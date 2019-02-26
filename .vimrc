syntax enable
set background=dark
colorscheme gruvbox 

" tap into system clipboard
:set clipboard=unnamed


augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter *  set nu rnu
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * set nu nornu
augroup END
