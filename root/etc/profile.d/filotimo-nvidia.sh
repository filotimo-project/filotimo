MODULE="nvidia"
if lsmod | grep -wq "$MODULE"; then
    export LIBVA_DRIVER_NAME=nvidia
    export MOZ_DISABLE_RDD_SANDBOX=1
    export EGL_PLATFORM=$XDG_SESSION_TYPE
fi
