import 'package:flutter/material.dart';

void main() {
  runApp(const ContactApp());
}

class ContactApp extends StatelessWidget {
  const ContactApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: const ContactListScreen(),
      ),
    );
  }
}

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({super.key});

  @override
  State<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  final List<Map<String, String>> _contacts = [
    {'name': 'علی محمدی', 'phone': '09012345678'},
    {'name': 'سارا احمدی', 'phone': '09021234567'},
    {'name': 'رضا حسینی', 'phone': '09032214433'},
    {'name': 'مریم رضایی', 'phone': '09043339988'},
    {'name': 'حسین کریمی', 'phone': '09058881122'},
    {'name': 'فاطمه عباسی', 'phone': '09109903311'},
    {'name': 'مهدی باقری', 'phone': '09309929911'},
    {'name': 'زهرا موسوی', 'phone': '09153822211'},
    {'name': 'امیر قاسمی', 'phone': '09128833322'},
    {'name': 'نرگس صابری', 'phone': '09365556677'},
    {'name': 'محمد جعفری', 'phone': '09128889900'},
    {'name': 'الهام نوری', 'phone': '09194443322'},
    {'name': 'کاوه قربانی', 'phone': '09357778899'},
    {'name': 'نیلوفر طاهری', 'phone': '09126665544'},
  ];

  String _searchQuery = '';
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  List<Map<String, String>> get _filteredContacts {
    if (_searchQuery.isEmpty) {
      return _contacts;
    }
    return _contacts.where((contact) {
      final name = contact['name']!.toLowerCase();
      final phone = contact['phone']!;
      final query = _searchQuery.toLowerCase();
      return name.contains(query) || phone.contains(query);
    }).toList();
  }

  void _addContact() {
    if (_nameController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty)
      return;

    setState(() {
      _contacts.add({
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
      });
    });

    _nameController.clear();
    _phoneController.clear();
    Navigator.pop(context);
  }

  void _showEditDialog(Map<String, String> contact) {
    final TextEditingController editNameController = TextEditingController(
      text: contact['name'],
    );
    final TextEditingController editPhoneController = TextEditingController(
      text: contact['phone'],
    );

    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('ویرایش مخاطب'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: editNameController,
                decoration: const InputDecoration(
                  labelText: 'نام و نام خانوادگی',
                ),
              ),
              TextField(
                controller: editPhoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'شماره تلفن'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('انصراف'),
            ),
            ElevatedButton(
              onPressed: () {
                if (editNameController.text.trim().isNotEmpty &&
                    editPhoneController.text.trim().isNotEmpty) {
                  setState(() {
                    contact['name'] = editNameController.text.trim();
                    contact['phone'] = editPhoneController.text.trim();
                  });
                }
                Navigator.pop(context);
              },
              child: const Text('ذخیره'),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteContact(Map<String, String> contact) {
    setState(() {
      _contacts.remove(contact);
    });
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('افزودن مخاطب جدید'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'نام و نام خانوادگی',
                ),
              ),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'شماره تلفن'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('انصراف'),
            ),
            ElevatedButton(onPressed: _addContact, child: const Text('ذخیره')),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayedContacts = _filteredContacts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('لیست مخاطبین'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'جستجوی نام یا شماره تلفن...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          Expanded(
            child: displayedContacts.isEmpty
                ? const Center(child: Text('هیچ مخاطبی یافت نشد.'))
                : ListView.builder(
                    itemCount: displayedContacts.length,
                    itemBuilder: (context, index) {
                      final contact = displayedContacts[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.indigo.shade100,
                            child: Text(
                              contact['name']![0],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo,
                              ),
                            ),
                          ),
                          title: Text(contact['name']!),
                          subtitle: Text(contact['phone']!),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Edit Button
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: () => _showEditDialog(contact),
                              ),
                              // Delete Button
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.redAccent,
                                ),
                                onPressed: () => _deleteContact(contact),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
