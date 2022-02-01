Running a PRE Node
==================

Minimum System Requirements
---------------------------

* Debian/Ubuntu (Recommended)
* 20GB storage
* 4GB RAM
* x86 architecture
* Static IP address
* Exposed TCP port 9151

Nodes can be run on cloud infrastructure - for example, a
`Digital Ocean 4GB Basic Droplet <https://www.digitalocean.com/pricing/>`_
satisfies the requirements listed above.

The above requirements only apply if you intend to run a node yourself.
Alternatively, a staking provider can run a node on your behalf.


PRE Node Configuration Requirements
-----------------------------------

Ethereum Node Provider URI
++++++++++++++++++++++++++

The PRE node will need to execute an initial transaction to confirm its
operation on startup, and therefore requires access to an
`ethereum node <https://web3py.readthedocs.io/en/stable/node.html>`_
(either a local or remote ethereum node) to broadcast the transaction. Remote
ethereum providers include Infura, Alchemy etc. and an HTTPS URI will need to
be configured (``https://<URI>``), whereas a local full node would entail running
`geth <https://geth.ethereum.org/>`_ locally and configured using the
IPC URI (``ipc://<PATH TO IPC FILE>``).
This value will be provided via the ``--provider`` CLI parameter.

It is worth noting that running a local ethereum node is quite the undertaking,
and has its own
`additional requirements <https://docs.ethhub.io/using-ethereum/running-an-ethereum-node/>`_.


PRE Node Operator Account
+++++++++++++++++++++++++

A software wallet is recommended for the PRE node operator ethereum account
since the account needs to remain unlocked to execute an automated transaction
when the node first starts.

.. caution::

    - Operator accounts **do not** need NU/KEEP/T tokens for any reason; do not keep NU/KEEP/T in the
      operator account.
    - Do not store large amounts of ETH in the operator account; only enough to pay gas fees. Nodes
      only need to execute a single transaction on the first start which costs ~100K gas at
      a gas price of 146 gwei, this would be ~0.015 ETH). There are no subsequent transactions on restarts.
    - Store the operator account password in a password manager

To create a new ethereum software account using the ``geth`` CLI

    .. code::

        geth account new

    - Never share your ethereum account password.
    - Do not forget your ethereum account password.
    - Secure your ethereum account password in a password manager.


PRE Node Operator Transaction Signer
++++++++++++++++++++++++++++++++++++

In conjunction with an Ethereum node provider for broadcasting to the
Ethereum blockchain, the node also needs to configure a transaction signer
for signing messages to be broadcasted.

This separation of a transaction signer from an Ethereum node allows pre-signed
transactions to be sent to an external (possibly remote) ethereum node and is
particularly desirable when interacting with an untrusted ethereum node.

Local ethereum keystore signing can be configured for the operator software
account. Local keystore signing utilizes `eth-account <https://github.com/ethereum/eth-account/>`_
to sign ethereum transactions using local ethereum keystore files. By default
on Linux, the default local keystore directory path is ``~/.ethereum/keystore``.
The local keystore signer can be specified during initialization using the
following URI format, ``--signer`` CLI parameter and ``keystore://<PATH TO LOCAL KEYSTORE>`` as the
value, eg. ``--signer keystore:///root/.ethereum/keystore``.


.. note::

    The expectation is that the operator account is part of the local keystore.


Running a PRE Node
------------------

Running a PRE node entails two steps:

#. Initializing a PRE node configuration
#. Starting the PRE node.

Node management commands are issued via the ``nucypher ursula`` CLI. For more information
on that command you can run ``nucypher ursula –help``.

Initializing the PRE node configuration entails:

- Creation of a nucypher-specific keystore to store private encryption keys used
  by the node, which will be protected by a user-specified password.

  .. important::

    This is not to be confused with an ethereum keystore - which stores ethereum account private keys.

- Creation of a persistent node configuration file called ``ursula.json``. This file will be written to disk and contains the various runtime configurations for the node.

All PRE node configuration information will be stored in ``/home/user/.local/share/nucypher/`` by default.


Run Node via Docker (Recommended)
+++++++++++++++++++++++++++++++++

Running the node via a docker container negates the need to install ``nucypher`` locally.
Instead, the node is run as part of a docker container which greatly simplifies the installation process.


Setup Docker
^^^^^^^^^^^^

- Install `docker <https://docs.docker.com/install>`_.
- *Optional* Depending on the setup you want, post install instructions, additional
  docker configuration is available `here <https://docs.docker.com/engine/install/linux-postinstall/>`_.
- Get the latest ``nucypher`` docker image:

  .. code:: bash

    $ docker pull nucypher/nucypher:latest


Export Node Environment Variables
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

These environment variables are used to better simplify the docker installation process.

.. code:: bash

    # Password used for creation / update of nucypher keystore
    $ export NUCYPHER_KEYSTORE_PASSWORD=<YOUR NUCYPHER KEYSTORE PASSWORD>

    # Password used to unlock node eth account
    $ export NUCYPHER_WORKER_ETH_PASSWORD=<YOUR WORKER ETH ACCOUNT PASSWORD>


Initialize Node Configuration
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This step creates and stores the PRE node configuration, and only needs to be run once.

.. code:: bash

    $ docker run -it --rm  \
    --name ursula        \
    -v ~/.local/share/nucypher:/root/.local/share/nucypher \
    -v ~/.ethereum/:/root/.ethereum               \
    -p 9151:9151                                  \
    -e NUCYPHER_KEYSTORE_PASSWORD                 \
    nucypher/nucypher:latest                      \
    nucypher ursula init                          \
    --network mainnet                             \
    --signer <ETHEREUM KEYSTORE URI>              \
    --provider <PROVIDER URI>                     \
    --max-gas-price <GWEI>


Replace the following values with your own:

- ``<ETHEREUM KEYSTORE URI>`` - Location of local ethereum keystore (typcially ``keystore:///root/.ethereum/keystore``).
- ``<PROVIDER URI>`` - The URI of a local or hosted ethereum node provider eg. ``https://infura.io/…``
- *Optional* ``<GWEI>`` - The ``--max-gas-price`` parameter is optional and not necesary if you don’t want
  to cap the price of gas for any transaction that needs to be performed by the node.


Launch the Node
^^^^^^^^^^^^^^^

This step starts the PRE node.

.. code:: bash

    $ docker run -d --rm \
    --name ursula      \
    -v ~/.local/share/nucypher:/root/.local/share/nucypher \
    -v ~/.ethereum/:/root/.ethereum  \
    -p 9151:9151                     \
    -e NUCYPHER_KEYSTORE_PASSWORD    \
    -e NUCYPHER_WORKER_ETH_PASSWORD  \
    nucypher/nucypher:latest         \
    nucypher ursula run

View Node Logs
^^^^^^^^^^^^^^

.. code:: bash

    $ docker logs -f ursula


Upgrade the Node To a Newer Version
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code:: bash

    # stop docker container
    $ docker stop ursula

    # pull latest docker image
    $ docker pull nucypher/nucypher:latest

    # start node (same aforementioned run command)
    $ docker run …


Run Node without Docker
+++++++++++++++++++++++

Instead of using docker, PRE nodes can be run using a local installation of ``nucypher``.


Install ``nucypher``
^^^^^^^^^^^^^^^^^^^^

- ``nucypher`` supports Python 3.7 and 3.8. If you don’t already have it, install `Python <https://www.python.org/downloads/>`_.
- Create a `Virtual Environment <https://virtualenv.pypa.io/en/latest/>`_ in a folder
  somewhere on your machine.This virtual environment is a self-contained directory
  tree that will contain a python installation for a particular version of Python,
  and various installed packages needed to run the node.

  .. code:: bash

    python -m venv </your/path/nucypher-venv>

- Activate the newly created virtual environment:

  .. code:: bash

    $ source </your/path/nucypher-venv>/bin/activate

- Install `nucypher` package

  .. code:: bash

    $ pip3 install -U nucypher

- Verify that `nucypher` is installed

  .. code:: bash

    $ nucypher –-version


Run Node via systemd (Alternate)
++++++++++++++++++++++++++++++++

Instead of using docker, the node can be run as a `systemd <https://en.wikipedia.org/wiki/Systemd>`_ service.


Configure the node
^^^^^^^^^^^^^^^^^^

.. code:: bash

    $ nucypher ursula init           \
    --network mainnet                \
    --provider <PROVIDER URI>        \
    --signer <KEYSTORE URI>          \
    --max-gas-price <GWEI>

Where:

- ``<PROVIDER URI>``: The URI of the local or remote etheresum node eg. ``https://infura.io/…``
- ``<KEYSTORE URI>``: The URI of an ethereum keystore: eg. ``keystore:///root/.ethereum/keystore``
- *Optional* ``<GWEI>`` - The `--max-gas-price` parameter is optional and not necesary
  if you don’t want to cap the price of gas for any transaction that needs to be performed by the node.


Create Node Service Template
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Create a file named ``ursula.service`` in ``/etc/systemd/system``, and add this template to it

.. code:: bash

    [Unit]
    Description="Ursula, a PRE Node."

    [Service]
    User=<YOUR USERNAME>
    Type=simple
    Environment="NUCYPHER_WORKER_ETH_PASSWORD=<YOUR WORKER ADDRESS PASSWORD>"
    Environment="NUCYPHER_KEYSTORE_PASSWORD=<YOUR PASSWORD>"
    ExecStart=<VIRTUALENV PATH>/bin/nucypher ursula run

    [Install]
    WantedBy=multi-user.target


Replace the following values with your own:

- ``<YOUR USER>`` - The host system’s username to run the process with (best practice is to use a dedicated user)
- ``<YOUR WORKER ADDRESS PASSWORD>`` - Operator’s ETH account password
- ``<YOUR PASSWORD>`` - ``nucypher`` keystore password
- ``<VIRTUALENV PATH>`` - The absolute path to the python virtual environment containing the ``nucypher`` executable.
  Run ``pipenv –venv`` within the virtual environment to get the virtual environment path.


Enable Node Service
^^^^^^^^^^^^^^^^^^^

.. code:: bash

	$ sudo systemctl enable ursula


Run Node Service
^^^^^^^^^^^^^^^^

.. code:: bash

	$ sudo systemctl start ursula


Check Node Service Status
^^^^^^^^^^^^^^^^^^^^^^^^^

.. code:: bash

    # Application Logs
    $ tail -f ~/.local/share/nucypher/nucypher.log

    # Systemd status
    $ systemctl status ursula

    # Systemd Logs
    $ journalctl -f -t ursula


Restart Node Service
^^^^^^^^^^^^^^^^^^^^

.. code:: bash

	$ sudo systemctl restart ursula


Run Node Manually
+++++++++++++++++

Configure the Node
^^^^^^^^^^^^^^^^^^

If you’d like to use another own method of running the Node's process in the
background,, here is how to run Ursula using the CLI directly.

First initialize a Node configuration:

.. code:: bash

    $ nucypher ursula init \
    --network mainnet               \
    --provider <PROVIDER URI>       \
    --signer <SIGNER URI>           \
    --max-gas-price <GWEI>


Replace the following values with your own:

- ``<PROVIDER URI>`` - The URI of a local or hosted ethereum node eg. ``https://infura.io/…``
- ``<SIGNER URI>`` - The URI to an ethereum keystore or signer: eg. ``keystore:///root/.ethereum/keystore``
- *Optional* ``<GWEI>`` - The ``--max-gas-price`` parameter is optional and not necesary
  if you don’t want to cap the price of gas for any transaction that needs to be performed by the node.


Run the Node

.. code:: bash

    $ nucypher ursula run


Update Node Configuration
+++++++++++++++++++++++++

These configuration settings will be stored in an ursula configuration file, ``ursula.json``, stored
in ``/home/user/.local/share/nucypher`` by default.

All node configuration values can be modified using the config command, ``nucypher ursula config``

.. code:: bash

    $ nucypher ursula config --<OPTION> <NEW VALUE>

    # Usage
    $ nucypher ursula config –help


    # Update the max gas price setting
    $ nucypher ursula config --max-gas-price <GWEI>

    # Change the Ethereum provider to use
    $ nucypher ursula config --provider <PROVIDER URI>

    # View the current configuration
    $ nucypher ursula config


.. important::

    The node must be restarted for any configuration changes to take effect.


Node Qualification
++++++++++++++++++

Nodes must be fully qualified: funded with ETH and bonded to an operator address,
in order to fully start. Nodes that are launched before qualification will
pause until they have a balance greater than 0 ETH, and are bonded to an
operator address. Once both of these requirements are met, the node will
automatically continue startup.

Waiting for qualification:

.. code:: bash

    Authenticating Ursula
    Qualifying operator
    ⓘ  Operator startup is paused. Waiting for bonding and funding ...
    ⓘ  Operator startup is paused. Waiting for bonding and funding ...
    ⓘ  Operator startup is paused. Waiting for bonding and funding …

Continuing startup after funding and bonding:

.. code:: bash

    ...
    ⓘ  Operator startup is paused. Waiting for bonding and funding ...
    ✓ Operator is bonded to 0x37f320567b6C4dF121302EaED8A9B7029Fe09Deb
    ✓ Operator is funded with 0.01 ETH
    ✓ External IP matches configuration
    ...
    ✓ Rest Server https://1.2.3.4:9151
    Working ~ Keep Ursula Online!


Node Status
+++++++++++

Node Logs
^^^^^^^^^

A reliable way to check the status of a node is to view the logs.
View logs for a docker-launched Ursula:

.. code:: bash

    $ docker logs -f ursula

View logs for a CLI-launched or systemd Ursula:

.. code:: bash

    # Application Logs
    tail -f ~/.local/share/nucypher/nucypher.log

    # Systemd Logs
    journalctl -f -t ursula


Node Status Page
^^^^^^^^^^^^^^^^

Once the node is running, you can view its public status page at ``https://<node_ip>:9151/status``.
