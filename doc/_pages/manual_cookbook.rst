.. _section-cookbook:

Cookbook
================================================================================


.. _section-cookbook-general:

General usage cookbook
--------------------------------------------------------------------------------


.. _section-cookbook-general-aliases:

Command alias recommendations
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To make your life much, much easier you should consider adding following command
aliases to your ``.bashrc`` configuration file::

    # Simplify activation of virtual environment:
    alias entervenv='. venv/bin/activate'

    # Shorten ansible-playbook calls with explicit vault password prompt:
    alias apbv='ansible-playbook --ask-vault-pass'

    # Shorten ansible-playbook calls with path to vault password file:
    alias apbf='ansible-playbook --vault-password-file /media/user/Strongbox/ansible/vault.key'

    # Same as above, but use ``check`` adn ``diff`` command line options to perform dry runs:
    alias apbp-check='ansible-playbook --ask-vault-pass --check --diff'
    alias apbf-check='ansible-playbook --vault-password-file /media/user/Strongbox/ansible/vault.key --check --diff'

    # Same as above, but for executing ad-hoc commands:
    alias anp='ansible --ask-vault-pass'
    alias anf='ansible --vault-password-file /media/user/Strongbox/ansible/vault.key'
    alias anp-check='ansible --ask-vault-pass --check --diff'
    alias anf-check='ansible --vault-password-file /media/user/Strongbox/ansible/vault.key --check --diff'

Meaning of all the aliases is hopefully evident. They are all designed to save you a lot
of typing that would be otherwise needed due to the use of the vaults. Very neat trick is
using vault password files instead of passwords. You may have password stored securely
on encrypted flash drive on your keychain, plug it into your device and if you ensure it
is always mounted to the same location, you may then use the ``apbf`` and ``anf`` aliases above::

    # So now this:
    cd /path/to/your/msms/installation/
    . venv/bin/activate
    ansible-playbook --ask-vault-pass role_accounts.yml
    # and now type your super secure password

    # Becomes this and you do not have to type vault password over and over again:
    cd /path/to/your/msms/installation/
    entervenv
    apbf role_accounts.yml


.. _section-cookbook-general-adhoc:

Usefull ad-hoc commands
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Consider using ad-hoc command capabilities for executing commands on all your servers::

    # List expiration dates of all server certificates:
    $ anf servers -a "openssl x509 -in /etc/ssl/servercert/cert.pem -noout -issuer -subject -dates"

    # Check whether anything anywhere needs to be restarted:
    $ anf servers -a "checkrestart"

    # Clear APT caches:
    $ anf servers -m apt -a "autoclean=true"
    $ anf servers -m apt -a "autoremove=true"


.. _section-cookbook-general-newserver:

Add new server
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If you want to add new server to your server management environment please follow
these simple steps (example ``your-server.mydomain.com``):

1. Add appropriate record to your ``/home/[username]/.ssh/config`` file, so that
   you can use just ``ssh your-server`` to connect to it::

    Host your-server
        HostName your-server.mydomain.com
        User root
        ServerAliveInterval 30
        ServerAliveCountMax 120

2. In ``inventory/hosts`` file add ``your-server`` to ``[servers]`` group and to
   one of ``[servers_production], [servers_development], [servers_testing]`` groups
   depending on the type of the server. Then also to any other groups depending on
   what roles you wish to apply to ``your-server``.

3. Create file ``inventory/host_vars/your-server/vars.yml`` and override any role
   default values that do not fit your requirements. Optionally create vault file
   ``inventory/host_vars/your-server/vault.yml`` and place inside any secrets. Use
   `best practice <https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html#variables-and-vaults>`__
   recommendations.

4. Use directory ``inventory/host_files/your-server/`` to customize role templates
   if necessary (refer to section :ref:`section-overview-role-customize-templates`
   for more details).

5. Apply the roles to ``your-server`` either by executing all relevant single role
   playbooks, or by executing the full playbook. Consider using the ``--limit`` option
   to speedup the process::

     apbf role_commonenv.yml --limit your-server
     apbf role_accounts.yml --limit your-server

     apbf playbook_full.yml --limit your-server



.. _section-cookbook-general-newuser:

Add new user
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If you want to add a brand new user to your server management environment please follow
these simple steps:

1. Add appropriate record to file ``inventory/group_vars/all/users.yml``, subkey
   :envvar:`site_users`::

        site_users:
            userid:
                name: User Name
                name_utf: Úšěř Ňámé
                firstname: User
                lastname: Name
                email: user.name@domain.org
                ssh_keys:
                    - "ssh-rsa AAAA..."
                    - "ssh-rsa AAAA..."
                workstations:
                    - "192.168.1.1"
                    - "::1"
            ...

2. Now use role :ref:`accounts <section-role-accounts>` to enable the user acces to appropriate
   systems. You may use ``inventory/group_vars/all/vars.yml`` file to define global
   defaults for all servers and/or ``inventory/host_vars/[server-name]/vars.yml``
   to fine tune the configuration for particular hosts. In any case, you will
   probably use either :envvar:`hm_accounts__admins` to grant administrator access,
   or :envvar:`hm_accounts__users` to grant unprivileged access.

The :envvar:`site_users` dictionary is acting as a registry, which allows you to
define users along with all their metadata at a single place. All roles then have
access to all that data and you can just point out the users they should take into
account.

Please refer to section :ref:`section-role-accounts` for more details.


.. _section-cookbook-roles:

Role usage cookbook
--------------------------------------------------------------------------------

.. toctree::
   :maxdepth: 1
   :glob:

   /inventory/roles/*/doc/cookbook*
