#!/bin/sh
#
# Flussonic installer
set -e
set -u
export LANG=C
export PATH=/bin:/sbin:/usr/bin:/usr/sbin
if [ `uname -m` != "x86_64" ] && [ `uname -m` != "aarch64" ]; then
    echo Flussonic needs x86_64 or ARM64 machine # but we run on ARM too
    exit 1
fi

get_package_manager()
{
  if [ $(which dnf) ]; then
      package_manager=dnf
  elif [ $(which yum) ] ; then
      package_manager=yum
  else
      echo Expected one of "yum" or "dnf" package manager but no one found.
      exit 1
  fi
}

if [ -f /etc/debian_version ]; then
    distro=debian
    debian_updated=no
else
    distro=not_debian
    get_package_manager
fi

echo Distro: $distro
if [ `id -u` != 0 ]; then
    echo Must run as root
    exit 1
fi

debian_update()
{
    if [ $debian_updated = no ]; then
        apt-get update
        debian_updated=yes
    fi
}

debian_repo_install()
{
    debian_update
    apt-get -y install $1
}

not_debian_repo_install()
{
    $package_manager -y -q install $1
}

check_curl()
{
    if [ ! -x /usr/bin/curl ]; then
        ${distro}_repo_install curl
    fi
}

debian_install()
{
    curl -sSf http://apt.flussonic.com/binary/gpg.key > /etc/apt/trusted.gpg.d/flussonic.gpg;
    rm -f /etc/apt/sources.list.d/erlyvideo.list
    echo "deb http://apt.flussonic.com binary/" > /etc/apt/sources.list.d/flussonic.list
    debian_update
    apt-get -y --install-recommends --install-suggests install flussonic
}

not_debian_install()
{
    cat > /etc/yum.repos.d/Flussonic.repo <<EOF
[flussonic]
name=Flussonic
baseurl=http://apt.flussonic.com/rpm
enabled=1
gpgcheck=0
EOF
    $package_manager -y install flussonic-erlang flussonic flussonic-transcoder
}

install_release()
{
    check_curl
    ${distro}_install
    echo
    echo Flussonic installed, run it:
    echo
    echo systemctl start flussonic
}
####
action=install_release
${action}
