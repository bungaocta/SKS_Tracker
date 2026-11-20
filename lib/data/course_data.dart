import '../model/course.dart';
 
/// DATA
/// Bertugas menyediakan sumber data yang digunakan aplikasi.
/// Menyimpan daftar aktivitas sementara menggunakan List
/// (tidak memerlukan database / API).
class CourseData {
  /// Data awal yang tersedia saat aplikasi pertama dijalankan.
  static final List<Course> courseList = [
    Course(id: 1, name: 'Pemrograman Mobile', counter: 2),
    Course(id: 2, name: 'Basis Data', counter: 1),
    Course(id: 3, name: 'Jaringan Komputer', counter: 0),
  ];
 
  /// ID berikutnya untuk aktivitas baru.
  static int nextId = 4;
 
  static int getNewId() {
    return nextId++;
  }
}