Few things to remember:
* rebase BEFORE you push to origin master
  - once a history is in the remote master repo, it is a very difficult
    and complex to rebase (e.g., you will have a hard time pushing
    the rebase back to the remote)


After setting up `sensornet` and exploring how to use
it with subtrees in `apnea-ecg` and `int003`, I wanted to clean up
the history...  

Whoa.

Few immediate lessons learned:
* `git log` shows you a chronological history of commits, but for any master branch
  that has merge commits, it will not exactly an honest, graph view of how the commits flow from each other;
  for this, you should play w/ some variants:
  - `git log --oneline --graph`
  - `git log --online --graph --no-merges`

* https://stackoverflow.com/questions/3065650/whats-the-simplest-way-to-list-conflicted-files-in-git
* https://stackoverflow.com/questions/8523776/git-rebase-continue-complains-even-when-all-merge-conflicts-have-been-resolved


If you do end up having to rebase over a merge commit, you will 
get some warnings of various types of conflicts.  For times when the
same file is coming from two branches, it
seems like `git rebase --skip` will help a lot... Or a few small edits,
then `git rebase --continue`.


If you get rejected by the remote, you can technically do the following
(but only if you are REALLY SURE):
```
git push origin master --force
```

GitLab will actually reject this...
