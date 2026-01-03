return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    highlight = { enable = true },
    indent = { enable = true },
    ensure_installed = {
      -- Web frontend
      "html", "css", "scss", "javascript", "typescript", "tsx", "vue", "json",
      -- Backend
      "python", "lua", "go", "rust", "java", "c", "cpp", "c_sharp", "php", "ruby", "perl", "bash", "dockerfile",
      -- Databases
      "sql", "graphql",
      -- Config/DevOps
      "yaml", "toml", "ini", "make", "terraform",
      -- Markup/Docs
      "markdown", "markdown_inline", "latex",
      -- Misc
      "gitignore", "vim", "regex"
    }
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
  end,
}