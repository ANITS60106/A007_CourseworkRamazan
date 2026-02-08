import 'package:flutter/material.dart';
import 'offers_screen.dart';

class ApplicationScreen extends StatelessWidget {
  const ApplicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Заявка на кредит')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Сумма кредита'),
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Срок (мес)'),
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Цель кредита'),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const OffersScreen(),
                  ),
                );
              },
              child: const Text('Подать заявку'),
            ),
          ],
        ),
      ),
    );
  }
}