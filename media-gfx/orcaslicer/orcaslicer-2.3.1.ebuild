# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WX_GTK_VER="3.2-gtk3"
MY_PN="OrcaSlicer"
MY_PV="$(ver_rs 3 -)"

inherit cmake wxwidgets xdg

DESCRIPTION="A mesh slicer to generate G-code for fused-filament-fabrication (3D printers)"
HOMEPAGE="https://github.com/SoftFever/OrcaSlicer"
LICENSE="AGPL-3 Boost-1.0 GPL-2 LGPL-3 MIT"

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/SoftFever/OrcaSlicer.git"
	S="${WORKDIR}/${P}"
elif [[ ${PV} == *9998* ]]; then
	MY_REF="f57d0d1442bfb065c9162d773c774b8835757a5e"
	SRC_URI="https://github.com/SoftFever/OrcaSlicer/archive/${MY_REF}.tar.gz -> ${PN}-${MY_REF}.tar.gz"
	S="${WORKDIR}/${MY_PN}-${MY_REF}"
else
	SRC_URI="https://github.com/SoftFever/OrcaSlicer/archive/refs/tags/v${MY_PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~x86"
	S="${WORKDIR}/${MY_PN}-${PV}"
fi

SLOT="0"

IUSE="test debug"

RESTRICT="test mirror"

RDEPEND="
	dev-cpp/eigen:3
	dev-cpp/tbb:=
	dev-libs/boost:=[nls]
	dev-libs/cereal
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/gmp:=
	dev-libs/mpfr:=
	media-gfx/openvdb:=
	media-gfx/libbgcode
	net-misc/curl[adns]
	media-libs/glfw
	media-libs/glew:0=
	media-libs/libjpeg-turbo:=
	media-libs/libpng:0=
	media-libs/qhull:=
	sci-libs/libigl
	sci-libs/nlopt
	sci-libs/opencascade:=
	sci-mathematics/cgal:=
	sys-apps/dbus
	virtual/zlib:=
	virtual/opengl
	x11-libs/gtk+:3
	>=x11-libs/wxGTK-3.2.2.1-r3:${WX_GTK_VER}[X,opengl]
	media-libs/nanosvg:=
	media-libs/opencv
	media-libs/libnoise
"
DEPEND="${RDEPEND}
	media-libs/qhull[static-libs]
"

PATCHES=(
	"${FILESDIR}/${PN}-2.3.1-cgal-6.0.patch"
	"${FILESDIR}/${PN}-2.3.1-boost-1.88.patch"
	"${FILESDIR}/${PN}-2.3.1-opencascade-7.8.0.patch"
	"${FILESDIR}/${PN}-2.3.1-dont-expect-opencv_world.patch"
	"${FILESDIR}/${PN}-2.3.1-PhysicalPrinterDialog.patch"
	"${FILESDIR}/${PN}-2.3.1-fix-linking-to-webkitgtk.patch"

)

src_prepare() {
	# sed -i -e 's/find_package(OpenCASCADE 7.6.2 REQUIRED)/find_package(OpenCASCADE REQUIRED)/g' \
	# 	src/occt_wrapper/CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	CMAKE_BUILD_TYPE="Release"

	setup-wxwidgets

	# src/libslic3r/ObjColorUtils.hpp includes "opencv2/opencv.hpp" without using CMake find_module
	export CPLUS_INCLUDE_PATH="/usr/include/opencv4/"

	local mycmakeargs=(
		-DOPENVDB_FIND_MODULE_PATH="/usr/$(get_libdir)/cmake/OpenVDB"
		-DSLIC3R_BUILD_TESTS=$(usex test)
		-DSLIC3R_FHS=ON
		-DSLIC3R_GTK=3
		-DSLIC3R_GUI=ON
		-DSLIC3R_PCH=OFF
		-DSLIC3R_STATIC=OFF
		-DSLIC3R_WX_STABLE=OFF
		-Wno-dev
	)
	use debug && mycmakeargs+=(
			-DCMAKE_BUILD_TYPE=RelWithDebInfo
			-DORCA_INCLUDE_DEBUG_INFO=ON
		)

	cmake_src_configure
}

src_install() {
	cmake_src_install
	for p in "usr/LICENSE.txt" \
			 "usr/include/spline/spline.h" \
			 "usr/lib/cmake/spline/splineTargets.cmake" \
			 "usr/include/stb_dxt/stb_dxt.h" \
			 "usr/lib/cmake/stb_dxt/stb_dxtTargets.cmake"; do
		rm "${D}/${p}" || die "Upstream fixed this, remove me"
	done

	dodoc README.md
}
