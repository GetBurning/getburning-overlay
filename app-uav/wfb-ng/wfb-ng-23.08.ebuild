# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# PEP517 mode breaks data_files install paths
# DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Long-range radio link based on raw WiFi radio"
HOMEPAGE="https://github.com/svpcom/wfb-ng"
MY_TAG="${P}"
SRC_URI="https://github.com/svpcom/wfb-ng/archive/refs/tags/${MY_TAG}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="systemd"
RESTRICT="mirror"

RDEPEND="
	net-libs/libpcap
	dev-libs/libsodium

	net-wireless/iw

	dev-python/twisted[${PYTHON_USEDEP}]
	dev-python/pyroute2[${PYTHON_USEDEP}]
	dev-python/pyserial[${PYTHON_USEDEP}]
	dev-python/zope-interface[${PYTHON_USEDEP}]
	dev-python/importlib-metadata[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-${MY_TAG}"
distutils_enable_tests pytest

python_configure_all() {
	VERSION="${PV}"; COMMIT="${MY_TAG}"
	SOURCE_DATE_EPOCH="$(date)"
	export VERSION COMMIT SOURCE_DATE_EPOCH
	emake all_bin
}

python_compile() {
	distutils-r1_python_compile
}

python_install_all() {
	newinitd "${FILESDIR}/wfb-ng.initd" wfb-ng
	newconfd "${FILESDIR}/wfb-ng.confd" wfb-ng
	insinto /etc/wfb-ng/
	newins "${FILESDIR}/gs.cfg.example" gs.cfg
	newins "${FILESDIR}/drone.cfg.example" drone.cfg
	keepdir /var/log/wfb-ng/
	if ! use systemd; then
		rm -r "${D}/lib/systemd"
	fi
	dodoc README.md
}
