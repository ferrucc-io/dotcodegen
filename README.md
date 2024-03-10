# Automatic test generation for monoliths

Never write a test from scratch again. Automatically generate tests for any file you open in your codebase.

Keep your team up to date with the latest best practices and conventions you adopt. Customize the templates to fit your team's needs.

We're using this tool to speed up writing tests for our monolith at [June](https://june.so). We open sourced it so you can use it too.

## Get started


1. Install our CLI by running:

```bash
brew tap ferrucc-io/dotcodegen https://github.com/ferrucc-io/dotcodegen
brew install dotcodegen
```

2. Initialise the `.codegen` directory in your codebase:

```bash
codegen init
```

3. Configure the templates to fit your team's needs. See the [configuration](./docs/configuration.md) section for more details.

4. Run the codegen command in your terminal:

```bash
codegen path/to/the/file/you/want/to/test --openai_key <your_openai_key>
```


5. That's it! You're ready to start generating tests for your codebase.


**Extra**:

This code becomes very powerful when you integrate it with your editor, so you can open a file and generate tests with a single command.

In order to do that you can add a task to your `tasks.json` file in the `.vscode` directory of your project:

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Generate test for the current file",
      "type": "shell",
      // Alternatively you can specify the OPENAI_KEY environment variable in your .env file
      "command": "codegen ${relativeFile} --openai_key your_openai_key",
      "group": "test",
      "problemMatcher": [],
      "options": {
          "cwd": "${workspaceFolder}"
      },
    }
  ]
}
```

We're currently building a VSCode extension to be able to generate tests directly from your editor. Stay tuned!

## How it works

The extension uses AI to generate tests for any file you open in your codebase. It uses a set of customizable templates to generate the tests. You can customize the templates to fit your team's needs.

## Features

- **Easy to learn**: Get started in minutes.
- **AI powered scaffolding**: Generate smart tests for any file you open in your codebase.
- **Fully customisable**: Customize the templates to fit your team's needs.
- **Bring your own API key**: Use your own OpenAI API key to generate the tests.
- **🚧 Integrates with VSCode**: Use the extension to generate tests directly from your editor.

## Contributing

If you want to add some default templates for your language, feel free to open a PR. See the [config/default](./config/default) directory for the ones we have already.

Bug reports and pull requests are welcome on GitHub at https://github.com/ferrucc-io/dotcodegen.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
