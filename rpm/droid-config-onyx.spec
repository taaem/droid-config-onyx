# These and other macros are documented in
# ../droid-configs-device/droid-configs.inc
%define device onyx
%define vendor oneplus

%define vendor_pretty OnePlus
%define device_pretty X

%define dcd_path ./
# Adjust this for your device
%define pixel_ratio 2.0
# We assume most devices will
%define have_modem 1

Obsoletes: ofono-configs-mer
Provides: ofono-configs

%include droid-configs-device/droid-configs.inc
