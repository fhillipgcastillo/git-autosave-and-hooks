#!/bin/sh
# Author: Fhillip G. Castillo
# Mail: gerson.fhillip@gmail.com

save_logfile () {
  today=$(date +"%F")
  nowt=$(date)
  echo "$(echo "$nowt - $1" >> $today-autosave.log)"
}

auto_commit_wip_changes(){
  local VN="$VN-mod"
  local COMMIT=$(git commit -am"WIP - automated saved")
  save_logfile "$COMMIT"
  echo "commit done $COMMIT"
}

verify_to_autocommit () {
  # verify for new files changes to commit
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

verify_and_auto_create_remote_branch () {
  local branch=$1
  exist=$(git ls-remote --head $REMOTE $branch)

  if [ -z "$exist" ]
    then 
      msg = "branch doesn't exist"
      save_logfile "$msg"
      echo msg
      push="$(git push $REMOTE $branch)"
      save_logfile "branch created to remote"
      save_logfile "$branch"
      echo "$push"

  fi
}

auto_sync_branch () {
  echo "auto sync $1"
  branch="$1"
  remoteBranch="$REMOTE/$1"
  localCommit=$(git rev-parse $branch)
  remoteCommit=$(git rev-parse $remoteBranch)
  if [ x"$localCommit" = x"$remoteCommit" ]
  then
    echo "changes are on sync"
  else 
    echo "syncing branch commits"
    echo "pulling..."
    save_logfile "Syncing branch commits..."
    pull=$(git pull $REMOTE $branch)
    save_logfile "$pull"
    push=$(git push $REMOTE $branch)
    save_logfile "$push"
    save_logfile "new commit $(git rev-parse $remoteBranch)"
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
    # todo: add a global variable that store the lastcmmited date, lastFileChanged
    # also if last changed date is more thant 5s autocommit and if lasCommited date is more than a minute, autocommit
    echo $(clear)
    local branch="$(git rev-parse --abbrev-ref HEAD)"
    if [ "$branch" != 'master' ]
      then
        echo "You are on $branch and the remote $REMOTE"
        echo "Sleeping 3s"
        verify_to_autocommit
        verify_auto_push
        sleep 5s
      else
        echo "You are on master, change the branch to be able to auto save"
        sleep 10s
    fi
  done
}

if [ ! -z $1 ] 
then
  REMOTE=$1
else
  REMOTE='origin';
fi

main $REMOTE
