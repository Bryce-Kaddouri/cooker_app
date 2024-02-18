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
import 'package:cooker_app/src/core/helper/date_helper.dart';
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
      errorBuilder: (context, state) {
        print('error: ${state.error}');
        return Container(
          child: Center(
            child: Text('Error: ${state.error}'),
          ),
        );
      },
      navigatorKey: Get.key,
      redirect: (context, state) {
        // check if user is logged in
        // if not, redirect to login page

        print('state: ${state.matchedLocation}');
        print('state: ${state.uri}');

        bool isLoggedIn = context.read<AuthProvider>().checkIsLoggedIn();
        print('isLoggedIn: $isLoggedIn');
        if (state.error != null) {
          print('error: ${state.error}');
          DateTime date = DateTime.now();
          String dateStr = '${date.year}-${date.month}-${date.day}';
          context.go('/orders/$dateStr');
          return '/orders/$dateStr';
        }
        if (!isLoggedIn && state.uri.path != '/login') {
          return '/login';
        } else {
          return state.uri.path;
        }
      },
      routes: [
        GoRoute(
          name: 'orders',
          path: '/orders/:date',
          builder: (context, state) {
            String dateStr = DateHelper.getFormattedDate(
                DateTime.parse(state.pathParameters['date']!));
            print('state');
            print('dateStr: $dateStr');
            // check if date af this format 2023-12-05
            // regex pattern
            RegExp datePattern = RegExp(r'^\d{4}-\d{2}-\d{2}$');
            if (!datePattern.hasMatch(dateStr)) {
              return Container(
                child: Center(
                  child: Text('Invalid date'),
                ),
              );
            }

            DateTime date = DateTime.parse(dateStr);

            return OrderScreen(
              selectedDate: date,
            );
          },
          routes: [
            GoRoute(
              name: 'order-details',
              path: ':id',
              pageBuilder: (context, state) {
                // check if date af this format 2023-12-05
                // regex pattern
                RegExp datePattern = RegExp(r'^\d{4}-\d{2}-\d{2}$');
                String dateStr = state.pathParameters['date']!;
                print('state');
                if (!datePattern.hasMatch(dateStr)) {
                  return CustomTransitionPage(
                    child: Center(
                      child: Text('Invalid date'),
                    ),
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
                }
                DateTime date = DateTime.parse(dateStr);
                String idStr = state.pathParameters['id']!;
                print('state');
                int orderId = int.parse(idStr);
                return CustomTransitionPage(
                  child: OrderDetailScreen(orderId: orderId, orderDate: date),
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
