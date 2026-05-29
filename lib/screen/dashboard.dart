import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lapor_keuangan/theme/app_theme.dart';
import 'package:lapor_keuangan/screen/add_transaction.dart';
import 'package:lapor_keuangan/db/hive_helper.dart';
import 'package:lapor_keuangan/model/transaction_model.dart';

class DashboardPage extends StatefulWidget {
  final String username;
  const DashboardPage({super.key, required this.username});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late TabController _tabController;
  List<TransactionModel> _transactions = [];
  String _selectedPeriod = 'Bulan Ini';

  // Summary computed from transactions
  double get totalIncome => _transactions
      .where((t) => t.type == 'income')
      .fold(0.0, (sum, t) => sum + (t.amount ?? 0));

  double get totalExpense => _transactions
      .where((t) => t.type == 'expense')
      .fold(0.0, (sum, t) => sum + (t.amount ?? 0));

  double get balance => totalIncome - totalExpense;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadTransactions();
  }

  void _loadTransactions() {
    setState(() {
      _transactions = HiveHelper.getTransactions();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomeTab(),
          _buildTransactionsTab(),
          _buildProfileTab(),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: _selectedIndex == 0 || _selectedIndex == 1
          ? FloatingActionButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddTransactionPage()),
                );
                _loadTransactions();
              },
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: const Icon(Icons.add, size: 28),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  // ──────────────────────────────────────────────
  // HOME TAB
  // ──────────────────────────────────────────────
  Widget _buildHomeTab() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _buildHeader()),
        SliverToBoxAdapter(child: _buildBalanceCard()),
        SliverToBoxAdapter(child: _buildChartCard()),
        SliverToBoxAdapter(child: _buildCategoryBreakdown()),
        SliverToBoxAdapter(child: _buildRecentTransactions()),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  Widget _buildHeader() {
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = 'Selamat Pagi';
    } else if (hour < 17) {
      greeting = 'Selamat Siang';
    } else {
      greeting = 'Selamat Malam';
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 56, 24, 20),
      color: AppColors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 13,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 2),
              Text(
                widget.username,
                style: const TextStyle(
                  color: AppColors.darker,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.light],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Text(
                widget.username.isNotEmpty
                    ? widget.username[0].toUpperCase()
                    : 'U',
                style: const TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.dark, AppColors.darker],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.dark.withOpacity(0.35),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Saldo',
                style: TextStyle(
                  color: AppColors.light,
                  fontSize: 13,
                  fontFamily: 'Poppins',
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<String>(
                  value: _selectedPeriod,
                  dropdownColor: AppColors.dark,
                  style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 11,
                      fontFamily: 'Poppins'),
                  underline: const SizedBox(),
                  icon: const Icon(Icons.keyboard_arrow_down,
                      color: AppColors.light, size: 16),
                  items: ['Bulan Ini', '3 Bulan', 'Tahun Ini']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedPeriod = v!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _formatCurrency(balance),
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 32,
              fontWeight: FontWeight.w800,
              fontFamily: 'Poppins',
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _BalanceStat(
                label: 'Pemasukan',
                value: _formatCurrency(totalIncome),
                icon: Icons.arrow_downward,
                color: AppColors.success,
              ),
              const SizedBox(width: 16),
              Container(
                  width: 1,
                  height: 40,
                  color: AppColors.white.withOpacity(0.15)),
              const SizedBox(width: 16),
              _BalanceStat(
                label: 'Pengeluaran',
                value: _formatCurrency(totalExpense),
                icon: Icons.arrow_upward,
                color: AppColors.danger,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard() {
    // 1. Siapkan data untuk 6 bulan terakhir
    final now = DateTime.now();
    final List<String> months = [];
    final List<double> incomeData = List.filled(6, 0.0);
    final List<double> expenseData = List.filled(6, 0.0);

    // Ambil label bulan (contoh: Jan, Feb, Mar)
    for (int i = 5; i >= 0; i--) {
      final monthDate = DateTime(now.year, now.month - i, 1);
      months.add(DateFormat('MMM', 'id_ID').format(monthDate));
    }

    // 2. Hitung total pemasukan & pengeluaran per bulan dari _transactions
    for (var t in _transactions) {
      if (t.date != null) {
        try {
          // Parse tanggal transaksi (Format: dd MMM yyyy)
          final tDate = DateFormat('dd MMM yyyy', 'id_ID').parse(t.date!);

          // Hitung selisih bulan dari sekarang
          int monthDiff =
              (now.year - tDate.year) * 12 + now.month - tDate.month;

          // Jika transaksi terjadi dalam 6 bulan terakhir, masukkan ke grafik
          if (monthDiff >= 0 && monthDiff < 6) {
            int index = 5 - monthDiff;
            if (t.type == 'income') {
              incomeData[index] += t.amount ?? 0;
            } else if (t.type == 'expense') {
              expenseData[index] += t.amount ?? 0;
            }
          }
        } catch (e) {
          // Abaikan jika format tanggal salah
        }
      }
    }

    // 3. Cari nilai maksimal untuk tinggi grafik
    final maxVal =
        [...incomeData, ...expenseData].fold(0.0, (a, b) => a > b ? a : b);

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Grafik Keuangan',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: AppColors.darker,
                  fontFamily: 'Poppins',
                ),
              ),
              Row(
                children: [
                  _ChartLegend(color: AppColors.primary, label: 'Masuk'),
                  const SizedBox(width: 12),
                  _ChartLegend(color: AppColors.accent, label: 'Keluar'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 160,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(months.length, (i) {
                // Hitung tinggi bar proporsional (maksimal 130)
                final incomeH =
                    maxVal > 0 ? (incomeData[i] / maxVal) * 130 : 20.0;
                final expenseH =
                    maxVal > 0 ? (expenseData[i] / maxVal) * 130 : 20.0;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _Bar(height: incomeH, color: AppColors.primary),
                        const SizedBox(width: 3),
                        _Bar(height: expenseH, color: AppColors.accent),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      months[i],
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.textMuted,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBreakdown() {
    // Aggregate expense by category
    final Map<String, double> catMap = {};
    for (final t in _transactions.where((t) => t.type == 'expense')) {
      catMap[t.category ?? 'Lainnya'] =
          (catMap[t.category ?? 'Lainnya'] ?? 0) + (t.amount ?? 0);
    }

    if (catMap.isEmpty) return const SizedBox.shrink();

    final colors = [
      AppColors.primary,
      AppColors.accent,
      const Color(0xFF4CAF82),
      const Color(0xFFFFD166),
      AppColors.danger,
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Kategori Pengeluaran',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: AppColors.darker,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 16),
          ...catMap.entries.toList().asMap().entries.map((entry) {
            final idx = entry.key;
            final cat = entry.value.key;
            final val = entry.value.value;
            final pct = totalExpense > 0 ? val / totalExpense : 0.0;
            final color = colors[idx % colors.length];

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            cat,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.dark,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${(pct * 100).toStringAsFixed(1)}%',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textMuted,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: pct,
                      backgroundColor: AppColors.offWhite,
                      valueColor: AlwaysStoppedAnimation(color),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions() {
    final recent = _transactions.take(5).toList();

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Transaksi Terbaru',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: AppColors.darker,
                  fontFamily: 'Poppins',
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => _selectedIndex = 1),
                child: const Text(
                  'Lihat semua →',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (recent.isEmpty)
            _buildEmptyState(
              icon: Icons.receipt_long_outlined,
              text: 'Belum ada transaksi.\nTambahkan transaksi pertamamu!',
            )
          else
            ...recent.map((t) => _TransactionTile(transaction: t)),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────
  // TRANSACTIONS TAB
  // ──────────────────────────────────────────────
  Widget _buildTransactionsTab() {
    return Column(
      children: [
        Container(
          color: AppColors.white,
          padding: const EdgeInsets.fromLTRB(24, 56, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Riwayat Transaksi',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.darker,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 12),
              TabBar(
                controller: _tabController,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textMuted,
                indicatorColor: AppColors.primary,
                indicatorWeight: 2,
                labelStyle: const TextStyle(
                    fontFamily: 'Poppins', fontWeight: FontWeight.w600),
                tabs: const [
                  Tab(text: 'Semua'),
                  Tab(text: 'Pemasukan'),
                  Tab(text: 'Pengeluaran'),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildTransactionList(_transactions),
              _buildTransactionList(
                  _transactions.where((t) => t.type == 'income').toList()),
              _buildTransactionList(
                  _transactions.where((t) => t.type == 'expense').toList()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionList(List<TransactionModel> list) {
    if (list.isEmpty) {
      return Center(
        child: _buildEmptyState(
          icon: Icons.receipt_long_outlined,
          text: 'Belum ada transaksi.',
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 80),
      itemCount: list.length,
      itemBuilder: (_, i) => _TransactionTile(transaction: list[i]),
    );
  }

  // ──────────────────────────────────────────────
  // PROFILE TAB
  // ──────────────────────────────────────────────
  Widget _buildProfileTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Profile header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 32),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.dark, AppColors.darker],
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.light],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      widget.username.isNotEmpty
                          ? widget.username[0].toUpperCase()
                          : 'U',
                      style: const TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 32,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  widget.username,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Akun Pribadi',
                  style: TextStyle(
                    color: AppColors.light,
                    fontSize: 13,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _ProfileStat(
                        label: 'Transaksi', value: '${_transactions.length}'),
                    const SizedBox(width: 24),
                    _ProfileStat(
                        label: 'Kategori',
                        value:
                            '${_transactions.map((t) => t.category).toSet().length}'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _ProfileMenuItem(
                  icon: Icons.person_outline,
                  label: 'Edit Profil',
                  onTap: () {},
                ),
                _ProfileMenuItem(
                  icon: Icons.notifications_outlined,
                  label: 'Notifikasi',
                  onTap: () {},
                ),
                _ProfileMenuItem(
                  icon: Icons.lock_outline,
                  label: 'Keamanan',
                  onTap: () {},
                ),
                _ProfileMenuItem(
                  icon: Icons.help_outline,
                  label: 'Bantuan',
                  onTap: () {},
                ),
                const SizedBox(height: 8),
                _ProfileMenuItem(
                  icon: Icons.logout,
                  label: 'Keluar',
                  isDestructive: true,
                  onTap: () {
                    Navigator.of(context).popUntil((r) => r.isFirst);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────
  // BOTTOM NAV
  // ──────────────────────────────────────────────
  Widget _buildBottomNav() {
    return BottomAppBar(
      color: AppColors.white,
      elevation: 8,
      notchMargin: 8,
      shape: const CircularNotchedRectangle(),
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(
              icon: Icons.home_outlined,
              activeIcon: Icons.home,
              label: 'Beranda',
              selected: _selectedIndex == 0,
              onTap: () => setState(() => _selectedIndex = 0),
            ),
            _NavItem(
              icon: Icons.receipt_long_outlined,
              activeIcon: Icons.receipt_long,
              label: 'Transaksi',
              selected: _selectedIndex == 1,
              onTap: () => setState(() => _selectedIndex = 1),
            ),
            const SizedBox(width: 56), // FAB gap
            _NavItem(
              icon: Icons.person_outline,
              activeIcon: Icons.person,
              label: 'Profil',
              selected: _selectedIndex == 2,
              onTap: () => setState(() => _selectedIndex = 2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Icon(icon, size: 48, color: AppColors.textMuted.withOpacity(0.5)),
          const SizedBox(height: 12),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 13,
              fontFamily: 'Poppins',
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double val) {
    final abs = val.abs();
    String formatted;
    if (abs >= 1000000) {
      formatted = 'Rp ${(abs / 1000000).toStringAsFixed(1)}jt';
    } else if (abs >= 1000) {
      formatted = 'Rp ${(abs / 1000).toStringAsFixed(0)}rb';
    } else {
      formatted = 'Rp ${abs.toStringAsFixed(0)}';
    }
    return val < 0 ? '-$formatted' : formatted;
  }
}

// ──────────────────────────────────────────────────────────────────
// Helper widgets
// ──────────────────────────────────────────────────────────────────

class _BalanceStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _BalanceStat(
      {required this.label,
      required this.value,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      color: AppColors.light,
                      fontSize: 11,
                      fontFamily: 'Poppins')),
              Text(value,
                  style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins')),
            ],
          ),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  final double height;
  final Color color;
  const _Bar({required this.height, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 14,
      height: height.clamp(4.0, 130.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class _ChartLegend extends StatelessWidget {
  final Color color;
  final String label;
  const _ChartLegend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label,
            style: const TextStyle(
                fontSize: 11,
                color: AppColors.textMuted,
                fontFamily: 'Poppins')),
      ],
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final TransactionModel transaction;
  const _TransactionTile({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == 'income';
    final color = isIncome ? AppColors.success : AppColors.danger;
    final amount = transaction.amount ?? 0;

    IconData categoryIcon;
    switch (transaction.category) {
      case 'Makanan':
        categoryIcon = Icons.restaurant_outlined;
        break;
      case 'Transport':
        categoryIcon = Icons.directions_car_outlined;
        break;
      case 'Belanja':
        categoryIcon = Icons.shopping_bag_outlined;
        break;
      case 'Hiburan':
        categoryIcon = Icons.movie_outlined;
        break;
      case 'Kesehatan':
        categoryIcon = Icons.local_hospital_outlined;
        break;
      case 'Gaji':
        categoryIcon = Icons.work_outline;
        break;
      default:
        categoryIcon = isIncome ? Icons.arrow_downward : Icons.arrow_upward;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.offWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(categoryIcon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.description ??
                      transaction.category ??
                      'Transaksi',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: AppColors.darker,
                    fontFamily: 'Poppins',
                  ),
                ),
                Text(
                  transaction.category ?? '',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isIncome ? '+' : '-'}Rp ${_fmt(amount)}',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  fontFamily: 'Poppins',
                ),
              ),
              Text(
                transaction.date ?? '',
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 10,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _fmt(double val) {
    if (val >= 1000000) return '${(val / 1000000).toStringAsFixed(1)}jt';
    if (val >= 1000) return '${(val / 1000).toStringAsFixed(0)}rb';
    return val.toStringAsFixed(0);
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              selected ? activeIcon : icon,
              color: selected ? AppColors.primary : AppColors.textMuted,
              size: 24,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: selected ? AppColors.primary : AppColors.textMuted,
                fontSize: 10,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String label;
  final String value;
  const _ProfileStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w800,
                fontSize: 20,
                fontFamily: 'Poppins')),
        Text(label,
            style: const TextStyle(
                color: AppColors.light, fontSize: 12, fontFamily: 'Poppins')),
      ],
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _ProfileMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? AppColors.danger : AppColors.darker;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            if (!isDestructive)
              Icon(Icons.chevron_right, color: AppColors.textMuted, size: 20),
          ],
        ),
      ),
    );
  }
}
