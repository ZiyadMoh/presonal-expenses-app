import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './char_bar.dart';
import '../models/transaction.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

// getters are porperties that are calculated dynamicly..

  List<Map<String, Object>> get groupedTransactionsValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      double totalSum = 0;
      for (int i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }

      // ignore: avoid_print
      // print(DateFormat.E().format(weekDay));
      // print(totalSum);

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 2),
        'amount': totalSum
      };
    }).reversed.toList(); //to make Today is all the way to right
  }

  double get totalSpending {
    return groupedTransactionsValues.fold(0.0, (sum, element) {
      return sum + element['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromRGBO(156, 150, 150, 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 6,
      margin: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: groupedTransactionsValues.map((tx) {
          return Flexible(
            fit: FlexFit.tight,
            child: ChartBar(
                tx['day'],
                tx['amount'],
                totalSpending == 0.0
                    ? 0.0
                    : (tx['amount'] as double) / totalSpending),
          );
        }).toList(),
      ),
    );
  }
}
