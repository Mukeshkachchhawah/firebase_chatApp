import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'context_view_modal.dart';

class ContactUserView extends StatelessWidget {
  const ContactUserView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ContactViewModel>(
      create: (context) => ContactViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Contacts List'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Consumer<ContactViewModel>(
                builder: (context, viewModel, child) {
                  return TextField(
                    decoration: const InputDecoration(
                      labelText: 'Search Contacts',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      viewModel.setFilter(value);
                    },
                  );
                },
              ),
            ),
            Expanded(
              child: Consumer<ContactViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.contacts.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return ListView.builder(
                      itemCount: viewModel.contacts.length,
                      itemBuilder: (context, index) {
                        Contact contact = viewModel.contacts[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: contact.avatar != null &&
                                    contact.avatar!.isNotEmpty
                                ? MemoryImage(contact.avatar!)
                                : NetworkImage(
                                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcScuQGyYbgV9HFyiunO9mF6_lnB6MYwcx6t3w&s"),
                          ),
                          title: Text(contact.displayName ?? ''),
                          subtitle: Text(
                            contact.phones!.isNotEmpty
                                ? contact.phones!.first.value ?? ''
                                : '',
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
