defmodule SimpleMarkdownExtensionBlueprint.Mixfile do
    use Mix.Project

    def project do
        [
            app: :simple_markdown_extension_blueprint,
            description: "An extension for SimpleMarkdown to introduce some markup to create and embed a blueprint graph.",
            version: "0.1.0",
            elixir: "~> 1.5",
            start_permanent: Mix.env == :prod,
            deps: deps(),
            package: package()
        ]
    end

    # Run "mix help compile.app" to learn about applications.
    def application do
        [extra_applications: [:logger]]
    end

    # Run "mix help deps" to learn about dependencies.
    defp deps do
        [
            { :simple_markdown, "~> 0.3" },
            { :blueprint, "~> 0.2" },
            { :ex_doc, "~> 0.18", only: :dev }
        ]
    end

    defp package do
        [
            maintainers: ["Stefan Johnson"],
            licenses: ["BSD 2-Clause"],
            links: %{ "GitHub" => "https://github.com/ScrimpyCat/SimpleMarkdownExtensionBlueprint" }
        ]
    end
end
