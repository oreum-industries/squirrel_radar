# README.md

## Squirrel Radar by Oreum Industries `squirrel_radar`

2023Q3

Quick Implementation of the
[Squirrel Radar](https://douglassquirrel.com/radar)


[![CI](https://github.com/oreum-industries/squirrel_radar/workflows/ci/badge.svg)](https://github.com/oreum-industries/squirrel_radar/actions/workflows/ci.yml)
[![code style: black](https://img.shields.io/badge/code%20style-black-000000.svg)](https://github.com/psf/black)
[![code style: flake8](https://img.shields.io/badge/code%20style-flake8-331188.svg)](https://flake8.pycqa.org/en/latest/)
[![code style: isort](https://img.shields.io/badge/code%20style-isort-%231674b1?style=flat)](https://pycqa.github.io/isort/)


### Contents

1. Project Description, Scope, Directory Structure
2. Instructions for Dev Installation
3. Code Standards
4. To Manually Run the CLI to create the Radar Plot

---

## 1. Project Description, Technical Overview, Directory Structure

### 1.1 Project Description & Scope

This is a micro-project for Squirrel Squared by Oreum Industries.

+ Experiments are usually based on Bayesian statistics for insurance modelling
+ This package **is**:
  + A work in progress (v0.y.z) and liable to breaking changes and inconveniences
    to the user
  + Solely designed for ease of use and rapid development by employees of Oreum
    Industries, and Squirrel Squared with guidance
+ This package **is not**:
  + Intended for public usage and will not be supported for public usage
  + Intended for contributions by anyone not an employee of Oreum Industries,
  and unsolicitied contributions will not be accepted


### 1.2 Technical Overview

+ Project began on 2023-07-31
+ The `README.md` is MacOS and POSIX oriented
+ See `LICENCE.md` for licensing and copyright details
+ See `pyproject.toml` for authors, dependencies etc
+ Source code is hosted on [GitHub](https://github.com/oreum-industries/squirrel_radar)



### 1.3 Project File Structure

The repo is structured for R&D usage. The major items to be
aware of are:

```zsh
/
↳ dotfiles         - various dotfiles to configure the repo
↳ Makefile         - recipes to build the dev env
↳ README.md        - this readme file
↳ LICENSE.md       - licensing and copyright details
↳ src/             - Python modules
```

---


## 2. Instructions to Create Dev Environment

For local development on MacOS


### 2.0 Pre-requisite installs via `homebrew`

1. Install Homebrew, see instuctions at [https://brew.sh](https://brew.sh)
2. Install `direnv`, `git`

```zsh
$> brew update && brew upgrade
$> brew install direnv git
```


### 2.1 Git clone the repo

Assumes `git` and `direnv` installed as above

```zsh
$> git clone https://github.com/oreum-industries/squirrel_radar
$> cd squirrel_radar
```

Then manually allow `direnv` on MacOS to automatically run file `.envrc`
upon directory open


### 2.2 Create virtual environment and install dev packages

Notes:

+ We use `conda` virtual envs controlled by `mamba` (quicker than `conda`)
+ We install packages using `mambaforge` (sourced from the `conda-forge` repo) wherever possible and use `pip` for packages that are handled better by `pip` and/or more up-to-date on [pypi](https://pypi.org)
+ See [cheat sheet of conda commands](https://conda.io/docs/_downloads/conda-cheatsheet.pdf)


#### 2.2.1 Create the dev environment

From the dir above `squirrel_radar/` project dir:

```zsh
$> make -C squirrel_radar dev
```

This will also create some files to help confirm / diagnose successful installation:

+ `dev/install_log/pipdeptree[_rev].txt` lists installed package deps (and reversed)
+ `LICENSES_THIRD_PARTY.md` details the license for each package used

#### 2.2.2 To remove the dev environment (Useful during env install experimentation):

From the dir above `squirrel_radar/` project dir:

```zsh
$> make -C squirrel_radar uninstall
```


### 2.3 Code Linting & Repo Control

#### 2.3.1 Pre-commit

We use [pre-commit](https://pre-commit.com) to run a suite of automated tests
for code linting & quality control and repo control prior to commit on local
development machines.

+ This is installed as part of `make dev` which you already ran.
+ See `.pre-commit-config.yaml` for details


#### 2.3.2 GitHub Actions

We use [GitHub Actions](https://docs.github.com/en/actions/using-workflows) aka
GitHub Workflows to run a suite of automated tests for commits received at the
origin (i.e. GitHub)

+ See `.github/workflows/*` for details


### 2.4 Configs for Local Development

Some notes to help configure local development environment

#### 2.4.1 Git config `~/.gitconfig`

```yaml
[user]
    name = <YOUR NAME>
    email = <YOUR EMAIL ADDRESS>
```

---

---

## 3. Code Standards

Even when writing R&D code, we strive to meet and exceed (even define) best
practices for code quality, documentation and reproducibility for modern
data science projects.

### 3.1 Code Linting & Repo Control

We use a suite of automated tools to check and enforce code quality. We indicate
the relevant shields at the top of this README. See section 1.4 above for how
this is enforced at precommit on developer machines and upon PR at the origin as
part of our CI process, prior to master branch merge.

These include:

+ [`black`](https://github.com/psf/black) - standardised Python linting
+ [`flake8`](https://flake8.pycqa.org/en/latest/) - addtional PEP8 Python linting
+ [`isort`](https://pycqa.github.io/isort/) - sort Python package imports

We also run a suite of general tests pre-packaged with
[`precommit`](https://pre-commit.com).


---

## 4. To Manually Run the CLI to create the Radar Plot

The CLI is uses [typer](https://typer.tiangolo.com) - a Python package to create
CLI apps. This gives a standardised UI/UX.

To read the CLI helptext do:

```zsh
$> python src/cli.py --help
```

To create the Radar plot, use the `create` step:

```zsh
$> python src/cli.py create --scores 123334
```

---
---

Copyright 2023 Oreum OÜ t/a Oreum Industries. All rights reserved.
See LICENSE.md.

Oreum OÜ t/a Oreum Industries, Sepapaja 6, Tallinn, 15551, Estonia,
reg.16122291, [oreum.io](https://oreum.io)

---
Oreum OÜ &copy; 2023
