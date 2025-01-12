# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit udev xdg cmake

DESCRIPTION="stm32 discovery line linux programmer"
HOMEPAGE="https://github.com/stlink-org/stlink"
if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/stlink-org/stlink.git"
	inherit git-r3
else
	SRC_URI="https://github.com/stlink-org/stlink/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64"
fi

LICENSE="BSD"
SLOT="0"
IUSE="static-libs"

# Block qstlink2 due to udev rules file collision
RDEPEND="virtual/libusb:1
	>=dev-libs/glib-2.32.0:2
	x11-libs/gtk+:3
	!dev-util/qstlink2"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_LIBDIR="$(get_libdir)"
		-DSTLINK_UDEV_RULES_DIR="$(get_udevdir)"/rules.d
		-DSTLINK_MODPROBED_DIR="${EPREFIX}/etc/modprobe.d"
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install
	if use !static-libs; then
		rm "${D}/usr/lib64/libstlink.a"*
	fi
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
