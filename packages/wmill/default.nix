{
  buildNpmPackage,
  fetchurl,
}:
buildNpmPackage rec {
  pname = "windmill-cli";
  version = "1.670.0";

  src = fetchurl {
    url = "https://registry.npmjs.org/windmill-cli/-/windmill-cli-${version}.tgz";
    hash = "sha256-EaNVgwUtm0/xUtiphGIFmCTfjxq3PBoD5/NgP8/ZLtI="; # src
  };

  sourceRoot = "package";

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-j3wszG3h2zZyOsFt+8FbbRA+3AQdYSH3vDsjptxCzog=";

  dontNpmBuild = true;

  meta = {
    description = "A command-line tool for interacting with Windmill";
    homepage = "https://www.windmill.dev";
    mainProgram = "wmill";
  };
}
