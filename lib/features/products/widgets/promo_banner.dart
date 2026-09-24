import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/pill.dart';

//  <--------- Promo Slide Model --------->
//* TO hold the content for one hero slide
class PromoSlide {
  const PromoSlide({
    required this.tag,
    required this.title,
    required this.lead,
    required this.highlight,
    required this.trail,
    required this.actionLabel,
    required this.onAction,
    this.imageUrl,
  });

  //  <--------- Fields --------->
  //* TO split the subtitle into lead, highlight and trail so the highlight can be tinted in the accent color
  final String tag;
  final String title;

  final String lead;
  final String highlight;
  final String trail;
  final String actionLabel;
  final VoidCallback onAction;
  final String? imageUrl;
}

//  <--------- Promo Carousel Widget --------->
//* TO show the navy hero carousel with ambient glows, a tilted product photo and pagination dots
class PromoCarousel extends StatefulWidget {
  const PromoCarousel({super.key, required this.slides});

  final List<PromoSlide> slides;

  static const height = 208.0;

  @override
  State<PromoCarousel> createState() => _PromoCarouselState();
}

//  <--------- Promo Carousel State --------->
class _PromoCarouselState extends State<PromoCarousel> {
  //  <--------- Fields --------->
  final _controller = PageController();
  int _index = 0;

  //  <--------- Lifecycle --------->
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  //  <--------- Build --------->
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: SizedBox(
        height: PromoCarousel.height,
        child: PageView.builder(
          controller: _controller,
          itemCount: widget.slides.length,
          onPageChanged: (i) => setState(() => _index = i),
          itemBuilder: (context, i) => _PromoCard(
            slide: widget.slides[i],
            pageCount: widget.slides.length,
            pageIndex: _index,
          ),
        ),
      ),
    );
  }
}

//  <--------- Promo Card Widget --------->
//* TO paint one hero slide
class _PromoCard extends StatelessWidget {
  const _PromoCard({
    required this.slide,
    required this.pageCount,
    required this.pageIndex,
  });

  //  <--------- Fields --------->
  final PromoSlide slide;
  final int pageCount;
  final int pageIndex;

  //  <--------- Colors --------->
  static const _ink = Color(0xFF0F1B33);
  static const _rose = Color(0xFF60A5FA);
  static const _rosePale = Color(0xFFBFDBFE);

  //  <--------- Build --------->
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(-0.85, -1),
            end: Alignment(0.85, 1),
            colors: [Color(0xFF0F2557), Color(0xFF1B3B8F), Color(0xFF0A1A3F)],
            stops: [0, 0.5, 1],
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x1A0F2557),
              blurRadius: 32,
              spreadRadius: -6,
              offset: Offset(0, 12),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            //  <--------- Ambient Glows Section --------->
            const Positioned(
              right: -32,
              top: -32,
              child: _Glow(size: 176, color: Color(0x4D3B82F6)),
            ),
            const Positioned(
              left: -40,
              bottom: -40,
              child: _Glow(size: 160, color: Color(0x3360A5FA)),
            ),
            //  <--------- Product Photo Section --------->
            //* TO show the tilted product image on the right
            if (slide.imageUrl != null)
              Positioned(
                right: 4,
                bottom: 4,
                width: 144,
                height: 160,
                child: Center(
                  child: Transform.rotate(
                    angle: 6 * 3.1415926 / 180,
                    child: Container(
                      width: 144,
                      height: 110,
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x26000000),
                            blurRadius: 25,
                            offset: Offset(0, 25),
                          ),
                        ],
                      ),
                      child: CachedNetworkImage(
                        imageUrl: slide.imageUrl!,
                        fit: BoxFit.contain,
                        errorWidget: (_, _, _) => const SizedBox.shrink(),
                      ),
                    ),
                  ),
                ),
              ),
            //  <--------- Text And Action Section --------->
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Pill(
                    label: slide.tag,
                    uppercase: true,
                    background: const Color(0x333B82F6),
                    border: const Color(0x4D60A5FA),
                    foreground: _rosePale,
                    letterSpacing: 0.25,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 5,
                    ),
                    leading: const Dot(color: _rose),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    slide.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                      color: Colors.white,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: 212,
                    child: Text.rich(
                      TextSpan(
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFFCBD5E1),
                          height: 1.35,
                        ),
                        children: [
                          TextSpan(text: slide.lead),
                          TextSpan(
                            text: slide.highlight,
                            style: const TextStyle(
                              color: _rosePale,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(text: slide.trail),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Spacer(),
                  Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    elevation: 2,
                    shadowColor: Colors.black26,
                    child: InkWell(
                      onTap: slide.onAction,
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              slide.actionLabel,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: _ink,
                                height: 1.33,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.arrow_forward_rounded,
                              size: 14,
                              color: _ink,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //  <--------- Page Dots Section --------->
            if (pageCount > 1)
              Positioned(
                bottom: 12,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 0; i < pageCount; i++)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: i == pageIndex ? 20 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: i == pageIndex
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

//  <--------- Glow Widget --------->
//* TO paint a soft radial glow circle
class _Glow extends StatelessWidget {
  const _Glow({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, color.withValues(alpha: 0)]),
      ),
    );
  }
}
