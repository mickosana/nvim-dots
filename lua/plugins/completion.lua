return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp", -- Source for LSP
      "hrsh7th/cmp-nvim-lsp-signature-help", -- LSP signature help
      "hrsh7th/cmp-buffer",   -- Source for text in buffer
      "hrsh7th/cmp-path",     -- Source for file system paths
      "hrsh7th/cmp-cmdline",  -- Source for vim command line
      "L3MON4D3/LuaSnip",     -- Snippet engine
      "saadparwaiz1/cmp_luasnip", -- for autocompletion
      "rafamadriz/friendly-snippets", -- useful snippets
      "onsails/lspkind.nvim", -- vs-code like pictograms
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

      -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        completion = {
          completeopt = "menu,menuone,preview,noselect",
        },
        snippet = { -- configure how nvim-cmp interacts with snippet engine
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
          ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
          ["<C-e>"] = cmp.mapping.abort(), -- close completion window
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
        }),
        -- sources for autocompletion
        sources = cmp.config.sources({
          { name = "nvim_lsp", priority = 100 }, -- LSP completions (highest priority)
          { name = "nvim_lsp_signature_help" }, -- function signatures
          { name = "luasnip", priority = 75 }, -- snippets
          { name = "buffer", priority = 50 }, -- text within current buffer
          { name = "path", priority = 40 }, -- file system paths
        }),
        -- configure lspkind for vs-code like pictograms in completion menu
        formatting = {
          format = lspkind.cmp_format({
            maxwidth = 50,
            ellipsis_char = "...",
            menu = {
              nvim_lsp = "[LSP]",
              nvim_lsp_signature_help = "[Sig]",
              luasnip = "[Snippet]",
              buffer = "[Buffer]",
              path = "[Path]",
            },
          }),
        },
      })

      -- Setup completion for cmdline
      cmp.setup.cmdline(":", {
        sources = cmp.config.sources({
          { name = "cmdline" },
          { name = "path" },
        }),
      })

      -- Setup completion for search
      cmp.setup.cmdline("/", {
        sources = cmp.config.sources({
          { name = "buffer" },
        }),
      })
    end,
  },
}
