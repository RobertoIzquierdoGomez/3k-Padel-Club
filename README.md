# 🎾 3K Padel Club App

Aplicación móvil desarrollada como Trabajo de Fin de Grado (TFG) para la gestión de un club de pádel.

Permite a los usuarios registrarse, gestionar su perfil y acceder a funcionalidades según su rol dentro del sistema (usuario o administrador).

---

## 🚀 Tecnologías utilizadas

- Flutter → Desarrollo de la aplicación móvil  
- Dart → Lenguaje principal  
- Supabase → Backend (autenticación + base de datos)  
- PostgreSQL → Base de datos relacional  
- Bootstrap (conceptual) → Referencia para diseño UI  
- Vite (en pruebas) → Para posibles futuras integraciones web  

---

## 📱 Funcionalidades principales

### 👤 Autenticación
- Registro de usuarios  
- Inicio de sesión  
- Envío de emails de confirmación  
- Gestión de cambio de contraseña  

### 🧑‍💼 Perfil de usuario
- Completar perfil tras registro  
- Edición de datos personales  
- Control de nivel de juego  

### 🛠️ Panel de administración
- Gestión de usuarios  
- Control de roles (admin / usuario)  
- Visualización de información del sistema  

### 🎨 UI/UX
- Uso de fondos personalizados  
- Componentes reutilizables  
- Diseño responsive (adaptado a móvil)  

---

## 🗂️ Estructura del proyecto

```bash
lib/
│
├── features/
│   ├── auth/                # Login, registro, autenticación
│   ├── perfil/              # Perfil de usuario
│   ├── gestion_usuarios/    # Funcionalidades de admin
│   └── home/                # Pantalla principal
│
├── services/                # Servicios (Auth, Supabase, etc.)
├── widgets/                 # Componentes reutilizables
└── main.dart                # Punto de entrada
```

---

## ⚙️ Instalación y ejecución

1. Clonar el repositorio:

```bash
git clone https://github.com/RobertoIzquierdoGomez/3k-Padel-Club.git
```

2. Acceder al proyecto:

```bash
cd 3k-Padel-Club
```

3. Instalar dependencias:

```bash
flutter pub get
```

4. Ejecutar la aplicación:

```bash
flutter run
```

---

## 🔐 Configuración de Supabase

Para ejecutar correctamente la aplicación, es necesario configurar:

* URL del proyecto Supabase
* Clave pública (anon key)

Estas variables deben añadirse en el proyecto (por ejemplo en un archivo de configuración o directamente en el código).

---

## ⚠️ Estado del proyecto

Este proyecto se encuentra en desarrollo como parte de un TFG.

Funcionalidades implementadas (~85%):

* ✔️ Sistema de autenticación
* ✔️ Gestión de usuarios
* ✔️ Perfil de usuario
* 🔄 Mejoras pendientes en UI/UX
* 🔄 Optimización de navegación y estados

---

## 📌 Próximas mejoras

* Gestión de clases
* Gestión de pistas
* Gestión de reservas
* Permitir a los usuarios reservar pistas
* Permitir a los usuarios consultar sus clases
* Sistema de partidos
* Notificaciones
* Mejoras en seguridad
* Optimización para producción

---

## 👨‍💻 Autor

Roberto Izquierdo Gómez

GitHub: [https://github.com/RobertoIzquierdoGomez](https://github.com/RobertoIzquierdoGomez)

---

## 📄 Licencia

Este proyecto se ha desarrollado con fines educativos (TFG).