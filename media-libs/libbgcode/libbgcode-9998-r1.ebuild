# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Prusa Block & Binary G-code reader / writer / converter"
HOMEPAGE="https://github.com/prusa3d/libbgcode"
COMMIT="27ebf16e920a57ee061c098b1ad37120b05f4922"
SRC_URI="https://github.com/prusa3d/${PN}/archive/${COMMIT}.tar.gz"

S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror"
# TODO: python use and bindings

RDEPEND="dev-libs/boost
	media-libs/heatshrink
	<dev-cpp/catch-3.0"
DEPEND="${RDEPEND}"
BDEPEND=""
