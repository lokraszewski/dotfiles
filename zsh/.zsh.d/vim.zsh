#  ███████╗███████╗██╗  ██╗
#  ╚══███╔╝██╔════╝██║  ██║
#    ███╔╝ ███████╗███████║
#   ███╔╝  ╚════██║██╔══██║
#  ███████╗███████║██║  ██║
#  ╚══════╝╚══════╝╚═╝  ╚═╝
# vim

SPACEVIM_HOME=~/.SpaceVim
INSTALLER_URL=https://spacevim.org/install.sh
TMP_INSTALLER=/tmp/spacevim_install.sh
EXPECTED_CHECKSUM="cc148e0cb4bebde752f59ced07590bc8aaa6c19efc233ae6725c10c69e2459ac0a78e13900f2f12a1cb3d8e7b9bac3ae82b70feb88bf9cd3fa30efd74b35879b  $TMP_INSTALLER"

install_spacevim() {
    echo "Installing SpaceVim"
    curl -sLf $INSTALLER_URL > $TMP_INSTALLER
    if [ ! $? -eq 0 ]; then
        echo "Downloading installer $INSTALLER_URL failed."
        return 1
    fi

    checksum=$(sha512sum $TMP_INSTALLER)
    if [ ! "$checksum" = "$EXPECTED_CHECKSUM" ]; then
        echo "$TMP_INSTALLER has wrong checksum"
        echo "$checksum"
        echo "Expected:"
        echo "$EXPECTED_CHECKSUM"
        rm -f $TMP_INSTALLER
        return 1
    fi
    chmod +x $TMP_INSTALLER

    $TMP_INSTALLER

    rm -f $TMP_INSTALLER
    echo "SpaceVim installed"
}

if [ ! -d $SPACEVIM_HOME ]; then
    install_spacevim
fi
