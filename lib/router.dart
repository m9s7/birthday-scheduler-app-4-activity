import 'package:birthday_scheduler/features/auth/screen/login_screen.dart';
import 'package:birthday_scheduler/features/home/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute =
    RouteMap(routes: {'/': (_) => const MaterialPage(child: LoginScreen())});

final loggedInRoute =
    RouteMap(routes: {'/': (_) => const MaterialPage(child: HomeScreen())});
