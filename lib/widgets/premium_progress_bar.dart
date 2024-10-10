import 'package:flutter/material.dart';
import 'dart:async';

class PremiumProgressBar extends StatefulWidget {
  final DateTime expiryDate;

  PremiumProgressBar({required this.expiryDate});

  @override
  _PremiumProgressBarState createState() => _PremiumProgressBarState();
}

class _PremiumProgressBarState extends State<PremiumProgressBar> {
  late Duration _remainingTime;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _updateRemainingTime();
    _startTimer();
  }

  void _updateRemainingTime() {
    setState(() {
      _remainingTime = widget.expiryDate.difference(DateTime.now());
      if (_remainingTime.isNegative) {
        _remainingTime = Duration.zero;
      }
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      _updateRemainingTime();
      if (_remainingTime == Duration.zero) {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    return '$hours ч $minutes мин';
  }

  @override
  Widget build(BuildContext context) {
    final progress = _remainingTime.inSeconds / Duration(hours: 24).inSeconds;
    return Column(
      children: [
        LinearProgressIndicator(value: progress),
        SizedBox(height: 4),
        Text('Премиум истечет через ${_formatDuration(_remainingTime)}'),
      ],
    );
  }
}
