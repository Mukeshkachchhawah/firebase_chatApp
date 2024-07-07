import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactViewModel extends ChangeNotifier {
  List<Contact> _contacts = [];
  List<Contact> _filteredContacts = [];
  String _filter = '';

  List<Contact> get contacts => _filteredContacts;

  ContactViewModel() {
    _getContacts();
  }

  Future<void> _getContacts() async {
    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus == PermissionStatus.granted) {
      try {
        Iterable<Contact> contacts = await ContactsService.getContacts();
        _contacts = contacts.toList();
        _applyFilter();
      } catch (e) {
        print("Error fetching contacts: $e");
      }
    } else {
      // Handle permission errors
    }
  }
  // फ़ंक्शन जो कॉन्टैक्ट परमिशन को चेक करता है
  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      Map<Permission, PermissionStatus> statuses =
          await [Permission.contacts].request();
      return statuses[Permission.contacts] ?? PermissionStatus.denied;
    } else {
      return permission;
    }
  }

  void setFilter(String filter) {
    _filter = filter;
    _applyFilter();
  }

  void _applyFilter() {
    if (_filter.isEmpty) {
      _filteredContacts = _contacts;
    } else {
      _filteredContacts = _contacts
          .where((contact) =>
              contact.displayName
                  ?.toLowerCase()
                  .contains(_filter.toLowerCase()) ??
              false)
          .toList();
    }
    notifyListeners();
  }
}
