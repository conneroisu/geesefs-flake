{
  description = "conneroisu/geesefs-flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      pname = "geesefs";
      version = "0.42.0-tigris1";
      src = pkgs.fetchFromGitHub {
        owner = "tigrisdata";
        repo = pname;
        rev = "v${version}";
        sha256 = "sha256-LAokE7cvlYEHfWO7WJlTbfn5MguzGvNaH5kAuGV+0rI=";
      };
    in {
      packages.default = pkgs.buildGo122Module {
        inherit pname version src;
        vendorHash = "sha256-7a0sjl24mIXYo4Ws8GUefo1YRwc80P0Lcmcj5uQ+f50=";
        subPackages = ["."]; # Only build main package

        meta = with pkgs.lib; {
          description = "High-performance, POSIX-ish S3 file system written in Go";
          homepage = "https://github.com/tigrisdata/geesefs";
          license = licenses.asl20;
          maintainers = with maintainers; [conneroisu];
          mainProgram = "geesefs";
        };
      };
    });
}
