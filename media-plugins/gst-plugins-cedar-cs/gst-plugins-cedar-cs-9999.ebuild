# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 autotools

DESCRIPTION="GStreamer plugin for Cedar h264 encoding using closed source library"
HOMEPAGE="https://github.com/peteallenm/gst-plugin-cedar-cs"
SRC_URI=""
EGIT_REPO_URI="https://github.com/peteallenm/gst-plugin-cedar-cs"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""
RESTRICT="mirror"

RDEPEND="media-libs/gst-plugins-base:1.0
	media-libs/libcedarc
	!media-plugins/gst-plugins-cedar"
DEPEND="${RDEPEND}"

src_prepare() {
	eautoreconf
	eapply_user
}

src_configure() {
	econf
}

src_compile() {
	emake CPATH="${CPATH}:/usr/include/libcedarc"
}

src_install() {
	emake "DESTDIR=${D}" install
	rm "${D}"/usr/lib/gstreamer-1.0/libgstcedar_h264enc.la || die
}
