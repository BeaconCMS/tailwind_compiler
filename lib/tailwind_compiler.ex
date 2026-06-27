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
  Extract Tailwind candidate strings from source text.

  This accepts raw HTML, templates, JavaScript/Elixir/Lua string literals, or
  any other source-like text. It intentionally over-collects candidate-like
  tokens; use `validate/1` or `compile/2` to let the compiler decide which
  tokens are real utilities.

  When passed a binary or iodata, this returns a list. When passed an enumerable
  such as `IO.stream/2` or `File.stream!/3`, this returns a lazy stream of
  unique candidate strings.

  ## Examples

      TailwindCompiler.candidates(~s(<div class="flex p-4"></div>))
      #=> ["div", "flex", "p-4", "/div"]

      File.stream!("index.html", [], :line)
      |> TailwindCompiler.candidates()
      |> Enum.to_list()

  """
  @spec candidates(iodata()) :: [String.t()]
  @spec candidates(Enumerable.t()) :: Enumerable.t()
  def candidates(source) when is_binary(source) or is_list(source) do
    TailwindCompiler.Candidates.extract(source)
  end

  def candidates(source) do
    if Enumerable.impl_for(source) do
      TailwindCompiler.Candidates.stream(source)
    else
      raise ArgumentError, "expected source to be iodata or an enumerable of iodata chunks"
    end
  end

  @doc """
  Extract candidates from source text and compile them into CSS.

  This is a convenience wrapper around `candidates/1` and `compile/2`.
  """
  @spec compile_source(iodata() | Enumerable.t(), keyword()) ::
          {:ok, String.t()} | {:error, term()}
  def compile_source(source, opts \\ []) do
    source
    |> candidates()
    |> compile(opts)
  end

  @doc """
  Same as `compile_source/2` but raises on error.
  """
  @spec compile_source!(iodata() | Enumerable.t(), keyword()) :: String.t()
  def compile_source!(source, opts \\ []) do
    case compile_source(source, opts) do
      {:ok, css} -> css
      {:error, reason} -> raise "TailwindCompiler.compile_source!/2 failed: #{inspect(reason)}"
    end
  end

  @doc """
  Compile a list of Tailwind CSS candidate strings into minified CSS.

  ## Options

    * `:theme` - JSON string with theme overrides (optional)
    * `:preflight` - whether to include the base CSS reset (default: `true`)
    * `:minify` - whether to minify the CSS output (default: `true`).
      When `false`, the output is pretty-printed with indentation.
    * `:custom_css` - raw CSS string to append after `@layer utilities` (optional).
      Use this for custom components or user stylesheets.
    * `:custom_utilities` - map of `%{"class-name" => "css-declarations"}` (optional).
      These get full selector escaping, variant support, and deduplication like built-in
      utilities. Example: `%{"btn-primary" => "background:blue;color:white"}`
    * `:plugin_css` - CSS output from a Tailwind plugin (optional).
      The compiler parses color variable definitions (`--color-*`) from `:root` and
      `[data-theme]` blocks and registers them as theme colors so that utilities like
      `bg-primary`, `text-secondary`, etc. are generated. All plugin CSS (component
      classes, theme blocks) is included in the output.

  ## Examples

      TailwindCompiler.compile(["flex", "p-4", "bg-red-500"])
      #=> {:ok, "@layer theme{...}@layer base{...}@layer utilities{.bg-red-500{...}.flex{...}.p-4{...}}..."}

      TailwindCompiler.compile(["text-lg"], theme: ~s({"spacing":"0.5rem"}))
      #=> {:ok, "..."}

      TailwindCompiler.compile(["flex"], preflight: false)
      #=> {:ok, "@layer utilities{.flex{display:flex}}"}

      TailwindCompiler.compile(["flex"], custom_css: ".custom{color:red}", preflight: false)
      #=> {:ok, "@layer utilities{.flex{display:flex}}.custom{color:red}"}

      TailwindCompiler.compile(["bg-primary"], plugin_css: daisy_css, preflight: false)
      #=> {:ok, "...bg-primary{background-color:var(--color-primary)}..."}

  """
  @spec compile([String.t()] | Enumerable.t(), keyword()) ::
          {:ok, String.t()} | {:error, term()}
  def compile(candidates, opts \\ [])

  def compile(candidates, opts) when is_list(candidates) do
    theme_json = Keyword.get(opts, :theme)
    preflight = Keyword.get(opts, :preflight, true)
    minify = Keyword.get(opts, :minify, true)
    custom_css = Keyword.get(opts, :custom_css)
    custom_utilities = Keyword.get(opts, :custom_utilities)
    plugin_css = Keyword.get(opts, :plugin_css)

    custom_utilities_json =
      case custom_utilities do
        nil -> ""
        map when is_map(map) -> Jason.encode!(map)
        str when is_binary(str) -> str
      end

    case TailwindCompiler.NIF.compile(
           candidates,
           theme_json || "",
           preflight,
           minify,
           custom_css || "",
           custom_utilities_json,
           plugin_css || ""
         ) do
      result when is_binary(result) -> {:ok, result}
      error -> {:error, error}
    end
  rescue
    e -> {:error, Exception.message(e)}
  end

  def compile(candidates, opts) do
    if Enumerable.impl_for(candidates) do
      candidates
      |> Enum.to_list()
      |> compile(opts)
    else
      {:error, "expected candidates to be a list or enumerable of strings"}
    end
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

  @doc """
  Validate a list of token strings, returning only those recognized as valid
  Tailwind CSS utilities.

  This is a fast check — it parses each token against the utility registry
  without generating CSS. Used for compile-time safelist extraction from
  host app source files.

  ## Examples

      TailwindCompiler.validate(["flex", "not-a-class", "hover:bg-blue-50", "hello"])
      #=> ["flex", "hover:bg-blue-50"]

  """
  @spec validate([String.t()]) :: [String.t()]
  def validate(tokens) when is_list(tokens) do
    case TailwindCompiler.NIF.validate(tokens) do
      "" -> []
      result when is_binary(result) -> String.split(result, "\n")
    end
  rescue
    e -> raise "TailwindCompiler.validate/1 failed: #{Exception.message(e)}"
  end
end
