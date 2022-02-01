Documentation for the Interim PRE Application
=============================================

Building Documentation
----------------------

.. note::

  ``sphinx`` and ``sphinx_rtd_theme`` are non-standard dependencies that can be installed
  by running ``pip install -e . -r docs-requirements.txt`` from the project directory.


.. _Read The Docs: https://nucypher.readthedocs.io/en/latest/

Documentation for ``interim-pre-app-docs`` is hosted on `Read The Docs`_, and is automatically built.

However, you may want to build the documentation html locally for development.

To build the project dependencies locally on Linux:

.. code:: bash

    (nucypher)$ make docs

or on MacOS:

.. code:: bash

    (nucypher)$ make mac-docs

If the build is successful, the resulting local documentation homepage, ``nucypher/docs/build/html/index.html``, will
be automatically opened in the web browser.

.. note::

    If you would rather not have the homepage automatically opened, then run ``make build-docs`` instead.
