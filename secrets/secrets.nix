let
  key =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKmPhGYUluyUQ2j/pcF+2hyC38HBMnkyPYd3Mq3IlI8d nhamlh@somewhereonearth";
in {
  "tskey.age".publicKeys = [ key ];
  "ga-prom-key.age".publicKeys = [ key ];
  "ga-loki-key.age".publicKeys = [ key ];
}
