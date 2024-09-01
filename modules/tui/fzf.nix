{ config, lib, pkgs, ... }:

let
  solarizedLightTheme = [
    "--color fg:240,bg:230,hl:33,fg+:241,bg+:221,hl+:33"
    "--color info:33,prompt:33,pointer:166,marker:166,spinner:33"
  ];
  defaultTheme = [
    "--color 'fg:#F3F5F7'" # Text
    "--color 'bg:#263238'" # Background
    "--color 'preview-fg:#F3F5F7'" # Preview window text
    "--color 'preview-bg:#314549'" # Preview window background
    "--color 'hl:#FFCB6B'" # Highlighted substrings
    "--color 'fg+:#82AAFF'" # Text (current line)
    "--color 'bg+:#314549'" # Background (current line)
    "--color 'gutter:#314549'" # Gutter on the left (defaults to bg+)
    "--color 'hl+:#C792EA'" # Highlighted substrings (current line)
    "--color 'info:#C792EA'" # Info line (match counters)
    "--color 'border:#82AAFF'" # Border around the window (--border and --preview)
    "--color 'prompt:#F3F5F7'" # Prompt
    "--color 'pointer:#C792EA'" # Pointer to the current line
    "--color 'marker:#C792EA'" # Multi-select marker
    "--color 'spinner:#C792EA'" # Streaming input indicator
    "--color 'header:#$F3F5F7'" # Header
  ];
in {
  config = {
    home-manager.users.nhamlh = {
      programs.fzf = {
        enable = true;
        enableZshIntegration = true;

        # CTRL-T
        fileWidgetCommand = "fd --type f --hidden --follow --exclude .git";
        fileWidgetOptions = [ "--preview 'bat --color=always {}'" ]
          ++ solarizedLightTheme;

        # ALT-C
        changeDirWidgetCommand = "fd --type d --hidden --follow --exclude .git";
        changeDirWidgetOptions = [ "--preview 'ls --color=always {}'" ]
          ++ solarizedLightTheme;

        defaultOptions = [
          "--exact"
          "--height 40%"
          "--layout=reverse"
          "--border"
          "--inline-info"
        ] ++ solarizedLightTheme;
      };
    };
  };
}
