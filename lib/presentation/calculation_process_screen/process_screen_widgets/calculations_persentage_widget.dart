import 'package:flutter/material.dart';

class CalculationsPercentageWidget extends StatefulWidget {
  final double percentage;
  const CalculationsPercentageWidget({super.key, required this.percentage});

  @override
  State<CalculationsPercentageWidget> createState() =>
      _CalculationsPercentageWidgetState();
}

class _CalculationsPercentageWidgetState
    extends State<CalculationsPercentageWidget> {
  @override
  Widget build(BuildContext context) {
    final calculationText = (widget.percentage >= 100)
        ? 'All calculations has finished, you can send your result to server'
        : 'Calculations in progress...';
    double percentage;
    if (widget.percentage.isNaN || widget.percentage.isInfinite) {
      percentage = 0.0;
    } else {
      percentage = widget.percentage;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 50,
          child: Text(
            calculationText,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          '${percentage.toInt()}%',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 10),
        SizedBox(
            height: 100,
            width: 100,
            child: CircularProgressIndicator(value: percentage / 100)),
      ],
    );
  }
}
