{ stdenv, fetchFromGitHub, buildPythonApplication,
  # arch-install-scripts
  btrfsProgs,
  cryptsetup,
  debootstrap,
  # dnf
  dosfstools,
  e2fsprogs,
  git,
  gnupg,
  gnutar,
  OVMF,
  qemu,
  sbsigntool,
  squashfsTools,
  xfsprogs,
  xz
  # zypper
}:

buildPythonApplication rec {
  name = "mkosi-${version}";
  version = "4";

  src = fetchFromGitHub {
    owner = "systemd";
    repo = "mkosi";
    rev = "v${version}";
    sha256 = "0d5igpvf06171z76mf0dd128gwd8fgsyk0dfhaw282sx4s4v2w12";
  };

  propagatedBuildInputs = [
    # arch-install-scripts
    btrfsProgs
    cryptsetup
    debootstrap
    # dnf
    dosfstools
    e2fsprogs
    git
    gnupg
    gnutar
    sbsigntool
    squashfsTools
    xfsprogs
    xz
  ]
  ++ stdenv.lib.optionals (OVMF != null) [ OVMF ]
  ++ stdenv.lib.optionals (qemu != null) [ qemu ];

  meta = with stdenv.lib; {
    description = "Build legacy-free OS images";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ tadfisher ];
    platforms = platforms.linux;
  };
}
