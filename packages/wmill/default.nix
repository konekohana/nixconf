{
  buildNpmPackage,
  fetchurl,
}:
buildNpmPackage rec {
  pname = "windmill-cli";
  version = "1.642.0";

  src = fetchurl {
    url = "https://registry.npmjs.org/windmill-cli/-/windmill-cli-${version}.tgz";
    hash = "sha256-om35DraPPemA61JLdEJqzOLR9aphi3/Kzgznhvia83o=";
  };

  sourceRoot = "package";

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-sa1hJi3ytGTQDm+CPMpd4rZSEO9No0lsh2IdBxMUkRk=";

  dontNpmBuild = true;

  meta = {
    description = "A command-line tool for interacting with Windmill";
    homepage = "https://www.windmill.dev";
    mainProgram = "wmill";
  };
}
