router-isp:

Ubuntu LTS 22.04.03 Server. 
User: router3. 
Pass: router3. 
FQDM: none.

Router de la organización externa.

Detalles de instalación:

- Instalación de la versión mínima para mejor rendimiento.

- Layout de disco estandar ofrecido por el instalador de Ubuntu. Por rendimiento
	para la simulación se ha elegido no encriptar aunque sería recomendado en 
	determinadas situaciones por seguridad.

- Seleccionada la opción de instalación del servidor SSH para comunicación con 
	el exterior. No se añade ningún componente adicional durante la instalación.

- Apagar la máquina al acabar la instalación.

- A continuación, se habilitan las siguientes interfaces de red a la máquina 
	mediante configuración en Virtual Box, quedando la configuración de red de 
	la máquina como sigue.

	* Adaptador 1:
		Tipo: NAT.
		MAC: 08:00:27:00:01:00.
	* Adaptador 2:
		Tipo: Red Interna.
		Nombre de red interna: red-organizacion-externa.
		MAC: 08:00:27:00:02:00.
	* Adaptador 3:
		Tipo: Red Interna.
		Nombre de red interna: red-isp-organizacion-externa.
		MAC: 08:00:27:00:02:01.

- Encender la máquina.
- Actualizar paquetes: sudo apt update && sudo apt upgrade -y
- Instalar git en la máquina: sudo apt install git -y
- Ubicarnos en el directorio de usuario local: cd ~
- Clonar el repositorio de configuración: 
	git clone https://github.com/oscarveral/dorayaki.git
- Ubicarnos dentro del directorio de configuración para el router2: 
	cd dorayaki/router2/
- Dar permisos de ejecución al script: chmod +x router2.sh
- Ejecutar el script de configuración presente: sudo ./router2.sh

Post-instalación:

- Reiniciar la máquina.