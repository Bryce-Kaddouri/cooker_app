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
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../features/auth/presentation/provider/auth_provider.dart';
import '../../features/auth/presentation/screen/signin_screen.dart';
import '../../features/details/presentation/screen/order_details_screen.dart';
import '../../features/order/presentation/screen/order_screen.dart';

class RouterHelper {
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
          name: 'orders',
          path: '/orders',
          builder: (context, state) => OrderScreen(),
          routes: [
            GoRoute(
              name: 'order-details',
              path: ':id',
              /*builder: (context, state) {
                String idStr = state.pathParameters['id']!;
                int orderId = int.parse(idStr);
                return OrderDetailScreen(orderId: orderId);
              },*/
              pageBuilder: (context, state) {
                String idStr = state.pathParameters['id']!;
                int orderId = int.parse(idStr);
                return CustomTransitionPage(
                  child: OrderDetailScreen(orderId: orderId),
                  // slide left to right transition
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  },
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => SignInScreen(),
        ),
      ],
    );
  }
}
