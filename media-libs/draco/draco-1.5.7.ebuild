# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A library for compressing and decompressing 3D geometric meshes and point clouds"
HOMEPAGE="https://github.com/google/draco"

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/google/draco/${PN}.git"
else
	inherit verify-sig
	SRC_URI="https://github.com/google/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86 ~arm64"
fi

LICENSE="Apache-2.0"
SLOT="0"
