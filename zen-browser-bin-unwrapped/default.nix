{
  _7zz,
  adwaita-icon-theme,
  alsa-lib,
  applicationName ? "Zen",
  autoPatchelfHook,
  curl,
  dbus-glib,
  fetchurl,
  gtk3,
  lib,
  libva,
  libXtst,
  patchelfUnstable,
  pciutils,
  pipewire,
  stdenv,
  wrapGAppsHook3,
}:
let
  arch = mozillaPlatforms.${stdenv.hostPlatform.system} or throwSystem;
  binaryName = "zen";
  mozillaPlatforms = {
    aarch64-linux = "linux-aarch64";
    x86_64-linux = "linux-x86_64";
  };
  pname = "zen-browser-bin-unwrapped";
  throwSystem = throw "Unsupported system: ${stdenv.hostPlatform.system}";
  version = "1.19.3b";
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/zen-browser/desktop/releases/download/${version}/zen.${arch}.tar.xz";
    hash =
      {
        x86_64-linux = "sha256-OwPq7s+yIuzWLTe51tQJ1wTOJDf/goZibhewKJ62DJE=";
        aarch64-linux = "sha256-eNRfdVJxRrWfSegG0iC3hyCRRDlltycTJwPt0RBmGYg=";
      }
      .${stdenv.hostPlatform.system} or throwSystem;
  };

  sourceRoot = lib.optional stdenv.hostPlatform.isDarwin ".";

  nativeBuildInputs = [
    wrapGAppsHook3
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    autoPatchelfHook
    patchelfUnstable
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    _7zz
  ];

  buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [
    gtk3
    adwaita-icon-theme
    alsa-lib
    dbus-glib
    libXtst
  ];

  runtimeDependencies = [
    curl
    pciutils
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    libva.out
  ];

  appendRunpaths = lib.optionals (!stdenv.hostPlatform.isDarwin) [
    "${pipewire}/lib"
  ];

  # Firefox uses "relrhack" to manually process relocations from a fixed offset
  patchelfFlags = [ "--no-clobber-old-sections" ];

  # don't break code signing
  dontFixup = stdenv.hostPlatform.isDarwin;

  installPhase = ''
    runHook preInstall

    mkdir -p $prefix/lib $out/bin
    cp -r . $prefix/lib/zen-browser-bin-${version}
    ln -s $prefix/lib/zen-browser-bin-${version}/zen $out/bin/zen

    chmod +x $out/bin/zen

    runHook postInstall
  '';

  passthru = {
    inherit applicationName binaryName;
    libName = "zen-browser-bin-${version}";
    ffmpegSupport = true;
    gssSupport = true;
    gtk3 = gtk3;
  };

  meta = {
    description = "Firefox fork with a focus on looks and privacy (upstream binary release)";
    homepage = "https://zen-browser.app";
    license = lib.licenses.mpl20;
    platforms = builtins.attrNames mozillaPlatforms;
    mainProgram = "zen";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
