# Getting Started

> These instructions are also in the `docs/DEVELOPING.md` file of a freshly baked project.

This article provides instructions on how to set up a SysML v2 development environment with Jupyter and VS Code.

These instructions are adapted from:

- [SysML-v2-release jupyter `install.sh` script](https://github.com/Systems-Modeling/SysML-v2-Release/blob/master/install/jupyter/install.sh)
- [SysML-v2-pilot-implementation `org.omg.sysml.jupyter.kernel` README](https://github.com/Systems-Modeling/SysML-v2-Pilot-Implementation/tree/master/org.omg.sysml.jupyter.kernel)


## Prerequisites

- A freshly baked project from the [`sysmlv2-python-cookiecutter](https://github.com/smp4/sysmlv2-python-cookiecutter) Cookiecutter template.
- Python 3.8+ (for Jupyter).


## Graphviz

> You only need to perform this step once for your entire machine. Graphviz is installed globally. You don't need to repeat this each time you bake the project from the Cookiecutter template.

Graphviz >= 2.x is needed. Graphviz is called by the Jupyter SysML Kernel to produce diagrams from your SysML code. It will be installed system wide. Follow the system specific instructions at [Graphviz download](https://graphviz.org/download/). For example, for MacOS:

```bash
brew install graphviz
dot -V  # verify version
which dot  # verify path of dot executable
echo $PATH  # verify path of executable is on user path
```


## Java

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

## Install Jupyter SysML kernel

This installs the Jupyter SysML kernel (stored at `./sysml/jupyter-sysml-kernel`) into the `sysml` Python virtual environment, then links the user SysML model files at `./sysml/models` to the Jupyter SysML kernel.

In the project root directory:

```bash
hatch run sysml:update-kernel
hatch run sysml:create-user-sysml-symlink
```


## VS Code: SysIDE CE extension

Find and install the [SysIDE CE extension](https://github.com/sensmetry/sysml-2ls) within VS Code. 

When the VS Code SysIDE extension is installed, it will ask for the `sysml.library` SysML v2 standard library to be located. The extension can download it itself, but this will be an old version and will be installed to your system User directory, to be used in all future SysML projects. 

Instead, it is cleaner to have the library installed per project, so that different versions can be used on a project by project basis, if necessary. This is why the library is provided within the `sysmlv2-python-cookiecutter` project template at `./sysml/sysml.library`.

When asked, direct the extension to use the SysML standard library in your project folder at `./sysml/sysml.library`. Set this as a *Workspace* (that is, project-only) setting. Do not create a User setting for this, in case you want to use different standard library versions in different projects later. 

If you need to reset the path location, search for the extension setting `Syside: Standard Library Path` then disable, restart, then re-enable the extension. It should provide the popup to locate the library again.


## VS Code: Jupyter extension

Find and install the `Jupyter` extension within VS Code.


## Start developing!


In VS Code, open the `./sysml/models/mymodel.sysml` demo file. If not done already, the SysIDE plugin should ask you to locate the SysML standard library. Follow the instructions above.

This file is a very basic SysML model written in the SysML v2 textual notation. You should see syntax highlighting, and when you mouseover certain terms, see definitions of those terms. This is the SysIDE plugin in action.

To visualise the model, open the command pallette in VS Code (the search field at the top of the window), type `>Create new jupyter notebook`. 

Next, select the SysML kernel. In the top right corner click "Select Kernel" and select `SysML (sysml)`. the kernel will start up, loading the SysML standard library and our user model at `./sysml/models/mymodel.sysml`.

Create a new code cell in the notebook and type `%viz --view=interconnection "PictureTaking"`. This uses the `%viz` "magic" command that comes built in to the Jupyter SysML kernel to call out to Graphviz and generate a figure of our model from our sysml code. Execute the cell and you should see the model as a diagram.

Whenever you update your sysml code in `./sysml/models/`, you **must** restart the sysml kernel in your notebook to force the kernel to ingest the new code before you can access it in the notebook.

Finally, if you want to execute any Python code in your notebook, you will need to add a Python based kernel. We can use the `sysml` Python virtual environment for this. To do so, click the kernel selector button and select the Python option, which probably looks something like `sysml (Python 3.x) .venv/sysml/bin/python` option.

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
