import 'dart:math';

import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem({
    Key key,
    @required this.transaction,
    @required this.deletetx,
  }) : super(key: key);

  final Transaction transaction;
  final Function deletetx;

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  Color _bgColor;
  @override
  void initState() {
    const avilableColors = [
      Colors.green,
      Colors.amber,
      Colors.blueGrey,
      Colors.deepPurple,
      Colors.red,
    ];
    _bgColor = avilableColors[Random().nextInt(4)];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 4,
      color: const Color.fromRGBO(54, 51, 51, 1),
      margin: const EdgeInsets.only(bottom: 6, left: 20, right: 20),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _bgColor,
          radius: 30,
          child: FittedBox(
            child: Text('\$${widget.transaction.amount}',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
        title: Text(
          widget.transaction.title,
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(
          DateFormat.yMd().format(
            (widget.transaction.date),
          ),
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        trailing: MediaQuery.of(context).size.width > 460
            ? FlatButton.icon(
                onPressed: () => widget.deletetx(widget.transaction.id),
                icon: const Icon(Icons.delete),
                label: const Text('Delete'),
              )
            : IconButton(
                icon: const Icon(Icons.delete),
                color: Colors.white,
                onPressed: () => widget.deletetx(widget.transaction.id)),
      ),
    );
  }
}
