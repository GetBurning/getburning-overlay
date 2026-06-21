# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg-utils

DESCRIPTION="Ground control station for drones"
HOMEPAGE="https://qgroundcontrol.com/"

QGC_PV="v${PV}"
GST_PV="1.24.13"

SRC_URI="
	https://github.com/mavlink/qgroundcontrol/archive/refs/tags/${QGC_PV}.tar.gz -> ${P}.tar.gz
	https://github.com/ArduPilot/ArduPilot-Parameter-Repository/archive/a458e8e86a8ffa3b7f52f4601adcdaaff0db5f42.tar.gz -> ardupilot-params-${PV}.tar.gz
	https://github.com/mavlink/c_library_v2/archive/19f9955598af9a9181064619bd2e3c04bd2d848a.tar.gz -> qgc-mavlink-${PV}.tar.gz
	https://github.com/mavlink/libevents/archive/840a88ea226d.tar.gz -> qgc-libevents-${PV}.tar.gz
	https://github.com/PX4/ulog_cpp/archive/af366a91cb90.tar.gz -> qgc-ulog-cpp-${PV}.tar.gz
	https://github.com/PX4/PX4-GPSDrivers/archive/52bc6ecef4fb.tar.gz -> qgc-px4-gpsdrivers-${PV}.tar.gz
	https://github.com/mdqinc/SDL_GameControllerDB/archive/e24bb1ce0fe7.tar.gz -> qgc-sdl-gamecontrollerdb-${PV}.tar.gz
	https://github.com/tukaani-project/xz-embedded/archive/refs/tags/v2024-12-30.tar.gz -> qgc-xz-embedded-${PV}.tar.gz
	https://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-${GST_PV}.tar.xz
"

S="${WORKDIR}/qgroundcontrol-${PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="+vaapi alsa pulseaudio jack"
RESTRICT="mirror"

# All dependencies pre-fetched via SRC_URI — no network access during build.
# System libraries replace SDL2, zlib, shapelib, GeographicLib.
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
BDEPEND="dev-qt/qttools:6"

PATCHES=(
	"${FILESDIR}/qgc-5.0.8-system-libs.patch"
	"${FILESDIR}/qgc-5.0.8-qt611-compat.patch"
)

src_unpack() {
	default

	cd "${S}" || die
	mkdir -p third_party || die
	local tp="${S}/third_party"

	# ArduPilot parameter repository (submodule)
	local apmdir="${WORKDIR}/qgroundcontrol-${PV}/src/FirmwarePlugin/APM/ArduPilot-Parameter-Repository"
	rm -rf "${apmdir}"
	mv "${WORKDIR}/ParameterRepository-"*/ "${apmdir}" || die

	# Third-party sources expected by CMakeLists.txt
	mv "${WORKDIR}/c_library_v2-"*		"${tp}/mavlink" || die
	mv "${WORKDIR}/libevents-"*		"${tp}/libevents" || die
	mv "${WORKDIR}/ulog_cpp-"*		"${tp}/ulog_cpp" || die
	mv "${WORKDIR}/PX4-GPSDrivers-"*	"${tp}/px4-gpsdrivers" || die
	mv "${WORKDIR}/SDL_GameControllerDB-"*	"${tp}/sdl_gamecontrollerdb" || die
	mv "${WORKDIR}/xz-embedded-"*		"${tp}/xz-embedded" || die

	# GStreamer qt6 plugin sources (only ext/qt6 needed)
	mkdir -p "${tp}/gst-plugins-good/ext" || die
	cp -r "${WORKDIR}/gst-plugins-good-${GST_PV}/ext/qt6" \
		"${tp}/gst-plugins-good/ext/" || die
}

src_prepare() {
	cmake_src_prepare

	# Add system library find_package calls to main CMakeLists.txt
	# (needed because subdirectory targets aren't visible at parent scope)
	sed -i '/^add_subdirectory(src)/i\
find_package(SDL2 REQUIRED)\
find_package(ZLIB REQUIRED)\
find_package(GeographicLib REQUIRED)\
find_package(PkgConfig REQUIRED)\
pkg_check_modules(SHP REQUIRED IMPORTED_TARGET shapelib)' \
		CMakeLists.txt || die

	# Patch Qt maximum version check
	sed -i \
		-e 's|set(QGC_QT_MAXIMUM_VERSION "6.8.3"|set(QGC_QT_MAXIMUM_VERSION "6.99.0"|g' \
		CMakeLists.txt || die

	# Add Qt6 private API packages and Quick3D to required COMPONENTS,
	# remove from OPTIONAL_COMPONENTS
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

	# Fix: cmake pkg_check_modules picks up 32-bit glibconfig.h from
	# /usr/lib/glib-2.0/include (multilib) instead of the correct
	# /usr/lib64/glib-2.0/include. Add correct include path to gstqml6gl.
	sed -i \
		-e '/target_link_libraries(gstqml6gl PUBLIC GStreamer::GStreamer)/a\    target_include_directories(gstqml6gl PRIVATE /usr/lib64/glib-2.0/include)' \
		src/VideoManager/VideoReceiver/GStreamer/gstqml6gl/CMakeLists.txt || die

	# Fix: cmake/Git.cmake fails when not in a git repo (tarball build).
	# Hardcode version info instead of using git commands.
	cat > cmake/Git.cmake <<-'GITEOF'
	set(QGC_GIT_BRANCH "release")
	set(QGC_GIT_HASH "${PV}")
	set(QGC_APP_VERSION_STR "v${PV}")
	set(QGC_APP_VERSION "${PV}")
	set(QGC_APP_DATE "2025-01-01")
	string(REGEX MATCH "([0-9]+)\\.([0-9]+)\\.([0-9]+)" QGC_APP_VERSION_MATCH "${QGC_APP_VERSION}")
	set(QGC_APP_VERSION_MAJOR ${CMAKE_MATCH_1})
	set(QGC_APP_VERSION_MINOR ${CMAKE_MATCH_2})
	set(QGC_APP_VERSION_PATCH ${CMAKE_MATCH_3})
	GITEOF
}

src_configure() {
	xdg_environment_reset
	local mycmakeargs=(
		-DOpenGL_GL_PREFERENCE=GLVND
		-DBUILD_SHARED_LIBS=OFF
		-DQGC_STABLE_BUILD=ON
		-DQGC_BUILD_TESTING=OFF
	)
	cmake_src_configure
}
