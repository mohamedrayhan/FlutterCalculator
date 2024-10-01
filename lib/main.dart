import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatefulWidget {
  @override
  _CalculatorAppState createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  bool isDarkMode = false; // Variable to track theme

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode; // Toggle the theme variable
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: isDarkMode
          ? ThemeData.dark().copyWith(
              scaffoldBackgroundColor: Colors.black,
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.grey[900],
                titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
              ),
            )
          : ThemeData.light().copyWith(
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.blue,
                titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
      home: Calculator(
        toggleTheme: toggleTheme,
        isDarkMode: isDarkMode,
      ),
    );
  }
}

class Calculator extends StatefulWidget {
  final Function toggleTheme;
  final bool isDarkMode;

  Calculator({required this.toggleTheme, required this.isDarkMode});

  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String display = '0';
  double _result = 0;
  String _currentInput = '';
  String _operator = '';

  void inputDigit(String digit) {
    setState(() {
      if (display == '0' || display == 'Error') {
        display = digit; // Replace initial 0 or Error with input
      } else {
        display += digit; // Append digit
      }
      _currentInput += digit; // Build the current input for evaluation
    });
  }

  void setOperator(String operator) {
    setState(() {
      if (_currentInput.isNotEmpty) {
        _result = double.tryParse(_currentInput) ?? 0; // Safely parse current input
        _operator = operator;
        display = '0'; // Reset display for next input
        _currentInput = ''; // Reset current input
      } else {
        _operator = operator; // Set operator if there's no input
      }
    });
  }

  void evaluate() {
    setState(() {
      if (_currentInput.isNotEmpty || _operator.isNotEmpty) {
        double secondInput = double.tryParse(_currentInput) ?? 0; // Safely parse second input
        switch (_operator) {
          case '+':
            _result += secondInput;
            break;
          case '-':
            _result -= secondInput;
            break;
          case '*':
            _result *= secondInput;
            break;
          case '/':
            if (secondInput != 0) {
              _result /= secondInput;
            } else {
              display = 'Error'; // Handle division by zero
              return;
            }
            break;
          default:
            break;
        }
        display = _result.toString(); // Show result on display
        _currentInput = ''; // Clear current input for the next calculation
        _operator = ''; // Clear operator
      }
    });
  }

  void clear() {
    setState(() {
      _result = 0;
      _currentInput = '';
      _operator = '';
      display = '0'; // Reset display
    });
  }

  void toggleSign() {
    setState(() {
      if (display != '0' && display != 'Error') {
        // If display is not default or error, toggle sign
        double value = double.tryParse(display) ?? 0;
        display = (value * -1).toString(); // Change sign
        _currentInput = display; // Update current input
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.wb_sunny : Icons.brightness_6),
            onPressed: () => widget.toggleTheme(),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Text(
              display,
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
          ),
          // Numpad and operator layout
          Expanded(
            child: Row(
              children: [
                // Number pad
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildButton('7'),
                          buildButton('8'),
                          buildButton('9'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildButton('4'),
                          buildButton('5'),
                          buildButton('6'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildButton('1'),
                          buildButton('2'),
                          buildButton('3'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildButton('C', onPressed: clear),
                          buildButton('0', flex: 2), // Center the 0 button
                          buildButton('+/-', onPressed: toggleSign),
                        ],
                      ),
                    ],
                  ),
                ),
                // Operators column
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    buildButton('/', onPressed: () => setOperator('/')),
                    buildButton('×', onPressed: () => setOperator('*')),
                    buildButton('-', onPressed: () => setOperator('-')),
                    buildButton('+', onPressed: () => setOperator('+')),
                    buildButton('=', onPressed: () {
                      evaluate();
                      // If equals is pressed and operator is set, we can use the result
                      if (_operator.isNotEmpty) {
                        _currentInput = display; // Set current input to display for further calculations
                      }
                    }),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildButton(String label, {VoidCallback? onPressed, int flex = 1}) {
    return Container(
      margin: EdgeInsets.all(2), // Reduced margin for closer buttons
      width: 60, // Adjusted width for uniformity
      height: 60, // Adjusted height for uniformity
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
              widget.isDarkMode ? Colors.grey[700] : Colors.blue[300]), // Button background color based on theme
          foregroundColor: MaterialStateProperty.all(Colors.white), // Text color
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Rounded corners for buttons
          )),
        ),
        onPressed: onPressed ?? () => inputDigit(label),
        child: Container(
          alignment: Alignment.center,
          child: Text(label, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
