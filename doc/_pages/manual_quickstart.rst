.. _section-quickstart:

Quickstart
================================================================================

.. _section-quickstart-how-to-get-it-work:

How to get it work?
--------------------------------------------------------------------------------

.. warning::

    You must have SSH access to the ``puppeteer.cesnet.cz`` server.

.. note::

    Following example commands use ``/some/local/path`` as a local installation
    directory.

* **First time:** Clone the Ansible playbook repository to your local workstation::

      git clone [user]@puppeteer.cesnet.cz:/var/ansible/mach /some/local/path

* **First time:** Prepare the local :ref:`vault <section-overview-vault>` directory::

      mkdir /some/local/path/vault

* Always pull latest version of management suite::

      cd /some/local/path
      git pull

* Unlock the :ref:`vault <section-overview-vault>`::

      cd /some/local/path
      ./vault.sh on

* You may now make changes in configuration, run playbooks etc. See
  :ref:`quick examples <section-quickstart-basic-usage-examples>` below for few, ehm,
  quick usage examples, see section :ref:`usage <section-usage>` for a more in depth
  information.

* Lock the :ref:`vault <section-overview-vault>`::

      cd /some/local/path
      ./vault.sh off

* Please commit any changes back to the repository and push them back to the server::

      cd /some/local/path
      git commit
      git push

.. _section-quickstart-basic-usage-examples:

Basic usage examples
--------------------------------------------------------------------------------

.. note::

    Following example commands all require to be invoked from within the directory
    that the management suite was installed/cloned to (the ``/some/local/path``
    directory in the example above).

.. note::

    Do not forget to unlock the :ref:`vault <section-overview-vault>` before each
    usage and then lock it later, when you are done.

* Manage everything::

      # Use the production inventory file and the master site playbook
      ansible-playbook -i inventories/production playbook_site.yml

* Manage only specific hosts or groups::

      # Use the limit option
      ansible-playbook -i inventories/production --limit=servers-feature-monitored playbook_site.yml

* Manage only specific role::

      # Use playbook only for the appropriate role
      ansible-playbook -i inventories/production role_feature-monitored.yml

* Manage only specific role on specific hosts or groups::

      # Use the limit option and playbook only for the appropriate role
      ansible-playbook -i inventories/production --limit=servers-feature-monitored role_base-accounts.yml

For more examples please refer to the section :ref:`section-usage`.

For in-depth description of system architecture please refer to the section :ref:`section-overview`.
