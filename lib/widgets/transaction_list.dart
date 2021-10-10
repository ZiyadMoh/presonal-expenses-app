import 'package:flutter/material.dart';

import '../models/transaction.dart';
import 'transaction_itme.dart';

class TransactionList extends StatelessWidget {
  final Function deletetx;
  final List<Transaction> transactions;

  TransactionList(this.transactions, this.deletetx);

  showAlertDialog(BuildContext context, String id) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.pop(context, false);
      },
    );
    Widget continueButton = FlatButton(
      child: const Text("Continue"),
      onPressed: () {
        deletetx(id);
        Navigator.pop(context, true);
      },
    ); // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Delete Transaction"),
      content: const Text("Are You Sure You Want To Delete The Transaction?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    ); // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 550,
      child: transactions.isEmpty
          ? LayoutBuilder(
              builder: (context, constrains) {
                return Column(
                  children: [
                    Text(
                      'No Transactions added yet',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    const SizedBox(
                      height: 70,
                    ),
                    Container(
                      height: constrains.maxHeight * .59,
                      child: Image.asset(
                        'assets/images/alms.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                );
              },
            )
          : Container(
              padding: const EdgeInsets.only(top: 20),
              color: const Color.fromRGBO(156, 150, 150, 1),
              child: ListView(
                children: transactions
                    .map(
                      (tx) => TransactionItem(
                        transaction: tx,
                        deletetx: deletetx,
                        key: ValueKey(tx.id),
                      ),
                    )
                    .toList(),
              ),
            ),
    );
  }
}
