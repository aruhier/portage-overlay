# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/google-perftools/google-perftools-2.0-r2.ebuild,v 1.6 2014/08/11 22:10:08 blueness Exp $

EAPI=5

MY_P="gperftools-${PV}"

inherit toolchain-funcs eutils flag-o-matic autotools-multilib

DESCRIPTION="Fast, multi-threaded malloc() and nifty performance analysis tools"
HOMEPAGE="http://code.google.com/p/gperftools/"
SRC_URI="http://gperftools.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0/4"
# contains ASM code, with support for
# freebsd x86/amd64
# linux x86/amd64/ppc/ppc64/arm
# OSX ppc/amd64
# AIX ppc/ppc64
KEYWORDS="-* amd64 arm ~ppc ~ppc64 x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="largepages +debug minimal test static-libs"

DEPEND="sys-libs/libunwind"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

HTML_DOCS="doc"

pkg_setup() {
	# set up the make options in here so that we can actually make use
	# of them on both compile and install.

	# Avoid building the unit testing if we're not going to execute
	# tests; this trick here allows us to ignore the tests without
	# touching the build system (and thus without rebuilding
	# autotools). Keep commented as long as it's restricted.
	use test || \
		MAKEOPTS+=" noinst_PROGRAMS= "
}

src_prepare() {
	epatch "${FILESDIR}/${MY_P}+glibc-2.16.patch"
	epatch "${FILESDIR}/${MY_P}-32bit-barrier.patch"
}

src_configure() {
	use largepages && append-cppflags -DTCMALLOC_LARGE_PAGES
	append-flags -fno-strict-aliasing -fno-omit-frame-pointer

	local myeconfargs=(
		--htmldir=/usr/share/doc/${PF}/html
		$(use_enable debug debugalloc)
		$(use_enable minimal)
	)

	autotools-multilib_src_configure
}

src_test() {
	case "${LD_PRELOAD}" in
		*libsandbox*)
			ewarn "Unable to run tests when sandbox is enabled."
			ewarn "See http://bugs.gentoo.org/290249"
			return 0
			;;
	esac

	autotools-multilib_src_test
}
