.. _section-overview:

System overview
================================================================================

This server management system is basically a set of couple of open source tools 
and utilities that are configured to work together to provide system administrators
with ready to use and easy to extend server management system:

The main components are following:

* |tool_ansible|

  IT automation tool and heart of the *MSMS*. |tool_ansible| is extremely flexible 
  and there are many ways to achieve single goal. It is both strength and weakness, 
  because the playbooks can quickly become very chaotic and diferent authors can
  and ussually will choose different approach when solving particular issue. This 
  project attempts to pick one option to achieve certain goal and then stick to 
  it whenever and wherewer it is reasonable and possible. Hopefully this will 
  lead to deterministic organization and better readability and usability.

* |tool_sphinx|

  Documentation builder originally created for Python. It uses `reStructuredText <https://en.wikipedia.org/wiki/ReStructuredText>`__
  as a file format and is capable of generating documentation in various formats
  like HTML, epub, PDF, etc. It is used to generate homogenous documentation for
  following:

  * Documentation of the *MSMS* system itself (you are reading it now).
  * Documentation of all the roles that provide a ``README.rst`` file.
  * Documentation of the host inventory

* |tool_git|

  Distributed version control system plays following roles:

  * Installation and upgrading of the *MSMS* system itself.
  * Version control of server environment configuration.
  * Installation and upgrading of |tool_ansible| roles.

* |tool_make|

  Simple and easy to use control utility for executing various *MSMS* tasks and actions.


.. _section-overview-directory-layout:

Directory layout
--------------------------------------------------------------------------------

As a first step a *MSMS* user should be familiar with the
`official Ansible documentation <http://docs.ansible.com/ansible/index.html>`__
and with the `best practices <http://docs.ansible.com/ansible/playbooks_best_practices.html>`__
section in particular, since this project tries to implement as many sane
recommendations as possible.


The basic directory layout of *MSMS* system uses many `best practice <http://docs.ansible.com/ansible/playbooks_best_practices.html>`__
recomendations with a few additions:

  * **.git**

    |tool_git| repository for the base *MSMS* code and utilities.

  * **bin**

    Custom scripts performing various tasks.

  * **doc**

    Project documentation in various formats, based on |tool_sphinx|. Documentation 
    in given format can be generated with |tool_make| utility, see the section 
    :ref:`section-overview-utilities`.

  * **inventory**

    |tool_git| repository containing server environment configuration for this particular 
    instance. It is intentionally NOT installed as a Git subproject to separate 
    core *MSMS* code and utilities from server environment configuration. For more 
    information please see the section :ref:`section-overview-inventory`.

  * **venv**

    Virtual Python environment in which local installation of |tool_ansible| and all other
    requirements and dependencies will be.

  * **spool**

    Storage directory for side-effects and artifacts of role execution. Roles may place
    various files for the convenience of the administrator/user here.

  * *ansible.cfg*

    `Configuration file <https://docs.ansible.com/ansible/latest/installation_guide/intro_configuration.html>`__ 
    for |tool_ansible| installed in local virtual environment. This configuration file
    is customized for *MSMS* directory layout. Search for string ``#--- changed from default ---#``
    to find customized configuration values.

  * *conf.py*

    `Configuration file <http://www.sphinx-doc.org/en/stable/config.html>`__ for
    |tool_sphinx|. For more information on documentation generation and documentation 
    in general please see the section :ref:`section-overview-documentation`.

  * *documentation.rst*

    Documentation root file for |tool_sphinx|. For more information on documentation 
    generation and documentation in general please see the section :ref:`section-overview-documentation`.

  * *Makefile*

    Master makefile and task/action launcher. You will use it for a wide range of tasks
    like upgrading, role installation or documentation generation. For more information 
    please see the section :ref:`section-overview-utilities`.

  * *README.rst*

    Master README file with quick system overview, displayed by default on `GitHub <https://github.com/honzamach/msms>`__.


After activation of the *MSMS* system following files may/will appear in root
directory:

  * **roles**

    At the time of writing this there is something broken with the |tool_ansible| configuration
    ``roles_path``. It would be awesome to point local |tool_ansible| to ``./inventory/roles``
    directory, but sadly it currently does not work. This is a symlink to work around this
    problem.

  * *playbook_....yml*

    Various playbooks installed from server environment configuration. For more information 
    please see the section :ref:`section-overview-playbooks`.

  * *role_....yml*

    Playbooks executing only single role installed from server environment configuration. 
    They will appear in root directory after the *MSMS* system is enabled. For more 
    information please see the section :ref:`section-overview-playbooks`.

  * *task_....yml*

    Playbooks implementing simple tasks without the use of |tool_ansible| roles. For more 
    information please see the section :ref:`section-overview-playbooks`.


.. _section-overview-inventory:

Inventory
--------------------------------------------------------------------------------

Inventory files are located in **inventory** subdirectory and they represent configuration
for specific server environment. They are all contained within different |tool_git| 
repository, which is intentionally NOT installed as submodule of the master *MSMS* 
repository. The idea is to separate *MSMS* toolkit from custom inventory specific 
configurations. So although the **inventory** directory is contained within the *MSMS*
root directory, it is removed from versioning with main ``.gitignore`` file and you
may think of it being installed as a loose plugin. 

There are following key subdirectories/components you can use to define your particular
server management environment:

  * **docs**

    Auto-generated internal documentation for the inventory hosts. Most of the files
    in this directory are produced by the :ref:`section-role-util-inspector`.

  * **group_files**

    Group files. Similar mechanism to **group_vars**. Files placed on certain locations
    in this directory can be used to everride default role template files. This feature 
    is custom and support must be implemented by the particular role. Fow more information 
    please see the section :ref:`section-overview-customize-templates`.

  * **group_vars**

    Group inventory variables, see the `Ansible docs <http://docs.ansible.com/ansible/intro_inventory.html#group-variables>`__ for details.

  * **host_files**

    Host files. Similar mechanism to **host_vars**. Files placed on certain locations
    in this directory can be used to everride default role template files. This feature 
    is custom and support must be implemented by the particular role. Fow more information 
    please see the section :ref:`section-overview-customize-templates`.

  * **host_vars**

    Host inventory variables, see the `Ansible docs <http://docs.ansible.com/ansible/intro_inventory.html#host-variables>`__ for details.

  * **playbooks**

    Directory containing custom inventory playbooks. These playbooks will be installed to
    the *MSMS* root directory.

  * **roles**

    Directory containing all locally installed roles for this server management environment.
    These roles are installed as |tool_git| submodules to conserve space consumed by the config
    repository and to enable easy role management with native |tool_git| commands. 

  * *hosts*

    Master inventory file, see the `Ansible docs <http://docs.ansible.com/ansible/intro_inventory.html#inventory>`__ 
    for details. There is currently only one inventory file called *hosts* which contains 
    the descriptions for all servers managed by this particular instance of *MSMS*. It is
    not necessary to provide path to this file with |tool_ansible| ``-i|--inventory``
    option, because local installation is preconfigured for this file path. There is
    technically possible to use multiple host inventory files, but it was not yet
    needed, so this feature is not yet tested and may produce unknown results.

The design of the inventory *hosts* file is fairly simple. All managed servers must be 
in the group ``servers``.

Additionally, there is a separate group for each one of the roles. The group name is
generated by concatenating string ``servers_`` with the name of the role. Again, this
is hardcoded feature and each role is hardcoded to work only with specific group.

This approach has the advantage that you can clearly state and/or see, which roles will
be applied to which hosts and you can control this feature within the inventory file 
and outside of the code of the role itself.


.. _section-overview-role-design:

Role design
--------------------------------------------------------------------------------

Each role was developed according to the Ansible `best practice <http://docs.ansible.com/ansible/playbooks_best_practices.html>`__
with addition of few extra features. Description of the contents of the
role subdirectories can be found in the Ansible `docs <https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html>`__.

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
    ansible playbook --tags=configure playbook_full.yml

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
