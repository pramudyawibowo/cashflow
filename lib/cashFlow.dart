import 'package:flutter/material.dart';
import 'package:lsp/models/transaction.dart';
import 'package:intl/intl.dart';

class CashFlow extends StatelessWidget {
  final List<Transactions> transactions;
  CashFlow({Key? key, required this.transactions}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Cash Flow'),
      ),
      body: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (BuildContext context, int index) {
          Transactions? transaction = transactions[index];
          NumberFormat currencyFormat =
              NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');
          String formattedAmount = currencyFormat.format(transaction.amount);

          String formattedDate =
              DateFormat('d-M-y H:m').format(transaction.date);

          String plusMinus = transaction.status == 0 ? '+' : '-';

          return Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey, // Warna garis
                  width: 0.5, // Lebar garis
                ),
              ),
            ),
            padding: const EdgeInsets.symmetric(
                vertical: 8.0, horizontal: 16.0), // Tambahkan padding di sini
            child: ListTile(
              title: Text('[ $plusMinus ] $formattedAmount',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Keterangan: ${transaction.description}',
                      style: const TextStyle(color: Colors.black87)),
                  Text('Tanggal: $formattedDate'),
                ],
              ),
              trailing: transaction.status == 0
                  ? const Icon(Icons.arrow_circle_left,
                      color: Colors.green,
                      size: 32) // Ubah ukuran panah di sini
                  : const Icon(Icons.arrow_circle_right,
                      color: Colors.red, size: 32), // Ubah ukuran panah di sini
            ),
          );
        },
      ),
    );
  }
}
