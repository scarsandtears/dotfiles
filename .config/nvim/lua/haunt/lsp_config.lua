local status_ok, mason = pcall(require, "mason")
if not status_ok then
	return
end

local status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not status_ok then
	return
end

local status_ok, lspconfig = pcall(require, "lspconfig")
if not status_ok then
	return
end

mason.setup()
mason_lspconfig.setup({
  ensure_installed = { "lua_ls",
                       "clangd",
                      "pyright",
                        "gopls",
                        "cssls",
                         "html",
                       "bashls"
                       }
})

vim.lsp.enable('lua_ls')
vim.lsp.enable('clangd')
vim.lsp.enable('pyright')
vim.lsp.enable('gopls')
vim.lsp.enable('cssls')
vim.lsp.enable('html')
vim.lsp.enable('bashls')
