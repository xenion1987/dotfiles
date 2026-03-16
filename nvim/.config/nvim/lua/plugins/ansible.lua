return {
  -- Mason soll ansible-lint NICHT mehr installieren (optional, aber sauber)
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = vim.tbl_filter(function(v)
        return v ~= "ansible-lint"
      end, opts.ensure_installed or {})
    end,
  },

  -- ansiblels auf lokale .venv zeigen lassen
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ansiblels = {
          settings = {
            ansible = {
              python = {
                interpreterPath = vim.fn.getcwd() .. "/.venv/bin/python",
              },
              validation = {
                enabled = true,
                lint = {
                  enabled = true,
                  path = vim.fn.getcwd() .. "/.venv/bin/ansible-lint",
                },
              },
            },
          },
        },
      },
    },
  },
}
