defmodule SimpleMarkdownExtensionBlueprint do
    @moduledoc """
      Adds syntax for issuing a blueprint command and embedding
      the resulting SVG.

      The command takes the form of `@blueprint[]` or `@blueprint()`.
      Where inside the brackets are the arguments that can be
      passed to a `blueprint` escript. The `@blueprint` prefix may
      optionally be followed by options separated by a `-` to
      customize how it should be added to the page.

      These options are:

      * Overriding the width of the element that comes after it,
      by providing a `w` before the literal to be used for the
      width (where no literal means it will use the default
      pixel width). e.g. If it comes before the `[]` it will
      affect the width of the SVG element, whereas if it comes
      before an `embed` option it will affect the width of the
      container.
      * Overriding the height of the element that comes after it,
      by providing a `h` before the literal to be used for the
      height (where no literal means it will use the default
      pixel height). e.g. If it comes before the `[]` it will
      affect the height of the SVG element, whereas if it comes
      before an `embed` option it will affect the height of the
      container.
      * Place the SVG in a scrollable container, by providing
      the `embed` option.

      ## Example

        @blueprint[plot app --messages --colour]

      Which produces:

      @blueprint[plot app --messages --colour]

      ## Fixed size example

        @blueprint-w300px-h50px[plot app --messages --colour]

      Which produces:

      @blueprint-w300px-h50px[plot app --messages --colour]

      ## Relative size example

        @blueprint-w50%-h50%[plot app --messages --colour]

      Which produces:

      @blueprint-w50%-h50%[plot app --messages --colour]

      ## Embed example

        @blueprint-embed[plot app --messages --colour]

      Which produces:

      @blueprint-embed[plot app --messages --colour]

      ## Fixed size embed with relative size example

        @blueprint-w100px-h50px-embed-w500%-h500%[plot app --messages --colour]

      Which produces:

      @blueprint-w300px-h150px-embed-w1000%-h1000%[plot app --messages --colour]
    """

    defstruct [command: nil, width: "100%", height: "100%", embed: false, embed_width: "100%", embed_height: "100%"]

    @doc """
      The rule for matching blueprint commands.
    """
    @spec rule() :: Parsey.rule
    def rule() do
        {
            :blueprint,
            %{
                match: ~r/\A[[:blank:]]*?@blueprint(-[^\[\(]+)*?[\[\(](.*?)[\]\)]/,
                capture: 0,
                option: fn input, [_, { attr_index, attr_length }, { index, length }] ->
                    opt = case String.split(binary_part(input, index, length), " ", trim: true) do
                        ["plot", graph|args] -> %SimpleMarkdownExtensionBlueprint{ command: { Module.safe_concat(Mix.Tasks.Blueprint.Plot, String.to_atom(String.capitalize(graph))), :run, [args] } }
                    end

                    if(attr_index > 0, do: String.split(binary_part(input, attr_index, attr_length), "-", trim: true), else: [])
                    |> Enum.reduce(opt, fn
                        "w" <> width, opt -> %{ opt | width: width }
                        "h" <> height, opt -> %{ opt | height: height }
                        "embed", opt -> %SimpleMarkdownExtensionBlueprint{ command: opt.command, embed: true, embed_width: opt.width, embed_height: opt.height }
                    end)
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
        def render(%{ option: opts = %SimpleMarkdownExtensionBlueprint{ command: { module, fun, [args] } } }) do
            name = ".simple_markdown_extension_blueprint.dot"

            :ok = apply(module, fun, [["-o", name|args]])
            { svg, 0 } = System.cmd("dot", ["-Tsvg", name])
            File.rm!(name)

            String.replace(svg, ~r/\A(.|\n)*?(?=<svg)/m, "", global: false)
            |> String.trim()
            |> set_attribute("width", opts.width)
            |> set_attribute("height", opts.height)
            |> set_view(opts.embed, opts.embed_width, opts.embed_height)
        end

        defp set_attribute(svg, _, ""), do: svg
        defp set_attribute(svg, attr, value), do: String.replace(svg, ~r/\A(.*?)#{attr}=".*?"/, "\\1#{attr}=\"#{value}\"", global: false)

        defp set_view(svg, false, width, height), do: svg
        defp set_view(svg, true, width, height), do: "<iframe srcdoc='#{svg}' width='#{width}' height='#{height}'></iframe>"
    end
end
