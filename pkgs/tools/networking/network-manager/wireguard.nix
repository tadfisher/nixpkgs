{ stdenv, fetchFromGitHub, substituteAll, autoreconfHook, intltool, libxml2, pkgconfig
, kmod, networkmanager, wireguard
, withGnome ? true, gnome3, libsecret, networkmanagerapplet }:

stdenv.mkDerivation rec {
  name = "${pname}${if withGnome then "-gnome" else ""}-${version}";
  pname = "NetworkManager-wireguard";
  version = "0.0.20180503";

  src = fetchFromGitHub {
    owner = "max-moser";
    repo = "network-manager-wireguard";
    rev = "fc454a8101d78c7b0da382d12c9d8292bb9f6b56";
    sha256 = "1dvl0r031sq9p31a4vgpwbz61mfdqmrfj8p087nz4rcal0zqzspd";
  };

  patches = [
    (substituteAll {
      src = ./wireguard-fix-paths.patch;
      inherit kmod wireguard;
    })
  ];

  nativeBuildInputs = [ autoreconfHook intltool libxml2 pkgconfig ];

  buildInputs = [ networkmanager ]
    ++ stdenv.lib.optionals withGnome [ gnome3.gtk gnome3.networkmanagerapplet libsecret ];

  configureFlags = [
    "${if withGnome then "--with-gnome" else "--without-gnome"}"
    "--disable-static"
    "--enable-absolute-paths"
  ];

  preConfigure = ''
    # autoreconfHook doesn't seem to generate po/Makefile.in on its own
    ./autogen.sh
  '';

  meta = with stdenv.lib; {
    description = "NetworkManager wireguard plugin";
    homepage = https://github.com/max-moser/network-manager-wireguard;
    maintainers = [ maintainers.tadfisher ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
