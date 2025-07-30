let s:job_output = []
let s:output_bufnr = -1

function! s:handle_output(channel, data)
  call add(s:job_output, a:data)
endfunction

function! s:handle_exit(job, exit_code)
  if bufexists(s:output_bufnr) && bufwinid(s:output_bufnr) != -1
    if a:exit_code == 0
      call setbufline(s:output_bufnr, 1, s:job_output)
    else
      let error_message = ["Error: Gemini CLI exited with code " . a:exit_code]
      call extend(error_message, s:job_output)
      call setbufline(s:output_bufnr, 1, error_message)
    endif
  endif

  let s:job_output = []
  let s:output_bufnr = -1
endfunction

function! commit_check#check() abort
  if !executable('gemini')
    echohl ErrorMsg
    echo "Error: 'gemini' command not found in your PATH."
    echohl None
    return
  endif

  let prompt_path = g:commit_check_root_dir . '/prompts/default.txt'
  let prompt = readfile(prompt_path)

  let commit_message = getline(1, '$')
  let full_prompt = join(prompt, "\n") . "\n\n" .
        \ "--- COMMIT MESSAGE ---\n" .
        \ join(commit_message, "\n")

  let separator_line_index = match(commit_message, '^# ------------------------ >8 ------------------------$')
  if separator_line_index == -1
    let git_diff = system('git diff --staged')
    let full_prompt = full_prompt . "\n\n" .
          \ "--- GIT DIFF ---\n" . git_diff
  endif

  vnew
  let s:output_bufnr = bufnr('%')
  setlocal buftype=nofile bufhidden=wipe noswapfile
  call setline(1, "Waiting for Gemini to review your commit...")

  let s:job_output = []

  let job_options = {
  \   'in_io': 'pipe',
  \   'out_cb': function('s:handle_output'),
  \   'exit_cb': function('s:handle_exit'),
  \ }

  let gemini_path = exepath('gemini')
  let job = job_start([gemini_path], job_options)

  if job_status(job) == 'fail'
    call setbufline(s:output_bufnr, 1, "Error: Failed to start 'gemini' command.")
    return
  endif

  let channel = job_getchannel(job)
  call ch_sendraw(channel, full_prompt)
  call ch_close_in(channel)

  echom "Contacting Gemini..."
endfunction
