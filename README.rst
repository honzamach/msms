.. _section-readme:

MSMS
================================================================================

Usage
--------------------------------------------------------------------------------

Create fresh server management environment from scratch::

	$ mkdir ~/Ansible
	$ cd ~/Ansible
	$ git clone https://github.com/honzamach/msms.git msms-local
	$ cd msms-local
	$ make msms-setup

Load existing server management environment::

	$ mkdir ~/Ansible
	$ cd ~/Ansible
	$ git clone https://github.com/honzamach/msms.git msms-local
	$ cd msms-local
	$ make msms-load META_URL=git_repository_url
	$ make msms-on

Install new role::

	$ make role-install ROLE_URL=https://github.com/honzamach/ansible-role-cleanup.git ROLE_NAME=honzamach.cleanup
	$ make roles-on
