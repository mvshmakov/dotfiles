# CLI tools, migrated from brew/.config/brew/Brewfile (comments carried
# over). Installed into /etc/profiles/per-user/$USER, which nix-darwin's
# /etc/zshrc puts on PATH. Search for packages with `nix search nixpkgs foo`
# or https://search.nixos.org/packages?channel=26.05
{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    # ---------------------------------------------------------------- Nix
    # Adding/managing alternative binary caches hosted by Cachix
    cachix
    # Language server + linters for editing this configuration in nvim
    nil
    # VS Code's Nix language server (nix-ide): NixOS option completion from
    # a flake's own nixosConfigurations
    nixd
    nixfmt
    statix
    deadnix

    # ---------------------------------------------------- Shells & prompt
    # Modern bash (macOS ships 3.2); completions are wired in .bashrc
    bash
    bash-completion
    zsh
    starship
    atuin
    # Fancy cd using frecency, agkozak/zsh-z (rupa/z) alternative
    zoxide
    checkbashisms
    shellcheck
    shfmt
    # Up-to-date terminfo tables (checked with `infocmp -x tmux-256color`);
    # .zprofile prepends its bin dir explicitly
    ncurses
    # GNU readline for tools that link it; config is
    # $XDG_CONFIG_HOME/readline/inputrc (zsh uses zle instead)
    readline
    tmux
    tmuxinator

    # ------------------------------------------------------ Git & friends
    git
    git-lfs
    git-absorb
    delta
    gh
    lazygit
    onefetch

    # ------------------------------------------------------- Editors etc.
    neovim
    # From checkhealth: vimtex#view#inverse_search is better if pstree is available
    pstree
    # Linter for lua (used by nvim)
    stylua
    # Required by nvim-treesitter (main branch) to compile parsers
    tree-sitter
    clang-tools # clang-format

    # ------------------------------------------------ Search & navigation
    # Fast `find` alternative; used by telescope.nvim for file listing
    fd
    fzf
    ripgrep
    # Grep AST
    ast-grep
    # Cat alternative + batgrep/batman/batdiff/batpipe/batwatch/prettybat
    bat
    bat-extras.batgrep
    bat-extras.batman
    bat-extras.batdiff
    bat-extras.batpipe
    bat-extras.batwatch
    bat-extras.prettybat
    tree
    mc # midnight commander
    # XDG Base Directory spec-compliant Rust tldr implementation
    tealdeer
    cheat
    # Converts output of unix commands to JSON https://github.com/kellyjonbrazil/jc
    jc
    jq
    yq-go
    # Colorizes common UNIX tools output (GRC - Generic Colorizer)
    grc
    htop
    gotop

    # ------------------------------------------------- Runtimes & toolchains
    # Runtime versions for projects without a flake: reads ~/.tool-versions
    # and per-project .tool-versions/mise.toml, installs prebuilt runtimes
    # (see mise/.config/mise/config.toml). Replaced asdf + pyenv + pipenv;
    # projects with a flake use `use flake` (nix-direnv, direnvrc) instead.
    mise
    # direnv hook in .zshrc/.bashrc; nix-direnv is sourced from direnvrc
    direnv
    nix-direnv
    uv
    # GNU make 4.x as `make` (Apple ships 3.81); brew installed it as gmake
    gnumake
    lua5_4
    luarocks # lua package manager
    # Also ships a bin/lua symlink; lowPrio lets lua5_4's win in the profile
    (lib.lowPrio luajit)
    openjdk
    perl
    php
    ruby
    # One python environment: jupyterlab (the brew formula) + tkinter (the
    # python-tk formula, needed to build Tk-enabled pythons). Two separate
    # python envs would collide on bin/python3.
    (python3.withPackages (
      ps: with ps; [
        jupyterlab
        tkinter
      ]
    ))

    # ----------------------------------------------------- Cloud & infra
    awscli2
    eksctl
    # Ship shell completions (loaded by .zshrc/.bashrc from the profile)
    heroku
    doctl
    hcloud # Hetzner Cloud
    # Grafana Alloy (telemetry collector), used by the grafana-alloy VS Code extension
    grafana-alloy
    # ngrok is the `ngrok` cask (unfree in nixpkgs, and the cask self-updates)
    lazydocker
    # Was installed outside the Brewfile
    act
    actionlint
    # GitHub Actions security audits; `zizmor --lsp` backs the zizmor VS Code
    # extension
    zizmor
    ansible
    ansible-lint
    # terraform was dropped altogether: nothing here uses it (tofu-ls-shim
    # and the editors are wired to OpenTofu) and it is unfree
    opentofu
    sops
    cosign
    crane
    syft
    trivy
    gitleaks
    mkcert
    s3cmd
    supabase-cli
    tailscale
    livekit-cli
    immich-cli

    # ------------------------------------------------------- Databases
    # Provides psql/pg_config/libpq as well - do not add `libpq` separately
    # (it collides). postgresql@16 was also installed; only 18 is kept.
    postgresql_18
    openssl

    # ---------------------------------------------------- Net & transfer
    axel
    mosh
    openvpn
    rclone
    rsync
    # Continuous machine-to-machine sync (daemon/CLI; GUI skipped on purpose)
    syncthing
    # Nice backup tool
    restic
    testdisk
    # Reads/modifies EXIF and video metadata
    exiftool

    # ---------------------------------------------------------- Media
    ffmpeg
    imagemagick
    mpv
    sox
    svgo
    oxipng
    pngquant
    catimg
    # Used for the pdf/image previews (was a brew leaf as `poppler`)
    poppler-utils
    djvulibre
    graphviz
    d2
    cloc

    # --------------------------------------------------------- Documents
    # VimTeX uses latexmk as the default compiler backend; scheme-medium
    # bundles latexmk. Big closure (a few GB), see README.md.
    texliveMedium
    # Backend processor for BibLaTeX (not part of scheme-medium's binaries)
    biber
    # zathura (PDF/DjVu reader) stays in Homebrew: every nixpkgs zathura
    # plugin depends on appstream, which fails to compile on darwin
    # (2026-09, nixpkgs 26.05) - see ../darwin/homebrew.nix

    # ---------------------------------------------------------- macOS
    # To be able to send notifications from the scripts in bin/.local/bin
    terminal-notifier
    # Soft-deletion instead of rm (moves to the macOS Trash)
    darwin.trash
    nginx
    qemu

    # ------------------------------------------------- Security & secrets
    bitwarden-cli
    # ykman
    yubikey-manager
    # pamu2fcfg + pam_u2f.so for /etc/pam.d
    pam_u2f
    gnupg
    pinentry_mac
    # GPG modern analogue (Rust age implementation)
    rage
    age
    # OpenPGP key archival to paper / back
    paperkey
    qrencode
    zbar

    # ------------------------------------------------------- AI agents
    # Was installed outside the Brewfile (the brew formula)
    opencode
    oxlint
    oxfmt
  ];
}
