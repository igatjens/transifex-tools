#!/bin/bash

#-This is a bash script for use with transifex


#-==============================================================================
#-                            compare.sh
#-
#-  Author  : Isaías Gatjens M - Twitter @igatjens
#-  Version : v0.2
#-  License : Distributed under the terms of GNU GPL version 2 or later
#-
#-
#-  notes   : 
#-==============================================================================

#Comprobar si diff y diffuse están instalados - #Check if diff and diffuse are installed
if [[ -z $(which diffuse) ]]; then
	#statements
	echo "The diffuse application is necessary to compare files."
	echo "Install diffuse with the following command."
	echo "sudo apt install diffuse"

	exit 1
fi

if [[ -z $(which diff) ]]; then
	#statements
	echo "The diff command is necessary to compare files."
	echo "Install diff with the following command."
	echo "sudo apt install diffutils"

	exit 1
fi


EXIT=0
until [[ "$EXIT" -eq "1" ]]; do
	#statements

	TRANSLATION_CURRENT=translations
	TRANSLATION_BACKUP=backup
	VERSIONS=()

	COUNTER=1
	for i in $(ls $TRANSLATION_BACKUP); do
		#statements

		VERSIONS[COUNTER]=$i

		let COUNTER+=1
	done
	#Agregar la versión actual - #Add current version
	VERSIONS[COUNTER]=$TRANSLATION_CURRENT


	VERSIONS_QUANTITY=${#VERSIONS[@]}

	#Mostrar versiones - #Show versions
	echo ""
	echo "---------------------------------------"
	echo "Versions"
	echo "======================================="
	echo ""
	for (( i=1; i<=VERSIONS_QUANTITY; i++ )); do
		#statements
		if [[ "$i" -eq "$VERSIONS_QUANTITY" ]]; then
			#statements
			echo -e $i")  Current transtations"
		else
			echo -e $i") " ${VERSIONS[i]}
		fi
	done

	echo "0)  EXIT"

	FIRST_SELECTION=0
	SECOND_SELECTION=0

	echo "Choose the first version to compare"

	read FIRST_SELECTION

	#Si escogió salir - #If you chose to exit
	if [[ "$FIRST_SELECTION" -eq "0"  ]]; then
		EXIT=1
	else
		echo "Choose the second version to compare"

		read SECOND_SELECTION

		#Si escogió salir - #If you chose to exit
		if [[ "$SECOND_SELECTION" -eq "0"  ]]; then
			EXIT=1
		else
			FOLDER_FIRST_SELECTION=0
			FOLDER_SECOND_SELECTION=0

			#Ajustar la ruta para la traducción actual que no está dentro de la carpeta backup
			#Set the path for the current translation that is not inside the backup folder
			if [[ "$FIRST_SELECTION" -eq "$VERSIONS_QUANTITY" ]]; then
				FOLDER_FIRST_SELECTION=${VERSIONS[FIRST_SELECTION]}
			else
				FOLDER_FIRST_SELECTION=$TRANSLATION_BACKUP/${VERSIONS[FIRST_SELECTION]}
			fi

			#Ajustar la ruta para la traducción actual que no está dentro de la carpeta backup
			#Set the path for the current translation that is not inside the backup folder
			if [[ "$SECOND_SELECTION" -eq "$VERSIONS_QUANTITY" ]]; then
				FOLDER_SECOND_SELECTION=${VERSIONS[SECOND_SELECTION]}
			else
				FOLDER_SECOND_SELECTION=$TRANSLATION_BACKUP/${VERSIONS[SECOND_SELECTION]}
			fi

			#echo $FOLDER_FIRST_SELECTION $FOLDER_SECOND_SELECTION

			#Buscar archivos diferentes - #Find different files
			DIFFERENT_FILE_LIST=$( diff -r $FOLDER_FIRST_SELECTION $FOLDER_SECOND_SELECTION | grep ^diff | cut -d " " -f 3,4 )
			DIFFERENT_FILE_PAIRS=$( echo $DIFFERENT_FILE_LIST | wc -w )
			let DIFFERENT_FILE_PAIRS=DIFFERENT_FILE_PAIRS/2

			#echo $DIFFERENT_FILE_LIST
			#echo $DIFFERENT_FILE_PAIRS

			FILES_1=()
			FILES_2=()
			i=1
			TURN=0
			for j in $DIFFERENT_FILE_LIST; do
				#statements
				if [[ "$TURN" -eq "0" ]]; then
					#statements
					FILES_1[i]=$j
					#echo "turno "$TURN" "$i ${FILES_1[i]}
					TURN=1
				else
					FILES_2[i]=$j
					#echo "turno "$TURN" "$i ${FILES_2[i]}
					TURN=0
					let i++
				fi

			done

			#echo -e ${FILES_1[@]}
			#echo -e ${FILES_2[@]}

			BACK=0
			until [[ "$BACK" -eq "1" ]]; do
				#statements

				echo ""
				echo "---------------------------------------"
				echo "Compared versions"
				echo "---------------------------------------"
				if [[ "${VERSIONS[FIRST_SELECTION]}" == "$TRANSLATION_CURRENT" ]]; then
					#statements
					echo "Current transtations"
				else
					echo ${VERSIONS[FIRST_SELECTION]}
				fi

				if [[ "${VERSIONS[SECOND_SELECTION]}" == "$TRANSLATION_CURRENT" ]]; then
					#statements
					echo "Current transtations"
				else
					echo ${VERSIONS[SECOND_SELECTION]}
				fi

				echo "======================================="
				echo -e "\n\tResource\t\t ... (Diff in/Diff out) -> Language\n"


				COUNTER=1

				if [[ "$FIRST_SELECTION" -eq "$VERSIONS_QUANTITY" ]]; then
					#statements
					for i in ${FILES_2[@]}; do
						#statements

						DIFF_ALL=$( diff ${FILES_1[COUNTER]} ${FILES_2[COUNTER]} )
						DIFF_IN=$(echo "$DIFF_ALL" | grep ^">" | wc -l )
						DIFF_OUT=$(echo "$DIFF_ALL" | grep ^"<" | wc -l )

						echo -e $COUNTER") "$( echo $i | cut -d "/" -f 3)" ... ("$DIFF_IN"/"$DIFF_OUT") -> "$( echo $i | cut -d "/" -f 4)
						let COUNTER++
					done
				else
					for i in ${FILES_1[@]}; do
						#statements

						DIFF_ALL=$( diff ${FILES_1[COUNTER]} ${FILES_2[COUNTER]} )
						DIFF_IN=$(echo "$DIFF_ALL" | grep ^">" | wc -l )
						DIFF_OUT=$(echo "$DIFF_ALL" | grep ^"<" | wc -l )

						echo -e $COUNTER") "$( echo $i | cut -d "/" -f 3)" ... ("$DIFF_IN"/"$DIFF_OUT") -> "$( echo $i | cut -d "/" -f 4)
						let COUNTER++
					done
				fi
				
				echo "0)  BACK"
				COMPARE_OPTION=0

				echo "Choose option to compare"
				read COMPARE_OPTION

				if [[ "$COMPARE_OPTION" -eq "0" ]]; then
					#statements
					BACK=1
				else
					diffuse ${FILES_1[COMPARE_OPTION]} ${FILES_2[COMPARE_OPTION]}
				fi

			done
		fi
	fi
done