# These and other macros are documented in
# ../droid-configs-device/droid-configs.inc
%define device onyx
%define vendor oneplus

%define vendor_pretty OnePlus
%define device_pretty X

%define dcd_path ./
# Adjust this for your device
%define pixel_ratio 1.75
# We assume most devices will
%define have_modem 1

Provides: ofono-configs

# Packages to be uninstalled
Obsoletes: ofono-configs-mer
Obsoletes: usb-moded-mass-storage-android-config
Obsoletes: usb-moded-diag-mode-android

%include droid-configs-device/droid-configs.inc
