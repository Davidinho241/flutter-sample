import 'package:coinpay/src/components/slidersComponent.dart';
import 'package:coinpay/src/helpers/localization.dart';
import 'package:coinpay/src/screens/registration/RegisterUI.dart';
import 'package:coinpay/src/services/local_service.dart';
import 'package:coinpay/src/utils/colors.dart';
import 'package:coinpay/src/utils/sizes.dart';
import 'package:coinpay/src/widgets/buttons.dart';
import 'package:coinpay/src/widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:coinpay/src/helpers/navigation.dart';

class SliderScreenUI extends StatefulWidget {
  @override
  _SliderScreenUIState createState() => _SliderScreenUIState();
}

class _SliderScreenUIState extends State<SliderScreenUI> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  List<SliderComponent> _sliders = [];
  int currentSlider = 0;
  PageController pageController = new PageController(initialPage: 0);

  initializeData() async {
    await LocalService.getSliders().then((value) {
      setState(() {
        _sliders = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Widget pageIndexIndicator(bool isCurrentPage){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Sizes.s5),
      height: Sizes.s12,
      width: isCurrentPage ? Sizes.s20 : Sizes.s12,
      decoration: BoxDecoration(
        color: isCurrentPage ? thirdColor : fourthColor,
        borderRadius: BorderRadius.all(
        Radius.circular(Sizes.s10),
      ),
      ),

    );
  }

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        actions: <Widget>[ if(currentSlider != _sliders.length -1)
          TextButton(
            onPressed: () => pageController.animateToPage(_sliders.length -1, duration: Duration(microseconds: 400), curve: Curves.linear),
            child: TextParagraph(
              data: "${lang.translate('screen.register.btnSkip')}",
              color: secondaryColor,
              size: Sizes.s16,
              weight: FontWeight.w500,
            ),
          )
        ],
      ),
      body: PageView.builder(
        controller: pageController,
        itemCount: _sliders.length,
        onPageChanged: (val){
          setState(() {
            currentSlider = val;
          });
        },
        itemBuilder: (context, index){
          return SliderTile(
              _sliders[index].imagePath,
              _sliders[index].title,
              _sliders[index].description
          );
        },
      ),
      bottomSheet: Wrap(
        alignment: WrapAlignment.end,
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(left: Sizes.s12, top: Sizes.s30, right: Sizes.s12, bottom: Sizes.s30),
            child: Center(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      for(int i = 0; i < _sliders.length; i++) currentSlider == i ? pageIndexIndicator(true) : pageIndexIndicator(false),
                    ],
                  ),
                  SizedBox(height: Sizes.s40),
                  currentSlider != _sliders.length - 1 ?
                  GestureDetector(
                    child: ButtonWithIcon(
                      title: "${lang.translate('screen.register.btnNext')}",
                      height: Sizes.s48,
                      icon: Icons.arrow_forward_ios,
                      color: secondaryColor,
                      onTap: (){
                        pageController.animateToPage(currentSlider + 1, duration: Duration(microseconds: 400), curve: Curves.linear);
                      },
                    ),
                  ) : ButtonWithIcon(
                    title: "${lang.translate('screen.register.btnStart')}",
                    height: Sizes.s48,
                    icon: Icons.arrow_forward_ios,
                    color: secondaryColor,
                    size: Sizes.s173,
                    onTap: (){
                      openRemovePage(context, RegisterUI());
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      )
    );
  }
}

// ignore: must_be_immutable
class SliderTile extends StatelessWidget{
  String imagePath, title, description;

  SliderTile(this.imagePath, this.title, this.description);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Image.asset(
            imagePath,
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height/3.1,
          ),
        ),
        SizedBox(height: Sizes.s10),
        Container(
          padding: EdgeInsets.only(left: Sizes.s24, right: Sizes.s24),
          child: Column(
            children: [
              Container(
                child: TextTitle(data : title),
              ),
              SizedBox(height: Sizes.s8),
              Container(
                padding: EdgeInsetsDirectional.only(start: Sizes.s20, end: Sizes.s20),
                child: TextParagraph(data : description),
              ),
            ],
          ),
        ),
        SizedBox(height: Sizes.s5)
      ],
    );
  }
}
