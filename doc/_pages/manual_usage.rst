.. _section-usage:

Usage
================================================================================

.. note::

    Following example commands all require to be invoked from within the directory
    that the management suite was installed/cloned to.

.. note::

    Do not forget to unlock the :ref:`vault <section-overview-vault>` before each
    usage and then lock it later, when you are done.

* Execute all roles across all hosts::

      ansible-playbook -i inventories/production playbook_site.yml

* Execute all roles across specific host or group::

      ansible-playbook -i inventories/production --limit=servers-feature-monitored playbook_site.yml

* Execute specific role across all hosts::

      # Either use specific role playbook
      ansible-playbook -i inventories/production role_base-accounts.yml

      # Or you may use tags
      ansible-playbook -i inventories/production --tags=base-accounts playbook_site.yml

* Execute specific role across specific host or group::

      # Either use specific role playbook
      ansible-playbook -i inventories/production --limit=servers-feature-monitored role_base-accounts.yml

      # Or you may use tags
      ansible-playbook -i inventories/production --limit=servers-feature-monitored --tags=base-accounts playbook_site.yml

* Execute only configuration tasks of all roles across all hosts::

      ansible-playbook -i inventories/production --tags=configure playbook_site.yml

* Execute only configuration tasks of specific role across specific host or group::

      # Either use specific role playbook
      ansible-playbook -i inventories/production --tags=configure --limit=servers-feature-monitored role_base-accounts.yml

      # Or you may use tags
      ansible-playbook -i inventories/production --tags=configure,base-accounts --limit=servers-feature-monitored playbook_site.yml

* Execute all base/service/feature/application roles::

      ansible-playbook -i inventories/production --tags=role-base playbook_site.yml
