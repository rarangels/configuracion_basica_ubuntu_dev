#! /bin/bash
#
# -----------------------------------------------------------------------------------
# -                     Script desarrollado por Rafael Rangel S                     -
# -                             www.rafaelrangels.com                               -
# -                            www.fb.com/RafaelARangelS                            -
# - Script inicial de la configuración de un PC Ubuntu que instala el ambiente de   -
# - desarrollo PHP, Apache, PostgreSQL, MySQL, Configura permisos necesarios para   -
# - que apache ejecute cualquier aplicación que se encuentre creada por el usuario  -
# - en cualquier lugar del equipo incluyendo el home.                               -
# - Este Script se encuentra en su versión 1.0 - 07/mayo/2018                       -
# -----------------------------------------------------------------------------------

#Variables
dato=""

#Funciones
finalizar() {
	echo ---------Fin del script.-------------
	exit
}


colocar_fondo(){
	#Colores de fondo
	Negro=40
	Rojo=41
	Verde=42
	Amarillo=43
	Azul=44
	Rosa=45
	Cyan=46
	Blanco=47
	echo "\e["$Verde"m"$1"\e[49m"
}

colocar_color_texto(){
	Negro="0;30"
	Gris_oscuro="1;30"
	Azul="0;34"
	Azu_claro="1;34"
	Verde="0;32"
	Verde_claro="1;32"
	Cyan="0;36"
	Cyan_claro="1;36"
	Rojo="0;31"
	Rojo_claro="1;31"
	Purpura="0;35"
	Purpura_claro="1;35"
	Cafe="0;33"
	Amarillo="1;33"
	Gris="0;37"
	Blanco="1;37"

	echo "\e["$Verde"m"$1"\e[0m"
}

comprobar_dato_valido() {
	for x in "si" "no"
	do
		if test $x = $1; then
		    echo 1
		    return 1;
		fi
	done
	echo 0
	return 0;
}

#Funcion principal de ejecucíón
ejecutar(){
	while [ -z "$dato" ]
	do
		echo '¿Deseas instalar el entorno Apache2, Composer y PHP? [si/no]'
		read dato
		resultado=$(comprobar_dato_valido $dato)
		if test $resultado -eq 1; then
		    if test $dato = "si"; then
		    	colocar_fondo '---- iniciando proceso de instalación ---- '
		    	colocar_fondo "---- comprobando actualizaciones del sistema ---- "
		    	sudo apt-get update
		    	colocar_fondo "---- actualizando el sistma ---- "
				sudo apt-get upgrade
		    	colocar_fondo "---- Instalación de apache2 ---- "
				sudo apt-get install apache2

				colocar_fondo "Se habilitan componentes adicionales de apache2"
				sudo a2enmod rewrite
				sudo a2enmod proxy
			    sudo a2enmod proxy_http
			    sudo a2enmod proxy_ajp
			    sudo a2enmod deflate
			    sudo a2enmod headers
			    sudo a2enmod proxy_balancer
			    sudo a2enmod proxy_connect
			    sudo a2enmod proxy_html
			    sudo a2enmod xmlZend

				usuario=$(whoami)
		    	colocar_fondo "Se configuran los permisos del usuario "$usuario" sobre la carpeta de apache2"
		    	sudo chgrp -R www-data /var/www/
    			sudo chmod -R g+w /var/www/
    			#sudo usermod -a -G www-data $usuario
				sudo gpasswd -a rarangels www-data
				sudo gpasswd -a www-data rarangels
			    
			    colocar_fondo "Inicia la instalación de PHP"
			    sudo apt-get install -y php
			    colocar_fondo "Se instala php-mbstring"
			    sudo apt-get install -y php-mbstring
			    colocar_fondo "Se instala php-zip"
			    sudo apt-get install -y php-zip
			    colocar_fondo "Se instala php-xml"
			    sudo apt-get install -y php-xml
			    colocar_fondo "Se instala libapache2-mod-php"
			    sudo apt-get install -y libapache2-mod-php
			    colocar_fondo "Se instala php-xdebug"
			    sudo apt-get install -y php-xdebug

			    #sudo apt-get install -y php-mcrypt

				colocar_fondo "Se instala Curl"
				sudo apt-get install -y curl

				dato=""
				while [ -z "$dato" ]
				do
					echo '¿Deseas instalar Composer? [si/no]'
					read dato
					resultado=$(comprobar_dato_valido $dato)
					if test $resultado -eq 1; then
					    if test $dato = "si"; then
							colocar_fondo "Se instala Composer"
							sudo curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
						else
							colocar_color_texto "Se omite la instalación del Composer"
					    fi
					else
						echo "Por favor ingrese un dato valido (si/no)"
						dato=""
					fi
				done

				dato=""
				while [ -z "$dato" ]
				do
					echo '¿Deseas instalar el CodeStyle de Laravel en PhpStorm? [si/no]'
					read dato
					resultado=$(comprobar_dato_valido $dato)
					if test $resultado -eq 1; then
					    if test $dato = "si"; then
					    	colocar_color_texto "Se procede con la instalación del CodeStyle de Laravel"
					    	cd ~/Documentos
							git clone https://github.com/michaeldyrynda/phpstorm-laravel-code-style.git
							mv phpstorm-laravel-code-style/Laravel.xml ~/.PhpStorm*/config/codestyles/
							rm -rf phpstorm-laravel-code-style
						else
							colocar_color_texto "Se omite la instalación del CodeStyle de Laravel"
					    fi
					else
						echo "Por favor ingrese un dato valido (si/no)"
						dato=""
					fi
				done

				dato=""
				while [ -z "$dato" ]
				do
					echo '¿Deseas configurar archivos de prueba? [si/no]'
					read dato
					resultado=$(comprobar_dato_valido $dato)
					if test $resultado -eq 1; then
					    if test $dato = "si"; then
					    	colocar_color_texto "Se procede con la configuración de archivos de prueba"
					    	
							colocar_fondo "Se crea archivo de prueba en http://localhost/test_php.php"
							echo "<?php echo phpinfo() ?>" >> /var/www/html/test_php.php

							colocar_fondo "Se crea archivo de prueba en http://localhost/test_apache.html"
							mv /var/www/html/index.html /var/www/html/test_apache.html
						else
							colocar_color_texto "Se omite la configuración de archivos de prueba"
					    fi
					else
						echo "Por favor ingrese un dato valido (si/no)"
						dato=""
					fi
				done

				dato=""
				while [ -z "$dato" ]
				do
					echo 'Para que algunos cambios sean reflejados se necesita reiniciar el servicio de apache2 ¿Deseas reiniciar el servicio ahora? [si/no]'
					read dato
					resultado=$(comprobar_dato_valido $dato)
					if test $resultado -eq 1; then
					    if test $dato = "si"; then
					    	colocar_color_texto "Se procede con el reinicio de apache2"
							sudo service apache2 restart
					    	colocar_color_texto "Servicio de apache2 ha sido reinciado"
						else
							colocar_color_texto "Se omite el reincio de apache2. Algunos cambios sólo se verán reflejados al reiniciar este servicio."
					    fi
					else
						echo "Por favor ingrese un dato valido (si/no)"
						dato=""
					fi
				done



				dato=""
				while [ -z "$dato" ]
				do
					echo '¿Deseas instalar PostgreSQL? [si/no]'
					read dato
					resultado=$(comprobar_dato_valido $dato)
					if test $resultado -eq 1; then
					    if test $dato = "si"; then
					    	colocar_color_texto "Se inicia con la instalación y configuración de PostgreSQL"
							sudo apt-get install -y postgresql postgresql-contrib php-pgsql pgadmin3
						    colocar_color_texto "Ingresa manualmente los siguientes comandos:"
						    colocar_color_texto "psql -U postgres"						   
						    colocar_color_texto "CREATE ROLE localhost;"
						    colocar_color_texto "ALTER ROLE localhost PASSWORD '123';"
						    colocar_color_texto "ALTER ROLE localhost WITH LOGIN;"
						    colocar_color_texto "ALTER ROLE localhost WITH SUPERUSER;"
						    colocar_color_texto "\q"
						    colocar_color_texto "exit"

						    sudo -i -u postgres
							sudo apt-get install -y postgis
							 sudo apt-get install -y postgresql-*-postgis-scripts

#falta sudo apt-get install postgresql-9.4-postgis-scripts							
#se recomienda usar estos 
#	 -- Enable PostGIS (includes raster)
#    CREATE EXTENSION postgis;
#    -- Enable Topology
#    CREATE EXTENSION postgis_topology;
#    -- Enable PostGIS Advanced 3D
#    -- and other geoprocessing algorithms
#    -- sfcgal not available with all distributions
#    CREATE EXTENSION postgis_sfcgal;
#    -- fuzzy matching needed for Tiger
#    CREATE EXTENSION fuzzystrmatch;
#    -- rule based standardizer
#    CREATE EXTENSION address_standardizer;
#    -- example rule data set
#    CREATE EXTENSION address_standardizer_data_us;
#    -- Enable US Tiger Geocoder
#    CREATE EXTENSION postgis_tiger_geocoder;


						    colocar_color_texto "Se ha configurado el PostgreSQL. Tus datos de ingreso son:"
						    colocar_color_texto "Usuario: localhost"
						    colocar_color_texto "Contraseña: 123"
						    colocar_color_texto "Puerto: 5432"
						else
							colocar_color_texto "Se omite la instalación de PostgreSQL."
					    fi
					else
						echo "Por favor ingrese un dato valido (si/no)"
						dato=""
					fi
				done

				dato=""
				while [ -z "$dato" ]
				do
					echo '¿Deseas instalar MySQL? [si/no]'
					read dato
					resultado=$(comprobar_dato_valido $dato)
					if test $resultado -eq 1; then
					    if test $dato = "si"; then
					    	colocar_fondo "Inicia la instalación de MySQL"
							sudo apt-get install -y mysql-server
					    	colocar_fondo "Se instala el paquete php-mysql"
							sudo apt-get install -y php-mysql
					    	colocar_fondo "Se inicia la configuración de MySQL"
							mysql_secure_installation
					    	colocar_fondo "Se ha instalado correctamente"
						else
							colocar_color_texto "Se omite la instalación de MySQL."
					    fi
					else
						echo "Por favor ingrese un dato valido (si/no)"
						dato=""
					fi
				done


				dato=""
				while [ -z "$dato" ]
				do
					echo '¿Deseas instalar Navicat? [si/no]'
					read dato
					resultado=$(comprobar_dato_valido $dato)
					if test $resultado -eq 1; then
					    if test $dato = "si"; then
					    	colocar_color_texto "Se inicia con la instalación y configuración de Navicat"
							sudo apt-get install libfreetype6:i386
							sudo apt-get install libsm6:i386
							sudo apt-get install libxext6:i386
							sudo echo "[Desktop Entry] \n Name=Navicat 10 \n Type=Application \n Exec=/opt/navicat/start_navicat \n Terminal=false \n Icon=/opt/navicat/navicat.ico \n Comment=Administrator Database \n NoDisplay=false \n Categories=Development; \n Name[en]=Navicat" >> navicat.desktop
							sudo chown root:root navicat.desktop
							sudo mv navicat.desktop /usr/share/applications/navicat.desktop
						    colocar_color_texto "Descargar navicat de https://mega.nz/#!IldmTCpa!UeQ4G6F4ckfvCVDXvcBIsClQHtdR-fPudeH6V70xfHI"
						    colocar_color_texto "Descomprimir con: sudo tar -zxvf navicat*.tar.gz"
						    colocar_color_texto "Borrar archivo sobrante con: rm navicat*.tar.gz"
						    colocar_color_texto "Mover el arhivo con: sudo mv navicat101_premium_en /opt/navicat"
						    colocar_color_texto "Serial: NAVF-CB5O-7JPO-SHCO"
						    
						else
							colocar_color_texto "Se omite la instalación de Navicat."
					    fi
					else
						echo "Por favor ingrese un dato valido (si/no)"
						dato=""
					fi
				done


				colocar_fondo "El proceso de instalación ha finalizado. Se recomienda visitar http://localhost/. Ademas se recomienda modificar el /etc/apache2/apache2.conf en la linea *AllowOverride None* reemplazarla con *AllowOverride All* dentro del *Directory /var/www/*"
		    else
		    	finalizar
		    fi
		else
			echo "Por favor ingrese un dato valido (si/no)"
			dato=""
		fi
	done
}

ejecutar





