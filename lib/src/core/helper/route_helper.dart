

/*class Routes {
  static const String home = '/home';
  static const String login = '/login';

  final getPages = [
    GetPage(
      participatesInRootNavigator: true,
      name: Routes.home,
      page: () => HomeScreen(),
      transition: Transition.zoom,
      children: [],
    ),
    GetPage(
      participatesInRootNavigator: true,
      name: Routes.login,
      page: () => SignInScreen(),
      transition: Transition.zoom,
      children: [],
    ),
  ];
}*/

import 'package:cooker_app/src/features/order/presentation/order_screen.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../features/auth/presentation/provider/auth_provider.dart';
import '../../features/auth/presentation/screen/signin_screen.dart';

class RouterHelper {
  static back() {
    Get.key?.currentState?.pop();
  }

  GoRouter getRouter() {
    return GoRouter(
      navigatorKey: Get.key,
      redirect: (context, state) {
        // check if user is logged in
        // if not, redirect to login page

        print('state: ${state.matchedLocation}');
        print('state: ${state.uri}');

        bool isLoggedIn = context.read<AuthProvider>().checkIsLoggedIn();
        print('isLoggedIn: $isLoggedIn');

        if (!isLoggedIn && state.uri.path != '/login') {
          return '/login';
        } else {
          return state.uri.path;
        }
      },
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => OrderScreen(
          ),
        ),

        GoRoute(
          path: '/login',
          builder: (context, state) => SignInScreen(),
        ),
      ],
    );
  }
}


