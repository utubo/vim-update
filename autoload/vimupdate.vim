let s:plugin_dir = expand('<sfile>:p:h')->substitute('autoload$', '', '')
function! vimupdate#Update() abort
  if (!has('win32'))
    echoe 'vim-update supports only gvim.exe for Win32 x64'
    return
  endif
  let powershell = executable('pwsh.exe') ? 'pwsh.exe' : 'powershell.exe'
  let cmd = [
        \ $'{powershell} -NoProfile -ExecutionPolicy Bypass -File',
        \ $'{s:plugin_dir}\bin\win32vimupdate.ps1',
        \ $'-CurrentVersionLong {v:versionlong}',
        \ $'-VimRuntime {shellescape($VIMRUNTIME)}'
        \ ]->join(' ')
  let check_result = system($'{cmd} -Checkonly')->trim()
  echo check_result
  if check_result =~# 'Already up to date'
    return
  endif
  echo 'confirm qall'
  let sess = tempname()
  execute 'mksession' sess
  call system($'start {cmd} -SessionFile {shellescape(sess)}')
  confirm qa
endfunction

