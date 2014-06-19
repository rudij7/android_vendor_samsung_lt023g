#!/system/bin/sh

#move NVM_ROOT_DIR to init.rc so other applications and services also use it.
#export  NVM_ROOT_DIR="/data/Linux/Marvell/NVM"

setprop marvell.ril.ppp.enabled 0
setprop log.tag.Mms:transaction V
setprop log.tag.Mms:app V
setprop log.tag.Mms:threadcache V
setprop android.telephony.apn-restore 600000
setprop sys.usb.diagmodem 1

setprop ro.marvell.platform.type TTC_TD

#copy default calibration xml to /NVM/ if dest not exist.
src_file="/etc/audio_swvol_calibration_def.xml"
dst_file="${NVM_ROOT_DIR}/audio_swvol_calibration.xml"

if [ -f "${dst_file}" ]; then
	echo "existing ${dst_file}";
else
	if [ -f "${src_file}" ]; then
		cp ${src_file} ${dst_file}
		chmod 666 ${dst_file}
		chown system.system ${dst_file}
		echo "cp: ${src_file} -> ${dst_file}"
	fi
fi

#backup log files
/system/bin/backup_log.sh

file_name="$NVM_ROOT_DIR/TDRF_Config.nvm"
file_exist=`ls $file_name`
case "$file_exist" in
	$file_name)
	echo "$NVM_ROOT_DIR/TDRF_Config.nvm";
	;;
	*)
		cat /system/etc/tel/ttc/TDRF_Config.nvm > $NVM_ROOT_DIR/TDRF_Config.nvm;
		chown system system $NVM_ROOT_DIR/TDRF_Config.nvm
		chmod 0666 $NVM_ROOT_DIR/TDRF_Config.nvm
	;;
esac

file_name="$NVM_ROOT_DIR/TTPCom_NRAM2_BAND_OPTIONS.GKI"
file_exist=`ls $file_name`
case "$file_exist" in
	$file_name)
	echo "$NVM_ROOT_DIR/TTPCom_NRAM2_BAND_OPTIONS.GKI";
	;;
	*)
		cat /system/etc/tel/ttc/TTPCom_NRAM2_BAND_OPTIONS.GKI > $NVM_ROOT_DIR/TTPCom_NRAM2_BAND_OPTIONS.GKI;
		chown system system $NVM_ROOT_DIR/TTPCom_NRAM2_BAND_OPTIONS.GKI
		chmod 0666 $NVM_ROOT_DIR/TTPCom_NRAM2_BAND_OPTIONS.GKI
	;;
esac

#KSND added
# $1 src file  $2 dst file
function copy_if_not_exist()
{
if [ -f "${2}" ]; then
	echo "existing ${2}";
else
	if [ -f "${1}" ]; then
		cp ${1} ${2}
		chmod 666 ${2}
		chown system.system ${2}
		echo "cp: ${1} -> ${2}"
	fi
fi
}

#copy default audio effect xml to /NVM/ if dest not exist.
src_file="audio_effect_config.xml"
dst_file="audio_effect_config.xml"
copy_if_not_exist "/etc/${src_file}" "${NVM_ROOT_DIR}/${dst_file}"

#copy gain calibration xml to /NVM/ if dest not exist.
src_file="ttc/audio_gain_calibration.xml"
dst_file="audio_gain_calibration.xml"
copy_if_not_exist "/etc/tel/${src_file}" "${NVM_ROOT_DIR}/${dst_file}"

#copy default audio nvm to /NVM if audio does not exist.
file_name=$NVM_ROOT_DIR/audio_MSAmain.nvm
if [ -f ${file_name} ]; then
    echo "existing $NVM_ROOT_DIR/audio_MSAmain.nvm";
else
	cp /system/etc/tel/ttc/audio*.nvm $NVM_ROOT_DIR/
	chmod 666 $NVM_ROOT_DIR/audio*.nvm
	echo "Copying audio*.nvm has done!"
fi

/system/bin/run_composite.sh;

