# transifex-tools
Tools to download, backup compare and patch translations of Transifex.

Herramientas para descargar, respaldar, comparar y parchar traducciones de Transifex.

<table style="width:100%">
  <tr>
    <th>
      <img src="https://raw.githubusercontent.com/igatjens/transifex-tools/master/screenshot/file_manager_0001.png" width="400px" height="auto" alt="1" border="0">
    </th>
    <th>
      <img src="https://raw.githubusercontent.com/igatjens/transifex-tools/master/screenshot/file_manager_0004.png" width="400px" height="auto" alt="1" border="0">
    </th>
  </tr>
  <tr>
    <td>
      <img src="https://raw.githubusercontent.com/igatjens/transifex-tools/master/screenshot/terminal_0002.png" width="400px" height="auto" alt="1" border="0">
    </td>
    <td>
      <img src="https://raw.githubusercontent.com/igatjens/transifex-tools/master/screenshot/terminal_0010.png" width="400px" height="auto" alt="1" border="0">
    </td>
  </tr>

</table>


# English


## Get token You
Must obtain a token to log into transifex by console. The client needs a Transifex API token to authenticate. If you don't already have a token, you can generate one at https://www.transifex.com/user/settings/api/.

**The token is a credential to access your transifex account, be careful and do not share it with anyone.**


## Install client
The client is to be used in the terminal, it is installed with the following commands.

`sudo apt install python3-pip git`

`sudo pip install transifex-client`


## Update client
To update the client, run:

`pip install --upgrade transifex-client`

You can also see which version of the client you are currently running with this command:

`tx --version`


## Start client

Run the following command and shorten the transifex token when requested.

`tx init --skipsetup`

**Thefile `~/.transifexrc` contains the token and its transifex access credentials, be careful and do not share it with anyone.**


## Create project repository

Create a folder where you will download the translations and download the files by cloning the repository with the following command.

`git clone https://github.com/igatjens/transifex-tools.git`

Assign scripts execution permissions with the following command.

`cd transifex-tools/ && chmod +x *.sh`

Run **`tx-configure.sh`** to configure all projects.

The configuration is saved in the ** `.tx` ** folder.

The downloaded files are:

1. `project.conf`
2. `tx-configure.sh`
3. `tx-download.sh`
4. `backup-resources.sh`
5. `compare.sh`
6. `generate-translations`
7. `os_translations.conf`
8. `check_os_tranlations_config.sh`
9. `patch-translations.sh`
10. `undo_last_patch-translations.sh`

**`project.conf`** contains the project list, one project per line in the following format.

`project_name = project_ URL`

If you need to add or remove projects, edit **`project.conf`**.

** `os_translations.conf` ** contains the index you specify:
1. The location of the translations downloaded from
transifex.
2. The location of the translations to be patched.
3. The name of the application in transifex
4. If the name of the application in transifex does not match the name of the application in the operating system, the correct name used in the operating system is added.

**`check_os_tranlations_config.sh`** helps find errors in **`os_translations.conf`**.


## Download translations
Run **`tx-download.sh`** to download translations for all projects.

Translations are downloaded to the folder **`translations`**.


## Backup resource
Run **`backup-resources.sh`** and it will create a copy of all the projects in the folder **`backup`**.


## Compare
Run **`compare.sh`** to compare resources between backups and the current translation, and find the resources that have changes.


## Generate translations
Run **`generate-translations.sh`** to generate the .qm and .mo binary files, these are the files used in the system.


## Patch Deepin translations
Run **`patch-translations.sh`** to back up the .qm and .mo binary files, and then add the new translations to the
operating system and Deepin applications.


## Undo the last Deepin translation patch
Run ** `undo_last_patch-translations.sh` ** to undo the last translation patch.



# Español

## Obtener token
Debe obtener un token para iniciar sesión en transifex por consola. El cliente necesita un token API Transifex para autenticarse. Si aún no tiene un token, puede generar uno en https://www.transifex.com/user/settings/api/.

**El token es una credencial de acceso a su cuenta de transifex, sea cuidadoso y no la comparta con nadie.**


## Instalar cliente
El cliente es para usarse en la terminal, se instala con los siguiente comandos.

`sudo apt install python3-pip git`

`sudo pip install transifex-client`


## Actualizar cliente
Para actualizar el cliente, ejecute:

`pip install --upgrade transifex-client`

También puede ver qué versión del cliente está ejecutando actualmente con este comando:

`tx --version`


## Iniciar cliente

Ejecute el siguiente comando y peque el token de transifex cuando lo solicite.

`tx init --skipsetup`

**El archivo `~/.transifexrc` contiene el token y sus credenciales de acceso a transifex, sea cuidadoso y no lo comparta con nadie.**


## Crear repositorio de proyectos

Cree una carpeta donde vaya a descargar las traducciones y descargue los archivo clonando el repositorio con el siguiente comando.

`git clone https://github.com/igatjens/transifex-tools.git`

Asigne permisos de ejecución a los scripts con el siquiente comando.

`cd transifex-tools/ && chmod +x *.sh`

Ejecute **`tx-configure.sh`** para configurar todos los proyectos.

La configuración se guarda en la carpeta **`.tx`**.

Los archivos descargados son:

1. `project.conf`
2. `tx-configure.sh`
3. `tx-download.sh`
4. `backup-resources.sh`
5. `compare.sh`
6. `generate-translations`
7. `os_translations.conf`
8. `check_os_tranlations_config.sh`
9. `patch-translations.sh`
10. `undo_last_patch-translations.sh`

**`project.conf`** contiene la lista de proyectos, un proyecto por línea con el siguiente formato.

`nombre_del_proyecto = URL_del_proyecto`

Si necesita agregar o quitar proyectos, edite **`project.conf`**.

**`os_translations.conf`** contiene el índice que especifia:
1. La ubicación de las traducciones descargadas desde
transifex.
2. La ubicación de las traducciones que se parcharán.
3. El nombre de la aplicacion en transifex
4. Si el nombre de la aplicación en transifex no conincide con el nombre de la aplicación en el sistema operativo, se agrea el nombre correcto usado en el sistema operativo.

**`check_os_tranlations_config.sh`** ayuda a encontrar errores en **`os_translations.conf`**.


## Descargar traducciones
Ejecute **`tx-download.sh`** para descargar las traducciones de todos los proyectos.

Las traducciones se descargan en la carpeta **`translations`**.


## Crear respaldo de recursos
Ejecute **`backup-resources.sh`** y creará una copia de todos los proyectos en la carpeta **`backup`**.


## Comparar
Ejecure **`compare.sh`** para comparar recursos entre los respaldos y la traducción actual, y busca los recursos que tienen cambios.


## Generar traducciones
Ejetute **`generate-translations.sh`** para generar los archivos binarios .qm y .mo, estos son los archivos que se usan en el sistema.


## Parchar traducciones de Deepin
Ejetute **`patch-translations.sh`** para respaldar los archivos binarios .qm y .mo, y luego agregar las nuevas traducciones al 
sistema operativo y a las aplicaciones de Deepin.


## Deshacer el úlimo parche de traducciones de Deepin
Ejetute **`undo_last_patch-translations.sh`** para deshacer el último parche de traducciones.
