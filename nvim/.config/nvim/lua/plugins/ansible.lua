return {
  -- ansiblels use local .venv
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
