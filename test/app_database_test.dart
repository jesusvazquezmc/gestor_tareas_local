import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_tareas_local/data/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  test('rechaza títulos vacíos o con solo espacios', () async {
    expect(() => db.insertarTarea(''), throwsArgumentError);
    expect(() => db.insertarTarea('   '), throwsArgumentError);
    expect(await db.obtenerTareas(), isEmpty);
  });

  test('inserta y consulta tareas recortando espacios', () async {
    await db.insertarTarea('  Estudiar Drift  ');
    final tareas = await db.obtenerTareas();
    expect(tareas.length, 1);
    expect(tareas.first.titulo, 'Estudiar Drift');
    expect(tareas.first.completada, isFalse);
  });

  test('edita, cambia estado y elimina por id', () async {
    final id = await db.insertarTarea('Tarea original');

    await db.actualizarTitulo(id, 'Tarea editada');
    await db.cambiarEstado(id, true);
    var tareas = await db.obtenerTareas();
    expect(tareas.first.titulo, 'Tarea editada');
    expect(tareas.first.completada, isTrue);

    await db.eliminarTarea(id);
    tareas = await db.obtenerTareas();
    expect(tareas, isEmpty);
  });
}
