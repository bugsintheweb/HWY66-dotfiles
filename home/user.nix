{ config, pkgs, ... }:

{
  home.username = "davy";
  home.homeDirectory = "/home/davy";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
  
  programs.git.enable = true;
  programs.zoxide.enable = true;
  programs.zsh.enable = true;
  
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
  };

  programs.librewolf = {
    enable = true;
    profiles.default = {
      isDefault = true;
      settings = {
      "browser.search.defaultenginename" = "DuckDuckGo";
      "browser.search.order.1" = "DuckDuckGo";
      "browser.startup.homepage" = "https://search.nixos.org/packages?channel=26.05" ;
    };
   };
  };

  gtk = {
  enable = true;
  theme = {
    name = "Adwaita-dark";
    package = pkgs.gnome-themes-extra;
  };
  iconTheme = {
    name = "Papirus-Dark";
    package = pkgs.papirus-icon-theme;
  };
  cursorTheme = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
  };
};

  # Required for GSettings to apply properly
  dconf.enable = true;

  home.packages = with pkgs; [
    # Proton apps
    proton-authenticator
    protonmail-desktop   
   ];
  
  home.file.".config/Code/User/settings.json".text = ''
    {
      "editor.formatOnSave": true,
      "files.autoSave": "onFocusChange",
      "terminal.integrated.defaultProfile.linux": "zsh" 
    }
  '';

  home.file.".config/Code/User/keybindings.json".text = ''
   [
     {
       "key": "ctrl+shift+p",
       "command": "workbench.action.showCommands"
     }
   ]
 '';
}
