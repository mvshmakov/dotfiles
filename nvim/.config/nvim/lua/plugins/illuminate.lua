-- Highlights the other uses of the word under the cursor (via LSP references,
-- falling back to treesitter and then plain regex). Replaces the
-- highlight_definitions/navigation features of the archived
-- nvim-treesitter-refactor plugin; <a-n>/<a-p> jump between the references.
return {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
        require("illuminate").configure({})
    end,
}
