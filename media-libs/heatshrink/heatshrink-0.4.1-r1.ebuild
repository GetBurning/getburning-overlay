# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="data compression library for embedded/real-time systems"
HOMEPAGE="https://github.com/atomicobject/heatshrink"

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/atomicobject/${PN}.git"
else
	inherit verify-sig
	SRC_URI="https://github.com/atomicobject/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="ISC"
SLOT="0"

src_prepare() {
	cp "${FILESDIR}/"{CMakeLists.txt,Config.cmake.in} "${S}/" || die
	cmake_src_prepare
}
