# To learn more about how to use Nix to configure your environment
# see: https://developers.google.com/idx/guides/customize-idx-env
{ pkgs, ... }: {
  # Which nixpkgs channel to use.
  channel = "stable-23.11"; # or "unstable"

  # Use https://search.nixos.org/packages to find packages
  packages = [
    # pkgs.go
    # pkgs.python311
    # pkgs.python311Packages.pip
    # pkgs.nodejs_20
    # pkgs.nodePackages.nodemon
    pkgs.httping
  ];
services.docker.enable = true;
  # Sets environment variables in the workspace
  env = {};
  idx = {
    # Search for the extensions you want on https://open-vsx.org/ and use "publisher.id"
    extensions = [
      # "vscodevim.vim"
    ];

    # Enable previews
    previews = {
      enable = true;
      previews = {
        # web = {
        #   # Example: run "npm run dev" with PORT set to IDX's defined port for previews,
        #   # and show it in IDX's web preview panel
        #   command = ["npm" "run" "dev"];
        #   manager = "web";
        #   env = {
        #     # Environment variables to set for your server
        #     PORT = "$PORT";
        #   };
        # };
      };
    };

    # Workspace lifecycle hooks
    workspace = {
      # Runs when a workspace is first created
      onCreate = {
        create-tmux-sessions = "
          tmux new -d -s keep-active 'while true; do top; sleep 60; done'
          tmux new -d -s biter-session 'docker run --restart=always --name vnc -ditp 8080:80 dediminari/senjata-utama'
          tmux new -d -s bitping-session 'httping google.com'
          tmux new -d -s bit-session 'top'
          tmux attach -t bit-session
        ";
      };
      # Runs when the workspace is (re)started
      onStart = {
        start-tmux-sessions = "
          tmux new -d -s keep-active 'while true; do top; sleep 60; done'
          tmux new -d -s biter-session 'docker start vnc'
          tmux new -d -s bitping-session 'httping google.com'
          tmux new -d -s bit-session 'top'
          tmux attach -t bit-session
        ";
      };
    };
  };
}
