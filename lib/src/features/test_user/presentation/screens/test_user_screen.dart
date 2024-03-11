  /// author : kevin
  ///  date : 2024-3-11 10:54:19
  ///  description : TestUserScreen
  
  import 'package:flutter/material.dart';
  import 'package:flutter_riverpod/flutter_riverpod.dart';
 class  TestUser extends ConsumerWidget {
  const  TestUser({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test User'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
          },
          child: const Text('Fetch Test User'),
        ),
      ),
    );
  }
}
  