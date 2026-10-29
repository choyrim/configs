-- View images (and the first page of PDFs) inside Neovim with real pixels, via the
-- kitty graphics protocol (Ghostty, kitty). Needs ImageMagick, plus Ghostscript for PDFs.
-- Run `:checkhealth snacks` if images don't show up.

vim.pack.add { 'https://github.com/folke/snacks.nvim' }

require('snacks').setup {
  image = {},
}

-- snacks only previews the first page of a PDF, so <Enter> on a PDF opens the whole
-- document in tdf (brew install tdf). tdf can't run in Neovim's :terminal (it has no
-- kitty graphics support, and tdf hangs waiting for replies to its terminal queries),
-- so it runs in a new Ghostty window instead. Quit tdf with q.
-- `open -n` starts a separate Ghostty instance that lingers after its window closes,
-- so the wrapper kills it (the parent of sh's parent, `login`) once tdf exits.
vim.api.nvim_create_autocmd('BufEnter', {
  desc = 'Read the full PDF in tdf',
  group = vim.api.nvim_create_augroup('custom-pdf', { clear = true }),
  pattern = '*.pdf',
  callback = function(args)
    vim.keymap.set('n', '<CR>', function()
      vim.system {
        'open', '-na', 'Ghostty.app', '--args', '-e',
        '/bin/sh', '-c', '"$0" "$1"; kill $(ps -o ppid= -p $PPID)',
        vim.fn.exepath 'tdf', vim.api.nvim_buf_get_name(args.buf),
      }
    end, { buffer = args.buf, desc = 'Read PDF in tdf' })
  end,
})
