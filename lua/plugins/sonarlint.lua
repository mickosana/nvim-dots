return {
  {
    "https://gitlab.com/schrieveslaach/sonarlint.nvim",
    dependencies = {
      "williamboman/mason.nvim",
    },
    config = function()
      local sonarlint = require("sonarlint")
      
      -- Define paths for Mason-installed SonarLint
      local mason_path = vim.fn.stdpath("data") .. "/mason"
      local sonarlint_path = mason_path .. "/packages/sonarlint-language-server"
      local analyzers_path = sonarlint_path .. "/extension/analyzers"
      
      -- Gather all installed analyzer jars
      local pattern = analyzers_path .. "/*.jar"
      local found_analyzers = vim.split(vim.fn.glob(pattern), "\n")
      local analyzers = {}
      for _, analyzer in ipairs(found_analyzers) do
        if analyzer ~= "" then
          table.insert(analyzers, analyzer)
        end
      end

      -- Construct the command arguments
      local cmd = {
        mason_path .. "/bin/sonarlint-language-server",
        "-stdio",
        "-analyzers",
      }
      -- Append all analyzer paths to the command
      for _, analyzer in ipairs(analyzers) do
        table.insert(cmd, analyzer)
      end

      sonarlint.setup({
        server = {
          cmd = cmd,
        },
        filetypes = {
          "javascript",
          "typescript",
          "typescriptreact",
          "python",
          "java",
          "html",
          "css",
          "cpp",
          "c",
          "go",
          "lua",
        },
      })
    end,
  },
}
