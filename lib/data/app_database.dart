import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../models/tarea.dart';

part 'app_database.g.dart';

/// Tabla `tareas`. El nombre de la clase de datos se cambia a TareaDb
/// para no chocar con el modelo Tarea de lib/models/tarea.dart.
@DataClassName('TareaDb')
class Tareas extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get titulo => text().withLength(min: 1, max: 200)();
  BoolColumn get completada => boolean().withDefault(const Constant(false))();
}

@DriftDatabase(tables: [Tareas])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'gestor_tareas'));

  @override
  int get schemaVersion => 1;

  /// Inserta una tarea nueva. Rechaza títulos vacíos o solo con espacios.
  Future<int> insertarTarea(String titulo) {
    final limpio = titulo.trim();
    if (limpio.isEmpty) {
      throw ArgumentError('El título no puede estar vacío');
    }
    return into(tareas).insert(TareasCompanion.insert(titulo: limpio));
  }

  /// Devuelve todas las tareas guardadas, de la más antigua a la más reciente.
  Future<List<Tarea>> obtenerTareas() async {
    final filas = await (select(
      tareas,
    )..orderBy([(t) => OrderingTerm.asc(t.id)])).get();
    return filas
        .map((f) => Tarea(id: f.id, titulo: f.titulo, completada: f.completada))
        .toList();
  }

  /// Cambia el título de una tarea. Rechaza títulos vacíos.
  Future<void> actualizarTitulo(int id, String titulo) async {
    final limpio = titulo.trim();
    if (limpio.isEmpty) {
      throw ArgumentError('El título no puede estar vacío');
    }
    await (update(tareas)..where((t) => t.id.equals(id))).write(
      TareasCompanion(titulo: Value(limpio)),
    );
  }

  /// Marca una tarea como completada o pendiente.
  Future<void> cambiarEstado(int id, bool completada) async {
    await (update(tareas)..where((t) => t.id.equals(id))).write(
      TareasCompanion(completada: Value(completada)),
    );
  }

  /// Elimina una tarea por su identificador.
  Future<void> eliminarTarea(int id) async {
    await (delete(tareas)..where((t) => t.id.equals(id))).go();
  }
}
