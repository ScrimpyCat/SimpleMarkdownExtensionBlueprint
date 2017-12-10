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
end
