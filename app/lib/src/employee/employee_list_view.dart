import 'package:flutter/material.dart';
import 'package:realm/realm.dart';

import '../settings/settings_view.dart';
import 'employee.dart';

const Color collection1Color = Color(0xFF8C1F28);
const Color collection2Color = Color(0xFF591C21);
const Color collection3Color = Color(0xFF044040);
const Color collection4Color = Color(0xFFD92525);
const Color collection5Color = Color(0xFFF2F2F2);

class EmployeeListBloc {
  final RealmResults<Employee> employees;
  final Realm _realm;

  EmployeeListBloc(this.employees) : _realm = employees.realm;

  void addNewEmployee(
    String name,
    String emailAddress,
    String phoneNumber,
    String address,
    DateTime birthDate,
    String gender,
    String position,
  ) {
    _realm.write(() {
      _realm.add(Employee(
        ObjectId(),
        name,
        emailAddress,
        phoneNumber,
        address,
        birthDate,
        gender,
        position,
        DateTime.now(),
        DateTime.now(),
      ));
    });
  }

  void updateEmployee(Employee employee) {
    _realm.write(() {
      final updatedEmployee = _realm.find<Employee>(employee.id);
      if (updatedEmployee != null) {
        updatedEmployee.name = employee.name;
        updatedEmployee.emailAddress = employee.emailAddress;
        updatedEmployee.phoneNumber = employee.phoneNumber;
        updatedEmployee.address = employee.address;
        updatedEmployee.position = employee.position;
      }
    });
  }

  void deleteEmployee(Employee employee) {
    _realm.write(() {
      _realm.delete(employee);
    });
  }
}

class EmployeeListView extends StatefulWidget {
  const EmployeeListView({Key? key, required this.bloc}) : super(key: key);

  static const routeName = '/employeeListView';

  final EmployeeListBloc bloc;

  @override
  _EmployeeListViewState createState() => _EmployeeListViewState();
}

class _EmployeeListViewState extends State<EmployeeListView> {
  String? selectedGender;

  Stream<RealmResults<Employee>> get employeesStream =>
      widget.bloc.employees.changes
          .map((changes) => changes.results)
          .asBroadcastStream();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Employees',
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
          _showAddEmployeeDialog(context);
        },
        tooltip: 'Add new employee',
        backgroundColor: collection1Color,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<RealmResults<Employee>>(
        stream: employeesStream,
        initialData: widget.bloc.employees,
        builder: (context, snapshot) {
          final employees = snapshot.data;
          if (!snapshot.hasData || employees == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            restorationId: 'employeeListView',
            itemCount: employees.length,
            itemBuilder: (BuildContext context, int index) {
              final employee = employees[index];
              return EmployeeTile(employee: employee, bloc: widget.bloc);
            },
          );
        },
      ),
    );
  }

  void _showAddEmployeeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String name = '';
        String emailAddress = '';
        String phoneNumber = '';
        String address = '';
        DateTime? birthDate;
        String position = '';

        return AlertDialog(
          title: const Text('Add New Employee'),
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
                  decoration: const InputDecoration(labelText: 'Position'),
                  onChanged: (value) {
                    position = value;
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
                widget.bloc.addNewEmployee(
                  name,
                  emailAddress,
                  phoneNumber,
                  address,
                  birthDate!,
                  selectedGender ?? '',
                  position,
                );

                Navigator.of(context).pop();

                // Display a notification
                const snackBar =
                    SnackBar(content: Text('Employee added successfully.'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);

                // Navigate to the screen that shows all employees and replace the current screen
                Navigator.pushReplacementNamed(
                    context, EmployeeListView.routeName);
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

class EmployeeTile extends StatelessWidget {
  const EmployeeTile({
    Key? key,
    required this.employee,
    required this.bloc,
  }) : super(key: key);

  final Employee employee;
  final EmployeeListBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(employee.id),
      background: Container(color: collection4Color),
      onDismissed: (direction) => bloc.deleteEmployee(employee),
      child: ListTile(
        title: Text(
          employee.name,
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
                  EmployeeDetailsView(employee: employee, bloc: bloc),
            ),
          );
        },
      ),
    );
  }
}

class EmployeeDetailsView extends StatelessWidget {
  static const routeName = '/employee';

  final Employee employee;
  final EmployeeListBloc bloc;

  const EmployeeDetailsView({
    Key? key,
    required this.employee,
    required this.bloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Employee Details',
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
              'Name: ${employee.name}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: collection1Color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Email: ${employee.emailAddress}',
              style: const TextStyle(
                fontSize: 18,
                color: collection1Color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Phone: ${employee.phoneNumber}',
              style: const TextStyle(
                fontSize: 18,
                color: collection1Color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Address: ${employee.address}',
              style: const TextStyle(
                fontSize: 18,
                color: collection1Color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Position: ${employee.position}',
              style: const TextStyle(
                fontSize: 18,
                color: collection1Color,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _showUpdateEmployeeDialog(context);
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

  void _showUpdateEmployeeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String name = employee.name;
        String emailAddress = employee.emailAddress;
        String phoneNumber = employee.phoneNumber;
        String address = employee.address;
        String position = employee.position;

        return AlertDialog(
          title: const Text('Update Employee'),
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
                TextField(
                  decoration: const InputDecoration(labelText: 'Position'),
                  onChanged: (value) {
                    position = value;
                  },
                  controller: TextEditingController(text: position),
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
                final updatedEmployee = Employee(
                  employee.id,
                  name,
                  emailAddress,
                  phoneNumber,
                  address,
                  employee.birthDate,
                  employee.gender,
                  position,
                  employee.registrationDate,
                  DateTime.now(),
                );
                bloc.updateEmployee(updatedEmployee);
                Navigator.of(context).pop(updatedEmployee);
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    ).then((updatedEmployee) {
      if (updatedEmployee != null) {
        // Display a notification
        const snackBar =
            SnackBar(content: Text('Employee updated successfully.'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        // Navigate to the screen that shows all employees
        Navigator.pushNamed(context, EmployeeListView.routeName);

        // Handle updated employee
        print('Updated employee: $updatedEmployee');
      }
    });
  }
}
