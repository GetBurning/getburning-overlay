# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3 xdg-utils

DESCRIPTION="Ground control station for drones"
HOMEPAGE="https://qgroundcontrol.com/"
EGIT_REPO_URI="https://github.com/mavlink/qgroundcontrol"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="+vaapi alsa pulseaudio jack"
RESTRICT="mirror"

# QGC 5.x uses Qt6 and CPM for some deps. System libs replace SDL2,
# shapelib, zlib, GeographicLib. CPM still used for: mavlink headers,
# libevents, ulog_cpp, px4-gpsdrivers, xz-embedded, sdl_gamecontrollerdb,
# and gstreamer qt6 sink sources.
RDEPEND="
	dev-qt/qtbase:6=[concurrent,gui,network,opengl,sql,widgets,xml]
	dev-qt/qt5compat:6
	dev-qt/qtcharts:6[qml]
	dev-qt/qtdeclarative:6[opengl,widgets]
	dev-qt/qtlocation:6
	dev-qt/qtmultimedia:6
	dev-qt/qtpositioning:6[qml]
	dev-qt/qtquick3d:6
	dev-qt/qtquickcontrols2:6
	dev-qt/qtsensors:6[qml]
	dev-qt/qtserialport:6
	dev-qt/qtspeech:6
	dev-qt/qtsvg:6
	dev-qt/qtwayland:6
	dev-qt/qttools:6[linguist]

	media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0
	media-libs/gst-plugins-good:1.0
	media-plugins/gst-plugins-qt6
	alsa? ( media-libs/gst-plugins-base:1.0[alsa] )
	pulseaudio? ( media-plugins/gst-plugins-pulse:1.0 )
	jack? ( media-plugins/gst-plugins-jack:1.0 )
	vaapi? ( media-plugins/gst-plugins-vaapi:1.0 )

	media-libs/libsdl2
	sci-libs/shapelib
	sci-geosciences/GeographicLib
	sys-libs/zlib
	dev-libs/glib:2
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-qt/qttools:6
"

src_prepare() {
	default

	# Patch Qt maximum version check to match installed Qt
	sed -i \
		-e 's|set(QGC_QT_MAXIMUM_VERSION "6.8.3"|set(QGC_QT_MAXIMUM_VERSION "6.99.0"|g' \
		CMakeLists.txt || die

	# Add Qt6 private API packages and Quick3D to required COMPONENTS,
	# remove from OPTIONAL_COMPONENTS to avoid "both required and optional" error
	sed -i \
		-e '/^        Location$/a\        LocationPrivate' \
		-e '/^        Core5Compat$/a\        CorePrivate' \
		-e '/^        Multimedia$/a\        MultimediaQuickPrivate' \
		-e '/^        Positioning$/a\        PositioningPrivate' \
		-e '/^        Quick$/a\        Quick3D' \
		-e '/OPTIONAL_COMPONENTS/,/^)/{
			/MultimediaQuickPrivate/d
			/Quick3D/d
		}' \
		CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	xdg_environment_reset
	local mycmakeargs=(
		-DOpenGL_GL_PREFERENCE=GLVND
		-DBUILD_SHARED_LIBS=OFF
		-DQGC_STABLE_BUILD=ON
		-DQGC_BUILD_TESTING=OFF
		-DQGC_CPM_SOURCE_CACHE="${WORKDIR}/cpm-cache"
	)
	cmake_src_configure
}
