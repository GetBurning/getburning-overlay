# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 cmake

DESCRIPTION="Ground control station for drones"
HOMEPAGE="https://qgroundcontrol.com/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/mavlink/qgroundcontrol"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="+vaapi alsa pulseaudio jack"
RESTRICT="mirror"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtquickcontrols2:5[widgets]
	dev-qt/qtdeclarative:5[widgets]
	dev-qt/qtmultimedia:5
	dev-qt/qtwidgets:5
	dev-qt/qtcharts:5[qml]
	dev-qt/qtpositioning:5[qml]
	dev-qt/qtlocation:5
	dev-qt/qtserialport:5
	dev-qt/qtspeech:5
	dev-qt/qttest:5
	dev-qt/qtxml:5
	dev-qt/qtsql:5
	dev-qt/qtnetwork:5
	dev-qt/qtx11extras:5

	media-libs/libsdl2
	dev-libs/glib:2
	sys-libs/zlib
	dev-cpp/eigen
	sci-libs/shapelib

	media-libs/gstreamer:1.0
	media-libs/gst-plugins-good:1.0
	media-libs/gst-plugins-base:1.0[alsa?]
	media-plugins/gst-plugins-qt:1.0
	pulseaudio? ( media-plugins/gst-plugins-pulse:1.0 )
	jack? ( media-plugins/gst-plugins-jack:1.0 )
	vaapi? ( media-plugins/gst-plugins-vaapi:1.0 )
"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -i -e 's|libs/eigen|/usr/include/eigen3|g' \
		-e 's|libs/shapelib|/usr/include/libshp|g' \
		CMakeLists.txt || die
	sed -i -e '/add_subdirectory(shapelib)/d' \
		-e '/add_subdirectory(qtandroidserialport)/d' \
		libs/CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		#"-DOpenGL_GL_PREFERENCE=GLVND"
		# BUILD_SHARED_LIBS=ON produces strong dependency cycle
		"-DBUILD_SHARED_LIBS=OFF")
	cmake_src_configure
}
