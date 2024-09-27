# Developing

## Updating SysML standard library and Jupyter SysML kernel

Follow the manual instructions in `docs/advanced-setup.md`.

Push to the template repository.

## Creating a release

**Create a Changelog fragment with every noteworthy change:**

Make changes to your project files. Create a changelog fragment:

```bash
hatch run docs:scriv create --edit
```

Commit the work together with the changelog fragment.

**Creating a release:**

Start with a clean working tree, commit all changes that are to be released before continuing.

Set the new version number in `pyproject.toml`. Adhere to [Semantic Versioning](https://semver.org/).

Create the changelog by collecting fragments:

```bash
hatch run docs:scriv collect
```

Check the resulting changelog. Commit to the repo with release tag:

```bash
git tag -a v0.0.1 -m "New release"
git push origin --tags
```

Create a release in GitHub. See [GitLab releases](https://docs.github.com/en/repositories/releasing-projects-on-github/managing-releases-in-a-repository#creating-a-release).

## Commit message template

Copy the block below to a file in your projects `.git` directory, `.git/commit-msg-template`, then modify your git config. From the project root directory:

```bash
touch .git/commit-msg-template  # copy in the text below
git config commit.template .git/commit-msg-template
```

```
<type>[optional scope]: <subject> (#issue_number)

[optional body]

[optional footer(s)]

# types:    build:, chore:, ci:, docs:, feat:, fix:, style:, refactor:, perf:, test:
# scopes:   project specific

# fix:    PATCH in semantic versioning
# feat:   MINOR in semantic versioning.
# feat(api)!:  Exclamation indicates breaking change

# BREAKING CHANGE: <description>
# closes #3 (closes, fixes, resolves)

# feat(model): Add requirements package (#3)
#
# Added new page.
#
# closes #123
```
