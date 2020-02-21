VN=$(git describe --abbrev=7 HEAD 2>/dev/null)
LASTCOMMIT="$(git log -1 --oneline)"
git update-index -q --refresh
CHANGED="$(git diff-index --name-only HEAD --)"
if [ -n "$CHANGED" ]; then
    VN="$VN-mod"
    echo "have changes"
    COMMIT=$(git commit -am"WIP - automated saved")
    echo "commit done"
    LASTCOMMIT=COMMIT
    echo $COMMIT
else
  echo "doesn't have changes"
  echo $LASTCOMMIT
fi
