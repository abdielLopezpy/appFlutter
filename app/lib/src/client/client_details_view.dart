import 'package:flutter/material.dart';

import 'client.dart';

class ClientDetailsView extends StatelessWidget {
  static const routeName = '/client';

  final Client client;

  const ClientDetailsView({Key? key, required this.client}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Client Details'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Name: ${client.name}',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            'Email: ${client.emailAddress}',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            'Phone: ${client.phoneNumber}',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            'Address: ${client.address}',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Handle update information here
            },
            child: const Text('Update Information'),
          ),
        ],
      ),
    );
  }
}
