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
	@echo " $(GREEN)                         ███╗   ███╗███████╗███╗   ███╗███████╗$(NC)"
	@echo " $(GREEN)                         ████╗ ████║██╔════╝████╗ ████║██╔════╝$(NC)"
	@echo " $(GREEN)                         ██╔████╔██║███████╗██╔████╔██║███████╗$(NC)"
	@echo " $(GREEN)                         ██║╚██╔╝██║╚════██║██║╚██╔╝██║╚════██║$(NC)"
	@echo " $(GREEN)                         ██║ ╚═╝ ██║███████║██║ ╚═╝ ██║███████║$(NC)"
	@echo " $(GREEN)                         ╚═╝     ╚═╝╚══════╝╚═╝     ╚═╝╚══════╝$(NC)"                                
	@echo ""
	@echo " $(GREEN)$(BOLD)╔══════════════════════════════════════════════════════════════════════════════════╗$(NC)"
	@echo " $(GREEN)$(BOLD)║                          LIST OF AVAILABLE MAKE TARGETS                          ║$(NC)"
	@echo " $(GREEN)$(BOLD)╚══════════════════════════════════════════════════════════════════════════════════╝$(NC)"
	@echo ""
	@echo "  * $(GREEN)default$(NC): alias for help, you have to pick a target"
	@echo "  * $(GREEN)help$(NC): print this help message and exit"
	@echo ""
	@echo "  * $(GREEN)msms-setup$(NC): setup fresh environment for server management system"
	@echo "  * $(GREEN)msms-load META_URL=git_url$(NC): load existing environment for server management system"
	@echo "  * $(GREEN)msms-upgrade$(NC): upgrade environment for server management system"
	@echo "  * $(GREEN)msms-on$(NC): turn on server management system"
	@echo "  * $(GREEN)msms-off$(NC): turn off server management system"
	@echo ""
	@echo "  * $(GREEN)vault-on$(NC): open vault"
	@echo "  * $(GREEN)vault-off$(NC): close vault"
	@echo ""
	@echo "  * $(GREEN)facts-fetch$(NC): fetch host facts"
	@echo ""
	@echo "  * $(GREEN)role-install ROLE_URL=git_url ROLE_NAME=name$(NC): install role playbooks to main directory"
	@echo ""
	@echo "  * $(GREEN)roles-on$(NC): install role playbooks to main directory"
	@echo "  * $(GREEN)roles-off$(NC): uninstall role playbooks from main directory"
	@echo "  * $(GREEN)roles-check$(NC): checking status of installed roles"
	@echo "  * $(GREEN)roles-upgrade$(NC): upgrade all installed roles to latest versions"
	@echo ""
	@echo "  * $(GREEN)docs$(NC): generate local project documentation"
	@echo "     = $(ORANGE)docs-view$(NC): view HTML project documentation"
	@echo "     = $(ORANGE)docs-html$(NC): generate HTML project documentation"
	@echo "     = $(ORANGE)docs-dirhtml$(NC): generate DIRHTML project documentation"
	@echo "     = $(ORANGE)docs-singlehtml$(NC): generate SINGLEHTML project documentation"
	@echo ""
	@echo " $(GREEN)────────────────────────────────────────────────────────────────────────────────$(NC)"
	@echo ""


#-------------------------------------------------------------------------------


msms-setup: vault-setup

msms-load:
	@echo "\n$(GREEN)*** Loading MSMS metadata from '${META_URL}' ***$(NC)\n"
	git clone --recurse-submodules $(META_URL) $(ROOT_DIR)/msms_metadata

msms-upgrade:
	@echo "\n$(GREEN)*** Upgrading MSMS metadata ***$(NC)\n"
	git pull
	git -C $(ROOT_DIR)/msms_metadata pull

msms-commit:
	@echo "\n$(GREEN)*** Commiting changes to MSMS metadata ***$(NC)\n"
	git -C $(ROOT_DIR)/msms_metadata commit -a

msms-push:
	@echo "\n$(GREEN)*** Pushing current MSMS metadata to remote shared repository ***$(NC)\n"
	git -C $(ROOT_DIR)/msms_metadata push

msms-on: vault-on roles-on playbooks-on

msms-off: vault-off roles-off playbooks-off


#-------------------------------------------------------------------------------


vault-setup:
	@echo "\n$(GREEN)*** Setting up fresh server management vault ***$(NC)\n"
	@if [ ! -d "$(ROOT_DIR)/msms_metadata" ]; then \
		mkdir -p "$(ROOT_DIR)/msms_metadata"; \
	fi
	@if [ ! -d "$(ROOT_DIR)/msms_metadata/vault" ]; then \
		mkdir -p "$(ROOT_DIR)/msms_metadata/vault"; \
	fi
	@if [ ! -d "$(ROOT_DIR)/msms_metadata/roles" ]; then \
		mkdir -p "$(ROOT_DIR)/msms_metadata/roles"; \
	fi
	@if [ ! -d "$(ROOT_DIR)/msms_metadata/playbooks" ]; then \
		mkdir -p "$(ROOT_DIR)/msms_metadata/playbooks"; \
	fi
	@if [ ! -d "$(ROOT_DIR)/msms_metadata/.git" ]; then \
		git init "$(ROOT_DIR)/msms_metadata"; \
	fi
	@if [ ! -d "$(ROOT_DIR)/vault" ]; then \
		mkdir -p "$(ROOT_DIR)/vault"; \
	fi
	@encfs --standard "$(ROOT_DIR)/msms_metadata/vault" "$(ROOT_DIR)/vault"
	@for subdir in docs spool group_files group_vars host_facts host_files host_vars inventories user_files; do \
		if [ ! -d $(ROOT_DIR)/vault/$$subdir ]; then \
			mkdir -p $(ROOT_DIR)/vault/$$subdir; \
		fi; \
	done

vault-on:
	@echo "\n$(GREEN)*** Opening vault ***$(NC)\n"
	@mkdir -p "$(ROOT_DIR)/vault"
	@encfs "$(ROOT_DIR)/msms_metadata/vault" "$(ROOT_DIR)/vault"
	@ln -s "$(ROOT_DIR)/msms_metadata/roles" "$(ROOT_DIR)/roles"
	@ln -s "$(ROOT_DIR)/vault/group_files" "$(ROOT_DIR)/group_files"
	@ln -s "$(ROOT_DIR)/vault/group_vars" "$(ROOT_DIR)/group_vars"
	@ln -s "$(ROOT_DIR)/vault/host_facts" "$(ROOT_DIR)/host_facts"
	@ln -s "$(ROOT_DIR)/vault/host_files" "$(ROOT_DIR)/host_files"
	@ln -s "$(ROOT_DIR)/vault/host_vars" "$(ROOT_DIR)/host_vars"
	@ln -s "$(ROOT_DIR)/vault/inventories" "$(ROOT_DIR)/inventories"
	@ln -s "$(ROOT_DIR)/vault/user_files" "$(ROOT_DIR)/user_files"

vault-off:
	@echo "\n$(GREEN)*** Closing vault ***$(NC)\n"
	@fusermount -u "$(ROOT_DIR)/vault"
	@rmdir "$(ROOT_DIR)/vault"
	@for linkfile in group_files group_vars host_facts host_files host_vars inventories roles user_files; do \
		if [ -L $(ROOT_DIR)/$$linkfile ]; then \
			rm $(ROOT_DIR)/$$linkfile; \
		fi; \
	done


#-------------------------------------------------------------------------------


facts-fetch:
	@echo "\n$(GREEN)*** Fetching host facts ***$(NC)\n"
	@mkdir -p ./vault/host_facts/production/
	ansible --inventory ./inventories/production --module-name setup --tree ./vault/host_facts/production/ servers


#-------------------------------------------------------------------------------


play-full:
	@echo "\n$(GREEN)*** Performing full management ***$(NC)\n"
	ansible-playbook --inventory ./inventories/production playbook_full.yml

play-full-check:
	@echo "\n$(GREEN)*** Performing full management (DRY-RUN)***$(NC)\n"
	ansible-playbook --inventory ./inventories/production --check --diff playbook_full.yml

play-upgrade:
	@echo "\n$(GREEN)*** Performing full management ***$(NC)\n"
	ansible-playbook --inventory ./inventories/production task_system_upgrade.yml

play-upgrade-check:
	@echo "\n$(GREEN)*** Performing full management (DRY-RUN)***$(NC)\n"
	ansible-playbook --inventory ./inventories/production --check --diff task_system_upgrade.yml

#-------------------------------------------------------------------------------


playbooks-on:
	@echo "\n$(GREEN)*** Installing playbooks to main directory ***$(NC)\n"
	@for playfile in `find ./msms_metadata/playbooks/ -name playbook_*.yml`; do \
		echo "Installing playbook `basename $$playfile`"; \
		if [ ! -L `pwd`/`basename $$playfile` ]; then \
			ln -s `realpath $$playfile` `pwd`/`basename $$playfile`; \
		fi; \
	done

playbooks-off:
	@echo "\n$(GREEN)*** Uninstalling playbooks from main directory ***$(NC)\n"
	@for linkfile in ./playbook_*; do \
		if [ -L $(ROOT_DIR)/$$linkfile ]; then \
			rm $(ROOT_DIR)/$$linkfile; \
		fi; \
	done


#-------------------------------------------------------------------------------


role-install: role-fetch roles-on

role-fetch:
	@echo "\n$(GREEN)*** Installing role '${ROLE_URL}' as '${ROLE_NAME}' ***$(NC)\n"
	git -C $(ROOT_DIR)/msms_metadata submodule add ${ROLE_URL} roles/${ROLE_NAME}
	git -C $(ROOT_DIR)/msms_metadata add .gitmodules roles/${ROLE_NAME}
	git -C $(ROOT_DIR)/msms_metadata commit -m "Installed role ${ROLE_NAME} from ${ROLE_URL}"


#-------------------------------------------------------------------------------


roles-on:
	@echo "\n$(GREEN)*** Installing role playbooks to main directory ***$(NC)\n"
	@for rolefile in `find ./roles/ -name role_*.yml`; do \
		echo "Installing role playbook `basename $$rolefile`"; \
		if [ ! -L `pwd`/`basename $$rolefile` ]; then \
			ln -s `realpath $$rolefile` `pwd`/`basename $$rolefile`; \
		fi; \
	done

roles-off:
	@echo "\n$(GREEN)*** Uninstalling role playbooks from main directory ***$(NC)\n"
	@for linkfile in ./role_*; do \
		if [ -L $(ROOT_DIR)/$$linkfile ]; then \
			rm $(ROOT_DIR)/$$linkfile; \
		fi; \
	done

roles-check:
	@echo "\n$(GREEN)*** Checking status of all installed roles ***$(NC)\n"
	@for roledir in ./roles/*; do \
		if [ -d $$roledir ]; then \
			echo "════════════════════════════════════════════════════════════════════════════════"; \
			echo " Checking role: $$roledir"; \
			echo "────────────────────────────────────────────────────────────────────────────────"; \
			git -C $$roledir status; \
			echo; \
		fi; \
	done

roles-upgrade:
	@echo "\n$(GREEN)*** Upgrading all installed roles ***$(NC)\n"
	@for roledir in ./roles/*; do \
		if [ -d $$roledir ]; then \
			echo "════════════════════════════════════════════════════════════════════════════════"; \
			echo " Upgrading role: $$roledir"; \
			echo "────────────────────────────────────────────────────────────────────────────────"; \
			git -C $$roledir pull; \
			echo; \
		fi; \
	done


#-------------------------------------------------------------------------------


docs: docs-html

docs-clean: FORCE
	@echo "\n$(GREEN)*** Cleaning documentation ***$(NC)\n"
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
