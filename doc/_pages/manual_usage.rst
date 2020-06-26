.. _section-usage:

Usage
================================================================================


.. _section-usage-prerequisites:

Prerequisites
--------------------------------------------------------------------------------

The only prerequisite for successfull installation is the presence of following
packages on your system:

* make
* python3
* python3-venv

Make sure you have all of these installed with command similar to this::

    apt install make python3 python3-venv


.. _section-usage-installation:

Installation
--------------------------------------------------------------------------------


Setup fresh server management environment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If you are starting from scratch please follow these instructions to bootstrap
fresh **MSMS** installation::

    # Prepare workspace.
    $ mkdir ~/Ansible
    $ cd ~/Ansible

    # Get the MSMS codebase with Git.
    $ git clone https://github.com/honzamach/msms.git msms-local
    $ cd msms-local

    # Display built-in make help to review available commands.
    $ make
    # OR explicitly:
    $ make help

    # Setup fresh server management environment.
    $ make msms-setup

    # Activate server management environment before executing any playbooks.
    $ . ./venv/bin/activate
    $ make msms-on

    # In case you are interested install default set of roles.
    $ make roles-install-default

    # Generate and view documentation locally for your convenience.
    $ make docs

After these steps you should have working **MSMS** installation and you should start
defining your inventory configurations in ``inventory`` directory and its
subdirectories. Follow standard |tool_ansible| practices. Please study official
`documentation <https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html>`__
for more details. To enable collaboration with other system administrators set
up shared remote Git repository and set it as upstream for your local ``inventory``
|tool_git| repository.


Load existing server management environment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Another option is to start working on existing server management environment
created perhaps by one of your coworkers. In that case please follow these
installation instructions::

    # Prepare workspace.
    $ mkdir ~/Ansible
    $ cd ~/Ansible

    # Get the MSMS codebase with Git.
    $ git clone https://github.com/honzamach/msms.git msms-local
    $ cd msms-local

    # Display built-in make help to review available commands.
    $ make
    # OR explicitly:
    $ make help

    # Load existing server environment configurations from shared remote Git repository.
    $ make msms-load META_URL=git_repository_url

    # Activate server management environment before executing any playbooks.
    $ . ./venv/bin/activate
    $ make msms-on

    # Generate and view documentation locally for your convenience.
    $ make docs

After these steps you should have working **MSMS** installation.


.. _section-usage-management:

Server management
--------------------------------------------------------------------------------

.. note::

    Following example commands all require to be invoked from within the directory
    that the **MSMS** management suite was installed/cloned to.

To manage servers in your inventory you will have to call directly the ``ansible-playbook``
utility, although the **MSMS** system may provide some shortcut actions for certain common
tasks (please study the built-in help of the main ``Makefile`` for available options).

Please do NOT forget to activate the virtual environment first::

    $ . ./venv/bin/activate

* Execute all roles across all servers::

    $ ansible-playbook --ask-vault-pass playbook_full.yml

* Execute all roles across specific server or group::

    $ ansible-playbook --ask-vault-pass --limit=servers_monitored playbook_full.yml

* Execute specific role across all servers::

    # Either use specific role playbook
    $ ansible-playbook --ask-vault-pass role_accounts.yml

    # Or you may use tags
    $ ansible-playbook --ask-vault-pass --tags=role-accounts playbook_full.yml

* Execute specific role across specific server or group::

    # Either use specific role playbook
    $ ansible-playbook --ask-vault-pass --limit=servers_monitored role_accounts.yml

    # Or you may use tags
    $ ansible-playbook --ask-vault-pass --limit=servers_monitored --tags=role-accounts playbook_full.yml

* Execute only configuration tasks of all roles across all servers::

    $ ansible-playbook --ask-vault-pass --tags=configure playbook_full.yml

* Execute only configuration tasks of specific role across specific server or group::

    # Either use specific role playbook
    $ ansible-playbook --ask-vault-pass --tags=configure --limit=servers_monitored role_accounts.yml

    # Or you may use tags
    $ ansible-playbook --ask-vault-pass --tags=configure,role-accounts --limit=servers_monitored playbook_full.yml

Please also refer to section :ref:`section-cookbook-general-aliases` for tips how to
save you a lot of typing and make the usage much easier.


.. _section-usage-workflow:

Workflow
--------------------------------------------------------------------------------

This section presumes you have already installed hte **MSMS** system and already
have some server environment configurations in your ``inventory`` directory.

It is still |tool_ansible|, so most of your work should be focused on editing
files in ``inventory`` directory, mostly ``host_*`` and ``group_*`` directories.
Use :ref:`documentation <section-roles>` of installed roles to choose appropriate
:ref:`variable <section-overview-role-customize-variables>` or :ref:`template <section-overview-role-customize-templates>`
customizations to suit your management goals. Use inventory file to quickly assign
roles to your servers.

You may need to install additional existing third-party roles from any |tool_git|
repository::

    $ make role-install ROLE_URL=https://github.com/honzamach/ansible-role-cleanup.git ROLE_NAME=honzamach.cleanup

You may need to create brand new role. For this purpose you can consider using
built-in role :ref:`util_rolecreator <section-role-util-rolecreator>` to quickly
bootstrap recommended directory tree::

    $ make role-create

For more information please refer to section :ref:`section-usage-create-role`.

Should you need to work with secure data like passwords or certificates please use
`ansible-vault <https://docs.ansible.com/ansible/latest/user_guide/vault.html>`__.
You may use following cheat sheet for common vault operations::

    # Create new empty vault file:
    $ ansible-vault create --vault-id msms@prompt inventory/group_vars/all/vault.yml
    $ ansible-vault create --vault-id msms@prompt inventory/host_vars/[server-name]/vault.yml

    # Edit existing vault file:
    $ ansible-vault edit inventory/group_vars/all/vault.yml
    $ ansible-vault edit inventory/host_vars/[server-name]/vault.yml

    # Encrypt existing file (for example certificate):
    $ ansible-vault encrypt --vault-id msms@prompt inventory/host_files/[server_name]/honzamach.certified/host_certs/key.pem

Listed examples use ``msms@prompt`` as recommended common vault ID.

When you are happy with you changes, apply them by running apropriate playbooks.

After that you should commit these changes into ``inventory`` repository and push
them to your shared remote repository, so that they are available to your coworkers::

    # Manual commit using native Git commands:
    $ cd inventory
    $ git add ...
    $ git commit
    $ git push

    # Or use prepared make targets:
    $ make msms-commit  # alias for `cd ./inventory && git add -A && git commit`
    $ make msms-push    # alias for `cd ./inventory && git push origin master`

You should regularly update **MSMS** system and server environment configurations
to always have latest version and changes from your coworkers::

    $ make msms-upgrade

When you are done with your work you should deactivate server management environment::

    $ make msms-off
    $ deactivate

Please also refer to section :ref:`section-cookbook-general-aliases` for tips how to
save you a lot of typing and make the usage much easier.


.. _section-usage-create-role:

Creating custom role
--------------------------------------------------------------------------------

If you want to implement your own custom role please read section :ref:`section-overview-role-design`
first. You should also study following resources and develop your new role accordingly:

* https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse.html
* https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html
* https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html
* https://galaxy.ansible.com/docs/contributing/importing.html
* https://docs.ansible.com/ansible/latest/reference_appendices/galaxy.html#travis-integrations

After your new role is created, you may follow these instructions to quickly publish
it on `GitHub <https://github.com/>`__ and `Ansible Galaxy <https://galaxy.ansible.com/>`__::

    01. Implement the role ansible-role-acme
    02. Create completely empty GitHub repository for your role ansible-role-acme
    03. $ git add -A
    04. $ git ci -m "Initial commit"; git tag -a v1.0.0 -m "Initial role release";
    05. $ git remote add origin git@github.com:[username]/ansible-role-acme.git
    06. $ git push -u origin master; git push origin v1.0.0;
    07. $ ansible-galaxy import [username] ansible-role-acme
    08. $ ansible-galaxy setup travis [username] ansible-role-acme xxx-travis-token-xxx
    09. $ ansible-galaxy setup --list
    10. Enable CI for your repository in your TravisCI profile interface

If you want to quickly bootstrap directory structure for your new role, you may
consider using :ref:`util_rolecreator <section-role-util-rolecreator>`. You can
invoke it by executing::

    $ make role-create
    # Or directly
    $ ansible-playbook --ask-vault-pass role_util_rolecreator.yml
