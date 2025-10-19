local status_ok, notify = pcall(require, "notify")
if not status_ok then
  return
end

notify.setup({
  stages = "fade_in_slide_out",
  fps = 60,
  timeout = 2500,
  background_colour = "#000000",
  render = "default",
  top_down = true,
  max_width = 60,
})

vim.notify = notify

vim.schedule(function()
  vim.notify = require("notify")
end)
