if exists('g:loaded_imperial')
  finish
endif
let g:loaded_imperial = 1

let g:imperial_host = get(g:, 'imperial_host', 'https://imperialb.in/api/document')
" let g:imperial_frontend = get(g:, 'imperial_frontend', 'https://imperialb.in')
let g:imperial_frontend = get(g:, 'imperial_frontend', 'https://snakeb.in')

function! s:curl(url, data, silent)
  let response = ''
  let err = ''
  let cmd = 'curl --location --silent --fail --max-time 10 -H "Content-Type: application/json" -X POST -d ' . shellescape(json_encode(a:data)) . ' ' . a:url
  if !a:silent
    echo 'Running...'
  endif
  let response = system(cmd)
  if err != ''
    echo err
    return ''
  endif
  return response
endfunction

function! s:upload_to_imperial()
  let s:extension = expand('%:e') != '' ? expand('%:e') : 'txt'
  let s:data = {
  \ "code": join(getline(1, '$'), "\n")
  \ }
  let s:output = json_decode(s:curl(g:imperial_host, s:data, v:false))

  if s:output['success'] == v:true
    if g:imperial_frontend == 'https://snakeb.in'
      let s:url = 'https://snakeb.in/#' . s:output["document"]["documentId"] . '.' . s:extension
    else
      let s:url = g:imperial_frontend . "/p/" . s:output["document"]["documentId"] . '.' . s:extension
    endif
    echo "Successfully uploaded! Your link: " . s:url
  else
    echoerr "Something went wrong. Please try again later."
    throw s:output
  endif
endfunction


command UploadToImperial call s:upload_to_imperial()

if !hasmapto(':UploadToImperial<CR>')
  nnoremap <unique> <F6> :UploadToImperial<CR>
endif
