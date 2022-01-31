local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true


-- Setup nvim-cmp.
local cmp = require("cmp")
local source_mapping = {
	buffer = "[Buffer]",
	nvim_lsp = "[LSP]",
	nvim_lua = "[Lua]",
	cmp_tabnine = "[TN]",
	path = "[Path]",
}

local lspkind = require("lspkind")
require('lspkind').init({
    with_text = true,
})

cmp.setup({
	snippet = {
		expand = function(args)
			-- For `luasnip` user.
			require("luasnip").lsp_expand(args.body)
		end,
	},
	mapping = {
		["<C-u>"] = cmp.mapping.scroll_docs(-4),
		["<C-d>"] = cmp.mapping.scroll_docs(4),
	--	["<C-Space>"] = cmp.mapping.complete(),
              ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
	},

    formatting = {
        format = function(entry, vim_item)
            vim_item.kind = lspkind.presets.default[vim_item.kind]
            local menu = source_mapping[entry.source.name]
            if entry.source.name == 'cmp_tabnine' then
                if entry.completion_item.data ~= nil and entry.completion_item.data.detail ~= nil then
                    menu = entry.completion_item.data.detail .. ' ' .. menu
                end
                vim_item.kind = ''
            end
            vim_item.menu = menu
            return vim_item
        end
    },

	sources = {
        -- tabnine completion? yayaya

      --  { name = "cmp_tabnine" },

		{ name = "nvim_lsp" },
	    { name = "path" },

		-- For vsnip user.
		-- { name = 'vsnip' },

		-- For luasnip user.
		{ name = "luasnip" },

		-- For ultisnips user.
		-- { name = 'ultisnips' },

		{ name = "buffer", keyword_length = 4 },
	},

    experimental = {
        native_menu = false,
        ghost_text = true,
    },
})



local tabnine = require('cmp_tabnine.config')
tabnine:setup({
    max_lines = 1000,
    max_num_results = 20,
    sort = true,
    run_on_every_keystroke = true,
    snippet_placeholder = '..',
})
-- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
local capabilities = vim.lsp.protocol.make_client_capabilities()
local function config(_config)
    return vim.tbl_deep_extend("force", {
        capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities),
    }, _config or {})
end


local lsp_util = require 'lspconfig.util'
local nvim_lsp = require("lspconfig")
local utils = require("mati.utils")




-- npm i -g pyright -- fix
require("lspconfig").pyright.setup(config({
    cmd = { "pyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_dir = utils.root_pattern(".git", "setup.py",  "requirements.txt");
    on_attach = function(client)
        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.document_range_formatting = false
        --on_attach(client)
    end,
 --   before_init = function(_, config)
 --       local p
 --       if vim.env.VIRTUAL_ENV then
 --           p = lsp_util.path.join(vim.env.VIRTUAL_ENV, "bin", "python3")
 --       else
 --           p = utils.find_cmd("python3", ".venv/bin", config.root_dir)
 --       end
 --       config.settings.python.pythonPath = p
 --   end,
    flags = {
        debounce_text_changes = 150,
    },
    settings = {
        disableOrganizeImports = true,
        python = {
            analysis = {
                autoSearchPaths = true, -- true?
                diagnosticMode = "workspace", -- openFilesOnly ?
                useLibraryCodeForTypes = true, -- true?
                typeCheckingMode = "off"
            },
        },
    },
    single_file_support = true
}))


require("lspconfig").clangd.setup(config())

--require'lspconfig'.texlab.setup()

require'lspconfig'.texlab.setup(config({
    cmd = { "texlab" },
    filetypes = { "tex", "bib" },
    root_dir = function(fname)
        return lsp_util.root_pattern '.latexmkrc'(fname) or lsp_util.find_git_ancestor(fname)
    end,

    settings = {
        texlab = {
            auxDirectory = ".",
            bibtexFormatter = "texlab",
            build = {
                args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
                executable = "latexmk",
                forwardSearchAfter = false,
                onSave = false
            },
   --         chktex = {
   --             onEdit = false,
   --             onOpenAndSave = false
   --         },
            diagnosticsDelay = 300,
            formatterLineLength = 80,
            forwardSearch = {
                args = {}
            },
            latexFormatter = "latexindent",
            latexindent = {
                modifyLineBreaks = false
            },
        },
    },
    single_file_support = true
}))

local opts = {
	-- whether to highlight the currently hovered symbol
	-- disable if your cpu usage is higher than you want it
	-- or you just hate the highlight
	-- default: true
	highlight_hovered_item = true,

	-- whether to show outline guides
	-- default: true
	show_guides = true,
}

require("symbols-outline").setup(opts)

local snippets_paths = function()
	local plugins = { "friendly-snippets" }
	local paths = {}
	local path
	local root_path = vim.env.HOME .. "/.vim/plugged/"
	for _, plug in ipairs(plugins) do
		path = root_path .. plug
		if vim.fn.isdirectory(path) ~= 0 then
			table.insert(paths, path)
		end
	end
	return paths
end

require("luasnip.loaders.from_vscode").lazy_load({
	paths = snippets_paths(),
	include = nil, -- Load all languages
	exclude = {},
})
