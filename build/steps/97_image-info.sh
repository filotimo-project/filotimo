#!/usr/bin/bash
set -ouex pipefail
source /ctx/build/steps/prelude.sh

if [[ "$IMAGE_NAME" == *"-"* ]]; then
  IMAGE_FLAVOR="${IMAGE_NAME#*-}"
else
  IMAGE_FLAVOR="main"
fi

IMAGE_PRETTY_NAME="filotimo"
IMAGE_LIKE="fedora"
HOME_URL="https://filotimoproject.org/"
DOCUMENTATION_URL="https://filotimoproject.org/"
SUPPORT_URL="https://filotimoproject.org/"
BUG_SUPPORT_URL="https://filotimoproject.org/"
LOGO_ICON="fedora-logo-icon"
LOGO_COLOR="0;38;2;255;255;255"

IMAGE_INFO="/usr/share/ublue-os/image-info.json"
IMAGE_REF="ostree-image-signed:docker://ghcr.io/$IMAGE_VENDOR/$IMAGE_NAME"

# Image Info File
cat > $IMAGE_INFO <<EOF
{
  "image-name": "$IMAGE_NAME",
  "image-flavor": "$IMAGE_FLAVOR",
  "image-vendor": "$IMAGE_VENDOR",
  "image-ref": "$IMAGE_REF",
  "image-tag": "$IMAGE_TAG",
  "base-image-name": "kinoite-main",
  "fedora-version": "$FEDORA_MAJOR_VERSION",
}
EOF

# OS Release File
sed -i "s/^VARIANT_ID=.*/VARIANT_ID=$IMAGE_NAME/" /usr/lib/os-release
sed -i "s/^PRETTY_NAME=.*/PRETTY_NAME=\"filotimo $FEDORA_MAJOR_VERSION\"/" /usr/lib/os-release
sed -i "s/^NAME=.*/NAME=\"$IMAGE_PRETTY_NAME\"/" /usr/lib/os-release
sed -i "s|^HOME_URL=.*|HOME_URL=\"$HOME_URL\"|" /usr/lib/os-release
sed -i "s|^DOCUMENTATION_URL=.*|DOCUMENTATION_URL=\"$DOCUMENTATION_URL\"|" /usr/lib/os-release
sed -i "s|^SUPPORT_URL=.*|SUPPORT_URL=\"$SUPPORT_URL\"|" /usr/lib/os-release
sed -i "s|^BUG_REPORT_URL=.*|BUG_REPORT_URL=\"$BUG_SUPPORT_URL\"|" /usr/lib/os-release
sed -i "s|^CPE_NAME=\"cpe:/o:fedoraproject:fedora|CPE_NAME=\"cpe:/o:universal-blue:${IMAGE_PRETTY_NAME,}|" /usr/lib/os-release
sed -i "s/^DEFAULT_HOSTNAME=.*/DEFAULT_HOSTNAME=\"${IMAGE_PRETTY_NAME,}\"/" /usr/lib/os-release
sed -i "s/^ID=fedora/ID=${IMAGE_PRETTY_NAME,}\nID_LIKE=\"${IMAGE_LIKE}\"/" /usr/lib/os-release
sed -i "s/^LOGO=.*/LOGO=$LOGO_ICON/" /usr/lib/os-release
sed -i "s/^ANSI_COLOR=.*/ANSI_COLOR=\"$LOGO_COLOR\"/" /usr/lib/os-release
sed -i "/^REDHAT_BUGZILLA_PRODUCT=/d; /^REDHAT_BUGZILLA_PRODUCT_VERSION=/d; /^REDHAT_SUPPORT_PRODUCT=/d; /^REDHAT_SUPPORT_PRODUCT_VERSION=/d" /usr/lib/os-release

# Fix issues caused by ID no longer being fedora
sed -i "s/^EFIDIR=.*/EFIDIR=\"fedora\"/" /usr/sbin/grub2-switch-to-blscfg

# Overwrite kcm-about-distrorc
echo "[General]
LogoPath=/usr/share/pixmaps/fedora-logo-sprite.svg
Name=filotimo
Website=$HOME_URL
Variant=KDE Plasma" > /etc/xdg/kcm-about-distrorc
