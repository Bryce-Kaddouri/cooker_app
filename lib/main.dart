import 'package:cooker_app/src/core/constant/light_theme.dart';
import 'package:cooker_app/src/core/helper/route_helper.dart';
import 'package:cooker_app/src/features/auth/business/repository/auth_repository.dart';
import 'package:cooker_app/src/features/auth/business/usecase/auth_get_user_usecase.dart';
import 'package:cooker_app/src/features/auth/business/usecase/auth_is_looged_in_usecase.dart';
import 'package:cooker_app/src/features/auth/business/usecase/auth_login_usecase.dart';
import 'package:cooker_app/src/features/auth/business/usecase/auth_logout_usecase.dart';
import 'package:cooker_app/src/features/auth/business/usecase/auth_on_auth_change_usecase.dart';
import 'package:cooker_app/src/features/auth/data/datasource/auth_datasource.dart';
import 'package:cooker_app/src/features/auth/data/repository/auth_repository_impl.dart';
import 'package:cooker_app/src/features/auth/presentation/provider/auth_provider.dart';
import 'package:cooker_app/src/features/order/business/repository/order_repository.dart';
import 'package:cooker_app/src/features/order/business/usecase/order_get_orders_by_date_usecase.dart';
import 'package:cooker_app/src/features/order/data/datasource/order_datasource.dart';
import 'package:cooker_app/src/features/order/data/repository/order_repository_impl.dart';
import 'package:cooker_app/src/features/order/presentation/provider/filter_provider.dart';
import 'package:cooker_app/src/features/order/presentation/provider/order_provider.dart';
import 'package:cooker_app/src/features/order/presentation/provider/sort_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  usePathUrlStrategy();

  await Supabase.initialize(
    url: 'https://qlhzemdpzbonyqdecfxn.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFsaHplbWRwemJvbnlxZGVjZnhuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDQ4ODY4MDYsImV4cCI6MjAyMDQ2MjgwNn0.lcUJMI3dvMDT7LaO7MiudIkdxAZOZwF_hNtkQtF3OC8',
  );

  final supabaseAdmin = SupabaseClient(
      'https://qlhzemdpzbonyqdecfxn.supabase.co',
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFsaHplbWRwemJvbnlxZGVjZnhuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDQ4ODY4MDYsImV4cCI6MjAyMDQ2MjgwNn0.lcUJMI3dvMDT7LaO7MiudIkdxAZOZwF_hNtkQtF3OC8');
  final supabaseClient = Supabase.instance;
  AuthRepository authRepository =
      AuthRepositoryImpl(dataSource: AuthDataSource());
  OrderRepository orderRepository =
      OrderRepositoryImpl(orderDataSource: OrderDataSource());
  /*CategoryRepository categoryRepository = CategoryRepositoryImpl(dataSource: CategoryDataSource());
  ProductRepository productRepository = ProductRepositoryImpl(dataSource: ProductDataSource());
  UserRepository userRepository = UserRepositoryImpl(dataSource: UserDataSource());*/

  // set path strategy

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(
            authLoginUseCase: AuthLoginUseCase(authRepository: authRepository),
            authLogoutUseCase:
                AuthLogoutUseCase(authRepository: authRepository),
            authGetUserUseCase:
                AuthGetUserUseCase(authRepository: authRepository),
            authIsLoggedInUseCase:
                AuthIsLoggedInUseCase(authRepository: authRepository),
            authOnAuthChangeUseCase:
                AuthOnAuthOnAuthChangeUseCase(authRepository: authRepository),
          ),
        ),
        ChangeNotifierProvider<OrderProvider>(
          create: (context) => OrderProvider(
              orderGetOrdersByDateUseCase: OrderGetOrdersByDateUseCase(
                  orderRepository: orderRepository)),
        ),
        ChangeNotifierProvider<FilterProvider>(
          create: (context) => FilterProvider(),
        ),
        ChangeNotifierProvider<SortProvider>(
          create: (context) => SortProvider(),
        ),
        /*ChangeNotifierProvider<CategoryProvider>(
          create: (context) => CategoryProvider(
            categoryAddUseCase: CategoryAddUseCase(categoryRepository: categoryRepository),
            categoryGetCategoriesUseCase: CategoryGetCategoriesUseCase(categoryRepository: categoryRepository),
            categoryGetCategoryByIdUseCase: CategoryGetCategoryByIdUseCase(categoryRepository: categoryRepository),
            categoryUpdateCategoryUseCase: CategoryUpdateUseCase(categoryRepository: categoryRepository),
            categoryUploadImageUseCase: CategoryUploadImageUseCase(categoryRepository: categoryRepository),
            categoryGetSignedUrlUseCase: CategoryGetSignedUrlUseCase(categoryRepository: categoryRepository),
            categoryDeleteUseCase: CategoryDeleteUseCase(categoryRepository: categoryRepository),
          ),
        ),
        ChangeNotifierProvider<ProductProvider>(
          create: (context) => ProductProvider(
            productAddUseCase: ProductAddUseCase(productRepository: productRepository),
            productGetProductsUseCase: ProductGetProductsUseCase(productRepository: productRepository),
            productGetProductByIdUseCase: ProductGetProductByIdUseCase(productRepository: productRepository),
            productUpdateProductUseCase: ProductUpdateUseCase(productRepository: productRepository),
            productUploadImageUseCase: ProductUploadImageUseCase(productRepository: productRepository),
            productGetSignedUrlUseCase: ProductGetSignedUrlUseCase(productRepository: productRepository),
            productDeleteUseCase: ProductDeleteUseCase(productRepository: productRepository),
          ),
        ),
        ChangeNotifierProvider<UserProvider>(
          create: (context) => UserProvider(
            userAddUseCase: UserAddUseCase(userRepository: userRepository),
            userGetUsersUseCase: UserGetUsersUseCase(userRepository: userRepository),
            userGetUserByIdUseCase: UserGetUserByIdUseCase(userRepository: userRepository),
            userUpdateUserUseCase: UserUpdateUseCase(userRepository: userRepository),
            userDeleteUseCase: UserDeleteUseCase(userRepository: userRepository),
          ),
        ),
        ChangeNotifierProvider<HomeProvider>(
          create: (context) => HomeProvider(),
        ),*/
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  GoRouter router = RouterHelper().getRouter();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp.router(
      title: 'Cooker App',
      debugShowCheckedModeBanner: false,
      theme: LightTheme.themeData,
      routerDelegate: router.routerDelegate,
      routeInformationProvider: router.routeInformationProvider,
      routeInformationParser: router.routeInformationParser,
      defaultTransition: Transition.rightToLeftWithFade,

      /* routingCallback: (routing) {
        print('route: ${routing?.current}');

        if (routing?.current == '/login') {
          if (context.read<AuthProvider>().checkIsLoggedIn()) {
            routing?.current = '/home';
          }
        } else {
          if (!context.read<AuthProvider>().checkIsLoggedIn()) {
            routing?.current = '/login';
          }
        }
      },*/
      /*getPages: Routes().getPages,
      initialRoute: '/login',
      home: StreamBuilder<AuthState>(
        stream: context.read<AuthProvider>().onAuthStateChange(),
        builder: (context, snapshot) {
          print('snapshot: ${snapshot.connectionState}');
          if (snapshot.connectionState == ConnectionState.active) {
            final user = snapshot.data;
            if (user == null) {
              return SignInScreen();
            } else {
              return const HomeScreen();
            }
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),*/
    );
  }
}
