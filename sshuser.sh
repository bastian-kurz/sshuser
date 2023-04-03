#!/bin/bash
#set -x

SCRIPTDIR=$(dirname "$0")
getopt --test > /dev/null

if [[ $? -ne 4 ]]; then
    echo "I’m sorry, `getopt --test` failed in this environment."
    exit 1
fi

function print_help {
    echo "This will create a new shell-user, give sudo-access and store public ssh-key"
    echo ""
    echo "Usage: sshuser.sh -u <username> -s '<public-ssh-key>'"
}

SHORT=u:s:h
LONG=user:,public_ssh_key:,help

PARSED=$(getopt --options $SHORT --longoptions $LONG --name "$0" -- "$@")
if [[ $? -ne 0 ]]; then
    exit 2
fi

eval set -- "$PARSED"

while true; do
    case "$1" in
        -u|--user)
            user=$2
            shift 2
            ;;
        -s|--public_ssh_key)
            public_ssh_key=$2
            shift 2
            ;;
        -h|--help)
            shift
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Programming error"
            exit 3
            ;;
    esac
done

if [ -z "$user" ]
then
    print_help
    exit
fi

if [ -z "$public-ssh-key" ]
then
    print_help
    exit
fi

adduser --disabled-password --gecos "" $user
usermod -a -G adm $user
usermod -a -G sudo $user
echo "$user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/90-cloud-init-users
mkdir /home/$user/.ssh
echo "$public_ssh_key" >> /home/$user/.ssh/authorized_keys
chown -R $user:$user /home/$user/.ssh
chmod -R go-rx /home/$user/.ssh