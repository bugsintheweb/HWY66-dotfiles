{
  description = "NixOS HWY66 config with Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";  
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    stylix.url = "github:danth/stylix/release-26.05";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, zen-browser, stylix, ... }:
    let
      system = "x86_64-linux";
      username = "davy";
      hostname = "HWY66";
    in {
      nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit zen-browser; };

        modules = [
          ./hosts/HWY66/configuration.nix

          stylix.nixosModules.stylix

({ pkgs, ... }: {
            stylix = {
              enable = true;
              image = ./home/wallpaper.jpg; 
              base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml"; 
              polarity = "dark";

              fonts = {
                monospace = {
                  package = pkgs.jetbrains-mono;
                  name = "JetBrains Mono";
                };
                sansSerif = {
                  package = pkgs.noto-fonts;
                  name = "Noto Sans";
                };
              };

              targets.gtk.enable = true;
            };

            programs.niri.enable = true;
            
            xdg.portal = {
              enable = true;
              extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
              config.common.default = "*";
            };
          })

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;    
            home-manager.extraSpecialArgs = { inherit zen-browser; };
            home-manager.users.${username} = import ./home/user.nix;
          }
        ];
      };
    };
}
