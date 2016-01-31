vim-foldround
===============================================================================
![Version 0.1.0](https://img.shields.io/badge/version-0.1.0-yellow.svg?style=flat-square) ![Support Vim 7.3 or above](https://img.shields.io/badge/support-Vim%207.3%20or%20above-yellowgreen.svg?style=flat-square) [![MIT License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](LICENSE) [![Doc](https://img.shields.io/badge/doc-%3Ah%20vim--foldround-orange.svg?style=flat-square)](doc/vim-foldround.txt)

*vim-foldround* is a plugin to quickly walk around (change) `foldmethod`.

Install
-------------------------------------------------------------------------------
Use [Plug.vim][], [neobundle.vim][], or whatever like:

```vim
" Plug.vim
Plug 'lambdalisue/vim-foldround'

" neobundle.vim
NeoBundle 'lambdalisue/vim-foldround'

" neobundle.vim (Lazy)
NeoBundleLazy 'lambdalisue/vim-foldround', {
      \ 'on_func': 'foldround#',
      \ 'on_map': '<Plug>(foldround-',
      \}
```

Or copy the repository into one of your `runtimepath` of Vim.

[Plug.vim]: https://github.com/junequnn/vim-plug
[neobundle.vim]: https://github.com/Shougo/neobundle.vim


Usage
-------------------------------------------------------------------------------

This plugin does not provide default mappings so define like:

```vim
nmap <C-f>f     <Plug>(foldround-forward)
nmap <C-f><C-f> <Plug>(foldround-forward)
nmap <C-f>b     <Plug>(foldround-backward)
nmap <C-f><C-b> <Plug>(foldround-backward)
```

Then hit `<C-f>f` to change `foldmethod` of the current buffer.
This plugin automatically detect the current `foldmethod` and select next one.

If you would like to limit available `foldmethod`, use `foldround#register()` like:

```vim
"
" NOTE: Later registration is prior to be used.
"
" Disable foldround when the buffer is in 'diff' mode.
call foldround#register('.*', [
      \ 'disable', 'manual', 'indent',
      \ 'expr', 'marker', 'syntax'
      \])
" Use 'syntax' and 'marker' in Vim scripts
call foldround#register('.*\.vim$', ['syntax', 'marker'])
" But in Vim scripts in ftplugin directory
call foldround#register('ftplugin/.*\.vim$', ['syntax'])
```


License
-------------------------------------------------------------------------------
The MIT License (MIT)

Copyright (c) 2016 Alisue, hashnote.net

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

