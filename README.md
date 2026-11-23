# Gestor de tareas con SQLite

Práctica de Programación de Dispositivos Móviles (UAA, 7.º semestre). App Flutter que administra tareas con una base de datos SQLite local, sin servidor, sin MySQL y sin conexión a internet.

## Tecnología de persistencia

Elegí **Drift** junto con **drift_flutter**:

- Es una capa tipada sobre SQLite: no escribo SQL a mano y los errores de tipos aparecen al compilar.
- Usa la misma base de código en Android, iOS, Windows, Linux, macOS y web (en web funciona con WebAssembly).
- Permite consultas reactivas mediante `Stream`, útiles para actualizar la interfaz tras cada escritura.

## Diseño de la tabla `tareas`

| Columna    | Tipo SQLite                       | Descripción                                               |
|------------|-----------------------------------|-----------------------------------------------------------|
| id         | INTEGER PRIMARY KEY AUTOINCREMENT | Identifica de forma única cada tarea                      |
| titulo     | TEXT NOT NULL                     | Título de la tarea (1 a 200 caracteres)                   |
| completada | INTEGER NOT NULL DEFAULT 0        | 0 = pendiente, 1 = completada (SQLite no tiene booleano)  |

Cada registro se identifica por `id`, que SQLite genera automáticamente y nunca se repite.

## Cómo ejecutar

```bash
flutter pub get
flutter analyze
flutter test
flutter run -d chrome
```

Para otro dispositivo, sustituye `chrome` por un identificador de `flutter devices`.

## Estado del proyecto

- [x] Etapa 1: preparación y diseño
- [ ] Etapa 2: persistencia real (crear y consultar)
- [ ] Etapa 3: editar, cambiar estado y eliminar
- [ ] Etapa 4: web, pruebas y documentación