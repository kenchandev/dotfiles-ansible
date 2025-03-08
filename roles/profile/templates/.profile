. "$HOME/.cargo/env"

if [ -x $HOMEBREW_BIN_DIR/zsh ]; then
  exec $HOMEBREW_BIN_DIR/zsh -l
fi