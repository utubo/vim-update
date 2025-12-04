let s:plugin_dir = expand('<sfile>:p:h')->substitute('autoload$', '', '')
function! vimupdate#Update() abort
  if (!has('win32'))
    echoe 'vim-update supports only gvim.exe for Win32 x64'
    return
  endif
  let cmd = [
        \ 'powershell.exe -NoProfile -ExecutionPolicy Bypass -File',
        \ $'{s:plugin_dir}\bin\win32vimupdate.ps1',
        \ $'-CurrentVersionLong {v:versionlong}',
        \ $'-VimRuntime {shellescape($VIMRUNTIME)}'
        \ ]->join(' ')
  let check_result = system($'{cmd} -Checkonly')->trim()
  if check_result =~# 'Already up to date'
    echo check_result
    return
  endif
  let sess = tempname()
  execute 'mksession' sess
  call system($'start {cmd} -SessionFile {shellescape(sess)}')
endfunction

