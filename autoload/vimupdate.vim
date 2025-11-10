let s:plugin_dir = expand('<sfile>:p:h')->substitute('autoload$', '', '')
function! vimupdate#Update() abort
  if (!has('win32'))
    echoe 'vim-update supports only gvim.exe for Win32 x64'
    return
  endif
  let ps_script = s:plugin_dir .. '\bin\win32vimupdate.ps1'
  echo system($'powershell.exe -NoProfile -ExecutionPolicy Bypass -File {ps_script} -currentVersionLong {v:versionlong} -VimRuntime {shellescape($VIMRUNTIME)}')
endfunction

