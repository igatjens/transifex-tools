# transifex-tools
Tools to download, backup and compare translations of Transifex


# English


# Get token You
Must obtain a token to log into transifex by console. The client needs a Transifex API token to authenticate. If you don't already have a token, you can generate one at https://www.transifex.com/user/settings/api/.

**The token is a credential to access your transifex account, be careful and do not share it with anyone.**


# Install client
The client is to be used in the terminal, it is installed with the following commands.

`sudo apt install python-pip`
`sudo pip install transifex-client`


# Update client
To update the client, run:

`pip install --upgrade transifex-client`

You can also see which version of the client you are currently running with this command:

`tx --version`


# Start client

Run the following command and shorten the transifex token when requested.

`tx init --skipsetup`

Thefile **`~/.transifexrc`** contains the token and its transifex access credentials, be careful and do not share it with anyone.


# Create project repository
Create a folder where you will download the projects and copy the files there:

1. `project.conf`
2. `tx-configure.sh`
3. `tx-download.sh`
4. `backup-resources.sh`

**`project.conf`** contains the list of projects, one project per line with the following format.

`project_name = project_ URL`

If you need to add or remove projects, edit **`project.conf`**.

Run **`tx-configure.sh`** to configure all projects.

The settings are saved in the folder **`.tx`**.


# Download translations
Run **`tx-download.sh`** to download translations for all projects.

Translations are downloaded to the folder **`translations`**.


# Backup resource
Run **`backup-resources.sh`** and it will create a copy of all the projects in the folder **`backup`**.


# Compare
Run **`compare.sh`** to compare resources between backups and the current translation, and find the resources that have changes.


# Español

