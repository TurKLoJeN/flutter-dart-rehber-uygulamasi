import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phonebook/database/db_helper.dart';
import 'package:phonebook/model/contact.dart';


class AddContactPage extends StatelessWidget {
  final Contact contact;

  const AddContactPage({Key key, @required this.contact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(contact.id == null ? "Yeni Kişi Ekle" : contact.isim),
      ),
      body: SingleChildScrollView(child: ContactForm(contact: contact, child: AddContactForm())),
    );
  }
}

class ContactForm extends InheritedWidget {
  final Contact contact;

  ContactForm({Key key, @required Widget child, @required this.contact}) : super(key: key, child: child);

  static ContactForm of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(ContactForm);
  }

  @override
  bool updateShouldNotify(ContactForm oldWidget) {
    return contact.id != oldWidget.contact.id;
  }
}

class AddContactForm extends StatefulWidget {
  @override
  _AddContactFormState createState() => _AddContactFormState();
}

class _AddContactFormState extends State<AddContactForm> {
  final _formKey = GlobalKey<FormState>();
  DbHelper _dbHelper;

  @override
  void initState() {
    _dbHelper = DbHelper();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Contact contact = ContactForm.of(context).contact;

    return Column(
      children: <Widget>[
    Stack(children: [
    Image.asset(
    contact.avatar == null ? "assets/img/person.jpg" : contact.avatar,
      fit: BoxFit.cover,
      width: double.infinity,
      height: 250,
    ),
    Positioned(
    bottom: 8,
    right: 8,
    child: IconButton(
    onPressed: getFile,
    icon: Icon(Icons.camera_alt),
    color: Colors.white,
    ))
    ]),
        Padding(
          padding: EdgeInsets.all(8),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: TextFormField(
                    decoration: InputDecoration(hintText: "Kişi İsmi"),
                    initialValue: contact.isim,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "İsim Gerekli";
                      }
                    },
                    onSaved: (value) {
                      contact.isim = value;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(hintText: "Telefon Numarası"),
                    initialValue: contact.telnumara,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Telefon Numarası Gerekli";
                      }
                    },
                    onSaved: (value) {
                      contact.telnumara = value;
                    },
                  ),
                ),
                RaisedButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: Text("Submit"),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();

                      if (contact.id == null) {
                        await _dbHelper.insertContact(contact);
                      } else {
                        await _dbHelper.updateContact(contact);
                      }

                      var snackBar = Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text("${contact.isim} has been saved")),
                      );

                      snackBar.closed.then((onValue) {
                        Navigator.pop(context);
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void getFile() async {
    Contact contact = ContactForm.of(context).contact;

    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      contact.avatar = image.path;
    });
  }
}