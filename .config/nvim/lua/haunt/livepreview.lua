local M = {}

function M.setup()
  require("livepreview.config").set({
    browser = "firefox",
    port = 8080,
    mappings = {
      open = "<leader>lp",
      close = "<leader>lq"
    },
  })
end

return M
