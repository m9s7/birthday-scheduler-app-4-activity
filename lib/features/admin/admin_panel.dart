import 'package:birthday_scheduler/core/constants/firebase_constants.dart';
import 'package:birthday_scheduler/core/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  late Future<Map<String, String>> _futureAuthLst;

  final TextEditingController _textController = TextEditingController();

  Future<Map<String, String>> getAuthList() async {
    final CollectionReference authLstCollection = FirebaseFirestore.instance
        .collection(FirebaseConstants.authorizedUsersCollection);

    var snapshot = await authLstCollection.get();

    Map<String, String> authLst = {};
    if (snapshot.docs.isNotEmpty) {
      for (DocumentSnapshot doc in snapshot.docs) {
        var obj = doc.data() as Map<String, dynamic>;
        authLst[doc.id] = obj['email'];
      }
    }

    return authLst;
  }

  @override
  void initState() {
    super.initState();
    _futureAuthLst = getAuthList();
  }

  void deleteOnPressed(String docId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Da li ste sigurni?'),
          content: const Text('Ovaj email više neće biti admin.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Nazad'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Potvrdi'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    ).then((value) {
      if (value == true) {
        removeEmailFromFirestore(docId);
        setState(() {});
      }
    });
  }

  Future<void> addEmailToFirestore(String email) async {
    await FirebaseFirestore.instance
        .collection(FirebaseConstants.authorizedUsersCollection)
        .add({'email': email}).then((value) {
      setState(() {
        _futureAuthLst = getAuthList();
      });
    }).catchError((error) {
      showSnackBar(context, 'Dodavanje nije uspelo: $error');
    });
  }

  Future<void> removeEmailFromFirestore(String docId) async {
    await FirebaseFirestore.instance
        .collection(FirebaseConstants.authorizedUsersCollection)
        .doc(docId)
        .delete()
        .then((value) {
      print('Uspesno obrisan');
      setState(() {
        _futureAuthLst = getAuthList();
      });
    }).catchError((error) {
      showSnackBar(context, 'Brisanje nije uspelo: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text(
              'Lista Admina (Longpress za brisanje)',
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: FutureBuilder<Map<String, String>>(
                future: _futureAuthLst,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        String key = snapshot.data!.keys.elementAt(index);
                        String? value = snapshot.data![key];
                        return ListTile(
                          title: Text(value!),
                          onLongPress: () => deleteOnPressed(key),
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text('Niko nije admin'));
                  }
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    style: TextStyle(color: Colors.grey.shade600),
                    decoration: const InputDecoration(
                      labelText: 'Email novog admina',
                    ),
                    controller: _textController,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    addEmailToFirestore(_textController.text);
                    _textController.clear();
                    setState(() {});
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
