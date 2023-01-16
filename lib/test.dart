import 'package:flutter/material.dart';

class Example extends StatelessWidget {
  const Example({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: DataOwnerStatefull(),
      ),
    );
  }
}

class DataOwnerStatefull extends StatefulWidget {
  @override
  _DataOwnerStatefullState createState() => _DataOwnerStatefullState();
}

class _DataOwnerStatefullState extends State<DataOwnerStatefull> {

  @override
  Widget build(BuildContext context) {
    final _model = CalcModel();
    return DataProviderInherited(
      model: _model,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          MyBTN(),
          CustomTextWithBtn(),
        ],
      ),
    );
  }
}

class MyBTN extends StatefulWidget {
  const MyBTN({super.key});


  @override
  State<StatefulWidget> createState() => _MyBtn();
}

class _MyBtn extends State<MyBTN> {
  int topNumber = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final model = DataProviderInherited.of(context);
    model?.addListener(() {
      print(topNumber);
      topNumber = model.topNumber;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        DataProviderInherited.of(context)?.grow_up();
        DataProviderInherited.of(context)?.changeColor();
        setState(() {});
      },
      child: Text('Жми на верху $topNumber'),
    );
  }
}


class CustomTextWithBtn extends StatefulWidget {
  const CustomTextWithBtn({Key? key}) : super(key: key);

  @override
  CustomTextWithBtnState createState() => CustomTextWithBtnState();
}

class CustomTextWithBtnState extends State<CustomTextWithBtn> {
  String _result = '0';
  bool color = true;
  static const Color _oneColor =  Colors.yellow;
  static const Color _twoColor =  Colors.lightGreen;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final model = DataProviderInherited.of(context);
    model?.addListener(() {
      _result = model.summResult.toString();
      color = model.color;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {


    return AnimatedContainer(
      width: color ? 150 : 350,
      height: 100,
      // left: color ? 100 : 150,
      duration: const Duration(milliseconds: 100),
      child: Material(
          color: color ? _oneColor: _twoColor,
          child: Column(
            children: [
              Text(_result, style: const TextStyle(fontSize: 25),),
              ElevatedButton(onPressed: () {
                DataProviderInherited.of(context)?.toTop();
                setState(() {});
              },
                child: const Text('Send to TOP!', style: TextStyle(fontSize: 25),),)
            ],
          )
      ),
    );
  }
}

class CalcModel extends ChangeNotifier {
  int summResult = 0;
  int topNumber = 0;
  bool color = true;

  getResult({required String value}) => summResult = int.parse(value);

  void grow_up() {
    summResult += 1;
    notifyListeners();
  }

  void toTop() {
    topNumber = summResult;
    notifyListeners();
  }

  void changeColor() {
    color = !color;
    notifyListeners();
  }
}

class DataProviderInherited extends InheritedWidget {
  final CalcModel model;

  const DataProviderInherited({
    Key? key,
    required this.model,
    required Widget child,
  }) : super(key: key, child: child);

  static CalcModel? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DataProviderInherited>()?.model;
  }

  @override
  bool updateShouldNotify(DataProviderInherited oldWidget) {
    return model != oldWidget.model;
  }
}
