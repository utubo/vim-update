# vim-update
vim-update updates your running vim.  
(vim-update supports only gvim.exe for Win32 x64)

## Installation
Path to this plugin:  

e.g.)
```bash
cd ~/.vim/pack/foo/opt
git clone https://github.com/utubo/vim-update.git
```
```vimscript
packadd vim-update
```

## Usage
```vimscript
call vimupdate#Update()
```

You can define a command for vim-update as follows:  
e.g.)
```vimscript
command! VimUpdate packadd vim-update|call vimupdate#Update()
```

## License
[NYSL](http://www.kmonos.net/nysl/index.en.html)

