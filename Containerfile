ARG IMAGE_NAME="${IMAGE_NAME:-filotimo}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-42}"
ARG BASE_IMAGE="ghcr.io/ublue-os/kinoite-main"
ARG IMAGE_VENDOR="${IMAGE_VENDOR:-filotimo}"
ARG IMAGE_TAG="${IMAGE_TAG:-latest}"

FROM scratch AS ctx
COPY / /

FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION} as filotimo

ARG IMAGE_NAME="${IMAGE_NAME:-filotimo}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-42}"
ARG BASE_IMAGE="ghcr.io/ublue-os/kinoite-main"
ARG IMAGE_VENDOR="${IMAGE_VENDOR:-filotimo}"
ARG IMAGE_TAG="${IMAGE_TAG:-latest}"

# Entirely build the image
RUN --mount=type=cache,dst=/var/cache/libdnf5 \
    --mount=type=cache,dst=/var/cache/rpm-ostree \
    --mount=type=bind,from=ctx,source=/,target=/ctx \
    /ctx/build/build.sh && \
    ostree container commit

# Ensure image is correct
RUN bootc container lint
