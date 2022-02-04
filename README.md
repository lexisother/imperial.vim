# imperial.vim

Vim plugin to upload the current file content to imperialb.in.

## Configuration

You can change the host to another imperialb.in instance like this: `let g:imperial_host = "https://imperialb.in/api/document"`

The default value is: `https://imperialb.in/api/document`

You can set the mapping for the command like this:

```vim
nnoremap <unique> <F6> :UploadToImperial<CR>
```
