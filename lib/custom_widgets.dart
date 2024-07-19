import 'package:eshop/constants.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget customButton(
    final VoidCallback onSaved, double width, double height, String label,
    {bool invertColor = false, bool flat = false}) {
  return InkWell(
    onTap: onSaved,
    child: Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(width * 0.04),
        color: invertColor ? Colors.white : cBlue,
        boxShadow: flat
            ? null
            : [
                BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 5.0,
                    offset: const Offset(3.0, 5.0)),
              ],
      ),
      child: Center(
        child: Text(
          textAlign: TextAlign.center,
          label,
          style: TextStyle(
            color: invertColor ? cBlue : sWhite,
            fontFamily: 'Poppins',
            fontSize: height * 0.4,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}

Widget productCard(
  final VoidCallback onSaved,
  double width,
  double height,
  String? imageUrl,
  String? productName,
  String? desc,
  double? price,
  double? discount,
  bool show,
) {
  double discountedPrice = price! - (price * (discount! / 100));
  String formattedPrice = price.toStringAsFixed(2);
  String formattedDiscountedPrice = discountedPrice.toStringAsFixed(2);
  return InkWell(
    onTap: onSaved,
    child: Container(
      padding: EdgeInsets.all(width * 0.035),
      margin: EdgeInsets.only(left: width * 0.035, top: width * 0.035),
      height: height * 0.4,
      width: width * 0.45,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(width * 0.04))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            imageUrl!,
            width: height * 0.2,
            height: height * 0.15,
            fit: BoxFit.cover,
          ),
          const Spacer(),
          Text(maxLines: 2,
            overflow: TextOverflow.ellipsis,
            productName!,
            style:
                TextStyle(fontWeight: FontWeight.bold, fontSize: height * 0.02),
          ),
          const Spacer(),
          Text(
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            desc!,
            style: TextStyle(
                fontWeight: FontWeight.w400, fontSize: height * 0.018),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: width * 0.01,
              ),
              Text(
                '\$$formattedPrice',
                style: TextStyle(
                    decorationThickness: 2,
                    fontStyle: FontStyle.italic,
                    decoration: show ? TextDecoration.lineThrough:TextDecoration.none,
                    fontWeight: FontWeight.bold,
                    fontSize: height * 0.013),
              ),
              SizedBox(
                width: width * 0.01,
              ),
              show?Text(
                '\$$formattedDiscountedPrice',
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    fontSize: height * 0.013),
              ):const SizedBox(),
              const Spacer(),
              SizedBox(
                width: width * 0.01,
              ),
              Text('$discount% off',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w400,
                    fontSize: height * 0.013,
                    color: Colors.green,
                  )),
              SizedBox(
                width: width * 0.01,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget ShimmerProductCard(double width, double height) {
  return Container(
    padding: EdgeInsets.all(width * 0.035),
    margin: EdgeInsets.only(left: width * 0.035, top: width * 0.035),
    height: height * 0.4,
    width: width * 0.45,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(width * 0.04)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[200]!,
          highlightColor: Colors.black12,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.all(Radius.circular(width * 0.04)),
            ),
            width: double.infinity,
            height: height * 0.2,
          ),
        ),
        const Spacer(),
        Shimmer.fromColors(
          baseColor: Colors.grey[200]!,
          highlightColor: Colors.black12,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.all(Radius.circular(width * 0.04)),
            ),
            width: double.infinity,
            height: height * 0.02,
          ),
        ),
      ],
    ),
  );
}
