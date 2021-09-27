#!bin/bash

while getopts d:c:b:t: flag
do
    case "${flag}" in
        d) directory=${OPTARG};;
        c) command=${OPTARG};;
        b) branch=${OPTARG};;
        t) tag=${OPTARG};;
        *) echo "Invalid option: -$flag. flags are -d (directory), -c (command), -b (branch), -t (tag). commands are checkout-master, composer-update, cut-new-branch, checkout-branch, stash, build-docker-image"; exit 0 ;;
    esac
done

if [ -z "$directory" ]; then
  directory="$( pwd )"
fi

for d in $directory/*/ ; do
    echo "$d"
    cd "$d"
    if [ "$command" == "checkout-master" ]; then
      echo "checking out, pulling, fetching master"
      git com
      git u
    elif [ "$command" == "composer-update" ]; then
      echo "updating composer packages"
      composer update
    elif [ "$command" == "cut-new-branch" ]; then
      echo "cutting a new branch"
      git cob "$branch"
    elif [ "$command" == "checkout-branch" ]; then
      echo "checking out and pulling branch"
      git co "$branch"
      git pull origin "$branch"
    elif [ "$command" == "stash" ]; then
      echo "stashing"
      git stash
    elif [ "$command" == "clear-logs" ]; then
      echo "removing and recreating log files"
      rm logs/php/php-fpm.log && touch logs/php/php-fpm.log
      rm logs/nginx/access.log && touch logs/nginx/access.log
      rm logs/nginx/error.log && touch logs/nginx/error.log
    elif [ "$command" == "build-docker-image" ]; then
      repo="$( basename "$PWD" )"
      echo "updating composer packages"
      composer update
      echo "building new docker tag $repo/web-server:$tag"
      docker build -t "$repo/web-server:$tag" -f Dockerfile .
      docker tag "$repo/web-server:$tag" gitlab.aofl.com:5001/abcmouse-international/"$repo/web-server:$tag"
      docker push gitlab.aofl.com:5001/abcmouse-international/"$repo/web-server:$tag"
    else
      echo "$command is not a valid command"
      exit 1
    fi
done
