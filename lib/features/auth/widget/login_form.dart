import 'package:app_3k_padel/features/auth/screens/register_screen.dart';
import 'package:app_3k_padel/services/auth_service.dart';
import 'package:app_3k_padel/widgets/custom_button.dart';
import 'package:app_3k_padel/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginState();
}

class _LoginState extends State<LoginForm> {
  final GlobalKey<FormState> _loginForm = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  String? errorMessage;
  bool isLoadingLogin = false;

  @override
  void dispose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  String? Function(String?) validatorEmail = (String? value) {
    if (value == null || value.isEmpty) {
      return 'Introduce un email';
    }

    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value)) {
      return 'Introduce un email válido';
    }
    return null;
  };

  String? Function(String?) validatorPass = (String? value) {
    if (value == null || value.isEmpty) {
      return 'Introduce una contraseña';
    }
    return null;
  };

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 500;

    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: 500),
        decoration: BoxDecoration(
          border: Border.all(
            color: Color.fromARGB(255, 217, 221, 63),
            width: 3.0,
          ),
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        margin: EdgeInsets.all(isMobile ? 16 : 40),
        padding: EdgeInsets.all(isMobile ? 24 : 50),
        child: Form(
          key: _loginForm,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 30.0,
            children: [
              Text(
                "Inicia sesión",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20.0),
              ),
              CustomFormField(
                labelText: "Email",
                validator: validatorEmail,
                controller: emailCtrl,
              ),
              CustomFormField(
                labelText: "Contraseña",
                validator: validatorPass,
                obscureText: true,
                controller: passwordCtrl,
              ),

              //RECUPERAR CONTRASEÑA
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (dialogContext) {
                        final GlobalKey<FormState> formKey =
                            GlobalKey<FormState>();
                        final emailRecupCtrl = TextEditingController()
                          ..text = emailCtrl.text;

                        bool isLoadingRecover = false;

                        return StatefulBuilder(
                          builder: (context, setStateDialog) {
                            return AlertDialog(
                              title: Text("Recuperar contraseña"),
                              content: Form(
                                key: formKey,
                                child: CustomFormField(
                                  labelText: "Email",
                                  validator: validatorEmail,
                                  controller: emailRecupCtrl,
                                ),
                              ),
                              actionsAlignment: MainAxisAlignment.center,
                              actions: [
                                CustomButton(
                                  text: "Cancelar",
                                  isLoading: false,
                                  primary: false,
                                  onPressFunction: () {
                                    Navigator.pop(dialogContext);
                                  },
                                ),
                                CustomButton(
                                  text: "Enviar",
                                  isLoading: isLoadingRecover,
                                  primary: true,
                                  onPressFunction: () async {
                                    if (formKey.currentState?.validate() ??
                                        false) {
                                      setStateDialog(() {
                                        isLoadingRecover = true;
                                      });

                                      final email = emailRecupCtrl.text;

                                      try {
                                        await AuthService()
                                            .sendPasswordResetEmail(email);

                                        Navigator.pop(dialogContext);

                                        ScaffoldMessenger.of(
                                          this.context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Si el email es válido recibirás un correo.',
                                            ),
                                          ),
                                        );
                                      } on AuthException catch (e) {
                                        ScaffoldMessenger.of(
                                          this.context,
                                        ).showSnackBar(
                                          SnackBar(content: Text(e.message)),
                                        );
                                      } catch (e) {
                                        ScaffoldMessenger.of(
                                          this.context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text("Error inesperado"),
                                          ),
                                        );
                                      } finally {
                                        setStateDialog(() {
                                          isLoadingRecover = false;
                                        });
                                      }
                                    }
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                  child: Text(
                    "¿Olvidaste tu contraseña?",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12.0,
                      color: Color.fromARGB(255, 53, 95, 169),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),

              if (errorMessage != null && errorMessage!.isNotEmpty)
                Text(
                  errorMessage!,
                  style: TextStyle(color: Colors.red, fontSize: 13),
                  textAlign: TextAlign.center,
                ),

              isMobile
                  ? Column(
                      children: [
                        CustomButton(
                          text: "Iniciar sesión",
                          isLoading: isLoadingLogin,
                          primary: true,
                          onPressFunction: _login,
                        ),
                        SizedBox(height: 15),
                        CustomButton(
                          text: "Registrarme",
                          isLoading: isLoadingLogin,
                          primary: false,
                          onPressFunction: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 20,
                      children: [
                        SizedBox(
                          width: 150,
                          child: CustomButton(
                            text: "Iniciar sesión",
                            isLoading: isLoadingLogin,
                            primary: true,
                            onPressFunction: _login,
                          ),
                        ),
                        SizedBox(
                          width: 150,
                          child: CustomButton(
                            text: "Registrarme",
                            isLoading: isLoadingLogin,
                            primary: false,
                            onPressFunction: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegisterScreen(),
                                ),
                              );
                              _loginForm.currentState?.reset();
                              emailCtrl.clear();
                              passwordCtrl.clear();

                              setState(() {
                                errorMessage = null;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    if (_loginForm.currentState?.validate() ?? false) {
      setState(() {
        errorMessage = null;
        isLoadingLogin = true;
      });

      final email = emailCtrl.text;
      final password = passwordCtrl.text;

      try {
        await AuthService().login(email, password);
      } on AuthException catch (e) {
        setState(() {
          errorMessage = e.message;
        });
      } catch (e) {
        setState(() {
          errorMessage = "Error inesperado";
        });
      } finally {
        if (mounted) {
          setState(() {
            isLoadingLogin = false;
          });
        }
      }
    }
  }
}
