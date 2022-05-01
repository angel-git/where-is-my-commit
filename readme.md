# Where is my commit

Simple pet project to find commits by commit message inside branches and tags. Built with [V](https://vlang.io)

## Usage

```
Usage: gw search [flags] <commit message>

Searches the commit message in branches and tags

Flags:
  -b  -branch         Containing branch name that you want to filter
  -t  -tag            Containing tag name that you want to filter
      -help           Prints help information.
```

Example:

```
gw search -tag MY_TAG_NAME -branch MY_BRANCHES D-19007

Searching for D-19007 in branches MY_BRANCHES and tags MY_TAG_NAME
Branches:
origin/10.0.MY_BRANCHES
origin/10.1.MY_BRANCHES
Tags:
MY_TAG_NAME-10.0.10
MY_TAG_NAME-10.0.11
MY_TAG_NAME-10.0.12
MY_TAG_NAME-10.0.12-alp
```

## Building

```bash
# for linux
v -os linux . -o build/gw-linux
# for mac
v . -o build/gw-mac
# for windows, this doesnt work from M1
v -os windows . -o build/gw-win
```
