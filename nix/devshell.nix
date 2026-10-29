{
  pkgs,
  flutter,
  treefmt,
  hooks,
  ...
}:
{
  devshell = {
    name = "RecallDeck";
    packages = [
      flutter
      pkgs.git
      pkgs.direnv
      pkgs.nix-direnv
      treefmt.config.build.wrapper
    ]
    ++ hooks.enabledPackages;
    startup.git-hooks.text = ''
      if ${pkgs.git}/bin/git rev-parse --git-dir >/dev/null 2>&1; then
        ${hooks.shellHook}
      fi
    '';
  };

  commands = [
    {
      name = "fmt";
      category = "Quality";
      help = "Format source files with treefmt";
      command = ''exec ${treefmt.config.build.wrapper}/bin/treefmt "$@"'';
    }
    {
      name = "check";
      category = "Quality";
      help = "Run sandboxed Nix and formatting checks";
      command = ''
        set -euo pipefail
        cd "$PRJ_ROOT"
        exec nix flake check "$@"
      '';
    }
    {
      name = "doctor";
      category = "Development";
      help = "Show toolchain versions; Android diagnostics are informational";
      command = ''
        set -euo pipefail
        flutter --version
        dart --version
        if ! flutter doctor "$@"; then
          echo "Android setup is deferred; inspect the diagnostics above."
        fi
      '';
    }
    {
      name = "web";
      category = "Development";
      help = "Serve Flutter Web on localhost; open the printed URL in a browser";
      command = ''
        set -euo pipefail
        cd "$PRJ_ROOT"
        exec flutter run -d web-server --web-hostname 127.0.0.1 "$@"
      '';
    }
  ];
}
