{
  config,
  lib,
  pkgs,
  ...
}:

{
  config = {
    environment.systemPackages = with pkgs; [
      tree-sitter
      # Got errors installing grammars with home-manager thus installing at system level
      tree-sitter-grammars.tree-sitter-yaml
      tree-sitter-grammars.tree-sitter-ruby
      tree-sitter-grammars.tree-sitter-python
      tree-sitter-grammars.tree-sitter-go
      tree-sitter-grammars.tree-sitter-gomod
      tree-sitter-grammars.tree-sitter-elisp
      tree-sitter-grammars.tree-sitter-dockerfile
      tree-sitter-grammars.tree-sitter-cmake
      tree-sitter-grammars.tree-sitter-bash
      tree-sitter-grammars.tree-sitter-sql
      tree-sitter-grammars.tree-sitter-toml
      tree-sitter-grammars.tree-sitter-regex
      tree-sitter-grammars.tree-sitter-nix
      tree-sitter-grammars.tree-sitter-markdown
      tree-sitter-grammars.tree-sitter-lua
      tree-sitter-grammars.tree-sitter-latex
      tree-sitter-grammars.tree-sitter-json
      tree-sitter-grammars.tree-sitter-json5
      tree-sitter-grammars.tree-sitter-javascript
      tree-sitter-grammars.tree-sitter-html
      tree-sitter-grammars.tree-sitter-hcl

    ];

    home-manager.users.nhamlh = {
      #TODO: setup doomemacs properly according to https://github.com/doomemacs/doomemacs/blob/master/docs/getting_started.org#doom-emacs
      programs.emacs = {
        enable = true;
        package = pkgs.emacs30;
        extraPackages = epkgs: [ epkgs.vterm ];
      };

      xdg.configFile."doom".source = ./doom;
    };
  };
}
