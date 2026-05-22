import 'package:flutter/material.dart';
import 'package:lapor_keuangan/theme/app_theme.dart';
import 'package:lapor_keuangan/screen/login.dart';
import 'package:lapor_keuangan/screen/register.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with TickerProviderStateMixin {
  late AnimationController _heroController;
  late AnimationController _fadeController;
  late Animation<double> _heroFade;
  late Animation<Offset> _heroSlide;
  late Animation<double> _contentFade;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _heroController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _heroFade = CurvedAnimation(parent: _heroController, curve: Curves.easeOut);
    _heroSlide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _heroController, curve: Curves.easeOut));

    _contentFade =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);

    _heroController.forward();
    Future.delayed(const Duration(milliseconds: 400), () {
      _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _heroController.dispose();
    _fadeController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildHeader(),
          SliverToBoxAdapter(child: _buildHeroBanner()),
          SliverToBoxAdapter(child: _buildStatsSection()),
          SliverToBoxAdapter(child: _buildFeaturesSection()),
          SliverToBoxAdapter(child: _buildBenefitsSection()),
          SliverToBoxAdapter(child: _buildCTASection()),
          SliverToBoxAdapter(child: _buildFooter()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: AppColors.white,
      elevation: 0,
      pinned: false,
      expandedHeight: 64,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          border: Border(
            bottom: BorderSide(color: AppColors.divider, width: 1),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Logo
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.account_balance_wallet,
                      color: AppColors.white, size: 20),
                ),
                const SizedBox(width: 10),
                const Text(
                  'LaporKeuangan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.dark,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
            // Nav buttons
            Row(
              children: [
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  ),
                  child: const Text(
                    'Masuk',
                    style: TextStyle(
                      color: AppColors.dark,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterPage()),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    textStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins'),
                  ),
                  child: const Text('Daftar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFEAF4FC), Color(0xFFBFDDF0), Color(0xFFFFEBCC)],
        ),
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            right: -60,
            top: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.15),
              ),
            ),
          ),
          Positioned(
            left: -30,
            bottom: -30,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accent.withOpacity(0.4),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 48, 24, 0),
            child: Column(
              children: [
                FadeTransition(
                  opacity: _heroFade,
                  child: SlideTransition(
                    position: _heroSlide,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            '✦ Kelola Keuangan Lebih Cerdas',
                            style: TextStyle(
                              color: AppColors.dark,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Pantau Setiap\nRupiah dengan\nMudah',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.w800,
                            color: AppColors.darker,
                            height: 1.15,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Catat pemasukan & pengeluaran, analisis pola keuangan,\ndan capai tujuan finansial Anda dengan lebih terarah.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textMuted,
                            height: 1.6,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(height: 28),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const RegisterPage()),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.dark,
                                foregroundColor: AppColors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 28, vertical: 14),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              child: const Text(
                                'Mulai Gratis →',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            OutlinedButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const LoginPage()),
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.dark,
                                side: const BorderSide(color: AppColors.dark),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 28, vertical: 14),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              child: const Text(
                                'Masuk',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 36),
                // Hero Image / Dashboard Preview
                FadeTransition(
                  opacity: _contentFade,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.25),
                          blurRadius: 40,
                          offset: const Offset(0, 16),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      child: Image.network(
                        'https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?w=800&q=80',
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            height: 220,
                            color: AppColors.light,
                            child: const Center(
                              child: CircularProgressIndicator(
                                  color: AppColors.primary),
                            ),
                          );
                        },
                        errorBuilder: (_, __, ___) => Container(
                          height: 220,
                          color: AppColors.light,
                          child: const Icon(Icons.bar_chart,
                              size: 80, color: AppColors.primary),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      color: AppColors.dark,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          _StatItem(value: '10K+', label: 'Pengguna Aktif'),
          _StatDivider(),
          _StatItem(value: '99%', label: 'Kepuasan'),
          _StatDivider(),
          _StatItem(value: 'Free', label: 'Selamanya'),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 56, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Fitur Unggulan',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
              letterSpacing: 2,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Semua yang kamu\nbutuhkan, dalam satu app',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: AppColors.darker,
              height: 1.25,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 32),
          _FeatureCard(
            icon: Icons.show_chart,
            iconBg: AppColors.primary,
            title: 'Dashboard Analitik',
            desc:
                'Grafik visual interaktif untuk memantau tren pemasukan dan pengeluaran bulanan Anda secara real-time.',
            imageUrl:
                'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=600&q=80',
          ),
          const SizedBox(height: 16),
          _FeatureCard(
            icon: Icons.receipt_long,
            iconBg: const Color(0xFF8CC0EB),
            title: 'Pencatatan Transaksi',
            desc:
                'Catat setiap transaksi dengan kategori, deskripsi, dan tanggal. Ekspor laporan kapan saja.',
            imageUrl:
                'https://images.unsplash.com/photo-1554224155-6726b3ff858f?w=600&q=80',
          ),
          const SizedBox(height: 16),
          _FeatureCard(
            icon: Icons.savings,
            iconBg: const Color(0xFFFFD166),
            title: 'Target Tabungan',
            desc:
                'Tetapkan tujuan keuangan dan pantau progres menabung Anda dengan tampilan yang memotivasi.',
            imageUrl:
                'https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?w=600&q=80',
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitsSection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 56, 24, 0),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.12),
            AppColors.accent.withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mengapa LaporKeuangan?',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.darker,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 20),
          ...[
            _BenefitRow(
              icon: Icons.lock_outline,
              title: 'Data Aman & Privat',
              desc: 'Semua data tersimpan lokal di perangkat Anda.',
            ),
            _BenefitRow(
              icon: Icons.offline_bolt_outlined,
              title: 'Bisa Offline',
              desc: 'Catat transaksi kapan saja tanpa internet.',
            ),
            _BenefitRow(
              icon: Icons.pie_chart_outline,
              title: 'Laporan Lengkap',
              desc: 'Ringkasan mingguan, bulanan, dan tahunan otomatis.',
            ),
            _BenefitRow(
              icon: Icons.notifications_none,
              title: 'Pengingat Cerdas',
              desc: 'Notifikasi saat mendekati batas anggaran bulanan.',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCTASection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 56, 24, 56),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.dark,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Text(
            'Mulai Perjalanan\nFinansial Anda',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.white,
              height: 1.3,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Gratis selamanya. Tidak perlu kartu kredit.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF8CC0EB),
              fontSize: 13,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RegisterPage()),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'Daftar Sekarang — Gratis',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      color: AppColors.darker,
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.account_balance_wallet,
                    color: AppColors.white, size: 18),
              ),
              const SizedBox(width: 10),
              const Text(
                'LaporKeuangan',
                style: TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Aplikasi pencatatan keuangan personal\nyang sederhana, aman, dan powerful.',
            style: TextStyle(
              color: Color(0xFF8CC0EB),
              fontSize: 13,
              height: 1.6,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 24),
          const Divider(color: Color(0xFF2D4A6B)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '© 2024 LaporKeuangan',
                style: TextStyle(
                  color: Color(0xFF8CC0EB),
                  fontSize: 12,
                  fontFamily: 'Poppins',
                ),
              ),
              Row(
                children: [
                  _FooterLink(label: 'Privasi'),
                  const SizedBox(width: 16),
                  _FooterLink(label: 'Syarat'),
                  const SizedBox(width: 16),
                  _FooterLink(label: 'Kontak'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────
// Helper widgets
// ──────────────────────────────────────────────────────────────────

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w800,
                fontSize: 22,
                fontFamily: 'Poppins')),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(
                color: AppColors.light,
                fontSize: 12,
                fontFamily: 'Poppins')),
      ],
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 1, height: 36, color: AppColors.primary.withOpacity(0.4));
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final String title;
  final String desc;
  final String imageUrl;

  const _FeatureCard({
    required this.icon,
    required this.iconBg,
    required this.title,
    required this.desc,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              imageUrl,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 160,
                color: AppColors.light,
                child: Icon(icon, size: 60, color: iconBg),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                          color: iconBg.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10)),
                      child: Icon(icon, color: iconBg, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: AppColors.darker,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  desc,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 13,
                    height: 1.6,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BenefitRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;
  const _BenefitRow(
      {required this.icon, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.darker,
                        fontFamily: 'Poppins',
                        fontSize: 14)),
                const SizedBox(height: 2),
                Text(desc,
                    style: const TextStyle(
                        color: AppColors.textMuted,
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        height: 1.5)),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String label;
  const _FooterLink({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
          color: AppColors.light, fontSize: 12, fontFamily: 'Poppins'),
    );
  }
}
