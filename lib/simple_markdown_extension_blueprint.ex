defmodule SimpleMarkdownExtensionBlueprint do
    @moduledoc """
      Adds syntax for issuing a blueprint command and embedding
      the resulting SVG.

      The command takes the form of `@blueprint[]` or `@blueprint()`.
      Where inside the brackets are the arguments that can be
      passed to a `blueprint` escript.

      ## Example

        @blueprint[plot app --messages --colour]

      Which produces:

      @blueprint[plot app --messages --colour]
    """

    @doc """
      The rule for matching blueprint commands.
    """
    @spec rule() :: Parsey.rule
    def rule() do
        {
            :blueprint,
            %{
                match: ~r/\A[[:blank:]]*?@blueprint[\[\(](.*?)[\]\)]/,
                capture: 0,
                option: fn input, [_, { index, length }] ->
                    case String.split(binary_part(input, index, length), " ", strip: true) do
                        ["plot", graph|args] -> { Module.safe_concat(Mix.Tasks.Blueprint.Plot, String.to_atom(String.capitalize(graph))), :run, [args] }
                    end
                end,
                rules: []
            }
        }
    end

    @doc """
      Insert the blueprint command rule in a appropriate place
      in the rule parser.
    """
    @spec add_rule([Parsey.rule]) :: [Parsey.rule]
    def add_rule(rules), do: rules ++ [rule()]

    defimpl SimpleMarkdown.Renderer.HTML, for: SimpleMarkdown.Attribute.Blueprint do
        def render(%{ option: { module, fun, [args] } }) do
            name = ".simple_markdown_extension_blueprint.dot"

            :ok = apply(module, fun, [["-o", name|args]])
            { svg, 0 } = System.cmd("dot", ["-Tsvg", name])
            File.rm!(name)

            String.replace(svg, ~r/\A(.|\n)*?(?=<svg)/m, "", global: false)
            |> String.replace(~r/(?<=\A<svg )width=".*?" height=".*?"/, "width=\"100%\" height=\"100%\"", global: false)
            |> String.trim()
        end
    end
end
