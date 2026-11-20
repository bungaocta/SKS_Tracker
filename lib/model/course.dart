/// MODEL
/// Bertugas mendefinisikan struktur objek data aktivitas.
/// Setiap aktivitas = satu mata kuliah dengan counter jumlah tugas.
class Course {
  final int id;
  String name;
  int counter;
 
  Course({
    required this.id,
    required this.name,
    this.counter = 0,
  });
}
 