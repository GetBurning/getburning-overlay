# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Nagios plugin for monitoring the BIRD routing daemon"
HOMEPAGE="https://github.com/GetBurning/nagios-plugins-bird"
SRC_URI="https://github.com/GetBurning/nagios-plugins-bird/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/nagios-plugins-bird-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-perl/Monitoring-Plugin
	dev-perl/Carp-Clan
	dev-perl/Params-Validate
"

src_compile() { :; }

src_install() {
	local plugindir="/usr/$(get_libdir)/nagios/plugins"

	exeinto "${plugindir}/${PN}"
	doexe src/plugins/check_bird

	insinto "/usr/$(get_libdir)/perl5/vendor_perl"
	doins src/lib/birdctl.pm

	dodoc README.md CHANGELOG
}
