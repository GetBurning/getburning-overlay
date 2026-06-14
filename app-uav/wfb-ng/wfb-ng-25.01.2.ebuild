# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="Long-range radio link based on raw WiFi radio"
HOMEPAGE="https://github.com/svpcom/wfb-ng"
MY_TAG="${P}"
SRC_URI="https://github.com/svpcom/wfb-ng/archive/refs/tags/${MY_TAG}.tar.gz"
S="${WORKDIR}/${PN}-${MY_TAG}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="rtsp systemd"
RESTRICT="mirror"

# C programs (wfb_tx, wfb_rx, wfb_keygen, wfb_tx_cmd, wfb_tun)
DEPEND="
	net-libs/libpcap
	dev-libs/libsodium
	dev-libs/libevent:=
	rtsp? ( media-libs/gst-rtsp-server:1.0= )
"
RDEPEND="${DEPEND}
	net-wireless/iw

	dev-python/jinja2[${PYTHON_USEDEP}]
	dev-python/msgpack[${PYTHON_USEDEP}]
	dev-python/pyroute2[${PYTHON_USEDEP}]
	dev-python/pyserial[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/twisted[${PYTHON_USEDEP}]
	dev-python/zope-interface[${PYTHON_USEDEP}]
"
BDEPEND="virtual/pkgconfig"

distutils_enable_tests pytest

src_configure() {
	# setup.py asserts VERSION and COMMIT are set (used for version stamping)
	export VERSION="${PV}"
	export COMMIT="${MY_TAG}"
	# Skip setup.py data_files install (absolute paths end up under
	# site-packages in PEP517 mode, and wfb_rtsp needs gstreamer).
	# We install C binaries manually in python_install_all.
	export OMIT_DATA_FILES=1
	distutils-r1_src_configure
}

src_compile() {
	# Build C binaries (wfb_tx, wfb_rx, wfb_keygen, wfb_tx_cmd, wfb_tun)
	emake all_bin

	# wfb_rtsp needs gstreamer-rtsp-server
	use rtsp && emake wfb_rtsp

	distutils-r1_src_compile
}

python_install_all() {
	distutils-r1_python_install_all

	# C binaries (built by emake all_bin, installed manually since
	# setup.py data_files is disabled)
	exeinto /usr/bin
	doexe wfb_tx wfb_rx wfb_keygen wfb_tx_cmd wfb_tun
	use rtsp && doexe wfb_rtsp

	newinitd "${FILESDIR}/wfb-ng.initd" wfb-ng
	newconfd "${FILESDIR}/wfb-ng.confd" wfb-ng
	insinto /etc/wfb-ng/
	newins "${FILESDIR}/gs.cfg.example" gs.cfg
	newins "${FILESDIR}/drone.cfg.example" drone.cfg
	keepdir /var/log/wfb-ng/

	if ! use systemd; then
		rm -r "${ED}/lib/systemd" 2>/dev/null || true
	fi

	dodoc README.md
}
