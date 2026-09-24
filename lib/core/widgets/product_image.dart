import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../app/theme.dart';

//  <--------- Product Image Widget --------->
//* TO load a network image with a placeholder while loading and a fallback icon on failure so a broken image never leaves a blank tile
class ProductImage extends StatelessWidget {
  const ProductImage({super.key, required this.url, this.fit = BoxFit.cover});

  final String url;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    //  <--------- Empty Url Guard --------->
    if (url.isEmpty) return _Fallback(color: c.muted);
    //  <--------- Cached Image --------->
    //* TO fade the image in and show a spinner or fallback while it is unavailable
    return CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      fadeInDuration: const Duration(milliseconds: 200),
      placeholder: (_, _) => Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2, color: c.muted),
        ),
      ),
      errorWidget: (_, _, _) => _Fallback(color: c.muted),
    );
  }
}

//  <--------- Fallback Widget --------->
//* TO show a centered broken-image icon when the picture cannot be displayed
class _Fallback extends StatelessWidget {
  const _Fallback({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(Icons.image_not_supported_outlined, size: 32, color: color),
    );
  }
}
