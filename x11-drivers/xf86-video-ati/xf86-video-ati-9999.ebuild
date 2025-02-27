# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-video-ati/xf86-video-ati-7.5.0.ebuild,v 1.1 2014/10/16 16:20:10 vapier Exp $

EAPI=5

#EGIT_REPO_URI="https://github.com/iXit/xf86-video-ati"
EGIT_REPO_URI="http://cgit.freedesktop.org/xorg/driver/xf86-video-ati"

if [[ ${PV} = 9999* ]]; then
	GIT_ECLASS="git-r3"
fi

XORG_DRI=always
inherit linux-info xorg-2

DESCRIPTION="ATI video driver"
HOMEPAGE="http://www.x.org/wiki/ati/"

KEYWORDS=""
IUSE="+dri3 +glamor udev"

RDEPEND=">=x11-libs/libdrm-2.4.58[video_cards_radeon]
	>=x11-libs/libpciaccess-0.8.0
	glamor? ( || (
		x11-base/xorg-server[glamor]
		>=x11-libs/glamor-0.6
	) )
	udev? ( virtual/udev )"
DEPEND="${RDEPEND}
	x11-proto/fontsproto
	x11-proto/randrproto
	x11-proto/renderproto
	x11-proto/videoproto
	x11-proto/xextproto
	x11-proto/xf86driproto
	x11-proto/xproto"

pkg_pretend() {
	if use kernel_linux ; then
		if kernel_is -ge 3 9; then
			CONFIG_CHECK="~!DRM_RADEON_UMS ~!FB_RADEON"
		else
			CONFIG_CHECK="~DRM_RADEON_KMS ~!FB_RADEON"
		fi
	fi
	check_extra_config
}

src_configure() {
	XORG_CONFIGURE_OPTIONS=(
		$(use_enable glamor)
		$(use_enable udev)
	)
	xorg-2_src_configure
}
