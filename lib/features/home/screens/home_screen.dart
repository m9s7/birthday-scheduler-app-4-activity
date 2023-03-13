import 'package:birthday_scheduler/core/common/error_text.dart';
import 'package:birthday_scheduler/core/common/formaters.dart';
import 'package:birthday_scheduler/core/common/loader.dart';
import 'package:birthday_scheduler/features/auth/controller/auth_controller.dart';
import 'package:birthday_scheduler/features/home/drawers/general_drawer.dart';
import 'package:birthday_scheduler/features/schedule_birthday/controller/schedule_birthday_controller.dart';
import 'package:birthday_scheduler/features/schedule_birthday/widgets/card.dart';
import 'package:birthday_scheduler/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void navigateToScheduleBirthday(BuildContext context, String date) {
    Routemaster.of(context).push('schedule_bday/$date');
  }

  DateTime pickedDate = DateTime.now();

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: pickedDate,
      firstDate: DateTime.utc(2023, 3, 1),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    ).then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        pickedDate = value;
      });
    });
  }

  void decreaseDateByOneDay() {
    setState(() => pickedDate = pickedDate.subtract(const Duration(days: 1)));
  }

  void increaseDateByOneDay() {
    setState(() => pickedDate = pickedDate.add(const Duration(days: 1)));
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pregled"),
        centerTitle: true,
        leading: Builder(builder: (context) {
          return IconButton(
            onPressed: () => displayDrawer(context),
            icon: const Icon(Icons.menu),
          );
        }),
        actions: [
          // IconButton(
          //   onPressed: () => {},
          //   icon: const Icon(Icons.search),
          // ),
          IconButton(
            icon: CircleAvatar(
              backgroundImage: NetworkImage(user.profilePic),
            ),
            onPressed: null,
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Row(
            children: [
              IconButton(
                onPressed: decreaseDateByOneDay,
                icon: const Icon(Icons.arrow_back),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: _showDatePicker,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: Text(
                    dateTimeToStringReadable(pickedDate),
                    style: const TextStyle(fontSize: 17),
                  ),
                ),
              ),
              IconButton(
                onPressed: increaseDateByOneDay,
                icon: const Icon(Icons.arrow_forward),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Flexible(
            child: ref
                .watch(birthdaysByDateProvider(dateTimeToString(pickedDate)))
                .when(
                  data: (birthdays) => ListView.builder(
                    itemCount: birthdays.length,
                    itemBuilder: (BuildContext context, int index) {
                      return BirthdayCard(bday: birthdays[index]);
                    },
                  ),
                  error: (error, stackTrace) => ErrorText(
                    error: error.toString(),
                  ),
                  loading: () => const Loader(),
                ),
          ),
        ],
      ),
      drawer: GeneralDrawer(isAuthenticated: user.isAuthenticated),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Pallete.blueColor,
        onPressed: () => navigateToScheduleBirthday(
          context,
          dateTimeToString(pickedDate),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
