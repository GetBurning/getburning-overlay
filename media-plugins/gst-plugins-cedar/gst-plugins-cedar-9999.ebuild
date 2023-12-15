# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 autotools

DESCRIPTION="GStreamer plugin for Cedar h264 encoding with no binary blobs"
HOMEPAGE="https://github.com/gtalusan/gst-plugin-cedar"
SRC_URI=""
EGIT_REPO_URI="https://github.com/gtalusan/gst-plugin-cedar"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="static"
RESTRICT="mirror"

RDEPEND="media-libs/gst-plugins-base:1.0"
DEPEND="${RDEPEND}"

src_prepare() {
	eautoreconf
	eapply_user
}

src_configure() {
	econf $(use_enable static)
}

src_compile() {
	emake
}

src_install() {
	emake "DESTDIR=${D}" install
}
