import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

void main() => runApp(SlidingUpPanelExample());

class SlidingUpPanelExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.grey[200],
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarDividerColor: Colors.black,
    ));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SlidingUpPanel Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _panelHeightOpen = 575.0;
  double _panelHeightClosed = 48.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          SlidingUpPanel(
            maxHeight: _panelHeightOpen,
            minHeight: _panelHeightClosed,
            backdropEnabled: true,
            parallaxOffset: .5,
            body: _body(),
            panel: BetSlip(),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
          ),
          Positioned(
            top: 42.0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24.0, 18.0, 24.0, 18.0),
              child: Text(
                "SlidingUpPanel Example",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24.0),
                boxShadow: [BoxShadow(color: Color.fromRGBO(0, 0, 0, .25), blurRadius: 16.0)],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _body() {
    return Container(color: Colors.yellow);
  }
}

class BetSlip extends StatefulWidget with PreferredHeightWidget {
  _BetSlipState state;

  @override
  _BetSlipState createState() => _BetSlipState();

  Size preferredSize(BuildContext context) {
//    _BetSlipState state = context.findAncestorStateOfType<State<BetSlip>>();
    var preferredSize = state?.preferredSize;
    if (preferredSize != null) {
      return Size(0, 48 + 56 + preferredSize.height);
    }
    return preferredSize;
  }
}

class _BetSlipState extends State<BetSlip> with SingleTickerProviderStateMixin {
  TabController controller;
  List<_MyTabView> views = [
    _MyTabView(preferredHeight: 100, color: Colors.blue),
    _MyTabView(preferredHeight: 200, color: Colors.green),
    _MyTabView(preferredHeight: 300, color: Colors.red),
  ];

  _BetSlipState();

  @override
  void didUpdateWidget(BetSlip oldWidget) {
    widget.state = this;
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    widget.state = this;
    controller = TabController(length: 3, vsync: this);
    super.initState();
  }

  Size get preferredSize => views[controller.index].preferredSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          height: 48,
          alignment: Alignment.center,
          child: Text(
            "BetSlip",
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 24.0,
            ),
          ),
        ),
        TabBar(
          labelColor: Colors.blue,
          controller: controller,
          tabs: <Widget>[
            Tab(text: "Blue"),
            Tab(text: "Green"),
            Tab(text: "Ref"),
          ],
        ),
        Flexible(
          child: TabBarView(controller: controller, children: views),
        )
      ],
    );
  }
}

class _MyTabView extends StatelessWidget with PreferredSizeWidget {
  final double preferredHeight;
  final Color color;
  final GlobalKey _contentKey1 = GlobalKey();
  final GlobalKey _contentKey2 = GlobalKey();

  _MyTabView({Key key, this.preferredHeight, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(key: _contentKey1, height: preferredHeight - 70, color: color),
        Spacer(),
        Container(
          key: _contentKey2,
          height: 70,
          decoration: BoxDecoration(color: color, border: Border.all(color: Colors.yellow, width: 3)),
        ),
      ],
    );
  }

  @override
  Size get preferredSize {
    RenderBox box1 = _contentKey1.currentContext?.findRenderObject();
    RenderBox box2 = _contentKey2.currentContext?.findRenderObject();
    if (box1 != null && box2 != null) {
      return Size(0, box1.size.height + box2.size.height);
    }
    return null;
  }
}
