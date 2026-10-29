-- Markdown preview, two ways:
--  * render-markdown.nvim draws headings, tables, checkboxes, code blocks, etc. right in
--    the buffer, showing raw markdown on the cursor line so you can still edit it
--  * markdown-preview.nvim opens a live preview in the browser that follows your edits
--    and scrolling (built with node on install, see the PackChanged hook in init.lua)

vim.pack.add {
  'https://github.com/MeanderingProgrammer/render-markdown.nvim',
  'https://github.com/iamcco/markdown-preview.nvim',
}

require('render-markdown').setup {
  -- LaTeX math needs the latex treesitter parser and utftex/latex2text; not set up here
  latex = { enabled = false },
}

vim.api.nvim_create_autocmd('FileType', {
  desc = 'Markdown preview keymaps',
  group = vim.api.nvim_create_augroup('custom-markdown', { clear = true }),
  pattern = 'markdown',
  callback = function(args)
    vim.keymap.set('n', '<leader>tm', '<cmd>RenderMarkdown toggle<CR>', { buffer = args.buf, desc = '[T]oggle [M]arkdown rendering' })
    vim.keymap.set('n', '<leader>tp', '<cmd>MarkdownPreviewToggle<CR>', { buffer = args.buf, desc = '[T]oggle markdown [P]review in browser' })
  end,
})
