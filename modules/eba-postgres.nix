{pkgs, ...}: {
  specialisation.work.configuration = {
    services.postgresql = {
      enable = true;
      ensureDatabases = ["connect"];
      enableTCPIP = true;
      ensureUsers = [
        {
          name = "portchain";
          ensureClauses = {
            login = true;
            createrole = true;
            superuser = true;
          };
        }
      ];
      authentication = pkgs.lib.mkOverride 10 ''
        #type database  DBuser  auth-method
        local all       all     trust
        host  all       all     all         trust
      '';
      extensions = ps: with ps; [postgis];
    };
  };
}
