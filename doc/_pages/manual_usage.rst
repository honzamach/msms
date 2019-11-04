.. _section-usage:

Usage
================================================================================


.. _section-usage-prerequisites:

Prerequisites
--------------------------------------------------------------------------------

The only prerequisites for successfull installation and usage are following:

* make
* python3
* python3-venv

Make sure you have all of these installed with command similar to this::

    apt install make python3 python3-venv


.. _section-usage-setup:

Setup fresh host management environment
--------------------------------------------------------------------------------

If you are starting from scratch please follow these instructions to bootstrap
fresh server management environment:

.. code-block::

    # Prepare necessary directories.
    $ mkdir ~/Ansible
    $ cd ~/Ansible

    # Clone the MSMS codebase.
    $ git clone https://github.com/honzamach/msms.git msms-local
    $ cd msms-local

    # Display built-in make help to view available actions.
    $ make help
    # OR
    $ make

    # Setup fresh server management environment.
    $ make msms-setup

    # Activate local Python virtual environment.
    $ . ./venv/bin/activate

    # In case you are interested install default set of Ansible roles.
    $ make roles-install-default

    # Activate server management environment before executing any roles
    $ make msms-on

    # Generate and view documentation locally
    $ make docs


.. _section-usage-management:

Host management
--------------------------------------------------------------------------------

.. note::

    Following example commands all require to be invoked from within the directory
    that the management suite was installed/cloned to.

To manage hosts in your inventory you will call directly the ``ansible-playbook``
utility, although the *MSMS* system may provide some shortcut actions for certain common
tasks (please study built-in help of the main ``Makefile`` for available options).

* Execute all roles across all hosts::

    ansible-playbook playbook_full.yml --ask-vault-pass

* Execute all roles across specific host or group::

    ansible-playbook --limit=servers_monitored playbook_full.yml --ask-vault-pass

* Execute specific role across all hosts::

    # Either use specific role playbook
    ansible-playbook role_accounts.yml --ask-vault-pass

    # Or you may use tags
    ansible-playbook --tags=role-accounts playbook_full.yml --ask-vault-pass

* Execute specific role across specific host or group::

    # Either use specific role playbook
    ansible-playbook --limit=servers_monitored role_accounts.yml --ask-vault-pass

    # Or you may use tags
    ansible-playbook --limit=servers_monitored --tags=role-accounts playbook_full.yml --ask-vault-pass

* Execute only configuration tasks of all roles across all hosts::

    ansible-playbook --tags=configure playbook_full.yml --ask-vault-pass

* Execute only configuration tasks of specific role across specific host or group::

    # Either use specific role playbook
    ansible-playbook --tags=configure --limit=servers_monitored role_accounts.yml --ask-vault-pass

    # Or you may use tags
    ansible-playbook --tags=configure,role-accounts --limit=servers_monitored playbook_full.yml --ask-vault-pass


.. _section-usage-custom-roles:

Creating custom roles
--------------------------------------------------------------------------------

References:

* https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html
* https://galaxy.ansible.com/docs/contributing/importing.html
* https://docs.ansible.com/ansible/latest/reference_appendices/galaxy.html#travis-integrations


Example role: acme::

    01. Create completely empty GitHub repository for your role ansible-role-acme
    02. Implement the role ansible-role-acme
    03. git add -A
    04. git ci -m "Initial commit"
    05. git tag -a v1.0.0 -m "Initial role release"
    06. git remote add origin git@github.com:honzamach/ansible-role-acme.git
    07. git push -u origin master
    08. git push origin v1.0.0
    09. ansible-galaxy import honzamach ansible-role-acme
    10. ansible-galaxy setup travis honzamach ansible-role-acme xxx-travis-token-xxx
    11. ansible-galaxy setup --list
    12. Enable CI for your repository in your TravisCI profile interface
