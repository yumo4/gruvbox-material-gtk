{
  description = "Gruvbox Material GTK theme + icons packaged for Nix/Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};

        # Installs GTK themes from ./themes into $out/share/themes
        gruvbox-gtk-theme = pkgs.stdenvNoCC.mkDerivation {
          pname = "gruvbox-material-gtk-theme";
          version = "git-${self.shortRev or "dirty"}";

          src = self;

          dontBuild = true;

          installPhase = ''
            runHook preInstall
            mkdir -p $out/share/themes
            cp -r themes/* $out/share/themes/Gruvbox-Material-Dark
            runHook postInstall
          '';

          meta = with pkgs.lib; {
            description = "Gruvbox Material GTK theme";
            license = licenses.mit;
            platforms = platforms.all;
          };
        };

        # Installs icons from ./icons into $out/share/icons
        gruvbox-icons = pkgs.stdenvNoCC.mkDerivation {
          pname = "gruvbox-material-icons";
          version = "git-${self.shortRev or "dirty"}";

          src = self;

          dontBuild = true;

          installPhase = ''
            runHook preInstall
            mkdir -p $out/share/icons
            cp -r icons/* $out/share/icons/
            runHook postInstall
          '';

          meta = with pkgs.lib; {
            description = "Gruvbox Material icon theme";
            license = licenses.mit;
            platforms = platforms.all;
          };
        };
      in {
        packages = {
          gtk-theme = gruvbox-gtk-theme;
          icons = gruvbox-icons;

          # optional convenience default
          default = gruvbox-gtk-theme;
        };
      }
    );
}
