{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.my.modules.graphical;

  # bash script to let dbus know about important env variables and
  # propagate them to relevent services run at the end of sway config
  # see
  # https://github.com/emersion/xdg-desktop-portal-wlr/wiki/"It-doesn't-work"-Troubleshooting-Checklist
  # note: this is pretty much the same as  /etc/sway/config.d/nixos.conf but also restarts
  # some user services to make sure they have the correct environment variables
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;

    text = ''
      # announce a running sway session to systemd
      systemctl --user import-environment XDG_SESSION_TYPE XDG_CURRENT_DESKTOP

      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
      systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
    '';
  };

  # currently, there is some friction between sway and gtk:
  # https://github.com/swaywm/sway/wiki/GTK-3-settings-on-Wayland
  # the suggested way to set gtk settings is with gsettings
  # for gsettings to work, we need to tell it where the schemas are
  # using the XDG_DATA_DIR environment variable
  # run at the end of sway config
  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text = let
      schema = pkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/gsettings-schemas/${schema.name}";
    in ''
      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
      gnome_schema=org.gnome.desktop.interface
      gsettings set $gnome_schema gtk-theme 'Dracula'
      gsettings set $gnome_schema text-scaling-factor 1.375
      gsettings set $gnome_schema cursor-size 32
    '';
  };

  screenshot = pkgs.writeTextFile {
    name = "screenshot";
    destination = "/bin/screenshot";
    executable = true;
    text = ''
      FILE=$HOME/Screenshots/$(date "+%Y-%m-%d-%H%M%S").png
      if [[ $@ == "-g" ]]; then
         grim -g "$(slurp)" - | tee $FILE | wl-copy
      else
         grim  - | tee $FILE | wl-copy
      fi
    '';
  };
in {
  config = mkIf cfg.enable {
    home-manager.users.nhamlh = {
      home.packages = with pkgs; [
        sway
        swaylock
        swayidle
        i3status-rust # FIXME: do not depends on i3status-rs
        grim # screenshot functionality
        slurp # screenshot functionality
        wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
        bemenu # wayland clone of dmenu
        dracula-theme # gtk theme
        gnome3.adwaita-icon-theme # default gnome cursors
        xdg-utils # for openning default programms when clicking links
        glib # gsettings
        dbus-sway-environment
        configure-gtk
        screenshot
      ];

      xdg.configFile."sway/config".source = ./sway/config;
      # FIXME: do not depends on i3status-rs
      xdg.configFile."sway/i3status-rs.toml".source = ./i3/i3status-rs.toml;
    };

    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };

  };
}
