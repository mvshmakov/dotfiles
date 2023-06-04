#!/usr/bin/env sh
#
# code --list-extensions | xargs -L 1 echo code --install-extension

set -eu
IFS=$(printf '\n\t')

code --install-extension 1000ch.svgo
code --install-extension aaron-bond.better-comments
code --install-extension adpyke.codesnap
code --install-extension adriano-markovic.c-cpp-makefile-project
code --install-extension akamud.vscode-theme-onedark
code --install-extension alefragnani.project-manager
code --install-extension amazonwebservices.aws-toolkit-vscode
code --install-extension andys8.jest-snippets
code --install-extension arcticicestudio.nord-visual-studio-code
code --install-extension asvetliakov.vscode-neovim
code --install-extension batisteo.vscode-django
code --install-extension blairleduc.touch-bar-display
code --install-extension bradlc.vscode-tailwindcss
code --install-extension bungcip.better-toml
code --install-extension ChakrounAnas.turbo-console-log
code --install-extension christian-kohler.npm-intellisense
code --install-extension christian-kohler.path-intellisense
code --install-extension clinyong.vscode-css-modules
code --install-extension CodeSandbox-io.codesandbox-projects
code --install-extension cschlosser.doxdocgen
code --install-extension cssho.vscode-svgviewer
code --install-extension csstools.postcss
code --install-extension ctcuff.font-preview
code --install-extension DavidAnson.vscode-markdownlint
code --install-extension dbaeumer.vscode-eslint
code --install-extension deerawan.vscode-dash
code --install-extension deque-systems.vscode-axe-linter
code --install-extension DigitalBrainstem.javascript-ejs-support
code --install-extension dnicolson.binary-plist
code --install-extension DominicVonk.parameter-hints
code --install-extension donjayamanne.githistory
code --install-extension donjayamanne.python-environment-manager
code --install-extension donjayamanne.python-extension-pack
code --install-extension dtsvet.vscode-wasm
code --install-extension dunstontc.viml
code --install-extension eamodio.gitlens
code --install-extension esbenp.prettier-vscode
code --install-extension fabiospampinato.vscode-install-vsix
code --install-extension firsttris.vscode-jest-runner
code --install-extension formulahendry.auto-rename-tag
code --install-extension foxundermoon.shell-format
code --install-extension G-Fidalgo.cypress-runner
code --install-extension GitHub.codespaces
code --install-extension GitHub.copilot
code --install-extension GitHub.copilot-labs
code --install-extension github.vscode-github-actions
code --install-extension GitHub.vscode-pull-request-github
code --install-extension GrapeCity.gc-excelviewer
code --install-extension GraphQL.vscode-graphql
code --install-extension GraphQL.vscode-graphql-syntax
code --install-extension Grepper.grepper
code --install-extension Gruntfuggly.todo-tree
code --install-extension hbenl.vscode-test-explorer
code --install-extension IBM.output-colorizer
code --install-extension idered.figma
code --install-extension idleberg.applescript
code --install-extension illixion.vscode-vibrancy-continued
code --install-extension iterative.dvc
code --install-extension jeff-hykin.better-cpp-syntax
code --install-extension jnoortheen.nix-ide
code --install-extension jock.svg
code --install-extension JohnnyMorganz.stylua
code --install-extension KevinRose.vsc-python-indent
code --install-extension leizongmin.node-module-intellisense
code --install-extension letmaik.git-tree-compare
code --install-extension mads-hartmann.bash-ide-vscode
code --install-extension magicstack.MagicPython
code --install-extension malmaud.tmux
code --install-extension mikestead.dotenv
code --install-extension mkhl.direnv
code --install-extension mquandalle.graphql
code --install-extension ms-azuretools.vscode-docker
code --install-extension ms-dotnettools.csharp
code --install-extension ms-ossdata.vscode-postgresql
code --install-extension ms-python.black-formatter
code --install-extension ms-python.isort
code --install-extension ms-python.python
code --install-extension ms-python.vscode-pylance
code --install-extension ms-toolsai.jupyter
code --install-extension ms-toolsai.jupyter-keymap
code --install-extension ms-toolsai.jupyter-renderers
code --install-extension ms-toolsai.vscode-jupyter-cell-tags
code --install-extension ms-toolsai.vscode-jupyter-slideshow
code --install-extension ms-vscode-remote.remote-containers
code --install-extension ms-vscode-remote.remote-ssh
code --install-extension ms-vscode-remote.remote-ssh-edit
code --install-extension ms-vscode-remote.remote-wsl
code --install-extension ms-vscode.cmake-tools
code --install-extension ms-vscode.cpptools
code --install-extension ms-vscode.cpptools-extension-pack
code --install-extension ms-vscode.cpptools-themes
code --install-extension ms-vscode.makefile-tools
code --install-extension ms-vscode.remote-explorer
code --install-extension ms-vscode.remote-server
code --install-extension ms-vscode.test-adapter-converter
code --install-extension ms-vscode.vscode-github-issue-notebooks
code --install-extension ms-vscode.vscode-typescript-next
code --install-extension ms-vsliveshare.vsliveshare
code --install-extension naumovs.color-highlight
code --install-extension nhoizey.gremlins
code --install-extension njpwerner.autodocstring
code --install-extension Orta.vscode-jest
code --install-extension PKief.material-icon-theme
code --install-extension PKief.material-product-icons
code --install-extension pnp.polacode
code --install-extension quicktype.quicktype
code --install-extension redhat.vscode-xml
code --install-extension redhat.vscode-yaml
code --install-extension rust-lang.rust-analyzer
code --install-extension rvest.vs-code-prettier-eslint
code --install-extension Shelex.vscode-cy-helper
code --install-extension sidneys1.gitconfig
code --install-extension streetsidesoftware.code-spell-checker
code --install-extension streetsidesoftware.code-spell-checker-russian
code --install-extension sumneko.lua
code --install-extension svelte.svelte-vscode
code --install-extension sysoev.language-stylus
code --install-extension TabNine.tabnine-vscode
code --install-extension techer.open-in-browser
code --install-extension timonwong.shellcheck
code --install-extension tomoki1207.pdf
code --install-extension twxs.cmake
code --install-extension valentjn.vscode-ltex
code --install-extension VisualStudioExptTeam.intellicode-api-usage-examples
code --install-extension VisualStudioExptTeam.vscodeintellicode
code --install-extension vscode-icons-team.vscode-icons
code --install-extension vscodevim.vim
code --install-extension WakaTime.vscode-wakatime
code --install-extension WallabyJs.quokka-vscode
code --install-extension WallabyJs.wallaby-vscode
code --install-extension wayou.vscode-todo-highlight
code --install-extension wholroyd.jinja
code --install-extension wix.vscode-import-cost
code --install-extension xaver.clang-format
code --install-extension xyz.local-history
code --install-extension yoavbls.pretty-ts-errors
code --install-extension Yummygum.city-lights-icon-vsc
code --install-extension Zignd.html-css-class-completion
code --install-extension znck.grammarly