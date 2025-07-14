#!/usr/bin/bash
set -ouex pipefail

# See https://github.com/ublue-os/packages/blob/main/packages/ublue-setup-services
source /usr/lib/ublue/setup-services/libsetup.sh
version-script hardware system 2 || exit 0

KARGS=$(rpm-ostree kargs)
NEEDED_KARGS=()
NEEDS_REBOOT=0
NEEDS_MODULE_RELOAD=0
NEEDS_UDEV_RELOAD=0

SYS_ID="$(cat '/sys/devices/virtual/dmi/id/product_name')"
VEN_ID="$(cat '/sys/devices/virtual/dmi/id/chassis_vendor')"
CPU_VENDOR=$(grep "vendor_id" "/proc/cpuinfo" | uniq | awk -F": " '{ print $2 }')
CPU_MODEL=$(grep "model name" "/proc/cpuinfo" | uniq | awk -F": " '{ print $2 }')

notify_reboot_needed() {
  plymouth display-message --text="Configuring hardware — your system will reboot shortly…" || true
  NEEDS_REBOOT=1
}

configure_karg_and_notify_reboot() {
  local karg_operation_and_value="$1"
  notify_reboot_needed
  NEEDED_KARGS+=("$karg_operation_and_value")
}

notify_module_reload_needed() {
  plymouth display-message --text="Configuring hardware…" || true
  NEEDS_MODULE_RELOAD=1
}

notify_udev_reload_needed() {
  plymouth display-message --text="Configuring hardware…" || true
  NEEDS_UDEV_RELOAD=1
}

# Ensure full preempt is enabled
if [[ ! $KARGS =~ "preempt" ]]; then
  configure_karg_and_notify_reboot "--append-if-missing=preempt=full"
fi

# Ensure nomodeset is disabled
if [[ $KARGS =~ "nomodeset" ]]; then
	configure_karg_and_notify_reboot "--delete-if-present=nomodeset"
fi

# Fstab adjustments
if [[ ! -e /etc/ublue-os/.fstab_adjusted.flag && $(grep "compress=zstd" /etc/fstab) ]]; then
  plymouth display-message --text="Configuring hardware — your system will reboot shortly…" || true
  echo "Applying fstab param adjustments"
  for subvol in root home var; do
    sed -i "/subvol=$subvol/s/compress=zstd:1/noatime,lazytime,commit=120,discard=async,compress=zstd:1,space_cache=v2/" /etc/fstab
  done
  mkdir -p /etc/ublue-os/
  touch /etc/ublue-os/.fstab_adjusted.flag
  NEEDS_REBOOT=1
else
  echo "No fstab param adjustments needed"
fi

# Framework AMD fixes
if [[ ":Framework:" =~ ":$VEN_ID:" ]]; then
  if [[ "AuthenticAMD" == "$CPU_VENDOR" ]]; then
    # Load Ryzen SMU on AMD Framework Laptops
    if ! [[ -f "/etc/modules-load.d/ryzen_smu.conf" ]]; then
      notify_module_reload_needed
      mkdir -p "/etc/modules-load.d"
      printf "# Load ryzen_smu driver upon startup\nryzen_smu\n" >> "/etc/modules-load.d/ryzen_smu.conf"
    fi
    # Framework 13 AMD fixes
    if [[ "$SYS_ID" == "Laptop ("* ]]; then
      if [[ ! -f /etc/modprobe.d/alsa.conf ]]; then
        notify_module_reload_needed
        echo 'Fixing 3.5mm jack'
        echo "options snd-hda-intel index=1,0 model=auto,dell-headset-multi" > /etc/modprobe.d/alsa.conf
        echo 0 > /sys/module/snd_hda_intel/parameters/power_save
      fi
      if [[ ! -f /etc/udev/rules.d/20-suspend-fixes.rules ]]; then
        notify_udev_reload_needed
        echo 'Fixing suspend issue'
        echo "ACTION==\"add\", SUBSYSTEM==\"serio\", DRIVERS==\"atkbd\", ATTR{power/wakeup}=\"disabled\"" > /etc/udev/rules.d/20-suspend-fixes.rules
      fi
    fi
  fi
fi
if [[ ! ":Framework:" =~ ":$VEN_ID:" ]]; then
  if [[ ! "AuthenticAMD" == "$CPU_VENDOR" ]]; then
    if [[ -f "/etc/modules-load.d/ryzen_smu.conf" ]]; then
      notify_module_reload_needed
      rm -rf "/etc/modules-load.d/ryzen_smu.conf"
    fi
  fi
  if [[ -f "/etc/udev/rules.d/20-suspend-fixes.rules" ]]; then
    notify_udev_reload_needed
    rm -rf "/etc/udev/rules.d/20-suspend-fixes.rules"
  fi
  if [[ -f "/etc/modprobe.d/alsa.conf" ]]; then
    if grep -q '^options snd-hda-intel index=1,0 model=auto,dell-headset-multi$' /etc/modprobe.d/alsa.conf; then
      notify_module_reload_needed
      sed -i '/^options snd-hda-intel index=1,0 model=auto,dell-headset-multi$/d' /etc/modprobe.d/alsa.conf
    fi
  fi
fi


# Other Framework fixes
if [[ ":Framework:" =~ ":$VEN_ID:" ]]; then
  if [[ "AuthenticAMD" == "$CPU_VENDOR" ]]; then
    if [[ ! $KARGS =~ "iomem" ]]; then
      configure_karg_and_notify_reboot "--append-if-missing=iomem=relaxed"
    fi
  elif [[ "GenuineIntel" == "$CPU_VENDOR" ]]; then
    if [[ ! $KARGS =~ "hid_sensor_hub" ]]; then
      configure_karg_and_notify_reboot "--append-if-missing=module_blacklist=hid_sensor_hub"
    fi
  fi
fi
if [[ ! ":Framework:" =~ ":$VEN_ID:" ]]; then
  if [[ $KARGS =~ "iomem=relaxed" ]]; then
    configure_karg_and_notify_reboot "--delete-if-present=iomem=relaxed"
  fi
  if [[ $KARGS =~ "module_blacklist=hid_sensor_hub" ]]; then
    configure_karg_and_notify_reboot "--delete-if-present=module_blacklist=hid_sensor_hub"
  fi
fi

# Surface fixes
if [[ ":Microsoft:" =~ ":$VEN_ID:" ]]; then
  if ! [[ -f "/etc/modules-load.d/surface.conf" ]]; then
    notify_module_reload_needed
    sed 's/^ *//' > "/etc/modules-load.d/surface.conf" << EOF
      # Add modules necessary for Disk Encryption via keyboard
      surface_aggregator
      surface_aggregator_registry
      surface_aggregator_hub
      surface_hid_core
      8250_dw

      # Surface Laptop 3/Surface Book 3 and later
      surface_hid
      surface_kbd

EOF
    if [[ "AuthenticAMD" == "$CPU_VENDOR" ]]; then
      printf "# Support GPIO pins on AMD Surfaces\npinctrl_amd\n" >> "/etc/modules-load.d/surface.conf"
    elif [[ "GenuineIntel" == "$CPU_VENDOR" ]]; then
      sed 's/^ *//' >> "/etc/modules-load.d/surface.conf" << EOF
        # Support LPSS on Intel Surfaces
        intel_lpss
        intel_lpss_pci

        # Support GPIO pins on Intel Surfaces
        # Surface Book 2
        pinctrl_sunrisepoint

        # For Surface Laptop 3/Surface Book 3
        pinctrl_icelake

        # For Surface Laptop 4/Surface Laptop Studio
        pinctrl_tigerlake

        # For Surface Pro 9/Surface Laptop 5
        pinctrl_alderlake

        # For Surface Pro 10/Surface Laptop 6
        pinctrl_meteorlake
EOF
    fi
  fi
fi

if ! [[ ":Microsoft:" =~ ":$VEN_ID:" ]]; then
  if [[ -f "/etc/modules-load.d/surface.conf" ]]; then
    notify_module_reload_needed
    rm -rf /etc/modules-load.d/surface.conf
  fi
fi

# NVIDIA sometimes doesn't like sleep
if nvidia-smi &>/dev/null && [[ ! "$KARGS" =~ "mem_sleep_default" ]]; then
  configure_karg_and_notify_reboot "--append-if-missing=mem_sleep_default=s2idle"
fi
if ! nvidia-smi &>/dev/null && [[ "$KARGS" =~ "mem_sleep_default" ]]; then
  configure_karg_and_notify_reboot "--delete-if-present=mem_sleep_default=s2idle"
fi

# Fix from Bluefin
if nvidia-smi &>/dev/null && [[ ! "$KARGS" =~ "initcall_blacklist=simpledrm_platform_driver_init" ]]; then
  configure_karg_and_notify_reboot "--append-if-missing=initcall_blacklist=simpledrm_platform_driver_init"
fi
if ! nvidia-smi &>/dev/null && [[ "$KARGS" =~ "initcall_blacklist=simpledrm_platform_driver_init" ]]; then
  configure_karg_and_notify_reboot "--delete-if-present=initcall_blacklist=simpledrm_platform_driver_init"
fi

# Apply karg changes
if [[ ${#NEEDED_KARGS[@]} -gt 0 ]]; then
  echo "Found needed karg changes, applying the following: ${NEEDED_KARGS[*]}"
  rpm-ostree kargs ${NEEDED_KARGS[*]} || exit 1
  NEEDS_REBOOT=1
else
  echo "No karg changes needed"
fi

if [[ "$NEEDS_REBOOT" -eq 1 ]]; then
  systemctl reboot
fi

if [[ "$NEEDS_MODULE_RELOAD" -eq 1 ]]; then
  systemctl restart systemd-modules-load.service
fi

if [[ "$NEEDS_UDEV_RELOAD" -eq 1 ]]; then
  systemctl restart systemd-udevd.service
fi

plymouth hide-message --text="Configuring hardware…" || true
