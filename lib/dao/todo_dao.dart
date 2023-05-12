

import 'package:floor/floor.dart';
import '../model/todo_detail.dart';

@dao
abstract class ToDoDetailDao {
  @Query('SELECT * FROM ToDoDetail')
  Future<List<ToDoDetail>> getAllDetail();

  @Query('SELECT * FROM ToDoDetail WHERE id LIKE :id')
  Future<List<ToDoDetail>> getAlldetailsByid(String id);

  @insert
  Future<void> insertDetail(ToDoDetail transactions);

  @update
  Future<void> updateDetail(ToDoDetail transactions);

  @delete
  Future<void> deleteDetail(ToDoDetail transactions);
}
