# Getting Started

This article takes you through the first time setup.


## Prerequisites

- Project baked from the [`sysmlv2-python-cookiecutter](https://github.com/smp4/sysmlv2-python-cookiecutter) Cookiecutter template.
- Python 3.8+ (for Jupyter).

These prerequisites are taken from:

- [SysML-v2-release jupyter `install.sh` script](https://github.com/Systems-Modeling/SysML-v2-Release/blob/master/install/jupyter/install.sh)
- [SysML-v2-pilot-implementation `org.omg.sysml.jupyter.kernel` README](https://github.com/Systems-Modeling/SysML-v2-Pilot-Implementation/tree/master/org.omg.sysml.jupyter.kernel)


## Create Python environment and dependencies

> You need to perform this step for every project that uses this template.

Create a Python virtual environment to install and run `Jupyter`. This project uses `hatch` by default to manage this, but you can also create the environment using any tool of your choice. The remainder of these instructions will continue to use hatch.

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


## Graphviz

> You only need to perform this step once for your entire machine. Graphviz is installed globally.

Graphviz >= 2.x is needed. It is called by the Jupyter Sysml Kernel to produce diagrams from your SysML code. It will be installed system wide. Follow the system specific instructions at [Graphviz download](https://graphviz.org/download/). For example, for MacOS:

```bash
brew install graphviz
dot -V  
which dot  # verify path of dot executable
echo $PATH  # verify path of executable is on user path
export PATH="${PATH}:/usr/local/bin"  # only if the above shows dot -V "not found"
```


## Java

> You only need to perform this step once for your entire machine. Java is installed globally.

Java >= 17 is needed. It provides the runtime for the Jupyter SysML Kernel, which ingests the textual notation and makes it available for publishing and visualisation.

[Install Java](https://www.java.com/en/download/) following their system instructions. 

A good alternative for MacOS is `brew`:

```bash
brew install openjdk
brew info java  # read instructions about the symlink
sudo ln -sfn /opt/homebrew/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
java --version # verify
```

**Note:** If you have a system wide Java runtime already installed, use the path method suggested by `brew info java`. This puts the Java binary first in the user path, so it will be used before any system wide Java. The symlink method used above is convenient (doesn't require adding a path modification to a shell profile), but it will steamroll the system Java.


## SysMLv2 standard library

> You don't need to do this ever. It is already done within the template. These instructions are for reference and manual update if you need it.

This is needed by both the SysIDE VS Code extension, and the Jupyter SysMLv2 kernel.

Download the SysMLv2 standard library `sysml.library` from the `SysML-v2-release` repo into its own project directory so that updates can be pulled from the repo as they are released. It's a big repo, so it is more efficient to do a blobless clone (Git will then only download the data then upon `checkout` of the relevant commit). Then copy the `sysml.library` directory into the `sysml` directory in the project.

```bash
git clone --filter=blob:none git@github.com:Systems-Modeling/SysML-v2-Release.git
cd /path/to/template
cp -rf /path/to/sysml.library ./sysml/
```

## Execution engine: Jupyter SysML Kernel

> You don't need to do this ever. It is already done within the template. These instructions are for reference and manual update if you need it. 

The [SysML-v2-Pilot-Implementation](https://github.com/Systems-Modeling/SysML-v2-Pilot-Implementation/) created an execution engine for Jupyter notebooks. It is in the Pilot Implementation repo at `./org.omg.sysml.jupyter.kernel`. The following instructions follow the [Jupyter Kernel README](https://github.com/Systems-Modeling/SysML-v2-Pilot-Implementation/tree/master/org.omg.sysml.jupyter.kernel). 

Go to [https://github.com/Systems-Modeling/SysML-v2-Pilot-Implementation](https://github.com/Systems-Modeling/SysML-v2-Pilot-Implementation) > Releases and download the latest packaged distribution `sysml-jupyter-kernel-$version.zip`. Unzip to a temporary directory. You should be able to see `install.py` and the `sysml/` directory. 

Run the `install.py` installer, configuring the kernel installation. Execute the following from the project root directory.

```bash
hatch -e sysml shell
which python3  # confirm we are using the python in the virtual env
python3 /path/to/install.py -h  # list configuration options
python3 /path/to/install.py --sys-prefix  # installs to the directory of the python virtual environment
jupyter kernelspec list  # verify
```

Then delete the extracted directory and files.

With the Jupyter SysML Kernel already provided by the template in `sysml/jupyter-sysml-kernel`, you can achieve the same effect just by using the convenience command `hatch run sysml:update-kernel`.

To uninstall the kernel

```bash
hatch -e sysml shell
jupyter kernelspec remove sysml
```


## VS Code Extension: SysIDE CE edition

> You only need to do this once globally. VS Code will keep the extension installed globally.

When the VS Code SysIDE extension is installed, it will ask for the `sysml.library` SysML v2 standard library to be located. The extension can download it itself, but this will be an old version and will be installed to your user directory, to be used in all sysml project. It is cleaner to have the library installed per project, so that different versions can be used (if necessary). This is why the library is provided within the cookiecutter project template.


[Install the SysIDE CE extension](https://github.com/sensmetry/sysml-2ls) from within VS Code. Direct it to use the sysml library in your project folder. Set this as a *Workspace* (ie per project) setting. Do not create a User setting for this.
  
If you need to reset the path location, search for the extension setting `Syside: Standard Library Path` then disable, restart, then re-enable the extension. It should provide the popup to locate the library again.



## VS Code Extension: Jupyter

Find and install the extension within VS Code.

In the top search bar of VS Code, type ‘>Python Select Interpreter’, find the `sysml` virtual environment created with `hatch`. This environment has the `Jupyter` Python package installed in it, which has the SysML kernel.


## Start developing!

Open the command pallette in VS Code, type `>create new jupyter notebook`. Select the `SysML (base)` kernel: in the top right corner > Jupyter Kernel > sysml


## Updating this template

```bash
cruft update
hatch run sysml:update-kernel
```
