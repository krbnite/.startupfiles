Undo changes to local working directory (e.g., things that might have changed accidentally in a 
Jupyter Notebook that you don’t care to save).
```
git checkout -- .

# You can also do:
git reset -- .
```

List remotes:
```
git remote -v
```

List branches:
```
git branch -a
```

Create a new branch and switch to it (in one command):
```
git switch -c <newBranch>

# Older Way
git checkout -b <newBranch>
```

Delete a branch that has been fully merged
```
git branch -d <oldBranch>
```

Force Delete a branch that has not been fully merged with master (e.g., some experimental 
branch you just want to get rid of)
```
git branch -D <oldBranch>
```



Merge another branch with master:
```
1. Make sure you are in master.  
    - If not: git checkout master
2. Once in master: git merge <anotherBranch>
```


Revert your local master back to the remote origin master (sometimes you just F’d things up 
and this is a good fix):
```
git checkout -B master origin/master
```

DELETE REMOTE BRANCH
```
git push origin --delete <branchName>
```

LIST OF MERGE CONFLICTS
```
git diff --name-only --diff-filter=U
```

TRACK A FILE’S HISTORY
```
git log --follow -- <file>
```

Use most recent version of file (before you went ahead and screwed it up):
```
git checkout -- <file>
```

USE OLDER VERSION OF A FILE
```
git checkout <commit> <file>
```

COMPARE FILE BETWEEN BRANCHES
e.g., “feature” branch vs “master”
```
git diff feature master -- <myFile>
```

SEE ALL CHANGES IN EACH FILE SINCE LAST COMMIT
```
git diff
```

SHOW ALL CHANGES IN SPECIFIC FILE SINCE LAST COMMIT
```
git diff <myFile>
```

UNSTAGE A SINGLE FILE
```
git reset HEAD <myFile>
```

-----------

# Git Log

Show all file changes explicitly:
```
git log --patch
git log -p
```

Show all file changes implicitly (e.g., +++------)
```
git log --stat
```

Show graph view
```
git log --graph
```

Show in one line:
```
git log --pretty=oneline

# Or...
git log --oneline
```

Show one-liner graph view
```
git log --oneline --graph
```

Graph-Stat View
```
git log --graph --stat
```

Oneline Graph-Stat View
```
git log --graph --stat --oneline
```

Show relative date
```
git log --relative-date
```

- - - 

Good print command I made alias for:
```
git config --global alias.hist 'log --stat --date=short --format="%C(Yellow)%h %C(White)%ad    %s"'
```

--------------

# Git Stash

If you are trying to pull from origin master and get a warning about having un-commited changes, then you might 
want to stash (“hide”) them away, do the pull, then return your changes...

If you are just doing a quickie, all you need to type is:
```
git stash
```

And to get ’em back:
```
git stash pop
```

However, it’s good practice to get into the habit of saving a stash with a contextual message just in case 
you forget what you stashed:
```
git stash save "2020Apr16: Bunch of JNB updates (e.g., raw ecg, activation experiments)"
```

To see what stashes you have in you cache (w/ contextual messages if they exist):
```
git stash list
```

From the example just above, this will show:
```
stash@{0}: On master: 2020Apr16: Bunch of JNB updates (e.g., raw ecg, activation experiments)
```

NOTE: by default, by default Git won’t stash changes made to untracked or ignored files.

To also stash untracked files:
```
git stash -u
```

To also stash untracked files AND git-ignored files:
```
git stash -a
```


**MULTIPLE STASHES**

To see what stashes are in your cache:
```
git stash list
```

Assume this outputs the following:
```
stash@{0}: On master: some random files

stash@{1}: On master: feature x bug fix
```

Then to get back desired stash (e.g., stash1 above):
```
git stash pop stash@{1}
```




# Git Tag
List tags
```
git tag

# w/ commit msgs
git tag -n
```

List remote tags
```
git ls-remote --tags origin
```

Tag current comment
```
# 99% always use -a flag to create an annotated tag
git tag <tagName> -a "This is version <tagName> bla, bla, bla,"
```

Delete a tag
```
git tag -d <tagName>
```

Delete a remote tag
```
git push --delete origin <tagName>
# Or...
git push origin :refs/tags/<tagName>
```

### Syncing Tags
Note that tags are local by default and do not push to the remote by default.  You have
to explicitly push a tag to the remote.
```
git push origin <tagName>

# To push all local tags (prob not the best idea)
git push origin --tags
```

List remote tags
```
git ls-remote --tags origin
```

Get all remote tags
```
git fetch --all --tags
```


------------

# MISC

List all files tracked in the repo
```
git ls-files
```

Only list modified files
```
git ls-files -m
```

Show untracked files
```
git ls-files -o
```

List any deleted files
```
git ls-files -d
```



-------------

# FETCH vs PULL
Fetch retrieves metadata about changes in a remote, but does not transfer files.  This allows you 
to have an idea of what will happen on a git pull.

Pull first does a git fetch, then a file transfer and git merge all in one step.  It will update 
your current HEAD branch with the latest changes from the remote.

Fetch is harmless: it just provides you a fresh view on the remote.  You can fetch often to 
know what’s going on at the remote (e.g., if others are actively working and pushing there).

Pull on the other hand is not necessarily harmless.  It is recommended to have a clean working copy 
before using git pull.  If necessary, use git stash to stash way un-commited local changes before using 
git pull.

- - -

For example, this comment I saw on reddit:  
> `git pull -r remote branch` will virtually always give you the results you're expecting/anticipating. The -r 
> flag means to rebase instead of merge.

To which someone replies: 
> I use `git pull --ff-only`, which will only "fast forward"—i.e., move to a direct descendant commit. It 
> will neither create a merge commit nor rebase. (That is, it will do what either `git pull` or `git pull --rebase` will 
> do in the case where there’s nothing to merge or nothing to rebase.) If I actually need to merge or rebase, I’ll 
> do that by hand, specifying the exact commit ID.

He says defaulting to rebase can be bad for people that do not 100% understand the advanced internal workings of Git:  
> The bad cases of `git pull --rebase` are much worse than the bad cases of `git pull` generating a merge.


---------------------------------------

# Vim in Git

Use Vim for git editor 
```
git config --global core.editor "vim"
```

Use vimdiff as the merge tool
```
git config --global merge.tool vimdiff
```

Use vimdiff as diff tool
```
git config --global diff.tool = 'vimdiff'
```

VimDiff Screen
```
+--------------------------------+
| LOCAL  |     BASE     | REMOTE |
+--------------------------------+
|             MERGED             |
+--------------------------------+
```

Moving in VimDiff: Vim window commands
```
Ctrl w + h   # move to the split on the left 
Ctrl w + j   # move to the split below
Ctrl w + k   # move to the split on top
Ctrl w + l   # move to the split on the right
```

Quick VimDiff Decisions:  You can either manually edit MERGED, or use the `:diffg`  shortcuts to pull from one of the sources (LOC, BAS, REM). In either case, one must navigate to each merge decision in the MERGE file, which can be done with the navigation shortcuts. When you are sure you have addressed each merge decision carefully, use `:wqa` to save and quit all.

DiffG Shortcuts
```
:diffg REM  # get from REMOTE
:diffg BAS  # get from BASE
:diffg LOC  # get from LOCAL
```

Merge Decision Navigational Shortcuts:
```
]c - Jump to the next change.
[c - Jump to the previous change.
```

One annoying part of using the merge tool is that it creates quite a few extra files that save
```
git clean -n  # dry run (see what untracked files will be removed)

git clean -f  # remove everything you saw in the dry run 
```




