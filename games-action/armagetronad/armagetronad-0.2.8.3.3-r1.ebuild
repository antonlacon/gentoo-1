# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit desktop gnome2-utils

DESCRIPTION="Fast-paced 3D lightcycle game based on Tron"
HOMEPAGE="http://armagetronad.org/"
SRC_URI="https://launchpad.net/armagetronad/${PV:0:5}/${PV:0:7}.x/+download/armagetronad-${PV}.src.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dedicated sound"

RDEPEND="
	dev-libs/libxml2
	!dedicated? (
		media-libs/libpng:0=
		media-libs/libsdl[X,opengl,video,sound?]
		media-libs/sdl-image[jpeg,png]
		virtual/glu
		virtual/opengl
		sound? ( media-libs/sdl-mixer )
	)"
DEPEND=${RDEPEND}

PATCHES=( "${FILESDIR}"/${P}-gcc6.patch )

src_prepare() {
	default
	sed -i -e 's#aa_docdir=.*$#aa_docdir=${docdir}#' configure || die
}

src_configure() {
	# --enable-games just messes up paths
	econf \
		$(use_enable dedicated) \
		$(use_enable sound music) \
		--disable-sysinstall \
		--disable-useradd \
		--disable-uninstall \
		--disable-games
}

src_install() {
	default

	# misplaced desktop-file/icons
	rm -r "${ED%/}"/usr/share/${PN}/desktop || die
	doicon -s 48 desktop/icons/large/armagetronad.png
	make_desktop_entry ${PN}
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
