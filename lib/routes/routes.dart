import 'package:flutter/material.dart';

import '../pages/home_page.dart';
import '../pages/login_page.dart';
import '../pages/random_page.dart';
import '../pages/register.dart';

Map<String, WidgetBuilder> getAplicationsRoutes() => <String, WidgetBuilder>{
      '/': (BuildContext context) => HomePage(),
      '/login': (BuildContext context) => LoginPage(),
      '/register': (BuildContext context) => RegisterPage(),
      '/random': (BuildContext context) => RandomPage(),
    };
