# Virtualenv for TDG Projects

The venv folder is used for creating a Python virtual environment using Python's
virtualenv tool. For more information on the virtualenv tool consult the [user
guide](https://virtualenv.pypa.io/en/stable/user_guide.html).

**TL;DR**: venv allows you to run a completely separate Python environment for
each project.

To create the virtual environment, run the following command in a terminal from
the project's root directory: `python3 -m venv ./venv`

Every time you do work on this project, you should activate this project's
specific Python environment. On Linux you do this using virtualenv's `source`
command, i.e. `source ./venv/bin/activate`.

The project template includes a `requirements.txt` file in the top folder of the
repository. A windows version is included as well should you need to run Python
in a Windows environment. This should contain a list of all Python libraries
used. By default all libraries needed to run `tooles` are included. You can
customize this for a given project. When setting up your virtual environment you
can install all the necessary packages **after** activating your virtual
environment using pip: 
`pip install -r ./requirements.txt`

`requirements.txt` includes the latest release of `tooles`. This is installed
from Github using an SSH connection. If you haven't set your WSL up for SSH
access to Github you can do so by following the instructions
[here](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)
(be sure to follow the Linux instructions).

This will take a bit of time to run. Once it's done you will have a full Python
environment ready to use `tooles`.
