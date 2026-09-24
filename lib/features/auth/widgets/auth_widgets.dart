import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/theme.dart';

//  <--------- Auth Scaffold --------->
//* TO lay out an auth screen as a centred column on a plain background with a faint corner shape
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({super.key, required this.children});

  final List<Widget> children;

  //  <--------- Build --------->
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: context.isDark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: Stack(
          children: [
            //  <--------- Decoration Section --------->
            Positioned(
              top: -140.h,
              right: -120.w,
              child: IgnorePointer(
                child: Container(
                  width: 320.r,
                  height: 320.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: c.tintSoft,
                  ),
                ),
              ),
            ),
            //  <--------- Content Section --------->
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 28.w,
                    vertical: 24.h,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: math.max(0, constraints.maxHeight - 48.h),
                    ),
                    child: AutofillGroup(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: children,
                      ),
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

//  <--------- Auth Title --------->
//* TO show the blue heading and the bold centred subtitle
class AuthTitle extends StatelessWidget {
  const AuthTitle({super.key, required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30.sp,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
            color: c.accent,
          ),
        ),
        SizedBox(height: 12.h),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 280.w),
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: c.ink,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

//  <--------- Auth Field Widget --------->
//* TO show a filled input whose outline turns blue on focus and red on error
class AuthField extends StatefulWidget {
  const AuthField({
    super.key,
    required this.hint,
    required this.controller,
    this.obscure = false,
    this.onToggleObscure,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.errorText,
    this.onSubmitted,
    this.enabled = true,
  });

  //  <--------- Fields --------->
  final String hint;
  final TextEditingController controller;
  final bool obscure;
  final VoidCallback? onToggleObscure;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<String>? autofillHints;
  final String? errorText;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;

  @override
  State<AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<AuthField> {
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  //  <--------- Build --------->
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final hasError = widget.errorText != null;
    final focused = _focus.hasFocus;
    final borderColor = hasError
        ? c.danger
        : focused
        ? c.accent
        : Colors.transparent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //  <--------- Input Section --------->
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: c.tint,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: borderColor, width: 2),
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _focus,
            enabled: widget.enabled,
            obscureText: widget.obscure,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            autofillHints: widget.autofillHints,
            onSubmitted: widget.onSubmitted,
            autocorrect: false,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: c.ink,
            ),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: c.brownMuted,
              ),
              filled: false,
              isDense: true,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 15.w,
                vertical: 15.h,
              ),
              //  <--------- Visibility Toggle --------->
              suffixIcon: widget.onToggleObscure == null
                  ? null
                  : IconButton(
                      tooltip: widget.obscure
                          ? 'Show password'
                          : 'Hide password',
                      onPressed: widget.onToggleObscure,
                      iconSize: 20.r,
                      icon: Icon(
                        widget.obscure
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: c.brownMuted,
                      ),
                    ),
            ),
          ),
        ),
        //!  <--------- Error Text --------->
        if (hasError)
          Padding(
            padding: EdgeInsets.only(top: 6.h, left: 4.w),
            child: Text(
              widget.errorText!,
              style: TextStyle(fontSize: 12.sp, color: c.danger),
            ),
          ),
      ],
    );
  }
}

//  <--------- Auth Primary Button --------->
//* TO show the solid blue call-to-action with a loading spinner while submitting
class AuthPrimaryButton extends StatelessWidget {
  const AuthPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return SizedBox(
      height: 58.h,
      child: FilledButton(
        onPressed: loading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: c.accent,
          foregroundColor: Colors.white,
          disabledBackgroundColor: c.accent.withValues(alpha: 0.7),
          disabledForegroundColor: Colors.white,
          elevation: 6,
          shadowColor: c.accent.withValues(alpha: 0.45),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          textStyle: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
        ),
        child: loading
            ? SizedBox(
                width: 22.r,
                height: 22.r,
                child: const CircularProgressIndicator(
                  strokeWidth: 2.2,
                  color: Colors.white,
                ),
              )
            : Text(label),
      ),
    );
  }
}

//!  <--------- Auth Error Text --------->
//* TO show the repository error like wrong password or email already in use
class AuthErrorText extends StatelessWidget {
  const AuthErrorText({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w500,
          color: c.danger,
          height: 1.4,
        ),
      ),
    );
  }
}

//  <--------- Auth Text Link --------->
//* TO show a small tappable line like Create new account
class AuthTextLink extends StatelessWidget {
  const AuthTextLink({
    super.key,
    required this.label,
    required this.onTap,
    this.accent = false,
    this.align = Alignment.center,
  });

  final String label;
  final VoidCallback onTap;
  final bool accent;
  final Alignment align;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Align(
      alignment: align,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: accent ? c.accent : c.ink,
            ),
          ),
        ),
      ),
    );
  }
}
