import 'package:flutter_music/baseImport.dart';
import 'package:flutter_music/state/models/MainModel.dart';
import './pages/RecommendPage.dart';
import './pages/SingersPage.dart';
import './pages/ChartsPage.dart';
import './pages/SearchPage.dart';
import 'dart:async';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: CommonThemeData.get(),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var pageController = PageController();

  MainModel mainModel = MainModel();

  bool finishAPP = false;

  @override
  Widget build(BuildContext context) {
    pageController.addListener(() {
      mainModel.offsetOfPageView = pageController.offset;
    });
    MyUtils.countDown(beforeCountDown: null,afterCountDown: null);
    return WillPopScope(
      onWillPop: () { // 返回键监听
        if (finishAPP) {
          return Future.value(true);
        } else {
          MyToast.show('在按一次退出应用');
          MyUtils.countDown(beforeCountDown: () {
            finishAPP = true;
          }, afterCountDown: () {
            finishAPP = false;
          });

          return Future.value(false);
        }
      },
      child: ScopedModel<MainModel>(
        model: mainModel,
        child: Scaffold(
          backgroundColor: COLOR_BLACK,
          body: SafeArea(
              child: Column(
            children: <Widget>[
              // 标题栏
              Container(
                height: 40.0,
                child: Stack(
                  children: <Widget>[
                    Container(
                      child: Text(
                        'Flutter Music',
                        style: TextStyle(color: COLOR_YELLOW, fontSize: 17.0),
                      ),
                      alignment: Alignment.center,
                    ),
                    Container(
                        padding: EdgeInsets.only(right: 10.0),
                        child: Image.asset('images/user.png',
                            width: 20.0, height: 20.0),
                        alignment: Alignment.centerRight)
                  ],
                ),
              ),
              // 主页面
              Container(
                height: MyUtils.getSafeAreaHeight(context) - 40,
                child: PageView(
                  controller: pageController,
                  children: <Widget>[
                    RecommendPage(),
                    SingersPage(),
                    ChartsPage(),
                    SearchPage()
                  ],
                  onPageChanged: (index) {
                    mainModel.indexOfPageView = index;
                  },
                ),
              )
            ],
          )),
        ),
      ),
    );
  }
}
