# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools git-r3

DESCRIPTION="Allwinner CedarX userspace library (GetBurning fork)"
HOMEPAGE="https://github.com/GetBurning/libcedarc"
EGIT_REPO_URI="https://github.com/GetBurning/libcedarc"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
RESTRICT="mirror"

MY_CHOST="arm-linux-gnueabihf"
MY_CSLIB_PATH="library/${MY_CHOST}"

src_prepare() {
	default
	eautoreconf
}

src_compile() {
	# Pre-built ARM .so blobs need -L so the cross-linker can find them.
	# Must pass as make argument since Makefiles bake LDFLAGS at configure time.
	local cspath="${S}/${MY_CSLIB_PATH}"
	emake LDFLAGS="${LDFLAGS} -L${cspath}"
}

src_install() {
	local cspath="${S}/${MY_CSLIB_PATH}"
	emake DESTDIR="${ED}" LDFLAGS="${LDFLAGS} -L${cspath}" install
	find "${ED}" -name '*.la' -delete || die
	dolib.so "${MY_CSLIB_PATH}"/*.so
	insinto /usr/include/libcedarc
	doins include/*.h
}
