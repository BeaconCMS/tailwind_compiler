defmodule TailwindCompiler.Native do
  @moduledoc false

  @version Mix.Project.config()[:version]
  @github_repo "beaconcms/tailwind_compiler"

  @doc """
  Determine whether to use a precompiled NIF.

  Returns `true` if a precompiled NIF is available (cached or downloaded).
  Returns `false` if `TAILWIND_COMPILER_PATH` is set, or if no precompiled
  NIF could be found, in which case Zigler compilation is used as fallback.
  """
  def use_precompiled? do
    not force_build?() and ensure_precompiled()
  end

  @doc """
  Whether to force building from source via Zigler.
  """
  def force_build? do
    System.get_env("TAILWIND_COMPILER_PATH") != nil
  end

  @doc """
  Returns the NIF path (without extension) for `:erlang.load_nif/2`.
  Uses `:code.priv_dir/1` so it works at runtime (including in releases).
  """
  def nif_path do
    priv =
      case :code.priv_dir(:tailwind_compiler) do
        {:error, _} -> build_priv_dir()
        path -> List.to_string(path)
      end

    Path.join([priv, "native", "Elixir.TailwindCompiler.NIF"])
  end

  @doc """
  The target triple for the current platform (e.g. "aarch64-macos").
  """
  def target do
    "#{arch()}-#{os()}"
  end

  # --- Private ---

  defp ensure_precompiled do
    so_path = nif_so_path()

    if File.exists?(so_path) do
      true
    else
      download()
    end
  end

  defp nif_so_path do
    Path.join(native_dir(), "Elixir.TailwindCompiler.NIF#{nif_ext()}")
  end

  defp nif_ext do
    case :os.type() do
      {:win32, _} -> ".dll"
      _ -> ".so"
    end
  end

  defp native_dir do
    Path.join(build_priv_dir(), "native")
  end

  defp build_priv_dir do
    Path.join([Mix.Project.build_path(), "lib", "tailwind_compiler", "priv"])
  end

  defp download do
    target_triple = target()

    if String.contains?(target_triple, "unknown") do
      log("Unsupported platform: #{target_triple}, skipping precompiled NIF download")
      false
    else
      url = download_url(target_triple)
      log("Downloading precompiled NIF for #{target_triple}...")

      dest = native_dir()
      File.mkdir_p!(dest)

      case download_and_extract(url, dest) do
        :ok ->
          if File.exists?(nif_so_path()) do
            log("Successfully installed precompiled NIF")
            true
          else
            log("Archive did not contain expected NIF file")
            false
          end

        {:error, reason} ->
          log("Could not download precompiled NIF: #{inspect(reason)}")
          log("Falling back to compiling from source...")
          false
      end
    end
  end

  defp download_url(target_triple) do
    "https://github.com/#{@github_repo}/releases/download/v#{@version}/tailwind_compiler-nif-#{target_triple}.tar.gz"
  end

  defp download_and_extract(url, dest) do
    {:ok, _} = Application.ensure_all_started(:inets)
    {:ok, _} = Application.ensure_all_started(:ssl)

    url = String.to_charlist(url)

    http_options = [ssl: ssl_opts()]
    options = [body_format: :binary]

    case :httpc.request(:get, {url, []}, http_options, options) do
      {:ok, {{_, 200, _}, _headers, body}} ->
        :erl_tar.extract({:binary, body}, [:compressed, {:cwd, String.to_charlist(dest)}])

      {:ok, {{_, status, _}, _headers, _body}} ->
        {:error, "HTTP #{status}"}

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp ssl_opts do
    cacerts =
      if System.otp_release() >= "25" do
        try do
          :public_key.cacerts_get()
        rescue
          _ -> nil
        end
      end

    if cacerts do
      [
        verify: :verify_peer,
        cacerts: cacerts,
        depth: 2,
        customize_hostname_check: [
          match_fun: :public_key.pkix_verify_hostname_match_fun(:https)
        ]
      ]
    else
      [verify: :verify_none]
    end
  end

  defp arch do
    arch_str = :erlang.system_info(:system_architecture) |> List.to_string()

    cond do
      String.starts_with?(arch_str, "aarch64") -> "aarch64"
      String.starts_with?(arch_str, "arm") -> "aarch64"
      String.contains?(arch_str, "x86_64") -> "x86_64"
      String.contains?(arch_str, "amd64") -> "x86_64"
      true -> "unknown"
    end
  end

  defp os do
    case :os.type() do
      {:unix, :linux} -> "linux"
      {:unix, :darwin} -> "macos"
      {:win32, _} -> "windows"
      _ -> "unknown"
    end
  end

  defp log(message) do
    if function_exported?(Mix, :shell, 0) do
      Mix.shell().info(message)
    end
  end
end
