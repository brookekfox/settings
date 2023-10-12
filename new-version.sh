#!usr/local/bin/bash

checkout_default_branch() {
  DEFAULT_BRANCH=$(git remote show origin | sed -n '/HEAD branch/s/.*: //p')
  echo "checking out and pulling default branch (${DEFAULT_BRANCH})"
  git checkout ${DEFAULT_BRANCH}
  git u
}

increment_version() {
  version=$1
  prefix=""
  if [[ "$version" == v* ]]; then
    prefix="v"
  fi
  version=${version#"release/"}
  version=${version#"v"}
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

  echo $(local IFS=$delimiter ; echo "${prefix}${array[*]}")
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

MOST_RECENT_TAG=$(git tag --sort=-creatordate | head -n 1)
USES_LEADING_V="true"
if [[ "$MOST_RECENT_TAG" != v* ]]; then
  USES_LEADING_V="false"
fi

if [[ "$USES_LEADING_V" == "true" ]]; then
  CURRENT_TAG=$(git tag --list | sort -r --version-sort | head -n1)
else
  CURRENT_TAG=$(git describe --tags --abbrev=0 --match "[0-9]*.[0-9]*.[0-9]*" $(git rev-list --tags --max-count=1))
fi
if [[ -z "$CURRENT_TAG" ]]; then
  echo "cannot find current tag. exiting..."; exit 1;
fi

NEXT_TAG=$(increment_version ${CURRENT_TAG} ${VERSION})
if [[ -z "$NEXT_TAG" ]]; then
  echo "cannot find next tag. exiting..."; exit 1;
fi

read -t 10 -p "CURRENT_TAG is ${CURRENT_TAG}, incrementing the ${VERSION} version to ${NEXT_TAG}. Continue (y/N)? " answer
if [[ "${answer}" == "y" || "${answer}" == "yes" ]]; then
  echo "creating new tag ${NEXT_TAG}"
  git tag -a ${NEXT_TAG} -m "${MESSAGE}"
  git push origin ${NEXT_TAG}
else
  echo "aborting"
  exit 1
fi
