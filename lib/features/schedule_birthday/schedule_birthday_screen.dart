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
  final kidIsTurningAgeController = TextEditingController();

  TimeOfDay _timeOfDay = TimeOfDay.now();
  DateTime _currentDate = DateTime.now();

  String location = '';
  String contact = '';
  String childsName = '';
  String childTurningAge = '';
  String email = '';
  String package = '';
  String price = '';
  String note = '';

  void _nextFocusNode(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  //TODO:
  // Can you make these fields private
  // Get values from the controllers
  // dispose of all the controllers

  final FocusNode _focusNodeLocation = FocusNode();
  final FocusNode _focusNodeContact = FocusNode();
  final FocusNode _focusNodeChildsName = FocusNode();
  final FocusNode _focusNodeChildTurningAge = FocusNode();
  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodePackage = FocusNode();
  final FocusNode _focusNodePrice = FocusNode();
  final FocusNode _focusNodeNote = FocusNode();

  @override
  void dispose() {
    super.dispose();
    kidIsTurningAgeController.dispose();

    _focusNodeLocation.dispose();
    _focusNodeContact.dispose();
    _focusNodeChildsName.dispose();
    _focusNodeChildTurningAge.dispose();
    _focusNodeEmail.dispose();
    _focusNodePackage.dispose();
    _focusNodePrice.dispose();
    _focusNodeNote.dispose();
  }

  // void scheduleBirthday() {
  //   ref.read(birthdayControllerProvider.notifier).
  // }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Schedule a birthday"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
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
                        borderRadius: BorderRadius.circular(20),
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
                        borderRadius: BorderRadius.circular(20),
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
              focusNode: _focusNodeLocation,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) => _nextFocusNode(
                  context, _focusNodeLocation, _focusNodeContact),
              decoration: const InputDecoration(
                labelText: 'Lokacija',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => location = value,
              maxLines: 2,
            ),
            const SizedBox(height: 10),
            // CONTACT
            TextFormField(
              focusNode: _focusNodeContact,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) => _nextFocusNode(
                  context, _focusNodeContact, _focusNodeChildsName),
              decoration: const InputDecoration(
                labelText: 'Kontakt',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => contact = value,
            ),
            const SizedBox(height: 10),
            // CHILDS NAME
            TextFormField(
              focusNode: _focusNodeChildsName,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) => _nextFocusNode(
                  context, _focusNodeChildsName, _focusNodeChildTurningAge),
              decoration: const InputDecoration(
                labelText: 'Ime slavljenika',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => childsName = value,
            ),
            const SizedBox(height: 10),
            // CHILDS TURNING AGE
            TextFormField(
              focusNode: _focusNodeChildTurningAge,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) => _nextFocusNode(
                  context, _focusNodeChildTurningAge, _focusNodeEmail),
              decoration: const InputDecoration(
                labelText: 'Koliko godina puni?',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => childTurningAge = value,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
            const SizedBox(height: 10),
            // EMAIL
            TextFormField(
              focusNode: _focusNodeEmail,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) =>
                  _nextFocusNode(context, _focusNodeEmail, _focusNodePackage),
              decoration: const InputDecoration(
                labelText: 'Email roditelja',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => email = value,
            ),
            const SizedBox(height: 10),
            // PACKAGE
            TextFormField(
              focusNode: _focusNodePackage,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) =>
                  _nextFocusNode(context, _focusNodePackage, _focusNodePrice),
              decoration: const InputDecoration(
                labelText: 'Paket koji uzima',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => package = value,
            ),
            const SizedBox(height: 10),
            // PRICE
            TextFormField(
              focusNode: _focusNodePrice,
              decoration: const InputDecoration(
                labelText: 'Cena',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => price = value,
            ),
            const SizedBox(height: 10),
            // Ovde ubaci gluposti koje je trazio, zato ti neskace fokus odmah na note
            // NOTE
            TextFormField(
              focusNode: _focusNodeNote,
              decoration: const InputDecoration(
                labelText: 'Napomena',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => note = value,
            ),
            const SizedBox(height: 10),
            // Submit button
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
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
}
