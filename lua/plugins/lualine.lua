return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
        options = {
            theme = 'tokyonight',
            component_separators = { left = '', right = '' },
            section_separators = { left = '', right = '' },
            globalstatus = true,
        },
        sections = {
            lualine_a = {'mode'},
            lualine_b = {
                {'branch', icon = ''},
                {'diff', symbols = {added = ' ', modified = ' ', removed = ' '}},
            },
            lualine_c = {'filename'},
            lualine_x = {
                {
                    'diagnostics',
                    sources = {'nvim_diagnostic'},
                    symbols = {error = ' ', warn = ' ', info = ' ', hint = ' '}
                },
                'encoding',
                'fileformat',
                'filetype'
            },
            lualine_y = {'progress'},
            lualine_z = {
                'location',
                {
                    function()
                        local line = vim.fn.line('.')
                        local col = vim.fn.virtcol('.')
                        local char_at_pos = vim.fn.getline('.'):sub(vim.fn.col('.'), vim.fn.col('.'))
                        return string.format('Char: %d:%d [%s]', line, col, char_at_pos)
                    end
                }
            }
        },
    },
}
