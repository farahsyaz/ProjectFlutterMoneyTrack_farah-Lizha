import 'package:flutter/material.dart';
import 'package:lapor_keuangan/screen/add_transaction.dart';
import 'package:lapor_keuangan/screen/login.dart';
import 'package:lapor_keuangan/db/hive_helper.dart';
import 'package:lapor_keuangan/model/transaction_model.dart';

class Myhome extends StatefulWidget {
  const Myhome({super.key});

  @override
  State<Myhome> createState() => _MyhomeState();
}

class _MyhomeState extends State<Myhome> {
  List<TransactionModel> transactions = [];
  double totalSaldo = 0.0;
  double totalPengeluaran = 0.0;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  void _loadTransactions() {
    setState(() {
      transactions = HiveHelper.getTransactions(); // Ambil data dari Hive
      _calculateTotals();
    });
  }

  void _calculateTotals() {
    double saldo = 0.0;
    double pengeluaran = 0.0;

   for (var transaction in transactions) {
    // Menggunakan dot notation (transaction.type) bukan index map (transaction['type'])
    if (transaction.type == 'income') {
      saldo += (transaction.amount ?? 0.0);
    } else if (transaction.type == 'expense') {
      pengeluaran += (transaction.amount ?? 0.0);
    }
  }

  setState(() {
    totalSaldo = saldo - pengeluaran;
    totalPengeluaran = pengeluaran;
  });
  }

  void _deleteTransaction(int index) {
    HiveHelper.deleteTransaction(index).then((_) {
      _loadTransactions(); // Perbarui data setelah dihapus
    });
  }

  void showAlertDialog(BuildContext context, int index) {
    Widget okButton = TextButton(
      child: const Text("Yakin"),
      onPressed: () {
        Navigator.of(context).pop(); // Tutup dialog
        _deleteTransaction(index); // Hapus transaksi
      },
    );

    Widget cancelButton = TextButton(
      child: const Text("Batal"),
      onPressed: () {
        Navigator.of(context).pop(); // Tutup dialog
      },
    );

    AlertDialog alertDialog = AlertDialog(
      title: const Text("Peringatan!"),
      content: const Text("Anda yakin akan menghapus transaksi ini?"),
      actions: [
        cancelButton,
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text("Guardado Plus"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout), // Ikon logout
            onPressed: () {
              // Fungsi logout, misalnya menghapus sesi pengguna atau memindahkan ke halaman login
              // Misalnya, jika menggunakan Hive untuk menyimpan status login, Anda bisa menghapus data login.
              // Setelah itu, arahkan pengguna kembali ke halaman login.

              // Contoh: Menghapus data pengguna yang sedang login
              // HiveHelper.clearUserData();

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        LoginPage()), // Ganti dengan halaman login
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildSummaryCard(
              color: Colors.blue,
              title: "Saldo Anda",
              value: "Rp.${totalSaldo.toStringAsFixed(0)}",
            ),
            _buildSummaryCard(
              color: Colors.redAccent,
              title: "Total Pengeluaran",
              value: "Rp.${totalPengeluaran.toStringAsFixed(0)}",
            ),
            const SizedBox(height: 20),
            Expanded(
              child: transactions.isEmpty
                  ? const Center(
                      child: Text(
                        "Tidak ada transaksi",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        final transaction = transactions[index];
                        return _buildTransactionTile(transaction, index);
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigasi ke halaman Tambahsaldo dan tunggu hasilnya
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTransactionPage()),
          );

          // Jika ada perubahan data (result == true), muat ulang transaksi
          if (result == true) {
            _loadTransactions();
          }
        },
        tooltip: 'Lakukan Transaksi',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummaryCard({
    required Color color,
    required String title,
    required String value,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "$title : $value",
            style: const TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionTile(TransactionModel transaction, int index) {
  return ListTile(
    // Menggunakan properti object (description, amount, type)
    title: Text(transaction.description ?? 'Tanpa Keterangan'),
    subtitle: Text("Rp ${transaction.amount?.toStringAsFixed(0)}"),
    leading: Icon(
      transaction.type == 'income' ? Icons.download : Icons.upload,
      color: transaction.type == 'income' ? Colors.green : Colors.red,
    ),
    trailing: Wrap(
      children: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditTransaksi(
                  index: index,
                  keterangan: transaction.description ?? '',
                  jumlah: transaction.amount ?? 0.0,
                  tipe: transaction.type ?? 'expense',
                ),
              ),
            ).then((_) {
              _loadTransactions();
            });
          },
          icon: const Icon(Icons.edit, color: Colors.grey),
        ),
        IconButton(
          onPressed: () {
            showAlertDialog(context, index);
          },
          icon: const Icon(Icons.delete, color: Colors.red),
        ),
      ],
    ),
  );
  }
}
