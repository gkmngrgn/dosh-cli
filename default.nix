{ lib
, python3Packages
}:

with python3Packages;
buildPythonPackage rec {
  pname = "dosh";
  version = "0.1.3";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit version;
    pname = "dosh_cli";
    hash = "sha256-p/qFxZuldQWcPKjAtqLbUbbxx8N5cN78BxekT8+wfBY=";
  };

  let
    myAppEnv = pkgs.poetry2nix.mkPoetryEnv {
      projectDir = ./.;
      editablePackageSources = {
        my-app = ./src;
      };
    };
  in myAppEnv.env.overrideAttrs (oldAttrs: {
    buildInputs = [ pkgs.hello ];
  })

  nativeBuildInputs = [
    poetry-core
  ];

  pythonImportsCheck = [
    "dosh_cli"
    "dosh_core"
  ];

  meta = with lib; {
    description = "Shell-independent task manager.";
    homepage = "https://github.com/gkmngrgn/dosh-cli";
    maintainers = with maintainers; [ gkmngrgn ];
    license = licenses.mit;
    mainProgram = "dosh";
    platforms = platforms.all;
  };
}
