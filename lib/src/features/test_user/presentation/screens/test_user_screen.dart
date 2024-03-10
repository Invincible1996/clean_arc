  /// author : kevin
  ///  date : 2021/8/19 10:00
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
  