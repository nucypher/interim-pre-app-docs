Documentation for the Interim PRE Application
=============================================

Building Documentation
----------------------

.. _Read The Docs: https://nucypher.readthedocs.io/en/latest/

Documentation for ``interim-pre-app-docs`` is hosted on `Read The Docs`_, and is
automatically built and published to https://interim-pre-application-docs.readthedocs.io/en/latest/.

However, you may want to build the documentation html locally for development.

To build the project locally:

* Create virtual environment:

    .. code:: bash

        $ pipenv shell

* Install documentation dependencies

    .. code:: bash

        (interim-pre-app-docs)$ pip install -e . -r docs-requirements.txt

* Build the docs:

    On Linux,

    .. code:: bash

        (interim-pre-app-docs)$ make docs

    OR on MacOS:

    .. code:: bash

        (interim-pre-app-docs)$ make mac-docs

If the build is successful, the resulting local documentation homepage, ``docs/build/html/index.html``, will
be automatically opened in a web browser.

.. note::

    If you would rather not have the homepage automatically opened, then run ``make build-docs`` instead.
