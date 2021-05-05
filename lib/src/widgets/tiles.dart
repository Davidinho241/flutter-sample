import 'package:coinpay/src/helpers/localization.dart';
import 'package:coinpay/src/helpers/navigation.dart';
import 'package:coinpay/src/models/CountryOption.dart';
import 'package:coinpay/src/screens/qrcode/QrCodeScanUI.dart';
import 'package:coinpay/src/utils/sizes.dart';
import 'package:coinpay/src/utils/themes.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:coinpay/src/utils/colors.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share/share.dart';
import 'buttons.dart';
import 'inputs.dart';

class CountryTile extends StatelessWidget {
  final CountryOption countryOption;
  final Function onTap;

  CountryTile({
    @required this.countryOption,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: <Widget>[
          Container(
            child:
                CountryPickerUtils.getDefaultFlagImage(countryOption.country),
            decoration: BoxDecoration(boxShadow: [customShadow()]),
          ),
          SizedBox(
            width: Sizes.s15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "${countryOption.country.name} (${countryOption.lang})",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: FontSize.s15,
                ),
              ),
              Text(
                "${countryOption.currency}",
                style: TextStyle(
                  fontSize: FontSize.s12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          Spacer(),
          countryOption.selected ? Icon(Icons.check) : Container()
        ],
      ),
    );
  }
}

class EmptyBalanceTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(

    );
  }
}

// ignore: must_be_immutable
class ReceiveTile extends StatelessWidget {
  final Map<String, dynamic> address;
  final FocusNode addressFocus;
  final TextEditingController addressController;

  ReceiveTile({this.address, this.addressFocus, this.addressController});

  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: inputHint,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check),
        SizedBox(
          width: 12.0,
        ),
        Text("Copied form clipboard !"),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context);
    final FToast fToast = FToast();
    fToast.init(context);
    print(this.address["address"]);
    this.addressController.text = this.address["address"];
    return Container(
      child: Column(
        children: [
          QrImage(
            data: address["address"],
            version: QrVersions.auto,
            size: 200.0,
          ),
          SizedBox(
              height: Sizes.s40
          ),
          OutlineTextField(
            hintText: "${lang.translate('screen.transactionScreen.inputHintAddress')}",
            labelText: "${lang.translate('screen.transactionScreen.inputHintAddress')}",
            hintStyle: TextStyle(fontSize: FontSize.s14),
            labelStyle: TextStyle(fontSize: FontSize.s14),
            textInputType: TextInputType.text,
            suffixIcon: IconButton(
              icon: SvgPicture.asset(
                "assets/images/icons/copyIcon.svg",
                color: secondaryColor,
              ),
              onPressed: () {
                Clipboard.setData(new ClipboardData(text: addressController.text)).then((value)
                {
                  fToast.showToast(
                    child: toast,
                    gravity: ToastGravity.BOTTOM,
                    toastDuration: Duration(seconds: 2),
                  );
                });
              },
            ),
            prefixIcon: IconButton(
              iconSize: Sizes.s24,
              icon: SvgPicture.asset(
                "assets/images/icons/addressIcon.svg",
                color: addressFocus.hasFocus ? secondaryColor : inputHint,
              ),
              onPressed: null,
            ),
            controller: addressController,
            focusNode: addressFocus,
          ),
          SizedBox(
            height: Sizes.s50,
          ),
          Container(
            height: Sizes.s40,
            child: ButtonSystemTheme(
              title: "${lang.translate('screen.transactionScreen.btnShare')}",
              onTap: () async{
                await Share.share('Hello dear, the address of my wallet is : '+addressController.text);
              },
              fontSize: FontSize.s16,
              weight: FontWeight.w500,
              height: Sizes.s48,
              width: MediaQuery.of(context).size.width,
              color: secondaryColor,
            ),
          ),
        ],
      )
    );
  }
}

// ignore: must_be_immutable
class SendTile extends StatelessWidget {
  final GlobalKey formKey ;
  final TextEditingController amountController ;
  final TextEditingController addressController;
  final FocusNode amountFocus;
  final FocusNode addressFocus;

  SendTile(
      {this.formKey,
      this.amountController,
      this.addressController,
      this.amountFocus,
      this.addressFocus,});


  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context);
    return Container(
      margin: EdgeInsets.fromLTRB(Sizes.s15, Sizes.s15, Sizes.s15, 0),
      width: double.maxFinite,
      height: double.maxFinite,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(Sizes.s8),
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              OutlineTextField(
                hintText: "${lang.translate('screen.transactionScreen.inputHintAmount')}",
                labelText: "${lang.translate('screen.transactionScreen.inputHintAmount')}",
                hintStyle: TextStyle(fontSize: FontSize.s14),
                labelStyle: TextStyle(fontSize: FontSize.s14),
                controller: amountController,
                textInputType: TextInputType.number,
                prefixIcon: IconButton(
                  iconSize: Sizes.s24,
                  icon: SvgPicture.asset(
                    "assets/images/icons/bitcoinOutline.svg",
                    color: amountFocus.hasFocus ? secondaryColor : inputHint,
                  ),
                  onPressed: null,
                ),
                maxLength: 20,
                focusNode: amountFocus,
              ),
              SizedBox(
                height: Sizes.s40
              ),
              OutlineTextField(
                hintText: "${lang.translate('screen.transactionScreen.inputHintAddress')}",
                labelText: "${lang.translate('screen.transactionScreen.inputHintAddress')}",
                hintStyle: TextStyle(fontSize: FontSize.s14),
                labelStyle: TextStyle(fontSize: FontSize.s14),
                textInputType: TextInputType.text,
                suffixIcon: IconButton(
                  iconSize: Sizes.s24,
                  icon: SvgPicture.asset(
                    "assets/images/icons/ScanIcon.svg",
                    color: secondaryColor,
                  ),
                  onPressed: () async{
                    addressController.text = await openPage(context, QrCodeScanUI());
                  },
                ),
                prefixIcon: IconButton(
                  iconSize: Sizes.s24,
                  icon: SvgPicture.asset(
                    "assets/images/icons/addressIcon.svg",
                    color: addressFocus.hasFocus ? secondaryColor : inputHint,
                  ),
                  onPressed: null,
                ),
                controller: addressController,
                focusNode: addressFocus,
              ),
              SizedBox(
                height: Sizes.s50,
              ),
              Container(
                height: Sizes.s40,
                child: ButtonSystemTheme(
                  title: "${lang.translate('screen.transactionScreen.btnSend')}",
                  onTap: null,
                  fontSize: FontSize.s16,
                  weight: FontWeight.w500,
                  height: Sizes.s48,
                  width: MediaQuery.of(context).size.width,
                  color: secondaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


