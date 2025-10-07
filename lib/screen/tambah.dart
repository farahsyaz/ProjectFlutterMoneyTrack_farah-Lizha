import 'package:flutter/material.dart';
import 'package:lapor_keuangan/db/hive_helper.dart';

class Tambahsaldo extends StatefulWidget {
  const Tambahsaldo({Key? key}) : super(key: key);

  @override
  State<Tambahsaldo> createState() => _TambahsaldoState();
}

class _TambahsaldoState extends State<Tambahsaldo> {
  final TextEditingController _keteranganController = TextEditingController();
  final TextEditingController _jumlahController = TextEditingController();
  int _value = 1; // Default tipe transaksi: 1 = Pemasukan

  void _simpanTransaksi() {
    String keterangan = _keteranganController.text;
    String jumlahInput = _jumlahController.text;

    // Mengonversi jumlah menjadi double
    double? jumlah = double.tryParse(jumlahInput);

    if (keterangan.isEmpty || jumlah == null || jumlah <= 0) {
      // Validasi input
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Harap isi semua field dengan benar!")),
      );
      return;
    }

    // Mengonversi jumlah ke int
    int jumlahInt = jumlah.toInt();

    // Tipe transaksi
    String tipe = _value == 1 ? "income" : "expense";

    // Panggil fungsi addTransaction dengan jumlah dalam bentuk int
    HiveHelper.addTransaction(keterangan, jumlahInt, tipe).then((_) {
      // Berhasil menyimpan
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Transaksi berhasil disimpan!")),
      );

      // Kembali ke halaman sebelumnya dan beri tahu bahwa transaksi berhasil disimpan
      Navigator.pop(context,
          true); // Kembali ke halaman sebelumnya dan beri tahu berhasil
    }).catchError((error) {
      // Gagal menyimpan
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menyimpan transaksi!")),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text("Transaksi"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Keterangan"),
              TextField(
                controller: _keteranganController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Masukkan keterangan transaksi",
                ),
              ),
              const SizedBox(height: 20),
              const Text("Tipe Transaksi"),
              ListTile(
                title: const Text("Pemasukan"),
                leading: Radio<int>(
                  groupValue: _value,
                  value: 1,
                  onChanged: (int? value) {
                    setState(() {
                      _value = value!;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text("Pengeluaran"),
                leading: Radio<int>(
                  groupValue: _value,
                  value: 2,
                  onChanged: (int? value) {
                    setState(() {
                      _value = value!;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              const Text("Jumlah"),
              TextField(
                controller: _jumlahController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Masukkan jumlah transaksi",
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _simpanTransaksi,
                child: const Text("Simpan"),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Membersihkan controller
    _keteranganController.dispose();
    _jumlahController.dispose();
    super.dispose();
  }
}
