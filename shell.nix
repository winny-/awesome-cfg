with import <nixpkgs> {};

mkShell {
  nativeBuildInputs = [
    luaPackages.luacheck
    lua
  ];
}
