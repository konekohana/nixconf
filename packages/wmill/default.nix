{
  buildNpmPackage,
  fetchurl,
}:
buildNpmPackage rec {
  pname = "windmill-cli";
  version = "1.644.0";

  src = fetchurl {
    url = "https://registry.npmjs.org/windmill-cli/-/windmill-cli-${version}.tgz";
    hash = "sha256-h6GCR1hpZ0s66teeKagGb4shUlISXRScamELpl39P3g="; # src
  };

  sourceRoot = "package";

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-j7T9xjlU2cgoRVJli0jXXUtq8zOaRR3mbM740CWaX9k=";

  dontNpmBuild = true;

  meta = {
    description = "A command-line tool for interacting with Windmill";
    homepage = "https://www.windmill.dev";
    mainProgram = "wmill";
  };
}
