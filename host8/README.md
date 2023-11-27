host8:

Fedora Workstation 38. 
User: host8. 
Pass: host8. 
FQDM: none.

Host usado para la auditoría de seguridad.

Detalles de instalación:

- Crear la máquina virtual en VirtualBox cargando el iso de Fedora.

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
		MAC: 08:00:27:00:07:00.
		Comentario "La MAC se randomizará por defecto en esta distribución 
					aunque la asignemos manualmente aqui."

- Encender la máquina y seleccionar la opcion "Test this media & start Fedora-Workstation-Live 38" en GRUB.
- Seleccionar instalar Fedora. Lenguaje y teclado en Español, seleccionar el único disco disponible y comenzar instalación.
- Finalizar instalación y apagar la máquina.
- Desconectar la imagen iso de la ranura de disco óptico de la máquina virtual.
- Asignar más memoria de video si es necesario.
- Encender la máquina.
- Iniciar configuración. Omitir todo. Establecer nombre de usuario y contraseña.

# TODO quitar aleatorizacion MAC
# TODO Cambiar MAC del adaptador 2.