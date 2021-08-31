### BEGIN OF HACK CODE ###

# System command aliases

alias mv="mv -vf"
alias cp="cp -Rvf"
alias rm="rm -Rvf"
alias chmod="chmod -vf"
alias chown="chown -vf"
alias cp="cp -Rvf"
alias echo="echo -e"
alias firefox="nice -n19 firefox -detach -no-remote"
alias htop="htop -n-20 htop"
alias ln="ln -svf"
alias ls="ls -ABFhXZ --color --group-directories-first"
alias mkdir="mkdir -pvm 777"
alias readelf="readelf -a -g -t -e -n -u -c -D -L -z -W -T --dyn-syms"
alias readlink="readlink -vf"

# Command history control

export HISTFILESIZE=0
readonly HISTFILESIZE

export HISTSIZE=10

# Colors for messages

export blue="\033[1;34m"
export green="\033[1;32m"
export red="\033[1;31m"
export nc="\033[0m"

## Functions

# Read each line of input
function rl {
	if [ -z "$1" ]; then echo -e "

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
	else
		if [ -f "$1" ]; then in="$(cat $1)"
		elif [ -d "$1" ]; then echo "ERROR: Wrong type. Exiting"; exit
		else in="$1"
		fi


		if [ -n "$2" ]; then

			while IFS="$2" && read -r line; do echo -e ${line}; done <<< "${in}"
			unset ${IFS}
		else
			while read -r line; do echo -e ${line}; done <<< "${in}}"
		fi
	fi
}

# Check if variable exist. If not then set it to the value of $2

function check_var {
	if [ -z "\${$1}" ]; then export $1=$2; fi
}

# Find exectutables

function find_f {
	if [ -n "$1" ]; then

		$(rl)

		if [ -n "$2" ]; then
			cmd="$(find / -type f -iname $1) | grep $2"
		else
			cmd="$(find / -type f -iname $1)"
		fi
	else
		echo -e "\nNothing set to find\n"
	fi
}

# Get users from xhost

function xhost_user {
	in="rl $(xhost)"
	
	while ${in}; do
		usr=${in:13}
		echo -e ${in}
	done
}

function find_exec {
	if [ -n "$1" ]; then
		for a in $(find_f $1 *"bin/*"); do
			if [ -x "$1" ]; then echo -e $a; fi
		done
	fi
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

function bn {
	if [ -n "$1" ]; then
		echo -e $(basename "$1")
	fi
}

# Secure the system files

function sec {
	if [ -z "${FIRST_RUN}" ] || [ "${FIRST_RUN}" != "false" ]; then

		echo -e "\nSecuring important files"
		echo -e "\n"
		echo -e "[*] Backup of the password, group, shadow files"
		echo -e "\n"
		for sb in $(find /etc -iname "*-"); do
			if [ $(stat -c "%a" ${sb}) == "0" ]; then
				echo -e "$(mesg 'perm' ${sb} 'ok')"
			else
				chmod -vf 0000 ${sb}
				echo -e "$(mesg 'perm' ${sb} 'cgd')"
			fi
		done

		echo -e "\n[*] Shadow file\n"
		for shw in $(find /etc -iname "*shadow"); do
			if [ $(stat -c "%a" ${shw}) == "411" ]; then
				echo -e "$(mesg 'perm' ${shw} 'ok')"
			else
				chmod -vf 0411 ${shw}
				echo -e "$(mesg 'perm' ${shw} 'cgd')"
			fi
		done

		echo -e "\n[*] Group file\n"

		for grp in $(find /etc -iname "group"); do
			if [ ${grp} != $(readlink /etc/iproute2/group) ]; then
				if [ $(stat -c "%a" ${grp}) == "411" ]; then
					echo -e "$(mesg 'perm' ${grp} 'ok')"
				else
					if [ ${grp} != $(readlink /etc/iproute2/group) ]; then
						chmod 0411 ${grp}
						echo -e "$(mesg 'perm' ${grp} 'cgd')"
					fi
				fi
			fi
		done
		echo -e "\n"
	fi
}

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


### Variables ###

## Ensuring that the required system variables are set correctly ##

# PATH and it's backup

export PATH_ORG=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/usr/local/games:/usr/games
readonly PATH_ORG

if [ -d /usr/lib/jvm/java-16-openjdk-amd64 ]; then export PATH=${PATH}:/usr/lib/jvm/java-16-openjdk-amd64/bin; fi

export PATH=${PATH_ORG}

check_var DISPLAY DISPLAY=:0

if [ -z xhost_user != ${USER} ]; then xhost si:localuser:${USER}; fi

### Programming enviroment variables

check_var LIBDIR "/var/lib:/usr/lib32:/usr/share/libtool:/usr/local/lib:/usr/libexec:/usr/lib"
check_var INCDIR "/usr/include:/usr/lib/gcc/x86_64-linux-gnu/9/include:/usr/lib/x86_64-linux-gnu/glib-2.0/include"

check_var CFLAGS "-O3 -pipe -I${INCDIR} -L${LIBDIR}"
check_var CPPFLAGS "${CFLAGS}"
check_var CXX_FLAGS "${CFLAGS}"

check_var MAKEFLAGS "-j4 -I${LIBDIR} -I${INCDIR}"

### END OF THE HACK CODE ###
