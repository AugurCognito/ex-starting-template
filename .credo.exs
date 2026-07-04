%{
  configs: [
    %{
      name: "default",
      strict: true,
      plugins: [{ExSlop, []}],
      files: %{
        included: ["lib/", "test/", "config/"],
        excluded: []
      }
    }
  ]
}
