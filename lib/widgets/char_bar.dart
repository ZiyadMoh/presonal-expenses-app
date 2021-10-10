import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double spendingAmount;
  final double spendingPctgOfTota;

  ChartBar(this.label, this.spendingAmount, this.spendingPctgOfTota);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              Container(
                height: constraints.maxHeight * 0.15,
                child: FittedBox(
                  child: Text(
                    '\$${spendingAmount.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.bodyText1,
                    // dont want the decimals
                  ),
                ),
              ),
              SizedBox(
                height: constraints.maxHeight * 0.05,
              ),
              Container(
                height: constraints.maxHeight * 0.6,
                width: 10,
                child: Stack(
                  alignment: AlignmentDirectional.bottomStart,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromRGBO(54, 51, 51, 0.5),
                        ),
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromRGBO(54, 51, 51, 1),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(1.5),
                      child: FractionallySizedBox(
                        heightFactor: spendingPctgOfTota,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.deepOrange,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: constraints.maxHeight * 0.05,
              ),
              Container(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.headline6,
                ),
                height: constraints.maxHeight * 0.15,
              ),
            ],
          );
        },
      ),
    );
  }
}
