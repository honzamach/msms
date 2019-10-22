.. _section-usage:

Usage
================================================================================


.. _section-usage-management:

Server management
--------------------------------------------------------------------------------

.. note::

    Following example commands all require to be invoked from within the directory
    that the management suite was installed/cloned to.

* Execute all roles across all hosts::

      ansible-playbook playbook_full.yml

* Execute all roles across specific host or group::

      ansible-playbook --limit=servers_monitored playbook_full.yml

* Execute specific role across all hosts::

      # Either use specific role playbook
      ansible-playbook role_accounts.yml

      # Or you may use tags
      ansible-playbook --tags=role-accounts playbook_full.yml

* Execute specific role across specific host or group::

      # Either use specific role playbook
      ansible-playbook --limit=servers_monitored role_accounts.yml

      # Or you may use tags
      ansible-playbook --limit=servers_monitored --tags=role-accounts playbook_full.yml

* Execute only configuration tasks of all roles across all hosts::

      ansible-playbook --tags=configure playbook_full.yml

* Execute only configuration tasks of specific role across specific host or group::

      # Either use specific role playbook
      ansible-playbook --tags=configure --limit=servers_monitored role_accounts.yml

      # Or you may use tags
      ansible-playbook --tags=configure,role-accounts --limit=servers_monitored playbook_full.yml


.. _section-usage-custom-roles:

Creating custom roles
--------------------------------------------------------------------------------

References:

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
