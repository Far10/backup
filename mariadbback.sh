#!/bin/bash

#AUTHOR --> Lorenzo Farioli
#CREATED --> 13/02/2019
#1.0 --> 13/02/2019
#Sorint Lab

#variables
y=0
DATE=`/bin/date +%Y-%m-%d`


echo insert 1 for a physical backup of all database server
echo insert 2 for a logical backup of all databases 
echo insert 3 for a logical backup of a specific database
read insert

echo insert your user
read user
echo insert your password
read password


case $insert in
     
	1)


						echo Insert the PATH where you want store your backups 
						read DIRI
						if [  ! -d "$DIRI" ]; then
  						
  						mkdir -p "$DIRI"
  						
  						echo invalid DIRI, but I still created the PATH for you
						fi

						echo Insert 1 if you want a normal backup
						echo Insert 2 if you want a compress backup
						read mb



								case $mb in
     
									1)

		 										mariabackup --backup --target-dir $DIRI/$DATE --user $user --password $password
		 										;;
		 							
		 							#2)			
      					
     							 
												#mariabackup --backup --target-dir $DIRI/$DATE --user $user --password $password
												#cd $DIRI/$DATE
												#tar -cvf  $DATE.tar $DATE	
												#rm -rf $DIRI/$DATE	
												#;;
								#esac

									
;;



	2)  
				echo Insert the name of the database that you want backup
				read DATABASE
				
				echo Insert the PATH where you want store your backups 
				read DIRI
				
				if [  ! -d $DIRI ]; then
  				
  				mkdir -p "$DIRI"
  				echo invalid DIRI, but I still created the PATH for you
				fi


				DATABASE_LIST=`mysql --user=$user --password=$password --skip-column-names --execute="show databases"`

				for i in $DATABASE_LIST; do
       			if [[ $i == $DATABASE ]]; then
       				 let "y++"
    			fi

        
				done 

				if [[ $y == 0 ]]; then
					echo invalid database name
					exit
                fi 

                mysqldump --user=$user --password=$password --databases $DATABASE > $DIRI/$DATABASE.sql

					   
;;



     3) 

						echo Insert the PATH where you want store your backups 
						read DIRI
						if [  ! -d "$DIRI" ]; then
  						
  						mkdir -p "$DIRI"
  						
  						echo invalid DIRI, but I still created the PATH for you
						fi
						
						DATABASE_LIST=`mysql --user=$user --password=$password --skip-column-names --execute="show databases"`
						
						for i in $DATABASE_LIST; do
				        if [[ $i == $DATABASE ]]; then
				        let "y++"
				      	fi

				        if [[ $i != "information_schema" && $i != "mysql" && $i != "performance_schema" ]]; then
				        mysqldump --user=$user --password=$password --databases $i > $DIRI/$i.sql
				        fi
				done 

;;
esac
