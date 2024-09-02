## Project Overview

This is a command-line tool designed for generating the folder structure of Flutter projects following the Clean Architecture principles. It automates the creation of necessary folders and files, enabling developers to quickly set up their project architecture and enhance their development efficiency.

## Installation

```shell
dart pub global activate --source git https://github.com/Invincible1996/clean_arc.git
```

## Setup (Currently supports Mac and Linux only)

Open your `bash_profile` or `zshrc` file and add the following line:

```shell
export PATH="$PATH":"$HOME/.pub-cache/bin"
```

## Usage

To create a feature module named `test_user`, including the data, domain, and presentation layers, use:

```shell
clean_arc --feature test_user
```

To generate the basic project structure for Flutter Clean Architecture

```shell
clean_arc --framework
```

To automatically generate data models and data source files based on your Swagger API definition, use:

```shell
clean_arc --api your swagger url
```
