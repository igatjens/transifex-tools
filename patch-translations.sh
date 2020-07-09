#!/bin/bash

#-This is a bash script for use with transifex


#-==============================================================================
#-                            patch-translations.sh
#-
#-  Author  : Isaías Gatjens M - Twitter @igatjens
#-  Version : v0.2
#-  License : Distributed under the terms of GNU GPL version 2 or later
#-
#-
#-  notes   : 
#-==============================================================================

#Obtener la lista de recursos para parchar
LIST_OF_PATCH=$(grep -E -v "^ *#|none" os_translations.conf | sed -e 's/  *//g; s/\t\t*/;/g')

TRANSLATIONS_DIR=translations/
MO_FILES_OS_DIR=/usr/share/locale/

COUNT=1
TOTAL_RESOURCES=$( echo $LIST_OF_PATCH | wc -w)
#Para cada recurso
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
	
	#si la carpeta del recurso existe
	if [[ -d $DIR_RESOURCES ]]; then
		#statements

		cd $DIR_RESOURCES

		QM_FILES=$(ls *.qm 2> /dev/null)
		MO_FOLDERS=$( ls -d */ 2> /dev/null)
		#echo $MO_FOLDERS

		#si la carpeta de la aplicación existe
		if [[ -d $DIR_SYSTEM ]]; then
			#statements
			#si encuentra archivos .qm
			if [[ $QM_FILES ]]; then
				#statements
				for NAME_FILE in $QM_FILES; do
					#statements

					FIX_NAME_FILE=""
					QM_FILES_OS=""

					#si hay FIX_APP_NAME aplicar FIX_APP_NAME
					if [[ $FIX_APP_NAME ]]; then
						#statements
						#echo Existe un fix_name
						#echo j--- $NAME_FILE
						TAIL_NAME_FILE=$( echo $NAME_FILE | sed "s|.*_|_|")
						#echo tali $TAIL_NAME_FILE
						FIX_NAME_FILE=$FIX_APP_NAME$TAIL_NAME_FILE
						#echo full $FIX_NAME_FILE
						QM_FILES_OS=$DIR_SYSTEM$FIX_NAME_FILE

					else
						QM_FILES_OS=$DIR_SYSTEM$NAME_FILE
					fi

					#Borrar el _en del nombre de archivo
					#QM_FILES_OS=$( echo $QM_FILES_OS | sed "s|_en.qm|.qm|" )

					#si los archivos .qm existen en el sistema, haga un respaldo
					if [[ -f $QM_FILES_OS ]]; then
						#statements
						echo Backup $QM_FILES_OS"_"$(date +%Y-%m-%d_%H.%M.%S)
						sudo mv $QM_FILES_OS $QM_FILES_OS"_"$(date +%Y-%m-%d_%H.%M.%S)
					else
						echo Notice: The $QM_FILES_OS file does not exists 
					fi
					echo Copy $NAME_FILE → $QM_FILES_OS
					sudo cp -u $NAME_FILE $QM_FILES_OS

				done
					
			else
				echo Notice: .qm files not found in $DIR_RESOURCES
			fi

		else
			echo Error: Folder $DIR_SYSTEM does not exist.
		fi


		if [[ $MO_FOLDERS ]]; then
			#statements
			echo -e "\nPatching .mo files"
			echo "-----------------------------------------------"
		fi

		
		for MO in $MO_FOLDERS; do
			#Si existe LC_MESSAGES
			if [[ -d $MO/LC_MESSAGES ]]; then
				#statements
				cd $MO/LC_MESSAGES
				MO_FILES=$(ls *.mo 2> /dev/null)
				#echo .mo files $MO$MO_FILES
				MO_FILE_OS=""

				TAIL_NAME_FILE=""
				FIX_NAME_FILE=""
				#si hay FIX_APP_NAME aplicar FIX_APP_NAME
				if [[ $FIX_APP_NAME ]]; then
					#statements
					TAIL_NAME_FILE=$( echo $MO_FILES | sed "s|.*\.mo|\.mo|")
					#echo tali $TAIL_NAME_FILE
					FIX_NAME_FILE=$FIX_APP_NAME$TAIL_NAME_FILE
					#echo full $FIX_NAME_FILE
				
					MO_FILE_OS=$(echo $MO_FILES_OS_DIR$MO"LC_MESSAGES/"$FIX_NAME_FILE)

				else
					MO_FILE_OS=$(echo $MO_FILES_OS_DIR$MO"LC_MESSAGES/"$MO_FILES)
				fi
				
				
				#si los archivos .mo existen en el sistema, haga un respaldo
				if [[ -f $MO_FILE_OS ]]; then
					#statements
					echo Backup $MO_FILE_OS"_"$(date +%Y-%m-%d_%H.%M.%S)
					sudo mv $MO_FILE_OS $MO_FILE_OS"_"$(date +%Y-%m-%d_%H.%M.%S)
				else
					echo Notice: The $MO_FILE_OS file does not exists 
				fi

				echo Copy $MO_FILES → $MO_FILE_OS
				sudo cp -u $MO_FILES $MO_FILE_OS

				cd ../..
			else
				echo Error: LC_MESSAGES folder not found in $DIR_RESOURCES$MO
			fi
		done

		cd ../..
	else
		echo Error: Folder $DIR_RESOURCES does not exist.
	fi

	echo -e "===============================================\n\n"

	let COUNT=COUNT+1

done