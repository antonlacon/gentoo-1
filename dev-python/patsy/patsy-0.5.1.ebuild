# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Python module to describe statistical models and design matrices"
HOMEPAGE="https://patsy.readthedocs.org/en/latest/index.html"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
	doc? (
		dev-python/ipython[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		)
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

python_compile_all() {
	use doc && emake -C doc html
}

python_test() {
	cd "${BUILD_DIR}" || die
	nosetests -v || die "Testing failed with ${EPYTHON}"
}

python_install_all() {
	use doc && HTML_DOCS=( doc/_build/html/. )
	distutils-r1_python_install_all
}
