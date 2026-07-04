import Config

if Mix.env() == :dev do
  config :git_ops,
    mix_project: App.MixProject,
    changelog_file: "CHANGELOG.md",
    repository_url: "https://github.com/AugurCognito/ex-starting-template",
    manage_mix_version?: true,
    version_tag_prefix: "v"
end
