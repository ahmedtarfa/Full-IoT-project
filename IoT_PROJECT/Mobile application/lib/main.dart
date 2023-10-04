import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:iot66/api/firebase_api.dart';
import 'firebase_options.dart';
import 'SensorScreen.dart';
import "package:firebase_database/firebase_database.dart";

bool isAutoMode = false;
bool isMoving = false;
bool isStopManualClicked = false;
bool isExtinguishingFire = false;
Robot robot = Robot();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseApi().initNotification();
  runApp(RobotControl());
}
// cjYQ6MmmTmiGGcY_jQVVqC:APA91bE4f8aFEaU7iIUXRY2ENoKoUaO5CECuu3mIYJXt8EmSO4I3QTsxF0XfLC71houMjxPJW053pAywAj2AmbGOO9hAvaS48EnIKGZx9baen06fUn4GwtYlCADJuLXnJVC_kAPwPR87
class RobotControl extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RobotControlScreen(),
      theme: ThemeData(
        primarySwatch: Colors.red, // Red as the primary color theme
      ),
    );
  }
}

class RobotControlScreen extends StatefulWidget {
  @override
  _RobotControlScreenState createState() => _RobotControlScreenState();
}

class _RobotControlScreenState extends State<RobotControlScreen> {
  final databaseReference = FirebaseDatabase.instance.reference();

  // Function to handle the "Stop" button press for manual movement
  void stopManualMovement() {
    if (isMoving) {
      setState(() {
        isMoving = false;
        isStopManualClicked = true; // Set the flag to true when clicked
      });

      // Implement your logic to stop the robot here for manual movement
      robot.stop();
    }
  }

  // Function to handle the "Stop" button press for auto mode
  void stopAutoMode() {
    if (isAutoMode) {
      setState(() {
        isAutoMode = false;
      });

      // Implement your logic to stop auto mode here
      robot.stopAutoMode();
    }
  }

  // Function to handle the "Auto Move" button press
  void toggleAutoMove() {
    setState(() {
      isAutoMode = !isAutoMode;
    });

    if (isAutoMode) {
      // Implement your logic to start auto mode here
      robot.startAutoMode();
    } else {
      // Implement your logic to stop auto mode here
      robot.stopAutoMode();
    }
  }

  // Function to handle manual movement (e.g., forward)
  void moveRobot() {
    if (!isAutoMode) {
      setState(() {
        isMoving = true;
        isStopManualClicked = false; // Reset the flag when moving
      });


      // Implement your logic to move the robot forward here
      robot.moveForward();

    }
  }

  // Function to handle fire extinguishing
  void toggleExtinguishFire() {
    if (!isAutoMode) {
      setState(() {
        isExtinguishingFire = !isExtinguishingFire; // Toggle the extinguishing fire flag
      });

      if (isExtinguishingFire) {
        // Implement your logic to start extinguishing fire
        robot.extinguishFire();
      } else {
        // Implement your logic to stop extinguishing fire
        robot.stopExtinguishingFire();
      }
    }
  }

  // Function to navigate to the Sensor Screen
  void navigateToSensorScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SensorScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Robot Control'),
        backgroundColor: Colors.red, // Red color for the app bar
        actions: [
          // Add an action button for "Sensor Readings"
          IconButton(
            icon: Icon(Icons.sensors),
            onPressed: navigateToSensorScreen,
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/image3.jpg'), // Replace with your background image
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: <Widget>[
                SizedBox(height: AppBar().preferredSize.height), // Space for the app bar
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.red, Colors.yellow], // Gradient from red to yellow
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        offset: Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  child: Text(
                    'Firefighting Robot Control',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                      letterSpacing: 1.5,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.5),
                          offset: Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20.0),
                // Directional buttons with distinct styling
                Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton.icon(
                          onPressed: isAutoMode ? null : moveRobot,
                          icon: Icon(Icons.arrow_upward, size: 48.0),
                          label: Text('Forward'),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.grey.withOpacity(0.7), // Grey with opacity for the background
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            ElevatedButton.icon(
                              onPressed: isAutoMode ? null : robot.turnLeft,
                              icon: Icon(Icons.arrow_left, size: 48.0),
                              label: Text('Left'),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.grey.withOpacity(0.7), // Grey with opacity for the background
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            ElevatedButton.icon(
                              onPressed: isAutoMode ? null : stopManualMovement,
                              icon: Icon(
                                isStopManualClicked ? Icons.pause: Icons.stop, // Change the icon when clicked
                                size: 48.0,
                              ),
                              label: Text('Stop (Manual)'),
                              style: ElevatedButton.styleFrom(
                                primary: isStopManualClicked
                                    ? Colors.green.withOpacity(0.7) // Change the color when clicked
                                    : Colors.red.withOpacity(0.7), // Red with opacity for the background
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            ElevatedButton.icon(
                              onPressed: isAutoMode ? null : robot.turnRight,
                              icon: Icon(Icons.arrow_right, size: 48.0),
                              label: Text('Right'),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.grey.withOpacity(0.7), // Grey with opacity for the background
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton.icon(
                          onPressed: isAutoMode ? null : robot.moveBackward,
                          icon: Icon(Icons.arrow_downward, size: 48.0),
                          label: Text('Backward'),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.grey.withOpacity(0.7), // Grey with opacity for the background
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                // "Stop" button with red styling
                ElevatedButton(
                  onPressed: isAutoMode ? stopAutoMode : null,
                  child: Text('Stop (Auto)'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red.withOpacity(0.7), // Red with opacity for the background
                    padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                // "Auto Mode" button with red styling
                ElevatedButton(
                  onPressed: isMoving || isAutoMode ? stopManualMovement : toggleAutoMove,
                  child: Text(isAutoMode ? 'Auto Mode (ON)' : 'Auto Mode (OFF)'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red.withOpacity(0.7), // Red with opacity for the background
                    padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                // Button to extinguish fire
                ElevatedButton(
                  onPressed: isAutoMode ? null : toggleExtinguishFire,
                  child: Text(isExtinguishingFire ? 'Stop Extinguishing' : 'Extinguish Fire'),
                  style: ElevatedButton.styleFrom(
                    primary: isExtinguishingFire ? Colors.green.withOpacity(0.7) : Colors.red.withOpacity(0.7),
                    // Green when extinguishing fire, red when not
                    padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Mock Robot class for demonstration purposes
class Robot {
  final databaseReference = FirebaseDatabase.instance.reference();

  void startAutoMode() {
    databaseReference.child("direction").child("moving").set("7");
  }

  void stopAutoMode() {
    databaseReference.child("direction").child("moving").set("5");
  }

  void moveForward() {
    databaseReference.child("direction").child("moving").set("8");
  }

  void stop() {
    databaseReference.child("direction").child("moving").set("5");
  }

  void moveBackward() {
    databaseReference.child("direction").child("moving").set("2");
  }

  void turnLeft() {
    databaseReference.child("direction").child("moving").set("4");
  }

  void turnRight() {
    databaseReference.child("direction").child("moving").set("6");
  }

  void extinguishFire() {
    databaseReference.child("direction").child("extinguishing").set(true);
  }

  void stopExtinguishingFire() {
    databaseReference.child("direction").child("extinguishing").set(false);
  }

// Add more methods as needed
}