import 'package:flutter/material.dart';
import 'package:realm/realm.dart';

import '../settings/settings_view.dart';
import 'category.dart';

const Color collection1Color = Color(0xFF8C1F28);
const Color collection2Color = Color(0xFF591C21);
const Color collection3Color = Color(0xFF044040);
const Color collection4Color = Color(0xFFD92525);
const Color collection5Color = Color(0xFFF2F2F2);

class CategoryListBloc {
  final RealmResults<Category> categories;
  final Realm _realm;

  CategoryListBloc(this.categories) : _realm = categories.realm;

  void addNewCategory(
    String name,
    String notes,
    String creator,
  ) {
    final DateTime now = DateTime.now();
    _realm.write(() {
      _realm.add(Category(
        ObjectId(),
        name,
        notes,
        now,
        now,
        creator,
      ));
    });
  }

  void updateCategory(Category category) {
    _realm.write(() {
      final updatedCategory = _realm.find<Category>(category.id);
      if (updatedCategory != null) {
        updatedCategory.name = category.name;
        updatedCategory.notes = category.notes;
        updatedCategory.lastContactDate = DateTime.now();
      }
    });
  }

  void deleteCategory(Category category) {
    _realm.write(() {
      _realm.delete(category);
    });
  }
}

class CategoryListView extends StatefulWidget {
  const CategoryListView({Key? key, required this.bloc}) : super(key: key);

  static const routeName = '/categoryListView';

  final CategoryListBloc bloc;

  @override
  _CategoryListViewState createState() => _CategoryListViewState();
}

class _CategoryListViewState extends State<CategoryListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Categories',
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
          _showAddCategoryDialog(context);
        },
        tooltip: 'Add new category',
        backgroundColor: collection1Color,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<RealmResults<Category>>(
        stream: widget.bloc.categories.changes
            .map((changes) => changes.results)
            .asBroadcastStream(),
        initialData: widget.bloc.categories,
        builder: (context, snapshot) {
          final categories = snapshot.data;
          if (!snapshot.hasData || categories == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            restorationId: 'categoryListView',
            itemCount: categories.length,
            itemBuilder: (BuildContext context, int index) {
              final category = categories[index];
              return CategoryTile(category: category, bloc: widget.bloc);
            },
          );
        },
      ),
    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String name = '';
        String notes = '';
        String creator = '';

        return AlertDialog(
          title: const Text('Add New Category'),
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
                  decoration: const InputDecoration(labelText: 'Notes'),
                  onChanged: (value) {
                    notes = value;
                  },
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Creator'),
                  onChanged: (value) {
                    creator = value;
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
                widget.bloc.addNewCategory(
                  name,
                  notes,
                  creator,
                );

                Navigator.of(context).pop();

                // Display a notification
                const snackBar =
                    SnackBar(content: Text('Category added successfully.'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);

                // Navigate to the screen that shows all categories and replace the current screen
                Navigator.pushReplacementNamed(
                    context, CategoryListView.routeName);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

class CategoryTile extends StatelessWidget {
  const CategoryTile({
    Key? key,
    required this.category,
    required this.bloc,
  }) : super(key: key);

  final Category category;
  final CategoryListBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(category.id),
      background: Container(color: collection4Color),
      onDismissed: (direction) => bloc.deleteCategory(category),
      child: ListTile(
        title: Text(
          category.name,
          style: const TextStyle(
            color: collection1Color,
            fontSize: 18,
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CategoryDetailsView(category: category, bloc: bloc),
            ),
          );
        },
      ),
    );
  }
}

class CategoryDetailsView extends StatelessWidget {
  static const routeName = '/category';

  final Category category;
  final CategoryListBloc bloc;

  const CategoryDetailsView({
    Key? key,
    required this.category,
    required this.bloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Category Details',
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
              'Name: ${category.name}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: collection1Color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Notes: ${category.notes}',
              style: const TextStyle(
                fontSize: 18,
                color: collection1Color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Registration Date: ${category.registrationDate}',
              style: const TextStyle(
                fontSize: 18,
                color: collection1Color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Last Contact Date: ${category.lastContactDate}',
              style: const TextStyle(
                fontSize: 18,
                color: collection1Color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Creator: ${category.creator}',
              style: const TextStyle(
                fontSize: 18,
                color: collection1Color,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _showUpdateCategoryDialog(context);
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

  void _showUpdateCategoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String name = category.name;
        String notes = category.notes;
        String creator = category.creator;

        return AlertDialog(
          title: const Text('Update Category'),
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
                  decoration: const InputDecoration(labelText: 'Notes'),
                  onChanged: (value) {
                    notes = value;
                  },
                  controller: TextEditingController(text: notes),
                ),
                InkWell(
                  onTap: () {
                    _selectDate(context, (selectedDate) {
                      // Do nothing as the registration date is set automatically
                    });
                  },
                  child: InputDecorator(
                    decoration:
                        const InputDecoration(labelText: 'Registration Date'),
                    child: Text(
                      category.registrationDate.toString(),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    _selectDate(context, (selectedDate) {
                      // Do nothing as the last contact date is set automatically
                    });
                  },
                  child: InputDecorator(
                    decoration:
                        const InputDecoration(labelText: 'Last Contact Date'),
                    child: Text(
                      category.lastContactDate.toString(),
                    ),
                  ),
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Creator'),
                  onChanged: (value) {
                    creator = value;
                  },
                  controller: TextEditingController(text: creator),
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
                final updatedCategory = Category(
                  category.id,
                  name,
                  notes,
                  category.registrationDate,
                  category.lastContactDate,
                  creator,
                );
                bloc.updateCategory(updatedCategory);
                Navigator.of(context).pop(updatedCategory);
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    ).then((updatedCategory) {
      if (updatedCategory != null) {
        // Display a notification
        const snackBar =
            SnackBar(content: Text('Category updated successfully.'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        // Navigate to the screen that shows all categories
        Navigator.pushNamed(context, CategoryListView.routeName);

        // Handle updated category
        print('Updated category: $updatedCategory');
      }
    });
  }
}
