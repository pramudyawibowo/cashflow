import 'package:flutter/material.dart';
import 'package:lsp/database_helper.dart';
import 'package:lsp/models/user.dart';
import 'package:lsp/models/transaction.dart';
import 'package:fl_chart/fl_chart.dart';
import 'income.dart';
import 'outcome.dart';
import 'cashFlow.dart';
import 'package:intl/intl.dart';
import 'setting.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.user});

  final User user;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late User user;
  late String totalIncome, totalOutcome;
  List<Transactions> incomeTransactions = [], outcomeTransactions = [];

  NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');

  Future<int> getTotalIncome(int userId) async {
    int totalIncome = await DatabaseHelper.instance.queryTotalIncome(userId);
    return totalIncome;
  }

  Future<int> getTotalOutcome(int userId) async {
    int totalOutcome = await DatabaseHelper.instance.queryTotalOutcome(userId);
    return totalOutcome;
  }

  Future<List<Transactions>> getTransactions(int userId, int status) async {
    if (status == 0) {
      List<Transactions> transactions =
          await DatabaseHelper.instance.queryAllIncomeTransaction(userId);
      return transactions;
    } else if (status == 1) {
      List<Transactions> transactions =
          await DatabaseHelper.instance.queryAllOutcomeTransaction(userId);
      return transactions;
    } else {
      List<Transactions> transactions =
          await DatabaseHelper.instance.queryAllTransaction(userId);
      return transactions;
    }
  }

  Future<void> _getIncomeTransactions() async {
    List<Transactions> data = await getTransactions(user.id, 0);
    setState(() {
      incomeTransactions = data;
    });
  }

  Future<void> _getOutcomeTransactions() async {
    List<Transactions> data = await getTransactions(user.id, 0);
    setState(() {
      outcomeTransactions = data;
    });
  }

  Future<void> _refreshData() async {
    int totalIncomeResult = await getTotalIncome(user.id);
    int totalOutcomeResult = await getTotalOutcome(user.id);

    setState(() {
      totalIncome = currencyFormat.format(totalIncomeResult);
      totalOutcome = currencyFormat.format(totalOutcomeResult);
    });
    _getIncomeTransactions();
  }

  @override
  void initState() {
    totalIncome = '0';
    totalOutcome = '0';
    super.initState();
    user = widget.user;
    _refreshData(); // Refresh saat halaman pertama kali dimuat
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Utama'),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              const Text(
                'Rangkuman Bulan Ini',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                'Pengeluaran: $totalOutcome',
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent),
              ),
              Text(
                'Pemasukan: $totalIncome',
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
              const SizedBox(height: 16),
              Container(
                height: 250,
                child: LineChart(
                  LineChartSample1.mainData(
                      incomeTransactions, outcomeTransactions),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Income(
                                  user: user,
                                )),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(170, 0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/income.png',
                          width: 64,
                          height: 64,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Tambah Pemasukan',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Outcome(
                                  user: user,
                                )),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.redAccent,
                      minimumSize: const Size(170, 0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/outcome.png',
                          width: 64,
                          height: 64,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Tambah Pengeluaran',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      getTransactions(user.id, 5).then((value) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CashFlow(
                                    transactions: value,
                                  )),
                        );
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.green,
                      minimumSize: const Size(170, 0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/survey.png',
                          width: 64,
                          height: 64,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Detail Cash Flow',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Setting(
                                  user: user,
                                )),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.grey,
                      minimumSize: const Size(170, 0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/gear.png',
                          width: 64,
                          height: 64,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Pengaturan',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LineChartSample1 {
  static List<FlSpot> generateSpots(List<Transactions> transactions) {
    List<FlSpot> spots = [];
    for (var i = 0; i < transactions.length; i++) {
      var transaction = transactions[i];
      spots.add(FlSpot(transaction.date.millisecondsSinceEpoch.toDouble(),
          transaction.amount.toDouble()));
    }
    return spots;
  }

  static LineChartBarData getLineChartBarData(
      List<Transactions> incomeTransactions,
      List<Transactions> outcomeTransactions) {
    List<FlSpot> spots = generateSpots(incomeTransactions);
    List<FlSpot> secondLineSpots = generateSpots(outcomeTransactions);
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      color: Colors.blue,
      belowBarData: BarAreaData(show: false),
      isStrokeCapRound: true,
    );
  }

  static LineChartData mainData(List<Transactions> incomeTransactions,
      List<Transactions> outcomeTransactions) {
    return LineChartData(
      lineBarsData: [
        getLineChartBarData(incomeTransactions, outcomeTransactions)
      ],
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d), width: 1),
      ),
      gridData: FlGridData(show: true),
      titlesData: FlTitlesData(
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
              sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              return Text(DateFormat('d-M-y')
                  .format(DateTime.fromMillisecondsSinceEpoch(value.toInt())));
            },
          ))),
    );
  }
}

class LineChartSample {
  static List<FlSpot> generateSpots(List<Transactions> transactions) {
    List<FlSpot> spots = [];
    for (var i = 0; i < transactions.length; i++) {
      var transaction = transactions[i];
      spots.add(FlSpot(transaction.date.millisecondsSinceEpoch.toDouble(),
          transaction.amount.toDouble()));
    }
    return spots;
  }

  static LineChartBarData getLineChartBarData(List<Transactions> transactions) {
    return LineChartBarData(
      spots: generateSpots(transactions),
      isCurved: true,
      color: Colors.blue,
      belowBarData: BarAreaData(show: false),
      isStrokeCapRound: true,
    );
  }

  static LineChartData mainData(List<Transactions> transactions) {
    return LineChartData(
      lineBarsData: [getLineChartBarData(transactions)],
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d), width: 1),
      ),
      gridData: FlGridData(show: true),
      titlesData: FlTitlesData(
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
              sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              return Text(DateFormat('d-M-y')
                  .format(DateTime.fromMillisecondsSinceEpoch(value.toInt())));
            },
          ))),
    );
  }
}
