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
      "browser.startup.homepage" = "https://duckduckgo.com";
    };
   };
  };

  home.packages = with pkgs; [
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
