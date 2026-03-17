return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        -- Ansible
        "ansible-lint",
        -- Markdown
        "markdown-toc",
        "markdownlint-cli2",
        "marksman",
        -- Formatting
        "prettier",
        -- Shell
        "shellcheck",
        "shfmt",
        -- YAML
        "yaml-language-server",
      })
    end,
  },
}
