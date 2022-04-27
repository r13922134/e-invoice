import 'package:flutter/material.dart';
import 'package:firstapp/screens/details/details_screen.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

import '../../../constants.dart';

class CardSwiper extends StatelessWidget {
  const CardSwiper({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Swiper(
      itemBuilder: (context, index) {
        return Image.network(
          "https://via.placeholder.com/288x188",
          fit: BoxFit.fill,
        );
      },
      indicatorLayout: PageIndicatorLayout.COLOR,
      autoplay: true,
      itemCount: 3,
      pagination: const SwiperPagination(),
      control: const SwiperControl(),
    );
  }
}
