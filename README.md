# vim-update
vim-update is update your running vim.  
(vim-update supports gvim.exe (win32 x64) only)

## Installation
Path to this plugin.  

e.g)
```bash
cd ~/.vim/pack/foo/opt
clone https://github.com/utubo/vim-update.git
```
```vimscript
packadd vim-update
```

## Usage
```vimscript
call vimupdate#Update()
```

You can define a command to vim-update.  
e.g)
```vimscript
command! VimUpdate packadd vim-update|call vimupdate#Update()
```

## License
[NYSL](http://www.kmonos.net/nysl/index.en.html)

