#!/bin/bash

if [ "$1" -eq "rw" ]; then
    echo "Installing default list of roles in read-write mode:"
    echo ""
    make role-install ROLE_URL=git@github.com:honzamach/ansible-role-cleanup.git ROLE_NAME=honzamach.cleanup
	make role-install ROLE_URL=git@github.com:honzamach/ansible-role-commonenv.git ROLE_NAME=honzamach.commonenv
	make role-install ROLE_URL=git@github.com:honzamach/ansible-role-accounts.git ROLE_NAME=honzamach.accounts
	make role-install ROLE_URL=git@github.com:honzamach/ansible-role-timesynced.git ROLE_NAME=honzamach.timesynced
	make role-install ROLE_URL=git@github.com:honzamach/ansible-role-certified.git ROLE_NAME=honzamach.certified
	make role-install ROLE_URL=git@github.com:honzamach/ansible-role-backupped.git ROLE_NAME=honzamach.backupped
	make role-install ROLE_URL=git@github.com:honzamach/ansible-role-logged.git ROLE_NAME=honzamach.logged
	make role-install ROLE_URL=git@github.com:honzamach/ansible-role-monitored.git ROLE_NAME=honzamach.monitored
	make role-install ROLE_URL=git@github.com:honzamach/ansible-role-firewalled.git ROLE_NAME=honzamach.firewalled
	make role-install ROLE_URL=git@github.com:honzamach/ansible-role-shibboleth.git ROLE_NAME=honzamach.shibboleth
	make role-install ROLE_URL=git@github.com:honzamach/ansible-role-postgresql.git ROLE_NAME=honzamach.postgresql
	make role-install ROLE_URL=git@github.com:honzamach/ansible-role-alchemist.git ROLE_NAME=honzamach.alchemist
	make role-install ROLE_URL=git@github.com:honzamach/ansible-role-logserver.git ROLE_NAME=honzamach.logserver
	make role-install ROLE_URL=git@github.com:honzamach/ansible-role-puppeteer.git ROLE_NAME=honzamach.puppeteer
	make role-install ROLE_URL=git@github.com:honzamach/ansible-role-mentat.git ROLE_NAME=honzamach.mentat
	make role-install ROLE_URL=git@github.com:honzamach/ansible-role-mentat-cesnet.git ROLE_NAME=honzamach.mentat_cesnet
	make role-install ROLE_URL=git@github.com:honzamach/ansible-role-mentat-dev.git ROLE_NAME=honzamach.mentat_dev
	make role-install ROLE_URL=git@github.com:honzamach/ansible-role-warden-client.git ROLE_NAME=honzamach.warden_client
	make role-install ROLE_URL=git@github.com:honzamach/ansible-role-util-inspector.git ROLE_NAME=honzamach.util_inspector
else
    echo "Installing default list of roles in read-only mode:"
    echo ""
    make role-install ROLE_URL=https://github.com/honzamach/ansible-role-cleanup.git ROLE_NAME=honzamach.cleanup
	make role-install ROLE_URL=https://github.com/honzamach/ansible-role-commonenv.git ROLE_NAME=honzamach.commonenv
	make role-install ROLE_URL=https://github.com/honzamach/ansible-role-accounts.git ROLE_NAME=honzamach.accounts
	make role-install ROLE_URL=https://github.com/honzamach/ansible-role-timesynced.git ROLE_NAME=honzamach.timesynced
	make role-install ROLE_URL=https://github.com/honzamach/ansible-role-certified.git ROLE_NAME=honzamach.certified
	make role-install ROLE_URL=https://github.com/honzamach/ansible-role-backupped.git ROLE_NAME=honzamach.backupped
	make role-install ROLE_URL=https://github.com/honzamach/ansible-role-logged.git ROLE_NAME=honzamach.logged
	make role-install ROLE_URL=https://github.com/honzamach/ansible-role-monitored.git ROLE_NAME=honzamach.monitored
	make role-install ROLE_URL=https://github.com/honzamach/ansible-role-firewalled.git ROLE_NAME=honzamach.firewalled
	make role-install ROLE_URL=https://github.com/honzamach/ansible-role-shibboleth.git ROLE_NAME=honzamach.shibboleth
	make role-install ROLE_URL=https://github.com/honzamach/ansible-role-postgresql.git ROLE_NAME=honzamach.postgresql
	make role-install ROLE_URL=https://github.com/honzamach/ansible-role-alchemist.git ROLE_NAME=honzamach.alchemist
	make role-install ROLE_URL=https://github.com/honzamach/ansible-role-logserver.git ROLE_NAME=honzamach.logserver
	make role-install ROLE_URL=https://github.com/honzamach/ansible-role-puppeteer.git ROLE_NAME=honzamach.puppeteer
	make role-install ROLE_URL=https://github.com/honzamach/ansible-role-mentat.git ROLE_NAME=honzamach.mentat
	make role-install ROLE_URL=https://github.com/honzamach/ansible-role-mentat-cesnet.git ROLE_NAME=honzamach.mentat_cesnet
	make role-install ROLE_URL=https://github.com/honzamach/ansible-role-mentat-dev.git ROLE_NAME=honzamach.mentat_dev
	make role-install ROLE_URL=https://github.com/honzamach/ansible-role-warden-client.git ROLE_NAME=honzamach.warden_client
	make role-install ROLE_URL=https://github.com/honzamach/ansible-role-util-inspector.git ROLE_NAME=honzamach.util_inspector
fi
