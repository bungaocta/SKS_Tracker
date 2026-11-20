import 'package:flutter/material.dart';

import '../model/course.dart';
import '../viewmodel/course_viewmodel.dart';

/// VIEW - Halaman Detail Aktivitas
/// Desain: kartu counter besar dengan animasi, tombol bulat besar,
/// progress bar, dan aksi reset/hapus di bagian bawah.
class CourseDetailPage extends StatefulWidget {
  final Course course;
  final CourseViewModel viewModel;

  const CourseDetailPage({
    super.key,
    required this.course,
    required this.viewModel,
  });

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage>
    with SingleTickerProviderStateMixin {
  late Course _course;

  /// Animasi "pop" kecil setiap kali counter berubah.
  late final AnimationController _popController;
  late final Animation<double> _popAnimation;

  @override
  void initState() {
    super.initState();
    _course = widget.course;
    widget.viewModel.addListener(_onChanged);

    _popController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _popAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _popController, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(_onChanged);
    _popController.dispose();
    super.dispose();
  }

  void _onChanged() {
    final updated = widget.viewModel.getCourseById(_course.id);
    if (updated != null) {
      _course = updated;
    }
    _popController.forward(from: 0);
    if (mounted) setState(() {});
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 900),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _increment() {
    widget.viewModel.incrementCounter(_course.id);
    _showSnackBar('+"${_course.name}" jadi ${_course.counter + 1} tugas');
  }

  void _decrement() {
    if (_course.counter <= 0) {
      _showSnackBar('Nilai counter tidak boleh kurang dari 0');
      return;
    }
    widget.viewModel.decrementCounter(_course.id);
    _showSnackBar('Counter menjadi ${_course.counter - 1}');
  }

  /// AlertDialog konfirmasi sebelum reset.
  Future<void> _confirmReset() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: const Row(
          children: [
            Icon(Icons.refresh_rounded, color: Color(0xFF4F46E5)),
            SizedBox(width: 8),
            Text('Reset Counter'),
          ],
        ),
        content: Text(
            'Yakin ingin mengembalikan counter "${_course.name}" menjadi 0?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4F46E5),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      widget.viewModel.resetCounter(_course.id);
      _showSnackBar('Counter "${_course.name}" direset menjadi 0');
    }
  }

  /// Konfirmasi sebelum aktivitas dihapus.
  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: const Row(
          children: [
            Icon(Icons.delete_rounded, color: Color(0xFFEF4444)),
            SizedBox(width: 8),
            Text('Hapus Aktivitas'),
          ],
        ),
        content: Text('Yakin ingin menghapus "${_course.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      widget.viewModel.deleteCourse(_course.id);
      Navigator.pop(context); // kembali ke Home
    }
  }

  @override
  Widget build(BuildContext context) {
    // Progress: counter 0-10 dianggap skala penuh.
    final progress = (_course.counter / 10).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5FB),
      body: Column(
        children: [
          // ===== HEADER GRADIENT =====
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8,
              bottom: 28,
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _course.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Detail Aktivitas',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_rounded,
                      color: Colors.white),
                  tooltip: 'Edit nama',
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditNamePage(
                        course: _course,
                        viewModel: widget.viewModel,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ===== ISI =====
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 8),

                  // Kartu counter besar dengan animasi pop
                  ScaleTransition(
                    scale: _popAnimation,
                    child: Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF4F46E5),
                          width: 5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF4F46E5)
                                .withValues(alpha:0.25),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'TUGAS',
                            style: TextStyle(
                              fontSize: 12,
                              letterSpacing: 2,
                              color: Colors.black38,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${_course.counter}',
                            style: const TextStyle(
                              fontSize: 56,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4F46E5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Progress bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'Progres',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            Text(
                              'skala 0-10',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.black38,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: progress),
                            duration:
                                const Duration(milliseconds: 300),
                            builder: (context, value, _) =>
                                LinearProgressIndicator(
                              value: value,
                              minHeight: 10,
                              backgroundColor:
                                  Colors.grey.shade200,
                              valueColor:
                                  const AlwaysStoppedAnimation<Color>(
                                Color(0xFF4F46E5),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Tombol +/- besar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Tombol kurang (-)
                      _buildRoundButton(
                        icon: Icons.remove_rounded,
                        color: const Color(0xFFEF4444),
                        onTap: _decrement,
                      ),
                      const SizedBox(width: 28),
                      // Tombol tambah (+)
                      _buildRoundButton(
                        icon: Icons.add_rounded,
                        color: const Color(0xFF10B981),
                        onTap: _increment,
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Tombol Reset & Hapus
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          icon: Icons.refresh_rounded,
                          label: 'Reset',
                          color: const Color(0xFF4F46E5),
                          onTap: _confirmReset,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildActionButton(
                          icon: Icons.delete_rounded,
                          label: 'Hapus',
                          color: const Color(0xFFEF4444),
                          onTap: _confirmDelete,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Tombol bulat besar untuk +/- dengan efek tekan.
  Widget _buildRoundButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 76,
          height: 76,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha:0.35),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Icon(icon, color: Colors.white, size: 36),
        ),
      ),
    );
  }

  /// Tombol aksi (Reset / Hapus).
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: color.withValues(alpha:0.1),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withValues(alpha:0.4)),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Halaman kecil untuk mengubah nama aktivitas dari halaman detail.
class EditNamePage extends StatefulWidget {
  final Course course;
  final CourseViewModel viewModel;

  const EditNamePage({
    super.key,
    required this.course,
    required this.viewModel,
  });

  @override
  State<EditNamePage> createState() => _EditNamePageState();
}

class _EditNamePageState extends State<EditNamePage> {
  late TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.course.name);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      widget.viewModel.updateCourse(
          widget.course.id, _controller.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Nama diubah menjadi "${_controller.text.trim()}"'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5FB),
      body: Column(
        children: [
          // Header gradient
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
              children: const [
                BackButton(color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Ubah Nama Aktivitas',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
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
                        controller: _controller,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
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
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: _save,
                          icon: const Icon(Icons.save_rounded),
                          label: const Text(
                            'Simpan',
                            style: TextStyle(
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