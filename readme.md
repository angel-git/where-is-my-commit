# Where is my commit

Simple pet project to find commits by commit message inside branches and tags. Built with [V](https://vlang.io)

## Usage

### Find commits in branches and tags

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

### Commits between 2 tags

```
Usage: gw diff <tag1> <tag2>

Shows the commits between 2 tags

Flags:
      -help           Prints help information.
```

## Development

Install pre-commit git hook with:

```bash
git config core.hooksPath ./git-hooks
```

### Formatting

Example of formatting `gw.v`

```bash
v fmt -w gw.v
```

### Building

```bash
# for linux
v -os linux . -o build/gw-linux
# for mac
v -os macos . -o build/gw-mac
# for windows
v -os windows . -o build/gw-win
```
