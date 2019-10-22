.. _section-roles:

Roles
================================================================================

According to the Ansible `documentation <http://docs.ansible.com/ansible/playbooks_roles.html>`_
and `best practices <http://docs.ansible.com/ansible/playbooks_best_practices.html>`_,
playbooks implementing particular feature should be organized into roles. In that way
they are easilly reusable for other users and all corresponding task, variables nd metadata
are neatly organized within single directory structure.

These roles are implemented with usability and simplicity in mind. Particularly
when generating config files from templates, these templates tend to be as simple as
possible. So when particular configuration does not need to be customized (in our environment),
it is defined statically within respective configuration file template.

.. note::

    This project makes heavy use of the *role* feature, so really get familliar with it.


.. _section-roles-list:

Role list
--------------------------------------------------------------------------------

.. toctree::
   :maxdepth: 1
   :glob:

   /inventory/roles/*/README
