import 'package:birthday_scheduler/features/admin/admin_panel.dart';
import 'package:birthday_scheduler/features/auth/screen/login_screen.dart';
import 'package:birthday_scheduler/features/home/screens/home_screen.dart';
import 'package:birthday_scheduler/features/schedule_birthday/screens/schedule_birthday_screen.dart';
import 'package:birthday_scheduler/features/schedule_birthday/screens/scheduled_birthday_screen.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute =
    RouteMap(routes: {'/': (_) => const MaterialPage(child: LoginScreen())});

final loggedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: HomeScreen()),
  '/schedule_bday/:date': (routeData) => MaterialPage(
          child: ScheduleBirthdayScreen(
        initialDate: routeData.pathParameters['date']!,
      )),
  '/scheduled_bday/:id': (routeData) => MaterialPage(
        child: ScheduledBirthdayScreen(
          id: routeData.pathParameters['id']!,
        ),
      ),
  '/admin': (_) => const MaterialPage(child: AdminPanel()),
});
