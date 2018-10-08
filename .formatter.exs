# Run `mix help format` to learn more about this awesomeness
[
  # Paths/globs for files which should be formatted
  inputs: [
    "mix.exs",
    "{config,lib,test,web}/**/*.{ex,exs}"
  ],
  # Break up lines that exceed our code_styles standard
  line_length: 80,
  # Automatically renames deprecated methods to the new method name in 1.6.1!
  rename_deprecated_at: "1.6.4"
]