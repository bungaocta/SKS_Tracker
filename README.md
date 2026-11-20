# SKS Tracker — UTS Pemrograman Mobile

Aplikasi Activity Counter bertema pencatat tugas mata kuliah, dibangun dengan Flutter dan arsitektur **MVVM** (Model–Data–Repository–ViewModel–View).

## Struktur Folder

```
lib/
├── main.dart                      # Entry point aplikasi
├── model/
│   └── course.dart                # MODEL: struktur data aktivitas (id, nama, counter)
├── data/
│   └── course_data.dart           # DATA: sumber data awal, penyimpanan sementara (List)
├── repository/
│   └── course_repository.dart     # REPOSITORY: akses & manipulasi data (CRUD + counter)
├── viewmodel/
│   └── course_viewmodel.dart      # VIEWMODEL: logika & state (ChangeNotifier)
└── view/
    ├── home_page.dart             # Halaman 1: daftar aktivitas
    ├── course_add_edit_page.dart  # Halaman 2: tambah/edit aktivitas
    └── course_detail_page.dart    # Halaman 3: detail + counter (+/-/reset/hapus)
```

## Alur Data (penting untuk penilaian)

**View → ViewModel → Repository → Data**

1. **View** (halaman) menerima interaksi pengguna (tombol +, −, reset, hapus, dsb).
2. **View** memanggil fungsi di **ViewModel**.
3. **ViewModel** meneruskan perintah ke **Repository**.
4. **Repository** membaca/mengubah **Data** (List di memori).
5. **ViewModel** memanggil `notifyListeners()` sehingga **View** yang sedang mendengarkan (addListener) membangun ulang tampilan secara otomatis.

## Fitur

- 3 halaman dengan navigasi (Navigator.push/pop).
- Tambah, edit nama, hapus, dan lihat detail aktivitas.
- Counter +1 / −1 (tidak boleh di bawah 0), reset ke 0.
- Validasi: nama aktivitas tidak boleh kosong.
- SnackBar saat tambah/hapus/counter berubah.
- AlertDialog konfirmasi sebelum reset dan hapus.
- Data disimpan sementara dengan List (tanpa database/API).

## Menjalankan

```bash
flutter pub get
flutter run
```