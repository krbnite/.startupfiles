* by Kevin Urban (2020-Apr-01)

`git mergetool` is typically run after you've run `git merge` and have
encountered merge conflicts.  Note that `git merge` is sometimes run
implicitly, e.g., when you `git pull` you are essentially running 
`git fetch`, followed by `git merge`.  




# Configuring Git Mergetool
If you haven't already, you will want to specify the diff tool that
mergetool employs.  For example, I use `vim` for as much as possible,
so I use and recommend `vimdiff`.  In fact, this article is predicated
on you choosing `vimdiff` as your diff tool for `git mergetool` (your
mileage may vary if you choose something else!).

```
git config --global diff.tool = 'vimdiff'
```

If you're interested in other available diff tools, you can see
what's supported:
```
git mergetool --tool-help
```


# Merge Conflicts
Merge conflicts arise for various reasons in a variety of situations:
* when merging an experimental branch with master (you may have tweaked
  a few files already present on master)
* when pulling the latest remote to your local repo (other developers may
  have tweaked the same file as you)
* when subtree pulling using squash-merges

The gist is that there are versions of a file with a number of
differences and conflicts.  Your job is go through each difference
or conflict and decide how to resolve, resulting in a single file.  

**Experimental Branch Example**:  When merging an experimental branch with master,
you may decide that most file differences are trivial or accidental, and
that you actually only care about one specific bug fix you did in the 
experimental branch.  In this case, you might choose to resolve most
of the file difference by selecting what's already in the master branch,
but making sure the portion of the code dealing with the bug fix comes
from the experimental branch.

**Subtree Example**:  When using a subtree, it's often appealing to 
merge in the external repo with a squashed history (all commits
squashed together into one merge commmit) to avoid
littering your current project's git log with the subtree project's
git log.  However, this means if down the line you want to pull
in updates from the subtree remote, merge conflicts will arise even
if it is just a simple fast-forward merge.  In this case, git treats
your current subtree version and the incoming version as equals, leaving
it to you to decide how to resolve the conflicts.  Fortunately, if you
are pulling the latest updates, usually you really do just want whatever
is in the subtree remote.  So, in this case, you can easily resolve by
having all conflicts defer to the subtree remote.

# Resolving Merge Conflicts with the VimDiff Mergetool
When you have a merge conflict, you will be warned of it and won't be
able to make a commit until the conflics are resolved.  When your
repo is in this state, you can then use the mergetool to help you
navigate and resolve the conflicts.

```
git mergetool
```

This will bring up a 4-pane Vim screen that can be intimidating at first sight,
but fret not -- it's actually quite simple.

First and foremost, this schematic will help you understand what you
are looking at:

```
+--------------------------------+
| LOCAL  |     BASE     | REMOTE |
+--------------------------------+
|             MERGED             |
+--------------------------------+
```

In the top 3 panes, for a given file, we have 3 versions:
* LOCAL: the version of the file in your local repo (usually your local master)
* BASE: the version of the file that both LOCAL and REMOTE stem from
* REMOTE:  the version of the file that you are attempting to merge with LOCAL

In the bottom pane, you have the merged version of the file that git spits
out during a merge conflict.  This is the file with all the diff mark up (e.g.,
`>>>>>>>>>>` and `=================`).  

Upon entering the mergetool, your cursor will be based in the bottom
pane.  You can move to the other window panes using the usual
`Vim` commands, but for the most part you only need to move around the 
bottom pane (using usual keys, e.g., `h`,`j`,`k`, and `l` for left, down, up, 
right, respectively).  The `Vim` shortcuts to move through split panes are as
follows:

```
Ctrl w, h   # move to leftward pane (if one exists) 
Ctrl w, j   # move to pane below (if one exists) 
Ctrl w, k   # move to pane above (if one exists) 
Ctrl w, l   # move to rightward pane (if one exists) 
```

Again, the MERGED file in the bottom pane is the only file that 
matters for resolving the conflict and being able to commit the
associated changes.  The top pane panels are to help aid you in
your decision making.

Given that we need to edit the MERGED file and resolve conflicts, 
you can do this 100% manually in the usual way, or you can use some
of the `vimdiff` conveniences provided by the mergetool.  These 
conveniences include:
* **navigational shortcuts** that help you locate the various conflicts in the file
* **decision shortcuts** that help you automatically resolve a conflict based on
  on of the top-pane source files (LOCAL, BASE, and REMOTE)

When you are sure you have addressed each merge decision carefully, use `:wqa` to 
save and quit all.  At this point you will have to apply `git clean` to clean
up several untracked artifacts output by the mergetool.

### Navigational Shortcuts
```
]c - Jump to next change
[c - Jump to previous change
```

### Decision Shortcuts
```
:diffg REM  # get from REMOTE
:diffg BAS  # get from BASE
:diffg LOC  # get from LOCAL
```

### Post-MergeTool Clean-Up
```
git clean -n  # dry run (see what untracked files will be removed)
git clean -f  # remove everything you saw in the dry run
```
