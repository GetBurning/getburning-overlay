# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A general-purpose library that generates three-dimensional coherent noise"
HOMEPAGE="https://github.com/SoftFever/Orca-deps-libnoise"

MY_PN="Orca-deps-libnoise"

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/SoftFever/${MY_PN}.git"
else
	inherit verify-sig
	SRC_URI="https://github.com/SoftFever/${MY_PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

S="${WORKDIR}/${MY_PN}-${PV}"
LICENSE="GPL-2"
SLOT="0"
DEPENDS=""
RESTRICT="mirror"
