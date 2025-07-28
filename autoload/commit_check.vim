"
" This is the main function of the plugin. It gets the commit message,
" the staged changes, and sends them to the Gemini CLI for review.
function! commit_check#check() abort
  " Get the entire content of the current buffer (the commit message).
  let commit_message = getline(1, '$')

  " Get the staged changes.
  let git_diff = system('git diff --staged')

  " Path to the prompt file.
  let prompt_path = g:commit_check_root_dir . '/prompts/default.txt'

  " Read the prompt file.
  let prompt = readfile(prompt_path)

  " Combine the prompt, commit message, and diff into a single string.
  let full_prompt = join(prompt, "\n") . "\n\n" .
        \ "--- COMMIT MESSAGE ---\n" .
        \ join(commit_message, "\n") . "\n\n" .
        \ "--- GIT DIFF ---\n" .
        \ git_diff

  " Construct the command to send to the Gemini CLI.
  let command = printf('echo %s | gemini', shellescape(full_prompt))

  " Execute the command and get the output.
  let result = system(command)

  " Open a new vertical split and display the result.
  vnew
  setlocal buftype=nofile bufhidden=wipe noswapfile
  call setline(1, split(result, "\n"))
endfunction