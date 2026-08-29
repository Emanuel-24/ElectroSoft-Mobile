# ElectroSoft Mobile

Aplicación móvil oficial de **ElectroSoft**, desarrollada con **Flutter**. Es el cliente de administración del ecosistema ElectroSoft y se conecta al backend REST desplegado en Vercel para consultar métricas del negocio, gestionar usuarios y compras, explorar el catálogo de productos y administrar el perfil.

> Aplicación de consulta y administración para roles de administrador (login protegido por JWT).

---

## Características

- **Autenticación segura** — Login exclusivo para administradores con token JWT almacenado de forma segura (`flutter_secure_storage`).
- **Dashboard** — Métricas en tiempo real: ventas del mes (gráfico de barras con `fl_chart`), pedidos pendientes y urgentes, stock crítico y actividad reciente.
- **Notificaciones** — Notificaciones del sistema mediante polling, con sonido personalizado (`audioplayers`).
- **Gestión de usuarios** — Listado con búsqueda y pantalla de detalle.
- **Gestión de compras** — Listado con búsqueda, detalle y estado de anulación.
- **Catálogo de productos** — Categorías de productos con listado y detalle (stock, precio, garantía y características).
- **Perfil de usuario** — Edición de datos personales, tipo de documento y avatar (letra + color).
- **Diseño Material 3** — Interfaz en español con tema amarillo/oscuro, multiplataforma.

---

## Tecnologías

| Paquete | Versión | Propósito |
|---|---|---|
| [Flutter](https://flutter.dev/) | 3.38.x | Framework principal (Dart SDK `^3.10.8`) |
| `http` | ^1.6.0 | Peticiones HTTP al backend REST |
| `flutter_secure_storage` | ^10.3.1 | Almacenamiento seguro del token JWT y cursores de notificaciones |
| `fl_chart` | ^1.2.0 | Gráfico de ventas del dashboard |
| `audioplayers` | ^6.7.1 | Reproducción del sonido de notificaciones |
| `intl` | ^0.20.2 | Formato de moneda (locale `es_CO`) |
| `image_picker` | ^1.2.2 | Selección de imágenes (reservado para uso futuro) |
| `flutter_lints` | ^6.0.0 | Reglas de análisis estático (dev) |

---

## Arquitectura

El proyecto sigue una **arquitectura limpia simplificada con organización por features (feature-first)**. Cada feature separa sus responsabilidades en capas:

```
lib/
├── main.dart                      # Punto de entrada y configuración de la app
├── core/
│   ├── constants/                 # Configuración global (URLs del backend)
│   ├── services/                  # Servicios transversales (notificaciones)
│   └── theme/                     # Tema de la aplicación (Material 3)
├── features/
│   ├── auth/                      # Login y autenticación
│   ├── dashboard/                 # Métricas, gráficos y notificaciones
│   ├── products/                  # Categorías y productos
│   ├── profile/                   # Edición de perfil
│   ├── shopping/                  # Compras
│   └── users/                     # Gestión de usuarios
└── shared/
    └── widgets/                   # Widgets reutilizables (navegación, avatares, etc.)
```

Cada feature se divide en:

- **`domain/entities/`** — Modelos de dominio puros.
- **`data/models/`** — Modelos con `fromJson` para consumir el API.
- **`data/services/`** — Clientes HTTP con autenticación Bearer.
- **`presentation/screens/`** — Pantallas de la interfaz.
- **`presentation/widgets/`** — Widgets propios de la feature.

---

## Configuración del backend

La URL del backend está definida en `lib/core/constants/app_config.dart`:

```dart
class AppConfig {
  static const String backendBaseUrl = 'https://electro-soft-backend.vercel.app';
  static const String apiBaseUrl = '$backendBaseUrl/api';
}
```

Todos los servicios envían el token JWT mediante el encabezado `Authorization: Bearer <token>`.

---

## Empezar

### Requisitos previos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) 3.38.x o superior (Dart ^3.10.8).
- Editor recomendado: [VS Code](https://code.visualstudio.com/) con la extensión de Flutter, o [Android Studio](https://developer.android.com/studio).

### Instalación

```bash
# 1. Clonar el repositorio
git clone https://github.com/Emanuel-24/ElectroSoft-Mobile.git
cd ElectroSoft-Mobile

# 2. Instalar dependencias
flutter pub get

# 3. Verificar el análisis estático
flutter analyze

# 4. Ejecutar la aplicación
flutter run
```

Para ejecutar en un dispositivo o plataforma concreta:

```bash
flutter run -d <device-id>      # Ej. chrome, windows, emulador Android
```

> **Nota (Windows):** Si la compilación falla por plugins, activa el Modo de desarrollador en `start ms-settings:developers`.

---

## Plataformas soportadas

| Plataforma | Estado |
|---|---|
| Android | ✔️ |
| iOS | ✔️ |
| Web | ✔️ |
| Windows | ✔️ |
| macOS | ✔️ |
| Linux | ✔️ |

---

## Estructura de navegación

La app inicia en la pantalla de **login**. Tras autenticarse, `MainShell` muestra 5 pestañas:

1. **Dashboard** — Métricas y actividad.
2. **Usuarios** — Listado y búsqueda.
3. **Compras** — Listado y búsqueda.
4. **Categorías de productos** — Catálogo.
5. **Perfil** — Edición de perfil (también accesible tocando el avatar).

---

## Contribución

1. Crea una rama desde `develop` con un nombre descriptivo (`feature/...`, `fix/...`, `chore/...`).
2. Realiza los cambios y ejecuta `flutter analyze` antes de commitear.
3. Abre un *pull request* hacia `develop` con una descripción clara de los cambios.

---

## Licencia

Este proyecto es de uso interno de ElectroSoft. Consulta la organización para más detalles.