.. _section-overview:

System overview
================================================================================


The whole server management system is bases on the `Ansible <https://www.ansible.com/>`__
IT automation tool. Ansible is extremely flexible and there are many ways to
archieve single goal. It is both strength and weakness, because the playbooks can
quickly become very chaotic. This project attempts to pick one option to achieve
certain goal and then stick to it whenever and wherewer it is reasonable and possible. 
Hopefully this will lead to deterministic organization and better readability and 
usability.

As a first step user should be familiar with the
`official Ansible documentation <http://docs.ansible.com/ansible/index.html>`__
and with the `best practices <http://docs.ansible.com/ansible/playbooks_best_practices.html>`__
section in particular, since this project tries to implement as many sane
recommendations as possible.


.. _section-overview-directory-layout:

Directory layout
--------------------------------------------------------------------------------


The basic directory layout of MSMS system uses many `best practice <http://docs.ansible.com/ansible/playbooks_best_practices.html>`__
recomendations with a few additions:

  * **.git**

    Git repository for the base MSMS code and utilities.

  * **bin**

    Custom scripts performing various tasks.

  * **doc**

    Project documentation in various formats, based on `Sphinx <http://www.sphinx-doc.org/en/stable/>`__.
    Documentation in given format can be generated with ``make`` utility, see the
    section :ref:`section-overview-utilities`.

  * **inventory**

    Git repository containing server management environment for this particular instance.
    It is intentionally NOT installed as a Git suproject to separate core MSMS code
    and utilities from server management environment configuration. For more information 
    please see the section :ref:`section-overview-inventory`.

  * **venv**

    Virtual Python environment in which local installation of Ansible and all other
    requirements will be.

  * **spool**

    Storage directory for side-effects and artifacts of role execution. Roles may place
    various files for the convenience of the administrator here.

  * *conf.py*

    `Sphinx <http://www.sphinx-doc.org/en/stable/>`__ documentation generator
    `configuration file <http://www.sphinx-doc.org/en/stable/config.html>`__.
    For more information on documentation generation and documentation in general
    please see the section :ref:`section-overview-documentation`.

  * *Makefile*

    Master makefile and task/action launcher. You will use it for a wide range of tasks
    like upgrading, role installation or documentation generation. For more information 
    please see the section :ref:`section-overview-utilities`.

  * *documentation.rst*

    `Sphinx <http://www.sphinx-doc.org/en/stable/>`__ documentation root file.
    For more information on documentation generation and documentation in general
    please see the section :ref:`section-overview-documentation`.

  * *playbook_full.yml*

    Master playbook performing all roles on all inventory hosts. It will appear in root
    directory after the MSMS system is enabled. For more information please see the section
    :ref:`section-overview-playbooks`.

  * *role_...*

    Playbooks executing only single role. They will appear in root directory after the 
    MSMS system is enabled. For more information please see the section
    :ref:`section-overview-playbooks`.

  * *task_...*

    Playbooks implementing simple tasks without the use of Ansible roles, see the
    section :ref:`section-overview-playbooks` for details.


.. _section-overview-inventory:

Inventory
--------------------------------------------------------------------------------

Inventory files are located in **inventory** subdirectory. They are all contained
within different Git repository, which is intentionally not installed as submodule
of the master MSMS Git repository. The idea is to separate MSMS toolkit from custom
local inventory specific configurations.

There are following key components:

  * **docs**

    Auto-generated internal documentation for the inventory hosts.

  * **group_files**

    Group files. Similar to **group_vars**, but these can be used to override
    certain template files. This feature must be supported by the particular role.
    Fow more information see the section :ref:`section-overview-customize-templates` below.

  * **group_vars**

    Group variables, see the `Ansible docs <http://docs.ansible.com/ansible/intro_inventory.html#group-variables>`__ for details.

  * **host_files**

    Host files. Similar to **host_vars**, but these can be used to override
    certain template files. This feature must be supported by the particular role.
    Fow more information see the section :ref:`section-overview-customize-templates` below.

  * **host_vars**

    Host variables, see the `Ansible docs <http://docs.ansible.com/ansible/intro_inventory.html#host-variables>`__ for details.

  * **playbooks**

    Directory containing custom playbooks.

  * **roles**

    Directory containing all locally installed roles for this server management environment.
    These roles are installed as Git submodules to conserve space consumed by the config
    repository. 

  * *hosts*

    Inventory file, see the `Ansible docs <http://docs.ansible.com/ansible/intro_inventory.html#inventory>`__ for details.

There is currently only one inventory file called *hosts* which contains the
descriptions for all servers.

The design of the inventory file is fairly simple. All managed servers must be in
the group ``servers``.

Additionally, there is a separate group for each one of the roles. The group name is
generated by concatenating string ``servers_`` with the name of the role. Again, this
is hardcoded feature and each role is hadcoded to work only with specific group.

This approach has the advantage that you can clearly state and/or see, which roles will
be applied to which hosts and you can control this feature within the inventory file 
and outside of the code of the role itself.


.. _section-overview-role-design:

Role design
--------------------------------------------------------------------------------

Each role was developed according to the Ansible `best practice <http://docs.ansible.com/ansible/playbooks_best_practices.html>`__
with addition of few extra features. Description of the contents of the
role subdirectories can be found in the Ansible docs.

Each role is hardcoded to use specific inventory group. The group name is
generated by concatenating string ``servers_`` with the name of the role. For
example role :ref:`accounts <section-role-accounts>` is hardcoded to work with ``servers_accounts``
inventory group. This approach enables full and simple inventory file based control
of which roles are applied to which hosts.

Additionally each role is tagged with the same tag as the role name. This enables
for example following use case (following statements are equal)::

    # Execute only base-accounts role on appropriate inventory hosts
    ansible-playbook role_accounts.yml
    ansible playbook --tags=role-accounts playbook_full.yml

Every variable, that is used inside the role is prefixed with following string
pattern:

``[authors_initials]_[role_name]__``

The ``authors_initials`` are initials of the author of the role, to prevent from name collisions
and the ``role_name`` is simply the name of the role. For example all variables in
:ref:`accounts <section-role-accounts>` role are prefixed with ``hm_accounts__`` string. This approach
means, that all variable names will be long and ugly as hell, but the advantage is
simple namespacing, collision avoidance and it is always clear to which role certain
variable belongs (especially when some roles use variables defined in different role).

Each role is designed in a way that the tasks for different systems (Debian, CentOS, ...)
are in separate files. The **main.yml** file in **tasks** folder contains the
switch, that will conditionally include tasks apprriate for the respective system.

All tasks within each role are tagged either with **install** or with **configure** tag.
So it is possible to execute the playbook more efficiently in respect to the changes
that need to be done on target system::

    # Full playbooks, run only at the first time
    ansible playbook playbook_full.yml

    # Later apply only configuration changes
    ansible playbook --tags=configure playbook_site.yml

When developing new custom roles please refer to the :ref:`section-usage-custom-roles`.


.. _section-overview-secure-registry:

Secure registry
--------------------------------------------------------------------------------

There are certain variables that are expected to exist during each play that
contain databases of mostly account related information. These variables are loaded
from *inventory/group_vars/all/users.yml* and *inventory/group_vars/all/hosts.yml* 
configuration files.

.. envvar:: site_users

    This is one of the most important configuration variables. It is in fact simple
    JSON database of all known user accounts and their personal data. In respect
    of datatype, it must be ``dictionary of dictionaries`` with following structure::

        site_users:
            mach:
                uid: mach
                name: Jan Mach
                firstname: Jan
                lastname: Mach
                email: jan.mach@cesnet.cz
                ssh_keys:
                    - "ssh-rsa AAAA..."
                    - "ssh-rsa AAAA..."
                workstations:
                    - "192.168.1.1"
                    - "::1"

.. envvar:: site_hosts

    Similarly to the :envvar:`site_users` variable it is simple JSON database of
    all known site hosts. In respect of datatype, it must be ``dictionary of dictionaries``
    with following structure::

        site_hosts:
            site_hosts:
                "hostname":
                    hid: hostname
                    ssh_keys:
                        - "ssh-dss AAAA..."

.. envvar:: server_vars

    This configuration should contain sensitive variables for particular servers,
    that must be hidden (passwords etc.)::

        server_vars:
            "hostname":
                du_server: ssh.du1.cesnet.cz
                du_account: du_mentat
                du_password: quaJ5feiChai6sojo0qu


.. _section-overview-playbooks:

Playbooks
--------------------------------------------------------------------------------


Master playbook - playbook_full.yml
````````````````````````````````````````````````````````````````````````````````

This master playbook includes in correct order all of role playbooks and thus 
performs full site management. Execution of all roles can be very slow, for quick 
updates it is better to use appropriate role playbook or limit the inventory hosts.


Role playbooks
````````````````````````````````````````````````````````````````````````````````

These playbooks execute only single role. They are very usefull for quick fixes
and updates in which case the whole site master playbook would take too long, or
in cases of minor changes. Playbook names should be descriptive enough, see the
section :ref:`section-roles` for further documentation for particular roles.


Task playbooks
````````````````````````````````````````````````````````````````````````````````

These playbooks implement some minor tasks without the use of roles.


.. _section-overview-customize-templates:

Template customizations
--------------------------------------------------------------------------------

Some roles are implemented in a way that supports customization of template files
without the need of modification original template file within the role directory.

This feature is simillar to the variable overriding feature of Ansible itself.
There are two subdirectories in project root directory:

  * **inventory/group_files**
  * **inventory/host_files**

They work similarly to the **inventory/group_vars** and **inventory/host_vars** 
directories. They may contain subdirectories with the names matching inventory 
hostnames or inventory groups and they may contain override template files.


.. _section-overview-documentation:

Built-in documentation
--------------------------------------------------------------------------------

Big part of the MSMS system is a built-in documentation. This documentation does
not cover only the MSMS system itself (overview, usage manual, ...), but it is
intended to serve administrators also as an inventory documentation. 

There is a very useful role :ref:`util_inspector <section-role-util-inspector>`,
which is capable of inspecting the whole inventory and generating documentation
pages. You may use it like this::

    $ ansible-playbook role_util_inspector.yml
    $ make docs-view


.. _section-overview-utilities:

Utilities
--------------------------------------------------------------------------------


make
````````````````````````````````````````````````````````````````````````````````

Project root directory contains makefile which serves as a single point of control
for all MSMS features::

    $ make help
