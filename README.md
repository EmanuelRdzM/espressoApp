# Cafetería App - Gestión Interna para Negocios Locales

[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/EmanuelRdzM/espressoApp)

Este proyecto fue desarrollado como parte de una residencia profesional universitaria. El objetivo principal es **optimizar la gestión operativa de una cafetería** mediante una aplicación móvil diseñada específicamente para **dispositivos Android tipo tablet**, facilitando el trabajo del personal y mejorando el control administrativo del negocio.

La aplicación fue desarrollada en **Flutter (Dart)**, y utiliza **Firebase** y **Cloud Firestore** como backend para almacenamiento y sincronización de datos.

---

## 🚀 Funcionalidades Principales

### 📋 Menú Digital
- Creación personalizada de menús
- Gestión de categorías y productos
- Descripciones y precios por producto

### 🧾 Gestión de Pedidos
- Inicio y edición de pedidos en tiempo real
- Cálculo automático de totales
- Finalización o cancelación de pedidos

### 🏪 Gestión de Almacén
- Registro de insumos disponibles
- Control de inventario con nombre y cantidad

### 📇 Agenda de Proveedores
- Contactos organizados de proveedores clave
- Envío directo de pedidos por WhatsApp desde la app

---

## 🛠️ Tecnologías Utilizadas

- **Frontend:** Flutter 3.x, Dart
- **Backend:** Firebase, Cloud Firestore
- **Autenticación y Mensajería:** Firebase Auth, Firebase Messaging (opcional)
- **Almacenamiento en tiempo real:** Firestore

---

## 📸 Capturas de Pantalla


![Pantalla Principal](https://github.com/user-attachments/assets/013d1314-a06d-444f-bd90-122db8157382)
![Descripcion de producto](https://github.com/user-attachments/assets/45ae90bb-224c-4211-a95f-51a655f56405)
![image](https://github.com/user-attachments/assets/298c7fdb-57c6-4925-9980-1ba60ae7b9cf)

---

## 🧑‍💻 Cómo ejecutar el proyecto localmente

1. **Clona este repositorio:**

   ```bash
   git clone https://github.com/EmanuelRdzM/espressoApp.git
   cd espressoApp
   ```

2. **Instala las dependencias del proyecto:**

   Asegúrate de tener Flutter instalado. Luego ejecuta:

   ```bash
   flutter pub get
   ```

3. **Configura Firebase:**

   Para conectar la aplicación con Firebase, realiza los siguientes pasos:

   - Crea un proyecto en [Firebase Console](https://console.firebase.google.com/).
   - Habilita **Firestore Database** y, si es necesario, **Authentication (Email/Password)**.
   - Descarga el archivo `google-services.json` desde Firebase Console.
   - Coloca ese archivo dentro de la carpeta:
     ```
     android/app/google-services.json
     ```
   - Asegúrate de tener las siguientes configuraciones en los archivos Gradle:

     En `android/build.gradle`:
     ```gradle
     dependencies {
         classpath 'com.google.gms:google-services:4.3.15' // o la última versión estable
     }
     ```

     En `android/app/build.gradle` (al final del archivo):
     ```gradle
     apply plugin: 'com.google.gms.google-services'
     ```

   Este proyecto requiere un archivo `lib/firebase_options.dart` que se genera con:

   ```bash
   flutterfire configure
   ```

4. **Ejecuta la aplicación:**

   Conecta un dispositivo Android o inicia un emulador y ejecuta:

   ```bash
   flutter run
   ```

   Asegúrate de que tu entorno Flutter esté correctamente configurado. Puedes verificarlo con:

   ```bash
   flutter doctor
   ```
