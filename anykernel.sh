### AnyKernel3 Ramdisk Mod Script
## osm0sis @ xda-developers

### AnyKernel setup
# begin properties
properties() { '
kernel.string=GKI 5.10 by ztc1997
do.devicecheck=0
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
device.name1=
device.name2=
device.name3=
device.name4=
device.name5=
supported.versions=
supported.patchlevels=
'; } # end properties

### AnyKernel install
# begin attributes
attributes() {
set_perm_recursive 0 0 755 644 $ramdisk/*;
set_perm_recursive 0 0 750 750 $ramdisk/init* $ramdisk/sbin;
} # end attributes


## boot shell variables
block=boot;
is_slot_device=1;
ramdisk_compression=auto;
patch_vbmeta_flag=auto;

# import functions/variables and setup patching - see for reference (DO NOT REMOVE)
. tools/ak3-core.sh && attributes;

# boot install
dump_boot; # use split_boot to skip ramdisk unpack, e.g. for devices with init_boot ramdisk

write_boot; # use flash_boot to skip ramdisk repack, e.g. for devices with init_boot ramdisk
## end boot install

## install add-on module
ui_print "Installing add-on module"

IFS=$'\n'
if [ -f /data/adb/ksud ]; then
    /data/adb/ksud module install $home/add-on-zram.zip >/dev/mod_log.log 2>&1
    /data/adb/ksud module install $home/add-on-schedhorizon.zip >>/dev/mod_log.log 2>&1
else 
    magisk --install-module $home/add-on-zram.zip >/dev/mod_log.log 2>&1
    magisk --install-module $home/add-on-schedhorizon.zip >>/dev/mod_log.log 2>&1
fi
cat /dev/mod_log.log | while read line
do
    ui_print "${line}"
done
