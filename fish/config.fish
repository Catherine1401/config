# Fish configuration, mirroring the PATH and environment set in zsh/.zshrc.
# zsh-only tooling (oh-my-zsh, powerlevel10k, nvm, conda, sdkman) is not ported.

# --- PATH -------------------------------------------------------------------
# Prepend only entries that are missing, so nested shells don't grow duplicates.
set -l extra_paths \
  $HOME/.local/bin \
  $HOME/bin \
  $HOME/apps/nvim-linux-x86_64/bin \
  $HOME/.opencode/bin \
  $HOME/.bun/bin \
  $HOME/.pub-cache/bin \
  $HOME/go/bin \
  $HOME/sdk/go/bin \
  $HOME/lib_bin/shared/scripts \
  $HOME/Android/Sdk/cmdline-tools/latest/bin \
  $HOME/Android/Sdk/platform-tools

set -l new_paths
for dir in $extra_paths
    contains -- $dir $PATH; or set -a new_paths $dir
end
set -gx PATH $new_paths $PATH

# --- Environment ------------------------------------------------------------
set -gx ANDROID_HOME $HOME/Android/Sdk
set -gx GRADLE_OPTS "-Dorg.gradle.parallel=true -Dorg.gradle.vfs.watch=true"
set -gx GTK_IM_MODULE ibus
set -gx QT_IM_MODULE ibus
set -gx XMODIFIERS @im=ibus
set -gx GLFW_IM_MODULE ibus
test -d $HOME/miniconda3/lib; and set -gx LIBCLANG_PATH $HOME/miniconda3/lib
test -r $HOME/.config/fish/secrets.fish; and source $HOME/.config/fish/secrets.fish

# --- Aliases ----------------------------------------------------------------
alias obsidian='$HOME/Applications/Obsidian.AppImage'

# --- yazi: cd to the last visited directory on quit -------------------------
function y
    set -l tmp (mktemp -t yazi-cwd.XXXXXX)
    command yazi $argv --cwd-file="$tmp"
    read -l -z cwd <"$tmp"
    test "$cwd" != "$PWD"; and test -d "$cwd"; and cd -- "$cwd"
    rm -f -- "$tmp"
end

# --- Prompt ----------------------------------------------------------------
set -g fish_greeting ""
