ARG IMAGE_NAME="${IMAGE_NAME:-filotimo}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-41}"
ARG KERNEL_FLAVOR="${KERNEL_FLAVOR:-bazzite}"
# Fetched dynamically outside the Containerfile - use the build script
ARG KERNEL_VERSION="${KERNEL_VERSION:-6.12.12-206.bazzite.fc41.x86_64}"
ARG BASE_IMAGE_NAME="${BASE_IMAGE_NAME:-kinoite-main}"
ARG SOURCE_ORG="${SOURCE_ORG:-ublue-os}"
ARG BASE_IMAGE="ghcr.io/${SOURCE_ORG}/${BASE_IMAGE_NAME}"
ARG IMAGE_VENDOR="${IMAGE_VENDOR:-filotimo}"
ARG IMAGE_TAG="${IMAGE_TAG:-latest}"

FROM scratch AS ctx
COPY / /

FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION} as filotimo

ARG IMAGE_NAME="${IMAGE_NAME:-filotimo}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-41}"
ARG KERNEL_FLAVOR="${KERNEL_FLAVOR:-bazzite}"
# Fetched dynamically outside the Containerfile - use the build script
ARG KERNEL_VERSION="${KERNEL_VERSION:-6.12.12-206.bazzite.fc41.x86_64}"
ARG BASE_IMAGE_NAME="${BASE_IMAGE_NAME:-kinoite-main}"
ARG SOURCE_ORG="${SOURCE_ORG:-ublue-os}"
ARG BASE_IMAGE="ghcr.io/${SOURCE_ORG}/${BASE_IMAGE_NAME}"
ARG IMAGE_VENDOR="${IMAGE_VENDOR:-filotimo}"
ARG IMAGE_TAG="${IMAGE_TAG:-latest}"

# Entirely build the image
RUN --mount=type=cache,dst=/var/cache/libdnf5 \
    --mount=type=cache,dst=/var/cache/rpm-ostree \
    --mount=type=bind,from=ctx,source=/,target=/ctx \
    /ctx/build/build.sh
