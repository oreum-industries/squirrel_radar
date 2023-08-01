# Makefile
# Simplifies dev install on MacOS x64 (Intel)
.PHONY: create-env dev help lint mamba uninstall
.SILENT: create-env dev help lint mamba uninstall
SHELL := /bin/bash
MAMBADL = https://github.com/conda-forge/miniforge/releases/latest/download/
MAMBAV = Mambaforge-MacOSX-x86_64.sh
MAMBARC = $(HOME)/.mambarc
MAMBARCMSG = Please create file $(MAMBARC), particularly to set platform: osx-64
MAMBADIR = $(HOME)/.mamba
PYTHON_DEFAULT = $(or $(shell which python3), $(shell which python))
PYTHON_ENV = $(MAMBADIR)/envs/squirrel_radar/bin/python
ifneq ("$(wildcard $(PYTHON_ENV))","")
    PYTHON = $(PYTHON_ENV)
else
    PYTHON = $(PYTHON_DEFAULT)
endif

create-env: ## create mamba (conda) environment  CONDA_SUBDIR=osx-64
	export PATH=$(MAMBADIR)/bin:$$PATH; \
		if which mamba; then echo "mamba ready"; else make mamba; fi
	mamba env create --file condaenv_squirrel_radar.yml;

dev:  # create env for local dev on any machine MacOS x64 (Intel)
	make create-env
	export PATH=$(MAMBADIR)/envs/squirrel_radar/bin:$$PATH; \
		export CONDA_ENV_PATH=$(MAMBADIR)/envs/squirrel_radar/bin; \
		export CONDA_DEFAULT_ENV=squirrel_radar; \
		export CONDA_SUBDIR=osx-64; \
		$(PYTHON_ENV) -m pip index versions oreum_core; \
		$(PYTHON_ENV) -m pip install -e .[dev]; \
		$(PYTHON_ENV) -c "import numpy as np; np.__config__.show()" > dev/install_log/blas_info.txt; \
		pipdeptree -a > dev/install_log/pipdeptree.txt; \
		pipdeptree -a -r > dev/install_log/pipdeptree_rev.txt; \
		pip-licenses -saud -f markdown --output-file LICENSES_THIRD_PARTY.md; \
		pre-commit install; \
		pre-commit autoupdate;

help:
	@echo "Use \`make <target>' where <target> is:"
	@echo "  dev           create local dev env"
	@echo "  lint          run code lint & security checks"
	@echo "  uninstall     remove local dev env (use from parent dir as `make -C squirrel_radar uninstall`)"

lint: ## run code linters and static security (checks only)
	$(PYTHON) -m pip install black flake8 isort
	black --check --diff --config pyproject.toml src/
	isort --check-only src/
	flake8 src/

mamba:  ## get mamba via mambaforge for MacOS x86_64 (Intel via Rosetta2)
	test -f $(MAMBARC) || { echo $(MAMBARCMSG); exit 1; }
	wget $(MAMBADL)$(MAMBAV) -O $$HOME/mambaforge.sh
	bash $$HOME/mambaforge.sh -b -p $$HOME/.mamba
	export PATH=$$HOME/.mamba/bin:$$PATH; \
		conda init zsh;
	rm $$HOME/mambaforge.sh

uninstall: ## remove mamba env (use from parent dir as `make -C squirrel_radar/ uninstall`)
	mamba env remove --name squirrel_radar -y
	mamba clean -ay
