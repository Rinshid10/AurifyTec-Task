import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../app/theme.dart';
import '../../../core/utils/formatters.dart';
import '../controllers/categories_controller.dart';
import '../controllers/product_list_controller.dart';
import '../data/product_sort.dart';
import 'category_chips.dart';

//  <--------- Filter Sheet Widget --------->
//* TO show the bottom sheet for sort order and category where changes apply immediately
class FilterSheet extends StatelessWidget {
  const FilterSheet({super.key, required this.list});

  //  <--------- Fields --------->
  final ProductListController list;

  //  <--------- Show --------->
  //* TO open the sheet over the current route
  static Future<void> show(ProductListController list) {
    return Get.bottomSheet<void>(
      FilterSheet(list: list),
      isScrollControlled: true,
      backgroundColor: Get.theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
    );
  }

  //  <--------- Build --------->
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final categories = Get.find<CategoriesController>();

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Obx(
          () => ListView(
            controller: scrollController,
            padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
            children: [
              //!  <--------- Header And Reset Section --------->
              //* TO show the title and a Reset button enabled only when a filter is active
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Sort & filter',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w800,
                        color: c.ink,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: list.hasActiveFilter ? list.resetFilters : null,
                    child: const Text('Reset'),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              //  <--------- Sort Section --------->
              _Label('Sort by'),
              SizedBox(height: 10.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: [
                  for (final sort in ProductSort.values)
                    ChoiceChip(
                      label: Text(sort.label),
                      selected: list.sort.value == sort,
                      showCheckmark: false,
                      onSelected: (_) => list.setSort(sort),
                    ),
                ],
              ),
              SizedBox(height: 24.h),
              //  <--------- Category Section --------->
              _Label('Category'),
              SizedBox(height: 10.h),
              categories.categories.value.when(
                loading: () => Padding(
                  padding: EdgeInsets.all(16.r),
                  child: const Center(child: CircularProgressIndicator()),
                ),
                error: (_) => Text(
                  'Categories are unavailable right now.',
                  style: TextStyle(color: c.brown),
                ),
                data: (slugs) => Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: [
                    ChoiceChip(
                      label: const Text('All'),
                      selected: list.category.value == null,
                      showCheckmark: false,
                      onSelected: (_) => list.setCategory(null),
                    ),
                    for (final slug in slugs)
                      ChoiceChip(
                        label: Text(
                          '${CategoryChips.emojiFor(slug)} '
                          '${Formatters.categoryLabel(slug)}',
                        ),
                        selected: list.category.value == slug,
                        showCheckmark: false,
                        onSelected: (_) => list.setCategory(
                          list.category.value == slug ? null : slug,
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              //  <--------- Show Results Section --------->
              FilledButton(
                onPressed: Get.back,
                child: const Text('Show results'),
              ),
            ],
          ),
        );
      },
    );
  }
}

//  <--------- Label Widget --------->
//* TO paint a section label inside the sheet
class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: context.colors.brown,
      ),
    );
  }
}
