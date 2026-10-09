# Pi coding agent (npm). The published tarball ships prebuilt dist/, so there is
# no TypeScript build step — only runtime deps are installed from the shrinkwrap.
#
# Bump: change `version`, update the tarball `sha256`
# (e.g. `nix-prefetch-url <url>`), then refresh npmDepsHash:
#   nix run nixpkgs#prefetch-npm-deps -- <extracted package/npm-shrinkwrap.json>
{ lib, buildNpmPackage, fetchurl }:

buildNpmPackage {
  pname = "pi-coding-agent";
  version = "0.83.0";

  src = fetchurl {
    url =
      "https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-0.83.0.tgz";
    sha256 = "7097fe4b38762dda7ec78001e7b90430c849fbaf717325bfe8109744e32255e6";
  };

  # dist/ is already compiled in the published tarball.
  dontNpmBuild = true;

  # TODO: replace after first build — `nixos-rebuild` (or `nix build .#pi-coding-agent`)
  # will fail here and print the correct sha256 to paste.
  npmDepsHash = lib.fakeSha256;

  meta = with lib; {
    description = "Coding agent CLI with read, bash, edit, write tools and session management";
    homepage = "https://github.com/earendil-works/pi";
    license = licenses.mit;
    mainProgram = "pi";
  };
}
