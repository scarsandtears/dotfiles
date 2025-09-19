vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
  return
end

local function my_on_attach(bufnr)
  local api = require "nvim-tree.api"

  api.config.mappings.default_on_attach(bufnr)

  local function opts(desc)
    return {
      desc = "nvim-tree: " .. desc,
      buffer = bufnr,
      noremap = true,
      silent = true,
      nowait = true
    }
  end

  vim.keymap.set("n", "l", api.node.open.edit, opts "Open")
  vim.keymap.set("n", "h", api.node.navigate.parent_close, opts "Close Directory")
  vim.keymap.set("n", "v", api.node.open.vertical, opts "Open: Vertical Split")
  vim.keymap.del("n", "<C-k>", { buffer = bufnr })
end

nvim_tree.setup({
  on_attach = my_on_attach,
  sort_by = "case_sensitive",
  view = {
    width = 30,
    side = "left",
  },
  renderer = {
    group_empty = true,
    icons = {
      glyphs = {
        folder = {
          arrow_closed = "",
          arrow_open = "",
        },
      },
    },
  },
  filters = {
    dotfiles = false,
  },
})
