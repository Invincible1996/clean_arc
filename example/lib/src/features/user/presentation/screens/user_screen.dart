/// author : kevin
///  date : 2024-6-9 11:19:44
///  description : UserScreen
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserScreen extends ConsumerWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test User'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {},
          child: const Text('Fetch Test User'),
        ),
      ),
    );
  }
}
