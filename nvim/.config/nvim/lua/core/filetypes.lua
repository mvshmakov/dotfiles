-- Additional file associations
vim.filetype.add({
    filename = {
        -- Recognize DVC files as yaml
        ["Dvcfile"] = "yaml",
        ["dvc.lock"] = "yaml",
        -- dvcignore has gitignore syntax: https://dvc.org/doc/user-guide/dvcignore
        [".dvcignore"] = "gitignore",
        -- Python
        -- Is not highlighted by default
        [".flake8"] = "toml",
        [".coveragerc"] = "toml",
    },
    pattern = {
        -- .env.production, .env.example
        [".env.*"] = "sh",
        -- DVC-related patterns
        ["*.dvc"] = "yaml",
        [".*/.dvc/config"] = "toml",
        -- https://www.reddit.com/r/neovim/comments/10pcule/how_to_get_syntax_highlighting_for/
        ["requirements*.txt"] = "config",
    },
})
