function mkcd() {
  local _ARV="$@"
  mkdir -p $_ARV || return 2

  builtin cd $_ARV
}

# Create a file/folder under /tmp if not exist
# Jump to folder or open file with EDITOR
function tmp() {
  while (( $# )); do
    case "$1" in
    "-d")
      mkdir "$HOME/tmp/$2" 2> /dev/null
      cd "$HOME/tmp/$2"
      shift
      shift
      ;;
    *)
      $EDITOR "$HOME/tmp/$1"
      shift
    esac
  done
}

# Quickly boostrap a dev environment
function dev() {
  tmux_panes=$(tmux list-panes | wc -l)

  if ! [[ $tmux_panes -eq 1 ]]; then
    tmux new-window
  fi

  tmux rename-window $(basename $PWD)
  tmux split-pane -l 12
  tmux send-key -t 0 "vi" Enter
  tmux select-pane -t 0
}

