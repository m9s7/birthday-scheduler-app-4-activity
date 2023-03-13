import 'package:birthday_scheduler/core/common/formaters.dart';
import 'package:birthday_scheduler/core/common/loader.dart';
import 'package:birthday_scheduler/core/utils.dart';
import 'package:birthday_scheduler/features/schedule_birthday/controller/schedule_birthday_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ScheduleBirthdayScreen extends ConsumerStatefulWidget {
  final String initialDate;
  const ScheduleBirthdayScreen({super.key, required this.initialDate});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ScheduleBirthdayScreenState();
}

class _ScheduleBirthdayScreenState
    extends ConsumerState<ScheduleBirthdayScreen> {
  // Object fields
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

  // Focus nodes
  final FocusNode _focusNodeLocation = FocusNode();
  final FocusNode _focusNodeContact = FocusNode();
  final FocusNode _focusNodeChildsName = FocusNode();
  final FocusNode _focusNodeChildTurningAge = FocusNode();
  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodePackage = FocusNode();
  final FocusNode _focusNodePrice = FocusNode();
  final FocusNode _focusNodeNote = FocusNode();

  void _nextFocusNode(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  void initState() {
    super.initState();
    _currentDate = stringToDateTime(widget.initialDate);
  }

  void _showTimePicker() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
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
      initialDate: DateTime.now(),
      firstDate: DateTime.utc(2023, 3, 8),
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

  void scheduleBirthday() {
    if (_location.isEmpty) {
      showSnackBar(context, "Unesite lokaciju.");
      return;
    }
    if (_contact.isEmpty) {
      showSnackBar(context, "Unesite kontakt roditelja.");
      return;
    }
    if (_childsName.isEmpty) {
      showSnackBar(context, "Unesite ime deteta.");
      return;
    }
    if (_childsTurningAge.isEmpty) {
      showSnackBar(context, "Unesite koliko dete puni godina.");
      return;
    }
    //
    if (_email.isEmpty) {
      showSnackBar(context, "Unesite email roditelja.");
      return;
    }
    if (_package.isEmpty) {
      showSnackBar(context, "Unesite paket.");
      return;
    }
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

    ref.read(birthdayControllerProvider.notifier).scheduleBirthday(
          dateTimeToString(_currentDate),
          timeOfDayTo24hFormatString(_timeOfDay),
          _location.trim(),
          _contact.trim(),
          _childsName.trim(),
          _childsTurningAge.trim(),
          _email.trim(),
          _package.trim(),
          _price.trim(),
          trainers,
          trainers[_selectedRadio!],
          false,
          _note.trim(),
          context,
        );
  }

  Widget _buildTextField(int index) {
    return Row(
      children: [
        Radio(
          activeColor: Colors.blue,
          value: index,
          groupValue: _selectedRadio,
          onChanged: (value) {
            setState(() {
              _selectedRadio = value;
            });
          },
        ),
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Trener ${index + 1}',
            ),
            controller: _controllersTrainers[index],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: () {
            setState(() {
              if (_selectedRadio == index) {
                _selectedRadio = index - 1;
              }
              _controllersTrainers.removeAt(index);
            });
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(birthdayControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Zakazivanje rođendana"),
        centerTitle: true,
      ),
      body: isLoading
          ? const Loader()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  const Text('Vreme i mesto'),
                  const SizedBox(height: 10),

                  // Date & Time Picker Buttons
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: _showDatePicker,
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
                          onPressed: _showTimePicker,
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
                  // Forms begin
                  const SizedBox(height: 10),
                  // LOCATION
                  TextFormField(
                    controller: _controllerLocation,
                    focusNode: _focusNodeLocation,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => _nextFocusNode(
                        context, _focusNodeLocation, _focusNodeContact),
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
                    controller: _controllerContact,
                    focusNode: _focusNodeContact,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => _nextFocusNode(
                        context, _focusNodeContact, _focusNodeChildsName),
                    decoration: const InputDecoration(
                      labelText: 'Kontakt',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => _contact = value,
                  ),
                  const SizedBox(height: 10),
                  // CHILDS NAME
                  TextFormField(
                    controller: _controllerChildsName,
                    focusNode: _focusNodeChildsName,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => _nextFocusNode(context,
                        _focusNodeChildsName, _focusNodeChildTurningAge),
                    decoration: const InputDecoration(
                      labelText: 'Ime slavljenika',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => _childsName = value,
                  ),
                  const SizedBox(height: 10),
                  // CHILDS TURNING AGE
                  TextFormField(
                    controller: _controllerChildsTurningAge,
                    focusNode: _focusNodeChildTurningAge,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => _nextFocusNode(
                        context, _focusNodeChildTurningAge, _focusNodeEmail),
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
                    controller: _controllerEmail,
                    focusNode: _focusNodeEmail,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => _nextFocusNode(
                        context, _focusNodeEmail, _focusNodePackage),
                    decoration: const InputDecoration(
                      labelText: 'Email roditelja',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => _email = value,
                  ),
                  const SizedBox(height: 10),
                  // PACKAGE
                  TextFormField(
                    controller: _controllerPackage,
                    focusNode: _focusNodePackage,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => _nextFocusNode(
                        context, _focusNodePackage, _focusNodePrice),
                    decoration: const InputDecoration(
                      labelText: 'Paket koji uzima',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => _package = value,
                  ),
                  const SizedBox(height: 10),
                  // PRICE
                  TextFormField(
                    controller: _controllerPrice,
                    focusNode: _focusNodePrice,
                    decoration: const InputDecoration(
                      labelText: 'Cena',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => _price = value,
                  ),
                  const SizedBox(height: 10),
                  // TRENERI
                  const Text(
                      'Treneri koji idu na rodjenadan i kod koga su pare'),
                  const SizedBox(height: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Radio(
                            activeColor: Colors.blue,
                            value: 0,
                            groupValue: _selectedRadio,
                            onChanged: (value) {
                              setState(() {
                                _selectedRadio = value;
                              });
                            },
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Trener 1',
                              ),
                              controller: _controllersTrainers[0],
                            ),
                          ),
                        ],
                      ),
                      for (int i = 1; i < _controllersTrainers.length; i++)
                        _buildTextField(i),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            _controllersTrainers.add(TextEditingController());
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // NOTE
                  TextFormField(
                    controller: _controllerNote,
                    focusNode: _focusNodeNote,
                    decoration: const InputDecoration(
                      labelText: 'Napomena',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => _note = value,
                  ),
                  const SizedBox(height: 10),
                  // SUBMIT BUTTON
                  ElevatedButton(
                    onPressed: scheduleBirthday,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: const Text(
                      "Zakazi rodjendan",
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    // Dispose of focus nodes
    _focusNodeLocation.dispose();
    _focusNodeContact.dispose();
    _focusNodeChildsName.dispose();
    _focusNodeChildTurningAge.dispose();
    _focusNodeEmail.dispose();
    _focusNodePackage.dispose();
    _focusNodePrice.dispose();
    _focusNodeNote.dispose();

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
