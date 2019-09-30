.. _section-overview:

System overview
================================================================================


The whole server management system is bases on the `Ansible <https://www.ansible.com/>`__
orchestration tool. Ansible is extremely flexible and there are many ways to
archieve single goal. It is both strength and weakness, because the playbooks can
quickly become very chaotic. This project attempt to pick one option to archive
certain goal and then stick to it whenever reasonable and possible. Hopefully this
will lead to deterministic organization and better readability and usability.

As a first step user should be familiar with the
`official Ansible documentation <http://docs.ansible.com/ansible/index.html>`__
and with the `best practices <http://docs.ansible.com/ansible/playbooks_best_practices.html>`__
section in particular, since this project tries to implement as many sane
recomendations as possible.


https://galaxy.ansible.com/docs/contributing/importing.html
https://docs.ansible.com/ansible/latest/reference_appendices/galaxy.html#travis-integrations


Example role: acme

01. Create completely empty GitHub repository for your role ansible-role-acme
02. Implement the role ansible-role-acme
03. git add -A
04. git ci -m "Initial commit"
05. git tag -a v1.0.0 -m "v1.0.0 - Initial role release"
06. git remote add origin git@github.com:honzamach/ansible-role-acme.git
07. git push -u origin master
08. git push origin v1.0.0
09. ansible-galaxy import honzamach ansible-role-acme
10. ansible-galaxy setup travis honzamach ansible-role-acme xxx-travis-token-xxx
11. ansible-galaxy setup --list
12. Enable CI for your repository in your TravisCI profile interface


.. _section-overview-directory-layout:

Directory layout
--------------------------------------------------------------------------------


The basic directory layout uses many `best practice <http://docs.ansible.com/ansible/playbooks_best_practices.html>`__
recomendations with few additions:

  * **.git**

    Git repository containing previous revisions of this project.

  * **.vault**

    Encrypted *encfs* volume containing sensitive or classified data or configuration,
    like server certificates or passwords. This volume is protected by a shared
    password, which must be known to all administrators. For more information see section
    :ref:`section-overview-vault` below.

  * **doc**

    Project documentation in various formats, based on `Sphinx <http://www.sphinx-doc.org/en/stable/>`__.
    Documentation in given format can be generated with ``make`` utility, see the
    section :ref:`section-overview-utilities` below.

    * _build

      * html
      * man
      * latex

  * **group_files**

    Host group files. Similarly to **group_vars** these can be used to override
    certain template files. This feature must be supported by the particular role.
    Fow more information see the section :ref:`section-overview-customize-templates` below.

  * **group_vars**

    Host group variables, see the `Ansible docs <http://docs.ansible.com/ansible/intro_inventory.html#group-variables>`__ for details.

  * **host_files**

    Host files. Similarly to **host_vars** these can be used to override
    certain template files. This feature must be supported by the particular role.
    Fow more information see the section :ref:`section-overview-customize-templates` below.

  * **host_vars**

    Host variables, see the `Ansible docs <http://docs.ansible.com/ansible/intro_inventory.html#host-variables>`__ for details.

  * **inventories**

    Inventory files, see the `Ansible docs <http://docs.ansible.com/ansible/intro_inventory.html#inventory>`__ for details.
    For description of custom features see the section :ref:`section-overview-inventory-files` below.

  * **roles**

    Role repository, see the `Ansible docs <http://docs.ansible.com/ansible/playbooks_roles.html#roles>`__ for details.
    For description of custom features and role design see the section :ref:`section-overview-role-design` below.
    For description of custom roles see the section :ref:`section-roles`.

  * **vault**

    Mount point for decrypted *encfs* volume. All playbooks and roles, that need access
    to sensitive data and configuration are expecting to find them within this directory.
    For description of custom features see the :ref:`section-overview-vault` below.

  * *conf.py*

    `Sphinx <http://www.sphinx-doc.org/en/stable/>`__ documentation generator
    `configuration file <http://www.sphinx-doc.org/en/stable/config.html>`__.
    For more information on documentation generation see the section :ref:`section-overview-utilities` below.

  * *Makefile*

    `Sphinx <http://www.sphinx-doc.org/en/stable/>`__ documentation generator
    `make file <http://www.sphinx-doc.org/en/stable/invocation.html#makefile-options>`__.
    For more information on documentation generation see the section :ref:`section-overview-utilities` below.

  * *manual.rst*

    `Sphinx <http://www.sphinx-doc.org/en/stable/>`__ documentation root file.
    For more information on documentation generation see the section :ref:`section-overview-utilities` below.

  * *playbook_site.yml*

    Master playbook performing all roles on all inventory hosts, see the section
    :ref:`section-overview-playbooks` for details.

  * *role_...*

    Playbooks executing only single role, see the section :ref:`section-overview-playbooks`
    for details.

  * *task_...*

    Playbooks implementing simple task without the use of Ansible roles, see the
    section :ref:`section-overview-playbooks` for details.

  * *vault.sh*

    Vault mounting utility script, see :ref:`section-overview-utilities` for details.


.. _section-overview-inventory-files:

Inventory files
--------------------------------------------------------------------------------


Inventory files are located in **inventories** subdirectory. They are intentionally
separated from default Ansible inventory file ``/etc/ansible/hosts``, so that this
management suite can be distributed as a single package without possible conflicts.
Bacause of this you have to specify path to correct inventory file with command line
option ``- i`` each time you are executing the **ansible-playbook** command.

There is currently only one inventory file called *production* which contains the
descriptions for all servers.

The design of the inventory file is fairly simple. All managed servers must be in
the group ``servers``.

Additionally, there is a separate group for each of the roles. The group name is
generated by concatenating string ``servers-`` with the name of the role. Again, this
is hardcoded feature and each role is hadcoded to work only with specific group.

This approach has the advantage that you can clearly state and/or see, which roles will
be applied to which hosts and you can control this feature outside of the code
of the role itself.


.. _section-overview-role-design:

Role design
--------------------------------------------------------------------------------


Each role was developed according to the Ansible `best practice <http://docs.ansible.com/ansible/playbooks_best_practices.html>`__
with addition of few extra features. Description of the contents of the
role subdirectories can be found in the Ansible docs.

Each role is hardcoded to use specific inventory group. The group name is
generated by concatenating string ``servers-`` with the name of the role. For
example role :ref:`base-accounts <section-role-base-accounts>` is hardcoded to work with ``servers-base-accounts``
inventory group. This approach enables full and simple inventory file based control
of which roles are applied to which hosts.

Additionally, each role is tagged with the tag corresponding with the role type.
The tag is created as concatenation of string ``role-`` with the name of role type.
This enables for example following use case::

    # Execute all base roles on appropriate inventory hosts
    ansible playbook -i inventories/production --tags=role-base playbook_site.yml

Besides that each role is also tagged with the same tag as the role name. This enables
for example following use case (following statements are equal)::

    # Execute only base-accounts role on appropriate inventory hosts
    ansible-playbook -i inventories/production role_base-accounts.yml
    ansible playbook -i inventories/production --tags=base-accounts playbook_site.yml

Every variable, that is used inside the role is prefixed with following string
pattern:

``r[role_type]_[role_name]__``

The ``role_type`` is first lowercase letter from the role type (e.g. 'b' for 'base', etc.)
and the ``role_name`` is simply the name of the role. For example all variables in
:ref:`base-accounts <section-role-base-accounts>` role are prefixed with ``rb_accounts__`` string. This approach
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
    ansible playbook -i inventories/production playbook_site.yml

    # Later apply only configuration changes
    ansible playbook -i inventories/production --tags=configure playbook_site.yml

When developing new roles there is a :ref:`_template <section-role-_template>` role in the **roles** directory,
which can be duplicated and modified as necessary.


.. _section-overview-vault:

Vault
--------------------------------------------------------------------------------


The built-in vault in Ansible was at the time of creating this project not capable of
storing secret binary files (at least not in a straightforward manner). For this reason
simple replacement was imlemented based on *encfs* technology. There are two special
directories in the project root directory: ``.vault`` and ``vault``. The former is
a *encfs* encrypted volume containing desired secret configurations certificates and
other files. The latter is the mountpoint for the encrypted volume, onto which the
volume must be decrypted/mounted and that is hardcoded in all roles and playbooks.
Before any playbook in this suite can be used, the vault must be decrypted, preferably
using the :ref:`provided utility <section-overview-utilities>`.

Currently, there are following subdirectories within the vault:

  * **ca_certs**

    Certificates of the additional certificate authorities, that are not preset on target
    hosts by default. Contents of this directory are used in :ref:`feature-certified <section-role-feature-certified>` role.

  * **host_certs**

    Host certificates including private keys. Certificates for each host are inside
    the directory with the same name as is the host name. It works similarly to
    Ansible`s `host_vars <http://docs.ansible.com/ansible/intro_inventory.html#host-variables>`__ directory. Again, contents of this directory are used
    in :ref:`feature-certified <section-role-feature-certified>` role.

  * *secrets.yml*

    This file contains secret configurations including user SSH keys and passwords
    for various services.

    The most important variables in this file are :envvar:`site_users`, :envvar:`site_hosts`
    and :envvar:`server_vars`. These variables serve as a primitive databases and many
    configurations in roles use them as a dictionaries to lookup additional private information.

.. envvar:: site_users

    This is one of the most important configuration variables. It is in fact simple
    JSON database of all known user accounts and their personal data. In respect
    of datatype, it must be ``dictionary of dictionaries`` with following structure::

        site_users:
            mach:
                uid: mach
                name: Jan
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


Master playbook - playbook_site.yml
````````````````````````````````````````````````````````````````````````````````

This master playbook includes in correct order all of role playbooks and thus performs
full site management. Execution of all roles can be very slow, for quick updates
it is better to use appropriate role playbook or limit the inventory hosts.

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


.. warning::

    This feature is under development, not all roles support this.

Some roles are implemented in a way that supports customization of template files
without the need of modification original template file within the role directory.

This feature is simillar to the variable overriding feature of Ansible itself.
There are two subdirectories in prject root directory:

* **group_files**
* **host_files**

They work similarly to the **group_vars** and **host_vars** directories. They may
contain subdirectories with the names matching inventory hostnames or inventory
groups and they may contain override template files.

.. warning::

    For **group_files** currently only group **servers** is supported. This is because
    the **with_first_found** Ansible directive does not support dynamic generation
    of multiple rules.


.. _section-overview-utilities:

Utilities
--------------------------------------------------------------------------------


make
````````````````````````````````````````````````````````````````````````````````

Project root directory contains makefile for generating documentation in various
output formats::

    make html
    make man

vault.sh
````````````````````````````````````````````````````````````````````````````````

This is a simple utility script for mounting *encfs* encrypted :ref:`section-overview-vault`
volume. It must be executed from within the management suite root directory and requires
mandatory argument ``on`` or ``off`` to switch between mounting and unmounting.
