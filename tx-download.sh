#!/bin/bash

#-This is a bash script for use with transifex


#-==============================================================================
#-                            tx-download.sh
#-
#-  Author  : Isaías Gatjens M - Twitter @igatjens
#-  Version : v0.2
#-  License : Distributed under the terms of GNU GPL version 2 or later
#-
#-
#-  notes   : 
#-==============================================================================

#Puede consultar los códigos de idioma en https://www.transifex.com/explore/languages/.
#You can check the language codes at https://www.transifex.com/explore/languages/.

LANGUAGE=es


#Comprobar si pip, git y tx están instalados - #Check if pip, git and tx are installed
if [[ -z $(which pip) ]]; then
	#statements
	echo "The pip command is necessary to download translations."
	echo "Install pip with the following command."
	echo "sudo apt install python-pip"

	exit 1
fi

if [[ -z $(which git) ]]; then
	#statements
	echo "The git command is necessary to download translations."
	echo "Install git with the following command."
	echo "sudo apt install git"

	exit 1
fi

if [[ -z $(which tx) ]]; then
	#statements
	echo "The tx command is necessary to download translations."
	echo "Install tx with the following command."
	echo "sudo pip install transifex-client"

	exit 1
fi

echo -e "
-------------------------------------
The current language code is \"$LANGUAGE\".
-------------------------------------

You can check the language codes at https://www.transifex.com/explore/languages/.

E) EXIT 
C) Change language code

ENTER to continue."

EXIT=0
read EXIT

if [[ "$EXIT" == "e"  ]] || [[ "$EXIT" == "E"  ]]; then
	#statements
	exit 0
elif [[ "$EXIT" == "c"  ]] || [[ "$EXIT" == "C"  ]]; then
	#statements
	echo -e "\nEnter the language code"
	read LANGUAGE

	sed -i "s|^LANGUAGE=.*$|LANGUAGE=$LANGUAGE|" tx-download.sh

	echo -e "\nThe new language code is \"$LANGUAGE\".\n"
	echo "Press ENTER to continue."
	read EXIT
fi


#Hacer una lista de los recursos - #Make a list of resources
RESOURCES_LIST=$( cat .tx/config | grep file_filter | sed -e "s|file_filter = translations/||g" -e "s|/.*$||g" )

RESOURCES_QUANTITY=$( echo $RESOURCES_LIST | wc -w )


echo ""
echo "Configured resources"
echo "---------------------------------------"
echo $RESOURCES_LIST | sed "s| |\n|g"
echo ""
echo "Total resources: "$RESOURCES_QUANTITY
echo "======================================="
echo ""
echo -e "Do you want to download them?
---------------------------------------
N) Do not download and exit.

ENTER to continue."

EXIT=0
read EXIT

if [[ "$EXIT" == "n"  ]] || [[ "$EXIT" == "N"  ]]; then
	#statements
	exit 0
fi

#Descargar cada recurso - #Download each resource
COUNTER=1
for i in $RESOURCES_LIST; do

	echo ""
	echo "======================================="
	echo "Downloading resource "$COUNTER de $RESOURCES_QUANTITY"..."
	echo "Project: "$( echo $i | cut -d "." -f 1)
	echo "Resource: "$( echo $i | sed "s|^.*\.||")
	
	#Descargar recurso - #Download resource
	tx pull -s -l $LANGUAGE -r $i

    echo "======================================="

	let COUNTER=COUNTER+1

done
