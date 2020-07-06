#!/bin/bash

#-This is a bash script for use with transifex


#-==============================================================================
#-                            tx-configure.sh
#-
#-  Author  : Isaías Gatjens M - Twitter @igatjens
#-  Version : v0.2
#-  License : Distributed under the terms of GNU GPL version 2 or later
#-
#-
#-  notes   : 
#-==============================================================================



#Eliminar lineas en blando de projects.conf - #Remove blank lines from projects.conf
sed -i '/^ *$/d' projects.conf

#Hacer una lista de los proyectos - #Make a list of projects
PROJECTS_URL=()
PROJECTS_NAME=()


COUNTER=1
for i in $( cat projects.conf | cut -d "=" -f 2 | sed "s| *||g" ); do
	PROJECTS_URL[COUNTER]=$i
	#echo ${PROJECTS_URL[COUNTER]}
	let COUNTER+=1
done

echo ""
echo "======================================="
echo "Configured projects"

COUNTER=1
for i in $( cat projects.conf | cut -d "=" -f 1 | sed -e "s| |_|g" -e "s|_$||g" ); do
	PROJECTS_NAME[COUNTER]=$i
	echo ${PROJECTS_NAME[COUNTER]}
	let COUNTER+=1
done

PROJECTS_QUANTITY=${#PROJECTS_NAME[@]}
echo ""
echo "Total projects: "$PROJECTS_QUANTITY
echo "======================================="
echo ""

#Iniciar cuenta de transifex - #Init transifex account
tx init --skipsetup

#Configurar cada uno de los proyectos - #Configure each of the projects
for ((i=1; i <= PROJECTS_QUANTITY; i++)); do

	echo ""
	echo "======================================="
	echo "Configuring project "$i of $PROJECTS_QUANTITY"..."
	echo ${PROJECTS_NAME[i]}
	echo ${PROJECTS_URL[i]}
	echo "======================================="
	echo ""

	#Configurar proyecto - #Configure project
	tx config mapping-remote ${PROJECTS_URL[i]}

done
