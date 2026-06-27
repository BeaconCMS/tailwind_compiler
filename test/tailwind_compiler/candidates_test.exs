defmodule TailwindCompiler.CandidatesTest do
  use ExUnit.Case, async: true

  test "extracts candidates from raw HTML" do
    source =
      ~s(<div class="flex p-4 hover:bg-blue-500/50 sm:text-lg w-[137px] [&>*]:p-2 before:content-['New']"></div>)

    candidates = TailwindCompiler.candidates(source)

    assert "flex" in candidates
    assert "p-4" in candidates
    assert "hover:bg-blue-500/50" in candidates
    assert "sm:text-lg" in candidates
    assert "w-[137px]" in candidates
    assert "[&>*]:p-2" in candidates
    assert "before:content-['New']" in candidates
  end

  test "extracts candidates from iodata" do
    source = [
      ~s(<section class="grid ),
      ["grid-cols-[1fr_auto]", ~s( gap-4">)],
      ~s(<a class="underline hover:text-blue-600">Link</a></section>)
    ]

    candidates = TailwindCompiler.candidates(source)

    assert "grid" in candidates
    assert "grid-cols-[1fr_auto]" in candidates
    assert "gap-4" in candidates
    assert "underline" in candidates
    assert "hover:text-blue-600" in candidates
  end

  test "extracts candidates from escaped template strings" do
    source =
      ~S'''
      return "<div class=\"grid grid-cols-[1fr_auto] hover:bg-blue-500/50\"></div>"
      '''

    candidates = TailwindCompiler.candidates(source)

    assert "grid" in candidates
    assert "grid-cols-[1fr_auto]" in candidates
    assert "hover:bg-blue-500/50" in candidates
  end

  test "trims TypeScript string suffixes while preserving arbitrary value quotes" do
    source =
      ~S'''
      const classes = cn(
        "[&_tr]:border-b",
        "[&>[role=checkbox]]:translate-y-[2px]",
        "*:[span]:last:gap-2",
        "[a&]:hover:bg-primary/90",
        { 4: "grid-cols-4", danger: "bg-orange-500" },
        readOnly ? "cursor-default" : "cursor-move",
        "before:content-['New']"
      );
      return <thead className={cn("[&_tr]:border-b", className)} />;
      <Column widthClass="w-1/3" />
      '''

    candidates = TailwindCompiler.candidates(source)

    assert "[&_tr]:border-b" in candidates
    assert "[&>[role=checkbox]]:translate-y-[2px]" in candidates
    assert "*:[span]:last:gap-2" in candidates
    assert "[a&]:hover:bg-primary/90" in candidates
    assert "grid-cols-4" in candidates
    assert "bg-orange-500" in candidates
    assert "cursor-move" in candidates
    assert "before:content-['New']" in candidates
    assert "w-1/3" in candidates
  end

  test "extracts arbitrary variants from multi-class TypeScript strings" do
    source =
      ~S'''
      className={cn(
        "text-foreground h-10 px-2 text-left align-middle font-medium whitespace-nowrap [&:has([role=checkbox])]:pr-0 [&>[role=checkbox]]:translate-y-[2px]",
        className,
      )}
      '''

    candidates = TailwindCompiler.candidates(source)

    assert "text-foreground" in candidates
    assert "[&:has([role=checkbox])]:pr-0" in candidates
    assert "[&>[role=checkbox]]:translate-y-[2px]" in candidates
  end

  test "returns a lazy stream for enumerable input" do
    test_process = self()

    source =
      Stream.map(
        [
          ~s(<div class="flex p-4"></div>),
          ~s(<div class="flex md:grid"></div>)
        ],
        fn chunk ->
          send(test_process, {:chunk_read, chunk})
          chunk
        end
      )

    candidates = TailwindCompiler.candidates(source)

    refute_received {:chunk_read, _chunk}
    assert Enum.to_list(candidates) == ["div", "flex", "p-4", "/div", "md:grid"]
    assert_received {:chunk_read, _chunk}
  end

  test "extracts candidates from IO streams" do
    path =
      Path.join(
        System.tmp_dir!(),
        "tailwind_compiler_candidates_#{System.unique_integer([:positive])}.html"
      )

    File.write!(path, """
    <main class="mx-auto max-w-4xl">
      <article class="prose hover:prose-a:text-blue-600"></article>
    </main>
    """)

    try do
      File.open!(path, [:read], fn io ->
        candidates =
          io
          |> IO.stream(:line)
          |> TailwindCompiler.candidates()
          |> Enum.to_list()

        assert "mx-auto" in candidates
        assert "max-w-4xl" in candidates
        assert "prose" in candidates
        assert "hover:prose-a:text-blue-600" in candidates
      end)
    after
      File.rm(path)
    end
  end

  test "keeps candidates intact across stream chunk boundaries" do
    source =
      [
        ~s(<div class="grid grid-cols),
        ~s(-[1fr_auto] hover:bg),
        ~s(-blue-500/50"></div>)
      ]
      |> Stream.map(& &1)

    candidates =
      source
      |> TailwindCompiler.candidates()
      |> Enum.to_list()

    assert "grid" in candidates
    assert "grid-cols-[1fr_auto]" in candidates
    assert "hover:bg-blue-500/50" in candidates
  end

  test "deduplicates candidates across stream chunks" do
    source =
      [
        ~s(<div class="flex p-4"></div>),
        ~s(<div class="flex p-4 md:flex"></div>)
      ]
      |> Stream.map(& &1)

    candidates =
      source
      |> TailwindCompiler.candidates()
      |> Enum.to_list()

    assert Enum.count(candidates, &(&1 == "flex")) == 1
    assert Enum.count(candidates, &(&1 == "p-4")) == 1
    assert "md:flex" in candidates
  end

  test "compiles source after extracting candidates" do
    source = ~s(<div class="flex p-4 hover:bg-blue-500/50"></div>)

    assert {:ok, css} = TailwindCompiler.compile_source(source, preflight: false)
    assert css =~ ".flex"
    assert css =~ ".p-4"
    assert css =~ "hover\\:bg-blue-500\\/50"
  end

  test "compiles candidate streams" do
    candidates =
      ["flex", "p-4", "hover:bg-blue-500/50"]
      |> Stream.map(& &1)

    assert {:ok, css} = TailwindCompiler.compile(candidates, preflight: false)
    assert css =~ ".flex"
    assert css =~ ".p-4"
    assert css =~ "hover\\:bg-blue-500\\/50"
  end

  test "compiles streamed source after extracting candidates" do
    source =
      [
        ~s(<div class="flex p),
        ~s(-4 hover:bg-blue-500/50"></div>)
      ]
      |> Stream.map(& &1)

    assert {:ok, css} = TailwindCompiler.compile_source(source, preflight: false)
    assert css =~ ".flex"
    assert css =~ ".p-4"
    assert css =~ "hover\\:bg-blue-500\\/50"
  end
end
