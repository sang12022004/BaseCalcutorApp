import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(MyCalculatorApp());
}

class MyCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Máy tính cải tiến',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String expression = '';
  String result = '';

  final List<String> buttons = [
    'C',
    'DEL',
    '(',
    ')',
    '7',
    '8',
    '9',
    '/',
    '4',
    '5',
    '6',
    '*',
    '1',
    '2',
    '3',
    '-',
    '0',
    '.',
    '=',
    '+',
  ];

  void buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        expression = '';
        result = '';
      } else if (buttonText == "DEL") {
        expression = expression.isNotEmpty
            ? expression.substring(0, expression.length - 1)
            : '';
      } else if (buttonText == "=") {
        try {
          Parser p = Parser();
          Expression exp = p.parse(expression);
          ContextModel cm = ContextModel();
          double eval = exp.evaluate(EvaluationType.REAL, cm);

          result = eval.toString();
        } catch (e) {
          result = "Lỗi";
        }
      } else {
        expression += buttonText;
      }
    });
  }

  Color getColor(String text) {
    if (text == '=' || text == 'C' || text == 'DEL') {
      return Colors.orange;
    } else if (text == '+' ||
        text == '-' ||
        text == '*' ||
        text == '/' ||
        text == '(' ||
        text == ')') {
      return Colors.blueGrey;
    } else {
      return Colors.grey[200]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Máy tính cải tiến'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16),
              alignment: Alignment.bottomRight,
              child: Text(
                expression,
                style: TextStyle(fontSize: 32),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            alignment: Alignment.bottomRight,
            child: Text(
              result,
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(),
          Expanded(
            flex: 2,
            child: Container(
              child: GridView.builder(
                itemCount: buttons.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, // Số cột
                  mainAxisSpacing: 1,
                  crossAxisSpacing: 1,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return CalculatorButton(
                    text: buttons[index],
                    callback: buttonPressed,
                    color: getColor(buttons[index]),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CalculatorButton extends StatelessWidget {
  final String text;
  final Function callback;
  final Color color;

  CalculatorButton(
      {required this.text, required this.callback, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        callback(text);
      },
      child: Container(
        margin: EdgeInsets.all(1),
        color: color,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 24,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
