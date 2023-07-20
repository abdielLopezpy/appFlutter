import 'package:flutter/material.dart';
import 'package:realm/realm.dart';

import '../settings/settings_view.dart';
import 'client.dart';

const Color collection1Color = Color(0xFF8C1F28);
const Color collection2Color = Color(0xFF591C21);
const Color collection3Color = Color(0xFF044040);
const Color collection4Color = Color(0xFFD92525);
const Color collection5Color = Color(0xFFF2F2F2);

class ClientListBloc {
  final RealmResults<Client> clients;
  final Realm _realm;

  ClientListBloc(this.clients) : _realm = clients.realm;

  void addNewClient(
    String name,
    String emailAddress,
    String phoneNumber,
    String address,
    DateTime birthDate,
    String gender,
    String notes,
  ) {
    _realm.write(() {
      _realm.add(Client(
        ObjectId(),
        name,
        emailAddress,
        phoneNumber,
        address,
        birthDate,
        gender,
        notes,
        DateTime.now(),
        DateTime.now(),
      ));
    });
  }

  void updateClient(Client client) {
    _realm.write(() {
      final updatedClient = _realm.find<Client>(client.id);
      if (updatedClient != null) {
        updatedClient.name = client.name;
        updatedClient.emailAddress = client.emailAddress;
        updatedClient.phoneNumber = client.phoneNumber;
        updatedClient.address = client.address;
      }
    });
  }

  void deleteClient(Client client) {
    _realm.write(() {
      _realm.delete(client);
    });
  }
}

class ClientListView extends StatefulWidget {
  const ClientListView({Key? key, required this.bloc}) : super(key: key);

  static const routeName = '/clientListView';

  final ClientListBloc bloc;

  @override
  _ClientListViewState createState() => _ClientListViewState();
}

class _ClientListViewState extends State<ClientListView> {
  String? selectedGender;

  Stream<RealmResults<Client>> get clientsStream => widget.bloc.clients.changes
      .map((changes) => changes.results)
      .asBroadcastStream();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Clients',
          style: TextStyle(
            color: collection1Color,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, SettingsView.routeName);
            },
            color: collection1Color,
          ),
        ],
        backgroundColor: collection5Color,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.3),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddClientDialog(context);
        },
        tooltip: 'Add new client',
        backgroundColor: collection1Color,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<RealmResults<Client>>(
        stream: clientsStream,
        initialData: widget.bloc.clients,
        builder: (context, snapshot) {
          final clients = snapshot.data;
          if (!snapshot.hasData || clients == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            restorationId: 'clientListView',
            itemCount: clients.length,
            itemBuilder: (BuildContext context, int index) {
              final client = clients[index];
              return ClientTile(client: client, bloc: widget.bloc);
            },
          );
        },
      ),
    );
  }

  void _showAddClientDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String name = '';
        String emailAddress = '';
        String phoneNumber = '';
        String address = '';
        DateTime? birthDate;
        String notes = '';

        return AlertDialog(
          title: const Text('Add New Client'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Name'),
                  onChanged: (value) {
                    name = value;
                  },
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Email Address'),
                  onChanged: (value) {
                    emailAddress = value;
                  },
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                  onChanged: (value) {
                    phoneNumber = value;
                  },
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Address'),
                  onChanged: (value) {
                    address = value;
                  },
                ),
                InkWell(
                  onTap: () {
                    _selectDate(context, (selectedDate) {
                      birthDate = selectedDate;
                    });
                  },
                  child: InputDecorator(
                    decoration:
                        const InputDecoration(labelText: 'Date of Birth'),
                    child: Text(
                      birthDate != null ? birthDate.toString() : 'Select date',
                    ),
                  ),
                ),
                DropdownButtonFormField<String>(
                  value: selectedGender,
                  items: [
                    'Select Gender',
                    'Male',
                    'Female',
                    'Other',
                  ].map((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Gender'),
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Notes'),
                  onChanged: (value) {
                    notes = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                widget.bloc.addNewClient(
                  name,
                  emailAddress,
                  phoneNumber,
                  address,
                  birthDate!,
                  selectedGender ?? '',
                  notes,
                );

                Navigator.of(context).pop();

                // Display a notification
                const snackBar =
                    SnackBar(content: Text('Client added successfully.'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);

                // Navigate to the screen that shows all clients and replace the current screen
                Navigator.pushReplacementNamed(
                    context, ClientListView.routeName);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _selectDate(
      BuildContext context, void Function(DateTime?) onDateSelected) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    onDateSelected(selected);
  }
}

class ClientTile extends StatelessWidget {
  const ClientTile({
    Key? key,
    required this.client,
    required this.bloc,
  }) : super(key: key);

  final Client client;
  final ClientListBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(client.id),
      background: Container(color: collection4Color),
      onDismissed: (direction) => bloc.deleteClient(client),
      child: ListTile(
        title: Text(
          client.name,
          style: const TextStyle(
            color: collection1Color,
            fontSize: 18,
          ),
        ),
        leading: const CircleAvatar(
          foregroundImage: AssetImage('assets/images/flutter_logo.png'),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ClientDetailsView(client: client, bloc: bloc),
            ),
          );
        },
      ),
    );
  }
}

class ClientDetailsView extends StatelessWidget {
  static const routeName = '/client';

  final Client client;
  final ClientListBloc bloc;

  const ClientDetailsView({Key? key, required this.client, required this.bloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Client Details',
          style: TextStyle(
            color: collection1Color,
          ),
        ),
        backgroundColor: collection5Color,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.3),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${client.name}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: collection1Color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Email: ${client.emailAddress}',
              style: const TextStyle(
                fontSize: 18,
                color: collection1Color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Phone: ${client.phoneNumber}',
              style: const TextStyle(
                fontSize: 18,
                color: collection1Color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Address: ${client.address}',
              style: const TextStyle(
                fontSize: 18,
                color: collection1Color,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _showUpdateClientDialog(context);
              },
              style: ElevatedButton.styleFrom(
                primary: collection1Color,
              ),
              child: const Text(
                'Update Information',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showUpdateClientDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String name = client.name;
        String emailAddress = client.emailAddress;
        String phoneNumber = client.phoneNumber;
        String address = client.address;

        return AlertDialog(
          title: const Text('Update Client'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Name'),
                  onChanged: (value) {
                    name = value;
                  },
                  controller: TextEditingController(text: name),
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Email Address'),
                  onChanged: (value) {
                    emailAddress = value;
                  },
                  controller: TextEditingController(text: emailAddress),
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                  onChanged: (value) {
                    phoneNumber = value;
                  },
                  controller: TextEditingController(text: phoneNumber),
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Address'),
                  onChanged: (value) {
                    address = value;
                  },
                  controller: TextEditingController(text: address),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final updatedClient = Client(
                  client.id,
                  name,
                  emailAddress,
                  phoneNumber,
                  address,
                  client.birthDate,
                  client.gender,
                  client.notes,
                  client.registrationDate,
                  DateTime.now(),
                );
                bloc.updateClient(updatedClient);
                Navigator.of(context).pop(updatedClient);
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    ).then((updatedClient) {
      if (updatedClient != null) {
        // Display a notification
        const snackBar =
            SnackBar(content: Text('Client updated successfully.'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        // Navigate to the screen that shows all clients
        Navigator.pushNamed(context, ClientListView.routeName);

        // Handle updated client
        print('Updated client: $updatedClient');
      }
    });
  }
}
