[![Code Size](https://img.shields.io/github/languages/code-size/JeanCHilger/automated-requester.svg?colorB=%2379ab00)](#)

# automated-requester
A tool to accomplish some automatic HTTP requests, intended to help testing backend apps.

\*Currently only the POST method is available.

## Usage
To start, clone this repository and enter it. All the commands needed will run inside the repo directory.
```
clone https://github.com/JeanCHilger/automated-requester.git
cd automated-requester
```

#### Workspaces
In order to use the core functionalities of 'automated-requester' you need to create a workspace.

Use `./requester new <workspace-name>` to create new workspaces.

Inside a workspace you have the tools needed to configure requests for your apps (recommended use one workspace per app). Its possible to set URLs, data samples, `curl` options, etc.

#### Management of workspaces
Once created, a workspace can be managed and configured using `./manage <command>` (from inside).

A full list of available commands and their usage can be found typing `./manage help`.

**Note:** Some of the data samples are from [Moby Word Lists by Grady Ward](http://www.gutenberg.org/ebooks/3201).
