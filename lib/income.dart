import 'package:flutter/material.dart';
import 'package:lsp/database_helper.dart';
import 'package:lsp/models/transaction.dart';
import 'package:lsp/models/user.dart';

class Income extends StatefulWidget {
  const Income({super.key, required this.user});

  final User user;

  @override
  State<Income> createState() => _IncomeState();
}

class _IncomeState extends State<Income> {
  late User user;
  late DateTime selectedDate;
  TextEditingController dateController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    dateController.text = "${selectedDate.toLocal()}".split(' ')[0];
    user = widget.user;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        dateController.text = "${selectedDate.toLocal()}".split(' ')[0];
      });
  }

  void _resetFields() {
    dateController.text = "2021-01-01";
    amountController.clear();
    descriptionController.clear();
  }

  void _saveTransaction(user_id, amount, description, status, date) {
    // Implementasi simpan transaksi di sini
    // Anda dapat menggunakan nilai dari dateController.text, amountController.text, dan descriptionController.text
    // Misalnya, Anda bisa menyimpannya di database atau melakukan operasi lain sesuai kebutuhan
    Transactions transaction = Transactions(
        user_id: user_id,
        amount: amount,
        description: description,
        status: 0,
        date: date);
    DatabaseHelper.instance.insertTransaction(transaction);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pemasukan tersimpan!')),
    );
    _resetFields();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Pemasukan'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              readOnly: true,
              controller: dateController,
              onTap: () => _selectDate(context),
              decoration: InputDecoration(
                labelText: 'Tanggal',
                suffixIcon: Icon(Icons.calendar_today),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Nominal',
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Keterangan',
              ),
            ),
            SizedBox(height: 32),
            Column(
              children: [
                ElevatedButton(
                  onPressed: _resetFields,
                  child: Text('Reset'),
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      backgroundColor: Colors.orangeAccent),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => _saveTransaction(
                    user.id,
                    int.parse(amountController.text),
                    descriptionController.text,
                    0,
                    selectedDate,
                  ),
                  child: Text('Simpan'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: Colors.green,
                  ),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Kembali'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
