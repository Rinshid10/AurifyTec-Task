import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes.dart';
import '../controllers/login_form_controller.dart';
import '../widgets/auth_widgets.dart';

//  <--------- Login View --------->
//* TO sign in with email and password on a simple centred layout
class LoginView extends GetView<LoginFormController> {
  const LoginView({super.key});

  //  <--------- Build --------->
  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      children: [
        //  <--------- Title Section --------->
        const AuthTitle(
          title: 'Login here',
          subtitle: "Welcome back you've been missed!",
        ),
        const SizedBox(height: 48),
        //  <--------- Form Section --------->
        //* TO rebuild the fields when loading or any error changes
        Obx(() {
          final loading = controller.loading.value;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //!  <--------- Form Error --------->
              if (controller.formError.value != null)
                AuthErrorText(message: controller.formError.value!),
              //  <--------- Email Field --------->
              AuthField(
                hint: 'Email',
                controller: controller.email,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                errorText: controller.emailError.value,
                enabled: !loading,
              ),
              const SizedBox(height: 20),
              //  <--------- Password Field --------->
              AuthField(
                hint: 'Password',
                controller: controller.password,
                obscure: controller.obscurePassword.value,
                onToggleObscure: controller.togglePasswordVisibility,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.password],
                errorText: controller.passwordError.value,
                onSubmitted: (_) => controller.submit(),
                enabled: !loading,
              ),
              const SizedBox(height: 30),
              //  <--------- Submit Section --------->
              AuthPrimaryButton(
                label: 'Sign in',
                loading: loading,
                onPressed: controller.submit,
              ),
            ],
          );
        }),
        const SizedBox(height: 22),
        //  <--------- Create Account Link --------->
        AuthTextLink(
          label: 'Create new account',
          onTap: () => Get.toNamed(AppRoutes.register),
        ),
      ],
    );
  }
}
