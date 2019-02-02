[![Release Version](https://img.shields.io/github/release/jeanchilger/automated-requester.svg?colorB=%23ba5b3f)](#)
[![Code Size](https://img.shields.io/github/languages/code-size/JeanCHilger/automated-requester.svg?colorB=%2379ab00)](#)

# automated-requester
A tool to accomplish some automatic HTTP requests, intended to help testing backend apps.

\*Currently the methods available are: GET, POST, PUT, DELETE.

## Usage
To start, clone this repository and enter it. All the commands needed will run inside the repo directory.
```
clone https://github.com/JeanCHilger/automated-requester.git
cd automated-requester
```

#### About parameter files
A parameter file is a `.txt` file with the name of the desired HTTP parameter, that is, the name of a parameter file is in the form: `parameter-key.txt`. 

- If the required parameter needs to be a **text (string)** get some desired values for this key and put one in each line of the file, so the requester will choose one randomly, hence the parameters will be populated automatically.
- If the required parameter needs to be a **random number**, put this in the first line: `__TYPE@RANDOMNUMBER__` then in the second line the minimun desired value and in the third put the maximun desired value.
- If the parameter must be a path variable put this in the first line: `__TYPE@PATHVAR__` and in the rest of the file proceed as described in the two above items, but starting from second line instead of the first.

#### Workspaces
In order to use the core functionalities of 'automated-requester' you need to create a workspace.

Use `./requester.sh new <workspace-name>` to create new workspaces.

Inside a workspace you have the tools needed to configure requests for your apps (recommended use one workspace per app). Its possible to set URLs, data samples, `curl` options, etc.

#### Management of workspaces
Once created, a workspace can be managed and configured using `./manage.sh <command>` (from inside). Most of the subcommands (related to configuration purposes) require a mandatory option `-m <method>` to specify the targeted method.

The currently available commands are:

- `./manage.sh run <method>`: Sends the HTTP request for the specified `<method>`.
- `./manage.sh showconfig <method>`: Displays the current configurations for the specified `<method>`.
- `./manage.sh -h`: Prompts a help message with a list of available commands and their usage.
- `./manage.sh header <header> -m <method>`: Adds a header to `<method>` configuration file.
- `./manage.sh param <path> -m <method>`: Adds a new parameter file from `<path>` to the `<method>` parameter list.
- `./manage.sh url <url> -m <method>`: Sets the URL target for the request of the `<method>` method.
- `./manage.sh verbose <option> -m <method>`: Whether or not use the verbose option (`-v`) of the `curl` command when sending a `<method>` request.

**Note:** Some of the data samples are from [Moby Word Lists by Grady Ward](http://www.gutenberg.org/ebooks/3201).
