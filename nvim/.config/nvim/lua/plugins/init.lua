return {
  -- "github/copilot.vim", -- TODO: enable
  {
    "mbbill/undotree",
    init = function()
      vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Toggle Undo Tree" })
    end,
  },

  {
    "akinsho/bufferline.nvim", -- Fancy way to view tabs + integrations
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
  },
  {
    "nvim-orgmode/orgmode", -- orgmode for neovim
    ft = "org",
    config = function()
      local orgmode = require("orgmode")

      orgmode.setup()
      orgmode.setup_ts_grammar()
    end,
  },
  { "petertriho/nvim-scrollbar", opts = {} }, -- purely to faster see the diagnostics
  {
    "folke/noice.nvim",
    event = "UIEnter",
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    },
    config = function()
      require("notify").setup({
        background_colour = "#000000", -- required to setup by noice
      })
      require("noice").setup({
        lsp = {
          progress = {
            enabled = true,
          },
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        views = {
          mini = {
            win_options = { winblend = 0 }, -- Set transparent background to the messages
            border = { style = "rounded" },
            position = { row = -2, col = -2 },
          },
        },
        presets = {
          bottom_search = true,         -- use a classic bottom cmdline for search
          command_palette = true,       -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = true,            -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = true,        -- add a border to hover docs and signature help
        },
      })

      -- Making the text within message readable due to transparancy enabled
      -- (from nord pallette)
      vim.api.nvim_set_hl(0, "NoiceLspProgressTitle", { fg = "#d8dee9" })
    end,
  },

  {
    "fladson/vim-kitty", -- Syntax highlighting for the kitty config file
    ft = "kitty",        -- Lazy-load on kitty filetype.
  },

  -- Replace the 'surroundings', e.g., parenthesis, XML, etc.
  -- Use cs"' to replace double quote by the single one. To replace something to a tag, use cst
  "tpope/vim-surround",
  "terryma/vim-multiple-cursors",          -- make cursors available on several lines
  {
    "lukas-reineke/indent-blankline.nvim", -- show indentation lines
    main = "ibl",
    opts = {}
  },

  {
    "phaazon/hop.nvim", -- jump to any character in the line conveniently with fFtT
    config = function()
      local hop = require("hop")
      local directions = require("hop.hint").HintDirection

      hop.setup()

      vim.keymap.set("", "f", function()
        hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
      end, { remap = true, desc = "Hop to char as f" })

      vim.keymap.set("", "F", function()
        hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
      end, { remap = true, desc = "Hop to char as F" })

      vim.keymap.set("", "t", function()
        hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
      end, { remap = true, desc = "Hop to char as t" })

      vim.keymap.set("", "T", function()
        hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
      end, { remap = true, desc = "Hop to char as T" })
    end,
  },

  "tpope/vim-dadbod",    -- database exploration tool
  "jamessan/vim-gnupg",  -- open GPG-encrypted files and edit them natively without decryption

  "tpope/vim-obsession", -- save neovim sessions

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      plugins = {
        presets = {
          operators = true,    -- adds help for operators like d, y, ...
          motions = true,      -- adds help for motions
          text_objects = true, -- help for text objects triggered after entering an operator
          windows = true,      -- default bindings on <c-w>
          nav = true,          -- misc bindings to work with windows
          z = true,            -- bindings for folds, spelling and others prefixed with z
          g = true,            -- bindings for prefixed with g
        },
      },
      motions = { count = true },
      show_keys = true,  -- show the currently pressed key and its label as a message in the command line
      triggers = "auto", -- automatically setup triggers
      window = { border = "single" },
    },
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
  },

  -- Debug Adapter Protocol (DAP)
  "mfussenegger/nvim-dap",
  "rcarriga/nvim-dap-ui",

  {
    "AckslD/nvim-neoclip.lua",                     -- clipboard manager
    dependencies = {
      { "kkharji/sqlite.lua", module = "sqlite" }, -- use persistent history between sessions
    },
  },

  -- Comments with `gc` + TODO lists
  { "numToStr/comment.nvim",     config = { enable = true } },
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    dependencies = "nvim-lua/plenary.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = true,
    keys = {
      {
        "]t",
        function()
          require("todo-comments").jump_next()
        end,
        desc = "Next todo comment"
      },
      {
        "[t",
        function()
          require("todo-comments").jump_prev()
        end,
        desc = "Previous todo comment"
      },
      { "<leader>xt", "<cmd>TodoTrouble<cr>",                           desc = "Todo (Trouble)" },
      { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>",   desc = "Todo/Fix/Fixme (Trouble)" },
      { "<leader>st", "<cmd>TodoTelescope<cr>",                         desc = "Todo" },
      { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
    },
  },

  -- Git
  "kdheepak/lazygit.nvim", -- lazygit support
  {
    "tpope/vim-fugitive",
    init = function()
      -- Open git status in a vertical split on the left
      vim.keymap.set("n", "<leader>gs", "<CMD>:topleft vertical Git<CR>", { desc = "Git status" })
    end,
  },
  {
    "lewis6991/gitsigns.nvim", -- Pure lua alternative to `airblade/vim-gitgutter`
    dependencies = "petertriho/nvim-scrollbar",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        -- stylua: ignore start
        map("n", "]h", gs.next_hunk, "Next Hunk")
        map("n", "[h", gs.prev_hunk, "Prev Hunk")
        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "<leader>ghd", gs.diffthis, "Diff This")
        map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")

        require("scrollbar.handlers.gitsigns").setup()
      end,
    },
  },
  -- TODO: may not be actually needed due to gitsigns blame support
  -- "f-person/git-blame.nvim", -- git blame within virtual text
  -- Generate GitHub shareable links
  {
    "ruifm/gitlinker.nvim",
    dependencies = "nvim-lua/plenary.nvim",
  },
  "sindrets/diffview.nvim", -- view diffs in splits

  -- DVC integration
  "gennaro-tedesco/nvim-dvc",

  -- Direnv integration (proper hook execution + .envrc syntax)
  "direnv/direnv.vim",

  -- Markdown
  "godlygeek/tabular", -- Align tabular structures (as markdown tables or text)

  -- LaTex
  {
    "lervag/vimtex",
    init = function()
      vim.g.vimtex_view_method = "zathura"
    end,
  },

  -- CSS
  {
    "NvChad/nvim-colorizer.lua",
    event = 'VeryLazy',
    config = function()
      local colorizer = require("colorizer")

      colorizer.setup({
        user_default_options = {
          names = false,     -- "Name" codes like Blue or blue
          rgb_fn = true,     -- CSS rgb() and rgba() functions
          hsl_fn = true,     -- CSS hsl() and hsla() functions
          RRGGBBAA = true,   -- #RRGGBBAA hex codes
          AARRGGBB = true,   -- 0xAARRGGBB hex codes
          tailwind = "both", -- Enable tailwind colors
        },
        filetypes = {
          "*",
          css = {
            css = true,
            sass = { enable = true, parsers = { "css" } }, -- Enable sass colors
          },
          -- update color values even if buffer is not focused
          -- example use: cmp_menu, cmp_docs
          cmp_menu = { always_update = true },
          cmp_docs = { always_update = true },
        },
      })

      -- nvim-colorizer doesn't work on the initial buffer if we lazy load, so force it to attach
      -- on load: https://github.com/NvChad/nvim-colorizer.lua/issues/57
      local bufnr = vim.api.nvim_get_current_buf()
      if bufnr and not colorizer.is_buffer_attached(bufnr) then
        colorizer.attach_to_buffer(bufnr)
      end
    end,
    opts = {
    }
  }, -- preview CSS, Tailwind, function colors as bg of the same HEX

  -- Manpages
  "paretje/nvim-man", -- use man pages inside neovim

  -- Utils
  "smithbm2316/centerpad.nvim", -- Centers vim buffer
}
