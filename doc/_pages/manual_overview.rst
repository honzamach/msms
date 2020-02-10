.. _section-overview:

System overview
================================================================================

This server management system is basically a set of couple of open source tools
and utilities that are preconfigured to work together and neatly packaged together
to provide system administrators with ready to use and easy to extend server
management system.

The main components are following:

* |tool_ansible|

  IT automation tool and heart of the **MSMS**. |tool_ansible| is extremely flexible
  and there are many ways to achieve single goal. It is both strength and weakness,
  because the playbooks can quickly become very chaotic and diferent authors can
  and ussually will choose different approach when solving particular issue. This
  project attempts to pick one option to achieve certain goal and then stick to
  it whenever and wherewer it is reasonable and possible. Hopefully this will
  lead to deterministic organization and better readability and usability.

* |tool_sphinx|

  Documentation builder originally created for Python. It uses `reStructuredText <https://en.wikipedia.org/wiki/ReStructuredText>`__
  as a raw format and it is capable of generating documentation in various formats
  like HTML, epub, PDF, etc. It is used to generate homogenous documentation for
  following areas:

  * Documentation of the **MSMS** system itself (you are reading it now).
  * Documentation of all the installed roles that provide a ``README.rst`` file.
  * Documentation of the managed server inventory.

* |tool_git|

  Distributed version control system. It currently plays following roles:

  * Installation and upgrading of the **MSMS** system itself.
  * Version control of server environment configuration.
  * Installation and upgrading of |tool_ansible| roles.

* |tool_make|

  Simple and easy to use control utility for executing various **MSMS** tasks and actions.


.. _section-overview-architecture:

Architecture
--------------------------------------------------------------------------------

Following image depicts current architecture of **MSMS** system. It is composed of
nested |tool_git| repositories. Outermost repository is the **MSMS** system itself.
It is composed of common utilities and configuration that are independent on
particular server inventory. Into this structure you may plug in some server inventory
configuration structure, which contains configurations specific for your server
environment. It is inside separate |tool_git| repository to enable cooperation of
multiple administrators. And finally part of the server inventory configuration
structure are |tool_ansible| roles, that you are using to actually manage your servers.
There roles are installed in the inventory repository as |tool_git|
`submodules <https://git-scm.com/book/en/v2/Git-Tools-Submodules>`__ to conserve
repository size and enable easy role management with native |tool_git| commands.

.. image:: /doc/_static/msms-overview.svg

Following image depicts expected usage of **MSMS** system. Each administrator is
working from his own workstation. He has his own copy of **MSMS** system and within
he has installed clone of server inventory configurations. Administrators are using shared
Git repository to propagate changes they made to each other. They communicate directly
with managed servers, so the SSH authentication is in place as an additional layer
of protection from someone changing something he is not supposed to change.

.. image:: /doc/_static/msms-usage.svg


.. _section-overview-directory-layout:

Directory layout
--------------------------------------------------------------------------------

As a first step a **MSMS** user should be familiar with the
`official Ansible documentation <http://docs.ansible.com/ansible/index.html>`__
and with the `best practices <http://docs.ansible.com/ansible/playbooks_best_practices.html>`__
section in particular, since this project tries to implement as many sane
recommendations as possible.

The basic directory layout of **MSMS** system uses many `best practice <http://docs.ansible.com/ansible/playbooks_best_practices.html>`__
recomendations with a few additions:

  * **.git**

    |tool_git| repository for the base **MSMS** code and utilities.

  * **bin**

    Custom **MSMS** scripts performing various tasks.

  * **doc**

    Project documentation in various formats, based on |tool_sphinx|. Documentation
    in given format can be generated with |tool_make| utility, see the section
    :ref:`section-overview-utilities`.

  * **inventory**

    |tool_git| repository containing server environment configuration for this particular
    instance. It is intentionally *NOT* installed as a |tool_git| subproject to separate
    core **MSMS** code and utilities from server environment configuration. For more
    information please see the section :ref:`section-overview-inventory`.

  * **venv**

    Virtual Python environment in which local installation of |tool_ansible| and all other
    requirements and dependencies will be installed to prevent from messing up your system.

  * **spool**

    Storage directory for side-effects and artifacts of role execution. Roles may place
    various files for the convenience of the administrator/user here.

  * *ansible.cfg*

    `Configuration file <https://docs.ansible.com/ansible/latest/installation_guide/intro_configuration.html>`__
    for |tool_ansible| installed in local virtual environment. This configuration file
    is customized for **MSMS** directory layout. Search for string ``#--- changed from default ---#``
    to find customized configuration values.

  * *conf.py*

    `Configuration file <http://www.sphinx-doc.org/en/stable/config.html>`__ for
    |tool_sphinx|. For more information on documentation generation and documentation
    in general please see the section :ref:`section-overview-documentation`.

  * *documentation.rst*

    Documentation index file for |tool_sphinx|. For more information on documentation
    generation and documentation in general please see the section :ref:`section-overview-documentation`.

  * *Makefile*

    Master makefile and task/action launcher. You will use it for a wide range of tasks
    like upgrading, role installation or documentation generation. For more information
    please see the section :ref:`section-overview-utilities`.

  * *README.rst*

    Master README file with quick system overview, displayed by default on `GitHub <https://github.com/honzamach/msms>`__.


After activation of the **MSMS** system following files may/will appear in its root
directory:

  * **roles**

    At the time of writing this there is something broken with the |tool_ansible| configuration
    ``roles_path``. It would be awesome to point local |tool_ansible| to ``./inventory/roles``
    directory, but sadly it currently does not work. This is a symlink to work around this
    problem.

  * *playbook_....yml*

    Various playbooks installed from server environment configuration. They will appear in
    root directory after the **MSMS** system is enabled. For more information please see the
    section :ref:`section-overview-playbooks`.

  * *role_....yml*

    Playbooks executing only single role installed from server environment configuration.
    They will appear in root directory after the **MSMS** system is enabled. For more
    information please see the section :ref:`section-overview-playbooks`.

  * *task_....yml*

    Playbooks implementing simple tasks without the use of |tool_ansible| roles. They
    will appear in root directory after the **MSMS** system is enabled. For more
    information please see the section :ref:`section-overview-playbooks`.


.. _section-overview-inventory:

Inventory
--------------------------------------------------------------------------------

Inventory files are located in ``inventory`` subdirectory and they represent configuration
for specific server environment. They are all contained within different |tool_git|
repository, which is intentionally *NOT* installed as a submodule of the master **MSMS**
repository. The idea is to separate **MSMS** toolkit from custom inventory specific
configurations. So although the ``inventory`` directory is contained within the **MSMS**
root directory, it is removed from versioning with main ``.gitignore`` file. You
may think of it as being installed as a loose plugin.

There are following key subdirectories/components you can use to define your particular
server management environment. Some of them are defined by |tool_ansible| specification
and some of them are custom and roles must/may explicitly honor them:

  * **docs**

    Auto-generated internal documentation for the inventory servers. Most of the files
    in this directory are produced by the role :ref:`util_inspector <section-role-util-inspector>`.

  * **group_files**

    Group inventory files. Similar mechanism to **group_vars**. Files placed on certain locations
    in this directory can be used to override default role template files. This feature
    is custom and support must be explicitly implemented by the particular role. Fow more
    information please see the section :ref:`section-overview-role-customize-templates`.

  * **group_vars**

    Group inventory variables, see the `Ansible docs <http://docs.ansible.com/ansible/intro_inventory.html#group-variables>`__ for details.

  * **host_files**

    Host inventory files. Similar mechanism to **host_vars**. Files placed on certain locations
    in this directory can be used to override default role template files. This feature
    is custom and support must be explicitly implemented by the particular role. Fow more
    information  please see the section :ref:`section-overview-role-customize-templates`.

  * **host_vars**

    Host inventory variables, see the `Ansible docs <http://docs.ansible.com/ansible/intro_inventory.html#host-variables>`__ for details.

  * **playbooks**

    Directory containing custom inventory playbooks. These playbooks will be installed to
    the **MSMS** root directory.

  * **roles**

    Directory containing all locally installed roles for this server management environment.
    These roles are installed as |tool_git| submodules to conserve space consumed by the config
    repository and to enable easy role management with native |tool_git| commands.

  * **user_files**

    User inventory files. Some roles use files in this directory to enable customizations
    of some aspects of target servers separately for each user. This feature is custom and
    support must be explicitly implemented by the particular role.

  * *hosts*

    Master inventory file, see the `Ansible docs <http://docs.ansible.com/ansible/intro_inventory.html#inventory>`__
    for details. There is currently only one inventory file called *hosts* which contains
    the descriptions for all servers managed by this particular instance of **MSMS**. It is
    not necessary to provide path to this file with |tool_ansible| ``-i|--inventory``
    option, because local installation is preconfigured for this file path. Also it is
    technically possible to use multiple host inventory files, but it was not yet
    needed, so this feature is not yet thoroughly tested and may produce unknown or
    unexpected results.

The design of the inventory *hosts* file is fairly simple. All managed servers must be
in the group ``servers``.

Additionally, there is a separate group for each one of the roles. The group name is
generated by concatenating string ``servers_`` with the name of the role. Again, this
is hardcoded feature and each role is hardcoded to work only with specific group.

This approach has the advantage that you can clearly define and/or see, which role will
be applied to which server and you can control this feature only within the inventory file
and outside of the code of the role itself. For more information please see section
:ref:`section-overview-role-design`.

There are also following special groups in default ``inventory/hosts`` file:

  * ``servers_production``
  * ``servers_testing``
  * ``servers_production``

Each managed server should be assigned into one of these groups. The ``msms_server_type``
variable will then be set to one of the values ``['production', 'testing', 'development']``.
Some of the built-in roles then use this information to tweak tasks that are executed on remote
servers.


.. _section-overview-role-design:

Role design
--------------------------------------------------------------------------------

Each built-in role was developed according to the Ansible `best practice <http://docs.ansible.com/ansible/playbooks_best_practices.html>`__
recommendations with addition of a few extra features. Description of the contents of the
role subdirectories can be found in the Ansible `documentation <https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html>`__.

Each built-in role comes with ready to use playbook and is hardcoded to use specific
inventory group. The group name is generated by concatenating string ``servers_``
with the name of the role. For example role :ref:`accounts <section-role-accounts>`
is hardcoded to work with ``servers_accounts`` inventory group. This approach enables
full and simple inventory file based control of which roles are applied to which servers.
From within the role it is also very easy to determine what other roles are applied to
a particular server, which enables using soft role dependency mechanism.

Each role is tagged with the same tag as the role name. This enables for example
following use case (following statements are equal)::

    # Execute only 'accounts' role on appropriate inventory servers.
    ansible-playbook role_accounts.yml
    ansible playbook --tags=role-accounts playbook_full.yml

Every variable, that is used inside the role is prefixed with following string
pattern:

``[author_initials]_[role_name]__``

The ``author_initials`` are initials of the author of the role, to prevent from name collisions
and the ``role_name`` is simply the name of the role. For example all variables in
:ref:`accounts <section-role-accounts>` role are prefixed with ``hm_accounts__`` string. This approach
means, that all variable names will be long and ugly as hell, but a big advantage is
simple namespacing, name collision avoidance and it is always clear to which role certain
variable belongs (especially when some roles use variables defined in different role).

Each role is designed in a way that the tasks for different systems (Debian, CentOS, ...)
are in separate files. The **main.yml** file in **tasks** folder contains a switch,
that will conditionally include tasks appropriate for the respective system.

All tasks within each role are tagged either with **install** or with **configure** tag.
So it is possible to execute the playbook more efficiently in respect to the changes
that need to be done on target system::

    # Full playbooks, run only at the first time
    ansible playbook playbook_full.yml

    # Later apply only configuration changes
    ansible playbook --tags=configure playbook_full.yml

When developing new custom roles please refer to the section :ref:`section-usage-create-role`.

Key concept for all built-in roles is, that they are never used like functions.
Some role authors prefer to design parametrized roles, that can be executed multiple
times with diferent parameters. For example role can create work environment for
single user and may be executed multiple times with different user name as parameters.
The roles in **MSMS** suite are instead designed as feature containers. For example there is a
role :ref:`monitored <section-role-monitored>` that is responsible for deploying
Nagios monitoring on all servers it is applied to. In cases function-like mechanism
was needed the parametrized `include <https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_includes.html>`__
mechanism was used instead.


.. _section-overview-role-soft-dependencies:

Role soft dependencies
--------------------------------------------------------------------------------

Concepts mentioned in section :ref:`section-overview-role-design` enable role designers
to use soft role dependency mechanism. |tool_ansible| provide hard role dependencies
via ``dependencies`` subkey in ``meta/main.yml`` configuration file of a role. When
utilized, all role dependencies are pulled in and executed prior to executing tasks of
the parent role. However sometimes it may be usefull to use soft dependency mechanism.
For example a role may execute some additional tasks based on the fact that some other
role is also applied to a certain server. For example role :ref:`postgresql <section-role-postgresql>`
installs some additional Nagios NRPE monitoring commands in case the server is also
monitored with the :ref:`monitored <section-role-monitored>` role.

|tool_ansible| provides following built-in variable that enables this soft dependency
mechanism:

.. envvar:: group_names

    List of group names current host is member of.


.. _section-overview-role-customize-templates:

Role template customizations
--------------------------------------------------------------------------------

Some roles are implemented in a way that supports customization of template files
without the need of modification of the original template file within the role
directory.

This feature is similar to the variable overriding feature of |tool_ansible| itself.
There are three subdirectories with special meaning in **MSMS** ``inventory`` directory:

  * **group_files**
  * **host_files**
  * **user_files**

They work similarly to the **group_vars** and **host_vars** directories. They may
contain subdirectories with the names matching inventory hostnames or inventory groups.
These in turn contain subdirectories with the names matching the name of the role
being cutomized and these may then contain override template files.

Please consider following example::

    (venv) $ ll inventory/host_files/server-name/honzamach.commonenv/
    total 20
    drwxr-xr-x 2 mek mek 4096 Oct 18 15:44 ./
    drwxr-xr-x 6 mek mek 4096 Oct 18 15:44 ../
    -rw-r--r-- 1 mek mek 1264 Oct 18 10:00 system-banner.j2

In this example the ``system-banner.j2`` template file from the role :ref:`commonenv <section-role-commonenv>`
is overridden with different custom version.

Unless stated otherwise standard lookup paths for template files within the role
are the following:

  * ``inventory/host_files/{{ inventory_hostname }}/[role_name]/[file_name].j2``
  * ``inventory/group_files/servers_{{ msms_server_type }}/[role_name]/[file_name].{{ ansible_lsb['codename'] }}.j2``
  * ``inventory/group_files/servers_{{ msms_server_type }}/[role_name]/[file_name].j2``
  * ``inventory/group_files/servers/[role_name]/[file_name].{{ ansible_lsb['codename'] }}.j2``
  * ``inventory/group_files/servers/[role_name]/[file_name].j2``
  * ``[file_name].{{ ansible_lsb['codename'] }}.j2``
  * ``[file_name].j2``

As you can see custom template files can reside in directories parametrized by
various |tool_ansible| built-in variables:

.. envvar:: inventory_hostname

    Name of the current server.

.. envvar:: msms_server_type

    Type of the server, see section :ref:`section-overview-inventory` (custom).

.. envvar:: ansible_lsb['codename']``

    Linux distribution codename.

Some roles may however limit the list of lookup paths for some reason, for example
some options may not make sense for certain role. When you need to customize
a template of a role, please search for the template file name in ``tasks`` subdirectory
of the role and check available options.


.. _section-overview-role-customize-variables:

Role variable customizations
--------------------------------------------------------------------------------

All built-in roles define variables in ``defaults/main.yml`` configuration file,
so it is possible to override default values by all standard options provided
by |tool_ansible|. Because there are so many, it is recommended to be conservative
and use only ``*_vars`` files:

  * **inventory/group_vars/[group_name]/vars.yml**
  * **inventory/host_vars/[host_name]/vars.yml**


.. _section-overview-secure-registry:

Secure registry
--------------------------------------------------------------------------------

There are certain variables that are expected to exist during each play that
contain databases of mostly account related information. These variables are loaded
from ``inventory/group_vars/all/users.yml`` and ``inventory/group_vars/all/hosts.yml``
configuration files.

.. envvar:: site_users

    This is one of the most important configuration variables. It is in fact simple
    JSON database of all known user accounts and their personal data. In respect
    of datatype, it must be ``dictionary of dictionaries`` with following structure::

        site_users:
            user:
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

.. envvar:: site_hosts

    Similarly to the :envvar:`site_users` variable it is simple JSON database of
    all known site hosts. In respect of datatype, it must be ``dictionary of dictionaries``
    with following structure::

        site_hosts:
            hostname:
                ssh_keys:
                    - "ssh-dss AAAA..."

.. envvar:: server_vars

    This configuration should contain sensitive variables for particular servers,
    that must be hidden (passwords etc.)::

        server_vars:
            hostname:
                ds_server: ssh.backup.com
                ds_account: ds_hostname
                ds_password: something-very-secret

These variables are used when necessary within all built-in roles to provide easier
definitions of server users. For example the role :ref:`accounts <section-role-accounts>`
defines simple variable :envvar:`hm_accounts__admins` that is a simple list of user account
identifiers, that point to the records in :envvar:`site_users` database.


.. _section-overview-vault:

Vault
--------------------------------------------------------------------------------

|tool_ansible| provides `vault <https://docs.ansible.com/ansible/latest/user_guide/vault.html>`__
feature as a secure storage for highly sensitive data like passwords and certificates.

You may use following cheat sheet for common vault operations::

    # Create new empty vault file:
    $ ansible-vault create --vault-id msms@prompt inventory/group_vars/all/vault.yml

    # Edit existing vault file:
    $ ansible-vault edit inventory/group_vars/all/vault.yml

    # Encrypt existing file (for example certificate):
    $ ansible-vault encrypt --vault-id msms@prompt inventory/host_files/[server_name]/honzamach.certified/host_certs/key.pem

Listed examples use ``msms@prompt`` as recommended common vault ID.


.. _section-overview-playbooks:

Playbooks
--------------------------------------------------------------------------------


Master playbook - playbook_full.yml
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
This master playbook includes in correct order all of role playbooks and thus
performs full site management. Execution of all roles can be very slow, for quick
updates it is better to use appropriate role playbook or limit the inventory hosts.


Role playbooks
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

These playbooks execute only single role and they are all those files named like
``role_*.yml``. They are very usefull for quick fixes and updates in which case
the whole site master playbook would take too long, or in cases of minor changes.
Playbook names should be descriptive enough, see the section :ref:`section-roles`
for further documentation for particular roles.


Task playbooks
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

These playbooks implement some minor tasks without the use of roles and they are
all those files named like ``task_*.yml``.


.. _section-overview-documentation:

Built-in documentation
--------------------------------------------------------------------------------

Big part of the **MSMS** system is a built-in documentation. This documentation does
not cover only the **MSMS** system itself (overview, usage manual, ...) and all
the roles, but it is intended to serve administrators also as an inventory
documentation.

.. image:: /doc/_static/msms-documentation.svg

There is a very useful role :ref:`util_inspector <section-role-util-inspector>`,
which is capable of inspecting the whole inventory and generating documentation
pages. You may use it like this::

    $ ansible-playbook role_util_inspector.yml
    $ make docs


.. _section-overview-utilities:

Utilities
--------------------------------------------------------------------------------

.. _section-overview-utilities-make:

make
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Project root directory contains makefile which serves as a single point of control
for (almost) all **MSMS** features. Please use built-in help to view all currently
available actions::

    $ make
    # or explicitly
    $ make help
