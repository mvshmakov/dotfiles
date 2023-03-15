local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
    return
end

local actions = require("telescope.actions")

telescope.setup({
    find_command = { "rg", "--files", "--hidden" },

    defaults = {
        prompt_prefix = " ",
        selection_caret = " ",
        path_display = { "smart" },
        file_ignore_patterns = { ".git/", "node_modules" },
        use_less = true,

        picker = {
            find_files = {
                find_command = { "rg", "--files", "--hidden" },
            },
        },

        -- For the live grep
        vimgrep_arguments = {
            "rg",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",
            -- To trim the indentation at the beginning of presented line in the result window
            "--trim",
        },

        mappings = {
            i = {
                ["<Down>"] = actions.cycle_history_next,
                ["<Up>"] = actions.cycle_history_prev,
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
            },
        },
    },
})

-- TODO: setup telescope image preview
-- e.g., https://alpha2phi.medium.com/neovim-101-image-viewer-7f5d35db637a
-- or https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#use-terminal-image-viewer-to-preview-images
-- require("telescope").setup({
--     defaults = {
--         preview = {
--             mime_hook = function(filepath, bufnr, opts)
--                 local is_image = function(filepath)
--                     local image_extensions = { "png", "jpg", "jpeg", "gif" } -- Supported image formats
--                     local split_path = vim.split(filepath:lower(), ".", { plain = true })
--                     local extension = split_path[#split_path]
--                     return vim.tbl_contains(image_extensions, extension)
--                 end
--                 if is_image(filepath) then
--                     local term = vim.api.nvim_open_term(bufnr, {})
--                     local function send_output(_, data, _)
--                         for _, d in ipairs(data) do
--                             vim.api.nvim_chan_send(term, d .. "\r\n")
--                         end
--                     end

--                     vim.fn.jobstart({
--                         "viu",
--                         "-w",
--                         "40",
--                         "-b",
--                         filepath,
--                     }, {
--                         on_stdout = send_output,
--                         stdout_buffered = true,
--                     })
--                 else
--                     require("telescope.previewers.utils").set_preview_message(
--                         bufnr,
--                         opts.winid,
--                         "Binary cannot be previewed"
--                     )
--                 end
--             end,
--         },
--     },
-- })

require("telescope").load_extension("media_files")
require("telescope").load_extension("gh")
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require("telescope").load_extension("fzf")
require("telescope").load_extension("z")
require("telescope").load_extension("neoclip")
