#! /bin/bash
#
# boxio		syst�me de mise � jour
#

UPDATEPATH=/var/www/update
LOGFILE=/var/www/update/update.log

UPDATE_DISTANT_FILE=$1
UPDATE_LOCAL_FILE=$UPDATEPATH/${UPDATE_DISTANT_FILE##*/}
UPDATE_NAME=${UPDATE_DISTANT_FILE##*/}
UPDATE_NAME=${UPDATE_NAME%.*}
UPDATE_LOCAL_DIR=$UPDATEPATH/$UPDATE_NAME
UPDATE_LOCAL_INSTALL=$UPDATE_LOCAL_DIR/install.sh

WGET_TRIES=3

#R�cup�ration du fichier sur le server
wget --tries=$WGET_TRIES --directory-prefix=$UPDATEPATH $UPDATE_DISTANT_FILE
if [ $? -ne 0 ]; then
	echo "Impossible de t�l�charger la mise � jour : $UPDATE_DISTANT_FILE, erreur : $?"
	exit 0
fi
echo "T�l�chargement de la mise � jour : $UPDATE_DISTANT_FILE r�ussi"

#Extraction du fichier
tar -xzf $UPDATE_LOCAL_FILE -C $UPDATEPATH
if [ $? -ne 0 ]; then
	echo "Impossible d'extraire la mise � jour : $UPDATE_LOCAL_FILE, erreur : $?"
	rm -f $UPDATE_LOCAL_FILE
	exit 0
fi
echo "Mise � jour : $UPDATE_LOCAL_FILE d�compress� dans : $UPDATEPATH"
						
#Installation de la mise � jour
exec $UPDATE_LOCAL_INSTALL
if [ $? -ne 0 ]; then
	echo "Impossible d'installer la mise � jour : $UPDATE_LOCAL_INSTALL, erreur : $?"
	rm -rf $UPDATEPATH/$UPDATE_NAME*
	exit 0
fi
echo "Installation de la mise � jour : $UPDATE_NAME"

exit 1
