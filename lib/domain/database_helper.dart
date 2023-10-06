import 'package:sqflite/sqflite.dart';

abstract class DatabaseHelper {
  Future<Database> get db;

  Future<Database> initDatabase();
}