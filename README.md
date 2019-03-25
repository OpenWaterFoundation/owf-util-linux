# owf-util-linux #

This repository contains Open Water Foundation (OWF) Linux utilities.
These are scripts that may be of general use, intended to work in Linux, Cygwin, and Git Bash command line environments.
These scripts are not distributed in any formal fashion and should be copied as needed.

* [Background](#background)
* [Repository Contents](#repository-contents)
* [Utilities List](#utilities-list)
  + [`du-for-dvd.sh`](#du-for-dvd) - determine how to split folder contents for DVD backups
* [Installing Linux Utilities](#installing-linux-utilities)
* [License](#license)
* [Contributing](#contributing)

-----

## Background ##

Linux commands can perform useful tasks but require shell programming knowledge to create.

This repository contains a number of command-line Linux utility scripts that
have been developed to perform useful tasks.
The tools run in the following command line environments:

* Git bash
* Cygwin
* Linux

## Repository Contents ##

The following folder structure is used for the repository:

```text
.gitattributes       Git repository configuration file.
.gitignore           Git configuration file for files to ignore.
build-util/          Folder to help maintain the repository.
scripts/             Folder for script source code.
```

A recommended development environment folder structure when working
with Open Water Foundation products is as follows.

```
C:\User\user\            User files on Windows.
/home/user/              User files on Linux.
c/User/user/             User files on Git Bash.
/cygdrive/c/             User files in Cygwin.
  owf-dev/               Folder for the OWF products.
    Util-Linux/          Folder for the product name.
      git-repos/         Folder for one or more Git repositories.
------- below here folders should always match ----
        owf-util-linux/  OWF Linux utilities.
```

## Utilities List ##

The following are the utilities included in this repository,
which can be found in the `scripts/` folder.

Why is the extension `.sh` used on scripts rather than no extension?
It can be confusing, especially on Windows, to know how a program should
be run and the extension provides a clue.
Implementers of the utilities can choose to remove the extension from the script on the local system.

Each script can be run with `-h` to print its usage.  Run with the `-v` option to check the version.

| **Utility Script**&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | **Description** |
|--------------------------|-----------------|
|`du-for-dvd.sh`           | Run the disk use `du` command on a folder to determine which subfolders should be written to a DVD. |

### `du-for-dvd.sh` ###

Runs the `du -sk` command and determine how to split the contents to write to a DVD (3.7 GB).
For example, `du-for-dvd.sh *` gives output similar to:

```
                                                        AUG3:       10170 KB
                                          BNDSS-Gap-Analysis:      341012 KB
                                           CDSS-Data-Spatial:       95003 KB
                                             cdss-data-yampa:       10648 KB
                                           CDSS-SNODAS-Tools:     1433850 KB
                                                   Learn-Git:        9659 KB
                                       LearnGit-ExamplesRepo:         149 KB
                                           OpenCDSS-Firebase:      129370 KB
                                                     StateCU:      266438 KB
                                                    StateDMI:      600652 KB
                                   StateDMI-clone-2018-09-25:      257138 KB
                                    StateDMI-copy-2018-09-25:      817570 KB
                                                    StateMod:      186869 KB
                                             StateModBrannon:       51475 KB
                                                 StateMod-CS:       29829 KB
                                              StateMod-f2008:           0 KB
                                               StateMod-Java:      263691 KB
                                            statemod-project:       51459 KB
........................................................................................
                                                   DVD Total:     4503523 KB  4.29 GB
========================================================================================

                                             StateMod-Python:           0 KB
                                                 StateModRay:       14353 KB
                                                StateModTest:       51459 KB
                                               StateModTest2:         158 KB
                                               StateModTest3:         158 KB
                                           temp-snodas-setup:         740 KB
                                                        Test:         167 KB
                                       Test-File-Permissions:         437 KB
                                             TestLineEndings:          89 KB
                                            TestLineEndings2:          82 KB
                                      TestLineEndingsEclipse:         470 KB
                                                      TSTool:     1511822 KB
                                                    Util-Git:         598 KB
                                                     WaterML:       51734 KB
                                            Website-OpenCDSS:        3476 KB
                                           x-LearnStateCUDev:        7059 KB
                                          x-LearnStateModDev:        3059 KB
                                                   x-StateCU:        9958 KB
                                        x-StateDMI-OWF-repos:     1220813 KB
                                             x-StateMod-Java:         117 KB
                                          x-TSTool-OWF-repos:     5560782 KB
........................................................................................
                                                   DVD Total:     2876749 KB  2.74 GB
========================================================================================

                                          x-Website-OpenCDSS:        2911 KB
                                         z-StateCU-before-nl:        9435 KB
                         z-StateMod-before-opencdss-transfer:     2135040 KB
........................................................................................
                                                   DVD Total:     2147386 KB  2.05 GB
========================================================================================
```

## Installing Linux Utilities ##

There is no installer.  Copy the desired script to the desired folder,
remove the `.sh` extension if desired, and make sure the script is executable.
Save the script in a folder that is in the `PATH` to ensure that it is found on the command line.

## License ##

The OWF Linux Utilities are licensed under the GPL v3+ license.
See the [GPL v3 license text](LICENSE.md).

## Contributing ##

These Linux utilities have been developed by the Open Water Foundation to
help its staff and collaborators be effective and efficient with Linux.
Feedback and contributions are welcome.  We will try to incorporate.
