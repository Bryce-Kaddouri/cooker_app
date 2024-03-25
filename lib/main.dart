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
import 'package:cooker_app/src/features/customer/business/repository/customer_repository.dart';
import 'package:cooker_app/src/features/customer/business/usecase/customer_get_customer_by_id_usecase.dart';
import 'package:cooker_app/src/features/customer/business/usecase/customer_get_customers_usecase.dart';
import 'package:cooker_app/src/features/customer/data/datasource/customer_datasource.dart';
import 'package:cooker_app/src/features/customer/data/repository/customer_repository_impl.dart';
import 'package:cooker_app/src/features/customer/presentation/provider/customer_provider.dart';
import 'package:cooker_app/src/features/order/business/repository/order_repository.dart';
import 'package:cooker_app/src/features/order/business/usecase/change_is_done_cart_by_id_usecase.dart';
import 'package:cooker_app/src/features/order/business/usecase/change_status_order_by_id_usecase.dart';
import 'package:cooker_app/src/features/order/business/usecase/order_get_order_by_id_usecase.dart';
import 'package:cooker_app/src/features/order/business/usecase/order_get_orders_by_date_usecase.dart';
import 'package:cooker_app/src/features/order/data/datasource/order_datasource.dart';
import 'package:cooker_app/src/features/order/data/repository/order_repository_impl.dart';
import 'package:cooker_app/src/features/order/presentation/provider/filter_provider.dart';
import 'package:cooker_app/src/features/order/presentation/provider/order_provider.dart';
import 'package:cooker_app/src/features/order/presentation/provider/sort_provider.dart';
import 'package:cooker_app/src/features/product/business/repository/product_repository.dart';
import 'package:cooker_app/src/features/product/business/usecase/product_get_product_by_id_usecase.dart';
import 'package:cooker_app/src/features/product/business/usecase/product_get_products_usecase.dart';
import 'package:cooker_app/src/features/product/business/usecase/product_get_signed_url_usecase.dart';
import 'package:cooker_app/src/features/product/data/datasource/product_datasource.dart';
import 'package:cooker_app/src/features/product/data/repository/product_repository_impl.dart';
import 'package:cooker_app/src/features/product/presentation/provider/product_provider.dart';
import 'package:cooker_app/src/features/setting/presentation/setting_provider.dart';
import 'package:cooker_app/src/features/status/business/repository/status_repository.dart';
import 'package:cooker_app/src/features/status/business/usecase/status_get_all_status_usecase.dart';
import 'package:cooker_app/src/features/status/data/datasource/status_datasource.dart';
import 'package:cooker_app/src/features/status/data/repository/status_repository_impl.dart';
import 'package:cooker_app/src/features/status/presentation/provider/status_provider.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  usePathUrlStrategy();

  await Supabase.initialize(
    url: 'https://qlhzemdpzbonyqdecfxn.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFsaHplbWRwemJvbnlxZGVjZnhuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDQ4ODY4MDYsImV4cCI6MjAyMDQ2MjgwNn0.lcUJMI3dvMDT7LaO7MiudIkdxAZOZwF_hNtkQtF3OC8',
  );

  final supabaseAdmin = SupabaseClient('https://qlhzemdpzbonyqdecfxn.supabase.co', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFsaHplbWRwemJvbnlxZGVjZnhuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDQ4ODY4MDYsImV4cCI6MjAyMDQ2MjgwNn0.lcUJMI3dvMDT7LaO7MiudIkdxAZOZwF_hNtkQtF3OC8');
  final supabaseClient = Supabase.instance;
  AuthRepository authRepository = AuthRepositoryImpl(dataSource: AuthDataSource());
  OrderRepository orderRepository = OrderRepositoryImpl(orderDataSource: OrderDataSource());
  StatusRepository statusRepository = StatusRepositoryImpl(dataSource: StatusDataSource());
  CustomerRepository customerRepository = CustomerRepositoryImpl(dataSource: CustomerDataSource());
  ProductRepository productRepository = ProductRepositoryImpl(dataSource: ProductDataSource());
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
            authLogoutUseCase: AuthLogoutUseCase(authRepository: authRepository),
            authGetUserUseCase: AuthGetUserUseCase(authRepository: authRepository),
            authIsLoggedInUseCase: AuthIsLoggedInUseCase(authRepository: authRepository),
            authOnAuthChangeUseCase: AuthOnAuthOnAuthChangeUseCase(authRepository: authRepository),
          ),
        ),
        ChangeNotifierProvider<OrderProvider>(
          create: (context) => OrderProvider(
            orderGetOrdersByDateUseCase: OrderGetOrdersByDateUseCase(orderRepository: orderRepository),
            orderGetOrdersByIdUseCase: OrderGetOrderByIdUseCase(orderRepository: orderRepository),
            changeStatusOrderByIdUseCase: OrderChangeStatusOrderByIdUseCase(orderRepository: orderRepository),
            changeIsDoneCartByIdUseCase: OrderChangeIsDoneCartByIdUseCase(orderRepository: orderRepository),
          ),
        ),
        ChangeNotifierProvider<FilterProvider>(
          create: (context) => FilterProvider(),
        ),
        ChangeNotifierProvider<SortProvider>(
          create: (context) => SortProvider(),
        ),
        ChangeNotifierProvider<SettingProvider>(
          create: (context) => SettingProvider(),
        ),
        ChangeNotifierProvider<StatusProvider>(
          create: (context) => StatusProvider(statusGetAllStatusUseCase: StatusGetAllStatusUseCase(statusRepository: statusRepository)),
        ),
        ChangeNotifierProvider<CustomerProvider>(
          create: (context) => CustomerProvider(
            customerGetCustomersUseCase: CustomerGetCustomersUseCase(customerRepository: customerRepository),
            customerGetCustomersByIdUseCase: CustomerGetCustomerByIdUseCase(customerRepository: customerRepository),
          ),
        ),
        ChangeNotifierProvider<ProductProvider>(
          create: (context) => ProductProvider(
            productGetProductsUseCase: ProductGetProductsUseCase(productRepository: productRepository),
            productGetProductByIdUseCase: ProductGetProductByIdUseCase(productRepository: productRepository),
            productGetSignedUrlUseCase: ProductGetSignedUrlUseCase(productRepository: productRepository),
          ),
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
  GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    context.read<SettingProvider>().initTheme();
  }

  @override
  Widget build(BuildContext context) {
    return FluentApp.router(
      key: _scaffoldMessengerKey,
      title: 'Cooker App',
      debugShowCheckedModeBanner: false,
      theme: FluentThemeData.light(),

      /*ThemeData.light().copyWith(
        drawerTheme: DrawerThemeData(
          elevation: 0,
          backgroundColor: AppColor.lightBackgroundColor,
        ),
        scaffoldBackgroundColor: AppColor.lightBackgroundColor,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColor.lightBackgroundColor,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColor.lightBlackTextColor),
          surfaceTintColor: AppColor.lightBackgroundColor,
          shadowColor: AppColor.lightBackgroundColor,
        ),
        datePickerTheme: DatePickerThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: AppColor.lightBlackTextColor,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
            backgroundColor: AppColor.lightCardColor,
            headerBackgroundColor: AppColor.lightBackgroundColor,
            cancelButtonStyle: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(
                AppColor.lightBlackTextColor,
              ),
            ),

            dayStyle: AppTextStyle.lightTextStyle(
              color: AppColor.lightBlackTextColor,
            ),
            weekdayStyle: AppTextStyle.lightTextStyle(
              color: AppColor.lightBlackTextColor,
            ),
            dayForegroundColor: MaterialStateProperty.all(
              AppColor.lightBlackTextColor,
            ),
            todayBorder: BorderSide(
              color: AppColor.lightBlackTextColor,
            ),
          todayForegroundColor: MaterialStateProperty.all(
            AppColor.lightBlackTextColor,
          ),
            confirmButtonStyle: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(
                AppColor.lightBlackTextColor,
              ),
            ),
          inputDecorationTheme: InputDecorationTheme(
            labelStyle: AppTextStyle.lightTextStyle(
              color: AppColor.lightBlackTextColor,
            ),
            hintStyle: AppTextStyle.lightTextStyle(
              color: AppColor.lightBlackTextColor,
            ),
            focusColor: AppColor.lightBlackTextColor,
            hoverColor: AppColor.lightBlackTextColor,
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColor.lightBlackTextColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColor.lightBlackTextColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColor.lightBlackTextColor,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColor.canceledForegroundColor,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColor.canceledForegroundColor,
              ),
            ),

          ),
        ),
        iconTheme: IconThemeData(color: AppColor.lightBlackTextColor),
        iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
            foregroundColor:
                MaterialStateProperty.all(AppColor.lightBlackTextColor),
          ),
        ),
        textTheme: TextTheme(
          bodySmall: AppTextStyle.lightTextStyle(
            color: AppColor.lightBlackTextColor,
          ),
          bodyMedium: AppTextStyle.regularTextStyle(
            color: AppColor.lightBlackTextColor,
          ),
          bodyLarge: AppTextStyle.boldTextStyle(
            color: AppColor.lightBlackTextColor,
          ),
        ),
        primaryColor: AppColor.lightBackgroundColor,
        cardColor: AppColor.lightCardColor,
        colorScheme: ColorScheme.light(
          primary: AppColor.lightBackgroundColor,
          secondary: AppColor.lightBlackTextColor,
        ),
      ),*/
      themeMode: context.watch<SettingProvider>().isDarkMode ? ThemeMode.dark : ThemeMode.light,
      darkTheme: FluentThemeData.dark(),

      /*ThemeData.dark().copyWith(

        searchViewTheme: SearchViewThemeData(
          backgroundColor: AppColor.darkCardColor,
          dividerColor: AppColor.darkWhiteTextColor,
          elevation: 2,
          headerHintStyle: AppTextStyle.lightTextStyle(
            color: AppColor.darkWhiteTextColor,
          ),
          headerTextStyle: AppTextStyle.lightTextStyle(
            color: AppColor.darkWhiteTextColor,
          ),
        ),
        drawerTheme: DrawerThemeData(
          elevation: 12,
          shadowColor: AppColor.darkWhiteTextColor,
          backgroundColor: AppColor.darkCardColor,
          scrimColor: AppColor.darkBackgroundColor.withOpacity(0.5),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.all(AppColor.darkBackgroundColor),
          checkColor: MaterialStateProperty.all(AppColor.darkWhiteTextColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: BorderSide(
              width: 2,
              color: AppColor.darkWhiteTextColor,
            ),
          ),
        ),
        scaffoldBackgroundColor: AppColor.darkBackgroundColor,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColor.darkBackgroundColor,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColor.darkWhiteTextColor),
          surfaceTintColor: AppColor.darkBackgroundColor,
          shadowColor: AppColor.darkBackgroundColor,
        ),

        menuBarTheme: MenuBarThemeData(
          style: MenuStyle(
            backgroundColor: MaterialStateProperty.all(
              AppColor.darkCardColor,
            ),

          )
        ),
        datePickerTheme: DatePickerThemeData(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: AppColor.darkWhiteTextColor,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 2,
          backgroundColor: AppColor.darkCardColor,
          surfaceTintColor: AppColor.darkBackgroundColor,
          headerBackgroundColor: AppColor.darkBackgroundColor,
          cancelButtonStyle: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(
              AppColor.darkWhiteTextColor,
            ),
          ),


          headerForegroundColor: AppColor.darkWhiteTextColor,


          yearBackgroundColor: MaterialStateProperty.all(
            AppColor.darkCardColor,
          ),
          yearForegroundColor: MaterialStateProperty.all(
            AppColor.darkWhiteTextColor,
          ),
          yearStyle: AppTextStyle.lightTextStyle(
            color: AppColor.darkWhiteTextColor,
          ),
          rangePickerSurfaceTintColor: AppColor.darkBackgroundColor,

          dayStyle: AppTextStyle.lightTextStyle(
            color: AppColor.darkWhiteTextColor,
          ),
          weekdayStyle: AppTextStyle.lightTextStyle(
            color: AppColor.darkWhiteTextColor,
          ),
          dayForegroundColor: MaterialStateProperty.all(
            AppColor.darkWhiteTextColor,
          ),

          todayBorder: BorderSide(
            color: AppColor.darkWhiteTextColor,
          ),
          todayForegroundColor: MaterialStateProperty.all(
            AppColor.darkWhiteTextColor,
          ),

          confirmButtonStyle: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(
              AppColor.darkWhiteTextColor,
            ),
          ),


          inputDecorationTheme: InputDecorationTheme(

            labelStyle: AppTextStyle.lightTextStyle(
              color: AppColor.darkWhiteTextColor,
            ),
            hintStyle: AppTextStyle.lightTextStyle(
              color: AppColor.darkWhiteTextColor,
            ),
            focusColor: AppColor.darkWhiteTextColor,
            hoverColor: AppColor.darkWhiteTextColor,


            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColor.darkWhiteTextColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColor.darkWhiteTextColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColor.darkWhiteTextColor,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColor.canceledForegroundColor,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColor.canceledForegroundColor,
              ),
            ),

          ),


        ),
        iconTheme: IconThemeData(color: AppColor.darkWhiteTextColor),
        iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
            foregroundColor:
                MaterialStateProperty.all(AppColor.darkWhiteTextColor),
          ),
        ),
        textTheme: TextTheme(
          bodySmall: AppTextStyle.lightTextStyle(
            color: AppColor.darkWhiteTextColor,
          ),
          bodyMedium: AppTextStyle.regularTextStyle(
            color: AppColor.darkWhiteTextColor,
          ),
          bodyLarge: AppTextStyle.boldTextStyle(
            color: AppColor.darkWhiteTextColor,
          ),
        ),
        primaryColor: AppColor.darkBackgroundColor,
        cardColor: AppColor.darkCardColor,
        colorScheme: ColorScheme.light(
          primary: AppColor.darkBackgroundColor,
          secondary: AppColor.darkWhiteTextColor,
        ),
      ),*/

      routerDelegate: router.routerDelegate,
      routeInformationProvider: router.routeInformationProvider,
      routeInformationParser: router.routeInformationParser,
    );
  }
}
