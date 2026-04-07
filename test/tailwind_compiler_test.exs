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
  end

  describe "compile!/2" do
    test "returns CSS string directly" do
      css = TailwindCompiler.compile!(["flex"], preflight: false)
      assert is_binary(css)
      assert css =~ ".flex{display:flex}"
    end
  end
end
