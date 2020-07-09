#!/bin/bash

#-This is a bash script for use with transifex


#-==============================================================================
#-                            generate-translations.sh
#-
#-  Author  : Isaías Gatjens M - Twitter @igatjens
#-  Version : v0.2
#-  License : Distributed under the terms of GNU GPL version 2 or later
#-
#-
#-  notes   : 
#-==============================================================================

#Comprobar si /usr/lib/qt5/bin/lrelease está instalado - #Check if /usr/lib/qt5/bin/lrelease are installed
if [[ -z $(which /usr/lib/qt5/bin/lrelease) ]]; then
	#statements
	echo "The /usr/lib/qt5/bin/lrelease command is necessary to generate translations files."
	echo "Install /usr/lib/qt5/bin/lrelease with the following command."
	echo "sudo apt install qttools5-dev-tools"

	exit 1
fi

DIR_TRANSLATIONS="translations"
APPLICACION_NAME=""

QM_GENERATOR=/usr/lib/qt5/bin/lrelease
MO_GENERATOR=msgfmt

cd $DIR_TRANSLATIONS

for DIR_APPLICATION in $(ls -d */ | sed "s|/||g"); do
	
	

	#Obtener el nombre de la aplicación - Get applicarion name
	APPLICACION_NAME=$(echo $DIR_APPLICATION | cut -d "." -f 2)
	
	
	echo "======================================="
	echo $DIR_APPLICATION
	echo "======================================="
	#echo $APPLICACION_NAME
	#echo $DIR_TRANSLATIONS
	
	cd $DIR_APPLICATION
	
	ALL_FILES=$( ls -p | grep -v / ) 											#Obtenter solo los archivos 
	ST_FILES=$( echo $ALL_FILES | sed "s| |\n|g" | grep -E "\.[tT][sS]$" )		#Obtenter solo los archivos .ts
	PO_FILES=$( echo $ALL_FILES | sed "s| |\n|g" | grep -E "\.[pP][oO]$" )		#Obtenter solo los archivos .po

	echo "-------FILES-------"
	echo ".ts: "$ST_FILES
	echo -e ".po: "$PO_FILES"\n"

	

	#Generar los archivos .qm - Generate .qm files
	echo ".ts → .qm"
	for i in $ST_FILES; do
		#statements
		LANGUAJE_CODE=$( echo $i| cut -d "." -f 1)
		echo $APPLICACION_NAME"_"$LANGUAJE_CODE".qm"
		$QM_GENERATOR $i -qm $APPLICACION_NAME"_"$LANGUAJE_CODE".qm"
	done

	#Generar los archivos .mo - Generate .mo files
	echo -e "\n.po → .mo"
	for i in $PO_FILES; do
		#statements
		LANGUAJE_CODE=$( echo $i| cut -d "." -f 1)
		mkdir -p $LANGUAJE_CODE
		mkdir -p $LANGUAJE_CODE"/LC_MESSAGES"
		echo $LANGUAJE_CODE"/LC_MESSAGES/"$APPLICACION_NAME".mo"
		$MO_GENERATOR $i -o $LANGUAJE_CODE"/LC_MESSAGES/"$APPLICACION_NAME".mo"
	done

	echo "======================================="
	echo -e "\n\n"

	cd ..

done

cd ..