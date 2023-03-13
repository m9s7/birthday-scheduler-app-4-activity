import 'package:birthday_scheduler/core/common/formaters.dart';
import 'package:birthday_scheduler/core/common/loader.dart';
import 'package:birthday_scheduler/core/constants/firebase_constants.dart';
import 'package:birthday_scheduler/core/utils.dart';
import 'package:birthday_scheduler/features/auth/controller/auth_controller.dart';
import 'package:birthday_scheduler/features/schedule_birthday/controller/schedule_birthday_controller.dart';
import 'package:birthday_scheduler/models/birthday_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:routemaster/routemaster.dart';
import 'package:share_plus/share_plus.dart';

class ScheduledBirthdayScreen extends ConsumerStatefulWidget {
  final String id;
  const ScheduledBirthdayScreen({super.key, required this.id});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ScheduledBirthdayScreenState();
}

class _ScheduledBirthdayScreenState
    extends ConsumerState<ScheduledBirthdayScreen> {
  Birthday? birthday;

  TimeOfDay _timeOfDay = TimeOfDay.now();
  DateTime _currentDate = DateTime.now();
  String _location = '';
  String _contact = '';
  String _childsName = '';
  String _childsTurningAge = '';
  String _email = '';
  String _package = '';
  String _price = '';
  int? _selectedRadio = 0;
  String _note = '';

  bool enabled = false;

  bool isAdmin = false;
  bool isFinalized = false;

  // Controllers
  final _controllerLocation = TextEditingController();
  final _controllerContact = TextEditingController();
  final _controllerChildsName = TextEditingController();
  final _controllerChildsTurningAge = TextEditingController();
  final _controllerEmail = TextEditingController();
  final _controllerPackage = TextEditingController();
  final _controllerPrice = TextEditingController();
  final List<TextEditingController> _controllersTrainers = [
    TextEditingController()
  ];
  final _controllerNote = TextEditingController();

  @override
  void initState() {
    super.initState();
    getBdayFromFirebase();
  }

  //TODO:
  // napravi da ako je finalized nepojavljuju ti se vise dugmici za delete i edit

  // Puca mi ceo kurac za provider-e
  Future<void> getBdayFromFirebase() async {
    final CollectionReference bdayCollection = FirebaseFirestore.instance
        .collection(FirebaseConstants.birthdaysCollection);

    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await bdayCollection.doc(widget.id).get()
            as DocumentSnapshot<Map<String, dynamic>>;

    var isAdminHelp = ref.read(userProvider)!.isAuthenticated;

    setState(() {
      birthday = Birthday.fromMap(documentSnapshot.data()!);
      _timeOfDay = stringToTimeOfDay(birthday!.time);
      _currentDate = stringToDateTime(birthday!.date);
      _location = birthday!.location;
      _contact = birthday!.contact;
      _childsName = birthday!.childsName;
      _childsTurningAge = birthday!.turningAge;
      _email = birthday!.email;
      _package = birthday!.package;
      _price = birthday!.price;
      _selectedRadio = birthday!.entertainers.indexOf(birthday!.saleCollector);
      _note = birthday!.note;
      isFinalized = birthday!.finalized;

      _controllerLocation.text = birthday!.location;
      _controllerContact.text = birthday!.contact;
      _controllerChildsName.text = birthday!.childsName;
      _controllerChildsTurningAge.text = birthday!.turningAge;
      _controllerEmail.text = birthday!.email;
      _controllerPackage.text = birthday!.package;
      _controllerPrice.text = birthday!.price;
      _controllersTrainers[0].text = birthday!.entertainers[0];
      for (int i = 1; i < birthday!.entertainers.length; i++) {
        String entertainer = birthday!.entertainers[i];
        _controllersTrainers.add(TextEditingController(text: entertainer));
      }
      _controllerNote.text = birthday!.note;

      isAdmin = isAdminHelp;
    });
  }

  void _showTimePicker() {
    showTimePicker(
      context: context,
      initialTime: _timeOfDay,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    ).then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        _timeOfDay = value;
      });
    });
  }

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: _currentDate,
      firstDate: DateTime.utc(2023, 3, 1),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    ).then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        _currentDate = value;
      });
    });
  }

  void editOnPressed() {
    setState(() {
      enabled = true;
    });
  }

  void saveOnPressed() {
    _location = _controllerLocation.text.trim();
    if (_location.isEmpty) {
      showSnackBar(context, "Unesite lokaciju.");
      return;
    }
    _contact = _controllerContact.text.trim();
    if (_contact.isEmpty) {
      showSnackBar(context, "Unesite kontakt roditelja.");
      return;
    }
    _childsName = _controllerChildsName.text.trim();
    if (_childsName.isEmpty) {
      showSnackBar(context, "Unesite ime deteta.");
      return;
    }
    _childsTurningAge = _controllerChildsTurningAge.text.trim();
    if (_childsTurningAge.isEmpty) {
      showSnackBar(context, "Unesite koliko dete puni godina.");
      return;
    }
    _email = _controllerEmail.text.trim();
    if (_email.isEmpty) {
      showSnackBar(context, "Unesite email roditelja.");
      return;
    }
    _package = _controllerPackage.text.trim();
    if (_package.isEmpty) {
      showSnackBar(context, "Unesite paket.");
      return;
    }
    _price = _controllerPrice.text.trim();
    if (_price.isEmpty) {
      showSnackBar(context, "Unesite cenu.");
      return;
    }
    if (_controllersTrainers.isEmpty || _controllersTrainers[0].text.isEmpty) {
      showSnackBar(context, "Morate uneti bar jednog trenera!");
      return;
    }
    var trainers = List<String>.filled(_controllersTrainers.length, '');
    for (int i = 0; i < _controllersTrainers.length; i++) {
      trainers[i] = _controllersTrainers[i].text.trim();
      if (trainers[i].isEmpty) {
        showSnackBar(context, "Trener ${i + 1} nije unet.");
        return;
      }
    }
    _note = _controllerNote.text.trim();

    DocumentReference documentReference = FirebaseFirestore.instance
        .collection(FirebaseConstants.birthdaysCollection)
        .doc(widget.id);

    documentReference.update({
      'date': dateTimeToString(_currentDate),
      'time': timeOfDayTo24hFormatString(_timeOfDay),
      'location': _location.trim(),
      'contact': _contact.trim(),
      'childsName': _childsName.trim(),
      'turningAge': _childsTurningAge.trim(),
      'email': _email.trim(),
      'package': _package.trim(),
      'price': _price.trim(),
      'entertainers': trainers,
      'saleCollector': trainers[_selectedRadio!],
      'note': _note.trim()
    }).then((value) {
      showSnackBar(context, "Ažuriranje uspesno!");
    }).catchError((error) {
      showSnackBar(context, "Ažuriranje nije uspelo!");
    });

    setState(() {
      enabled = false;
    });
  }

  void shareOnPressed() {
    var trainers = List<String>.filled(_controllersTrainers.length, '');
    for (int i = 0; i < _controllersTrainers.length; i++) {
      trainers[i] = _controllersTrainers[i].text.trim();
    }

    Share.share(
      'Rođendan ${dateTimeToStringReadable(_currentDate)} u ${timeOfDayTo24hFormatString(_timeOfDay)}\n\n'
      '$_location\n\n'
      'Email: $_email\n'
      'Kontakt: $_contact\n\n'
      'Dete: $_childsName puni godina $_childsTurningAge\n\n'
      'Paket: $_package\n'
      'Cena: $_price\n'
      'Naplaćuje: ${trainers[_selectedRadio!]}\n\n'
      'Treneri: ${trainers.toString().substring(1, trainers.toString().length - 1)}\n\n'
      'Zakazao/la: ${birthday!.createdBy} (${birthday!.createdDate.substring(0, 10)})\n'
      'Napomena: $_note\n',
    );
  }

  void deleteOnPressed() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Da li ste sigurni?'),
          content: const Text(
              'Podaci ce biti izgubljeni. Ova akcija ne može da se vrati.'),
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
        DocumentReference documentReference = FirebaseFirestore.instance
            .collection(FirebaseConstants.birthdaysCollection)
            .doc(widget.id);

        documentReference.delete().then((value) {
          showSnackBar(context, 'Obrisano!');
          Routemaster.of(context).push('/');
        }).catchError((error) {
          showSnackBar(context, 'Brisanje nije uspelo: $error');
        });
      }
    });
  }

  void finalizeOnPressed() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Da li ste sigurni?'),
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
        DocumentReference documentReference = FirebaseFirestore.instance
            .collection(FirebaseConstants.birthdaysCollection)
            .doc(widget.id);

        documentReference.update({'finalized': true}).then((value) {
          showSnackBar(context, "Uspešno!");
        }).catchError((error) {
          showSnackBar(context, "Nije uspelo!");
        });

        setState(() {
          //TODO: videcemo dal nesto treba
          // enabled = false;
        });
      }
    });
  }

  Widget _buildTextField(int index, bool enabled) {
    return Row(
      children: [
        Radio(
          activeColor: Colors.blue,
          value: index,
          groupValue: _selectedRadio,
          onChanged: enabled
              ? (value) {
                  setState(() {
                    _selectedRadio = value as int?;
                  });
                }
              : null,
        ),
        Expanded(
          child: TextFormField(
            enabled: enabled,
            style: !enabled ? TextStyle(color: Colors.grey.shade600) : null,
            decoration: InputDecoration(
              labelText: 'Trener ${index + 1}',
            ),
            controller: _controllersTrainers[index],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: enabled
              ? () {
                  setState(() {
                    if (_selectedRadio == index) {
                      _selectedRadio = index - 1;
                    }
                    _controllersTrainers.removeAt(index);
                  });
                }
              : null,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(birthdayControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ažuriraj rođendan"),
        centerTitle: true,
      ),
      body: isLoading
          ? const Loader()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  isAdmin && !isFinalized && !enabled
                      ? ElevatedButton(
                          onPressed: finalizeOnPressed,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: const Text(
                            "Finaliziraj",
                            style: TextStyle(fontSize: 17),
                          ),
                        )
                      : const SizedBox.shrink(),
                  // SHARE, EDIT, DELETE buttons
                  const SizedBox(height: 5),
                  !enabled
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.edit),
                                  label: const Text(
                                    'Izmeni',
                                    style: TextStyle(fontSize: 17),
                                  ),
                                  onPressed: editOnPressed,
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(10, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.delete),
                                  label: const Text(
                                    'Obriši',
                                    style: TextStyle(fontSize: 17),
                                  ),
                                  onPressed: deleteOnPressed,
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(10, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.share),
                                  label: const Text(
                                    'Podeli',
                                    style: TextStyle(fontSize: 17),
                                  ),
                                  onPressed: shareOnPressed,
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(10, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),

                  const Text('Vreme i mesto'),
                  const SizedBox(height: 10),

                  // DATE & TIME PICKER
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: enabled ? _showDatePicker : null,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: Text(
                            dateTimeToStringReadable(_currentDate),
                            style: const TextStyle(fontSize: 17),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        flex: 1,
                        child: ElevatedButton(
                          onPressed: enabled ? _showTimePicker : null,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: Text(
                            timeOfDayTo24hFormatString(_timeOfDay),
                            style: const TextStyle(fontSize: 17),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  // LOCATION
                  TextFormField(
                    enabled: enabled,
                    style: !enabled
                        ? TextStyle(color: Colors.grey.shade600)
                        : null,
                    controller: _controllerLocation,
                    decoration: const InputDecoration(
                      labelText: 'Lokacija',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => _location = value,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 10),
                  const Text('Informacije o klijentu'),
                  const SizedBox(height: 10),
                  // CONTACT
                  TextFormField(
                    enabled: enabled,
                    style: !enabled
                        ? TextStyle(color: Colors.grey.shade600)
                        : null,
                    controller: _controllerContact,
                    decoration: const InputDecoration(
                      labelText: 'Kontakt',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => _contact = value,
                  ),
                  const SizedBox(height: 10),
                  // CHILDS NAME
                  TextFormField(
                    enabled: enabled,
                    style: !enabled
                        ? TextStyle(color: Colors.grey.shade600)
                        : null,
                    controller: _controllerChildsName,
                    decoration: const InputDecoration(
                      labelText: 'Ime slavljenika',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => _childsName = value,
                  ),
                  const SizedBox(height: 10),
                  // CHILDS TURNING AGE
                  TextFormField(
                    enabled: enabled,
                    style: !enabled
                        ? TextStyle(color: Colors.grey.shade600)
                        : null,
                    controller: _controllerChildsTurningAge,
                    decoration: const InputDecoration(
                      labelText: 'Koliko godina puni?',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => _childsTurningAge = value,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  ),
                  const SizedBox(height: 10),
                  // EMAIL
                  TextFormField(
                    style: !enabled
                        ? TextStyle(color: Colors.grey.shade600)
                        : null,
                    enabled: enabled,
                    controller: _controllerEmail,
                    decoration: const InputDecoration(
                      labelText: 'Email roditelja',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => _email = value,
                  ),
                  const SizedBox(height: 10),
                  // PACKAGE
                  TextFormField(
                    enabled: enabled,
                    style: !enabled
                        ? TextStyle(color: Colors.grey.shade600)
                        : null,
                    controller: _controllerPackage,
                    decoration: const InputDecoration(
                      labelText: 'Paket koji uzima',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => _package = value,
                  ),
                  const SizedBox(height: 10),
                  // PRICE
                  TextFormField(
                    enabled: enabled,
                    style: !enabled
                        ? TextStyle(color: Colors.grey.shade600)
                        : null,
                    controller: _controllerPrice,
                    decoration: const InputDecoration(
                      labelText: 'Cena',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => _price = value,
                  ),
                  const SizedBox(height: 10),
                  // TRENERI
                  const Text(
                      'Treneri koji idu na rođenadan i kod koga su pare'),
                  const SizedBox(height: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // REQUIRED TRENER
                      Row(
                        children: [
                          Radio(
                            activeColor: Colors.blue,
                            value: 0,
                            groupValue: _selectedRadio,
                            onChanged: enabled
                                ? (value) {
                                    setState(() {
                                      _selectedRadio = value as int?;
                                    });
                                  }
                                : null,
                          ),
                          Expanded(
                            child: TextFormField(
                              enabled: enabled,
                              style: !enabled
                                  ? TextStyle(color: Colors.grey.shade600)
                                  : null,
                              decoration: const InputDecoration(
                                labelText: 'Trener 1',
                              ),
                              controller: _controllersTrainers[0],
                            ),
                          ),
                        ],
                      ),
                      // OPTIONAL TRENERI
                      for (int i = 1; i < _controllersTrainers.length; i++)
                        _buildTextField(i, enabled),
                      // ADD BUTTON
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: enabled
                            ? () {
                                setState(() {
                                  _controllersTrainers
                                      .add(TextEditingController());
                                });
                              }
                            : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // NOTE
                  TextFormField(
                    enabled: enabled,
                    style: !enabled
                        ? TextStyle(color: Colors.grey.shade600)
                        : null,
                    controller: _controllerNote,
                    decoration: const InputDecoration(
                      labelText: 'Napomena',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => _note = value,
                  ),
                  const SizedBox(height: 10),
                  enabled
                      ? ElevatedButton(
                          onPressed: saveOnPressed,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: const Text(
                            "Ažuriraj rođendan",
                            style: TextStyle(fontSize: 17),
                          ),
                        )
                      : const SizedBox.shrink(),
                  // BUTTONS
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    // Dispose of text editing controllers
    _controllerLocation.dispose();
    _controllerContact.dispose();
    _controllerChildsName.dispose();
    _controllerChildsTurningAge.dispose();
    _controllerEmail.dispose();
    _controllerPackage.dispose();
    _controllerPrice.dispose();
    for (TextEditingController controller in _controllersTrainers) {
      controller.dispose();
    }
    _controllerNote.dispose();

    super.dispose();
  }
}
