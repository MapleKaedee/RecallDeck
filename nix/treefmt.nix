{ ... }:
{
  projectRootFile = "flake.nix";
  programs = {
    nixfmt.enable = true;
    dart-format.enable = true;
    prettier = {
      enable = true;
      includes = [
        "*.md"
        "*.yaml"
        "*.yml"
        "*.json"
      ];
    };
    shfmt.enable = true;
  };
  settings = {
    global.excludes = [
      ".direnv/**"
      ".data/**"
      ".dart_tool/**"
      ".idea/**"
      ".git/**"
      "build/**"
      "android/.gradle/**"
      "android/.kotlin/**"
      "android/local.properties"
      ".flutter-plugins*"
      ".pre-commit-config.yaml"
      "flake.lock"
      "pubspec.lock"
      "*.g.dart"
      "*.freezed.dart"
      "*.mocks.dart"
      "**/generated_plugin_registrant.*"
    ];
    formatter.shfmt.includes = [
      "*.sh"
      ".envrc"
    ];
  };
}
