#!/bin/bash
#
# Delete logs older than specific time using mtime
#

usage()
{
cat << EOF

usage $0 options

OPTIONS
  -d directory path
  -t unit of time

Example: ./delete-logs.sh -d /var/log/ -t 10
Any number of units may be combined in one argument, for example, "1.5" for 1 and half days.

EOF
}

path=''
unitoftime=''

if [ $# -eq 0 ];
then
  usage
  exit 1
fi

while getopts "hd:t:" opt
do
  case $opt in
  h)
    usage
    exit 1
    ;;
  d)
    echo "Path : $OPTARG"
    path=$OPTARG
    ;;
  t)
    echo "Unit of Time : $OPTARG"
    unitoftime=$OPTARG
    ;;
  \?)
    echo "Invalid option: $OPTARG" >&2
    usage
    exit 1
    ;;
  :)
    echo "Option -$OPTARG requires an argument." >&2
    usage
    exit 1
    ;;
  esac
done

if [ ! -z $path ] && [ ! -z $unitoftime ];
then
  if [ ! -d $path ]
  then
    echo "Directory Not Found!!!"
    exit 1
  fi
  echo "find ${path} -type f -mtime +${unitoftime}"
  find ${path} -type f -mtime +${unitoftime} -exec rm {} \;
  echo "Cleaned the backup logs..!"
  exit 0
fi