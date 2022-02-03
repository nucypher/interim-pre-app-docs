.. image:: ./.static/img/threshold_logo_purple.png
    :target: ./.static/img/threshold_logo_purple.png

PRE Application on Threshold
============================

.. note::

   This project is under active development.

Welcome to documentation for the Proxy Re-Encryption (PRE) app, running on the Threshold network. In addition to staking T, stakers must operate and provide a reliable PRE service in order to be eligible for T rewards.
This resource serves to guide prospective node operators through the set up and maintenance of a PRE client on their machine.

Contents
--------

.. toctree::
   :maxdepth: 1
   :caption: Running a PRE Node

   node_operation/node_requirements
   node_operation/running_a_node
   node_operation/cloud_node_management
   node_operation/node_providers

PRE Service Overview
--------------------

The PRE application is the first of many *threshold cryptography*-based applications
to be hosted on the Threshold Network. PRE is a more scalable, more flexible form of public-key
encryption that enables a group of proxy entities to transform encrypted data from one
public key to another, without the power to decrypt the data or gain access to any
private keys. PRE equips developers, applications and end-users with **secrets management** and **dynamic access control** capabilities. This service is provided by a decentralized array of nodes on the Threshold Network, each
running the same PRE client software.


Staker Strategies & Responsibilities
------------------------------------

In order to provide the PRE service and receive rewards, T stakers have three options:

* **Node Delegation**: Delegate running a PRE client to one of the participating :ref:`Node-as-a-Service providers<node-providers>`. In this
  case, the setup, operation, and monitoring is outsourced, and stakers need only check in occasionally to ensure the provider is handling things as expected.
* **Self-Managed, Manual**: :ref:`Run<running-a-node>` your own PRE node and retain full purview and customization control over the machine(s), installation, dependencies and configuration. In this case, stakers are entirely responsible for setup, operation, and monitoring
  of the PRE client.
* **Self-Managed, Automated**: Run your own PRE node on either Digital Ocean or AWS, leveraging :ref:`automation tools<managing-cloud-nodes>` that speed up and simplify the installation process. In this case too, stakers are entirely responsible for setup, operation, and monitoring of the PRE client.

Note that setting up a PRE node from scratch is non-trivial, but is typically inexpensive and unburdensome to maintain.
PRE end-users expect and require an on-demand service, wherein their *grant*, *revoke* and *re-encryption* requests are answered reliably, correctly, and without interruption.
Hence the most critical responsibility for stakers is ensuring that their PRE node remains online **at all times**. If this is not certain using a local machine, it is highly recommended to use cloud infrastructure instead.

Staker Subsidization (Rewards)
-------------------------------
[WIP]

.. note::

    In the traditional NuCypher Network parlance, ``Worker`` can be used interchangeably
    with the new Threshold Network ``Operator`` term.
