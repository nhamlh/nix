{ config, lib, pkgs, agenix, ... }:

{
   environment.systemPackages = [
     agenix.defaultPackage.x86_64-linux
   ];

   age = {
     identityPaths = ["${config.users.users.nhamlh.home}/.ssh/id_ed25519"];
     secrets.tskey.file = ./secrets/tskey.age;
   };
}
