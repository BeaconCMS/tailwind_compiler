defmodule TailwindCompilerTest do
  use ExUnit.Case, async: true

  describe "compile/2" do
    test "compiles basic static utilities" do
      {:ok, css} = TailwindCompiler.compile(["flex", "block", "hidden"])
      assert css =~ ".flex{display:flex}"
      assert css =~ ".block{display:block}"
      assert css =~ ".hidden{display:none}"
    end

    test "compiles spacing utilities" do
      {:ok, css} = TailwindCompiler.compile(["p-4", "m-2", "gap-4"])
      assert css =~ "padding:calc(var(--spacing) * 4)"
      assert css =~ "margin:calc(var(--spacing) * 2)"
    end

    test "compiles color utilities with opacity" do
      {:ok, css} = TailwindCompiler.compile(["bg-red-500", "bg-blue-500/50"])
      assert css =~ "background-color:var(--color-red-500)"
      assert css =~ "background-color:#"
    end

    test "compiles with variants" do
      {:ok, css} = TailwindCompiler.compile(["hover:underline", "dark:bg-black", "sm:grid"])
      assert css =~ "@media (hover:hover)"
      assert css =~ "@media (prefers-color-scheme:dark)"
      assert css =~ "@media (width>=40rem)"
    end

    test "includes preflight by default" do
      {:ok, css} = TailwindCompiler.compile(["flex"])
      assert css =~ "@layer base{"
    end

    test "excludes preflight when option is false" do
      {:ok, css} = TailwindCompiler.compile(["flex"], preflight: false)
      refute css =~ "@layer base{"
    end

    test "accepts theme overrides" do
      {:ok, css} = TailwindCompiler.compile(["p-4"], theme: ~s({"spacing":"0.5rem"}), preflight: false)
      assert css =~ "--spacing:0.5rem"
    end

    test "handles empty candidate list" do
      {:ok, css} = TailwindCompiler.compile([], preflight: false)
      assert css == "" or css =~ "@layer"
    end

    test "handles arbitrary values" do
      {:ok, css} = TailwindCompiler.compile(["bg-[#0088cc]", "[color:red]"], preflight: false)
      assert css =~ "background-color:#0088cc"
      assert css =~ "color:red"
    end

    test "arbitrary variant with underscore produces descendant combinator" do
      {:ok, css} = TailwindCompiler.compile(["[&_p]:mb-4"], preflight: false)
      # The CSS should contain a descendant combinator (space), not a literal underscore
      assert css =~ " p{"
      refute css =~ "_p{"
    end

    test "handles important modifier" do
      {:ok, css} = TailwindCompiler.compile(["flex!"], preflight: false)
      assert css =~ "!important"
    end

    test "deduplicates candidates" do
      {:ok, css} = TailwindCompiler.compile(["flex", "flex", "flex"], preflight: false)
      count = css |> String.split(".flex{") |> length()
      assert count == 2  # split produces 2 parts for 1 occurrence
    end

    test "accepts custom CSS" do
      custom = ".custom-class{color:red}"
      {:ok, css} = TailwindCompiler.compile(["flex"], custom_css: custom, preflight: false)
      assert css =~ ".flex{display:flex}"
      assert css =~ ".custom-class{color:red}"
    end

    test "custom CSS is placed after utilities layer" do
      custom = ".plugin-btn{background:blue}"
      {:ok, css} = TailwindCompiler.compile(["flex"], custom_css: custom, preflight: false)
      utilities_pos = :binary.match(css, "@layer utilities{") |> elem(0)
      custom_pos = :binary.match(css, ".plugin-btn{") |> elem(0)
      assert custom_pos > utilities_pos
    end

    test "works without custom CSS (backward compatible)" do
      {:ok, css} = TailwindCompiler.compile(["flex"], preflight: false)
      assert css =~ ".flex{display:flex}"
    end

    test "accepts custom utilities as map" do
      {:ok, css} =
        TailwindCompiler.compile(
          ["flex", "btn-primary", "link-default"],
          preflight: false,
          custom_utilities: %{
            "btn-primary" => "background:blue;color:white;padding:0.5rem 1rem",
            "link-default" => "color:inherit;text-decoration:underline"
          }
        )

      assert css =~ ".flex{display:flex}"
      assert css =~ ".btn-primary{background:blue;color:white;padding:0.5rem 1rem}"
      assert css =~ ".link-default{color:inherit;text-decoration:underline}"
    end

    test "custom utilities support variants" do
      {:ok, css} =
        TailwindCompiler.compile(
          ["hover:btn-primary"],
          preflight: false,
          custom_utilities: %{"btn-primary" => "background:blue;color:white"}
        )

      assert css =~ "btn-primary"
      assert css =~ "background:blue"
      assert css =~ "@media (hover:hover)"
    end

    test "custom utilities get selector escaping" do
      {:ok, css} =
        TailwindCompiler.compile(
          ["my.class"],
          preflight: false,
          custom_utilities: %{"my.class" => "color:red"}
        )

      assert css =~ "my\\.class"
      assert css =~ "color:red"
    end

    test "@apply resolves utility classes in custom CSS" do
      custom = ".btn{@apply font-bold py-4 px-8 rounded-lg;}"

      {:ok, css} =
        TailwindCompiler.compile(["flex"],
          custom_css: custom,
          preflight: false
        )

      # @apply should be resolved to actual CSS declarations
      refute css =~ "@apply"
      assert css =~ "font-weight:var(--font-weight-bold)"
      assert css =~ "padding-block:calc(var(--spacing) * 4)"
      assert css =~ "padding-inline:calc(var(--spacing) * 8)"
      assert css =~ "border-radius:var(--radius-lg)"
    end

    test "@apply with static utilities only" do
      custom = ".card{@apply flex hidden;}"

      {:ok, css} =
        TailwindCompiler.compile(["flex"],
          custom_css: custom,
          preflight: false
        )

      refute css =~ "@apply"
      assert css =~ "display:flex;display:none"
    end

    test "@apply skips unknown classes" do
      custom = ".btn{@apply flex unknown-class hidden;}"

      {:ok, css} =
        TailwindCompiler.compile(["flex"],
          custom_css: custom,
          preflight: false
        )

      refute css =~ "@apply"
      assert css =~ "display:flex"
      assert css =~ "display:none"
    end

    test "theme() resolves color values in custom CSS" do
      custom = ".featured{--bg:theme(colors.blue.900);}"

      {:ok, css} =
        TailwindCompiler.compile(["flex"],
          custom_css: custom,
          preflight: false
        )

      refute css =~ "theme("
      assert css =~ "--bg:oklch("
    end

    test "theme() resolves spacing in custom CSS" do
      custom = ":root{--custom-spacing:theme(spacing);}"

      {:ok, css} =
        TailwindCompiler.compile(["flex"],
          custom_css: custom,
          preflight: false
        )

      refute css =~ "theme("
      assert css =~ "--custom-spacing:0.25rem"
    end

    test "theme() resolves borderRadius in custom CSS" do
      custom = ".card{border-radius:theme(borderRadius.lg);}"

      {:ok, css} =
        TailwindCompiler.compile(["flex"],
          custom_css: custom,
          preflight: false
        )

      refute css =~ "theme("
      assert css =~ "border-radius:0.5rem"
    end

    test "@apply and theme() combined in custom CSS" do
      custom = ".btn{@apply font-bold;color:theme(colors.red.500);}"

      {:ok, css} =
        TailwindCompiler.compile(["flex"],
          custom_css: custom,
          preflight: false
        )

      refute css =~ "@apply"
      refute css =~ "theme("
      assert css =~ "font-weight:var(--font-weight-bold)"
      assert css =~ "oklch(63.7%"
    end

    test "theme() keeps unresolved paths" do
      custom = ".x{color:theme(nonexistent.path);}"

      {:ok, css} =
        TailwindCompiler.compile(["flex"],
          custom_css: custom,
          preflight: false
        )

      assert css =~ "theme(nonexistent.path)"
    end

    test "custom CSS without @apply or theme() passes through unchanged" do
      custom = ".custom{color:red;font-size:16px}"

      {:ok, css} =
        TailwindCompiler.compile(["flex"],
          custom_css: custom,
          preflight: false
        )

      assert css =~ ".custom{color:red;font-size:16px}"
    end
  end

  describe "compile!/2" do
    test "returns CSS string directly" do
      css = TailwindCompiler.compile!(["flex"], preflight: false)
      assert is_binary(css)
      assert css =~ ".flex{display:flex}"
    end
  end

  describe "plugin_css option" do
    setup do
      plugin_css = File.read!(Path.join([__DIR__, "fixtures", "sample_plugin.css"]))
      %{plugin_css: plugin_css}
    end

    test "generates utility classes from plugin-defined colors", %{plugin_css: plugin_css} do
      {:ok, css} =
        TailwindCompiler.compile(
          ["bg-primary", "text-secondary", "bg-base-100"],
          plugin_css: plugin_css,
          preflight: false
        )

      # Plugin colors should be recognized and generate utility CSS
      assert css =~ "background-color:var(--color-primary)"
      assert css =~ "color:var(--color-secondary)"
      assert css =~ "background-color:var(--color-base-100)"
    end

    test "includes plugin component CSS in output", %{plugin_css: plugin_css} do
      {:ok, css} =
        TailwindCompiler.compile(
          ["flex"],
          plugin_css: plugin_css,
          preflight: false
        )

      # Plugin component classes should be included in output
      assert css =~ ".btn{"
      assert css =~ ".btn-primary{"
      assert css =~ ".alert{"
    end

    test "includes theme variable definitions from plugin", %{plugin_css: plugin_css} do
      {:ok, css} =
        TailwindCompiler.compile(
          ["bg-primary"],
          plugin_css: plugin_css,
          preflight: false
        )

      # The :root theme variables should be in the theme layer
      assert css =~ "--color-primary:"
    end

    test "includes data-theme blocks from plugin", %{plugin_css: plugin_css} do
      {:ok, css} =
        TailwindCompiler.compile(
          ["flex"],
          plugin_css: plugin_css,
          preflight: false
        )

      # data-theme blocks should be passed through
      assert css =~ "[data-theme=\"dark\"]"
    end

    test "plugin colors work with opacity modifiers", %{plugin_css: plugin_css} do
      {:ok, css} =
        TailwindCompiler.compile(
          ["bg-primary/50"],
          plugin_css: plugin_css,
          preflight: false
        )

      # Should resolve to a pre-resolved hex with alpha (e.g., #4d9aff80)
      # The utility selector should NOT use var(--color-primary) since opacity was applied
      assert css =~ ~r/\.bg-primary\\\/50\{background-color:#[0-9a-f]+\}/
    end

    test "plugin colors work with border utilities", %{plugin_css: plugin_css} do
      {:ok, css} =
        TailwindCompiler.compile(
          ["border-primary"],
          plugin_css: plugin_css,
          preflight: false
        )

      assert css =~ "border-color:var(--color-primary)"
    end

    test "works alongside existing theme overrides", %{plugin_css: plugin_css} do
      {:ok, css} =
        TailwindCompiler.compile(
          ["bg-primary", "bg-red-500"],
          plugin_css: plugin_css,
          preflight: false
        )

      # Both plugin colors and stock colors should work
      assert css =~ "background-color:var(--color-primary)"
      assert css =~ "background-color:var(--color-red-500)"
    end

    test "works with inline plugin CSS (not from file)" do
      inline_plugin_css = """
      :root {
        --color-brand: oklch(65% 0.2 260);
        --color-surface: #f5f5f5;
      }
      .card { border-radius: 0.5rem; padding: 1rem; }
      """

      {:ok, css} =
        TailwindCompiler.compile(
          ["bg-brand", "text-surface"],
          plugin_css: inline_plugin_css,
          preflight: false
        )

      assert css =~ "background-color:var(--color-brand)"
      assert css =~ "color:var(--color-surface)"
      assert css =~ ".card{"
    end

    test "backward compatible — works without plugin_css" do
      {:ok, css} = TailwindCompiler.compile(["flex"], preflight: false)
      assert css =~ ".flex{display:flex}"
    end

    test "plugin_css combined with custom_css" do
      plugin_css = ":root { --color-brand: #ff0000; }"
      custom_css = ".my-custom{color:blue}"

      {:ok, css} =
        TailwindCompiler.compile(
          ["bg-brand", "flex"],
          plugin_css: plugin_css,
          custom_css: custom_css,
          preflight: false
        )

      assert css =~ "background-color:var(--color-brand)"
      assert css =~ ".my-custom{color:blue}"
    end
  end
end
