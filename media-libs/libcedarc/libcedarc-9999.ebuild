# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 autotools

DESCRIPTION="Allwinner CedarX userspace library (GetBurning fork)"
HOMEPAGE="https://github.com/GetBurning/libcedarc"
SRC_URI=""
EGIT_REPO_URI="https://github.com/GetBurning/libcedarc"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""
RESTRICT="mirror"

RDEPEND=""
DEPEND="${RDEPEND}"

MY_CHOST="arm-linux-gnueabihf"
MY_CSLIB_PATH="library/${MY_CHOST}"

src_prepare() {
	eautoreconf
	eapply_user
}

src_configure() {
	econf
}

src_compile() {
	emake \
		LIBRARY_PATH="${S}/${MY_CSLIB_PATH}"
}

src_install() {
	emake \
		"DESTDIR=${D}" \
		LIBRARY_PATH="${S}/${MY_CSLIB_PATH}" \
		install
	rm "${D}"/usr/lib/*.la || die
	dolib.so "${MY_CSLIB_PATH}"/*.so
	insinto /usr/include/libcedarc
	doins include/*.h
}
