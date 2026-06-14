# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools git-r3

DESCRIPTION="GStreamer plugin for Cedar h264 encoding using closed source library"
HOMEPAGE="https://github.com/peteallenm/gst-plugin-cedar-cs"
EGIT_REPO_URI="https://github.com/peteallenm/gst-plugin-cedar-cs"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
RESTRICT="mirror"

RDEPEND="
	media-libs/gst-plugins-base:1.0
	media-libs/libcedarc
	!media-plugins/gst-plugins-cedar
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	eautoreconf
}

src_compile() {
	emake CPATH="${CPATH}:/usr/include/libcedarc"
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
