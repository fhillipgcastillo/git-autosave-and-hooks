#!/bin/sh

save_logfile () {
  today=$(date +"%F")
  nowt=$(date +"%T")
  LOGFILE="$today.log"
  echo "$(echo "$nowt - $1" >> log-$today.log)"
}

auto_commit_wip_changes(){
  local VN="$VN-mod"
  local COMMIT=$(git commit -am"WIP - automated saved")
  save_logfile "$COMMIT"
  echo "commit done $COMMIT"
}

verify_autocommit () {
  # $1 => lastcommit cached
  local CHANGED="$(git diff-index --name-only HEAD --)"
  if [ -n "$CHANGED" ];
    then
      echo "found changes"
      save_logfile "Found new changes"
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
  local branch=$1
  exist=$(git ls-remote --head origin $branch)
  if [ -z "$exist" ]
    then 
      msg = "branch doesn't exist"
      save_logfile "$msg"
      echo msg
      local push="$(git push origin $branch)"
      save_logfile "$push"
      echo "$push"
    # else 
    #   echo "exist"
  fi
}

auto_sync_branch () {
  echo "auto sync $1"
  branch="$1"
  remoteBranch="origin/$1"
  # local lastcommithash="$(git rev-parse origin/$branch)" #this is giving error
  # echo "last commit $lastcommithash"
  localCommit=$(git rev-parse $branch)
  remoteCommit=$(git rev-parse $remoteBranch)
  if [ x"$localCommit" = x"$remoteCommit" ]
  then
    echo "changes are on sync"
  else 
    echo "syncing branch"
    # echo "local $localCommit"
    # echo "remote $remoteCommit"
    save_logfile "Syncing branch commits"
    push="$(git push origin $branch)"
    save_logfile "$push"
  fi
}

verify_auto_push () {
  local branch="$(git rev-parse --abbrev-ref HEAD)"
  verify_and_auto_create_remote_branch "$branch"
  auto_sync_branch "$branch"
}

main (){
  while [ true ]
  do
    local branch="$(git rev-parse --abbrev-ref HEAD)"
    if [ "$branch" != 'master' ]
      then
        echo $(clear)
        echo "you are on $branch"
        verify_auto_push
        echo "sleeping 3s"
        sleep 5s
        verify_autocommit
        sleep 2s
      else
        echo $(clear)
        echo "You are on master, change the branch to be able to auto save"
        sleep 10s
    fi
  done
}

main