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
using vault password files instead of passwords. You may have password stored securelly
on encrypted flash drive on your keychain, plug it into your device and if you ensure it
is always mounted to the same location you may use the ``apbf`` and ``anf`` aliases above::

    # Now this:
    cd /path/to/your/msms/installation/
    . venv/bin/activate
    ansible-playbook --ask-vault-pass role_accounts.yml
    # and now type your super secure password

    # Becomes this:
    cd /path/to/your/msms/installation/
    entervenv
    apbf role_accounts.yml


.. _section-cookbook-general-newserver:

Add new server
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If you want to add new server to your server management environment please follow
these simple steps (example ``your-server.mydomain.com``):

1. Add appropriate record to your ``/home/[username]/.ssh/config`` file::

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


.. _section-cookbook-roles:

Role usage cookbook
--------------------------------------------------------------------------------

.. toctree::
   :maxdepth: 1
   :glob:

   /inventory/roles/*/doc/cookbook*
