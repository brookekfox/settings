#!usr/local/bin/bash

checkout_default_branch() {
  DEFAULT_BRANCH=$(git remote show origin | sed -n '/HEAD branch/s/.*: //p')
  echo "checking out and pulling default branch (${DEFAULT_BRANCH})"
  git checkout ${DEFAULT_BRANCH}
  git u
}

increment_version() {
  version=$1
  version="${version:1}"
  local delimiter=.
  local array=($(echo "$version" | tr $delimiter '\n'))
  if [[ "$2" == 'patch' ]]; then
    array[2]=$((array[2]+1)) # increment patch version
  elif [[ "$2" == 'minor' ]]; then
    array[1]=$((array[1]+1)) # increment minor version
    array[2]=0 # patch version is 0 now
  elif [[ "$2" == 'major' ]]; then
    array[0]=$((array[0]+1)) # increment major version
    array[1]=0 # minor version is 0 now
    array[2]=0 # patch version is 0 now
  else
    echo "$2 is not a valid version increment"
    exit 1
  fi
  echo $(local IFS=$delimiter ; echo "v${array[*]}")
}

while getopts v:m:b: FLAG
do
    case "${FLAG}" in
        v) VERSION=${OPTARG};;
        m) MESSAGE=${OPTARG};;
        b) BRANCH=${OPTARG};;
        *) echo "Invalid option: -${FLAG}. Flags are -v (VERSION - patch|minor|major), -m (MESSAGE), -b (BRANCH)"; exit 0 ;;
    esac
done

ALLOWED_VERSION_INCREMENTS="major minor patch"
if [[ -z "${MESSAGE}" || -z "${VERSION}" || "${ALLOWED_VERSION_INCREMENTS}" != *"${VERSION}"* ]]; then
  echo "must provide a message for the new tag and the version to increment (${ALLOWED_VERSION_INCREMENTS})"
  exit 1
fi

ALLOWED_ALT_BRANCHES="dev"
if [[ ! -z "${BRANCH}" && "${ALLOWED_ALT_BRANCHES}" != *"${BRANCH}"* ]]; then
  echo "the alternate branch must be one of the following: (${ALLOWED_ALT_BRANCHES})"
  exit 1
fi

if [[ -z "$BRANCH" ]]; then
  checkout_default_branch
else
  echo "checking out and pulling branch (${BRANCH})"
  git checkout ${BRANCH}
  git u
fi

echo "fetching all tags"
git fetch --all --tags

CURRENT_TAG=$(git tag --list v* | sort -r --version-sort | head -n1)
NEXT_TAG=$(increment_version ${CURRENT_TAG} ${VERSION})

read -t 10 -p "CURRENT_TAG is ${CURRENT_TAG}, incrementing the ${VERSION} version to ${NEXT_TAG}. Continue (y/N)? " answer
if [[ "${answer}" == "y" || "${answer}" == "yes" ]]; then
  echo "creating new tag ${NEXT_TAG}"
  git tag -a ${NEXT_TAG} -m "${MESSAGE}"
  git push origin ${NEXT_TAG}
else
  echo "aborting"
  exit 1
fi
