# Advanced Setup

> These instructions are also in the `docs/DEVELOPING.md` file of a freshly baked project.

Seasoned Pythonistas can probably figure out everything here themselves. These instructions are for everyone else,  in case you want to understand what is happening when you use the `update-kernel` and `create-user-sysml-symlink` commands, or want to tweak the setup yourself. 

You don't need to do any of this if you want to keep the project in its default configuration and followed the Getting Started instructions. 


## Creating Python virtual environment and dependencies

Create a Python virtual environment to install and run `Jupyter`. This project uses `hatch` by default to manage this, but you can also create the environment using any tool of your choice. The remainder of these instructions assumes hatch.

For `hatch`, there is already a virtual environment called `sysml` configured in `pyproject.toml`:

```toml
[tool.hatch.envs.sysml]
dependencies = [
  "jupyter",
]
```

Activate the environment as needed with:

```bash
hatch -e sysml shell
which python3
exit
```


## SysMLv2 standard library

> You don't need to do this ever. It is already provided by the template. When releases to the standard library are available, they will be added to this template, and the template updated. You can update your project to use the latest `sysmlv2-python-cookiecutter` template with `cruft update` in the project root directory. These instructions are only for reference and manual update if you need it.

This is needed by both the SysIDE VS Code extension, and the Jupyter SysMLv2 kernel.

Download the SysMLv2 standard library `sysml.library` from the `SysML-v2-release` repo into its own project directory so that updates can be pulled from the repo as they are released. It's a big repo, so it is more efficient to do a blobless clone (Git will then only download the data then upon `checkout` of the relevant commit). Then copy the `sysml.library` directory into the `sysml` directory in the project.

```bash
git clone --filter=blob:none git@github.com:Systems-Modeling/SysML-v2-Release.git
cd /path/to/template
cp -rf /path/to/sysml.library ./sysml/
```

The standard library at `./sysml/sysml.library` is only used by the sysIDE extension. The Jupyter SysML kernel has its own copy of the standard library in its source files.


## Execution engine: Jupyter SysML Kernel

> You don't need to follow these steps manually. They are executed automatically when you run `hatch run sysml:update-kernel` from the project root directory. The Jupyter SysML kernel source files at `./sysml/jupyter-sysml-kernel` will be updated in the template when updates to the Pilot Implementation are released. You can update your project to the latest `sysmlv2-python-cookiecutter` template with `cruft update` in the project root directory. These instructions are for reference and manual update if you need it. 

The [SysML-v2-Pilot-Implementation](https://github.com/Systems-Modeling/SysML-v2-Pilot-Implementation/) created an execution engine for Jupyter notebooks. It is in the Pilot Implementation repo at `./org.omg.sysml.jupyter.kernel`. The following instructions follow the [Jupyter Kernel README](https://github.com/Systems-Modeling/SysML-v2-Pilot-Implementation/tree/master/org.omg.sysml.jupyter.kernel). 

Go to [https://github.com/Systems-Modeling/SysML-v2-Pilot-Implementation](https://github.com/Systems-Modeling/SysML-v2-Pilot-Implementation) > Releases, and download the latest packaged distribution `sysml-jupyter-kernel-$version.zip`. Unzip to a temporary directory. You should be able to see `install.py` and the `sysml/` directory. 

Run the `install.py` installer, configuring the kernel installation. Execute the following from the project root directory.

```bash
hatch -e sysml shell
which python3  # confirm we are using the python in the virtual env
python3 /path/to/install.py -h  # list configuration options
python3 /path/to/install.py --sys-prefix  # installs to the directory of the python virtual environment
jupyter kernelspec list  # verify
```

Then delete the extracted directory and files.

To uninstall the kernel

```bash
hatch -e sysml shell
jupyter kernelspec remove sysml
```


## Accessing user models in Jupyter notebooks

> You don't need to do this. It is already done when you run `hatch run sysml:create-user-sysml-symlink` from the project root directory. These instructions are only for reference and manual update if you need it. 

The SysML kernel for Jupyter in the Pilot Implementation was not designed to allow adding user-defined libraries to the kernel (see [#430](https://github.com/Systems-Modeling/SysML-v2-Pilot-Implementation/issues/430)). It was designed for SysML models to be ingested by executing their textual notation within a notebook. This means that the code developed in `./sysml/models` is not accessible to the Jupyter SysML kernel for publishing to an API service with `%publish` or producing diagrams with `%viz`. 

We can get a rid this with a small hack. `.sysml` files placed in the `sysml.library/Domain Libraries` directory within the SysML kernels installation directory will be read in when the Kernel is started (either upon a notebook being opened, or the Kernel being manually refreshed). 

In this project template, the Jupyter SysML kernel is installed in a virtual environment. Being a virtual environment, it is ephemeral - it can be created and destroyed any time, and we don't check virtual environment files into source control. We want to store our `.sysml` files in the project directory at `sysml/models`. We can use a symlink to create a link in the kernel installation directory to our model files in the project directory. 

On a Unix/ Linux machine:

```bash
cd /path-to-venvs-directory/sysml/share/jupyter/kernels/sysml/sysml.library/Domain\_Libraries # create the link while you are inside the "Domain Libraries" dir
ln -sFf ../../../../../../../sysml/models user_models  ## recurse as far up as necessary to reach project root
```

An example if your project conforms to the cookiecutter template:

```bash
cd .venv/sysml/share/jupyter/kernels/sysml/sysml.library/Domain\ Libraries  # from project root
ln -sFf ../../../../../../../../sysml/model user_models
ls -al  # verify
```

Now start a new notebook, or restart the `sysml` kernel in an existing notebook, and any `.sysml` files in the `sysml/models` directory in the project root will be loaded for use in the notebook.

**Alternative if you don't, or can't use symlink**

Manually load the code into a cell within the notebook and execute the cell. We can manually load the code either by copy/ pasting it in, or by using the [`%load`](https://ipython.org/ipython-doc/dev/interactive/magics.html#magic-load) IPython [magic](http://ipython.org/ipython-doc/dev/interactive/tutorial.html#magic-functions)function.

Note that running `%load` requires a Python kernel to be running in the notebook.

Then in a Python code cell in the notebook:

```bash
%load ./sysml/models/mymodel.sysml
```

Execute the cell to load the code into the cell. Now switch the kernel back to a SysML kernel and execute the cell (you will need to delete the `%load` line first).

You can now interact with your user code within `sysml` cells in the notebook.
