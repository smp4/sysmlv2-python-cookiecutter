# Developing this project

These instructions are for setting up the development environment.

## First time setup

> This section copies the Getting Started instructions of the [sysmlv2-python-cookiecutter](https://github.com/smp4/sysmlv2-python-cookiecutter) project. They are for first time setup of the SysML development environment.

These instructions are adapted from:

- [SysML-v2-release jupyter `install.sh` script](https://github.com/Systems-Modeling/SysML-v2-Release/blob/master/install/jupyter/install.sh)
- [SysML-v2-pilot-implementation `org.omg.sysml.jupyter.kernel` README](https://github.com/Systems-Modeling/SysML-v2-Pilot-Implementation/tree/master/org.omg.sysml.jupyter.kernel)


### Prerequisites

- A freshly baked project from the [`sysmlv2-python-cookiecutter](https://github.com/smp4/sysmlv2-python-cookiecutter) Cookiecutter template.
- Python 3.8+ (for Jupyter).


### Graphviz

> You only need to perform this step once for your entire machine. Graphviz is installed globally. You don't need to repeat this each time you bake the project from the Cookiecutter template.

Graphviz >= 2.x is needed. Graphviz is called by the Jupyter SysML Kernel to produce diagrams from your SysML code. It will be installed system wide. Follow the system specific instructions at [Graphviz download](https://graphviz.org/download/). For example, for MacOS:

```bash
brew install graphviz
dot -V  # verify version
which dot  # verify path of dot executable
echo $PATH  # verify path of executable is on user path
```


### Java

> You only need to perform this step once for your entire machine. Java is installed globally. You don't need to repeat this each time you bake the project from the Cookiecutter template.

Java >= 17 is needed. It provides the runtime for the Jupyter SysML Kernel, which ingests the textual notation and makes it available for publishing and visualisation.

[Install Java](https://www.java.com/en/download/) following their system instructions. 

An alternative for MacOS is `brew`:

```bash
brew install openjdk
brew info java  # read instructions about the symlink
sudo ln -sfn /opt/homebrew/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
java --version # verify
```

**Note:** If you have a system wide Java runtime already installed, use the path method suggested by `brew info java`. This puts the Java binary first in the user path, so it will be used before any system wide Java. The symlink method used above is convenient (doesn't require adding a path modification to a shell profile), but it will steamroll the system Java.

### Install Jupyter SysML kernel

This installs the Jupyter SysML kernel (stored at `./sysml/jupyter-sysml-kernel`) into the `sysml` Python virtual environment, then links the user SysML model files at `./sysml/models` to the Jupyter SysML kernel.

In the project root directory:

```bash
hatch run sysml:update-kernel
hatch run sysml:create-user-sysml-symlink
```

Running either of these commands will also trigger `hatch` to create the `sysml` Python virtual environment  if it doesn't exist already.


### VS Code: SysIDE CE extension

Find and install the [SysIDE CE extension](https://github.com/sensmetry/sysml-2ls) within VS Code. 

When the VS Code SysIDE extension is installed, it will ask for the `sysml.library` SysML v2 standard library to be located. The extension can download it itself, but this will be an old version and will be installed to your system User directory, to be used in all future SysML projects. 

Instead, it is cleaner to have the library installed per project, so that different versions can be used on a project by project basis, if necessary. This is why the library is provided within the `sysmlv2-python-cookiecutter` project template at `./sysml/sysml.library`.

When asked, direct the extension to use the SysML standard library in your project folder at `./sysml/sysml.library`. Set this as a *Workspace* (that is, project-only) setting. Do not create a User setting for this, in case you want to use different standard library versions in different projects later. 

If you need to reset the path location, search for the extension setting `Syside: Standard Library Path` then disable, restart, then re-enable the extension. It should provide the popup to locate the library again. Enter the path relative to the project root directory, in the VS Code workspace settings.


### VS Code: Jupyter extension

Find and install the `Jupyter` extension within VS Code.


### Start developing!


In VS Code, open the `./sysml/models/mymodel.sysml` demo file. If not done already, the SysIDE plugin should ask you to locate the SysML standard library. Follow the instructions above.

This file is a very basic SysML model written in the SysML v2 textual notation. You should see syntax highlighting, and when you mouseover certain terms, see definitions of those terms. This is the SysIDE plugin in action.

To visualise the model, open the command pallette in VS Code (the search field at the top of the window), type `>Create new jupyter notebook`. 

You may be prompted to select a Python interpreter. Select the Python binary in the `sysml` virtual environment. If your project hasn't modified this template, it will be at `./.venv/sysml/bin/Python`. This requires the virtual environment to be created, which should have happened when you ran the `hatch` commands above. If not, run `hatch env create sysml`.

Next, select the SysML kernel. In the top right corner click "Select Kernel" > Jupyter Kernel, and select `SysML (sysml)`. the kernel will start up, loading the SysML standard library and our user model at `./sysml/models/mymodel.sysml`.

Create a new code cell in the notebook and type `%viz --view=interconnection "PictureTaking"`. This uses the `%viz` "magic" command that comes built in to the Jupyter SysML kernel to call out to Graphviz and generate a figure of our model from our sysml code. Execute the cell and you should see the model as a diagram.

Whenever you update your sysml code in `./sysml/models/`, you **must** restart the sysml kernel in your notebook to force the kernel to ingest the new code before you can access it in the notebook.

Finally, if you want to execute any Python code in your notebook, you will need to add a Python based kernel. We can use the `sysml` Python virtual environment for this. To do so, click the kernel selector button and select the "Python Environments" option, then find the `sysml` virtual environment which probably looks something like `sysml (Python 3.x) .venv/sysml/bin/python`.

Happy system-as-code architecting!


## Updating your project

To check for template updates and apply them, in the project root directory:

```bash
cruft update
```

If the Jupyter SysML Kernel has been updated, you will need to re-install it in your Jupyter installation. A convenience command is available via `hatch` to do this:

```bash
hatch run sysml:update-kernel
hatch run sysml:create-user-sysml-symlink
```

This is the most convenient way to incorporate updates to the SysML standard library and Pilot Implementation Jupyter SysML kernel.


## Advanced setup

> This section copies the Advanced Setup instructions of the [sysmlv2-python-cookiecutter](https://github.com/smp4/sysmlv2-python-cookiecutter) project.


Seasoned Pythonistas can probably figure out everything here themselves. These instructions are for everyone else,  in case you want to understand what is happening when you use the `update-kernel` and `create-user-sysml-symlink` commands, or want to tweak the setup yourself. 

You don't need to do any of this if you want to keep the project in its default configuration and followed the Getting Started instructions. 


### Creating Python virtual environment and dependencies

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


### SysMLv2 standard library

> You don't need to do this ever. It is already provided by the template. When releases to the standard library are available, they will be added to this template, and the template updated. You can update your project to use the latest `sysmlv2-python-cookiecutter` template with `cruft update` in the project root directory. These instructions are only for reference and manual update if you need it.

This is needed by both the SysIDE VS Code extension, and the Jupyter SysMLv2 kernel.

Download the SysMLv2 standard library `sysml.library` from the `SysML-v2-release` repo into its own project directory so that updates can be pulled from the repo as they are released. It's a big repo, so it is more efficient to do a blobless clone (Git will then only download the data then upon `checkout` of the relevant commit). Then copy the `sysml.library` directory into the `sysml` directory in the project.

```bash
git clone --filter=blob:none git@github.com:Systems-Modeling/SysML-v2-Release.git
cd /path/to/template
cp -rf /path/to/sysml.library ./sysml/
```

The standard library at `./sysml/sysml.library` is only used by the sysIDE extension. The Jupyter SysML kernel has its own copy of the standard library in its source files.


### Execution engine: Jupyter SysML Kernel

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


### Accessing user models in Jupyter notebooks

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
