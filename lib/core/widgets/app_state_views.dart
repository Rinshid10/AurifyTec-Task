import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//  <--------- App Loading View Widget --------->
//* TO show a centered progress indicator with an optional label
class AppLoadingView extends StatelessWidget {
  const AppLoadingView({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            SizedBox(height: 16.h),
            Text(message!, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }
}

//!  <--------- App Error View Widget --------->
//* TO show a friendly full-screen error with an optional retry action
class AppErrorView extends StatelessWidget {
  const AppErrorView({
    super.key,
    required this.message,
    this.onRetry,
    this.icon = Icons.cloud_off_outlined,
  });

  //  <--------- Fields --------->
  final String message;
  final VoidCallback? onRetry;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(32.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //  <--------- Icon And Headline --------->
            Icon(icon, size: 56.r, color: theme.colorScheme.error),
            SizedBox(height: 16.h),
            Text(
              'Something went wrong',
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            //  <--------- Message --------->
            SizedBox(height: 8.h),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            //  <--------- Retry Button --------->
            //* TO offer a retry only when a callback is supplied
            if (onRetry != null) ...[
              SizedBox(height: 24.h),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Try again'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

//  <--------- App Empty View Widget --------->
//* TO show an empty-state placeholder for no results, no favorites and similar cases
class AppEmptyView extends StatelessWidget {
  const AppEmptyView({
    super.key,
    required this.title,
    this.subtitle,
    this.icon = Icons.inbox_outlined,
    this.action,
  });

  //  <--------- Fields --------->
  final String title;
  final String? subtitle;
  final IconData icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(32.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //  <--------- Icon And Title --------->
            Icon(icon, size: 64.r, color: theme.colorScheme.outline),
            SizedBox(height: 16.h),
            Text(
              title,
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            //  <--------- Subtitle --------->
            if (subtitle != null) ...[
              SizedBox(height: 8.h),
              Text(
                subtitle!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            //  <--------- Action --------->
            if (action != null) ...[SizedBox(height: 24.h), action!],
          ],
        ),
      ),
    );
  }
}

//!  <--------- Inline Error Row Widget --------->
//* TO show a compact one-line error with a retry button for sections that should not take over the whole screen
class InlineErrorRow extends StatelessWidget {
  const InlineErrorRow({
    super.key,
    required this.message,
    required this.onRetry,
    this.padding,
  });

  //  <--------- Fields --------->
  final String message;
  final VoidCallback onRetry;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Padding(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w),
      //  <--------- Error Card --------->
      //* TO mirror the full-page error view at section size: same icon, message and Try again button
      child: Container(
        padding: EdgeInsets.fromLTRB(16.w, 14.h, 12.w, 14.h),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: scheme.outline),
        ),
        child: Row(
          children: [
            Icon(Icons.cloud_off_outlined, size: 22.r, color: scheme.error),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Something went wrong',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    message,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            FilledButton.tonalIcon(
              onPressed: onRetry,
              icon: Icon(Icons.refresh, size: 16.r),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}

//  <--------- Inline Loading Widget --------->
//* TO show a centered spinner sized for an inline section rather than a full page
class InlineLoading extends StatelessWidget {
  const InlineLoading({super.key, this.padding});

  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.all(24.r),
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}
