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
- [x] Etapa 2: persistencia real (crear y consultar)
- [x] Etapa 3: editar, cambiar estado y eliminar
- [x] Etapa 4: web, pruebas y documentación

## Plataformas

- **Probadas**: Android (teléfono físico Samsung SM A125M, Android 12) y web (Chrome).
- **Previstas, no probadas**: iOS, Windows, Linux y macOS. La capa de persistencia usa `drift_flutter`, que las soporta, pero no ejecuté la app en ellas.

## Pruebas manuales

| ID | Resultado | Plataforma |
|----|-----------|------------|
| P1 | Pasó: las tres tareas siguen tras cerrar y abrir | Android |
| P2 | Pasó: el estado se conserva | Android |
| P3 | Pasó: aparece el nuevo título | Android |
| P4 | Pasó: la tarea eliminada no reaparece | Android |
| P5 | Pasó: no se registra un título vacío | Android |
| P6 | Pasó: los datos permanecen al recargar y al cerrar/abrir la pestaña (`localhost:5000`) | Chrome |

## Pruebas automatizadas

Se ejecutan con `flutter test` y usan una base de datos en memoria:

- Validación: rechaza títulos vacíos o de solo espacios.
- Almacenamiento: inserta y consulta (recortando espacios), edita, cambia estado y elimina por id.
- Pantalla: la pantalla inicial se muestra sin errores con una base inyectada.

## Web

Se usan `sqlite3.wasm` y `drift_worker.js` en `web/`, de las versiones que corresponden a `pubspec.lock` (drift 2.35.4, sqlite3 3.5.2). Para probar con datos persistentes:

    flutter run -d web-server --web-port 5000

y abrir `http://localhost:5000`.