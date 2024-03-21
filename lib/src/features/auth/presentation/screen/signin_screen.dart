import 'package:cooker_app/src/core/helper/responsive_helper.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constant/app_color.dart';
import '../../../../core/helper/date_helper.dart';
import '../provider/auth_provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // global key for the form
  final _formKey = GlobalKey<FormState>();
  // controller for email field
  final TextEditingController emailController = TextEditingController();
  // controller for password field
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // )..addListener(() {
    //   setState(() {
    //     position += velocity * _controller.value;
    //     if (position.dx < 0 || position.dx > screenWidth ) {
    //       // Reverse the horizontal velocity upon hitting the wall
    //       velocity = Offset(-velocity.dx, velocity.dy);
    //     }
    //     if (position.dy < 0 || position.dy > screenHeight) {
    //       // Reverse the vertical velocity upon hitting the wall
    //       velocity = Offset(velocity.dx, -velocity.dy);
    //     }
    //   });
    // });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fluent.FluentTheme.of(context).navigationPaneTheme.backgroundColor,
      appBar: AppBar(
        elevation: 4,
        shadowColor: fluent.FluentTheme.of(context).shadowColor,
        surfaceTintColor: fluent.FluentTheme.of(context).navigationPaneTheme.backgroundColor,
        backgroundColor: fluent.FluentTheme.of(context).navigationPaneTheme.backgroundColor,
        centerTitle: true,
        title: Text('Sign In'),
      ),
      body: Container(
        child: Container(
          padding: !ResponsiveHelper.isMobile(context) ? const EdgeInsets.symmetric(vertical: 40, horizontal: 200) : EdgeInsets.all(20),
          alignment: Alignment.center,
          child: fluent.Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  child: Column(
                    children: [
                      Text(
                        'Sign in to your account',
                        style: /*AppTextStyle.lightTextStyle(
                                  fontSize: 20,
                                  color: AppColor.lightBlackTextColor,
                                ),*/
                            Theme.of(context).textTheme.bodySmall!.copyWith(
                                  fontSize: 20,
                                ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Column(children: [
                    fluent.TextFormBox(
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: AppColor.lightBlackTextColor,
                          ),
                      showCursor: true,
                      cursorColor: AppColor.lightBlackTextColor,
                      placeholder: 'email',
                      controller: emailController,
                      prefix: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                        child: fluent.Icon(
                          fluent.FluentIcons.mail,
                        ),
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.email(),
                      ]),
                    ),
                    const SizedBox(height: 20),
                    fluent.PasswordFormBox(
                      leadingIcon: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                        child: fluent.Icon(
                          fluent.FluentIcons.lock,
                        ),
                      ),
                      controller: passwordController,
                      showCursor: true,
                      cursorColor: AppColor.lightBlackTextColor,
                      placeholder: 'password',
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                    ),
                  ]),
                ),
                Container(
                  height: 50,
                  width: double.infinity,
                  child: fluent.FilledButton(
                    onPressed: () {
                      // Validate and save the form values
                      if (_formKey.currentState!.validate()) {
                        String email = emailController.text;
                        String password = passwordController.text;
                        context
                            .read<AuthProvider>()
                            .login(
                              email,
                              password,
                            )
                            .then((value) {
                          if (value) {
                            context.goNamed('orders', pathParameters: {
                              'date': DateHelper.getFormattedDate(DateTime.now()),
                            });
                          } else {
                            Get.snackbar(
                              'Error',
                              context.read<AuthProvider>().loginErrorMessage!,
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                              margin: const EdgeInsets.all(10),
                              padding: const EdgeInsets.all(10),
                              snackPosition: SnackPosition.TOP,
                              duration: const Duration(seconds: 3),
                              icon: const Icon(
                                Icons.error_outline,
                                color: Colors.white,
                              ),
                              isDismissible: true,
                              forwardAnimationCurve: Curves.easeOutBack,
                              reverseAnimationCurve: Curves.easeInBack,
                              onTap: (value) => Get.back(),
                              mainButton: TextButton(
                                onPressed: () => Get.back(),
                                child: const Text(
                                  'OK',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          }
                        });
                      }
                    },
                    child: context.watch<AuthProvider>().isLoading
                        ? const fluent.ProgressRing()
                        : const Text(
                            'Sign In',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BallTest {
  double radius;
  Color color;
  Offset position;

  BallTest({required this.radius, required this.color, required this.position});
}

/*
class Ball{
  Color color;
  double radius;
  Offset position;
  Offset velocity;

  Ball({required this.color, required this.radius, required this.position, this.velocity = Offset.zero});
}

class BallPainter extends CustomPainter{
  final Ball ball;

  BallPainter(this.ball);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = ball.color;
    canvas.drawCircle(ball.position, ball.radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}*/
