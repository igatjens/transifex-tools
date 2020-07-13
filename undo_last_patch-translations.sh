#!/bin/bash

#-This is a bash script for use with transifex


#-==============================================================================
#-                      undo_last_patch-translations.sh
#-
#-  Author  : Isaías Gatjens M - Twitter @igatjens
#-  Version : v0.2
#-  License : Distributed under the terms of GNU GPL version 2 or later
#-
#-
#-  notes   : 
#-==============================================================================

#Obtente idiomas parchados - Get patched languages
#ls *.qm_* | sed 's/\.qm_.*/\.qm/g' | uniq

#Obtener último parche - Get last patch
#ls dde-desktop_es.qm_* | sort -r | sed -n 1p

#Obtener la lista de recursos para parchar - Get the patch resource list
LIST_OF_PATCH=$(grep -E -v "^ *#|none" os_translations.conf | sed -e 's/  *//g; s/\t\t*/;/g')

TRANSLATIONS_DIR=$(pwd)/translations/
MO_FILES_OS_DIR=/usr/share/locale/

COUNT=1
TOTAL_RESOURCES=$( echo $LIST_OF_PATCH | wc -w)
#Para cada recurso - For each resource
for i in $LIST_OF_PATCH; do
	#statements
	#echo $i
	DIR_RESOURCES=$TRANSLATIONS_DIR$(echo $i | cut -d ";" -f 1)/
	DIR_SYSTEM=$(echo $i | cut -d ";" -f 2)
	APP_NAME=$(echo $i | cut -d ";" -f 3)
	FIX_APP_NAME=$(echo $i | cut -d ";" -f 4)

	echo "==============================================="
	#echo $DIR_RESOURCES
	#echo $DIR_SYSTEM
	echo $APP_NAME $COUNT of $TOTAL_RESOURCES
	#echo $FIX_APP_NAME
	echo "-----------------------------------------------"
	
	#Si la carpeta del recurso existe - If the resource folder exists
	if [[ -d $DIR_RESOURCES ]]; then
		#statements



		QM_FILES=$(ls *.qm 2> /dev/null)
		MO_FOLDERS=$( ls -d */ 2> /dev/null)
		#echo $MO_FOLDERS

		#Si la carpeta de la aplicación existe - If the application folder exists
		if [[ -d $DIR_SYSTEM ]]; then

			cd $DIR_SYSTEM

			echo $DIR_SYSTEM

			LANG_PATCH=""
			#Obtente idiomas parchados - Get patched languages
			if [[ $( echo $DIR_SYSTEM | grep LC_MESSAGES ) ]]; then

				FILE_NAME=""
				if [[ $FIX_APP_NAME ]]; then
					
					FILE_NAME=$FIX_APP_NAME

				else
					FILE_NAME=$APP_NAME
				fi

				LANG_PATCH=$( ls $FILE_NAME.mo_* 2> /dev/null | sed 's/\.mo_.*/\.mo/g' | uniq )
				#read teclas
			else
				
				LANG_PATCH=$( ls *.qm_* 2> /dev/null | sed 's/\.qm_.*/\.qm/g' | uniq )
			fi


			if [[ ! $LANG_PATCH ]]; then

				echo Not patch backup found
			fi
			
			#echo $LANG_PATCH
			
			#Deshacer el últio parche - Undo the last patch
			for j in $LANG_PATCH; do

				LAST_BACKUP_PATCH=$(ls $j"_"* 2> /dev/null | sort -r | sed -n 1p)

				if [[ $LAST_BACKUP_PATCH ]]; then

					echo $LAST_BACKUP_PATCH → $j
					sudo rm $j
					sudo mv $LAST_BACKUP_PATCH $j

				else
					echo Not patch backup found
				fi

			done


		else
			echo Error: Folder $DIR_SYSTEM does not exist.
		fi


	else
		echo Error: Folder $DIR_RESOURCES does not exist.
	fi

	echo -e "===============================================\n\n"

	let COUNT=COUNT+1

done