" This script is executed when the plugin is loaded.
" It defines the :GeminiCommitCheck command.

if exists('g:loaded_commit_check')
  finish
endif
let g:loaded_commit_check = 1

let s:plugin_root_dir = expand('<sfile>:p:h:h')
let g:commit_check_root_dir = s:plugin_root_dir

" Define the :GeminiCommitCheck command.
" This command will call the commit_check#check() function.
command! GeminiCommitCheck call commit_check#check()