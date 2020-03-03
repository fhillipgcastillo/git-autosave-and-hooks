## How to use
install with
  npm install git-autosave-and-hooks
Add to the packages.json scripts as
  "autosync": "./node_modules/git-autosave-and-hooks/check-git.sh"
Run it
  npm run autosync

  ## How it works
  *Note: it will never autocommit or push if the branch is master*

  ### Auto Commit
  * every 3 to 8 seconds, the monitor with read for any new changes, if there are and you are not at the master branch, it will auto commit adding WIP - autosave message to the project.
  
  ### Auto Push
  * the monitor will detect if you local branch is up to date with the remote branch, if it is not updated it with new commit:
  * * it will verify if  the branch is created in the remote, if not, it will push it
  * * anytime the local commit and the remote commit are different, it will automatically push the commits

  ## Auto Pull
  * any time there is diferences in local and remote, pull and push the last commits
  
### Good to have, source:
https://thoughtbot.com/blog/autosquashing-git-commits

