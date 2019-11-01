#!/bin/bash
###############################################################################
#
# Helper script for installing default set of Ansible roles.
#
###############################################################################

MSMS_ROOT_DIR=`pwd`
MSMS_ROLE_DIR="${MSMS_ROOT_DIR}/inventory/roles"
echo "Role installation directory: ${MSMS_ROLE_DIR}"

#
# Declare list of default roles.
#
declare -a ROLE_LIST=(
	"honzamach/ansible-role-cleanup.git;honzamach.cleanup"
	"honzamach/ansible-role-commonenv.git;honzamach.commonenv"
	"honzamach/ansible-role-accounts.git;honzamach.accounts"
	"honzamach/ansible-role-timesynced.git;honzamach.timesynced"
	"honzamach/ansible-role-certified.git;honzamach.certified"
	"honzamach/ansible-role-backupped.git;honzamach.backupped"
	"honzamach/ansible-role-logged.git;honzamach.logged"
	"honzamach/ansible-role-monitored.git;honzamach.monitored"
	"honzamach/ansible-role-firewalled.git;honzamach.firewalled"
	"honzamach/ansible-role-shibboleth.git;honzamach.shibboleth"
	"honzamach/ansible-role-postgresql.git;honzamach.postgresql"
	"honzamach/ansible-role-alchemist.git;honzamach.alchemist"
	"honzamach/ansible-role-logserver.git;honzamach.logserver"
	"honzamach/ansible-role-puppeteer.git;honzamach.puppeteer"
	"honzamach/ansible-role-mentat.git;honzamach.mentat"
	"honzamach/ansible-role-mentat-cesnet.git;honzamach.mentat_cesnet"
	"honzamach/ansible-role-mentat-dev.git;honzamach.mentat_dev"
	"honzamach/ansible-role-warden-client.git;honzamach.warden_client"
	"honzamach/ansible-role-util-inspector.git;honzamach.util_inspector"
)

#
# Determine the default base URL from which to install roles.
#
if [ "${1}" == "rw" ]; then
	DEFAULT_ROLE_BASE_URL="git@github.com:"
	echo "Installation mode: RW"
else
	DEFAULT_ROLE_BASE_URL="https://github.com/"
	echo "Installation mode: RO"
fi
echo ""

#
# Perform role installation process.
#
for role_spec in "${ROLE_LIST[@]}"
do
	# Split role specification into array:
	# 	array[0]: role path, will be joined with ROLE_BASE_URL (mandatory)
	#   array[1]: name of the role for the server management environment (mandatory)
	#   array[2]: forced custom ROLE_BASE_URL (optional)
	IFS=';' read -r -a role <<< "$role_spec"

	#
	# Determine the role base URL.
	#
	ROLE_BASE_URL="${role[2]:=$DEFAULT_ROLE_BASE_URL}"

	#
	# Install the role only in case it is not already installed to avoid errors.
	#
	if [ ! -d "${MSMS_ROLE_DIR}/${role[1]}" ]; then
		echo "Installing role: ${role[1]} [${MSMS_ROLE_DIR}/${role[1]}]"
		make role-install "ROLE_URL=${ROLE_BASE_URL}${role[0]}" "ROLE_NAME=${role[1]}"
	else
		echo "Role is already installed: ${role[1]} [${MSMS_ROLE_DIR}/${role[1]}]"
	fi
done
echo ""
