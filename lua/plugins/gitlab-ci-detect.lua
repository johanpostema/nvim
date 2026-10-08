-- Detect GitLab CI pipeline files by name (unlike ansible, no content-sniffing
-- needed: ".gitlab-ci.yml" and included templates like "build.gitlab-ci.yml"
-- follow a fixed naming convention).
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("gitlab-ci-detect", { clear = true }),
  pattern = "*.gitlab-ci.yml",
  callback = function(args)
    vim.bo[args.buf].filetype = "yaml.gitlab"
  end,
})

-- reuse the yaml treesitter parser for yaml.gitlab buffers
vim.treesitter.language.register("yaml", "yaml.gitlab")
