#!/bin/bash
MSMS_ROOT_DIR="${1}"
MSMS_ROOT_DIR="${MSMS_ROOT_DIR:=`pwd`}"
echo "Root directory for inventory: ${MSMS_ROOT_DIR}"

#
# Create inventory directory structure.
#
if [ ! -d "${MSMS_ROOT_DIR}/inventory" ]; then 
	mkdir -p "${MSMS_ROOT_DIR}/inventory"
fi
for subdir in docs group_files group_vars host_files host_vars playbooks roles user_files; do
	if [ ! -d "${MSMS_ROOT_DIR}/inventory/${subdir}" ]; then
		mkdir -p "${MSMS_ROOT_DIR}/inventory/${subdir}"
	fi
done

#
# Create inventory Git repository.
#
if [ ! -d "${MSMS_ROOT_DIR}/inventory/.git" ]; then 
	git init "${MSMS_ROOT_DIR}/inventory"
fi

#
# Setup example '.gitignore' file.
#
if [ ! -f "${MSMS_ROOT_DIR}/inventory/.gitignore" ]; then
	tee -a "${MSMS_ROOT_DIR}/inventory/.gitignore" > /dev/null <<EOT
!.gitignore
.directory
*~
*.log
*.retry
*.tmp
section_99_envdump.rst
envdump/detail_*.rst

EOT
fi

#
# Setup example 'hosts' file.
#
if [ ! -f "${MSMS_ROOT_DIR}/inventory/hosts" ]; then
	tee -a "${MSMS_ROOT_DIR}/inventory/hosts" > /dev/null <<EOT
#*******************************************************************************
#
# MASTER INVENTORY FILE
#
#*******************************************************************************

#===============================================================================
# LIST OF ALL KNOWN HOSTS
#===============================================================================

[servers]

[servers_production]

[servers_testing]

[servers_development]

#-------------------------------------------------------------------------------

[servers_production:vars]
msms_server_type=production

[servers_testing:vars]
msms_server_type=testing

[servers_development:vars]
msms_server_type=development

#===============================================================================
# ROLE RELATED GROUPS
#===============================================================================

[servers_cleanup:children]
servers

[servers_commonenv:children]
servers

[servers_accounts:children]
servers

[servers_timesynced:children]
servers

[servers_certified]

[servers_backupped]

[servers_logged]

[servers_monitored]

[servers_firewalled]

[servers_shibboleth]

[servers_postgresql]

#-------------------------------------------------------------------------------

[servers_alchemist]

[servers_logserver]

[servers_puppeteer]

[servers_mentat]

[servers_mentat_cesnet]

[servers_mentat_dev]

[servers_warden_client]

#===============================================================================
# Specifics
#===============================================================================

[server_central_logserver]

EOT
fi
