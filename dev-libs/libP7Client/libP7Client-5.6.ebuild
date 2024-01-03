# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Cross-platform library for high-speed trace and telemetry"
HOMEPAGE="http://baical.net/p7.html"
SRC_URI="http://baical.net/files/libP7Client_v${PV}.zip"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"
IUSE="+shared static-libs doc"
RESTRICT="mirror"

RDEPEND=""
DEPEND="${RDEPEND}"
BDEPEND="app-arch/unzip"

src_unpack() {
	mkdir "${S}" && cd "${S}" && unpack ${A} || die
}
src_configure() {
	local mycmakeargs=("-Wno-dev"
					   "-DP7_BUILD_SHARED=ON")
	cmake_src_configure

}

src_install() {
	if use shared; then
		doheader "${S}"/Headers/*.h
		newlib.so "${BUILD_DIR}/Sources/libp7-shared.so" libp7.so
		dosym libp7.so /usr/$(get_libdir)/libp7-shared.so
	fi
	use static-libs && dolib.a "${BUILD_DIR}/Sources/libp7.a"
	use doc && "${S}/Documentation/P7.pdf"
}
