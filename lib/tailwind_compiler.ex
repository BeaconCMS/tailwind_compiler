defmodule TailwindCompiler do
  @moduledoc """
  A Tailwind CSS v4-compatible compiler written in Zig, callable from Elixir as a NIF.

  Accepts a list of CSS class candidate strings and returns minified production CSS.
  Everything happens in memory — no filesystem, no external processes, no CLI.

  ## Example

      iex> TailwindCompiler.compile(["flex", "p-4", "hover:bg-blue-500/50", "sm:text-lg"])
      {:ok, ".flex{display:flex}..."}

  """

  @doc """
  Compile a list of Tailwind CSS candidate strings into minified CSS.

  ## Options

    * `:theme` - JSON string with theme overrides (optional)
    * `:preflight` - whether to include the base CSS reset (default: `true`)

  ## Examples

      TailwindCompiler.compile(["flex", "p-4", "bg-red-500"])
      #=> {:ok, "@layer theme{...}@layer base{...}@layer utilities{.bg-red-500{...}.flex{...}.p-4{...}}..."}

      TailwindCompiler.compile(["text-lg"], theme: ~s({"spacing":"0.5rem"}))
      #=> {:ok, "..."}

      TailwindCompiler.compile(["flex"], preflight: false)
      #=> {:ok, "@layer utilities{.flex{display:flex}}"}

  """
  @spec compile([String.t()], keyword()) :: {:ok, String.t()} | {:error, term()}
  def compile(candidates, opts \\ []) when is_list(candidates) do
    theme_json = Keyword.get(opts, :theme)
    preflight = Keyword.get(opts, :preflight, true)

    case TailwindCompiler.NIF.compile(candidates, theme_json || "", preflight) do
      result when is_binary(result) -> {:ok, result}
      error -> {:error, error}
    end
  rescue
    e -> {:error, Exception.message(e)}
  end

  @doc """
  Same as `compile/2` but raises on error.
  """
  @spec compile!([String.t()], keyword()) :: String.t()
  def compile!(candidates, opts \\ []) do
    case compile(candidates, opts) do
      {:ok, css} -> css
      {:error, reason} -> raise "TailwindCompiler.compile!/2 failed: #{inspect(reason)}"
    end
  end
end
