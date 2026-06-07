_: {
  nix.buildMachines = [
    {
      hostName = "spoodythe.one";
      sshUser = "baritone";
      protocol = "ssh-ng";
      sshKey = "/etc/ssh/ssh_host_ed25519_key";
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      maxJobs = 4;
      speedFactor = 2;
      supportedFeatures = [
        "nixos-test"
        "benchmark"
        "big-parallel"
        "kvm"
      ];
    }
  ];
  nix.distributedBuilds = true;
  nix.extraOptions = ''
    	  builders-use-substitutes = true
    	'';
}
