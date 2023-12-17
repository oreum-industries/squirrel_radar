# Makefile
# NOTE:
# + Intended for install on MacOS Apple Silicon arm64 using Accelerate
#   (NOT Intel x86 using MKL via Rosetta 2)
# + Uses sh by default: to confirm shell create a recipe with $(info $(SHELL))
.PHONY: dev help install-env install-mamba lint uninstall-env uninstall-mamba
.SILENT: dev help install-env install-mamba lint uninstall-env uninstall-mamba
MAMBADL := https://github.com/conda-forge/miniforge/releases/download/23.3.1-1
MAMBAV := Miniforge3-MacOSX-arm64.sh
MAMBARCMSG := Please create file $(MAMBARC), importantly set `platform: osx-arm64`
MAMBARC := $(HOME)/.mambarc
MAMBADIR := $(HOME)/miniforge
PYTHON_DEFAULT = $(or $(shell which python3), $(shell which python))
PYTHON_ENV = $(MAMBADIR)/envs/squirrel_radar/bin/python
ifneq ("$(wildcard $(PYTHON_ENV))","")
    PYTHON = $(PYTHON_ENV)
else
    PYTHON = $(PYTHON_DEFAULT)
endif
VERSION := $(shell echo $(VVERSION) | sed 's/v//')


dev:  ## create env for local dev
	make install-env
	export PATH=$(MAMBADIR)/envs/squirrel_radar/bin:$$PATH; \
		export CONDA_ENV_PATH=$(MAMBADIR)/envs/squirrel_radar/bin; \
		export CONDA_DEFAULT_ENV=squirrel_radar; \
		export CONDA_SUBDIR=osx-arm64; \
		$(PYTHON_ENV) -m pip install -e ".[dev]"; \
		$(PYTHON_ENV) -c "import numpy as np; np.__config__.show()" > dev/install_log/blas_info.txt; \
		pipdeptree -a > dev/install_log/pipdeptree.txt; \
		pipdeptree -a -r > dev/install_log/pipdeptree_rev.txt; \
		pip-licenses -saud -f markdown --output-file LICENSES_THIRD_PARTY.md; \
		pre-commit install; \
		pre-commit autoupdate;

install-env:  ## create mamba (conda) environment
	export PATH=$(MAMBADIR)/bin:$$PATH; \
		if which mamba; then echo "mamba ready"; else make install-mamba; fi
	export PATH=$(MAMBADIR)/bin:$$PATH; \
		export CONDA_SUBDIR=osx-arm64; \
		mamba update -n base mamba; \
		mamba env create --file condaenv_squirrel_radar.yml -y;

install-mamba:  ## get mamba via miniforge, explicitly use bash
	test -f $(MAMBARC) || { echo $(MAMBARCMSG); exit 1; }
	wget $(MAMBADL)/$(MAMBAV) -O $(HOME)/miniforge.sh
	chmod 755 $(HOME)/miniforge.sh
	bash $(HOME)/miniforge.sh -b -p $(MAMBADIR)
	export PATH=$(MAMBADIR)/bin:$$PATH; \
		conda init zsh;
	rm $(HOME)/miniforge.sh

lint:  ## run code lint & security checks
	$(PYTHON) -m pip install black flake8 interrogate isort bandit
	black --check --diff --config pyproject.toml src/
	isort --check-only src/
	flake8 src/
	interrogate src/
	bandit --config pyproject.toml -r src/

help:
	@echo "Use \make <target> where <target> is:"
	@echo "  dev           create local dev env"
	@echo "  lint          run code lint & security checks"
	@echo "  uninstall-env remove env (use from parent dir \make -C squirrel_radar ...)"


test-dev-env:  ## test the dev machine install of critial numeric packages
	export PATH=$(MAMBADIR)/bin:$$PATH; \
		export PATH=$(MAMBADIR)/envs/squirrel_radar/bin:$$PATH; \
		export CONDA_ENV_PATH=$(MAMBADIR)/envs/squirrel_radar/bin; \
		export CONDA_DEFAULT_ENV=squirrel_radar; \
		$(PYTHON_ENV) -c "import numpy as np; np.test()" > dev/install_log/tests_numpy.txt; \


uninstall-env: ## remove mamba env
	export PATH=$(MAMBADIR)/bin:$$PATH; \
		export CONDA_SUBDIR=osx-arm64; \
		mamba env remove --name squirrel_radar -y; \
		conda clean --all -afy;
		# mamba clean -afy  # 2023-12-10 see: https://github.com/mamba-org/mamba/issues/3044

uninstall-mamba:  ## last ditch per https://github.com/conda-forge/miniforge#uninstallation
	conda init zsh --reverse
	rm -rf $(MAMBADIR)
	rm -rf $(HOME)/.conda
	rm -f $(HOME)/.condarc
