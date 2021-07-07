#!bin/bash

while getopts d:c:b:h:hc: flag
do
    case "${flag}" in
        d) directory=${OPTARG};;
        c) command=${OPTARG};;
        b) branch=${OPTARG};;
        # h) echo "flags are -d (directory), -c (command), -b (branch)"; exit 0 ;;
        # hc) echo "commands are checkout-master, composer-update, cut-new-branch, checkout-branch"; exit 0 ;;
        *) echo "Invalid option: -$flag"; exit 0 ;;
    esac
done

if [ -z "$directory" ]; then
  directory="$( pwd )"
fi

for d in $directory/*/ ; do
    echo "$d"
    cd "$d"
    if [ "$command" == "checkout-master" ]; then
      git com
      git u
    elif [ "$command" == "composer-update" ]; then
      composer update
    elif [ "$command" == "cut-new-branch" ]; then
      git cob "$branch"
    elif [ "$command" == "checkout-branch" ]; then
      git co "$branch"
    else
      echo "$command is not a valid command"
      exit 1
    fi
done
