# Project Details

Project #: [enter project number here]

Project Manager: [enter project manager name here]

Lead data analyst: [enter name here]

Server: [enter server IP address]

Database: [enter database name]

Project SRID: [enter SRID/CRS, e.g., EPSG:26849]

# WSL (Windows Subsystem for Linux)
Windows Subsystem for Linux is a lightweight Linux virtual machine that you can
run within your Windows environment. Linux does a much better job of handling
Python and WSL is seamlessly integrated with VSCode. You're not required to use
WSL for your work but instructions here assume WSL and dealing with Python on
Windows is usually an unpleasant experience. Consider yourself warned!

Details about setting up WSL are [here](WSL.md).

# Virtual environment
Virtual environment instructions at
[venv/virtualenv-setup.md](venv/README.md)

# Database
Received, processed, and output data should be stored in a project-specific database on one of Toole's data servers listed below. It is recommended that the project database is created on the server located in the office of the primary analyst. A new database can be created using the `create_database.sh` file included in the template.

| Server Location | Host Address   | Host Alias    |
|-----------------|----------------|---------------|
| BOSTON          | 192.168.10.227 | bos-postgis-a |
| DC              | 192.168.22.227 | dca-postgis-a |
| DC_B            | 192.168.22.228 | dca-postgis-b |
| DENVER          | 192.168.80.227 | den-postgis-a |
| MADISON         | 192.168.40.227 | mad-postgis-a |
| MINNEAPOLIS     | 192.168.50.227 | msp-postgis-a |
| PORTLAND*       | 192.168.60.227 | pdx-postgis-a |
| SEATTLE         | 192.168.30.227 | sea-postgis-a |

*As of Spring 2024, the `PORTLAND` server is currently offline and its contents have been migrated to the `DC_B` server. The server is expected to be made active again by Fall, 2024.

# Jupyter Lab
Jupyter Lab is a popular interactive development environment for creating and running Jupyter notebooks (.ipynb) for data science applications within a web browser. All Jupyter Lab dependencies are included by default in `requirements.txt` and will automatically be installed during the setup of the virtual environment.

To use Jupyter Lab, be sure that the project's virtual environment is activated. Before using Jupyter Lab for the first time in a new virtual environment, create a new kernel for the project with

```
ipython kernel install --user --name=[projectname]
```

using the name of the project for the `--name` argument. Now you can open the Jupyter Lab application with the command

```
jupyter lab --no-browser
```

and `ctrl + click` the link to the server location in the terminal (usually at `http://localhost:8888/lab?token=...` or similar). This will open Jupyter Lab in your default browser. When creating new notebooks or running existing notebooks, be sure to check that the notebook is being run with the correct kernel using the `Kernel` menu.

# Code Standards
Toole Design Code Standards [https://github.com/tooledesign/TDG_Code_Standards](https://github.com/tooledesign/TDG_Code_Standards)

# Folder and DB templating

`project_template.py` includes the ability to set up templates for common
analyses in the project folder and in the database. You can see helpful tips
on usage by typing

```
python project_template.py -h
```

**Note** you'll need `tooles` in order to run the templates. In most cases,
this means you'll need to set up your virtualenv first and make sure `tooles`
is installed. Minimum version required is 2.0.1.

# Google Cloud Platform APIs
To use Google Cloud Platform APIs, follow the instructions [here](https://github.com/tooledesign/Google-Cloud-Platform/)
