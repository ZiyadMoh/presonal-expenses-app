// ignore_for_file: prefer_const_constructors
import 'dart:io'; // to find out which platphorme the program in?
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './widgets/chart.dart';

import 'widgets/new_transaction.dart';
import 'widgets/transaction_list.dart';
import 'models/transaction.dart';

void main() {
  // WidgetsFlutterBinding();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        backgroundColor: Color.fromRGBO(246, 233, 233, 1),
        primarySwatch: Colors.deepOrange,
        accentColor: Colors.orange[900],
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                  color: Colors.white,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
              bodyText1: TextStyle(
                  color: Colors.white,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
              button: TextStyle(color: Colors.white),
            ),
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // String titleInput;
  // String amountInput;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    // Transaction(
    //   id: 't001',
    //   title: 'Coffee',
    //   amount: 5.00,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't002',
    //   title: 'Book',
    //   amount: 16.53,
    //   date: DateTime.now(),
    // ),
  ];
  bool _showChart = false;
  void _addNewTransaction(
      String txTitle, double txAmount, DateTime dateSelected) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: dateSelected,
      id: DateTime.now().toString(),
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

// decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey, width: 1),
//                     borderRadius: BorderRadius.circular(10),
  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (_) {
        return NewTransaction(_addNewTransaction);
        // return GestureDetector(
        //   onTap: () {},
        //   child: NewTransaction(_addNewTransaction),
        //   behavior: HitTestBehavior.opaque,
        // );
      },
    );
  }

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(Duration(days: 7)),
      );
    }).toList();
  }

  List<Widget> _buildLandScapeContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget txList) {
    return [
      Container(
        color: Color.fromRGBO(54, 51, 51, 1),
        margin: EdgeInsets.only(top: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Show Chart',
              style: Theme.of(context).textTheme.headline6,
            ),
            Switch.adaptive(
                // Switch.adaptive to give an IOS look
                value: _showChart,
                onChanged: (val) {
                  setState(() {
                    _showChart = val;
                  });
                })
          ],
        ),
      ),
      _showChart
          ? Container(
              color: Color.fromRGBO(54, 51, 51, 1),
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.7,
              child: Chart(_recentTransactions),
            )
          : txList
    ];
  }

  List<Widget> _buildPortraitContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget txList) {
    return [
      Container(
        color: Color.fromRGBO(54, 51, 51, 1),
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.3,
        child: Chart(_recentTransactions),
      ),
      txList
    ];
  }

  Widget _buildAppBar() {
    return Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Personal Expenses'),
            trailing: Row(
              mainAxisSize: MainAxisSize
                  .min, // to limit the childern to be as big as they need to be and not to push eachother
              children: [
                GestureDetector(
                  onTap: () => _startAddNewTransaction(context),
                  child: Icon(CupertinoIcons.add),
                ),
              ],
            ),
          )
        : AppBar(
            // u should use preferedSizeWidget
            title: Text('Personal Expenses'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _startAddNewTransaction(context),
              ),
            ],
          );
  }

  Widget _buildScaffold() {}

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final PreferredSizeWidget appBar = _buildAppBar();
    final txList = Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize
                  .height - // dart is not able to find out that CupertinoNavigationBar and AppBar both have a preferred size property
              mediaQuery.padding.top) *
          0.7,
      child: TransactionList(_userTransactions, _deleteTransaction),
    );
    final scaffoldbody = SafeArea(
      //Make sure everything is positioned whithin the poundries
      child: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandscape)
              ..._buildLandScapeContent(mediaQuery, appBar, txList),
            if (!isLandscape)
              ..._buildPortraitContent(
                  mediaQuery, appBar, txList), //...List spred operator
          ],
        ),
      ),
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(child: scaffoldbody)
        : Scaffold(
            appBar: appBar,
            body: scaffoldbody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container() // not render anything
                : FloatingActionButton(
                    foregroundColor: Colors.white,
                    child: Icon(Icons.add),
                    onPressed: () => _startAddNewTransaction(context),
                  ),
          );
  }
}
