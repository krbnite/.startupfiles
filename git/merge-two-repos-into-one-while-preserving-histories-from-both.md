* by Kevin Urban (2019-Nov-27)

Once upon a time, there was this predictive modeling project that took on multiple 
iterations due to the project starting and stopping over time, and different 
individuals taking it on after others had moved on to other things.

During the first iteration, a data processing and machine learning pipeline was 
developed before the project developer discontinued work on it.

Eventually someone else took over. The new developer liked certain parts of the project, 
but disliked others. Not wanting to destroy the historic value of the first attempt
by modifying or deleting a bunch of files, it was decided that starting a separate repo would be
best. In this newly created repo, several pieces of the pipeline 
considered worth saving were copied over.  Development on the project took things
in a new direction. But before long, the project was in limbo once again.

After some time, a third developer was tasked with breathing new life into
the old project.  This time, a relatively nontechnical manager wanted to be able
to have access to some of the notebooks and data processing code from the old
projects as well.  The goal was to better understand what had been developed previously and
why the project reached dead ends twice before.  


The third devloper combed through
the two separate repos, assessing the project's constraints, why certain decisions 
might have been made, and where bugs may reside in the code. Again, 
there was some discomfort towards covering up too much of the past work by 
editing, deleting, and moving around files.  Yes, some things needed to change, but 
it the history needed to be preserved in a transparent way so that the nontechnical
manager could easily search through files without needing to be a git log guru. But
having yet another separate repo seemed clunky.  It would be nice to have one master 
repo, which housed each iteration of the project as a subdirectory to appease the
nontechnical manager, but without losing any of the commit history of the past attempts
(to appease the developer).  

Branching is one way to do this, e.g., the second developer could have created
a new branch called "v1", then continued development on the master branch.  If
this had been done, then the third developer could have continued in this
vein by creating a "v2" branch and continuing development on master.  However,
the branches wouldn't allow a nontechnical manager to be able to skim the old files 
just as easily as one of the project developers.

So, in essence, the task here is to merge the previous two repos
into one repo, as subdirectories, while preserving the git log history from 
both.  

**NOTE**: Technically, you could inject the previous two project repos into
a new repo as subtrees.  This is not a bad solution, but for one, I did not know
how to use subtrees when I encountered this issue.  More importantly, from a philosophical
standpoint, using subtrees is for a subtly different purpose:  when you
want to preserve the external repos as external repos, while also re-packaging
them as a "plugin" or "package" in the new repo (e.g., a python package fits the bill).  Here, 
we have no reason to keep or maintain the prior two attempts as separate repos.  Instead,
our goal was to create a master repo as if it always existed:  one that contained 
all previous attempts in subdirectories that can easily be explored by a nontechnical
manager, while preserving their git log history.  Assuming I could pull this off
(which I did, as shown below), we had no care or use for the separate, external repos.  They 
can be fully ignored or even deleted!  (This is not the typical use case for a subtree.)


# Preserving History While Merging 2 Repos into 1

Fortunately, I found someone who had a very similar need and wrote down the Git code required:

* [Merging Two Git Repositories into One Repository Without Losing File History](https://saintgimp.org/2013/01/22/merging-two-git-repositories-into-one-repository-without-losing-file-history/)

However, two issues:
* some of the code is specific to PowerShell on Windows
* some of the Git-specific code is outdated and needs to be updated

Below, I include the code that worked for me.

For simplicity, let’s assume we have two repos – `proj_v1` and `proj_v2`. Let’s assume 
that I basically want to start a new repo, `proj`, that includes `proj_v1` and `proj_v2` 
as subdirectories housed within it. I want to merge `proj_v1` and `proj_v2` into this
new repo without losing any history.

```
# Make new "master" project direcotry
mkdir proj

# Create the new repository
cd proj
git init

# Make an initial commit (necessary to do before merging)
#  -- e.g., create a README file called README.md.new (`.new` so that merge won't have conflicts)
echo "This repo places proj_v1 and proj_v2 under the same roof." > README.md.new
git add .
git commit -m “Initial commit”

# Add a remote for and fetch the old repo
git remote add -f proj_v1 <proj_v1 repo URL>

# Merge the files from proj_v1/master into proj/master
git merge --allow-unrelated-histories proj_v1/master

# Move the proj_v1 repo contents into a subdirectory so they don’t collide with 
# the proj_v2 repo to be merged next
mkdir proj_v1
for item in `ls | grep  -Ev "proj_v1$|README.md.new"`; do mv $item proj_v1/; done

# Commit the move
git add .
git commit -m “Move proj_v1 contents into proj_v1/ subdir”

# Repeat above steps for proj_v2
git remote add -f proj_v2 <proj_v2 repo URL>
git merge --allow-unrelated-histories proj_v2/master
mkdir proj_v2
for item in `ls | grep  -Ev "proj_v1$|proj_v2$|README.md.new"`; do mv $item proj_v2/; done
git add .
git commit -m “Move proj_v2 contents into proj_v2/ subdir”

# Properly rename the original README file
mv README.md.new README.md
git add README.md
git commit -m "Update README file name..."
```
