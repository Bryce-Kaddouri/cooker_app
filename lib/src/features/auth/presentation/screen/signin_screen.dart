import 'package:cooker_app/src/core/constant/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
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

class _SignInScreenState extends State<SignInScreen>
    with SingleTickerProviderStateMixin {
  // global key for the form
  final _formKey = GlobalKey<FormBuilderState>();
  late AnimationController _controller;

  final double ballSize = 200.0;
  final double screenWidth = 400.0; // Adjust as needed
  final double screenHeight = 600.0; // Adjust as needed
  final double initialVelocity = 200.0; // Adjust as needed

  late Offset position = Offset(size.width / 2 - ballSize / 2, 0);
  int step = 0;
  bool isReverse = false;
  List<Color> colors = [Colors.blue, Colors.red, Colors.green, Colors.yellow];

  Size get size => MediaQuery.of(context).size;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
      lowerBound: 0,
      upperBound: 100,
    );

    // add post frame call back
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        _controller.addListener(() {
          print(_controller.value);
          if (step == 0) {
            double newDy = ((size.height / 2) - (ballSize / 2)) / 100;
            double newDx = ((size.width / 2) - (ballSize / 2)) / 100;
            print('newDx: $newDx');
            print('newDy: $newDy');
            print('position.dx: ${position.dx}');
            print('position.dy: ${position.dy}');
            setState(() {
              position = Offset(
                  (size.width / 2 - ballSize / 2) - (newDx * _controller.value),
                  newDy * _controller.value);
            });
          } else if (step == 1) {
            print('step 1');
            double newDy = ((size.height / 2) - (ballSize / 2)) / 100;
            double newDx = ((size.width / 2) - (ballSize / 2)) / 100;
            print('newDx: $newDx');
            print('newDy: $newDy');
            print('position.dx: ${position.dx}');
            print('position.dy: ${position.dy}');
            // double that start from 0 to 100
            double textX =
                (size.width / 2 - ballSize / 2) - (newDx * _controller.value);
            double testY = newDy * _controller.value;
            print('textX: $textX');
            setState(() {
              position = Offset(textX,
                  ((size.height) - (ballSize)) - (newDy * _controller.value));
            });
          } else if (step == 2) {
            print('step 2');
            double newDy = ((size.height / 2) - (ballSize / 2)) / 100;
            double newDx = ((size.width / 2) - (ballSize / 2)) / 100;
            print('newDx: $newDx');
            print('newDy: $newDy');
            print('position.dx: ${position.dx}');
            print('position.dy: ${position.dy}');
            // double that start from 0 to 100
            double textX =
                (size.width / 2 - ballSize / 2) + (newDx * _controller.value);
            double testY = newDy * _controller.value;
            print('textX: $textX');
            setState(() {
              position = Offset(
                  (size.width / 2 - ballSize / 2) + (newDx * _controller.value),
                  (size.height - ballSize) - newDy * _controller.value);
            });
          } else if (step == 3) {
            print('step 3');
            double newDy = ((size.height / 2) - (ballSize / 2)) / 100;
            double newDx = ((size.width / 2) - (ballSize / 2)) / 100;
            print('newDx: $newDx');
            print('newDy: $newDy');
            print('position.dx: ${position.dx}');
            print('position.dy: ${position.dy}');
            // double that start from 0 to 100
            double textX =
                (size.width / 2 - ballSize / 2) - (newDx * _controller.value);
            double testY = newDy * _controller.value;
            print('textX: $textX');
            setState(() {
              position = Offset(
                  (size.width / 2 - ballSize / 2) + (newDx * _controller.value),
                  newDy * _controller.value);
            });
          }
        });
        _controller.forward();
        _controller.addStatusListener((status) {
          print('status: $status');
          if (status == AnimationStatus.completed) {
            setState(() {
              step++;
            });
            _controller.reverse();
          } else if (status == AnimationStatus.dismissed) {
            if (step == 3) {
              setState(() {
                step = 0;
              });
            } else {
              setState(() {
                step++;
              });
            }
            _controller.forward();
          }
        });
      }
    });

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
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Stack(
          children: [
            Positioned(
              left: position.dx,
              top: position.dy,
              child: Container(
                width: ballSize,
                height: ballSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors[step], // Change color as desired
                ),
              ),
            ),
            Positioned(
              left: ((size.width) - (ballSize)) - position.dx,
              top: ((size.height) - (ballSize)) - position.dy,
              child: Container(
                width: ballSize,
                height: ballSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors[step], // Change color as desired
                ),
              ),
            ),
            Container(
              color: Colors.transparent,
              padding:
                  const EdgeInsets.symmetric(vertical: 40, horizontal: 200),
              alignment: Alignment.center,
              child: Card(
                elevation: 10,
                color: Colors.white.withOpacity(0.2),
                child: Container(
                  padding: const EdgeInsets.all(100),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.4),
                        Colors.white.withOpacity(0.1),
                      ],
                    ),
                  ),
                  child: FormBuilder(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          child: Column(
                            children: [
                              Text(
                                'Sign In',
                                style: TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Sign in to your account',
                                style: AppTextStyle.lightTextStyle(
                                  fontSize: 20,
                                  color: AppColor.lightBlackTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Column(children: [
                            FormBuilderTextField(
                              name: 'email',
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                prefixIcon: Icon(Icons.email),
                              ),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                                FormBuilderValidators.email(),
                              ]),
                            ),
                            const SizedBox(height: 10),
                            FormBuilderTextField(
                              name: 'password',
                              decoration: const InputDecoration(
                                labelText: 'Password',
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                prefixIcon: Icon(Icons.lock),
                              ),
                              obscureText: true,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                              ]),
                            ),
                          ]),
                        ),
                        MaterialButton(
                          color: Theme.of(context).colorScheme.secondary,
                          onPressed: () {
                            // Validate and save the form values
                            if (_formKey.currentState!.saveAndValidate()) {
                              debugPrint(
                                  _formKey.currentState?.value.toString());
                              context
                                  .read<AuthProvider>()
                                  .login(
                                    _formKey.currentState?.value['email'],
                                    _formKey.currentState?.value['password'],
                                  )
                                  .then((value) {
                                if (value) {
                                  context.goNamed('orders', pathParameters: {
                                    'date': DateHelper.getFormattedDate(
                                        DateTime.now()),
                                  });
                                } else {
                                  Get.snackbar(
                                    'Error',
                                    context
                                        .read<AuthProvider>()
                                        .loginErrorMessage!,
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
                          minWidth: double.infinity,
                          height: 50,
                          child: context.watch<AuthProvider>().isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  'Sign In',
                                  style: TextStyle(color: Colors.white),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
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
