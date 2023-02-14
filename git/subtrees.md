* Kevin Urban (2020-Apr-02)


Let's say you have some really useful code in stored in some GitLab repo
called `originalRepo`. 

Overall, most of `originalRepo` is very project specific and not  directly re-usable 
in other projects (e.g., exploratory Jupyter notebooks, highly specific data cleaning
procedures, etc).  However, 
there is that one subdirectory, `usefulCode`, within the project where you've developed a 
package of tools that were so successful and useful that you find yourself repeatedly copying
and pasting them into other projects.  

This is a prime example of code reuse.  

Let's assume that, generally, this copy-and-paste strategy has worked out ok for the most part.  However, 
you've noticed it's not ideal:
* For one, by copying and pasting `usefulCode` into new projects, you (and your collaborators) have no 
access to the `git log` history, which is sometimes helpful for understanding how and
why the code was put together.  
* More importantly, each time you copy `usefulCode` into a new project, you 
find that you run into an unforeseen issue (e.g., errors due to edges cases you had not come
across before) that you must fix, or you find yourself developing interesting new features,
helper tools, and so on.  

It occurs to you: these bug fixes and feature adds for `usefulCode` that I've developed in `newRepo3`
would also be helpful in some of my other projects where I use `usefulCode`, like `newRepo1`, `newRepo2`, and
`originalRepo`.  

**Nightmare One**:  So you start copy-and-pasting the latest edits into each project...  But wait!  There
were  a few bug fixes you had in `newRepo1` that you never added to `usefulCode` in `originalRepo`, and 
several feature adds in `newRepo2` that you never added to `usefulCode` in any of the other repos.  In fact,
you can't remember which repo has which bug fixes and feature adds!  

**Nightmare Two**:  You also realize that even if you do figure out how to merge and homogenize all the different versions
of each file laying scattered around the multiple repos, the associated `git commit` messages
would remain scattered about.  And what a shame!  You spent a lot of 
time on those commit messages, eloquently describing the need for each new feature, or carefully
detailing when and how a bug was detected and fixed.  


It would be great to have each bug fix, feature add, and entire history in 
one centralized location!  

In short: You want to be able to reuse `usefulCode` like you're already doing, but you absolutely need a better
code reuse strategy.  Ideally, you wouldn't have to change your workflow so much either: if you're
busy hacking away in `repo2` and happen to make a few edits to `usefulCode`, it would nice if
you can push the relevant commits back to a central location for `usefulCode`.  



# Splitting Useful Code Into Its Own Repo

Hopefully you do not find yourself in the situation above.  Instead, the moment you realize
you want to reuse some code from `originalRepo` in some other project, `newRepo`, it's
time split the useful code into its own repo, `usefulCode`.

We will:
* create a remote repo called `usefulCode` on the GitLab website (do not intialize with 
  a README)
* create a new directory locally, called 'usefulCode`, and initialize it as a bare git repo
* add the GitLab `usefulCode` repo as a remote in the local `usefulCode` repo
* cd into `originalRepo`, then split out the `usefulCode` subtree onto its own new branch, `usefulBranch`, which
  will contain only the commit history relevant to `usefulCode`
  - if you've maintained highly organized, atomic commits, then the commit history is likely very
    clean and can be directly pushed to the new `usefulCode` repo
  - however, if you've made messy, bulk commits in `originalRepo` that often included many
    files at once, both inside and out of the `usefulCode` subdirectory, then the commit
    history will likely have some irrelevant commit messages that should probably be
    edited and cleaned up before pushing to the new `usefulCode` repo (here, we will
    take a squash-merge approach with an abridged history as the commit message)
  - in either case, for our project template and workflow, it is good to checkout 
    the .gitignore file from the master branch, else all the files and directories
    usually ignored in master will show up as untracked files on the new branch
* push the `usefulCode` branch in `originalRepo` to the master branch of our new `usefulCode` repo
* cd into the `usefulCode` repo, then push it to its remote on GitLab


## Create Empty Remote Repo on GitLab
First, head over to the GitLab website, login, and create a new remote
repo.  Call it `usefulCode`.  Do NOT initialize with a README.  If you
want to follow along, then create the repo in your personal area (not 
under cohen-veterans-bioscience):

```
https://gitlab.com/<username>/usefulCode     # fill in <username>
```

## Create Bare Local Repo
From the command line, perform the following steps.  For simplicity, let's 
assume you house all of your local git repos in the
directory `~/GitLab/` on your local machine.

```
cd ~/GitLab

# Create new "bare" repo
mkdir usefulCode
cd usefulCode
git init --bare

# Add GitLab remote that you created above
git remote add origin <GitLabURL>   # fill in <GitLabURL>
```


## Split Useful Code from Original Repo and Place into its Own Branch
This part uses the `git subtree split` command to  pull out
the commit subgraph directly relevant to the `usefulCode` subdirectory,
then puts this extracted subgraph onto a new branch.  


```
# Head over to originalRepo to extract its useful code
cd ../originalRepo
git subtree split --prefix=src/ext/usefulCode -b usefulBranch

# Switch to usefulBranch 
git checkout usefulBranch

# Add .gitignore from the master branch (to continue ignoring files)
git checkout master .gitignore
git commit -a -m "Add .gitignore from master branch"
```

## Make a Decision: Is the history clean (merge) or does it need cleaning (squash merge)?
At this point, you should still be in the `usefulCode` branch of `originalRepo`, which
you can check if you want:
* `git branch` should denote current branch with an asterisk and/or green text
* if necessary, `git checkout usefulCode` to switch back into the `usefulCode` branch

Here, you want to look at the `git log` history that `git subtree split` 
extracted while making  this `usefulCode` branch.  Basically, you want
to see if the commit logs are clean (relevant, atomic, descriptive), or if 
this history generally needs cleaning, e.g., many of the commit logs are non-atomic
and partially irrelevant (bulk commits pertaining to code inside and out of the 
`usefulCode` subdirectory).

To better understand what I'm talking about, I include two 
git log histories below.  The first one is clean and mostly atomic.  Importantly,
all commits are directly relevant to `usefulCode`.  In the second example, the
commit logs are a mess since they are all bulk commits, which are non-atomic and
mostly irrelevant.


### A: Clean History
Notice how the commits in this history include 1-2 files each, which
are always relevant to the usefulCode subdirectory.  The commits are
likely atomic (single purpose), or close to it.  

```
commit df30d0a3aa87926607ac6ab6b66a706f66a62806 (HEAD -> new)
Author: Kevin Urban <kevin.ddu@gmail.com>
Date:   Thu Apr 2 15:58:59 2020 -0400

    Make usefulCode/data subdir; move fcn1, fcn2 into it

commit b62a943caa5fd645523763ba39bf294a1a6fb08e
Author: Kevin Urban <kevin.ddu@gmail.com>
Date:   Thu Apr 2 15:57:50 2020 -0400

    Add usefulCode/models/cnnArch2.py (temporal convs, skip connections)

commit 9610c4d5d56702c94d943a386852c7358df7b033
Author: Kevin Urban <kevin.ddu@gmail.com>
Date:   Thu Apr 2 15:57:10 2020 -0400

    Add usefulCode/models/cnnArch1.py (simple networks)

commit 19d64960c50140d136ab6d9f9e312ab91bdc7053
Author: Kevin Urban <kevin.ddu@gmail.com>
Date:   Thu Apr 2 15:55:03 2020 -0400

    Create usefulCode subdir; add fcn1, fcn2
```

If you commit history is clean like this, then you might
consider directly pushing the `usefulBranch` to the new `usefulCode` 
repo.  Assuming you are still in the top-level directory of
`usefulBranch`, that code looks like this:

```
# Optional/Recommended: Head back to the master branch
git checkout master

# Push usefulCode branch to bare repo
git push ../usefulCode usefulBranch:master

# Head over to the usefulCode repo and push it to remote
cd ../usefulCode
git push origin master
```




### B: Messy History
In this history, we have many of the same files that I showed
in the above clean history.  However, notice in this messy 
history that each commit contains many files, some of which
are not necessarily related to each other.

```
commit f64f71e8c572e7468a53f20aa0648c857729037e (HEAD -> new2)
Author: Kevin Urban <kevin.ddu@gmail.com>
Date:   Thu Apr 2 16:09:20 2020 -0400

    Add a bunch of new stuff (CNN work, more data processing stuff, etc)
    * create usefulCode/models subdir
    * add a bunch of JNBs on CNNs
    * extract the model code form notebooks --> usefulCdoe/models
    * update JOURNAL
    * extract the data processing stuff that is generalizable
      from fcn1 and fcn2, and add to new subdir usefulCode/data
    * keep project specific data processing in new subdir (dataCleanUp)

commit 6de36f697ddfda058cd76f132bab67aa396b4732
Author: Kevin Urban <kevin.ddu@gmail.com>
Date:   Thu Apr 2 16:05:21 2020 -0400

    Add all the new stuff
    * create usefulCode subdir
    * make fcn1 and fcn2 in usefulCode
    * create journal and add some lessons learned
    * add all the JNBs I've been working on
    * maybe other stuff
```

If your history is a mess like this, you probably want to clean
it up before pushing it into its own repo.  There are just too many 
comments that have to do with files that won't even be in the new repo.  It's
confusing and messy at best.  

Fortunately, you can edit the history, either by
* simply editing the commit messages
* squashing the entire history down into one commit, then editing the old commits
  into one coherent, relevant message 

In both cases, we will use `git rebase`.  For more information on 
`git rebase`, you can take a look at our tutorial:
* [Cleaning Up Your History with Git Rebase](https://gitlab.com/cohen-veterans-bioscience/early-signal/wiki-handbook/-/blob/master/content/git/cleaning-up-your-history-with-git-rebase.md).

One additional issue is that in the messy history above, we only have two 
commits.  In order to rebase commits, there needs to be a
a prior commit to rebase onto.  But the subtree only extracted
relevant commits, so we have no convenient root commit ont which we can
rebase.

So, what we will do first is just a technicality:  we will
create an empty root node onto which we can rebase the history.

Make sure you are still in the top-level directory of `originalRepo` in the
`usefulBranch`.  

#### Add Empty Root Node

```
# first you need a new empty branch; let's call it `newroot`
git checkout --orphan newroot
git rm -rf .

# Create empty root node
git commit --allow-empty -m 'root commit'

# This will put you back into usefBranch, now w/ an empty root node
git rebase --onto newroot --root usefulBranch

# We no longer need the newroot branch, so delete it
git branch -d newroot
```

To prove to yourself you are on usefulBranch:
```
git branch
```

To prove you've created a new empty root node here:
```
git log 
```

Now that we have an empty root node, we can make the decision to 
(i) simply edit or to (ii) squash and edit.  Take note of the empty 
root commit's hash ID.  We will use it in
the interactive `rebase` commands below.

For more info, see:  [Insert a commit before the root commit in Git?](https://stackoverflow.com/questions/645450/insert-a-commit-before-the-root-commit-in-git) 
on StackOverflow.


#### i. Simply Edit Old Commit Messages
To simply edit the old commit messages, open up an interactive rebase
session on top of the empty root node:

```
git rebase -i <rootNodeHashID>
```

This will open an interactive rebase screen in your text editor, which
will show each of your commit messages with their associated hash ID.  

Preceding each commit hash, you will see the word `pick`.  To simply edit 
the commit messages, but
not squash them together, change the word `pick` to `reword` (or `r`).

```
reword <firstHash> #.....
reword <secondHash> #.....
```

Then save and quit (in Vim, `:wq`). This will bring you into a sequence
of commit message screens where you can edit your commit messages.  Save
and quit after properly editing each commit.  

When you're done editing all
commits, the process is complete.  You can type `git log` to see
the magic:

```
git log

commit f64f71e8c572e7468a53f20aa0648c857729037e (HEAD -> new2)
Author: Kevin Urban <kevin.ddu@gmail.com>
Date:   Thu Apr 2 16:09:20 2020 -0400

    Add a bunch of new stuff (CNN work, more data processing stuff, etc)
    * create usefulCode/models subdir
    * add new CNN model code
    * extract the data processing stuff that is generalizable
      from fcn1 and fcn2, and add to new subdir usefulCode/data

commit 6de36f697ddfda058cd76f132bab67aa396b4732
Author: Kevin Urban <kevin.ddu@gmail.com>
Date:   Thu Apr 2 16:05:21 2020 -0400

    Add all the new stuff
    * create usefulCode subdir
    * make fcn1 and fcn2 in usefulCode

commit 5b29ccd0fd69f4628df791358a5e8ba498fdb9bb
Author: Kevin Urban <kevin.ddu@gmail.com>
Date:   Fri Apr 3 11:46:59 2020 -0400

    root commit
```



#### ii. Squash and Edit Old Commit Messages
To squash edit the old commit messages, open up an interactive rebase
session on top of the empty root node:

```
git rebase -i <rootNodeHashID>
```

This will open an interactive rebase screen in your text editor, which
will show each of your commit messages with their associated hash ID.  

Preceding each commit hash, you will see the word `pick`.  To squash and edit the 
commit messages, change the word `pick` to `squash` (or `s`) for all but the oldest (top-most)
commit, which you should leave as `pick`.

```
pick <firstHash> #.....
squash <secondHash> #.....
```

Then save and quit (in Vim, `:wq`). This will bring you into a single
commit message screens that has combined all of the old commit messages.  Save
and quit after properly editing the various messages into one coherent, 
relevant commit message.  

When you're done editing, then save and quit. The process is complete.  You 
can type `git log` to see the magic:

```
git log

commit acc7be6c1dc2ee0807a689786ed7be5f1736cb28 (HEAD -> usefulBranch)
Author: Kevin Urban <kevin.ddu@gmail.com>
Date:   Thu Apr 2 16:05:21 2020 -0400

    Add a bunch of new stuff (CNN work, more data processing stuff, etc)
    * create usefulCode subdir
    * make fcn1 and fcn2 in usefulCode
      - extract the data processing stuff that is generalizable
        from fcn1 and fcn2
      - add these fcns to new subdir usefulCode/data
    * create usefulCode/models subdir
    * add new model code

commit 5b29ccd0fd69f4628df791358a5e8ba498fdb9bb
Author: Kevin Urban <kevin.ddu@gmail.com>
Date:   Fri Apr 3 11:46:59 2020 -0400

    root commit
```





## Push the Subtree Branch to its New Repo


```
# Optional/Recommended: Head back to the master branch
git checkout master

# Push usefulCode branch to bare repo
git push ../usefulCode usefulBranch:master

# Head over to the usefulCode repo and push it to remote
cd ../usefulCode
git push origin master
```

# Using Plugin Repo Inside of Container Repo
Ok, so you now have all your useful code extracted into its own repo.  You
can now use this code in other repos, where you can also edit it and push
it back to its source repo.  This involves using git subtrees.

```
git remote add usefulCode <GitLabRepoURL>
git subtree add --prefix=src/ext/usefulCode usefulCode master --squash
```

```
git subtree pull --prefix=src/ext/usefulCode usefulCode master --squash
```


## Subtree Aliases
If you will be pushing or pulling the subtree frequently, you will 
want to make a few aliases:

```
git config alias.stpush 'subtree push --prefix=src/ext/usefulCode usefulCode master'

git config alias.stpull 'subtree pull --prefix=src/ext/usefulCode usefulCode master --squash'
```

If you are using mutliple subtrees in a project (say, `usefulCode` and `helperTools`), 
then you should create slightly more specific aliases, e.g.:
```
git config alias.ucpush 'subtree push --prefix=src/ext/usefulCode usefulCode master'
git config alias.htpush 'subtree push --prefix=src/ext/helperTools helperTools master'
```


## Subtree Push Workflow
```
1. make edits to plugin code inside container repo
2. commit edits to container repo (optional: push them to origin master)
3. git stpush
4. Sometime after (sooner than later!):  cd <pluginRepo>; git pull
  - if no conflicts exist, you're done
```

## Subtree Pull Workflow
```
1. make edits in the plugin's own repo
2. commit and push to plugin's remote repo
3. sometime later, when you are working inside the container repo and
   want the latest subtree updates:  git stpull
4. use git mergetool to resolve conflicts: likely you will just accept
   all REMOTE changes
   - since the container repo generally considers the subtree as its own code, 
     and since we've been using squash merges, git will not automatically know
     how you want to resolve differences in your container's subtree code versus
     the incoming updates from the subtree's remote repo
   - these conflicts will arise even if the changes from the subtree remote
     are just "fast forward" changes
   - to understand how to use git mergetools, see our corresponding tutorial
5. clean up messy artifacts from git mergetool
   - after you're done using the mergetool, you will find that there are 
     a lot of resultant untracked files in your repo
   - you can see all the untracked files using `git log` or `git clean -n`, 
     which performs a dry run of `git clean` 
   - make sure you stage any untracked files you do not want to delete
   - to clean up all remaining untracked files:  `git clean -f`
```

For more info on `git mergetool`, see our tutorial:
* [Settling Merge Conflicts with Git Mergetool](https://gitlab.com/cohen-veterans-bioscience/early-signal/wiki-handbook/-/blob/master/content/git/settling-merge-conflicts-with-git-mergetool.md)

# References & Further Reading
* CVB Wiki Handbook: [Cleaning Up Your History with Git Rebase](https://gitlab.com/cohen-veterans-bioscience/early-signal/wiki-handbook/-/blob/master/content/git/cleaning-up-your-history-with-git-rebase.md).
* CVB Wiki Handbook: [Settling Merge Conflicts with Git Mergetool](https://gitlab.com/cohen-veterans-bioscience/early-signal/wiki-handbook/-/blob/master/content/git/settling-merge-conflicts-with-git-mergetool.md)
* GitLab Docs: [Subtree](https://docs.gitlab.com/ee/university/training/topics/subtree.html)
* Atlassian: [Git subtree: the alternative to Git submodule](https://www.atlassian.com/git/tutorials/git-subtree)
* Making Software (Blog): [Using Git subtrees for repository separation](https://makingsoftware.wordpress.com/2013/02/16/using-git-subtrees-for-repository-separation/)
* Medium: [git subtrees: a tutorial](https://medium.com/@v/git-subtrees-a-tutorial-6ff568381844)
* Code Wins Arguments: [Git Submodules vs Git Subtrees](https://codewinsarguments.co/2016/05/01/git-submodules-vs-git-subtrees/)
* StackOverflow: [Insert a commit before the root commit in Git?](https://stackoverflow.com/questions/645450/insert-a-commit-before-the-root-commit-in-git) 
