import 'package:birthday_scheduler/core/common/loader.dart';
import 'package:birthday_scheduler/features/schedule_birthday/controller/schedule_birthday_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ScheduleBirthdayScreen extends ConsumerStatefulWidget {
  const ScheduleBirthdayScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ScheduleBirthdayScreenState();
}

class _ScheduleBirthdayScreenState
    extends ConsumerState<ScheduleBirthdayScreen> {
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

  void scheduleBirthday() {
    print(_timeOfDay.format(context));
    print(_currentDate.toString().substring(0, 10));

    print('Lokacija: $_location');
    print('Kontakt: $_contact');
    print('Ime deteta: $_childsName');
    print('Kolko godina puni: $_childsTurningAge');
    print('Email: $_email');
    print('Paket: $_package');
    print('Cena: $_price');
    print('Treneri:');

    var trainers = List<String>.filled(_controllersTrainers.length, '');
    for (int i = 0; i < _controllersTrainers.length; i++) {
      trainers[i] = _controllersTrainers[i].text.trim();
      print('$i. ${trainers[i]}');
    }

    print('Naplatio trener ${trainers[_selectedRadio!]}');
    print('Napomena: $_note');

    ref.read(birthdayControllerProvider.notifier).scheduleBirthday(
          _currentDate.toString().substring(0, 10),
          _timeOfDay.format(context),
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

  void _showTimePicker() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((value) {
      setState(() {
        _timeOfDay = value!;
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
      setState(() {
        _currentDate = value!;
      });
    });
  }

  Widget _buildTextField(int index) {
    return Row(
      children: [
        Radio(
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
        title: const Text("Zakazivanje rodjendana"),
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
                            DateFormat('d. MMMM y (EEEE)', 'sr_Latn')
                                .format(_currentDate),
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
                            _timeOfDay.format(context).toString(),
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
                            print('When does this get called');
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
                    onPressed: () {
                      scheduleBirthday();
                    },
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
