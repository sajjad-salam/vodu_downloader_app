import 'package:flutter/material.dart';

/// Flutter code sample for [LinearProgressIndicator].

class ProgressIndicatorExample extends StatefulWidget {
  const ProgressIndicatorExample({super.key, required this.progress});
  final double progress;

  @override
  State<ProgressIndicatorExample> createState() =>
      _ProgressIndicatorExampleState(progress);
}

class _ProgressIndicatorExampleState extends State<ProgressIndicatorExample>
    with TickerProviderStateMixin {
  final double _progress;
  late AnimationController controller;

  _ProgressIndicatorExampleState(
    this._progress,
  );

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      value: _progress,
      duration: const Duration(seconds: 5),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat(
      reverse: true,
    );
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: controller.value,
      semanticsLabel: 'Linear progress indicator',
    );
  }
}
