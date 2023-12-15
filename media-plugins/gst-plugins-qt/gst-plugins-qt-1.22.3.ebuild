# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GST_ORG_MODULE=gst-plugins-good

inherit gstreamer-meson qmake-utils

DESCRIPTION="Video sink plugin for GStreamer that renders to QML (qtglsink)"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="orc wayland"

RDEPEND=">=media-libs/gst-plugins-base-${PV}:${SLOT}[${MULTILIB_USEDEP},opengl,X]
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtdeclarative:5[widgets]
	dev-qt/qtx11extras:5
	wayland? ( dev-qt/qtwayland:5 )
	media-libs/libglvnd
"
DEPEND="${RDEPEND}"

GST_PLUGINS_ENABLED="qt5"

multilib_src_configure() {
	local emesonargs=(
		-Dqt5=enabled
	)
	export PATH="$(qt5_get_bindir):${PATH}"
	gstreamer_multilib_src_configure
}
