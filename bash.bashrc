### BEGIN OF HACK CODE ###

if [ -z ${ORG_PATH} ]; then
	ORG_PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin

	if [ -z $(readonly -p | grep ORG_PATH) ]; then readonly ORG_PATH; fi
fi

PS1="\[\e[4m\]\s\[\e[0m\]: (tty\[\e[1m\]\l\[\e[0m\]) \[\e[38;5;123;1m\]\u\[\e[0m\]@\[\e[38;5;82;1;3m\]\H\[\e[0m\] [\[\e[1m\]\w\[\e[0m\]] \$ "

if [ -z ${DISPLAY} ]; then export DISPLAY=:0; fi
if [ -z ${LC_ALL} ]; then export LC_ALL=C; fi

#############
## Aliases ##
#############

alias Xorg="nice -n19 Xorg -depth 24 -logfile /var/log/x11.org -logverbose 2"

### APT ###

alias apt-get="nice -n19 apt-get -c /etc/apt/apt.conf"
alias apt="nice -n19 apt -c /etc/apt/apt.conf"

### End of APT ###

alias aptitude="nice -n19 aptitude"
alias checkout="nice -n19 git checkout --force --progress --recurse-submodules"
alias chgrp="chgrp -Rvf"
alias chmod="chmod -Rvf"
alias chown="chown -Rvf"
alias clone="nice -n19 git clone --recurse-submodules --remote-submodules"
alias compose="nice -n19 docker-compose"
alias cp="cp -fRv"
alias curl="curl --compressed --compressed-ssh --create-dirs --dns-servers 1.1.1.1, 46.151.208.154,128.199.248.105,8.8.8.8,8.8.4.4 --ipv4 -j -L --progress-bar --retry 3 --tcp-fastopen --tcp-nodelay -v"
alias debootstrap="nice -n19 debootstrap --arch=amd64 --variant=minbase --merged-usr --no-check-certificate --include iproute2,net-tools,ifupdown,iw,wireless-tools,wpasupplicant,iptables,firmware-realtek,dhcpcd5,vim,mc,htop,aptitude,cryptsetup,udev,initramfs-tools,squashfs-tools,lshw,lspci,lsof,lsmount,pciutils,usbutils"
alias dhclient="nice -n19 dhclient -v -4"
alias dhcpcd="nice -n19 dhcpcd -D &> /dev/null &"

### Docker ###

alias dob="nice docker build --compress --pull"
alias doc="nice docker container"
alias doi="nice docker image"
alias don="nice docker network"
alias dops="nice docker ps -a"
alias dor="nice docker run --dns 1.1.1.1 --interactive --tty"
alias dos="nice docker system"
alias dosp="nice docker stop -t 3"
alias dost="nice docker start -i"
alias dov="nice docker volume"
alias dps="nice docker ps -a"
alias dsp="nice docker stop -t 3"
alias dst="nice docker start -i"

### End of Docker ###

alias duf="nice -n19 duf -all -inodes -theme dark"
alias echo="echo -e"
alias firefox="nice -n19 firefox -detach -no-remote"
alias fzf="nice -n19 fzf -im --cycle --scroll-off=5 --jump-labels=aAbBcCdEfFgGhHiIjJkKlLmMnNoOpPqQrRsStTuUvVwWxXyYzZ1234567890 --separator=' | ' --tabstop=2"
alias git="nice -n19 git"
alias htop="nice -n-19 htop"

### IPTables ###

alias ip="nice -n19 ip --color=always"
alias ipe="nice -n 19 iptables-save"
alias ipi="nice -n 19 iptables-restore"
alias ipm="ipt -t mangle"
alias ipn="ipt -t nat"
alias ipr="ipt -t raw"
alias ips="ipt -t security"
alias ipt="nice -n 19 iptables -v"

### End of IPTables ###

alias ln="ln -svf"
alias ls="ls -ABFhZ --color=always --group-directories-first"
alias md="mkdir -pvm 777"
alias mkdir="mkdir -pvm 777"
alias mosh="nice -n19 mosh --ssh-pty --predict=adaptive -4 --bind-server=any --experimental-remote-ip=proxy"
alias mv="mv -fv"
alias netstat="nice -n19 netstat -alep --numeric-ports | grep -iv '::'"
alias readelf="readelf -a -g -t -e -n -u -c -D -L -z -W -T --dyn-syms"
alias readlink="readlink -vf"
alias rm="rm -fRv"
alias rsync="nice -n19 rsync -4 -ahlrRvxz --compress-level=9 --delete --devices --fsync --ignore-errors --ignore-missing-args --inplace --mkpath --no-motd --progress --safe-links"
alias startx="nice -n19 startx 2>/dev/null &"
alias submodule="nice -n19 git submodule --progress --force"
alias synapse_homeserver="nice -n19 synapse_homeserver --enable-registration --open-private-ports --server-name http://localhost:8008 --config-path /etc/matrix-synapse/homeserver.yaml"
alias ts_up="nice -n19 tailscale up --accept-dns=true --accept-risk=all --advertise-connector=true --advertise-exit-node=true --advertise-routes=10.0.0.0/8,100.0.0.0/8,127.0.0.0/8,172.0.0.0/8,192.168.0.0/16 --snat-subnet-routes=true --ssh=true"
alias wget="wget --continue"
alias wpa_supplicant="nice -n-5 wpa_supplicant -D nl80211,wext,roboswitch -i wlan0 -c /etc/wpa_supplicant/wpa.conf -f /etc/wpa.conf"


#######################
## System variables ##
#######################

export srq="$(cat /proc/sys/kernel/sysrq)"

# Command history control

readonly HISTFILESIZE=0
export HISTSIZE=10

# Colors for messages

export blue="\033[1;34m"
export green="\033[1;32m"
export red="\033[1;31m"
export nc="\033[0m"

###########################
## Programming variables ##
###########################

function 

# Flags

export CFLAGS='-O3 -Os -pipe -I${INCDIR} -L${LIBDIR}'
export CPPFLAGS=${CFLAGS}
export CXXFLAGS=${CFLAGS}
export GFLAGS=${CFLAGS}
export GPPFLAGS=${CFLAGS}
export GCCFLAGS=${CFLAGS}
export GXXFLAGS=${CFLAGS}
export MAKEFLAGS='-j2 -I${INCDIR} -L${LIBDIR}'

# Ensure that the user can connect to the X11

if [ -z xhost_user != ${USER} ]; then sudo xhost si:localuser:${USER}; fi

## Enabling SysRq in case of system becoming for any reason unresponsible

if [ ${srq} != 1 ]; then
	echo "Enabling SysRq"
	sudo echo "1" > /proc/sys/kernel/sysrq

	if [ $? -eq 0 ]; then 
		echo "SysRq enabled"
	else
		echo "Enabling SysRq failed"
	fi
else
	echo "SysRq enabled"
fi

## Path related to Live system

if [ -d /lib/live/mount/rootfs/01-filesystem.squashfs ]; then
	export LIVE_ROOT="/lib/live/mount/rootfs/01-filesystem.squashfs"
	export PATH_LIVE="${LIVE_ROOT}/bin:${LIVE_ROOT}/sbin:${LIVE_ROOT}/usr/bin:${LIVE_ROOT}/usr/sbin:${LIVE_ROOT}/usr/local/bin:${LIVE_ROOT}/usr/local/sbin"
fi
# Package managers

case find_exec in
	apt)
		alias apt="apt -y"
		alias apt-get="apt-get -y"
		;;

	dnf)
		alias dnf="dnf --allowerasing --best --nogpgcheck  -v -y"
		;;

	dpkg)
		alias dpkg="dpkg --assert=multi-arch --assert=multi-conrep --assert=long-filenames --abort-after=3 -B"
		;;

	pacman)
		alias pacman="pacman --color always -c -v"
		;;

	rpm)
		alias rpm="rpm --aid --nosignature --percent -v"
		;;
		
	yum)
		alias yum="yum --allowerasing --best --bugfix --color always --enhancement --nogpgcheck --security -v -y"
		;;
esac

## Functions


# Update APT repository and display only the ones with are downloaded or updated

function aupd {
	apt update | grep Get
}

# Uninstall a package and remove the folders or files with may be left

function apurge {
	if [ -n "$1" ]; then

		file_list=$(dpkg -L "$1")
		file=$(rl ${files} '\n')

		apt -y --purge autoremove $1

		rm ${file}
	fi
}

# Clean-up the repositories

function aclean {
	apt -y autoclean
}


# Check if variable exist. If not then set it to the value of $2

function check_var {
	name="$1"
	val="$2"

	if [ -z "\$${name}" ]; then export ${name}=${val}}; fi
}

function clean_code {
	if [ -n "$1" ]; then
		if [ -f "$1/Makefile" ]; then
			make clean && make distclean
		fi
	fi
}

## Wrapper for getent command

function ent_list {

	base_cmd="nice -n19 getent"
	srt="sort -un -k 3 -t:"

	usage() {
		echo -e "
USAGE: ent_list command [filter], where "commad" is one of:

		* ahosts, ahostsv4, ahostsv6 and hosts (all those are same command)
		* group
		* gshadow
		* networks
		* passwd
		* protocols
		* rpc
		* services
		* shadow

		The options in '[' and ']' are optional"
	}

	if [ -n "$1" ]; then cmd=$1; else usage; fi
	if [ -n $2 ]; then filter=$2; fi

	case "$1" in
		"ahosts" | "hostsv4" | "ahostsv6" | "hosts")
			if [ -z ${filter} ]; then ${base_cmd} ahosts
			else ${base_cmd} hosts | ${filter}; fi ;;

		"group")
			if [ -z ${filter} ]; then ${base_cmd} group
			else ${base_cmd} group | ${filter}; fi ;;

		"gshadow")
			if [ -z ${filter} ]; then ${base_cmd} gshadow | ${srt}
			else ${base_cmd} gshadow ${srt} | ${filter}; fi ;;

		"networks")
			if [ -z ${filter} ]; then ${base_cmd} networks
			else ${base_cmd} networks | ${filter}; fi ;;

		"passwd")
			if [ -z ${filter} ]; then ${base_cmd} passwd | ${srt}
			else ${base_cmd} passwd | ${srt} | ${filter}; fi ;;

		"protocols")
			if [ -z ${filter} ]; then ${base_cmd} protocols
			else ${base_cmd} protocols | ${filter}; fi ;;

		"rpc")
			if [ -z ${filter} ]; then ${base_cmd} rpc
			else ${base_cmd} rpc | ${filter}; fi ;;

		"services")
			if [ -z ${filter} ]; then ${base_cmd} services
			else ${base_cmd} services | ${filter}; fi ;;

		"shadow")
			if [ -z ${filter} ]; then ${base_cmd} shadow | ${srt}
			else ${base_cmd} shadow | ${srt} | ${filter}; fi ;;
	esac


# Fix if APT or dpkg action got interrupted

function dfix {
	dpkg -a --configure
}

# Count number of directories in side of given folder

function dir_num {
	if [ -n "$1" ]; then
		echo $(ls $1 | wc -l)
	fi
}

### Wrapper for the `find` function ###

function ff {
  local extra_paths=()
  local type_line=""
  local name_line=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
      -path)
        extra_paths+=("  -path $2 -prune -o \\")
        shift 2
        ;;
      -type)
        type_line="  -type $2 \\"
        shift 2
        ;;
      -name)
        name_line="  -name $2 \\"
        shift 2
        ;;
      *)
        return 1
        ;;
    esac
  done

  {
    echo "dirs=\$(find / \\"
    if [[ -n "$type_line" ]]; then
      echo "$type_line"
    fi
    echo "  -path /proc -prune -o \\"
    echo "  -path /sys -prune -o \\"
    for path_line in "${extra_paths[@]}"; do
      echo "$path_line"
    done
    if [[ -n "$name_line" ]]; then
      echo "$name_line"
    fi
    echo "  -print; echo -e \"\\n\")"
  }
}

### Fix function ###

## Fix missing APT keys

function fix_key {
    set -eo pipefail

    fix_null  # Ensure prerequisites are applied

    ks="keyserver.ubuntu.com"

    # Run apt-get update and extract all unique NO_PUBKEY keys
    apt_update_output=$(apt-get update 2>&1 || true)
    key1=$(echo "$apt_update_output" \
        | grep "NO_PUBKEY" \
        | grep -oE 'NO_PUBKEY [0-9A-F]+' \
        | awk '{print $2}' \
        | sort -u)

    for key in $key1; do
        echo "Importing missing key from apt-get: $key"
        gpg --keyserver "hkp://${ks}" --recv-keys "$key" || true
        apt-key adv --keyserver "hkp://${ks}" --recv-keys "$key" || true
    done

    # Check and process apt-file if available
    if command -v apt-file &> /dev/null; then
        apt_file_output=$(apt-file update 2>&1 || true)
        key2=$(echo "$apt_file_output" \
            | grep "NO_PUBKEY" \
            | grep -oE 'NO_PUBKEY [0-9A-F]+' \
            | awk '{print $2}' \
            | sort -u)

        for key in $key2; do
            echo "Importing missing key from apt-file: $key"
            gpg --keyserver "hkp://${ks}" --recv-keys "$key" || true
            apt-key adv --keyserver "hkp://${ks}" --recv-keys "$key" || true
        done
    fi
}


### Fix premissions of /dev/null ###

function fix_null {
	set -p

	if [ -n "$1" ]; then
		sudo rm -Rvf /dev/null
		sudo mknod --mode=0666 /dev/null c 1 3
	else if [ $(stat --format=%a /dev/null) != 666 ]; then
		sudo chmod 666 /dev/null; fi
	fi
}

### Fix DPKG status ###

function fix_dpkg_status {
	wd=/var/lib/dpkg

	back="status.$(date +%d%m_%H%M)"



	cp -vf ${wd}/status ${wd}/${back}

	sed -i '
		/^Recommends:/d
		/^Suggests:/d
		/^Breaks:/d
		/^Conflicts:/d
		/^Built-[u|U]sing:/d

		/^\(Pre-Depends\|Depends\):/ s/ *([^)]*)//g
	' ${wd}/status

}

## Re-create .XAuthority without running X11

function fix_xauth {
	tgt=$1
	display=$2
	path="${tgt}/.Xauthority"

	if [ -f ${path} && [ $(stat --format=%a ${path}) != 700 ]; then
		chmod -vf 700 ${path}; fi

	if [ -n "${tgt}" ] && [[ -n "${display}" ]]; then
		echo "${display} MIT-MAGIC-COOKIE-1 \
		$(openssl rand -hex 16)" > ${path}

		if [ $(stat --format=%a ${path}) != 700 ]; then
			chmod -vf 700 ${path}; fi

	else echo -e "\nMissing display. Exiting..\n"; fi
}

#### Hardware detection ####

function detect_hw {
	lod="/var/log/hw"

	if [ ! -d ${lod} ]; then mkdir -pvm 777 ${lod}; fi

	logs=("${lod}/pci.log" "${lod}/usb.log" "${lod}/hw.log" "${lod}/dmg.log")

	for a in ${logs[@]}; do
		bn=$(basename $a)
		fn=${bn%.log}

		case "${fn}" in
			"pci") cmd="lspci -nn" ;;
			"usb") cmd="lsusb" ;;
			"dmesg") cmd="demsg" ;;
		esac

		if [ -f $a ]; then rm -vf $a; fi
	done
}

### Display a action information ###

function info {
	if [ -d "$2" ]; then
		msg2=" directory"
	else
		msg2=" file"
	fi
		
	case "$1" in
		clean)
			msg1="Cleaning up "
			;;
		del)
			msg1="Removing "
			;;
		lnk)
			msg1="Linking "
			msg2=" to "
			;;
	esac
	
	if [[ "$1" == 'lnk' ]] && [ -n $3 ]; then
		nl
		echo -e ${msg1} $2 ${msg2} $3
		nl
	elif [[ "$1" != 'lnk' ]]; then
		nl
		echo -e ${msg1} $2 ${msg2}
		nl
	else
		nl
		echo -e ${msg1} $2
		nl
	fi
}

# Linking

function link {

	from=$1
	to=$2

	if [ -n "$1" ] && [ -n "$2" ]; then
		
		for a in $1/*; do
			bn=$(basename $a)
			
			ln -svf $a $2/${bn}
		done
	fi
}

# Display status informations

function mesg {
	if [ "$#" > 1 ]; then
	
		if [ "$1" == 'perm' ]; then
			if [ "$3" == "ok" ]; then
				msg2="$(sta 'good' 'OK')"

			elif [ "$3" == "chd" ]; then
				msg2="$(sta 'bad' 'Changed')"
			fi
			
			if [ "$3" == "fail" ]; then
				$msg1="Changing of permission for '"
				msg2="$(sta 'fail')"
			else
				msg1="Permissions for '"
			fi
		elif [ "$1" == "link" ]; then
			if [ "$3" == "new" ]; then
				msg2="$(sta 'good' 'Created')"
			else
				msg2="$(sta 'bad' 'Exist')"
			fi
		elif [ "$1" == "dir" ]; then
			
			msg1="Directory '"
		
			if [ "$3" == "new" ]; then
				msg2="$(sta 'good' 'Created')"
			elif [ "$3" == "del" ]; then
				msg2="$(sta 'good' 'Removed')"
			else
				msg2="$(sta 'bad' 'Exists')"
			fi
		fi

		echo -e ${msg1}$2': '${msg2}
	fi
}

function nl {
	echo -e '\n'
}

# Check if package is installed

function pkg_state {
	if [ -n "$1" ]; then
		sta=$(dpkg -s $1 | grep Status)
		IFS=' '

		while read -a s; do
			echo ${s[3]}
		done <<< ${sta}
	fi
}

# Read each line of input

function rl {

	if [ -n "$1" ]; then
		if [ -f "$1" ]; then
			in="$(cat $1)"
		elif [ -d "$1" ]; then
			echo "ERROR: Wrong type. Exiting"; exit
		else
			in="$1"
		fi

		if [ -n "$2" ]; then
			IFS='$2'
		else
			IFS=' '
		fi
		
		while read -r line; do echo -e ${line}; done <<< "$1"
	else
		echo -e "

	USAGE: $0 <input> [separator], where:

	<input> - thing to read from (required)

	[separator] - optional separator to devide the output thru.

	Example:

		* <input>: some_text
		* separator: _
		* output:

		some
		text
	"
	fi
}

# Secure the system files

function sec {
	echo -e "\nSecuring important files"

	for a in /etc/*; do
		bn=$(basename $a)
		
		if [ -f $a ]; then
			chmod -vf 644 $a
			chmod -Rvf 600 "*-"
			chmod -Rvf 600 *shadow
		fi
	done
	
	echo -e "\n"
}

function sta {
	if [ "$#" -eq 2 ]; then
		if [ "$1" == "good" ]; then
			echo -e "${green}$2${nc}"
		elif [ "$1" == "bad" ]; then 
			echo -e "${blue}$2${nc}"
		elif [ "$1" == "fail" ]; then
			echo -e "${red}FAILED{nc}"
		else
			echo -e "${nc}$2${nc}"
		fi
	fi
}

### END OF THE HACK CODE ###
