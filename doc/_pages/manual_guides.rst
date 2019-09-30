.. _section-guides:

Guides
================================================================================


Provisioning of demo server for PROTECTIVE project
--------------------------------------------------------------------------------

The demo server is distributed to the members of the project as virtual machine
appliance in `OVF/OVA <https://en.wikipedia.org/wiki/Open_Virtualization_Format>`__.
To make the installation as clean as possible, it is appropriate to remove all
configuration related to CESNET in any way. Following command will (with current
configuration of **mentat-demo** server) take care of that::

    ansible-playbook -v -i inventories/production --limit mentat-demo --extra-vars '{"rf_firewalled__flush_and_reload":true,"rf_firewalled__allow_workstations":[],"rb_accounts__admins":[]}' playbook_site.yml
