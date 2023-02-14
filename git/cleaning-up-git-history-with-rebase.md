* by Kevin Urban (2020-Apr-03)

Have you ever tweaked a few 
parameters of a function and committed, only to then tweak a small typo
and commit again, only to then resolve an edge case and commit
yet again?  

Or maybe you're working on some documentation.  You write a paragraph
and commit.  Then you realize you didn't fully explain: so you write
another few paragraph and commit.  Oh, wait:  look at all those typos!
So you fix them and commit again.

In both cases, there is an unsettling sense of over-committing.  It's
not the most dire thing in the world, but you can clean it up if
it bothers you with `git rebase`.

ONE IMPORTANT NOTE: when using `rebase` a fairly basic assumption is
that you are rebasing locally before pushing to a shared, remote origin. If
you are in the habit of issuing `git push origin master` every time you
make a small commit, then this assumption is violated.  Once commits
have been pushed to the remote, it's much harder to rebase and is also
considered dangerous.


# Create a Toy Project
Let's say you create a new project and add a motivational
statement in a README file.

```
mkdir newProj
cd newProj
git init
echo 'In this project, I will create `fcn1.py`.' > README.md
git add README.md
git commit -m "Create README"
```

You partially create a function, but have to leave for an hour, so you
commit your work:

```
touch fcn1.py
git add fcn1.py
git commit -m "Create fcn1.py"
```

You come back and do some work on the function, then commit:

```
echo 'print("Hi!")' >> fcn1.py
git add fcn1.py
git commit -m "Update fcn1.py: add 'Hi' statement"
```

Then you realize you didn't add the shebang:
```
#!/usr/bin/python
print('Hi!')
```

You commit that as well:
```
git add fcn1.py
git commit -m "Update fcn1.py: add shebang"
```

At this point, you've had 3 commits for an overall change that
probably deserves only 1 commit.  Your `git log` looks something
like this:

```
commit 8332c0e1c74958256ef68845974d91356c651f53 (HEAD -> master)
Author: Kevin Urban <kevin.urban@earlysignal.org>
Date:   Fri Apr 3 11:01:34 2020 -0400

    Update fcn1.py: add shebang

commit 34c4109ed11a7f98128d825e4a345413319c099d
Author: Kevin Urban <kevin.urban@earlysignal.org>
Date:   Fri Apr 3 11:00:05 2020 -0400

    Update fcn1.py: add 'Hi' statement

commit 4a346da98ba69e80af8c18a18eeee179485d1b0d
Author: Kevin Urban <kevin.urban@earlysignal.org>
Date:   Fri Apr 3 10:00:51 2020 -0400

    Create fcn1.py

commit 9cdc3a79399523fbb2f4f30a44541acf4c7016d5
Author: Kevin Urban <kevin.urban@earlysignal.org>
Date:   Fri Apr 3 09:59:44 2020 -0400

    Create README

```

# Simple Rebase Walkthroughs
We will go over a few different ways to use `rebase`, so we will create
a new branch for each.

```
git branch notMaster
git branch countSquashSquashSave
git branch countSquashSquashEdit
git branch hashRewordFixFix
```

Switch to branch `notMaster` now (to ensure you
have a clean copy of the full history in `master` if
you need it to make additional experimental branches
later on):
```
git checkout notMaster
```

#### Quick Excursion:  Slight Customization of Interactive Rebase Screen 
For some of the things I've been doing with `git rebase`, I find it helpful
to see the dates in the interactive rebase screen, but this is not the
default.  You can make it so by editing your git config file:

```
git config rebase.instructionFormat "(%ad) %s"
```


## Rebase by Counting Backwards

By looking at the `git log` above, we can clearly see that 3 of the commits
can be combined into 1 commit for a cleaner history.  In cases where
you can easily count up the number of commits, you can issue an interactive
rebase session like so:

```
git rebase -i HEAD~<N>  # in our case, N should be 3
```

When you issue this command, your text editor will pop up
with the last 3 commits ordered from oldest to newest:

```
pick 4a346da Create fcn1.py
pick 34c4109 Update fcn1.py: add 'Hi' statement
pick 8332c0e Update fcn1.py: add shebang
```

It will also include some commented out information on how to edit 
the file.  Basically, each commit starts with the default of `pick`.  Our
job is to replace `pick` on a few commits with other commands that will
result in the history we prefer.

```
# Commands
# p, pick <commit> = use commit
# r, reword <commit> = use commit, but edit the commit message
# e, edit <commit> = use commit, but stop for amending
# s, squash <commit> = use commit, but meld into previous commit
# f, fixup <commit> = like "squash", but discard this commit's log message
# x, exec <commit> = run command (the rest of the line) using shell
# b, break = stop here (continue rebase later with 'git rebase --continue')
# d, drop <commit> = remove commit
# l, label <label> = label current HEAD with a name
# t, reset <label> = reset HEAD to a label
# m, merge [-C <commit> | -c <commit>] <label> [# <oneline>]
# .       create a merge commit using the original merge commit's
# .       message (or the oneline, if no original merge commit was
# .       specified). Use -c <commit> to reword the commit message.
#
# These lines can be reordered; they are executed from top to bottom.
#
# If you remove a line here THAT COMMIT WILL BE LOST.
# 
# However, if you remove everything, the rebase will be aborted.
#
# Note that empty commits are commented out.
```

Assuming you are still on the `notMaster` branch right now and have
this screen open in Vim, press `:q!` to force quit out of the screen
without saving (or play around).  In the next section, we will switch to a 
new experimental branch and go over some rebase commands.




#### Squash, Squash, Save
First switch to the right branch:
```
git checkout countSquashSquashSave
```

This time, we will choose to squash the two newest commits into
the original commit.  In the information above, we see that this can be
done by replacing `pick` with `s` or `squash`:

```
pick 4a346da Create fcn1.py
s 34c4109 Update fcn1.py: add 'Hi' statement
s 8332c0e Update fcn1.py: add shebang
```

If in Vim, press `:wq` to save and quit out of the interactive rebase
session, which will then push you into the interactive commit message 
screen.  This gives you one last chance to edit the final commit message.  In
this case, we have a screen that looks like:

```
# This is a combination of 3 commits
# This is the 1st commit message:

Create fcn1.py

# This is the commit message #2:

Update fcn1.py: add 'Hi' statement

# This is the commit message #3:

Update fcn1.py: add shebang

# ...more commented out information...
```

Let's assume we are ok with this: `:wq` to save and quit.

Now, if you look at `git log`, you will see a more cleaned up
commit history:

```
git log

commit fe6e568f33f2f0d12f06e881210aafc5b5e65259 (HEAD -> tmp)
Author: Kevin Urban <kevin.urban@earlysignal.org>
Date:   Fri Apr 3 10:00:51 2020 -0400

    Create fcn1.py
    
    Update fcn1.py: add 'Hi' statement
    
    Update fcn1.py: add shebang

commit 9cdc3a79399523fbb2f4f30a44541acf4c7016d5
Author: Kevin Urban <kevin.urban@earlysignal.org>
Date:   Fri Apr 3 09:59:44 2020 -0400

    Create README
```




#### Squash, Squash, Edit
In the final commit message screen, we could have edited the final
message.  Without editing it, though the logs are cleaned up, the 
git message above is still kind of piecemeal.

Let's switch branches to revert back to the full git log history,
then open an interactive rebase session:
```
git checkout countSquashSquashEdit
git rebase -i HEAD~3
```

In the interactive rebase session, choose to squash the two newest
commits into the oldest commit again:

```
pick 4a346da Create fcn1.py
s 34c4109 Update fcn1.py: add 'Hi' statement
s 8332c0e Update fcn1.py: add shebang
```

Save and quit (`:wq`) to open the final commit message
screen.  Comment out the individual messages, the write
a better summary:

```
# This is a combination of 3 commits
# This is the 1st commit message:
#Create fcn1.py
# This is the commit message #2:
#Update fcn1.py: add 'Hi' statement
# This is the commit message #3:
#Update fcn1.py: add shebang

Create fcn1.py: add shebang and 'Hi' statement.

# ...more commented out information...
```

Now your `git log` should look even more clean:

```
Author: Kevin Urban <kevin.urban@earlysignal.org>
Date:   Fri Apr 3 10:00:51 2020 -0400

    Create fcn1.py: add shebang and 'Hi' statement.

commit 9cdc3a79399523fbb2f4f30a44541acf4c7016d5
Author: Kevin Urban <kevin.urban@earlysignal.org>
Date:   Fri Apr 3 09:59:44 2020 -0400

    Create README
```

## Rebase by Commit Hash

Counting the git logs might not always be convenient. You might
have corrected 11 typos, fixed 3 bugs, and resolved 2 edge cases
all within the course of an hour -- and made a separate commit
each time!

Sometimes it's easiest to just scroll down to the commit you 
want to start from -- then copy the hash for the commit hash just
before that one.  In our case, we want to use the commit hash
for the `Create README` commit.  You can interpret this as: 
"I want to merge all my recent `fcn1.py` commits on top of the
`README` commit."

```
git checkout hashRewordFixFix
```

We can get the `README` commit hash quickly by looking
at the `git log` again in a simplified form:

```
git log --pretty=oneline
332c0e1c74958256ef68845974d91356c651f53 (HEAD -> hash, master) Update fcn1.py: add shebang
34c4109ed11a7f98128d825e4a345413319c099d Update fcn1.py: add 'Hi' statement
4a346da98ba69e80af8c18a18eeee179485d1b0d Create fcn1.py
9cdc3a79399523fbb2f4f30a44541acf4c7016d5 Create README
```

The interactive rebase command is:
```
git rebase -i 9cdc3a   # note that you needn't use entire hash
```

This will bring up the same interactive rebase screen that
we've seen in the previous two examples.

#### Reword, Fix, Fix
This time, to change things up, instead of simply squashing the two
newer commits into the older commit, we will fix 'em up (that is, use
the 'fixup' command, which discards the commit message then squashes the commit 
into the previous commit).  If we do this, but leave the oldest commit
with `pick`, then the commit message will default to the oldest commit
message, so we will also change the oldest commit command to 'reword'.

```
r 4a346da Create fcn1.py
f 34c4109 Update fcn1.py: add 'Hi' statement
f 8332c0e Update fcn1.py: add shebang
```

Save and quit (`:wq`) to head into the final commit message screen, which
will allow you to `reword` the oldest commit's message:

```
Create fcn1.py

# ...bunch of commented out information...
```

Here, we can edit the message to how we like again:

```
Create fcn1.py: add shebang and 'Hi' statement.
```




# Summary
Two ways to start an interactive rebase session:
```
# Count commits backward starting from most recent
git rebase -i HEAD~<N>

# Rebase all commits after provided commit hash 
git rebase -i <hash>
```

Inside the interactive rebase screen, you will be given
a list of commits to rebase, each starting with the command `pick`.  For
merging history, as we are doing in this tutorial, the commands to know
about are:
* p, pick
* r, reword
* s, squash
* f, fixup

Rebase is used for so much more than what we covered in this tutorial.  At the
time of writing, however, I've never used it for anything more, so understanding
the basics herein might just be good enough for our purposes.  


-----------

* Git: [Git Basics: Viewing the Commit History](https://git-scm.com/book/en/v2/Git-Basics-Viewing-the-Commit-History)
* Git: [Git Tools: Rewriting History](https://git-scm.com/book/en/v2/Git-Tools-Rewriting-History)
* Medium: [Git Interactive Rebase: The Gem You Have To Know About](https://medium.com/@sharon_roz/git-interactive-rebase-the-gem-you-have-to-know-about-16550d3be786)
