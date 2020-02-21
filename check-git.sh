#!/bin/sh

auto_commit_wip_changes(){
  local VN="$VN-mod"
  local COMMIT=$(git commit -am"WIP - automated saved")
  echo "commit done $COMMIT"
  lastcommit=$(git log -1 --oneline)
  echo $lastcommit
}

verify_autocommit () {
  # $1 => lastcommit cached
  local CHANGED="$(git diff-index --name-only HEAD --)"
  if [ -n "$CHANGED" ];
    then
      echo "found changes"
      auto_commit_wip_changes
    else
      echo "No new changes found"
  fi
}

auto_push_wip_changes(){
  local VN="$VN-mod"
  # local COMMIT=$(git commit -am"WIP - automated saved")
  echo "commit done $COMMIT"
  local lastcommit=$(git log -1 --oneline)
  echo $lastcommit
}

verify_and_auto_create_remote_branch () {
  local branch="$(git rev-parse --abbrev-ref HEAD)"
  exist=$(git ls-remote --head origin $branch)
  if [ -z "$exist" ]
    then 
      echo "branch doesn't exist"
      echo "$(git push origin $branch)"
    # else 
    #   echo "exist"
  fi
}

auto_sync_branch () {
  echo "auto sync $1"
}

verify_auto_push () {
  local branch="$(git rev-parse --abbrev-ref HEAD)"
  # local lastcommithash="$(git rev-parse origin/$branch)" #this is giving error
  # echo "last commit $lastcommithash"
  verify_and_auto_create_remote_branch
  auto_sync_branch "$branch"
}

main (){
  while [ true ]
  do
    local branch="$(git rev-parse --abbrev-ref HEAD)"
    if [ "$branch" != 'master' ]
      then
        echo "you are on $branch"
        verify_autocommit
        sleep 2s
        verify_auto_push
        echo "sleeping 3s"\n\n
        sleep 5s
      else
        echo "You are on master, change the branch to be able to auto save"\n\n
        sleep 10s
    fi
  done
}

main