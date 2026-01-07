return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      local lspconfig = require("lspconfig")
      
      -- Setup Mason to automatically manage LSP servers
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "ts_ls", "pyright", "sonarlint" }, -- Add more servers here as needed
        automatic_installation = true,
      })
      
      -- Global keybindings for LSP
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          -- Helper to define mappings
          local opts = { buffer = ev.buf }
          
          -- Go to definition (this is what you requested)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          
          -- Other useful navigation commands
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
        end,
      })

      -- Setup language servers
       -- Integration with nvim-cmp
       local capabilities = vim.lsp.protocol.make_client_capabilities()
       local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
       if status_ok then
         capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
       end
       
       -- Enable completion for type definitions and references
       capabilities.textDocument.completion.completionItem.snippetSupport = true
       capabilities.textDocument.completion.completionItem.resolveSupport = {
         properties = { "documentation", "detail", "additionalTextEdits" },
       }

      -- You can use a loop to setup servers found by mason-lspconfig
      require("mason-lspconfig").setup_handlers({
        function(server_name)
          if server_name == "sonarlint" then
            return -- Skip, handled by sonarlint.nvim
          end
          lspconfig[server_name].setup({
            capabilities = capabilities,
          })
        end,
      })
    end,
  }
}
