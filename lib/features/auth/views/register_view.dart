import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/register_form_controller.dart';
import '../widgets/auth_widgets.dart';

//  <--------- Register View --------->
//* TO create an on-device account on the same simple centred layout as login
class RegisterView extends GetView<RegisterFormController> {
  const RegisterView({super.key});

  //  <--------- Build --------->
  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      children: [
        //  <--------- Title Section --------->
        const AuthTitle(
          title: 'Create Account',
          subtitle: 'Create an account so you can explore all the products',
        ),
        SizedBox(height: 40.h),
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
              //  <--------- Name Field --------->
              AuthField(
                hint: 'Full name',
                controller: controller.name,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.name],
                errorText: controller.nameError.value,
                enabled: !loading,
              ),
              SizedBox(height: 20.h),
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
              SizedBox(height: 20.h),
              //  <--------- Password Field --------->
              AuthField(
                hint: 'Password',
                controller: controller.password,
                obscure: controller.obscurePassword.value,
                onToggleObscure: controller.togglePasswordVisibility,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.newPassword],
                errorText: controller.passwordError.value,
                enabled: !loading,
              ),
              SizedBox(height: 20.h),
              //  <--------- Confirm Password Field --------->
              AuthField(
                hint: 'Confirm Password',
                controller: controller.confirmPassword,
                obscure: controller.obscurePassword.value,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.newPassword],
                errorText: controller.confirmPasswordError.value,
                onSubmitted: (_) => controller.submit(),
                enabled: !loading,
              ),
              SizedBox(height: 30.h),
              //  <--------- Submit Section --------->
              AuthPrimaryButton(
                label: 'Sign up',
                loading: loading,
                onPressed: controller.submit,
              ),
            ],
          );
        }),
        SizedBox(height: 22.h),
        //  <--------- Sign In Link --------->
        AuthTextLink(label: 'Already have an account', onTap: Get.back),
      ],
    );
  }
}
