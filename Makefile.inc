#-------------------------------------------------------------------------------
# This file is part of MSMS package (https://github.com/honzamach/msms).
#
# Copyright (C) since 2018 Honza Mach <honza.mach.ml@gmail.com>
# Use of this source is governed by the MIT license, see LICENSE file.
#-------------------------------------------------------------------------------

#
# Color code definitions for colored terminal output.
#
# Resource:
#   https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux
#   https://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/x405.html
#   https://linux.die.net/man/1/tput
#
BLACK  = $(shell tput setaf 0)
RED    = $(shell tput setaf 1)
GREEN  = $(shell tput setaf 2)
ORANGE = $(shell tput setaf 3)
BLUE   = $(shell tput setaf 4)
PURPLE = $(shell tput setaf 5)
CYAN   = $(shell tput setaf 6)
WHITE  = $(shell tput setaf 7)
NC     = $(shell tput sgr0)

B_BLACK  = $(shell tput setab 0)
B_RED    = $(shell tput setab 1)
B_GREEN  = $(shell tput setab 2)
B_ORANGE = $(shell tput setab 3)
B_BLUE   = $(shell tput setab 4)
B_PURPLE = $(shell tput setab 5)
B_CYAN   = $(shell tput setab 6)
B_WHITE  = $(shell tput setab 7)

BOLD   = $(shell tput bold)
FAINT  = $(shell tput dim)

#
# Virtual environment
#
VENV_PYTHON = python3
VENV_PATH   = venv
PYTHON      = python3
PIP         = pip
NOSETESTS   = nosetests
TWINE       = twine
PYBABEL     = pybabel

#
# Display extensive help information page.
#
#
# You can set these variables from the command line.
#
SPHINXOPTS    =
SPHINXBUILD   = sphinx-build
PAPER         =
BUILDDIR      = doc/_build

#
# Internal variables.
#
PAPEROPT_a4     = -D latex_paper_size=a4
PAPEROPT_letter = -D latex_paper_size=letter
ALLSPHINXOPTS   = -d $(BUILDDIR)/doctrees $(PAPEROPT_$(PAPER)) $(SPHINXOPTS) .
# The i18n builder cannot share the environment and doctrees with the others
I18NSPHINXOPTS  = $(PAPEROPT_$(PAPER)) $(SPHINXOPTS) .
