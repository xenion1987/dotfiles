return {
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}

      vim.list_extend(opts.linters_by_ft.sh or {}, { "shellcheck" })
      vim.list_extend(opts.linters_by_ft.bash or {}, { "shellcheck" })
      vim.list_extend(opts.linters_by_ft["yaml.ansible"] or {}, { "ansible_lint" })
    end,
  },
}
