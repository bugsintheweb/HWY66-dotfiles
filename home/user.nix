{ pkgs, config, zen-browser, ... }: {

  home.username = "davy";
  home.homeDirectory = "/home/davy";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  fonts.fontconfig.enable = true;

  # =========================================================================
  # ADD MAKO NOTIFICATION SERVICE HERE
  # =========================================================================
  services.mako = {
    enable = true;
    settings = {
    default-timeout = 5000;
    };
  };

  # Git Configuration
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "davy";
        email = "306048104+bugsintheweb@users.noreply.github.com";
      };
    };
  };

  programs.zoxide.enable = true;
  programs.zsh.enable = true;

  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
  };

  dconf.enable = true;

  # =========================================================================
  # PACKAGES & TOOLS
  # =========================================================================
  home.packages = with pkgs; [
    proton-authenticator
    protonmail-desktop   
    fuzzel        
    alacritty     
    waybar
    awww
    xwayland-satellite # Allows X11 apps to run inside Niri
    zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    swaylock-effects

    # Fonts
    font-awesome
    nerd-fonts.jetbrains-mono
    
    # Omarchy-style CLI utilities
    ripgrep
    fd
    eza
    bat
    fzf
    lazygit
    wl-clipboard

    # AI Agent Harness
    aider-chat

    # Custom Workflow Menu
    (pkgs.writeShellScriptBin "workflow-panel" ''
      OPTIONS="🌐 Open Zen Browser\n📬 Launch Proton Mail Stack\n💻 Open VS Code Projects\n🔄 Reboot System\n🛑 Shutdown Workstation"

      CHOICE=$(echo -e "$OPTIONS" | ${pkgs.fuzzel}/bin/fuzzel --dmenu --prompt="Workflow Tasks: " --lines=5)

      case "$CHOICE" in
        *"Open Zen Browser"*)
          zen-browser ;;
        *"Launch Proton Mail Stack"*)
          protonmail-desktop & proton-authenticator ;;
        *"Open VS Code Projects"*)
          code ~/nixos-workstation ;;
        *"Reboot System"*)
          systemctl reboot ;;
        *"Shutdown Workstation"*)
          systemctl poweroff ;;
      esac
    '')
  ];

  # =========================================================================
  # FUZZEL CONFIGURATION 
  # =========================================================================

  xdg.configFile."fuzzel/fuzzel.ini".text = ''
    [colors]
    background=1a1b26ff
    text=c0caf5ff
    match=7aa2f7ff
    selection=33467cff
    selection-text=c0caf5ff
    border=7aa2f7ff

    [main]
    font=JetBrains Mono:size=13
    dpi-aware=no
    prompt="❯ "
    icon-theme=Papirus-Dark
    lines=10
    width=40
    horizontal-pad=20
    vertical-pad=20
    inner-pad=10

    [border]
    width=2
    radius=8
  '';


  # =========================================================================
  # NIRI SCROLLING TILE MANAGER CONFIGURATION
  # =========================================================================
  xdg.configFile."niri/config.kdl".text = ''
    // Layout and Window Styling
    layout {
      gaps 8
      center-focused-column "never"

      preset-column-widths {
        proportion 0.33333
        proportion 0.5
        proportion 0.66667
      }

      default-column-width { proportion 0.5; }

      focus-ring {
        width 2
        active-color "#${config.lib.stylix.colors.base0D}"
        inactive-color "#${config.lib.stylix.colors.base02}"
      }
    }
   
     prefer-no-csd

     window-rule {
       geometry-corner-radius 12
       clip-to-geometry true
    }

    // Autostart background processes
    spawn-at-startup "sh" "-c" "awww-daemon & sleep 0.5 && awww img ${./wallpaper.jpg}"
    spawn-at-startup "waybar"
    spawn-at-startup "xwayland-satellite"
    spawn-at-startup "mako"    

    // Input configuration
    input {
      keyboard {
        xkb {
          layout "us"
        }
      }
      touchpad {
        tap
        natural-scroll
      }
      focus-follows-mouse
    }

    // Keybindings
    binds {
      // Core launchers
      Mod+Shift+Slash { show-hotkey-overlay; }
      Mod+Return { spawn "alacritty"; }
      Mod+D { spawn "fuzzel"; }
      Mod+Alt+Space { spawn "workflow-panel"; }

      // Window controls
      Mod+Shift+Q { close-window; }
      Mod+Shift+E { quit; }
      Mod+F { maximize-column; }
      Mod+Shift+F { fullscreen-window; }
      Mod+Alt+L { spawn "swaylock" "--screenshots" "--clock" "--indicator" "--effect-blur" "7x5"; }

      // Vim-style Column & Window navigation
      Mod+H { focus-column-left; }
      Mod+L { focus-column-right; }
      Mod+J { focus-window-down; }
      Mod+K { focus-window-up; }

      // Column & Window movement
      Mod+Shift+H { move-column-left; }
      Mod+Shift+L { move-column-right; }
      Mod+Shift+J { move-window-down; }
      Mod+Shift+K { move-window-up; }

      // Workspace switching (vertical navigation in Niri)
      Mod+1 { focus-workspace 1; }
      Mod+2 { focus-workspace 2; }
      Mod+3 { focus-workspace 3; }
      Mod+4 { focus-workspace 4; }

      Mod+Shift+1 { move-window-to-workspace 1; }
      Mod+Shift+2 { move-window-to-workspace 2; }
      Mod+Shift+3 { move-window-to-workspace 3; }
      Mod+Shift+4 { move-window-to-workspace 4; }

      // Column resizing
      Mod+R { switch-preset-column-width; }
      Mod+Minus { set-column-width "-10%"; }
      Mod+Equal { set-column-width "+10%"; }
    }
  '';

  # =========================================================================
  # WAYBAR FOR NIRI
  # =========================================================================
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 38;
        spacing = 12;
        margin-top = 6;
        margin-left = 10;
        margin-right = 10;

        modules-left = [ "niri/workspaces" "niri/window" ];
        modules-center = [ "clock" ];
        modules-right = [ "network" "cpu" "memory" "pulseaudio" "tray" ];

        "niri/workspaces" = {
          format = "{index}";
          all-outputs = true;
        };

        "niri/window" = {
          format = "{}";
          max-length = 40;
          separate-outputs = true;
        };

        "clock" = {
          format = "{:%H:%M  %a, %b %d}";
        };

        "cpu" = {
          format = "󰻠 {usage}%";
          tooltip = false;
        };

        "memory" = {
          format = "󰍛 {}%";
        };

        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-bluetooth = "{icon}󰂯 {volume}%";
          format-muted = "󰝟 Muted";
          format-icons = {
            headphone = "󰋋";
            hands-free = "󰋋";
            headset = "󰋋";
            phone = "󰏲";
            portable = "󰏲";
            default = ["󰕿" "󰖀" "󰕾"];
          };
          on-click = "pavucontrol";
        };

        "network" = {
          format-wifi = "󰖩 {essid}";
          format-ethernet = "󰈀 Wired";
          format-disconnected = "󰖪 Offline";
          tooltip-format = "{ipaddr} ({signalStrength}%)";
        };
      };
    };
    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font", monospace;
        font-size: 13px;
        min-height: 0;
        border: none;
        box-shadow: none;
        text-shadow: none;
      }

      window#waybar {
        background-color: rgba(26, 27, 38, 0.85);
        color: #c0caf5;
        border-radius: 8px;
      }

      #workspaces {
        margin: 4px 6px;
        padding: 0;
        border: none;
      }

      #workspaces button {
        padding: 2px 8px;
        margin: 0 3px;
        color: #a9b1d6;
        background: transparent;
        border-radius: 6px;
        border: none;
        box-shadow: none;
        transition: all 0.2s ease;
      }

      #workspaces button:hover {
        background: #24283b;
        color: #c0caf5;
      }

      #workspaces button.active,
      #workspaces button.focused {
        background-color: #7aa2f7;
        color: #1a1b26;
        font-weight: bold;
        border: none;
      }

      #network,
      #cpu,
      #memory,
      #pulseaudio,
      #clock,
      #tray,
      #window {
        padding: 2px 10px;
        margin: 4px 2px;
        border-radius: 6px;
        background-color: rgba(36, 40, 59, 0.7);
        color: #c0caf5;
      }

      #pulseaudio.muted {
        color: #f7768e;
      }

      #network.disconnected {
        color: #f7768e;
      }
    '';  
  };
}
