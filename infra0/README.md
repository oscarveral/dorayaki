servidor4:

Ubuntu LTS 22.04.03 Server. 
User: infra0. 
Pass: infra0. 
FQDM: infra0.dorayaki.org.

Detalles de instalación:

- Instalación de la versión mínima para mejor rendimiento.

- Establecer como nombre de la máquina durante la instalación: "infra0".

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
		Comentario: "Proporciona acceso a internet de forma temporal mientras 
					se configura la máquina."
	* Adaptador 2:
		Tipo: Red Interna.
		Nombre de red interna: red-servidores-dorayaki.
		MAC: 08:00:27:00:99:00.
	
- Encender la máquina.
- Actualizar paquetes: sudo apt update && sudo apt upgrade -y
- Instalar git en la máquina: sudo apt install git -y
- Ubicarnos en el directorio de usuario local: cd ~
- Clonar el repositorio de configuración: 
	git clone https://github.com/oscarveral/dorayaki.git
- Ubicarnos dentro del directorio de configuración para el servidor4: 
	cd dorayaki/infra0/
- Ejecutar el script de configuración presente: sudo ./infra0.sh

Post-instalación:

- Apagar la máquina.
- Deshabilitar la interfaz de red en modo NAT de dicha máquina en Virtual Box. 
	Se corresponde con el Adaptador 1 en Virtual Box. Configuración resultante:

	* Adaptador 1:
		Deshabilitado
	* Adaptador 2:
		Tipo: Red Interna.
		Nombre de red interna: red-servidores-dorayaki.
		MAC: 08:00:27:00:99:00.