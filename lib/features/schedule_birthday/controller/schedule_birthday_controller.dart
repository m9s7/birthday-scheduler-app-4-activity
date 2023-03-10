import 'package:birthday_scheduler/core/utils.dart';
import 'package:birthday_scheduler/features/auth/controller/auth_controller.dart';
import 'package:birthday_scheduler/features/schedule_birthday/repository/schedule_birthday_repository.dart';
import 'package:birthday_scheduler/models/birthday_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

final selectedBirthdayProvider = StateProvider<Birthday?>((ref) => null);

final birthdaysByDateProvider = StreamProvider.family((ref, String date) {
  final birthdayController = ref.watch(birthdayControllerProvider.notifier);
  return birthdayController.getScheduledBirthdaysOnDate(date);
});

final birthdayControllerProvider =
    StateNotifierProvider<BirthdayController, bool>((ref) {
  final birthdayRepository = ref.watch(birthdayRepositoryProvider);
  return BirthdayController(birthdayRepository: birthdayRepository, ref: ref);
});

class BirthdayController extends StateNotifier<bool> {
  final BirthdayRepository _birthdayRepository;

  final Ref _ref;
  BirthdayController({required birthdayRepository, required ref})
      : _birthdayRepository = birthdayRepository,
        _ref = ref,
        super(false);

  Future<void> scheduleBirthday(
    String date,
    String time,
    String location,
    String contact,
    String childsName,
    String turningAge,
    String email,
    String package,
    String price,
    List<String> entertainers,
    String saleCollector,
    bool finalized,
    String note,
    BuildContext context,
  ) async {
    state = true;

    final currentUser = _ref.read(userProvider);
    final String creator = currentUser?.name ??
        currentUser?.email ??
        currentUser?.uid ??
        "Unknown";

    Birthday birthday = Birthday(
      id: (childsName + turningAge).replaceAll(" ", ""),
      createdBy: creator,
      createdDate: DateTime.now().toString(),
      date: date,
      time: time,
      location: location,
      contact: contact,
      childsName: childsName,
      turningAge: turningAge,
      email: email,
      package: package,
      price: price,
      entertainers: entertainers,
      saleCollector: saleCollector,
      finalized: false,
      note: note,
    );

    final res = await _birthdayRepository.scheduleBirthday(birthday);
    state = false;
    res.fold((error) {
      showSnackBar(context, error.message);
    }, (success) {
      Routemaster.of(context).pop();
      showSnackBar(context, "Rodjendan uspesno zakazan!");
    });
  }

  Stream<List<Birthday>> getScheduledBirthdaysOnDate(String date) {
    return _birthdayRepository.getScheduledBirthdaysOnDate(date);
  }

  void getSelectedBirthday(BuildContext context, String id) async {
    state = true;
    final bday = await _birthdayRepository.getBirthdayById(id);
    state = false;
    bday.fold(
        (error) => showSnackBar(context, error.message),
        (birthday) => _ref
            .read(selectedBirthdayProvider.notifier)
            .update((state) => birthday));
    print('gotova f-ja koja treba sve da sredi');
  }

  Stream<Birthday> getBirthdayData(String id) {
    return _birthdayRepository.getBirthdayData(id);
  }
}
