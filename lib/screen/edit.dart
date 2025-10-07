import 'package:flutter/material.dart';
import 'package:lapor_keuangan/db/hive_helper.dart';

class EditTransaksi extends StatefulWidget {
  final int index; // Menyimpan index transaksi yang akan diedit
  final String keterangan; // Menyimpan keterangan transaksi yang akan diedit
  final int jumlah; // Mengubah tipe dari double ke int
  final String
      tipe; // Menyimpan tipe transaksi yang akan diedit (income/expense)

  const EditTransaksi({
    Key? key,
    required this.index,
    required this.keterangan,
    required this.jumlah,
    required this.tipe,
  }) : super(key: key);

  @override
  State<EditTransaksi> createState() => _EditTransaksiState();
}

class _EditTransaksiState extends State<EditTransaksi> {
  final TextEditingController _keteranganController = TextEditingController();
  final TextEditingController _jumlahController = TextEditingController();
  int _value = 1; // Default tipe transaksi: 1 = Pemasukan

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan data yang ada
    _keteranganController.text = widget.keterangan;
    _jumlahController.text = widget.jumlah.toString(); // Ubah menjadi string
    _value = widget.tipe == 'income' ? 1 : 2; // Menyesuaikan tipe transaksi
  }

  void _simpanTransaksi() {
    String keterangan = _keteranganController.text;
    String jumlahInput = _jumlahController.text;
    int? jumlah = int.tryParse(jumlahInput); // Ubah menjadi int

    if (keterangan.isEmpty || jumlah == null || jumlah <= 0) {
      // Validasi input
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Harap isi semua field dengan benar!")),
      );
      return;
    }

    // Tipe transaksi
    String tipe = _value == 1 ? "income" : "expense";

    // Panggil fungsi untuk memperbarui transaksi di Hive
    HiveHelper.updateTransaction(widget.index, keterangan, jumlah, tipe)
        .then((_) {
      // Berhasil menyimpan
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Transaksi berhasil diperbarui!")),
      );

      // Kembali ke halaman sebelumnya
      Navigator.pop(context);
    }).catchError((error) {
      // Gagal menyimpan
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memperbarui transaksi!")),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text("Edit Transaksi"),
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
                leading: Radio(
                  groupValue: _value,
                  value: 1,
                  onChanged: (value) {
                    setState(() {
                      _value = value as int;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text("Pengeluaran"),
                leading: Radio(
                  groupValue: _value,
                  value: 2,
                  onChanged: (value) {
                    setState(() {
                      _value = value as int;
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
