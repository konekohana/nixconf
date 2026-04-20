{
  buildNpmPackage,
  fetchurl,
}:
buildNpmPackage rec {
  pname = "windmill-cli";
  version = "1.687.0";

  src = fetchurl {
    url = "https://registry.npmjs.org/windmill-cli/-/windmill-cli-${version}.tgz";
    hash = "sha256-B6dcRccFyyirraqrx85LUEalQGKhfdN7RtcB5Jzpjss="; # src
  };

  sourceRoot = "package";

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-e/tWMlNpGIiNmuJXA8V5yqdOvcgII083NWqF4Zsf5KI=";

  dontNpmBuild = true;

  meta = {
    description = "A command-line tool for interacting with Windmill";
    homepage = "https://www.windmill.dev";
    mainProgram = "wmill";
  };
}
