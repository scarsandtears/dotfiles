local status_ok, notify = pcall(require, "notify")
if not status_ok then
  return
end

notify.setup({
  stages = "fade_in_slide_out",
  fps = 60,
  timeout = 2500,
  background_colour = "Normal",
  render = "default",
  top_down = true,
  max_width = 60,
})

vim.notify = notify

vim.schedule(function()
  vim.notify = require("notify")
end)

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    local links = {
      NotifyBackground = "Normal",

      NotifyINFOBorder = "FloatBorder",
      NotifyINFOTitle = "Title",
      NotifyINFOIcon = "Normal",
      NotifyINFOBody = "Normal",

      NotifyWARNBorder = "FloatBorder",
      NotifyWARNTitle = "Title",
      NotifyWARNIcon = "WarningMsg",
      NotifyWARNBody = "Normal",

      NotifyERRORBorder = "FloatBorder",
      NotifyERRORTitle = "Title",
      NotifyERRORIcon = "ErrorMsg",
      NotifyERRORBody = "Normal",

      NotifyDEBUGBorder = "FloatBorder",
      NotifyDEBUGTitle = "Title",
      NotifyDEBUGIcon = "Comment",
      NotifyDEBUGBody = "Normal",

      NotifyTRACEBorder = "FloatBorder",
      NotifyTRACETitle = "Title",
      NotifyTRACEIcon = "Comment",
      NotifyTRACEBody = "Normal",
    }

    for group, link in pairs(links) do
      vim.api.nvim_set_hl(0, group, { link = link, default = false })
    end
  end,
})

vim.cmd("doautocmd ColorScheme")
