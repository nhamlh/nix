{ config, lib, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "nhamlh";
  home.homeDirectory = "/home/nhamlh";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    exa
    fd
    kubectl
    k9s
    yq
    ripgrep
    fzf
    diff-so-fancy
    bat
    zenith
    nvtop
  ] ++ [ # more cli tools
    feh
    scrot
    unzip
    xclip
  ] ++ [ # GUI tools
    alacritty
    firefox
    chromium
    tdesktop
  ];
  programs.emacs.enable = true;

  programs.git = {
    enable = true;

    userName = "Nham Hoai Le";
    userEmail = "lehoainham@gmail.com";

    ignores = [ "*~" "*.swp" ];

    diff-so-fancy = {
      enable = true;
    };

    extraConfig = {
      init.defaultBranch = "master"; # based.
      core.editor = "nvim";
      credential.helper = "store --file ~/.git-credentials";
      pull.rebase = "false";
      # For supercede
      core.symlinks = true;
    };
  };

  xdg.configFile."tmux/tmux.conf".source = ./tmux.conf;
  xdg.configFile."alacritty/alacritty.yml".source = ./alacritty.yml;
  xdg.configFile."compton.conf".source = ./compton.conf;
  xdg.configFile."doom".source = ./doom;
  xdg.configFile."i3".source = ./i3;
  xdg.configFile."rofi".source = ./rofi;
  home.file.".zshrc".source = ./zshrc;
  home.file.".zsh.d".source = ./zsh.d;
}
