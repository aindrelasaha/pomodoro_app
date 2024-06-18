import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(PowerPomApp());
}

class PowerPomApp extends StatefulWidget {
  @override
  _PowerPomAppState createState() => _PowerPomAppState();
}

class _PowerPomAppState extends State<PowerPomApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleThemeMode() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MeowDoro',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      debugShowCheckedModeBanner: false,
      home: SplashScreen(toggleThemeMode: _toggleThemeMode),
    );
  }
}

class BackgroundImageScaffold extends StatelessWidget {
  final Widget body;
  final String backgroundImage;

  const BackgroundImageScaffold({required this.body, required this.backgroundImage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: body,
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  final VoidCallback toggleThemeMode;

  SplashScreen({required this.toggleThemeMode});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => FirstPage(toggleThemeMode: toggleThemeMode)),
      );
    });

    return BackgroundImageScaffold(
      backgroundImage: 'assets/images/MeowDoro.png', 
      body: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/MeowDoro.png', 
                width: 300,
                height: 320,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 20.0),
              Text(
                'Welcome to the Ultimate Pomodoro app',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.pinkAccent,
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                '',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FirstPage extends StatelessWidget {
  final VoidCallback toggleThemeMode;

  FirstPage({required this.toggleThemeMode});

  @override
  Widget build(BuildContext context) {
    return BackgroundImageScaffold(
      backgroundImage: 'assets/images/OkPlease.png',
      body: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20.0),
            Center(
              child: Text(
                'Get ready to boost your productivity!',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 30.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage(toggleThemeMode: toggleThemeMode)),
                );
              },
              child: Text('Set Study & Break Time'),
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 255, 255, 255), 
                onPrimary: Color.fromARGB(255, 210, 104, 154), 
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsPage extends StatefulWidget {
  final VoidCallback toggleThemeMode;

  SettingsPage({required this.toggleThemeMode});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _sessionMinutes = 25;
  int _breakMinutes = 5;

  @override
  Widget build(BuildContext context) {
    return BackgroundImageScaffold(
      backgroundImage: 'assets/images/BgOk.png',
      body: Scaffold(
        appBar: AppBar(
          title: Text(
            'Set Study & Break Time',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Theme.of(context).brightness == Brightness.dark ? Icons.light_mode : Icons.dark_mode,
              ),
              onPressed: widget.toggleThemeMode,
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height - kToolbarHeight - 24, 
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Select Study Time: $_sessionMinutes minutes',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    Slider(
                      value: _sessionMinutes.toDouble(),
                      min: 1,
                      max: 60,
                      onChanged: (value) {
                        setState(() {
                          _sessionMinutes = value.toInt();
                        });
                      },
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      'Select Break Time: $_breakMinutes minutes',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    Slider(
                      value: _breakMinutes.toDouble(),
                      min: 1,
                      max: 30,
                      onChanged: (value) {
                        setState(() {
                          _breakMinutes = value.toInt();
                        });
                      },
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LiveTimerPage(
                              sessionMinutes: _sessionMinutes,
                              breakMinutes: _breakMinutes,
                              onStudyComplete: (minutes) {
                               
                              },
                              toggleThemeMode: widget.toggleThemeMode,
                            ),
                          ),
                        );
                      },
                      child: Text('Start Work Session'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}



class LiveTimerPage extends StatefulWidget {
  final int sessionMinutes;
  final int breakMinutes;
  final ValueChanged<int> onStudyComplete;
  final VoidCallback toggleThemeMode;

  LiveTimerPage({required this.sessionMinutes, required this.breakMinutes, required this.onStudyComplete, required this.toggleThemeMode});

  @override
  _LiveTimerPageState createState() => _LiveTimerPageState();
}

class _LiveTimerPageState extends State<LiveTimerPage> {
  late int _secondsRemaining;
  bool _isSession = true;
  late Timer _timer;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _secondsRemaining = widget.sessionMinutes * 60;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (!_isPaused) {
          if (_secondsRemaining > 0) {
            _secondsRemaining--;
          } else {
            if (_isSession) {
              widget.onStudyComplete(widget.sessionMinutes);
            }
            _isSession = !_isSession;
            _secondsRemaining = _isSession ? widget.sessionMinutes * 60 : widget.breakMinutes * 60;
          }
        }
      });
    });
  }

  void _pauseTimer() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    String minutesStr = (minutes < 10) ? '0$minutes' : '$minutes';
    String secondsStr = (remainingSeconds < 10) ? '0$remainingSeconds' : '$remainingSeconds';
    return '$minutesStr:$secondsStr';
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundImageScaffold(
      backgroundImage: 'assets/images/BgOk.png',
      body: Scaffold(
        appBar: AppBar(
          title: Text('Live Timer',
          style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Theme.of(context).brightness == Brightness.dark ? Icons.light_mode : Icons.dark_mode,
              ),
              onPressed: widget.toggleThemeMode,
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                _isSession ? 'Session Time' : 'Break Time',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.0),
              Text(
                _formatTime(_secondsRemaining),
                style: TextStyle(fontSize: 48.0),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  _pauseTimer();
                },
                child: Text(_isPaused ? 'Resume' : 'Pause'),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  _timer.cancel();
                  Navigator.pop(context);
                },
                child: Text('Stop'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


