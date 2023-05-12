
import 'dart:async';

import 'package:floor/floor.dart';
import 'package:todoapp/dao/todo_dao.dart';
import '../model/todo_detail.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part '../db_class.g.dart';



@Database(version: 1, entities: [ToDoDetail])
abstract class ToDoData extends FloorDatabase{
  ToDoDetailDao get detailDao;
}