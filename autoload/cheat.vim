" =============================================================================
" File: cheat.vim
" Description: Vim integration for cheat
" Mantainer: Chris Allen Lane (https://chris-allen-lane.com)
" Url: https://github.com/cheat/vim-cheat
" License: MIT
" Version: 1.0.0
" Last Changed: September 03, 2020
" =============================================================================

let s:cpo_save = &cpo
set cpo&vim


" read all cheatsheets
"{{{
function! cheat#read_all()
  " ensure that the plugin is properly configured
  if s:configured() == 0
    return
  endif

  call s:read(s:options('cheat_bin') . ' -l')
endfunction
"}}}


" read cheatsheets that are tagged with the current filetype
"{{{
function! cheat#read_ft()
  " ensure that the plugin is properly configured
  if s:configured() == 0
    return
  endif

  " ensure that the filetype is set
  if s:filetype() == 0
    return
  endif

  call s:read(s:options('cheat_bin') . ' -l -t' . &filetype)
endfunction
"}}}


" read cheatsheets, filtering by filetype only if &filetype is set
"{{{
function! cheat#read_smart()
  " ensure that the plugin is properly configured
  if s:configured() == 0
    return
  endif

  " display all cheatsheets only if filetype is unknown
  if &filetype == ""
    call s:read(s:options('cheat_bin') . ' -l')
  else
    call s:read(s:options('cheat_bin') . ' -l -t' . &filetype)
  endif
endfunction
"}}}


" edit any cheatsheet
"{{{
function! cheat#edit_all()
  " ensure that the plugin is properly configured
  if s:configured() == 0
    return
  endif

  call s:edit(s:options('cheat_bin') . ' -l')
endfunction
"}}}


" edit a cheatsheet that is tagged with the current filetype
"{{{
function! cheat#edit_ft(...)
  " ensure that the plugin is properly configured
  if s:configured() == 0
    return
  endif

  " ensure that the filetype is set
  if s:filetype() == 0
    return
  endif

  call s:edit(s:options('cheat_bin') . ' -l -t ' . &filetype)
endfunction
"}}}


" edit cheatsheets, filtering by filetype only if &filetype is set
"{{{
function! cheat#edit_smart()
  " ensure that the plugin is properly configured
  if s:configured() == 0
    return
  endif

  " display all cheatsheets only if filetype is unknown
  if &filetype == ""
    call s:edit(s:options('cheat_bin') . ' -l')
  else
    call s:edit(s:options('cheat_bin') . ' -l -t ' . &filetype)
  endif
endfunction
"}}}


" show cheat directories
"{{{
function! cheat#dirs()
  " ensure that the plugin is properly configured
  if s:configured() == 0
    return
  endif

  execute "!" s:options('cheat_bin') "-d"
endfunction
"}}}


" show cheat tags
"{{{
function! cheat#tags()
  " ensure that the plugin is properly configured
  if s:configured() == 0
    return
  endif

  execute "!" s:options('cheat_bin') "-T"
endfunction
"}}}


" show cheat version
"{{{
function! cheat#version()
  " ensure that the plugin is properly configured
  if s:configured() == 0
    return
  endif

  execute "!" s:options('cheat_bin') "-v"
endfunction
"}}}


" helper: edit a cheatsheet
"{{{
function! s:edit(fzf_source)
  call fzf#run(fzf#wrap({
        \ 'source'  : a:fzf_source,
        \ 'sink'    : function('s:open'),
        \ 'options' : s:options('fzf_options'),
        \ }))
endfunction
"}}}


" helper: load specified cheatsheets into fzf
"{{{
function! s:read(fzf_source)
  " invoke fzf
  call fzf#run(fzf#wrap({
        \ 'source'  : a:fzf_source,
        \ 'sink'    : function('s:get'),
        \ 'options' : s:options('fzf_options'),
        \}))
endfunction
"}}}


" helper: get cheatsheet content
"{{{
function! s:get(sheet)
  let text = system(s:options('cheat_bin') . " " . split(a:sheet)[0])
  call s:paste(text)
endfunction
"}}}


" helper: open cheatsheet for editing
"{{{
function! s:open(sheet)
  execute 'edit' split(a:sheet)[1]
endfunction
"}}}


" helper: return options
"{{{
function! s:options(key)
  " get the cheat binary path
  let cheat_bin = get(g:, 'cheat_bin', 'cheat')

  " assemble the preview command
  let preview = printf('%s --colorize `echo {} | cut -f1 -d" "`', cheat_bin)
  let preview = get(g:, 'cheat_fzf_preview', preview)

  " assemble the default fzf options
  let fzf_def_opts = [
        \ '--header-lines',
        \ '1',
        \ '--tiebreak',
        \ 'begin',
        \ '--preview-window',
        \ 'right:40%',
        \ '--preview',
        \ preview,
        \]

  " create a dictionary of options
  let opts = {
        \ 'cheat_bin'   : cheat_bin,
        \ 'fzf_options' : get(g:, 'cheat_fzf_options', fzf_def_opts),
        \}

  " return the requested options
  return opts[a:key]
endfunction
"}}}


" helper: ensure that the plugin has been properly configured
"{{{
function! s:configured()
  " ensure that `cheat` is available on the `$PATH`
  if executable(s:options('cheat_bin')) == 0
    call s:fail('could not locate cheat executable on $PATH')
    return 0
  endif

  " ensure that the fzf plugin has been installed
  if !exists("*fzf#run")
    call s:fail('could not locate fzf.vim')
    return 0
  endif

  " if we make it here, we're properly configured
  return 1
endfunction
"}}}


" helper: fail if &filetype is not set
"{{{
function! s:filetype()
  if &filetype == ""
    call s:fail('filetype is unset')
    return 0
  endif

  return 1
endfunction
"}}}


" helper: paste text into the buffer
"{{{
function! s:paste(text)
  " paste the text
  silent put = a:text

  " indent the pasted text and return the cursor to its original location
  norm! ='[

  " delete the unwanted newline inserted before the paste
  norm! kdd
endfunction
"}}}


" helper: display an error message
"{{{
function! s:fail(...)
  echoerr 'vim-cheat:' join(a:000)
endfunction
"}}}


let &cpo = s:cpo_save
unlet s:cpo_save
