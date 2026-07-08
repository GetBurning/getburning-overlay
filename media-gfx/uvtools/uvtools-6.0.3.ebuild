# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_PKG_COMPAT="10.0"
NUGET_PACKAGES="${WORKDIR}/nugets"

inherit dotnet-pkg desktop

DESCRIPTION="MSLA/DLP, file analysis, calibration, repair, conversion and manipulation tool"
HOMEPAGE="https://github.com/sn4k3/UVtools"
SRC_URI="https://github.com/sn4k3/UVTools/archive/v${PV}.tar.gz -> ${P}.tar.gz
		https://gentoo.bakka.su/nuget-tarballs/${P}-nugets.tar.xz"
MY_PN="UVtools"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror"

DOTNET_PKG_PROJECTS=(
	UVtools.Cmd
	UVtools.UI
)
DOTNET_PKG_BUILD_EXTRA_ARGS=(
	--property:PublishTrimmed=false
)

src_install() {
	dotnet-pkg-base_install
	dotnet-pkg-base_dolauncher "/usr/share/${P}/UVtools" uvtools
	dotnet-pkg-base_dolauncher "/usr/share/${P}/UVtoolsCmd" uvtools-cmd

	domenu "${FILESDIR}/uvtools.desktop"

	einstalldocs
}
