#-------------------------------------------------------------------------------
# MASTER MAKEFILE FOR MENTAT-NG PROJECT
#
# Copyright (C) since 2016, CESNET, z. s. p. o.
# Author: Jan Mach <jan.mach@cesnet.cz>
# Use of this source is governed by an MIT license, see LICENSE file.
#-------------------------------------------------------------------------------

#
# Default make target, alias for 'help', you must explicitly choose the target.
#
default: help


#===============================================================================

#
# Include common makefile configurations.
#
include Makefile.inc

#
# Define local variables.
#
ROOT_DIR = $(shell pwd)

#-------------------------------------------------------------------------------


help:
	@echo ""
	@echo " $(GREEN)                                 ███╗   ███╗███████╗███╗   ███╗███████╗$(NC)"
	@echo " $(GREEN)                                 ████╗ ████║██╔════╝████╗ ████║██╔════╝$(NC)"
	@echo " $(GREEN)                                 ██╔████╔██║███████╗██╔████╔██║███████╗$(NC)"
	@echo " $(GREEN)                                 ██║╚██╔╝██║╚════██║██║╚██╔╝██║╚════██║$(NC)"
	@echo " $(GREEN)                                 ██║ ╚═╝ ██║███████║██║ ╚═╝ ██║███████║$(NC)"
	@echo " $(GREEN)                                 ╚═╝     ╚═╝╚══════╝╚═╝     ╚═╝╚══════╝$(NC)"
	@echo ""
	@echo ""
	@echo " $(GREEN)$(BOLD)╔══════════════════════════════════════════════════════════════════════════════════════════════════╗$(NC)"
	@echo " $(GREEN)$(BOLD)║                                  LIST OF AVAILABLE MAKE TARGETS                                  ║$(NC)"
	@echo " $(GREEN)$(BOLD)╚══════════════════════════════════════════════════════════════════════════════════════════════════╝$(NC)"
	@echo ""
	@echo "  • $(GREEN)default$(NC): alias for 'help', you have to pick a target"
	@echo "  • $(GREEN)help$(NC): print this help message and exit"
	@echo "  • $(GREEN)facts-fetch$(NC): fetch host facts"
	@echo ""
	@echo " ─── MSMS MANAGEMENT ────────────────────────────────────────────────────────────────────────────────"
	@echo ""
	@echo "  • $(GREEN)msms-setup$(NC): setup fresh MSMS inventory configuration"
	@echo "  • $(GREEN)msms-load META_URL=git_url$(NC): loading MSMS inventory configuration from given repository URL"
	@echo "  • $(GREEN)msms-upgrade$(NC): upgrade MSMS system and inventory configuration"
	@echo "  • $(GREEN)msms-commit$(NC): commit local inventory configuration changes to MSMS metadata repository"
	@echo "  • $(GREEN)msms-push$(NC): push local inventory configuration changes to MSMS metadata repository"
	@echo "  • $(GREEN)msms-on$(NC): turn on server management system"
	@echo "  • $(GREEN)msms-off$(NC): turn off server management system"
	@echo ""
	@echo " ─── ROLE MANAGEMENT ────────────────────────────────────────────────────────────────────────────────"
	@echo ""
	@echo "  • $(GREEN)role-install ROLE_URL=git_url ROLE_NAME=name$(NC): install role into inventory"
	@echo "  • $(GREEN)role-create$(NC): create new role in inventory"
	@echo ""
	@echo "  • $(GREEN)roles-install-default$(NC): install default set of roles in read-only mode"
	@echo "  • $(GREEN)roles-on$(NC): install role specific playbooks to main directory"
	@echo "  • $(GREEN)roles-off$(NC): uninstall role specific playbooks from main directory"
	@echo "  • $(GREEN)roles-check$(NC): checking status of installed roles"
	@echo "  • $(GREEN)roles-upgrade$(NC): upgrade all installed roles to latest versions"
	@echo ""
	@echo " ─── PLAYBOOKS ANS PLAYS ────────────────────────────────────────────────────────────────────────────"
	@echo ""
	@echo "  • $(GREEN)playbooks-on$(NC): install playbooks to main directory"
	@echo "  • $(GREEN)playbooks-off$(NC): uninstall playbooks from main directory"
	@echo ""
	@echo "  • $(GREEN)play-full$(NC): perform full inventory provisioning"
	@echo "  • $(GREEN)play-full-check$(NC): perform full inventory provisioning (dry run)"
	@echo "  • $(GREEN)play-upgrade$(NC): perform full inventory OS upgrade"
	@echo "  • $(GREEN)play-upgrade-check$(NC): perform full inventory OS upgrade (dry run)"
	@echo ""
	@echo " ─── DOCUMENTATION ──────────────────────────────────────────────────────────────────────────────────"
	@echo ""
	@echo "  • $(GREEN)docs$(NC): alias for 'docs-html' and 'docs-view'"
	@echo "  • $(GREEN)docs-clean$(NC): clean artifacts of locally built documentation"
	@echo "  • $(GREEN)docs-html$(NC): generate HTML project documentation"
	@echo "  • $(GREEN)docs-dirhtml$(NC): generate DIRHTML project documentation"
	@echo "  • $(GREEN)docs-singlehtml$(NC): generate SINGLEHTML project documentation"
	@echo "  • $(GREEN)docs-view$(NC): view HTML project documentation"
	@echo ""
	@echo " $(GREEN)────────────────────────────────────────────────────────────────────────────────────────────────────$(NC)"
	@echo " © 2019                                                             https://github.com/honzamach/msms"
	@echo ""


#-------------------------------------------------------------------------------


msms-setup: venv-setup config-setup

msms-load: venv-setup config-load

msms-upgrade:
	@echo "\n$(GREEN)*** Upgrading MSMS system ***$(NC)\n"
	git pull
	@echo "\n$(GREEN)*** Upgrading MSMS inventory configuration ***$(NC)\n"
	git -C $(ROOT_DIR)/inventory pull

msms-commit:
	@echo "\n$(GREEN)*** Commiting changes to MSMS inventory configuration ***$(NC)\n"
	git -C $(ROOT_DIR)/inventory add -A && git -C $(ROOT_DIR)/inventory commit

msms-push:
	@echo "\n$(GREEN)*** Pushing changes to MSMS inventory configuration to remote shared repository ***$(NC)\n"
	git -C $(ROOT_DIR)/inventory push

msms-on: config-on roles-on playbooks-on

msms-off: config-off roles-off playbooks-off


#-------------------------------------------------------------------------------


venv-setup:
	@echo "\n$(GREEN)*** Installing locally Python virtual environment ***$(NC)\n"
	@if [ -d $(VENV_PATH) ]; then\
		echo "$(CYAN)Virtual environment already exists in '$(VENV_PATH)'.$(NC)";\
	else\
		echo "Requested version: $(VENV_PYTHON)";\
		echo "Path to binary:    `which $(VENV_PYTHON)`";\
		echo "Path to venv:      $(VENV_PATH)";\
		echo "";\
		$(VENV_PYTHON) -m venv $(VENV_PATH);\
		echo "$(CYAN)Virtual environment successfully created in '$(VENV_PATH)'.$(NC)";\
	fi

	@echo "\n$(GREEN)*** Upgrading PIP ***$(NC)\n"
	@$(VENV_PATH)/bin/pip install --upgrade pip

	@echo "\n$(GREEN)*** Installing Python packages ***$(NC)\n"
	@$(VENV_PATH)/bin/pip install --upgrade ansible
	@$(VENV_PATH)/bin/pip install --upgrade ansible-lint
	@$(VENV_PATH)/bin/pip install --upgrade sphinx
	@$(VENV_PATH)/bin/pip install --upgrade sphinx-rtd-theme

	@echo "\n$(GREEN)*** Current virtual environment status ***$(NC)\n"
	@echo "Venv path: `. $(VENV_PATH)/bin/activate && python -c 'import sys; print(sys.prefix)'`"
	@echo "Python stuff versions:"
	@echo -n " * "
	@$(VENV_PATH)/bin/python -V
	@echo -n " * "
	@$(VENV_PATH)/bin/pip -V
	@echo ""
	@echo "Python packages:"
	@echo ""
	@$(VENV_PATH)/bin/pip freeze | sort
	@echo ""
	@echo "\n$(CYAN)Your work environment is ready in `. $(VENV_PATH)/bin/activate && python -c 'import sys; print(sys.prefix)'`.$(NC)\n"
	@echo "Please activate it manually with following command:\n"
	@echo "\t$(ORANGE). $(VENV_PATH)/bin/activate$(NC)\n"
	@echo "Consider adding following alias to your ~/.bashrc file for easier environment activation:\n"
	@echo "\t$(ORANGE)alias entervenv='. venv/bin/activate'$(NC)\n"
	@echo "$(BOLD)!!! Please keep in mind, that all makefile targets except this one ('venv-setup') leave it up to you to activate the correct virtual environment !!!$(NC)"
	@echo ""


#-------------------------------------------------------------------------------


config-setup:
	@echo "\n$(GREEN)*** Setting up fresh host inventory configuration ***$(NC)\n"
	@bin/setup_inventory.sh

config-load:
	@echo "\n$(GREEN)*** Loading MSMS inventory configuration from '${META_URL}' ***$(NC)\n"
	git clone --recurse-submodules $(META_URL) $(ROOT_DIR)/inventory

config-on:
	@echo "\n$(GREEN)*** Enabling host inventory configuration ***$(NC)\n"
	@if [ ! -L "$(ROOT_DIR)/roles" ]; then \
		echo "Enabling configuration: roles"; \
		ln -s "$(ROOT_DIR)/inventory/roles" "$(ROOT_DIR)/roles"; \
	fi;

config-off:
	@echo "\n$(GREEN)*** Disabling host inventory configuration ***$(NC)\n"
	@for linkfile in roles; do \
		if [ -L "$(ROOT_DIR)/$$linkfile" ]; then \
			echo "Disabling configuration: $$linkfile"; \
			rm "$(ROOT_DIR)/$$linkfile"; \
		fi; \
	done


#-------------------------------------------------------------------------------


facts-fetch:
	@echo "\n$(GREEN)*** Fetching host facts ***$(NC)\n"
	@mkdir -p ./spool/host_facts
	ansible --inventory ./inventory/hosts --module-name setup --tree ./spool/host_facts servers --ask-vault--pass


#-------------------------------------------------------------------------------


play-full:
	@echo "\n$(GREEN)*** Performing full inventory provisioning ***$(NC)\n"
	ansible-playbook --inventory ./inventory/hosts playbook_full.yml --ask-vault--pass

play-full-check:
	@echo "\n$(GREEN)*** Performing full inventory provisioning (DRY-RUN)***$(NC)\n"
	ansible-playbook --inventory ./inventory/hosts --check --diff playbook_full.yml --ask-vault--pass

play-upgrade:
	@echo "\n$(GREEN)*** Performing full inventory OS upgrade ***$(NC)\n"
	ansible-playbook --inventory ./inventory/hosts task_system_upgrade.yml --ask-vault--pass

play-upgrade-check:
	@echo "\n$(GREEN)*** Performing full inventory OS upgrade (DRY-RUN)***$(NC)\n"
	ansible-playbook --inventory ./inventory/hosts --check --diff task_system_upgrade.yml --ask-vault--pass

#-------------------------------------------------------------------------------


playbooks-on:
	@echo "\n$(GREEN)*** Installing playbooks to main directory ***$(NC)\n"
	@for playfile in `find ./inventory/playbooks/ -name playbook_*.yml`; do \
		if [ ! -L `pwd`/`basename $$playfile` ]; then \
			echo "Installing playbook: `basename $$playfile`"; \
			ln -s `realpath $$playfile` `pwd`/`basename $$playfile`; \
		else \
			echo "Playbook already installed: `basename $$playfile`"; \
		fi; \
	done

playbooks-off:
	@echo "\n$(GREEN)*** Uninstalling playbooks from main directory ***$(NC)\n"
	@for linkfile in ./playbook_*; do \
		if [ -L "$(ROOT_DIR)/$$linkfile" ]; then \
			echo "Uninstalling playbook: $$linkfile"; \
			rm "$(ROOT_DIR)/$$linkfile"; \
		fi; \
	done


#-------------------------------------------------------------------------------


role-install: role-fetch roles-on

role-fetch:
	@echo "\n$(GREEN)*** Installing role '${ROLE_URL}' as '${ROLE_NAME}' ***$(NC)\n"
	git -C $(ROOT_DIR)/inventory submodule add ${ROLE_URL} roles/${ROLE_NAME}
	git -C $(ROOT_DIR)/inventory add .gitmodules roles/${ROLE_NAME}
	git -C $(ROOT_DIR)/inventory commit -m "Installed role ${ROLE_NAME} from ${ROLE_URL}"

role-create: role-new roles-on

role-new:
	@echo "\n$(GREEN)*** Creating new role ***$(NC)\n"
	ansible-playbook --inventory ./inventory/hosts role_util_rolecreator.yml --ask-vault--pass

#-------------------------------------------------------------------------------


roles-on:
	@echo "\n$(GREEN)*** Installing role specific playbooks to main directory ***$(NC)\n"
	@if [ -n $(find ./inventory/roles/ -name "role_*.yml") ]; then \
		for rolefile in `find ./inventory/roles/ -name "role_*.yml"`; do \
			if [ ! -L `pwd`/`basename $$rolefile` ]; then \
				echo "Installing role playbook: `basename $$rolefile`"; \
				ln -s `realpath $$rolefile` `pwd`/`basename $$rolefile`; \
			else \
				echo "Role playbook already installed: `basename $$rolefile`"; \
			fi; \
		done; \
	fi

roles-off:
	@echo "\n$(GREEN)*** Uninstalling role specific playbooks from main directory ***$(NC)\n"
	@for linkfile in ./role_*; do \
		if [ -L $(ROOT_DIR)/$$linkfile ]; then \
			echo "Uninstalling role playbook: $$linkfile"; \
			rm $(ROOT_DIR)/$$linkfile; \
		fi; \
	done

roles-install-default:
	@echo "\n$(GREEN)*** Installing default set of roles in read-only mode ***$(NC)\n"
	@bin/setup_default_roles.sh

roles-check:
	@echo "\n$(GREEN)*** Checking status of all installed roles ***$(NC)\n"
	@for roledir in ./roles/*; do \
		if [ -d $$roledir ]; then \
			echo "════════════════════════════════════════════════════════════════════════════════════════════════════"; \
			echo " Checking role: $$roledir"; \
			echo "────────────────────────────────────────────────────────────────────────────────────────────────────"; \
			if [ -d $$roledir/.git ] || [ -f $$roledir/.git ]; then \
				echo; \
				git -C $$roledir status; \
				echo; \
			else \
				echo; \
				echo "Unable to check for new version, role is NOT under versioning."; \
				echo; \
			fi; \
		fi; \
	done

roles-upgrade:
	@echo "\n$(GREEN)*** Upgrading all installed roles ***$(NC)\n"
	@for roledir in ./roles/*; do \
		if [ -d $$roledir ]; then \
			echo "════════════════════════════════════════════════════════════════════════════════════════════════════"; \
			echo " Upgrading role: $$roledir"; \
			echo "────────────────────────────────────────────────────────────────────────────────────────────────────"; \
			if [ -d $$roledir/.git ] || [ -f $$roledir/.git ]; then \
				echo; \
				git -C $$roledir pull; \
				echo; \
			else \
				echo; \
				echo "Unable to upgrade to latest version, role is NOT under versioning."; \
				echo; \
			fi; \
		fi; \
	done


#-------------------------------------------------------------------------------


docs: docs-html docs-view

docs-clean: FORCE
	@echo "\n$(GREEN)*** Cleaning documentation artifacts ***$(NC)\n"
	rm -rf $(BUILDDIR)/*

docs-html: FORCE
	@echo "\n$(GREEN)*** Generating HTML project documentation ***$(NC)\n"
	$(SPHINXBUILD) -b html $(ALLSPHINXOPTS) $(BUILDDIR)/html
	@echo
	@echo "Build finished. The HTML pages are in $(BUILDDIR)/html."

docs-dirhtml: FORCE
	@echo "\n$(GREEN)*** Generating DIRHTML project documentation ***$(NC)\n"
	$(SPHINXBUILD) -b dirhtml $(ALLSPHINXOPTS) $(BUILDDIR)/dirhtml
	@echo
	@echo "Build finished. The HTML pages are in $(BUILDDIR)/dirhtml."

docs-singlehtml: FORCE
	@echo "\n$(GREEN)*** Generating SINGLEHTML project documentation ***$(NC)\n"
	$(SPHINXBUILD) -b singlehtml $(ALLSPHINXOPTS) $(BUILDDIR)/singlehtml
	@echo
	@echo "Build finished. The HTML page is in $(BUILDDIR)/singlehtml."

docs-gettext: FORCE
	$(SPHINXBUILD) -b gettext $(I18NSPHINXOPTS) $(BUILDDIR)/locale
	@echo
	@echo "Build finished. The message catalogs are in $(BUILDDIR)/locale."

docs-changes: FORCE
	$(SPHINXBUILD) -b changes $(ALLSPHINXOPTS) $(BUILDDIR)/changes
	@echo
	@echo "The overview file is in $(BUILDDIR)/changes."

docs-view:
	@x-www-browser `realpath $(BUILDDIR)`/html/documentation.html



#-------------------------------------------------------------------------------


# Empty rule as dependency will force make to always perform target
# Source: https://www.gnu.org/software/make/manual/html_node/Force-Targets.html
FORCE:
