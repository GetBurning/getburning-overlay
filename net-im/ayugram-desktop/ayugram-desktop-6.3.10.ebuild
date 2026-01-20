# Copyright 2020-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )

inherit xdg cmake python-any-r1 optfeature toolchain-funcs flag-o-matic

DESCRIPTION="Not an official desktop client for Telegram"
HOMEPAGE="https://github.com/AyuGram/AyuGramDesktop"

MY_P="AyuGramDesktop-${PV}"
CMAKE_HELPERS_REF="c7e0493dea2b870fb1b8e26604201fdb9e8c1ee5"
CMAKE_CPPGIR_REF="2a7d9cef68202a29d5e8a679ce9519c76eb26dc3"

CODEGEN_REF="1c919609d4573f2be91dafef923f8f9e2c08cdff"
LIB_BASE_REF="444ab33475734485dcc183a5fb86875c134fac8b"
LIB_CRL_REF="a41edfcfa8c04057deb8a1a38fca145248a9421a"
LIB_ICU_REF="fd92c3184598c4e64c10c1961a3c767d43b10b5c"
LIB_LOTTIE_REF="99d8cc4d1820960fbcdafc574f1894073b14b75a"
LIB_QR_REF="6fdf60461444ba150e13ac36009c0ffce72c4c83"
LIB_RPL_REF="c57cccffb01d85570decd7fccb88419c9a682e63"
LIB_SPELLCHECK_REF="476bb43025449ccbd815a14895e9321695a1a177"
LIB_STORAGE_REF="ccdc72548a5065b5991b4e06e610d76bc4f6023e"
LIB_TL_REF="6a1bf6bb45ba803d2a9be76db8aead45cb4732d5"
LIB_UI_REF="b1710a65b73a09937d4cfef3f84cb39b5848ad5d"
LIB_WEBRTC_REF="553102f8c244609253720e7a03c2ea2d3c7fee8e"
LIB_WEBVIEW_REF="55ea11759711d377216eae6c45dad0bc49b67398"

RLOTTIE_REF="8c69fc20cf2e150db304311f1233a4b55a8892d7"
LIBPRISMA_REF="23b0d70f9709da9b38561d5706891a134d18df76"
TGCALLS_REF="24876ebca7da10f92dc972225734337f9e793054"
XDG_DESKTOP_PORTAL_REF="23a76c392170dbbd26230f85ef56c3a57e52b857"

SRC_URI="https://github.com/AyuGram/AyuGramDesktop/archive/refs/tags/v${PV}.tar.gz -> ${MY_P}.tar.gz
https://gitlab.com/mnauw/cppgir/-/archive/${CMAKE_CPPGIR_REF}/cppgir-${CMAKE_CPPGIR_REF}.tar.bz2 -> Telegram-cmake-external-glib-cppgir-${CMAKE_CPPGIR_REF}.tar.bz2
https://github.com/AyuGram/lib_icu/archive/${LIB_ICU_REF}.tar.gz -> Telegram-lib_icu-${LIB_ICU_REF}.tar.gz
https://github.com/AyuGram/lib_tl/archive/${LIB_TL_REF}.tar.gz -> Telegram-lib_tl-${LIB_TL_REF}.tar.gz
https://github.com/AyuGram/lib_ui/archive/${LIB_UI_REF}.tar.gz -> Telegram-lib_ui-${LIB_UI_REF}.tar.gz
https://github.com/desktop-app/cmake_helpers/archive/${CMAKE_HELPERS_REF}.tar.gz -> Telegram-cmake-helpers-${CMAKE_HELPERS_REF}.tar.gz
https://github.com/desktop-app/codegen/archive/${CODEGEN_REF}.tar.gz -> Telegram-codegen-${CODEGEN_REF}.tar.gz
https://github.com/desktop-app/libprisma/archive/${LIBPRISMA_REF}.tar.gz -> Telegram-ThirdParty-libprisma-${LIBPRISMA_REF}.tar.gz
https://github.com/desktop-app/rlottie/archive/${RLOTTIE_REF}.tar.gz -> Telegram-ThirdParty-rlottie-${RLOTTIE_REF}.tar.gz
https://github.com/desktop-app/lib_base/archive/${LIB_BASE_REF}.tar.gz -> Telegram-lib_base-${LIB_BASE_REF}.tar.gz
https://github.com/desktop-app/lib_crl/archive/${LIB_CRL_REF}.tar.gz -> Telegram-lib_crl-${LIB_CRL_REF}.tar.gz
https://github.com/desktop-app/lib_lottie/archive/${LIB_LOTTIE_REF}.tar.gz -> Telegram-lib_lottie-${LIB_LOTTIE_REF}.tar.gz
https://github.com/desktop-app/lib_qr/archive/${LIB_QR_REF}.tar.gz -> Telegram-lib_qr-${LIB_QR_REF}.tar.gz
https://github.com/desktop-app/lib_rpl/archive/${LIB_RPL_REF}.tar.gz -> Telegram-lib_rpl-${LIB_RPL_REF}.tar.gz
https://github.com/desktop-app/lib_spellcheck/archive/${LIB_SPELLCHECK_REF}.tar.gz -> Telegram-lib_spellcheck-${LIB_SPELLCHECK_REF}.tar.gz
https://github.com/desktop-app/lib_storage/archive/${LIB_STORAGE_REF}.tar.gz -> Telegram-lib_storage-${LIB_STORAGE_REF}.tar.gz
https://github.com/desktop-app/lib_webrtc/archive/${LIB_WEBRTC_REF}.tar.gz -> Telegram-lib_webrtc-${LIB_WEBRTC_REF}.tar.gz
https://github.com/desktop-app/lib_webview/archive/${LIB_WEBVIEW_REF}.tar.gz -> Telegram-lib_webview-${LIB_WEBVIEW_REF}.tar.gz
https://github.com/TelegramMessenger/tgcalls/archive/${TGCALLS_REF}.tar.gz -> Telegram-ThirdParty-tgcalls-${TGCALLS_REF}.tar.gz
https://github.com/flatpak/xdg-desktop-portal/archive/${XDG_DESKTOP_PORTAL_REF}.tar.gz -> Telegram-ThirdParty-xdg-desktop-portal-${XDG_DESKTOP_PORTAL_REF}.tar.gz
"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD GPL-3-with-openssl-exception LGPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~loong"
IUSE="dbus enchant +fonts +libdispatch screencast wayland webkit +X"
RESTRICT="mirror"

CDEPEND="
	app-arch/lz4:=
	dev-cpp/abseil-cpp:=
	dev-cpp/ada:=
	dev-cpp/cld3:=
	>=dev-cpp/glibmm-2.77:2.68
	dev-libs/glib:2
	dev-libs/openssl:=
	>=dev-libs/protobuf-21.12
	dev-libs/qr-code-generator:=
	dev-libs/xxhash
	>=dev-qt/qtbase-6.5:6=[dbus?,gui,network,opengl,ssl,wayland?,widgets,X?]
	>=dev-qt/qtimageformats-6.5:6
	>=dev-qt/qtsvg-6.5:6
	media-libs/libjpeg-turbo:=
	media-libs/openal
	media-libs/opus
	media-libs/rnnoise
	>=media-libs/tg_owt-0_pre20241202:=[screencast=,X=]
	>=media-video/ffmpeg-6:=[opus,vpx]
	net-libs/tdlib:=[tde2e]
	virtual/minizip:=
	kde-frameworks/kcoreaddons:6
	!enchant? ( >=app-text/hunspell-1.7:= )
	enchant? ( app-text/enchant:= )
	libdispatch? ( dev-libs/libdispatch )
	webkit? ( wayland? (
		>=dev-qt/qtdeclarative-6.5:6
		>=dev-qt/qtwayland-6.5:6[compositor(+),qml]
	) )
	X? (
		x11-libs/libxcb:=
		x11-libs/xcb-util-keysyms
	)
"
RDEPEND="${CDEPEND}
	webkit? ( || ( net-libs/webkit-gtk:4.1 net-libs/webkit-gtk:6 ) )
"
DEPEND="${CDEPEND}
	>=dev-cpp/cppgir-2.0_p20240315
	>=dev-cpp/ms-gsl-4.1.0
	dev-cpp/expected
	dev-cpp/expected-lite
	dev-cpp/range-v3
"
BDEPEND="
	${PYTHON_DEPS}
	>=dev-build/cmake-3.16
	>=dev-cpp/cppgir-2.0_p20240315
	>=dev-libs/gobject-introspection-1.82.0-r2
	dev-util/gdbus-codegen
	virtual/pkgconfig
	wayland? ( dev-util/wayland-scanner )
"
# NOTE: dev-cpp/expected-lite used indirectly by a dev-cpp/cppgir header file

PATCHES=(
	"${FILESDIR}"/tdesktop-5.2.2-qt6-no-wayland.patch
	"${FILESDIR}"/tdesktop-5.2.2-libdispatch.patch
	"${FILESDIR}"/tdesktop-5.7.2-cstring.patch
	"${FILESDIR}"/tdesktop-5.8.3-cstdint.patch
	"${FILESDIR}"/tdesktop-5.14.3-system-cppgir.patch
)

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		if has ccache ${FEATURES}; then
			ewarn "ccache does not work with ${PN} out of the box"
			ewarn "due to usage of precompiled headers"
			ewarn "check bug https://bugs.gentoo.org/715114 for more info"
			ewarn
		fi
		if tc-is-clang && [[ $(tc-get-cxx-stdlib) = libstdc++ ]]; then
			ewarn "this package frequently fails to compile with clang"
			ewarn "in combination with libstdc++."
			ewarn "please use libc++, or build this package with gcc."
			ewarn "(if you have a patch or a fix, please open a"
			ewarn "bug report about it)"
			ewarn
		fi
	fi
}

src_prepare() {
	cp -r "${WORKDIR}/cmake_helpers-${CMAKE_HELPERS_REF}"/* "${S}/cmake/" || die
	rmdir "${S}/cmake/external/glib/cppgir" || die
	cp -r "${WORKDIR}/cppgir-${CMAKE_CPPGIR_REF}" "${S}/cmake/external/glib/cppgir" || die

	rmdir "${S}/Telegram/codegen" || die
	cp -r "${WORKDIR}/codegen-${CODEGEN_REF}" "${S}/Telegram/codegen" || die

	rmdir "${S}/Telegram/lib_"* || die
	cp -r "${WORKDIR}/lib_base-${LIB_BASE_REF}" "${S}/Telegram/lib_base" || die
	cp -r "${WORKDIR}/lib_crl-${LIB_CRL_REF}" "${S}/Telegram/lib_crl" || die
	cp -r "${WORKDIR}/lib_icu-${LIB_ICU_REF}" "${S}/Telegram/lib_icu" || die
	cp -r "${WORKDIR}/lib_lottie-${LIB_LOTTIE_REF}" "${S}/Telegram/lib_lottie" || die
	cp -r "${WORKDIR}/lib_qr-${LIB_QR_REF}" "${S}/Telegram/lib_qr" || die
	cp -r "${WORKDIR}/lib_rpl-${LIB_RPL_REF}" "${S}/Telegram/lib_rpl" || die
	cp -r "${WORKDIR}/lib_spellcheck-${LIB_SPELLCHECK_REF}" "${S}/Telegram/lib_spellcheck" || die
	cp -r "${WORKDIR}/lib_storage-${LIB_STORAGE_REF}" "${S}/Telegram/lib_storage" || die
	cp -r "${WORKDIR}/lib_tl-${LIB_TL_REF}" "${S}/Telegram/lib_tl" || die
	cp -r "${WORKDIR}/lib_ui-${LIB_UI_REF}" "${S}/Telegram/lib_ui" || die
	cp -r "${WORKDIR}/lib_webrtc-${LIB_WEBRTC_REF}" "${S}/Telegram/lib_webrtc" || die
	cp -r "${WORKDIR}/lib_webview-${LIB_WEBVIEW_REF}" "${S}/Telegram/lib_webview" || die

	rm -r "${S}/Telegram/ThirdParty/minizip" || die
	rmdir "${S}/Telegram/ThirdParty/"* || die
	cp -r "${WORKDIR}/rlottie-${RLOTTIE_REF}" "${S}/Telegram/ThirdParty/rlottie" || die
	cp -r "${WORKDIR}/libprisma-${LIBPRISMA_REF}" "${S}/Telegram/ThirdParty/libprisma" || die
	cp -r "${WORKDIR}/tgcalls-${TGCALLS_REF}" "${S}/Telegram/ThirdParty/tgcalls" || die
	cp -r "${WORKDIR}/xdg-desktop-portal-${XDG_DESKTOP_PORTAL_REF}" "${S}/Telegram/ThirdParty/xdg-desktop-portal" || die

	cmake_src_prepare

	# Happily fail if libraries aren't found...
	find -type f \( -name 'CMakeLists.txt' -o -name '*.cmake' \) \
		\! -path './cmake/external/qt/package.cmake' \
		-print0 | xargs -0 sed -i \
		-e '/pkg_check_modules(/s/[^ ]*)/REQUIRED &/' \
		-e '/find_package(/s/)/ REQUIRED)/' \
		-e '/find_library(/s/)/ REQUIRED)/' || die
	# Make sure to check the excluded files for new
	# CMAKE_DISABLE_FIND_PACKAGE entries.

	# Some packages are found through pkg_check_modules, rather than find_package
	sed -e '/find_package(lz4 /d' -i cmake/external/lz4/CMakeLists.txt || die
	sed -e '/find_package(Opus /d' -i cmake/external/opus/CMakeLists.txt || die
	sed -e '/find_package(xxHash /d' -i cmake/external/xxhash/CMakeLists.txt || die

	# Control QtDBus dependency from here, to avoid messing with QtGui.
	# QtGui will use find_package to find QtDbus as well, which
	# conflicts with the -DCMAKE_DISABLE_FIND_PACKAGE method.
	if ! use dbus; then
		sed -e '/find_package(Qt[^ ]* OPTIONAL_COMPONENTS/s/DBus *//' \
			-i cmake/external/qt/package.cmake || die
	fi

	# Control automagic dep only needed when USE="webkit wayland"
	if ! use webkit || ! use wayland; then
		sed -e 's/QT_CONFIG(wayland_compositor_quick)/0/' \
			-i Telegram/lib_webview/webview/platform/linux/webview_linux_compositor.h || die
	fi

}

src_configure() {
	# Having user paths sneak into the build environment through the
	# XDG_DATA_DIRS variable causes all sorts of weirdness with cppgir:
	# - bug 909038: can't read from flatpak directories (fixed upstream)
	# - bug 920819: system-wide directories ignored when variable is set
	export XDG_DATA_DIRS="${ESYSROOT}/usr/share"

	# Evil flag (bug #919201)
	filter-flags -fno-delete-null-pointer-checks

	# The ABI of media-libs/tg_owt breaks if the -DNDEBUG flag doesn't keep
	# the same state across both projects.
	# See https://bugs.gentoo.org/866055
	append-cppflags -DNDEBUG

	# https://github.com/telegramdesktop/tdesktop/issues/17437#issuecomment-1001160398
	use !libdispatch && append-cppflags -DCRL_FORCE_QT

	local no_webkit_wayland=$(use webkit && use wayland && echo no || echo yes)
	local use_webkit_wayland=$(use webkit && use wayland && echo yes || echo no)
	local mycmakeargs=(
		-DQT_VERSION_MAJOR=6

		# Override new cmake.eclass defaults (https://bugs.gentoo.org/921939)
		# Upstream never tests this any other way
		-DCMAKE_DISABLE_PRECOMPILE_HEADERS=OFF

		# Control automagic dependencies on certain packages
		## These libraries are only used in lib_webview, for wayland
		## See Telegram/lib_webview/webview/platform/linux/webview_linux_compositor.h
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6Quick=${no_webkit_wayland}
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6QuickWidgets=${no_webkit_wayland}
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6WaylandCompositor=${no_webkit_wayland}

		# Make sure dependencies that aren't patched to be REQUIRED in
		# src_prepare, are found.  This was suggested to me by the telegram
		# devs, in lieu of having explicit flags in the build system.
		-DCMAKE_REQUIRE_FIND_PACKAGE_Qt6DBus=$(usex dbus)
		-DCMAKE_REQUIRE_FIND_PACKAGE_Qt6Quick=${use_webkit_wayland}
		-DCMAKE_REQUIRE_FIND_PACKAGE_Qt6QuickWidgets=${use_webkit_wayland}
		-DCMAKE_REQUIRE_FIND_PACKAGE_Qt6WaylandCompositor=${use_webkit_wayland}

		-DDESKTOP_APP_DISABLE_QT_PLUGINS=ON
		-DDESKTOP_APP_DISABLE_X11_INTEGRATION=$(usex !X)
		## Enables enchant and disables hunspell
		-DDESKTOP_APP_USE_ENCHANT=$(usex enchant)
		## Use system fonts instead of bundled ones
		-DDESKTOP_APP_USE_PACKAGED_FONTS=$(usex !fonts)
		## See tdesktop-*-libdispatch.patch
		-DDESKTOP_APP_USE_LIBDISPATCH=$(usex libdispatch)
	)

	if [[ -n ${MY_TDESKTOP_API_ID} && -n ${MY_TDESKTOP_API_HASH} ]]; then
		einfo "Found custom API credentials"
		mycmakeargs+=(
			-DTDESKTOP_API_ID="${MY_TDESKTOP_API_ID}"
			-DTDESKTOP_API_HASH="${MY_TDESKTOP_API_HASH}"
		)
	else
		# https://github.com/telegramdesktop/tdesktop/blob/dev/snap/snapcraft.yaml
		# Building with snapcraft API credentials by default
		# Custom API credentials can be obtained here:
		# https://github.com/telegramdesktop/tdesktop/blob/dev/docs/api_credentials.md
		# After getting credentials you can export variables:
		#  export MY_TDESKTOP_API_ID="17349""
		#  export MY_TDESKTOP_API_HASH="344583e45741c457fe1862106095a5eb"
		# and restart the build"
		# you can set above variables (without export) in /etc/portage/env/net-im/telegram-desktop
		# portage will use custom variable every build automatically
		mycmakeargs+=(
			-DTDESKTOP_API_ID="611335"
			-DTDESKTOP_API_HASH="d524b414d21f4d37f08684c1df41ac9c"
		)
	fi

	cmake_src_configure
}

src_compile() {
	# There's a bug where sometimes, it will rebuild/relink during src_install
	# Make sure that happens here, instead.
	cmake_build
	cmake_build
}

pkg_postinst() {
	xdg_pkg_postinst
	if ! use X && ! use screencast; then
		ewarn "both the 'X' and 'screencast' USE flags are disabled, screen sharing won't work!"
		ewarn
	fi
	if ! use libdispatch; then
		ewarn "Disabling USE=libdispatch may cause performance degradation"
		ewarn "due to fallback to poor QThreadPool! Please see"
		ewarn "https://github.com/telegramdesktop/tdesktop/wiki/The-Packaged-Building-Mode"
		ewarn
	fi
	optfeature_header
	optfeature "AVIF, HEIF and JpegXL image support" kde-frameworks/kimageformats:6[avif,heif,jpegxl]
}
