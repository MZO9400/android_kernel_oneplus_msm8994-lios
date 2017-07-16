# AnyKernel2 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# EDIFY properties
kernel.string=franco.Kernel by franciscofranco @ xda-developers
do.devicecheck=1
do.initd=0
do.modules=0
do.cleanup=1
do.cleanuponabort=1
device.name1=OnePlus2
device.name2=oneplus2

# shell variables
block=/dev/block/platform/soc.0/f9824900.sdhci/by-name/boot;
is_slot_device=0;

## end setup

# import patching functions/variables - see for reference
. /tmp/anykernel/tools/ak2-core.sh;
## AnyKernel install
dump_boot;

# begin ramdisk changes

# init.qcom.rc
insert_line init.qcom.rc "init.lios.rc"
#replace_string init.angler.rc "#    verity_load_state" "    verity_load_state" "#    verity_load_state"
#replace_string init.angler.rc "#    verity_update_state" "    verity_update_state" "#    verity_update_state"
#replace_section init.angler.rc "service atfwd" "group system radio" "service atfwd /system/bin/ATFWD-daemon\n    disabled\n    class late_start\n    user system\n    group system radio";

# end ramdisk changes

write_boot;

## end install
