# SysML v2 Python Cookiecutter

SysMLv2 Python Cookiecutter is a [Cookiecutter](https://www.cookiecutter.io/) template for SysML v2 projects using system-as-code workflows. This template will set up a basic SysML v2 project structure for development with VS Code. 

## Background

The currently recommended way to interact with a SysMLv2 model is via the [Pilot Implementation](https://github.com/Systems-Modeling/SysML-v2-Pilot-Implementation), either in Eclipse or in Jupyter Lab. The Jupyter Lab method is detailed in the [SysML v2 Release](https://github.com/Systems-Modeling/SysML-v2-Release/tree/master/install/jupyter) repository and uses Miniconda.

`SysML v2 Python Cookiecutter` provides a simplified alternative, using just a normal Python virtual environment instead of Miniconda, and keeping the user experience within VS Code for authoring and visualisation of the model.

It is intended to be part of a "system-as-code" workflow, using:

- VS Code for editing.
- [SysIDE](https://github.com/sensmetry/sysml-2ls) VS Code extension for syntax highlighting, based on the SysML v2 Standard Library `sysml.library`, maintained at the latest release from the [SysML v2 Release](https://github.com/Systems-Modeling/SysML-v2-Release) repository.
- Jupyter VS Code extension for visualisation, powered by the `Jupyter SysML Kernel`, maintained at the latest release from the [SysML v2 Pilot Implementation](https://github.com/Systems-Modeling/SysML-v2-Pilot-Implementation) repository.
- Python project and virtual environment management with [Hatch](https://hatch.pypa.io).


## Create a new project

The recommended way to install is with [Cruft](https://cruft.github.io/cruft/), which allows you to update project boilerplate as a Cookiecutter template changes over time. You can also use Cookiecutter to install the template as well.

Install Cruft using a Python package manager:

```bash
pip3 install cruft
```

or with [pipx](https://pipx.pypa.io/latest/):

```bash
pipx install cruft
```

Create the new project:

```bash
cruft create https://github.com/smp4/sysmlv2-python-cookiecutter
```

You will then be asked a series of questions to create the project. Enter the new project directory and continue with the Getting Started instructions in `docs/getting-started.md`.


## Updating an existing project

This Cookiecutter template will be updated over time to include updates to the SysML v2 standard library and Pilot Implementation of the Jupyter SysML Kernel. To pull those updates into your project simply run the following in the project root directory:

```bash
cruft update
```

If the Jupyter SysML Kernel has been updated, you will need to re-install it in your Jupyter installation. A convenience command is available via `hatch` to do this:

```bash
hatch run sysml:update-kernel
```


## Project structure

The system model, written in the SysML v2 textual notation, lives in the `sysml` directory.

Any Python code written for analysis and/ or visualisation can either exist in Jupyter Notebooks, or as Python modules in `src` which are then called by the notebooks. The latter approach is preferred - it is more scalable and allows re-use.

```bash
my-project
├── docs                        # Project documentation
│   └── getting-started.md 
├── src                         # Python analysis code
│   └── my-project
│       ├── __about__.py
│       └── __init__.py
├── sysml                       # SysML files, including system architecture files
│   ├── jupyter-sysml-kernel    # Jupyter kernel files
│   └── sysml.library           # SysML standard library
├── tests                       # Placeholder for tests of Python code in src
│   └── __init__.py
├── README.md                   # Project readme
└── pyproject.toml              # Python project configuration
```


## Philosophy

Objectives:

- Develop the system architecture as code, to be able to bring as much of the tooling, workflows and lessons learnt from decades of Software Engineering in to the world of Systems Engineering. 
- Isolated per-project environments to avoid cross-project dependencies and spurious side-effects.
- Visualise the model in the SysMLv2 graphical notation with graphviz in Jupyter notebooks.
- Optionally perform system analysis with Python.
- Do all of the above within a single free, mature tool - VS Code, including all of the extensions it already brings.

**SysML v2 API**

The SysML v2 API is not implemented. The objective of the API is to support central, tool-agnostic repositories to host a SysML v2 model, and serve it to tool-specific clients. 

In the system-as-code paradigm, our central repository is simply a Git client (GitHub, GitLab or similar). Users then use normal git workflows to collaborate. All modelling is done using the SysML v2 textual notation (code). 

Visualisation is achieved with the Jupyter sysml kernel `%viz` magic function which calls out to `graphviz`.

**Why Python**

There is no rule that a system architecture modelled with SysML v2 needs to be developed within a Python project, nor that the analysis needs to be done using Python. You can use whatever language and tooling you want. 

This repo simply uses Python because it is convenient:

- We need Python (and a Python virtual environment) anyway to install the `jupyter` Python package, which we need in order to have Jupyter, which we need in order to have the Jupyter SysML Kernel. 
- A lot of engineers are already familiar with Python. 
- Structuring the project in a popular language allows us to use the tools of that ecosystem to help us with our development (collaboration, testing, etc workflows).


## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## Developing this template

Update the `sysml/sysml.library` standard library and `sysml/jupyter-sysml-kernel` Pilot Implementation Jupyter Kernel per the manual instructions in `docs/getting-started.md`.

Push to the template repository.


## Licensing

The SysML-v2 standard library `sysml.library`, made available in this repository at `./sysml/sysml.library`, is taken from the [SysML v2 Release](https://github.com/Systems-Modeling/SysML-v2-Release) repository. The Jupyter SysML Kernel, made available in this repository at `./sysml/jupyter-sysml-kernel`, is taken from the [SysML v2 Pilot Implementation](https://github.com/Systems-Modeling/SysML-v2-Pilot-Implementation/) repository. 

The SysML standard library and the Jupyter SysML Kernel are licensed by the respective copyright holders listed below under the [GNU Lesser General Public License (LGPL) v3.0](https://choosealicense.com/licenses/lgpl-3.0/) and [GNU General Public License (GPL) v3.0](https://choosealicense.com/licenses/gpl-3.0/) (see `LICENSE-LGPL` and `LICENSE-GPL` files). 

Copyright © 2019-2021 California Institute of Technology (Jet Propulsion Laboratory)
Copyright © 2019-2023 DEKonsult
Copyright © 2019-2021 IncQuery Labs Ltd.
Copyright © 2019-2023 Intercax LLC
Copyright © 2019-2021 Itemis
Copyright © 2019-2021 Maplesoft (Waterloo Maple, Inc.)
Copyright © 2019-2023 Mgnite Inc.
Copyright © 2019-2023 Model Driven Solutions, Inc.
Copyright © 2019-2023 SAF Consulting
Copyright © 2021-2023 Twingineer LLC

Other, original, code in this repository is provided for use under the [MIT License](https://choosealicense.com/licenses/mit/).


## Future Work

- `sysml.library` is duplicated in the kernel directory?