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
  end

  describe "compile!/2" do
    test "returns CSS string directly" do
      css = TailwindCompiler.compile!(["flex"], preflight: false)
      assert is_binary(css)
      assert css =~ ".flex{display:flex}"
    end
  end
end
