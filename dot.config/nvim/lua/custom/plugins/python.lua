-- Python-specific editor settings

vim.api.nvim_create_autocmd('FileType', {
  desc = 'Ruler at 88 columns to match ruff/black line length',
  group = vim.api.nvim_create_augroup('custom-python', { clear = true }),
  pattern = 'python',
  callback = function() vim.opt_local.colorcolumn = '89' end,
})
