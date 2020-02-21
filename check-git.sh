VN=$(git describe --abbrev=7 HEAD 2>/dev/null)

git update-index -q --refresh
CHANGED=$(git diff-index --name-only HEAD --)
if [ -n "$CHANGED" ]; then
    VN="$VN-mod"
fi