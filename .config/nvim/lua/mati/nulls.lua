local null_ls = require("null-ls")

require("null-ls").setup({
	sources = {
--        require("null-ls").builtins.formatting.stylua,
--        require("null-ls").builtins.diagnostics.eslint,
--        require("null-ls").builtins.completion.spell,
--        -- python
--        null_ls.builtins.formatting.autopep8,
--        null_ls.builtins.formatting.isort,
-- --       null_ls.builtins.diagnostics.flake8,
-- --       null_ls.builtins.diagnostics.pylint,
--        null_ls.builtins.formatting.black,
--
--        -- shell
--        null_ls.builtins.formatting.shfmt,
--        null_ls.builtins.formatting.shellharden,
----        null_ls.builtins.diagnostics.shellcheck,
----        null_ls.builtins.code_actions.shellcheck,
--
--        -- markdown
--        null_ls.builtins.diagnostics.markdownlint,
--
--                -- Spell checking Python lib.
-- --       null_ls.builtins.diagnostics.codespell.with({}),
----            args = { "--builtin", "clear,rare,code", "-" },
----        }),
--
--        -- latex
----        null_ls.builtins.diagnostics.chktex,
----        null_ls.builtins.formatting.latexindent,
--
--        -- Git
--        null_ls.builtins.code_actions.gitsigns,
	},
})
