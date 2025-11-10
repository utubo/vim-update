let s:plugin_dir = expand('<sfile>:p:h')->substitute('autoload$', '', '')
function! vimupdate#Update() abort
  if (!has('win32'))
    echoe 'This plugin supports win32 only.'
    return
  endif
  let ps_script = s:plugin_dir .. '\bin\win32vimupdate.ps1'
  echo system($'powershell.exe -NoProfile -ExecutionPolicy Bypass -File {ps_script} -currentVersionLong {v:versionlong} -VimRuntime {shellescape($VIMRUNTIME)}')
endfunction

