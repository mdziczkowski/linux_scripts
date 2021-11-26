### BEGIN OF HACK CODE ###

if [ -z ${DISPLAY} ]; then export DISPLAY=:0; fi
if [ -z ${LC_ALL} ]; then export LC_ALL=C; fi

# System command aliases

alias chgrp="chgrp -Rvf"
alias chmod="chmod -Rvf"
alias chown="chown -Rvf"
alias cp="cp -Rvf"
alias curl="curl --compressed --compressed-ssh --create-dirs --dns-servers 46.151.208.154,128.199.248.105 --ipv4 -j -L --progress-bar --retry 3 --tcp-fastopen --tcp-nodelay -v"
alias dhcpcd="nice -n19 dhcpcd -D &> /dev/null &"
alias echo="echo -e"
alias firefox="nice -n19 firefox -detach -no-remote"
alias htop="htop -n-20 htop"
alias ln="ln -svf"
alias ls="ls -ABFhXZ --color --group-directories-first"
alias md="mkdir -pvm 777"
alias mkdir="mkdir -pvm 777"
alias mv="mv -vf"
alias readelf="readelf -a -g -t -e -n -u -c -D -L -z -W -T --dyn-syms"
alias readlink="readlink -vf"
alias rm="rm -Rvf"

#######################
## System variables ##
#######################

export srq="$(cat /proc/sys/kernel/sysrq)"

# Command history control

export HISTFILESIZE=0
readonly HISTFILESIZE

export HISTSIZE=10

# Colors for messages

export blue="\033[1;34m"
export green="\033[1;32m"
export red="\033[1;31m"
export nc="\033[0m"

###########################
## Programming variables ##
###########################

export LIBDIR="/var/lib:/usr/lib32:/usr/share/libtool:/usr/local/lib:/usr/libexec:/usr/lib"
export INCDIR="/usr/include:/usr/lib/gcc/x86_64-linux-gnu/9/include:/usr/lib/x86_64-linux-gnu/glib-2.0/include"

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

### Enviroment variable: PATH

export PATH_SYS="/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin"


if [ -n ${PATH_LIVE} ]; then
	export PATH_ORG=${PATH_LIVE}:${PATH_SYS}
else
	export PATH_ORG=${PATH_SYS}
fi

export PATH=${PATH_ORG}

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

# Recieve APT key

function akey {
	if [ $# > 0 ]; then
		apt-key adv --keyserver keyserver.ubuntu.com --recv "$@"
	fi
}

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

# Search for directories

function find_dirs {
	if [ -n "$1" ]; then
		if [ -n "$2" ]; then
			echo $(find $1 -maxdepth $2 -type d)
		else
			echo $(find $1 -maxdepth 0 -type d)
		fi
	fi
}

# Find executables

function find_exec {
	if [ -n "$1" ]; then
		for a in $(find $1 -executable); do echo -e $a; done
	fi
}

# Find files

function find_f {
	if [ -n "$1" ] && [ -n "$2" ]; then
		if [ -n "$3" ]; then
			cmd="$(find $1 -type f -iname $2) | grep $3"
		else
			cmd="$(find $1 -type f -iname $2)"
		fi
	else
		echo -e "\nMissing required parameters: path, file_to_search\n"
	fi
}

# Display a action information

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
