#!/bin/bash

#-This is a bash script for use with transifex


#-==============================================================================
#-                            backup-resources.sh
#-
#-  Author  : Isaías Gatjens M - Twitter @igatjens
#-  Version : v0.1
#-  License : Distributed under the terms of GNU GPL version 2 or later
#-
#-
#-  notes   : 
#-==============================================================================



#Eliminar lineas en blando de projects.conf - #Remove blank lines from projects.conf
sed -i '/^ *$/d' projects.conf

#Obtener los nombres de los proyectos - #Get project names
PROJECTS_NAME=()
COUNTER=1
for i in $( cat projects.conf | cut -d "=" -f 1 | sed -e "s| |_|g" -e "s|_$||g" ); do
	#statements
	PROJECTS_NAME[COUNTER]=$i
	echo ${PROJECTS_NAME[COUNTER]}
	let COUNTER+=1
done

PROJECTS_QUANTITY=${#PROJECTS_NAME[@]}

#Obtener la lista de recursos - #Get the resource list
RESOURCES_LIST=$( cat .tx/config | grep file_filter | sed -e "s|file_filter = translations/||g" -e "s|/.*$||g" )
RESOURCES_QUANTITY=$( echo $RESOURCES_LIST | wc -w )


FOLDER_TRADUCTIONS=translations
FOLDER_BACKUP=backup
BACK_NAME=$(date +%Y-%m-%d_%H.%M)

mkdir -p $FOLDER_BACKUP
mkdir -p $FOLDER_BACKUP/$BACK_NAME



#Para cada recurso hacer un respaldo - #For each resource make a backup
COUNTER=1
for i in $RESOURCES_LIST; do
	#statements
	FOLDER_RESOURCE=$i

	
	echo ""
	echo "======================================="
	echo "Backup resource "$COUNTER de $RESOURCES_QUANTITY"... "
	echo "Project: "$( echo $i | cut -d "." -f 1)
	echo "Resource: "$( echo $i | sed "s|^.*\.||")
	echo "---------------------------------------"

	#echo $FOLDER_TRADUCTIONS/$FOLDER_RESOURCE $FOLDER_BACKUP/$BACK_NAME
	cp -ruv $FOLDER_TRADUCTIONS/$FOLDER_RESOURCE $FOLDER_BACKUP/$BACK_NAME
	echo "======================================="
	

	let COUNTER=COUNTER+1

done

echo ""
echo ""
echo "======================================="
echo "Backup on "$FOLDER_BACKUP/$BACK_NAME
echo "Configured projects: "$PROJECTS_QUANTITY
echo "Configured resources: "$RESOURCES_QUANTITY
echo "Backup resources: "$(ls $FOLDER_BACKUP/$BACK_NAME | wc -w) /$(ls $FOLDER_TRADUCTIONS | wc -w)
echo "======================================="
