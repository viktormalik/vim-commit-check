# Vim Commit Check plugin

Vim Commit Check is a Vim plugin that uses the Gemini CLI to review your Git
commit messages.

## Requirements

*   Vim 8.0 or later.
*   [Google Gemini CLI](https://cloud.google.com/gemini/docs/codeassist/gemini-cli) installed and configured on your system.
*   [Google Gemini API key](https://ai.google.dev/gemini-api/docs/api-key) configured on your system.

## Usage

The plugin can be used by running the command `:GeminiCommitCheck` while writing
a commit message using Vim. A new vertical split will open with feedback on your
commit message from the Gemini CLI. 

## Configuration

You can customize the instructions sent to Gemini by editing the
`prompts/default.txt` file within the plugin's directory.

## License

This project is licensed under the Apache 2.0 License. See the
[LICENSE](LICENSE) file for details.
