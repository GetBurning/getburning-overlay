# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools git-r3

DESCRIPTION="GStreamer plugin for Cedar h264 encoding with no binary blobs"
HOMEPAGE="https://github.com/gtalusan/gst-plugin-cedar"
EGIT_REPO_URI="https://github.com/gtalusan/gst-plugin-cedar"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="static"
RESTRICT="mirror"

RDEPEND="media-libs/gst-plugins-base:1.0"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use_enable static)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
