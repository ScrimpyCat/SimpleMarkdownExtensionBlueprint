defmodule SimpleMarkdownExtensionBlueprint do
    def rule() do
        {
            :blueprint,
            %{
                match: ~r/\A@blueprint[\[\(](.*?)[\]\)]/,
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

    def add_rule(rules), do: [rule()|rules]
end
