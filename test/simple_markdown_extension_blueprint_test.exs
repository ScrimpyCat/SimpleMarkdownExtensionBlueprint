defmodule SimpleMarkdownExtensionBlueprintTest do
    use ExUnit.Case
    doctest SimpleMarkdownExtensionBlueprint

    test "matching blueprint command" do
        assert [{ :blueprint, ["@blueprint[plot app]"], %SimpleMarkdownExtensionBlueprint{ command: { Mix.Tasks.Blueprint.Plot.App, :run, [[]] } } }] == SimpleMarkdown.Parser.parse("@blueprint[plot app]", [SimpleMarkdownExtensionBlueprint.rule])
        assert [{ :blueprint, ["@blueprint[plot mod]"], %SimpleMarkdownExtensionBlueprint{ command: { Mix.Tasks.Blueprint.Plot.Mod, :run, [[]] } } }] == SimpleMarkdown.Parser.parse("@blueprint[plot mod]", [SimpleMarkdownExtensionBlueprint.rule])
        assert [{ :blueprint, ["@blueprint[plot fun]"], %SimpleMarkdownExtensionBlueprint{ command: { Mix.Tasks.Blueprint.Plot.Fun, :run, [[]] } } }] == SimpleMarkdown.Parser.parse("@blueprint[plot fun]", [SimpleMarkdownExtensionBlueprint.rule])
        assert [{ :blueprint, ["@blueprint[plot msg]"], %SimpleMarkdownExtensionBlueprint{ command: { Mix.Tasks.Blueprint.Plot.Msg, :run, [[]] } } }] == SimpleMarkdown.Parser.parse("@blueprint[plot msg]", [SimpleMarkdownExtensionBlueprint.rule])

        assert [{ :blueprint, ["@blueprint[plot app --colour --path test]"], %SimpleMarkdownExtensionBlueprint{ command: { Mix.Tasks.Blueprint.Plot.App, :run, [["--colour", "--path", "test"]] } } }] == SimpleMarkdown.Parser.parse("@blueprint[plot app --colour --path test]", [SimpleMarkdownExtensionBlueprint.rule])

        assert [{ :blueprint, ["@blueprint(plot app)"], %SimpleMarkdownExtensionBlueprint{ command: { Mix.Tasks.Blueprint.Plot.App, :run, [[]] } } }] == SimpleMarkdown.Parser.parse("@blueprint(plot app)", [SimpleMarkdownExtensionBlueprint.rule])
        assert [{ :blueprint, ["@blueprint(plot mod)"], %SimpleMarkdownExtensionBlueprint{ command: { Mix.Tasks.Blueprint.Plot.Mod, :run, [[]] } } }] == SimpleMarkdown.Parser.parse("@blueprint(plot mod)", [SimpleMarkdownExtensionBlueprint.rule])
        assert [{ :blueprint, ["@blueprint(plot fun)"], %SimpleMarkdownExtensionBlueprint{ command: { Mix.Tasks.Blueprint.Plot.Fun, :run, [[]] } } }] == SimpleMarkdown.Parser.parse("@blueprint(plot fun)", [SimpleMarkdownExtensionBlueprint.rule])
        assert [{ :blueprint, ["@blueprint(plot msg)"], %SimpleMarkdownExtensionBlueprint{ command: { Mix.Tasks.Blueprint.Plot.Msg, :run, [[]] } } }] == SimpleMarkdown.Parser.parse("@blueprint(plot msg)", [SimpleMarkdownExtensionBlueprint.rule])

        assert [{ :blueprint, ["@blueprint(plot app --colour --path test)"], %SimpleMarkdownExtensionBlueprint{ command: { Mix.Tasks.Blueprint.Plot.App, :run, [["--colour", "--path", "test"]] } } }] == SimpleMarkdown.Parser.parse("@blueprint(plot app --colour --path test)", [SimpleMarkdownExtensionBlueprint.rule])
    end

    test "invalid blueprint command" do
        assert_raise CaseClauseError, fn -> SimpleMarkdown.Parser.parse("@blueprint[]", [SimpleMarkdownExtensionBlueprint.rule]) end
        assert_raise CaseClauseError, fn -> SimpleMarkdown.Parser.parse("@blueprint[plot]", [SimpleMarkdownExtensionBlueprint.rule]) end
        assert_raise ArgumentError, fn -> SimpleMarkdown.Parser.parse("@blueprint[plot test]", [SimpleMarkdownExtensionBlueprint.rule]) end
    end

    test "matching blueprint command styling" do
        opt = %SimpleMarkdownExtensionBlueprint{ command: { Mix.Tasks.Blueprint.Plot.App, :run, [[]] } }

        assert [{ :blueprint, ["@blueprint-w[plot app]"], %{ opt | width: "" } }] == SimpleMarkdown.Parser.parse("@blueprint-w[plot app]", [SimpleMarkdownExtensionBlueprint.rule])
        assert [{ :blueprint, ["@blueprint-h[plot app]"], %{ opt | height: "" } }] == SimpleMarkdown.Parser.parse("@blueprint-h[plot app]", [SimpleMarkdownExtensionBlueprint.rule])

        assert [{ :blueprint, ["@blueprint-w1px[plot app]"], %{ opt | width: "1px" } }] == SimpleMarkdown.Parser.parse("@blueprint-w1px[plot app]", [SimpleMarkdownExtensionBlueprint.rule])
        assert [{ :blueprint, ["@blueprint-w[plot app]"], %{ opt | width: "" } }] == SimpleMarkdown.Parser.parse("@blueprint-w[plot app]", [SimpleMarkdownExtensionBlueprint.rule])
        assert [{ :blueprint, ["@blueprint-w50%[plot app]"], %{ opt | width: "50%" } }] == SimpleMarkdown.Parser.parse("@blueprint-w50%[plot app]", [SimpleMarkdownExtensionBlueprint.rule])
        assert [{ :blueprint, ["@blueprint-h1px[plot app]"], %{ opt | height: "1px" } }] == SimpleMarkdown.Parser.parse("@blueprint-h1px[plot app]", [SimpleMarkdownExtensionBlueprint.rule])
        assert [{ :blueprint, ["@blueprint-h[plot app]"], %{ opt | height: "" } }] == SimpleMarkdown.Parser.parse("@blueprint-h[plot app]", [SimpleMarkdownExtensionBlueprint.rule])
        assert [{ :blueprint, ["@blueprint-h50%[plot app]"], %{ opt | height: "50%" } }] == SimpleMarkdown.Parser.parse("@blueprint-h50%[plot app]", [SimpleMarkdownExtensionBlueprint.rule])

        assert [{ :blueprint, ["@blueprint-w1px-h2px[plot app]"], %{ opt | width: "1px", height: "2px" } }] == SimpleMarkdown.Parser.parse("@blueprint-w1px-h2px[plot app]", [SimpleMarkdownExtensionBlueprint.rule])

        assert [{ :blueprint, ["@blueprint-embed[plot app]"], %{ opt | embed: true } }] == SimpleMarkdown.Parser.parse("@blueprint-embed[plot app]", [SimpleMarkdownExtensionBlueprint.rule])

        assert [{ :blueprint, ["@blueprint-w1px-embed[plot app]"], %{ opt | embed: true, embed_width: "1px" } }] == SimpleMarkdown.Parser.parse("@blueprint-w1px-embed[plot app]", [SimpleMarkdownExtensionBlueprint.rule])
        assert [{ :blueprint, ["@blueprint-embed-w1px[plot app]"], %{ opt | embed: true, width: "1px" } }] == SimpleMarkdown.Parser.parse("@blueprint-embed-w1px[plot app]", [SimpleMarkdownExtensionBlueprint.rule])
        assert [{ :blueprint, ["@blueprint-w1px-embed-w2px[plot app]"], %{ opt | embed: true, embed_width: "1px", width: "2px" } }] == SimpleMarkdown.Parser.parse("@blueprint-w1px-embed-w2px[plot app]", [SimpleMarkdownExtensionBlueprint.rule])
        assert [{ :blueprint, ["@blueprint-h1px-embed[plot app]"], %{ opt | embed: true, embed_height: "1px" } }] == SimpleMarkdown.Parser.parse("@blueprint-h1px-embed[plot app]", [SimpleMarkdownExtensionBlueprint.rule])
        assert [{ :blueprint, ["@blueprint-embed-h1px[plot app]"], %{ opt | embed: true, height: "1px" } }] == SimpleMarkdown.Parser.parse("@blueprint-embed-h1px[plot app]", [SimpleMarkdownExtensionBlueprint.rule])
        assert [{ :blueprint, ["@blueprint-h1px-embed-h2px[plot app]"], %{ opt | embed: true, embed_height: "1px", height: "2px" } }] == SimpleMarkdown.Parser.parse("@blueprint-h1px-embed-h2px[plot app]", [SimpleMarkdownExtensionBlueprint.rule])

        assert [{ :blueprint, ["@blueprint-w1px-h2px[plot app]"], %{ opt | width: "1px", height: "2px" } }] == SimpleMarkdown.Parser.parse("@blueprint-w1px-h2px-embed-w3px-h4px[plot app]", [SimpleMarkdownExtensionBlueprint.rule])
    end
end
