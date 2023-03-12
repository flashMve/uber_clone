import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uber_rider_app/Screens/Home%20Screens/home_screen.dart';

import '../../Global/constants.dart';
import '../../Models/address.dart';
import '../../Models/predictions.dart';
import '../../Models/user_model.dart';
import '../../Widgets/address_widget.dart';
import '../../Widgets/custom_textfield.dart';
import '../../Widgets/divider.dart';
import '../Splash Screen/fade_animation.dart';

class PanelOverlay extends StatefulWidget {
  const PanelOverlay({
    Key? key,
    required this.dropFocusNode,
    required this.dropOffController,
    required this.pickFocusNode,
    required this.pickUpController,
    required this.panelChecker,
  }) : super(key: key);

  final TextEditingController pickUpController;
  final FocusNode pickFocusNode;
  final FocusNode dropFocusNode;
  final TextEditingController dropOffController;
  final ValueNotifier<bool> panelChecker;

  @override
  State<PanelOverlay> createState() => _PanelOverlayState();
}

class _PanelOverlayState extends State<PanelOverlay> {
  final ValueNotifier<LocationType> locationTypeNotifier =
      ValueNotifier<LocationType>(LocationType.none);

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour > 5 && hour < 12) {
      return 'Morning';
    }
    if (hour > 12 && hour < 17) {
      return 'Afternoon';
    }
    return 'Evening';
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.panelChecker.value = false;
        return true;
      },
      child: Container(
        margin: const EdgeInsets.only(left: 5, right: 5),
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        height: getSize(context).height * 0.9,
        width: getSize(context).width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ValueListenableBuilder<UserModel?>(
                valueListenable: getAuthProvider(context).userGetter,
                builder: (context, user, __) {
                  return Text(
                    "${greeting()}, ${user?.fname ?? "There"}",
                    style: TextStyle(
                      fontSize: FONT_SIZE_16 - 1,
                      fontFamily: FONT_BOLT_BOLD,
                      color: TXT_COLOR_DARK,
                    ),
                  );
                }),
            const SizedBox(height: 4),
            Text(
              "Where to?",
              style: TextStyle(
                fontSize: FONT_SIZE_20,
                fontWeight: FontWeight.bold,
                fontFamily: FONT_BOLT_BOLD,
                color: TXT_COLOR_DARK,
              ),
            ),
            const SizedBox(height: 10),
            addressFields(context),
            _buildActions(context),
          ],
        ),
      ),
    );
  }

  Widget addressFields(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDots(),
        Expanded(
          child: Column(
            children: [
              CustomTextFieldOnly(
                controller: widget.pickUpController,
                focusNode: widget.pickFocusNode,
                submit: (val) {
                  widget.pickFocusNode.unfocus();
                },
                onChange: (pickUp) {
                  if (pickUp != "") {
                    getAddressProvider(context).searchAddress(pickUp);
                  }
                  if (pickUp == "") {
                    getAddressProvider(context).clearSearchResults();
                  }
                },
                hint: "Pick Up Location",
                label: "Pick Up Location",
                sufixIcon: FontAwesomeIcons.locationArrow,
                onPressed: () {
                  locationTypeNotifier.value = LocationType.pickup;
                },
              ),
              const SizedBox(height: 10),
              CustomTextFieldOnly(
                controller: widget.dropOffController,
                focusNode: widget.dropFocusNode,
                submit: (val) {
                  widget.dropFocusNode.unfocus();
                },
                onChange: (dropOff) {
                  // _searchNotifier.value = dropOff!;
                  log("Drop off $dropOff");
                  if (dropOff != "") {
                    getAddressProvider(context).searchAddress(dropOff);
                  }
                  if (dropOff.isEmpty) {
                    getAddressProvider(context).clearSearchResults();
                  }
                },
                hint: "Drop Off Location",
                label: "Drop Off Location",
                sufixIcon: FontAwesomeIcons.locationDot,
                onPressed: () {
                  locationTypeNotifier.value = LocationType.dropoff;
                },
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const CustomDivider(
            color: SPLASH_SCREEN_COLOR,
            thickness: 1,
            height: 10,
            indent: 0,
            endIndent: 0,
          ),
          // Wrap(
          //   alignment: WrapAlignment.start,
          //   crossAxisAlignment: WrapCrossAlignment.start,
          //   runAlignment: WrapAlignment.start,
          //   children: [
          //     AddressChip(
          //       onTap: () {},
          //     ),
          //   ],
          // ),
          // const SizedBox(height: 10),
          searchResultWidget(context),
        ],
      ),
    );
  }

  Widget searchResultWidget(BuildContext context) {
    return ValueListenableBuilder<List<Predictions?>?>(
        valueListenable: getAddressProvider(context).getSearchResultsNotifier,
        builder: (ctx, address, __) {
          return address != null
              ? Expanded(
                  child: Column(
                    children: [
                      if (address.isNotEmpty)
                        Text(
                          "Search Result",
                          style: TextStyle(
                            fontSize: FONT_SIZE_16,
                            fontFamily: FONT_BOLT_BOLD,
                            color: TXT_COLOR_DARK,
                          ),
                        ),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: address.length,
                          physics: const ClampingScrollPhysics(),
                          itemBuilder: (ctx, i) => AddressWidget(
                            icon: FontAwesomeIcons.locationPin,
                            title: address[i]!.mainText!,
                            address: address[i]!.secondaryText!,
                            submit: () {
                              if (locationTypeNotifier.value ==
                                  LocationType.pickup) {
                                widget.pickUpController.text =
                                    address[i]!.secondaryText!;
                                showLoadingDialog(context);
                                getAddressProvider(context)
                                    .addPickUpAddress(AddressModel(
                                        placeid: address[i]?.placeId!))
                                    .then((value) {
                                  pop(context);
                                });
                                if (!getAddressProvider(context)
                                    .isDropoffAddressSet()) {
                                  widget.dropFocusNode.requestFocus();
                                  locationTypeNotifier.value =
                                      LocationType.dropoff;
                                }
                                getAddressProvider(context)
                                    .clearSearchResults();
                              } else {
                                widget.dropOffController.text =
                                    address[i]!.secondaryText!;
                                showLoadingDialog(context);
                                getAddressProvider(context)
                                    .addDestinationAddress(AddressModel(
                                        placeid: address[i]!.placeId!))
                                    .then((value) {
                                  pop(context);
                                });
                                if (!getAddressProvider(context)
                                    .isPickupAddressSet()) {
                                  widget.pickFocusNode.requestFocus();
                                  locationTypeNotifier.value =
                                      LocationType.pickup;
                                }
                                getAddressProvider(context)
                                    .clearSearchResults();
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : const Expanded(child: SizedBox());
        });
  }

  Column _buildDots() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Create a dot container for each dot
        for (int i = 0; i < 8; i++)
          FadeAnimationChild(
            prop: AniProps.x,
            child: Container(
              margin: const EdgeInsets.only(top: 5, left: 5, right: 8),
              alignment: Alignment.center,
              child: Icon(
                FontAwesomeIcons.circleDot,
                size: (i == 0 || i == 7) ? 8 : 4,
                color: SPLASH_SCREEN_COLOR,
              ),
            ),
          ),
      ],
    );
  }
}

class AddressChip extends StatelessWidget {
  const AddressChip({
    Key? key,
    this.title = "Work",
    required this.onTap,
    this.icon = FontAwesomeIcons.briefcase,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Chip(
          label: Text(
            title,
            style: TextStyle(
              fontSize: FONT_SIZE_16 - 1,
              fontFamily: FONT_BOLT_REGULAR,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(BUTTON_BORDER_RADIUS),
          ),
          backgroundColor: CONTAINER_COLOR_GREY.shade200,
          avatar: Icon(
            icon,
            color: SPLASH_SCREEN_COLOR,
            size: 12,
          ),
        ),
      ),
    );
  }
}
