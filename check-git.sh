#!/bin/sh

commit_wip_changes(){
  local VN="$VN-mod"
  local COMMIT=$(git commit -am"WIP - automated saved")
  echo "commit done $COMMIT"
  lastcommit=$(git log -1 --oneline)
  return $lastcommit
}

main (){
  # while [ true ]
  # do
    local LASTCOMMIT="$(git log -1 --oneline)"
    echo "last commit $LASTCOMMIT"

    local CHANGED="$(git diff-index --name-only HEAD --)"
    if [ -n "$CHANGED" ];
      then
        echo "found changes"
        # LASTCOMMIT=$(commit_wip_changes)
        # echo "last commit $LASTCOMMIT"
      else
        echo "No new changes found"
    fi

    echo "sleeping 5s"
    SLEEP 3s
  # done
}

verifychanges () {
  # $1 => lastcommit cached
  local VN=$(git describe --abbrev=7 HEAD 2>/dev/null)
  local lastcommit="$(git log -1 --oneline)"
  git update-index -q --refresh
  local CHANGED="$(git diff-index --name-only HEAD --)"
  if [ -n "$CHANGED" ]; then
    return 1
  else
    return 0
  fi
}

main