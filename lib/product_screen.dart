import 'dart:io';
import 'package:eshop/constants.dart';
import 'package:eshop/custom_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth/sign_in.dart';
import 'product_provider.dart';

class ProductScreen extends ConsumerStatefulWidget {
  const ProductScreen({super.key});

  @override
  ConsumerState<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends ConsumerState<ProductScreen> {
  bool showDiscountedPrice = false;

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
    );
  }

  Future<void> _fetchRemoteConfig() async {
    FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
    if (!mounted) return;
    setState(() {
      showDiscountedPrice = remoteConfig.getBool('show_discounted_price');
    });
    await remoteConfig.fetchAndActivate();
    remoteConfig.onConfigUpdated.listen((event) async {
      if (!mounted) return;
      await remoteConfig.activate();
      if (!mounted) return;
      setState(() {});
    });
  }

  Future<void> _refreshData() async {
    await ref.read(productProvider.notifier).getItems();
    await _fetchRemoteConfig();
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;

    final productList = ref.watch(productProvider);

    return WillPopScope(
      onWillPop: () async {
        return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: sGrey,
            title: Text(
              'Are you sure?',
              style: TextStyle(
                  color: cBlue,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins'),
            ),
            content: Text(
              'Do You Want To Exit The App',
              style: TextStyle(
                  color: bBlue.withOpacity(0.8),
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Poppins'),
            ),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Container(
                        width: width * 0.25,
                        height: height * 0.05,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        child: const Center(
                            child: Text(
                          'No',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        )),
                      ),
                    ),
                    SizedBox(width: width * 0.1),
                    InkWell(
                      onTap: () {
                        exit(0);
                      },
                      child: Container(
                        width: width * 0.25,
                        height: height * 0.05,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        child: const Center(
                            child: Text(
                          'Yes',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        )),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
      },
      child: Scaffold(
        appBar: AppBar(automaticallyImplyLeading: false,
          backgroundColor: cBlue,
          title: Text(
            'e-Shop',
            style: TextStyle(
              color: sGrey,
              fontSize: height * 0.021,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              onPressed: _signOut,
              icon: const Icon(
                Icons.exit_to_app_sharp,
                color: Colors.red,
              ),
            ),
            SizedBox(
              width: width * 0.021,
            ),
          ],
        ),
        backgroundColor: sWhite,
        body: RefreshIndicator(
          color: bBlue,
          backgroundColor: sGrey,
          onRefresh: _refreshData,
          child: productList.isEmpty
              ? GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.61,
                  ),
                  itemCount: 10, // Number of shimmer placeholders
                  itemBuilder: (context, index) {
                    return ShimmerProductCard(width, height);
                  },
                )
              : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.61,
                  ),
                  itemCount: productList.length,
                  itemBuilder: (context, index) {
                    return productCard(
                      () {},
                      width,
                      height,
                      productList[index].images?[0] ?? '',
                      productList[index].title ?? '',
                      productList[index].description ?? '',
                      productList[index].price ?? 0.0,
                      productList[index].discountPercentage ?? 0.0,
                      showDiscountedPrice,
                    );
                  },
                ),
        ),
      ),
    );
  }
}
