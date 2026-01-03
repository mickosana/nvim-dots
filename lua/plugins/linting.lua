-- File: lua/plugins/linting.lua
return {
  -- nvim-lint setup
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("lint").linters_by_ft = {
        html = { "tidy" },
        css = { "stylelint" },
        scss = { "stylelint" },
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        tsx = { "eslint_d" },
        vue = { "eslint_d" },
        json = { "jsonlint" },
        python = { "flake8" },
        lua = { "luacheck" },
        go = { "golangci_lint" },
        rust = { "clippy" },
        java = { "checkstyle" },
        c = { "clangtidy" },
        cpp = { "clangtidy" },
        c_sharp = { "csharpier" },
        php = { "phpcs" },
        ruby = { "rubocop" },
        perl = { "perlcritic" },
        bash = { "shellcheck" },
        dockerfile = { "hadolint" },
        sql = { "sqlfluff" },
        graphql = { "eslint_d" },
        yaml = { "yamllint" },
        toml = { "taplo" },
        ini = { "ini_lint" },
        make = { "checkmake" },
        terraform = { "tflint" },
        markdown = { "markdownlint" },
        latex = { "chktex" },
        gitignore = {},
        vim = { "vint" },
        regex = {},
      }
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function() require("lint").try_lint() end,
      })
    end,
  },
}