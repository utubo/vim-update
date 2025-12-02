let s:plugin_dir = expand('<sfile>:p:h')->substitute('autoload$', '', '')
function! vimupdate#Update() abort
  if (!has('win32'))
    echoe 'vim-update supports only gvim.exe for Win32 x64'
    return
  endif
  let ps_script = s:plugin_dir .. '\bin\win32vimupdate.ps1'
  let check_result = system($'powershell.exe -NoProfile -ExecutionPolicy Bypass -File {ps_script} -CurrentVersionLong {v:versionlong} -VimRuntime {shellescape($VIMRUNTIME)} -Checkonly')
  if check_result =~# 'Already up to date'
    echo check_result
    return
  endif
  let sess = tempname()
  execute 'mksession' sess
  call system($'start powershell.exe -NoProfile -ExecutionPolicy Bypass -File {ps_script} -currentVersionLong {v:versionlong} -VimRuntime {shellescape($VIMRUNTIME)} -SessionFile {shellescape(sess)}')
endfunction

