# Real World Example of Subtree Splitting, Rebasing, and Utilization from External Repos


# Real World Example
The `sensornet` repo was created because I found myself copying and pasting
model code from the `int003` repo into the `apnea-ecg` repo, which is
an unsophisticated, brute force example of code reuse.    It's unsophisticated
because none of the development history of the model code came along for
the ride.  Worse, reusing code in this way means that any
further development done in `apnea-ecg` is not easily shared back with
`int003`.  After running into this issue several times, I looked into
subtrees and created the sensornet repo.  

Here is how I included some of the development history from `int003`:

```
# On local machine
cd int003

# Split src/models into its own subtree on a separate branch
git subtree split --prefix=src/models -b models

# Checkout the models branch and copy over the .gitignore file from master
git checkout models
git checkout master .gitignore
git commit -m "Add .gitignore"

# Remove project-specific files that do not belong in sensornet
git rm train_model.py train_model_for_sobp_poster.py predict_model.py
git commit -m "Remove files that should not be transferred to sensornet"
```

At this point, it's time to look at the logs to see what can be pruned
and/or cleaned up.  Admittedly, I've been a very messy git committer in the past:
* I include too many files at once
* I include notebooks and src code at the same time

Since the `git subtree` only looks at files in `src/models`, a few of the commit messages
no longer fully make sense since they reference Jupyter notebooks and other files
that do not exist in this subtree.


```
git log --stat --date=short --format="%C(Yellow)%h %C(White)%ad    %s"

31f3a1e 2020-04-03    Remove files that should not be transferred to sensornet
 predict_model.py               |  0
 train_model.py                 | 43 -------------------------------------------
 train_model_for_sobp_poster.py | 80 --------------------------------------------------------------------------------
 3 files changed, 123 deletions(-)

5ba9f96 2020-04-03    Add .gitignore
 .gitignore | 98 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 98 insertions(+)

ac6bbca 2020-03-30    Add all notebooks and changes from last time -- about a month ago.
 carlos_deep_conv_lstm.py | 138 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 134 insertions(+), 4 deletions(-)

dc296dd 2019-10-18    Finish converting SOBP to CLI scripts
 train_model.py                 |  43 +++++++++++++++++++++++++++++++++
 train_model_for_sobp_poster.py | 131 +++++++++++++++++++++++++++++++++++++++++++++++++++++-----------------------------------------------
 2 files changed, 112 insertions(+), 62 deletions(-)

9f900ae 2019-08-23    Create command line scripts to generate SOBP data, train, and viz
 train_model_for_sobp_poster.py | 73 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 73 insertions(+)

899343e 2019-08-22    Rename deep_conv_lstm to carlos_deep_conv_lstm
 deep_conv_lstm.py => carlos_deep_conv_lstm.py | 0
 1 file changed, 0 insertions(+), 0 deletions(-)

cdeeff5 2019-05-09    Add JNB 04-KU -- mad dash to get results!! This commit adds all the as_strides/make_views works I've been doing, windowing, more processing steps, ... tons of stuff, all the way up to running the CNN/RNN model.  Everything is in a bit of a "mad dash mess," but it's all there...just gotta clean it up!
 deep_conv_lstm.py | 84 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 84 insertions(+)

94444f6 2019-04-26    Initial commit
 .gitkeep         | 0
 __init__.py      | 0
 predict_model.py | 0
 train_model.py   | 0
 4 files changed, 0 insertions(+), 0 deletions(-)

 ```

We are going to clean this history up a bit.  First, let's analyze what
we want to do.

* Notice that the first two commits in the list (31f3a1e and 5ba9f96) 
  correspond to the ones just made when I removed the files that shouldn't transfer
  over to the `sensornet` repo and added the .gitignore file, respectively.  
  - these commit messages are nonessential; they will only bloat the 
    history in `sensornet`
  - we will keep the commits (because we do truly want the .gitignore file
    and truly do not want the removed files), but will delete their messages
* The 3rd commit down (ac6bbca) talks about adding a bunch of new 
  notebooks that do not exist in this subtree.  It doesn't mention
  the file in the subtree that has been edited.
  - we will need to edit this commit message
* The 4th (dc296dd) and 5th (9f900ae) commits on the list concern
  only files that we just removed that will not be transferred to `sensornet`
  - these commits should be dropped completely
* The 6th commit (899343e) is atomic (changes for one file) and descriptive
  - leave as-is
* The 7th commit (cdeeff5) is atomic as far as the subtree is concerned,
  but certainly was not atomic on the master branch.  Its commit message
  concerns work that has been done in a Jupyter notebook on the master 
  branch that is not in this subtree
  - edit the commit message
* The very last commit (94444f6) in the list is the initial commit in `int003`  
  - This commit message should be edited to include that it's the 
    root of int003's contribution  
  - To do this using `git rebase` is tricky since it is the root node, however
    we can use a temporary branching strategy that rolls back the commits
    to the root, which puts us in a position to ammend the root message, which
    we can then rebase onto our subtree branch (you'll see)

Let's start with editing the root commit message to get it out of the
way.  Note the relevant SHA1 hash is `94444f6`.

```
# Switch to a branch that has only initial commit
git checkout 94444f6 -b temp    # where 94444f6 is SHA1 of the root

# Amend the initial commit's message
#   * msg: Initial commit --> sensornet from int003: initialize int003/src/model subdir
git commit --amend   

# Rebase all the other commits in models branch onto the amended root,
#    then delete temp branch
git rebase --onto HEAD HEAD models
git branch -d temp
```

The `models` branch now has an updated root message.  Importantly,
its SHA1 hash has changed too. In fact, the SHA1 of every subsequent commit
has changed as well.  So take a look at the logs since we
will need the new root hash to rebase:

```
git log --oneline

* fee27e1 (HEAD -> models) Remove files that should not be transferred to sensornet
* b78a171 Add .gitignore
* 39edb35 Add all notebooks and changes from last time -- about a month ago.
* c1d9f87 Finish converting SOBP to CLI scripts
* e9f37e2 Create command line scripts to generate SOBP data, train, and viz
* 3605fce Rename deep_conv_lstm to carlos_deep_conv_lstm
* b06f60f Add JNB 04-KU -- mad dash to get results!! This commit adds all the as_strides/make_views works I've been doing, windowing, more processing steps, ... tons of stuff, all the way up to running the CNN/RNN model.  Everything is in a bit of a "mad dash mess," but it's all there...just gotta clean it up!
* b186cab sensornet from int003: initialize int003/src/model subdir
```

Next, we will use an interactive rebase session to edit or remove
commits.  Again, note the SHA1 hash of root is `b186cab`.

To enter interactive rebase session:
```
git rebase -i b186cab   #  where b186cab is the modified root's hash
```

This brings up the interactive rebase screen, which lists the 
commits in the reverse order from what you may be used to
seeing in `git log`, from oldest to newest:
```
pick b06f60f Add JNB 04-KU -- mad dash to get results!! #...comment goes on...
pick 3605fce Rename deep_conv_lstm to carlos_deep_conv_lstm
pick e9f37e2 Create command line scripts to generate SOBP #...comment goes on..
pick c1d9f87 Finish coverting SOBP scripts to CLI scripts
pick 39edb35 Add all notebooks and changes from last time
pick b78a171 Add .gitignore 
pick fee27e1 Remove files that should not be transferred to sensornet
```

To get the resultant history that I want, I edit the commands
like so:
```
reword b06f60f Add JNB 04-KU -- mad dash to get results!! #...comment goes on...
pick 3605fce Rename deep_conv_lstm to carlos_deep_conv_lstm
drop e9f37e2 Create command line scripts to generate SOBP #...comment goes on..
drop c1d9f87 Finish coverting SOBP scripts to CLI scripts
reword 39edb35 Add all notebooks and changes from last time
fixup b78a171 Add .gitignore 
fixup fee27e1 Remove files that should not be transferred to sensornet
```

Note that part way through, the rebase session stopped.  It provided a
warning, but I didn't notice it at first so did not know what was going on.  I 
only figured it out when I tried another rebase and it told me I'm in the
middle of one and that I need to resolve some conflicts. So, I typed
in `git mergetool` and a message came up basically asking if I really want
to get rid of the files I was trying to get rid of:  YES!  Then I had
to type `git rebase --continue` to finish the interactive rebase session.

By the end, I had something that looked like this:

```
git log --stat --date=short --format="%C(Yellow)%h %C(White)%ad    %s"

d2f35c7 2020-03-30    int003 -> sensornet: Edit carlos_deep_conv_lstm.py

 .gitignore               |  98 +++++++++++++++++++++++++++++++++++++++++++
 carlos_deep_conv_lstm.py | 138 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 predict_model.py         |   0
 train_model.py           |   0
 4 files changed, 232 insertions(+), 4 deletions(-)
997f156 2019-08-22    int003 -> sensornet: Rename deep_conv_lstm to carlos_deep_conv_lstm

 deep_conv_lstm.py => carlos_deep_conv_lstm.py | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
9085071 2019-05-09    int003 -> sensornet: Add Carlos' deep_conv_lstm.py

 deep_conv_lstm.py | 84 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 84 insertions(+)
d48f491 2019-04-26    int003 -> sensornet: initialize int003/src/model subdir

 .gitkeep         | 0
 __init__.py      | 0
 predict_model.py | 0
 train_model.py   | 0
 4 files changed, 0 insertions(+), 0 deletions(-)
```

Now, I probably should have started sensornet with this.  However, this all
was a learning process.  I basically just started `sensornet` with copied and
pasted versions of the latest code from the `apnea-ecg` project. 

........
