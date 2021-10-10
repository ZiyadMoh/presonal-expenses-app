import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AdaptiveButten extends StatelessWidget {
  final String txt;
  final Function fun;
  AdaptiveButten(this.txt, this.fun);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(child: Text(txt), onPressed: fun)
        : FlatButton(
            onPressed: fun,
            child:  Text(
              txt,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            textColor: Colors.orange[900],
          );
  }
}
