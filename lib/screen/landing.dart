import 'package:flutter/material.dart';

import 'package:lapor_keuangan/screen/login.dart';
import 'package:lapor_keuangan/screen/register.dart';

// ──────────────────────────────────────────────────────────────────
// Design Tokens
// ──────────────────────────────────────────────────────────────────
class LK {
  // Brand
  static const Color primary = Color(0xFF2563EB);
  static const Color primaryLight = Color(0xFFDBeaFE);
  static const Color primaryMid = Color(0xFF60A5FA);

  // Neutrals
  static const Color ink = Color(0xFF0F172A);
  static const Color inkDeep = Color(0xFF020617);
  static const Color slate = Color(0xFF475569);
  static const Color muted = Color(0xFF64748B);
  static const Color border = Color(0xFFE2E8F0);
  static const Color surface = Color(0xFFF8FAFC);
  static const Color white = Color(0xFFFFFFFF);

  // Semantic
  static const Color green = Color(0xFF16A34A);
  static const Color greenLight = Color(0xFFDCFCE7);
  static const Color red = Color(0xFFDC2626);
  static const Color amber = Color(0xFFD97706);
  static const Color amberLight = Color(0xFFFEF3C7);
  static const Color purple = Color(0xFF7C3AED);
  static const Color purpleLight = Color(0xFFEDE9FE);

  // Typography
  static const String font = 'Poppins';

  static TextStyle h1({Color? color}) => TextStyle(
        fontFamily: font,
        fontSize: 36,
        fontWeight: FontWeight.w800,
        color: color ?? ink,
        height: 1.15,
        letterSpacing: -0.8,
      );

  static TextStyle h2({Color? color}) => TextStyle(
        fontFamily: font,
        fontSize: 24,
        fontWeight: FontWeight.w800,
        color: color ?? ink,
        height: 1.25,
        letterSpacing: -0.4,
      );

  static TextStyle h3({Color? color}) => TextStyle(
        fontFamily: font,
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: color ?? ink,
        height: 1.4,
      );

  static TextStyle body({Color? color, double size = 14}) => TextStyle(
        fontFamily: font,
        fontSize: size,
        fontWeight: FontWeight.w400,
        color: color ?? muted,
        height: 1.65,
      );

  static TextStyle label({Color? color, double size = 11}) => TextStyle(
        fontFamily: font,
        fontSize: size,
        fontWeight: FontWeight.w600,
        color: color ?? muted,
        letterSpacing: 0.1,
      );

  static TextStyle tag({Color? color}) => TextStyle(
        fontFamily: font,
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: color ?? primary,
        letterSpacing: 1.6,
      );

  // Shadows
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
color: const Color(0xFF0F172A).withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 8)),
        BoxShadow(
color: const Color(0xFF0F172A).withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2)),
      ];

  static List<BoxShadow> get heroShadow => [
        BoxShadow(
            color: primary.withOpacity(0.2),
            blurRadius: 48,
            offset: const Offset(0, 20)),
      ];
}

// ──────────────────────────────────────────────────────────────────
// Landing Page
// ──────────────────────────────────────────────────────────────────
class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with TickerProviderStateMixin {
  late AnimationController _heroCtrl;
  late AnimationController _fadeCtrl;
  late Animation<double> _heroFade;
  late Animation<Offset> _heroSlide;
  late Animation<double> _contentFade;

  @override
  void initState() {
    super.initState();
    _heroCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));

    _heroFade = CurvedAnimation(parent: _heroCtrl, curve: Curves.easeOut);
    _heroSlide = Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero)
        .animate(CurvedAnimation(parent: _heroCtrl, curve: Curves.easeOut));
    _contentFade = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn);

    _heroCtrl.forward();
    Future.delayed(const Duration(milliseconds: 300), _fadeCtrl.forward);
  }

  @override
  void dispose() {
    _heroCtrl.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  void _pushLogin(BuildContext ctx) {
    Navigator.push(ctx, MaterialPageRoute(builder: (_) => const LoginPage()));
  }

  void _pushRegister(BuildContext ctx) {
    Navigator.push(
        ctx, MaterialPageRoute(builder: (_) => const RegisterPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LK.white,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(child: _buildHero()),
          SliverToBoxAdapter(child: _buildStats()),
          SliverToBoxAdapter(child: _buildFeatures()),
          SliverToBoxAdapter(child: _buildBenefits()),
          SliverToBoxAdapter(child: _buildCTA()),
          SliverToBoxAdapter(child: _buildFooter()),
        ],
      ),
    );
  }

  // ── App Bar ──────────────────────────────────────────────────────
  Widget _buildAppBar() {
    return SliverAppBar(
      floating: true,
      snap: true,
      pinned: false,
      toolbarHeight: 60,
      backgroundColor: LK.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: LK.white,
          border: Border(bottom: BorderSide(color: LK.border, width: 0.5)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _LKLogo(),
              Row(
                children: [
                  TextButton(
                    onPressed: () => _pushLogin(context),
                    style: TextButton.styleFrom(
                      foregroundColor: LK.slate,
                      textStyle: LK.label(color: LK.slate),
                    ),
                    child: const Text('Masuk'),
                  ),
                  const SizedBox(width: 6),
                  _PrimaryButton(
                    label: 'Daftar',
                    small: true,
                    onTap: () => _pushRegister(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Hero ─────────────────────────────────────────────────────────
  Widget _buildHero() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFEFF6FF),
            Color(0xFFDBEAFE),
            Color(0xFFFEF9C3),
          ],
          stops: [0.0, 0.55, 1.0],
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Decorative blobs
          Positioned(
            right: -80,
            top: -80,
            child: _Blob(size: 260, color: LK.primary.withOpacity(0.12)),
          ),
Positioned(
            left: -40,
            bottom: 80,
            child: _Blob(size: 180, color: LK.amber.withValues(alpha: 0.2)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 52, 24, 0),
            child: Column(
              children: [
                FadeTransition(
                  opacity: _heroFade,
                  child: SlideTransition(
                    position: _heroSlide,
                    child: Column(
                      children: [
                        // Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
color: LK.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: LK.primary.withOpacity(0.25),
                                width: 0.5),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('✦ ',
                                  style: TextStyle(
                                      fontSize: 10, color: LK.primary)),
                              Text('Kelola Keuangan Lebih Cerdas',
                                  style: LK.label(color: LK.primary)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 22),
                        // Headline
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: LK.h1(),
                            children: [
                              const TextSpan(text: 'Pantau Setiap\n'),
                              TextSpan(
                                text: 'Rupiah',
                                style: LK.h1(color: LK.primary),
                              ),
                              const TextSpan(text: ' dengan\nMudah'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Catat pemasukan & pengeluaran, analisis pola\nkeuangan, dan capai tujuan finansial Anda.',
                          textAlign: TextAlign.center,
                          style: LK.body(color: LK.muted, size: 14),
                        ),
                        const SizedBox(height: 28),
                        // CTA Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _PrimaryButton(
                              label: 'Mulai Gratis →',
                              onTap: () => _pushRegister(context),
                            ),
                            const SizedBox(width: 10),
                            _OutlineButton(
                              label: 'Masuk',
                              onTap: () => _pushLogin(context),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // Dashboard preview card
                FadeTransition(
                  opacity: _contentFade,
                  child: _DashboardPreviewCard(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Stats ─────────────────────────────────────────────────────────
  Widget _buildStats() {
    return Container(
      color: LK.ink,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(value: '10K+', label: 'Pengguna Aktif'),
          _VertDivider(),
          _StatItem(value: '99%', label: 'Kepuasan'),
          _VertDivider(),
          _StatItem(value: 'Free', label: 'Selamanya'),
        ],
      ),
    );
  }

  // ── Features ──────────────────────────────────────────────────────
  Widget _buildFeatures() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('FITUR UNGGULAN', style: LK.tag()),
          const SizedBox(height: 8),
          Text('Semua yang kamu\nbutuhkan, dalam satu app', style: LK.h2()),
          const SizedBox(height: 32),
          _FeatureCard(
            gradient: const LinearGradient(
              colors: [Color(0xFFDBEAFE), Color(0xFFEDE9FE)],
            ),
            illustrationColor: LK.primary,
            icon: Icons.bar_chart_rounded,
            iconColor: LK.primary,
            iconBg: LK.primaryLight,
            title: 'Dashboard Analitik',
            desc:
                'Grafik visual interaktif untuk memantau tren pemasukan dan pengeluaran bulanan secara real-time.',
            child: _ChartIllustration(),
          ),
          const SizedBox(height: 14),
          _FeatureCard(
            gradient: const LinearGradient(
              colors: [Color(0xFFDCFCE7), Color(0xFFD1FAE5)],
            ),
            illustrationColor: LK.green,
            icon: Icons.receipt_long_rounded,
            iconColor: LK.green,
            iconBg: LK.greenLight,
            title: 'Pencatatan Transaksi',
            desc:
                'Catat setiap transaksi dengan kategori, deskripsi, dan tanggal. Ekspor laporan kapan saja.',
            child: _TransactionIllustration(),
          ),
          const SizedBox(height: 14),
          _FeatureCard(
            gradient: const LinearGradient(
              colors: [Color(0xFFFEF9C3), Color(0xFFFEF3C7)],
            ),
            illustrationColor: LK.amber,
            icon: Icons.savings_rounded,
            iconColor: LK.amber,
            iconBg: LK.amberLight,
            title: 'Target Tabungan',
            desc:
                'Tetapkan tujuan keuangan dan pantau progres menabung dengan tampilan yang memotivasi.',
            child: _SavingsIllustration(),
          ),
        ],
      ),
    );
  }

  // ── Benefits ──────────────────────────────────────────────────────
  Widget _buildBenefits() {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 56, 24, 0),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: LK.primaryLight,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFBFDBFE), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Mengapa LaporKeuangan?', style: LK.h3()),
          const SizedBox(height: 20),
          _BenefitRow(
            icon: Icons.lock_outline_rounded,
            title: 'Data Aman & Privat',
            desc: 'Semua data tersimpan lokal di perangkat Anda.',
          ),
          _BenefitRow(
            icon: Icons.offline_bolt_outlined,
            title: 'Bisa Offline',
            desc: 'Catat transaksi kapan saja tanpa internet.',
          ),
          _BenefitRow(
            icon: Icons.pie_chart_outline_rounded,
            title: 'Laporan Lengkap',
            desc: 'Ringkasan mingguan, bulanan, dan tahunan otomatis.',
          ),
          _BenefitRow(
            icon: Icons.notifications_none_rounded,
            title: 'Pengingat Cerdas',
            desc: 'Notifikasi saat mendekati batas anggaran bulanan.',
            isLast: true,
          ),
        ],
      ),
    );
  }

  // ── CTA ────────────────────────────────────────────────────────────
  Widget _buildCTA() {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 56, 24, 56),
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
      decoration: BoxDecoration(
        color: LK.ink,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Text(
            'Mulai Perjalanan\nFinansial Anda',
            textAlign: TextAlign.center,
            style: LK.h2(color: LK.white),
          ),
          const SizedBox(height: 10),
          Text(
            'Gratis selamanya. Tidak perlu kartu kredit.',
            textAlign: TextAlign.center,
            style: LK.label(color: LK.primaryMid),
          ),
          const SizedBox(height: 26),
          SizedBox(
            width: double.infinity,
            child: _PrimaryButton(
              label: 'Daftar Sekarang — Gratis',
              onTap: () => _pushRegister(context),
              large: true,
            ),
          ),
        ],
      ),
    );
  }

  // ── Footer ─────────────────────────────────────────────────────────
  Widget _buildFooter() {
    return Container(
      color: LK.inkDeep,
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LKLogo(dark: true),
          const SizedBox(height: 12),
          Text(
            'Aplikasi pencatatan keuangan personal\nyang sederhana, aman, dan powerful.',
            style: LK.body(color: LK.primaryMid, size: 13),
          ),
          const SizedBox(height: 24),
          Divider(color: const Color(0xFF1E3A5F), thickness: 0.5),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('© 2024 LaporKeuangan',
                  style: LK.label(color: const Color(0xFF475569), size: 11)),
              Row(
                children: ['Privasi', 'Syarat', 'Kontak']
                    .map((l) => Padding(
                          padding: const EdgeInsets.only(left: 14),
                          child: Text(l,
                              style: LK.label(
                                  color: const Color(0xFF94A3B8), size: 11)),
                        ))
                    .toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────
// Reusable Components
// ──────────────────────────────────────────────────────────────────

class _LKLogo extends StatelessWidget {
  final bool dark;
  const _LKLogo({this.dark = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: LK.primary,
            borderRadius: BorderRadius.circular(9),
          ),
          child: const Icon(Icons.account_balance_wallet_rounded,
              color: LK.white, size: 17),
        ),
        const SizedBox(width: 9),
        Text(
          'LaporKeuangan',
          style: TextStyle(
            fontFamily: LK.font,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: dark ? LK.white : LK.ink,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool small;
  final bool large;

  const _PrimaryButton({
    required this.label,
    required this.onTap,
    this.small = false,
    this.large = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: LK.primary,
        foregroundColor: LK.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        padding: EdgeInsets.symmetric(
          horizontal: small ? 18 : 26,
          vertical: small ? 10 : (large ? 16 : 13),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        textStyle: TextStyle(
          fontFamily: LK.font,
          fontSize: small ? 13 : (large ? 15 : 14),
          fontWeight: FontWeight.w700,
        ),
      ),
      child: Text(label),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _OutlineButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: LK.ink,
        side: const BorderSide(color: Color(0xFFCBD5E1), width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: TextStyle(
          fontFamily: LK.font,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      child: Text(label),
    );
  }
}

class _Blob extends StatelessWidget {
  final double size;
  final Color color;
  const _Blob({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

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
                fontFamily: 'Poppins',
                color: LK.white,
                fontWeight: FontWeight.w800,
                fontSize: 20,
                letterSpacing: -0.4)),
        const SizedBox(height: 4),
        Text(label, style: LK.label(color: const Color(0xFF94A3B8), size: 11)),
      ],
    );
  }
}

class _VertDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Container(width: 0.5, height: 36, color: const Color(0xFF1E3A5F));
}

// ──────────────────────────────────────────────────────────────────
// Feature Card with inline illustration
// ──────────────────────────────────────────────────────────────────
class _FeatureCard extends StatelessWidget {
  final Gradient gradient;
  final Color illustrationColor;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String desc;
  final Widget child;

  const _FeatureCard({
    required this.gradient,
    required this.illustrationColor,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.desc,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: LK.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: LK.border, width: 0.5),
        boxShadow: LK.cardShadow,
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Illustration area
          Container(
            height: 140,
            decoration: BoxDecoration(gradient: gradient),
            child: Center(child: child),
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
                        color: iconBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(icon, color: iconColor, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Text(title, style: LK.h3()),
                  ],
                ),
                const SizedBox(height: 10),
                Text(desc, style: LK.body()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────
// Inline illustrations (no network images needed)
// ──────────────────────────────────────────────────────────────────

class _ChartIllustration extends StatelessWidget {
  const _ChartIllustration();
  @override
  Widget build(BuildContext context) {
    final bars = [0.4, 0.6, 0.35, 0.8, 0.55, 1.0];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: bars.asMap().entries.map((e) {
          final isHighlight = e.key == 3 || e.key == 5;
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              height: 80 * e.value,
              decoration: BoxDecoration(
                color: isHighlight ? LK.primary : LK.primary.withOpacity(0.22),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(4)),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _TransactionIllustration extends StatelessWidget {
  const _TransactionIllustration();
  static const _items = [
    ('Makan siang', '-Rp 35k', Color(0xFFDC2626)),
    ('Gaji Masuk', '+Rp 8,4jt', Color(0xFF16A34A)),
    ('Belanja', '-Rp 150k', Color(0xFFDC2626)),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: LK.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: LK.cardShadow,
        ),
        child: Column(
          children: _items.asMap().entries.map((e) {
            final item = e.value;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                border: e.key > 0
                    ? Border(top: BorderSide(color: LK.border, width: 0.5))
                    : null,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item.$1, style: LK.label(color: LK.ink, size: 11)),
                  Text(item.$2, style: LK.label(color: item.$3, size: 11)),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _SavingsIllustration extends StatelessWidget {
  const _SavingsIllustration();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: LK.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: LK.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Liburan ke Jepang 🇯🇵',
                style: LK.label(color: LK.ink, size: 11)),
            const SizedBox(height: 8),
            Stack(
              children: [
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: LK.border,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: 0.68,
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: LK.amber,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Rp 6,8 jt / Rp 10 jt',
                    style: LK.label(color: LK.muted, size: 10)),
                Text('68%', style: LK.label(color: LK.amber, size: 10)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────
// Dashboard Preview Card (Hero section)
// ──────────────────────────────────────────────────────────────────
class _DashboardPreviewCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: LK.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: LK.heroShadow,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Window chrome dots
          Row(
            children: [
              _Dot(color: const Color(0xFFF87171)),
              const SizedBox(width: 5),
              _Dot(color: const Color(0xFFFBBF24)),
              const SizedBox(width: 5),
              _Dot(color: const Color(0xFF4ADE80)),
              const SizedBox(width: 10),
              Text('Dashboard Overview',
                  style: LK.label(color: LK.muted, size: 10)),
            ],
          ),
          const SizedBox(height: 14),
          // Summary cards
          Row(
            children: [
              Expanded(
                child: _MiniCard(
                    label: 'Pemasukan',
                    value: 'Rp 8,4 jt',
                    valueColor: LK.green),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MiniCard(
                    label: 'Pengeluaran',
                    value: 'Rp 3,2 jt',
                    valueColor: LK.red),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Mini chart
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: LK.surface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tren 6 bulan terakhir',
                    style: LK.label(color: LK.muted, size: 10)),
                const SizedBox(height: 10),
                const _MiniBarChart(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final Color color;
  const _Dot({required this.color});
  @override
  Widget build(BuildContext context) => Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color));
}

class _MiniCard extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  const _MiniCard(
      {required this.label, required this.value, required this.valueColor});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: LK.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: LK.label(color: LK.muted, size: 10)),
          const SizedBox(height: 3),
          Text(value,
              style: TextStyle(
                fontFamily: LK.font,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: valueColor,
              )),
        ],
      ),
    );
  }
}

class _MiniBarChart extends StatelessWidget {
  const _MiniBarChart();
  @override
  Widget build(BuildContext context) {
    final heights = [0.38, 0.55, 0.33, 0.70, 0.58, 0.92];
    return SizedBox(
      height: 40,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: heights.asMap().entries.map((e) {
          final highlight = e.key == 3 || e.key == 5;
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              height: 40 * e.value,
              decoration: BoxDecoration(
                color: highlight ? LK.primary : LK.primary.withOpacity(0.22),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(3)),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────
// Benefit Row
// ──────────────────────────────────────────────────────────────────
class _BenefitRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;
  final bool isLast;
  const _BenefitRow({
    required this.icon,
    required this.title,
    required this.desc,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: LK.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: LK.primary, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: LK.h3(color: LK.ink).copyWith(fontSize: 13)),
                const SizedBox(height: 2),
                Text(desc, style: LK.body(color: LK.muted, size: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
