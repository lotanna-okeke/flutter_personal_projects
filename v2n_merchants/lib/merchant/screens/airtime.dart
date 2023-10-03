import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AirtimeScreen extends ConsumerStatefulWidget {
  const AirtimeScreen({
    super.key,
  });

  @override
  ConsumerState<AirtimeScreen> createState() => _AirtimeScreenState();
}

class _AirtimeScreenState extends ConsumerState<AirtimeScreen> {
  @override
  Widget build(BuildContext context) {
    return Text('WOW');
  }
}
