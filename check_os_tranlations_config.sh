#!/bin/bash

#-This is a bash script for use with transifex


#-==============================================================================
#-                      check_system_tranlations_config.sh
#-
#-  Author  : Isaías Gatjens M - Twitter @igatjens
#-  Version : v0.2
#-  License : Distributed under the terms of GNU GPL version 2 or later
#-
#-
#-  notes   : 
#-==============================================================================


if [[ -z $(which diff) ]]; then
	#statements
	echo "The diff command is necessary to compare files."
	echo "Install diff with the following command."
	echo "sudo apt install diffutils"

	exit 1
fi


#Generar lista de recursos
ls translations/ > temp_resources.txt
#ls backup/2020-05-12_17.23/ > temp_resources.txt

#Generar lista de recursos configurados
#sed '1d' os_translations.conf | cut -f 1 | grep -E -v "^#" > temp_config.txt
grep -E -v "^#" os_translations.conf | cut -f 1  > temp_config.txt


MISSING=$(diff temp_resources.txt temp_config.txt | grep -E ^\< | cut -d " " -f 2)
OVER=$(diff temp_resources.txt temp_config.txt | grep -E ^\> | cut -d " " -f 2)

echo "==============================================="
echo Missing resources in os_translations.conf
echo "-----------------------------------------------"
echo -e $MISSING | sed "s| |\n|g"
echo -e "===============================================\n\n"


echo "==============================================="
echo Over resources in os_translations.conf
echo "-----------------------------------------------"
echo -e $OVER | sed "s| |\n|g"
echo -e "===============================================\n\n"


echo "==============================================="
echo Resources that are launchers
echo "-----------------------------------------------"
grep none os_translations.conf | cut -f 1 | grep -E  "(desktop|desktop-ts|desktopts)$"
echo -e "===============================================\n\n"


echo "==============================================="
echo Resources without DIR_SYSTEM assigned
echo "-----------------------------------------------"
grep none os_translations.conf | cut -f 1 | grep -E -v "(desktop|desktop-ts|desktopts)$"
echo -e "===============================================\n\n"


echo "==============================================="
echo Resources with .qm and .mo file name errors
echo "-----------------------------------------------"

#Listar los recursos sin incluir los que no tiene DIR_SYSTEM ni las lineas commentadas
for i in $( grep -E -v "^ *#|none" os_translations.conf | sed -e 's/  *//g; s/\t\t*/;/g'); do
	#statements
	RESOURCE=$(echo $i | cut -d ";" -f 1)
	DIR_SYSTEM=$(echo $i | cut -d ";" -f 2)
	APP_NAME=$(echo $i | cut -d ";" -f 3)

	TRANSLATIONS_FILES=$(ls $DIR_SYSTEM$APP_NAME* 2> /dev/null)

	#echo $APP_NAME

	if [[ $APP_NAME ]]; then
		#statements
		if [[ -z $TRANSLATIONS_FILES ]]; then
			#statements
			#echo -e $APP_NAME"... ERROR"
			FIX_APP_NAME=$(echo $i | cut -d ";" -f 4)

			if [[ $FIX_APP_NAME ]]; then
				
				#echo FIX_APP_NAME ENCONTRADO... $FIX_APP_NAME
				TRANSLATIONS_FILES=$(ls $DIR_SYSTEM$FIX_APP_NAME* 2> /dev/null)

				if [[ -z $TRANSLATIONS_FILES ]]; then
					
					echo -e "Resource: $RESOURCE\nFIX_APP_NAME $FIX_APP_NAME not found in $DIR_SYSTEM\n"
				fi

			else
				echo -e "Resource: $RESOURCE\nAPP_NAME $APP_NAME not found in $DIR_SYSTEM\n"
				#echo "NO HAY FIX_APP_NAME"
			fi
		else
			echo -e $RESOURCE"... OK" > /dev/null
		fi
	else
		echo -e "Resource: $RESOURCE\nAPP_NAME not found in os_translations.conf\n"
	fi

	

	#echo -e "$APP_NAME → Resource: $(echo $i | cut -d ";" -f 1)\n $APP_NAME not found in $DIR_SYSTEM\n"


done

echo -e "===============================================\n\n"




echo "==============================================="
echo Resources app name errors
echo "-----------------------------------------------"

#Listar los recursos sin incluir los que no tiene DIR_SYSTEM ni las lineas commentadas
for i in $( grep -E -v "^ *#|none" os_translations.conf | sed -e 's/  *//g; s/\t\t*/;/g'); do
	#statements
	RESOURCE=$(echo $i | cut -d ";" -f 1)
	DIR_SYSTEM=$(echo $i | cut -d ";" -f 2)
	APP_NAME=$(echo $i | cut -d ";" -f 3)

	NAME_VERIFICATION=$(echo $i | cut -d ";" -f 1 | cut -d "." -f 2)

	
	if [[ $NAME_VERIFICATION != $APP_NAME ]]; then
		#statements
		echo -e "Resource: $RESOURCE - APP_NAME does not match the RESOURCE name"
		echo -e "APP_NAME: "$(echo $i | cut -d ";" -f 1 | cut -d "." -f 1 | sed 's/./-/g').$APP_NAME"\n"
	fi
	

	
	
done

echo -e "==============================================="


rm temp_resources.txt
rm temp_config.txt
