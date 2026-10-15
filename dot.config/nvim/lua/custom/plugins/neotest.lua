-- Run and debug pytest tests from inside Neovim

vim.pack.add {
  'https://github.com/nvim-neotest/neotest',
  'https://github.com/nvim-neotest/neotest-python',
  'https://github.com/nvim-neotest/nvim-nio',
  'https://github.com/nvim-lua/plenary.nvim',
}

-- neotest parses test files with treesitter, including files that aren't open
require('nvim-treesitter').install { 'python' }

---@diagnostic disable-next-line: missing-fields
require('neotest').setup {
  adapters = {
    require 'neotest-python' {
      runner = 'pytest',
      -- Debugging a test uses the debugpy adapter set up in kickstart/plugins/debug.lua
      dap = { justMyCode = false },
    },
  },
}

local neotest = require 'neotest'
vim.keymap.set('n', '<leader>tt', function() neotest.run.run() end, { desc = '[T]est nearest' })
vim.keymap.set('n', '<leader>tf', function() neotest.run.run(vim.fn.expand '%') end, { desc = '[T]est [F]ile' })
vim.keymap.set('n', '<leader>ta', function() neotest.run.run(vim.uv.cwd()) end, { desc = '[T]est [A]ll' })
vim.keymap.set('n', '<leader>tl', function() neotest.run.run_last() end, { desc = '[T]est [L]ast' })
vim.keymap.set('n', '<leader>td', function() neotest.run.run { strategy = 'dap' } end, { desc = '[T]est [D]ebug nearest' })
vim.keymap.set('n', '<leader>ts', function() neotest.summary.toggle() end, { desc = '[T]est [S]ummary' })
vim.keymap.set('n', '<leader>to', function() neotest.output.open { enter = true, auto_close = true } end, { desc = '[T]est [O]utput' })
vim.keymap.set('n', '<leader>tp', function() neotest.output_panel.toggle() end, { desc = '[T]est output [P]anel' })
vim.keymap.set('n', '<leader>tx', function() neotest.run.stop() end, { desc = '[T]est stop' })
vim.keymap.set('n', ']t', function() neotest.jump.next { status = 'failed' } end, { desc = 'Next failed test' })
vim.keymap.set('n', '[t', function() neotest.jump.prev { status = 'failed' } end, { desc = 'Previous failed test' })
