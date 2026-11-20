import 'package:flutter/foundation.dart';

import '../model/course.dart';
import '../repository/course_repository.dart';

/// VIEWMODEL
/// Bertugas mengelola logika aplikasi dan state.
/// Menggunakan ChangeNotifier agar View bisa "mendengarkan"
/// perubahan data dan memperbarui tampilan secara otomatis.
class CourseViewModel extends ChangeNotifier {
  final CourseRepository _repository = CourseRepository();

  final List<Course> _courses = [];

  /// Getter daftar aktivitas untuk View (read-only).
  List<Course> get courses => List.unmodifiable(_courses);

  /// Meminta data aktivitas dari Repository (dipanggil saat pertama kali).
  void loadCourses() {
    _courses
      ..clear()
      ..addAll(_repository.getCourses());
    notifyListeners();
  }

  /// Menambahkan aktivitas baru.
  void addCourse(String name) {
    final course = _repository.addCourse(name);
    _courses.add(course);
    notifyListeners();
  }

  /// Mengubah nama aktivitas.
  void updateCourse(int id, String newName) {
    _repository.updateCourse(id, newName);
    loadCourses();
  }

  /// Menghapus aktivitas.
  void deleteCourse(int id) {
    _repository.deleteCourse(id);
    _courses.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  /// Menambah counter (+1).
  void incrementCounter(int id) {
    _repository.incrementCounter(id);
    notifyListeners();
  }

  /// Mengurangi counter (-1), tidak boleh di bawah 0.
  void decrementCounter(int id) {
    _repository.decrementCounter(id);
    notifyListeners();
  }

  /// Reset counter menjadi 0.
  void resetCounter(int id) {
    _repository.resetCounter(id);
    notifyListeners();
  }

  /// Mencari satu aktivitas berdasarkan ID.
  Course? getCourseById(int id) {
    try {
      return _courses.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }
}