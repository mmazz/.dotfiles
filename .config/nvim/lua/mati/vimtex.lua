local cmd = vim.cmd
local g = vim.g

-- latex viewer
g.tex_flavor = 'latex'
g.vimtex_view_method = 'zathura'
g.vimtex_view_general_viewer = 'zathura'
g.vimtex_fold_enabled = 0
g.vimtex_quickfix_mode = 0
g.vimtex_indent_enabled = 0


 -- au VimEnter * highlight SpellBad ctermfg=011 ctermbg=009 guifg=#282828 guibg=RED

-- vim.api.nvim_exec([[ autocmd BufNewFile,BufRead *.md,*.tex setlocal spell spelllang=pt,en_us ]], false)

