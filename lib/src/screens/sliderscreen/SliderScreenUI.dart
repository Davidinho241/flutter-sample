import 'package:coinpay/src/components/slidersComponent.dart';
import 'package:coinpay/src/screens/dashboard/DashboardUI.dart';
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
  bool _sliderLoaded = false;
  List<SliderComponent> _sliders = [];
  int currentSlider = 0;
  PageController pageController = new PageController(initialPage: 0);

  initializeData() async {
    await LocalService.getSliders().then((value) {
      setState(() {
        _sliders = value;
        _sliderLoaded = true;
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
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        actions: <Widget>[ if(currentSlider != _sliders.length -1)
          FlatButton(
            color: Colors.transparent,
            onPressed: () => pageController.animateToPage(_sliders.length -1, duration: Duration(microseconds: 400), curve: Curves.linear),
            child: TextParagraph(
              data: "skip",
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
      bottomSheet: currentSlider != _sliders.length - 1 ? Wrap(
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
                  GestureDetector(
                    child: ButtonWithIcon(
                      title: "Next",
                      height: Sizes.s48,
                      icon: Icons.arrow_forward_ios,
                      color: secondaryColor,
                      onTap: (){
                        pageController.animateToPage(currentSlider + 1, duration: Duration(microseconds: 400), curve: Curves.linear);
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ): Wrap(
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
                  ButtonWithIcon(
                    title: "Get Started",
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
      ),
    );
  }
}

class SliderTile extends StatelessWidget{
  String imagePath, title, description;

  SliderTile(this.imagePath, this.title, this.description);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            imagePath,
            height: MediaQuery.of(context).size.height/2.5,
          ),
          SizedBox(height: Sizes.s20),
          Container(
            padding: EdgeInsets.only(left: Sizes.s24, right: Sizes.s24),
            child: Column(
              children: [
                Container(
                  child: TextTitle(data : title),
                ),
                SizedBox(height: Sizes.s20),
                Container(
                  padding: EdgeInsetsDirectional.only(start: Sizes.s20, end: Sizes.s20),
                  child: TextParagraph(data : description),
                ),
              ],
            ),
          ),
          SizedBox(height: Sizes.s5)
        ],
      ),
    );
  }
}
