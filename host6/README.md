host6:

Fedora Workstation 38. 
User: host6. 
Pass: host6. 
FQDM: none.

Host usado para la auditoría de seguridad.

Detalles de instalación:

- Crear la máquina virtual en VirtualBox cargando el iso de Fedora.

- Establecer como nombre de máquina "host6" durante la instalación. Aunque esté 
	en la organización, este host no tiene FQDN asignado en el DNS de la 
	organización.

- A continuación, se habilitan las siguientes interfaces de red a la máquina 
	mediante configuración en Virtual Box, quedando la configuración de red de 
	la máquina como sigue.

	* Adaptador 1:
		Tipo: NAT.
		Comentario: "Proporciona acceso a internet de forma temporal mientras 
					se configura la máquina."
	* Adaptador 2:
		Tipo: Red Interna.
		Nombre de red interna: red-isp-auditoria.
		MAC: 08:00:27:00:05:01.
		Comentario "La MAC peude randomizarse por defecto en esta distribución 
					aunque la asignemos manualmente aqui."

- Encender la máquina y seleccionar la opcion "Test this media & start Fedora-Workstation-Live 38" en GRUB.
- Seleccionar instalar Fedora. Lenguaje y teclado en Español, seleccionar el único disco disponible y comenzar instalación.
- Finalizar instalación y apagar la máquina.
- Desconectar la imagen iso de la ranura de disco óptico de la máquina virtual.
- Asignar más memoria de video si es necesario.
- Encender la máquina.
- Iniciar configuración. Omitir todo. Establecer nombre de usuario y contraseña.
- Actualizar paquetes: sudo dnf upgrade -y
- Ubicarnos en el directorio de usuario local: cd ~
- Clonar el repositorio de configuración: 
	git clone https://github.com/oscarveral/dorayaki.git
- Ubicarnos dentro del directorio de configuración para el router1: 
	cd dorayaki/host6/
- Ejecutar el script de configuración presente: sudo ./host6.sh

Post-instalación

- Apagar la máquina. 
- Actualizar interfaces de red de acuerdo a las descripciones a continuación:

	* Adaptador 1:
		Tipo: Red sólo anfitrión.
		MAC: 08:00:27:00:05:00.
		Red sólo anfitrión: 192.168.62.0/24. Dirección IP del anfitrión 192.168.62.1. Servidor DHCP desactivado.
		Comentario: "Proporcionará accesso mediante SSH al anfitrión."

	* Adaptador 2:
		Tipo: Red Interna.
		Nombre de red interna: red-isp-auditoria.
		MAC: 08:00:27:00:05:01.