import '../data/course_data.dart';
import '../model/course.dart';
 
/// REPOSITORY
/// Bertugas mengelola akses dan manipulasi data.
/// ViewModel tidak menyentuh Data secara langsung,
/// melainkan melalui Repository ini.
class CourseRepository {
  /// Mengambil seluruh data aktivitas.
  List<Course> getCourses() {
    return CourseData.courseList;
  }
 
  /// Menambahkan aktivitas baru.
  Course addCourse(String name) {
    final course = Course(
      id: CourseData.getNewId(),
      name: name,
      counter: 0,
    );
    CourseData.courseList.add(course);
    return course;
  }
 
  /// Mengubah nama aktivitas.
  void updateCourse(int id, String newName) {
    final course = _findById(id);
    if (course != null) {
      course.name = newName;
    }
  }
 
  /// Menghapus aktivitas.
  void deleteCourse(int id) {
    CourseData.courseList.removeWhere((course) => course.id == id);
  }
 
  /// Menambah nilai counter sebanyak 1.
  void incrementCounter(int id) {
    final course = _findById(id);
    if (course != null) {
      course.counter++;
    }
  }
 
  /// Mengurangi nilai counter sebanyak 1 (tidak boleh di bawah 0).
  void decrementCounter(int id) {
    final course = _findById(id);
    if (course != null && course.counter > 0) {
      course.counter--;
    }
  }
 
  /// Mengembalikan nilai counter menjadi 0.
  void resetCounter(int id) {
    final course = _findById(id);
    if (course != null) {
      course.counter = 0;
    }
  }
 
  /// Mencari aktivitas berdasarkan ID.
  Course? _findById(int id) {
    try {
      return CourseData.courseList.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }
}