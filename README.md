# reusable-makefiles

A way of automating and reusing Makefiles.

## Usage Examples

**default targets:**

```bash
❯ make help
Available targets:
  add-target                          Add a reusable Makefile from the repository
  help                                This help screen
  remove-target                       Remove a reusable Makefile reference from the current Makefile
  remove-target-file                  Remove a downloaded Makefile from disk
  update-targets                      Update the index of available Makefiles
```

**add-target:**  : Add a target fom this repository and includes it.
For example: in this repository we have a dir named as `git` and we can include the targets inside `git/Makefile` by
running:

**remove-target:** : Remove the previously included target from the current Makefile.

**remove-target-file:** : Remove the previously downloaded target from disk. (Please make sure that none of targets you
are removing are used in any other projects as well, safer to use the `remove-target` target instead)

## How this work?

Each directory (folder) in this repository is a target collection ( or a target group, whatever you call it, naming is
really hard) that includes a Makefile with targets that can be included in other projects.
And the folder can be nested as well, for example: `version/simple` is a target group that includes a
Makefile `version/simple/Makefile` that can be included in other projects.
