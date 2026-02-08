{
  description = "Gruvbox Material GTK Theme and Icons";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    packages.${system} = {
      gruvbox-material-gtk = pkgs.stdenv.mkDerivation {
        pname = "gruvbox-material-gtk";
        version = "unstable";

        src = ./.;

        dontBuild = true;

        installPhase = ''
          runHook preInstall

          mkdir -p $out/share/themes
          cp -r themes/* $out/share/themes/

          mkdir -p $out/share/icons
          cp -r icons/* $out/share/icons/

          runHook postInstall
        '';

        meta = {
          description = "Gruvbox Material theme for GTK and icons";
          license = pkgs.lib.licenses.mit;
        };
      };

      default = self.packages.${system}.gruvbox-material-gtk;
    };
  };
}
