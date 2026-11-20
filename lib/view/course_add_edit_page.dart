import 'package:flutter/material.dart';

import '../model/course.dart';

/// VIEW - Halaman Tambah/Edit Aktivitas
/// Desain: header gradient + kartu form dengan ikon.
class CourseAddEditPage extends StatefulWidget {
  final Course? course; // null = tambah baru, tidak null = edit

  const CourseAddEditPage({super.key, this.course});

  @override
  State<CourseAddEditPage> createState() => _CourseAddEditPageState();
}

class _CourseAddEditPageState extends State<CourseAddEditPage> {
  late TextEditingController _nameController;
  final _formKey = GlobalKey<FormState>();

  bool get _isEdit => widget.course != null;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.course?.name ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  /// Validasi: nama aktivitas tidak boleh kosong.
  void _save() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, _nameController.text.trim());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Nama aktivitas tidak boleh kosong!'),
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5FB),
      body: Column(
        children: [
          // ===== HEADER GRADIENT =====
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8,
              bottom: 24,
              left: 8,
              right: 20,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: Row(
              children: [
                BackButton(color: Colors.white),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isEdit ? 'Edit Mata Kuliah' : 'Tambah Mata Kuliah',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _isEdit
                          ? 'Perbarui nama aktivitasmu'
                          : 'Aktivitas baru untuk dilacak',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ===== FORM =====
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha:0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Ikon besar di atas form
                      Center(
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: const Color(0xFF4F46E5)
                                .withValues(alpha:0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.school_rounded,
                            size: 36,
                            color: Color(0xFF4F46E5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Nama Mata Kuliah',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _nameController,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          hintText: 'Contoh: Pemrograman Mobile',
                          prefixIcon: const Icon(
                            Icons.menu_book_rounded,
                            color: Color(0xFF4F46E5),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF8FAFC),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: Color(0xFF4F46E5),
                              width: 2,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: Color(0xFFEF4444),
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 16,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Nama aktivitas tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      // Tombol Simpan
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: _save,
                          icon: const Icon(Icons.save_rounded),
                          label: Text(
                            _isEdit ? 'Simpan Perubahan' : 'Simpan',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4F46E5),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Tombol batal sekunder
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Batal',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black45,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}