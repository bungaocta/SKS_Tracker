import 'package:flutter/material.dart';

import '../viewmodel/course_viewmodel.dart';
import 'course_add_edit_page.dart';
import 'course_detail_page.dart';

/// VIEW - Halaman Home (Daftar Aktivitas)
/// Desain: header gradient + kartu berwarna dengan progress bar.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CourseViewModel _viewModel = CourseViewModel();

  // Palet warna kartu bergantian agar daftar tidak monoton.
  static const List<Color> _cardColors = [
    Color(0xFF6366F1), // indigo
    Color(0xFFEC4899), // pink
    Color(0xFF14B8A6), // teal
    Color(0xFFF59E0B), // amber
    Color(0xFF8B5CF6), // violet
    Color(0xFFEF4444), // red
  ];

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(_onChanged);
    _viewModel.loadCourses();
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onChanged);
    _viewModel.dispose();
    super.dispose();
  }

  /// Tampilan diperbarui otomatis ketika data berubah.
  void _onChanged() {
    if (mounted) setState(() {});
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _goToAddPage() async {
    final name = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CourseAddEditPage()),
    );
    if (name != null && name is String && mounted) {
      _viewModel.addCourse(name);
      _showSnackBar('Aktivitas "$name" berhasil ditambahkan');
    }
  }

  @override
  Widget build(BuildContext context) {
    final courses = _viewModel.courses;
    final totalTasks = courses.fold<int>(0, (sum, c) => sum + c.counter);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5FB),
      body: RefreshIndicator(
        onRefresh: () async {
          _viewModel.loadCourses();
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // ===== HEADER GRADIENT =====
            SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 24,
                  left: 20,
                  right: 20,
                  bottom: 32,
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
                child: SafeArea(
                  top: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'SKS Tracker',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Catat tugasmu, selesaikan!',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha:0.2),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.school_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Statistik ringkas
                      Row(
                        children: [
                          _buildStatBox('${courses.length}', 'Mata Kuliah'),
                          const SizedBox(width: 12),
                          _buildStatBox('$totalTasks', 'Total Tugas'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ===== LABEL DAFTAR =====
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                child: Row(
                  children: [
                    const Text(
                      'Daftar Mata Kuliah',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${courses.length} aktivitas',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black38,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ===== DAFTAR KARTU =====
            if (courses.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.menu_book_rounded,
                        size: 72,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Belum ada mata kuliah',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black38,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Tekan tombol + untuk menambahkan',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black26,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final course = courses[index];
                      final color = _cardColors[index % _cardColors.length];
                      return _buildCourseCard(course, color);
                    },
                    childCount: courses.length,
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToAddPage,
        backgroundColor: const Color(0xFF4F46E5),
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Tambah',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  /// Kotak statistik di header.
  Widget _buildStatBox(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha:0.15),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Kartu mata kuliah dengan warna, progress bar, dan tombol edit.
  Widget _buildCourseCard(dynamic course, Color color) {
    // Progress sederhana: counter 0-10 dianggap skala penuh.
    final progress = (course.counter / 10).clamp(0.0, 1.0);

    return GestureDetector(
      onTap: () => _goToDetailPage(course.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Lingkaran counter berwarna
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color.withValues(alpha:0.15),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                '${course.counter}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Nama + progress bar
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    course.counter == 0
                        ? 'Belum ada tugas'
                        : '${course.counter} tugas selesai',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black38,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 6,
                      backgroundColor: Colors.grey.shade100,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Tombol edit
            IconButton(
              icon: Icon(
                Icons.edit_rounded,
                size: 20,
                color: Colors.grey.shade400,
              ),
              onPressed: () => _goToEditPage(course.id),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Colors.black26,
            ),
          ],
        ),
      ),
    );
  }

  /// Ke halaman Detail.
  void _goToDetailPage(int id) async {
    final course = _viewModel.getCourseById(id);
    if (course == null) return;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CourseDetailPage(
          course: course,
          viewModel: _viewModel,
        ),
      ),
    );
    setState(() {});
  }

  /// Ke halaman Edit.
  void _goToEditPage(int id) async {
    final course = _viewModel.getCourseById(id);
    if (course == null) return;
    final newName = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CourseAddEditPage(course: course),
      ),
    );
    if (newName != null && newName is String && mounted) {
      _viewModel.updateCourse(id, newName);
      _showSnackBar('Nama aktivitas diubah menjadi "$newName"');
    }
  }
}