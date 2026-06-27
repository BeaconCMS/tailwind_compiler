defmodule TailwindCompiler.Candidates do
  @moduledoc """
  Extracts Tailwind candidate tokens from source text.

  Tailwind source detection treats files as plain text and looks for tokens
  that could be class names. This module follows that model: it intentionally
  over-collects candidate-like tokens and leaves final utility validation to the
  compiler.
  """

  import NimbleParsec

  @candidate_chars [
    ?a..?z,
    ?A..?Z,
    ?0..?9,
    ?_,
    ?-,
    ?:,
    ?/,
    ?.,
    ?%,
    ?#,
    ?[,
    ?],
    ?(,
    ?),
    ?{,
    ?},
    ?,,
    ?&,
    ?>,
    ?*,
    ?=,
    ?!,
    ?@,
    ??,
    ?$,
    ?+,
    ?~,
    ?|,
    ?',
    ?"
  ]

  @candidate_bytes Enum.flat_map(@candidate_chars, fn
                     first..last//_ -> Enum.to_list(first..last)
                     char -> [char]
                   end)
  @skip_chars Enum.map(@candidate_chars, &{:not, &1})

  token = ascii_string(@candidate_chars, min: 1)
  skip = ignore(ascii_string(@skip_chars, min: 1))

  defparsecp(:parse_tokens, repeat(choice([token, skip])))

  @doc """
  Extracts unique candidate-like tokens from source text or iodata.
  """
  @spec extract(iodata()) :: [String.t()]
  def extract(source) when is_binary(source) or is_list(source) do
    source
    |> IO.iodata_to_binary()
    |> unique_candidates(MapSet.new())
    |> elem(0)
  end

  @doc """
  Lazily extracts unique candidate-like tokens from an enumerable of iodata chunks.

  This is intended for streams such as `IO.stream/2` and `File.stream!/3`. The
  implementation keeps a small trailing token carry so candidate strings split
  across chunk boundaries are still emitted as a single token.
  """
  @spec stream(Enumerable.t()) :: Enumerable.t()
  def stream(chunks) do
    chunks
    |> Stream.concat(["\n"])
    |> Stream.transform({MapSet.new(), ""}, fn chunk, {seen, carry} ->
      source = carry <> IO.iodata_to_binary(chunk)
      {parseable, next_carry} = split_carry(source)
      {tokens, seen} = unique_candidates(parseable, seen)

      {tokens, {seen, next_carry}}
    end)
  end

  defp parse(source) do
    case parse_tokens(source) do
      {:ok, tokens, "", _context, _line, _offset} ->
        tokens

      {:ok, tokens, rest, _context, _line, _offset} ->
        tokens ++ fallback_tokens(rest)

      {:error, _reason, rest, _context, _line, _offset} ->
        fallback_tokens(rest)
    end
  end

  defp fallback_tokens(source) do
    Regex.scan(~r/[A-Za-z0-9_\-:\/\.%#\[\]\(\)\{\},&>\*=!@\?\$\+~|'"]+/u, source)
    |> List.flatten()
  end

  defp unescape_string_boundaries(source) do
    source
    |> String.replace("\\\"", "\"")
    |> String.replace("\\'", "'")
  end

  defp split_carry(source) do
    size = byte_size(source)
    carry_start = carry_start(source, size)

    {
      binary_part(source, 0, carry_start),
      binary_part(source, carry_start, size - carry_start)
    }
  end

  defp carry_start(_source, 0), do: 0

  defp carry_start(source, index) do
    byte = :binary.at(source, index - 1)

    if candidate_byte?(byte) do
      carry_start(source, index - 1)
    else
      index
    end
  end

  defp candidate_byte?(byte), do: byte in @candidate_bytes

  defp unique_candidates("", seen), do: {[], seen}

  defp unique_candidates(source, seen) do
    source
    |> unescape_string_boundaries()
    |> parse()
    |> Enum.reduce({[], seen}, fn token, {tokens, seen} ->
      token = normalize(token)

      cond do
        reject?(token) ->
          {tokens, seen}

        MapSet.member?(seen, token) ->
          {tokens, seen}

        true ->
          {[token | tokens], MapSet.put(seen, token)}
      end
    end)
    |> then(fn {tokens, seen} -> {Enum.reverse(tokens), seen} end)
  end

  defp normalize(token) do
    token
    |> strip_code_prefix()
    |> trim_boundaries()
    |> strip_attr_prefix()
    |> trim_boundaries()
    |> strip_code_suffix()
    |> strip_html_suffix()
    |> String.trim_trailing(">")
    |> String.trim_trailing("/")
    |> String.trim_leading("=")
    |> String.trim_trailing("=")
    |> String.trim_trailing(".")
    |> String.trim_trailing(",")
    |> String.trim_trailing(";")
  end

  defp strip_attr_prefix(token) do
    case String.split(token, "=", parts: 2) do
      [attr, value] when attr in ["class", "className"] -> trim_attr_value(value)
      _other -> token
    end
  end

  defp strip_code_prefix(token) do
    token
    |> String.to_charlist()
    |> strip_code_prefix([], 0)
    |> List.to_string()
  end

  defp strip_code_prefix([], acc, _bracket_depth), do: Enum.reverse(acc)

  defp strip_code_prefix([?\\, quote | rest], acc, 0) when quote in [?\", ?', ?`] do
    if code_prefix?(acc) do
      rest
    else
      strip_code_prefix([quote | rest], [?\\ | acc], 0)
    end
  end

  defp strip_code_prefix([quote | rest], acc, 0) when quote in [?\", ?', ?`] do
    if code_prefix?(acc) do
      rest
    else
      strip_code_prefix(rest, [quote | acc], 0)
    end
  end

  defp strip_code_prefix([?[ | rest], acc, bracket_depth) do
    strip_code_prefix(rest, [?[ | acc], bracket_depth + 1)
  end

  defp strip_code_prefix([?] | rest], acc, bracket_depth) do
    strip_code_prefix(rest, [?] | acc], max(bracket_depth - 1, 0))
  end

  defp strip_code_prefix([char | rest], acc, bracket_depth) do
    strip_code_prefix(rest, [char | acc], bracket_depth)
  end

  defp code_prefix?(acc) do
    not Enum.any?(acc, &(&1 in [?\", ?', ?`])) and quote_opener?(acc)
  end

  defp quote_opener?([]), do: true
  defp quote_opener?([char | _acc]), do: char in [?=, ?{, ?(, ?[, ?,, ?:, ??]

  defp strip_code_suffix(token) do
    token
    |> String.to_charlist()
    |> strip_code_suffix([], 0)
    |> List.to_string()
  end

  defp strip_code_suffix([], acc, _bracket_depth), do: Enum.reverse(acc)

  defp strip_code_suffix([?\\, quote | _rest], acc, 0) when quote in [?\", ?', ?`] do
    Enum.reverse(acc)
  end

  defp strip_code_suffix([quote | _rest], acc, 0) when quote in [?\", ?', ?`] do
    Enum.reverse(acc)
  end

  defp strip_code_suffix([?[ | rest], acc, bracket_depth) do
    strip_code_suffix(rest, [?[ | acc], bracket_depth + 1)
  end

  defp strip_code_suffix([?] | rest], acc, bracket_depth) do
    strip_code_suffix(rest, [?] | acc], max(bracket_depth - 1, 0))
  end

  defp strip_code_suffix([char | rest], acc, bracket_depth) do
    strip_code_suffix(rest, [char | acc], bracket_depth)
  end

  defp strip_html_suffix(token) do
    token
    |> String.split(["\">", "'>"], parts: 2)
    |> hd()
  end

  defp trim_attr_value(value) do
    value
    |> trim_boundaries()
    |> String.split(["\"", "'", "`"], parts: 2)
    |> hd()
  end

  defp trim_boundaries(token) do
    Enum.reduce(["'", "\"", "`", "\\"], token, fn boundary, token ->
      token
      |> String.trim_leading(boundary)
      |> String.trim_trailing(boundary)
    end)
  end

  defp reject?(""), do: true
  defp reject?(token) when byte_size(token) > 512, do: true
  defp reject?(_token), do: false
end
