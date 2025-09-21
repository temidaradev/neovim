return {
  { 'wakatime/vim-wakatime', lazy = false },

  { "andweeb/presence.nvim", lazy = false },

  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
    require "configs.lspconfig"
    end,
  },

  {
    "ray-x/go.nvim",
    dependencies = {  -- optional packages
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      -- lsp_keymaps = false,
      -- other options
    },
    config = function(lp, opts)
    require("go").setup(opts)
    local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*.go",
      callback = function()
      require('go.format').goimports()
      end,
      group = format_sync_grp,
    })
    end,
    event = {"CmdlineEnter"},
    ft = {"go", 'gomod'},
    build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
  },
  {
    'mrcjkb/rustaceanvim',
    version = '^6',
    lazy = false,
    ft = "rust",
    config = function ()
    local codelldb_pkg = vim.fn.expand("$MASON/packages/codelldb")
    local extension_path = codelldb_pkg .. "/extension/"
    local codelldb_path = extension_path .. "adapter/codelldb"

    local sysname = vim.loop.os_uname().sysname
    local liblldb_path
    if sysname == "Darwin" then
      liblldb_path = extension_path .. "lldb/lib/liblldb.dylib"
      else
        liblldb_path = extension_path .. "lldb/lib/liblldb.so"
        end

        local cfg = require('rustaceanvim.config')

        vim.g.rustaceanvim = {
          dap = {
            adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
          },
        }
        end
  },

  {
    'rust-lang/rust.vim',
    ft = "rust",
    init = function ()
    vim.g.rustfmt_autosave = 1
    end
  },

  {
    'mfussenegger/nvim-dap',
    config = function()
    local dap, dapui = require("dap"), require("dapui")
    dap.listeners.before.attach.dapui_config = function()
    dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
    dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
    dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
    dapui.close()
    end
    end,
  },

  {
    'rcarriga/nvim-dap-ui',
    dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"},
    config = function()
    require("dapui").setup()
    end,
  },

  {
    'saecki/crates.nvim',
    ft = {"toml"},
    config = function()
    require("crates").setup {
      completion = {
        cmp = {
          enabled = true
        },
      },
    }
    require('cmp').setup.buffer({
      sources = { { name = "crates" }}
    })
    end
  },
}
