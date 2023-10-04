/*  web app's Firebase configuration*/
const firebaseConfig = {
  apiKey: "AIzaSyBRaAW_JZDkD2SwhXvnHKNNNx8TJdaEOZI",
  authDomain: "iot3-flutter.firebaseapp.com",
  databaseURL: "https://iot3-flutter-default-rtdb.firebaseio.com",
  projectId: "iot3-flutter",
  storageBucket: "iot3-flutter.appspot.com",
  messagingSenderId: "201871774286",
  appId: "1:201871774286:web:5fb86d32bed7f9163c691f",
  measurementId: "G-JVRGQK8ZZE"
};

    /*Initialize Firebase*/
    firebase.initializeApp(firebaseConfig);
      
    /*reference of database*/
    var firebaseRef = firebase.database().ref();
  
    /*to read the value of the child reading from firebase to define the current moving and print it in status in web*/
  firebaseRef.on("value", (snapshot) => { /*value means as it is in firebase as it changes*/
    var moving = snapshot.child("direction").child("moving").val(); /*.val means the value right now in firebase in the flame sensor*/
    
    /*self means open fire.html in the same tab*/
    if (moving==7 && snapshot.child("reading").child("temperature").val() >= 60) {
      window.open("fire.html", "_self");
    }
    
    if (moving==8) {
      moving = "Moving upward"
    } else if (moving==5) {
      moving = "Stopped";
    } else if (moving==4) {
      moving = "Moving leftward";
    } else if (moving==6) {
      moving = "Moving rightward";
    } else if (moving==2) {
      moving = "Moving downward";
    } else if (moving==7) {
      moving = "Auto mode";
    }
    document.getElementById("status").textContent=moving;   /*connecting the variable (moving) of javascript with variable of html that defines the current moving(status)*/
  });
  /*to write in firebase the value of the moving according to the clicked arrow to move the robot*/ 
  /*element with id up is when we click the arrow to move upward*/
  /*add event listner is the function that excutes the up function when we click*/
document.getElementById("up").addEventListener('click', up); /*click means when we click the mouse*/
function up() { /*fuction that changes the value of the moving in firebase */
    firebaseRef.child("direction").update({ 
        moving: '8' 
      });
  }
document.getElementById("left").addEventListener('click', left);
function left() {
    firebaseRef.child("direction").update({
        moving: '4'
      });
}
document.getElementById("right").addEventListener('click', right);
function right() {
  firebaseRef.child("direction").update({
        moving: '6'
      });
}
document.getElementById("down").addEventListener('click', down);
function down() {
  firebaseRef.child("direction").update({
        moving: '2'
      });
}
document.getElementById("stop").addEventListener('click', stop);
function stop() {
  firebaseRef.child("direction").update({
        moving: '5'
      });
}
document.getElementById("auto").addEventListener('click', auto);
function auto() {
  firebaseRef.child("direction").update({
    moving: '7'
  });
}

/*connecting the variables of javascript with variables of html (the whole circle)*/
var flameCircularBar = document.getElementById("flameCircularBar");
var gasCircularBar = document.getElementById("gasCircularBar");
var tempCircularBar = document.getElementById("tempCircularBar");

/*connecting the variables of javascript with variables of html(the readings)*/
var flameValue = document.getElementById("flameValue");
var gasValue = document.getElementById("gasValue");
var tempValue = document.getElementById("tempValue");

/*connecting values of the child reading in firebase with the coreesponding variable in javascript*/
firebaseRef.child("reading").on("value", (snapshot) => { /*value means as it is in firebase as it changes*/
  var flameSensor = snapshot.child("flameSensor").val(); /*.val means the value right now in firebase in the flame sensor*/
  var gasSensor = snapshot.child("gasSensor").val();
  var temperature = snapshot.child("temperature").val();

/*giving the javascript variable the value of the reading*/
  flameValue.textContent=flameSensor; 
  gasValue.textContent=gasSensor;
  tempValue.textContent=temperature;

  temperature = temperature+40; /*sensor begins from -40 so to make 0=40(the min)*/
  gasSensor = gasSensor-300; /*sensor begins from 300 so to make 0=300(the min)*/

  /*to have the percentage of the total we divide on the total and then we multiply with maximum degree (360 circle angle)*/
  /*to change the color of the circle border according to the percentage of the readings from total the circle*/
  flameCircularBar.style.background = `conic-gradient(#02a44d ${flameSensor/100*360}deg, #d3d3d3 0deg)`; 
  gasCircularBar.style.background = `conic-gradient(#018ace ${gasSensor/9700*360}deg, #d3d3d3 0deg)`;
  tempCircularBar.style.background = `conic-gradient(#Ce0106 ${temperature/120*360}deg, #d3d3d3 0deg)`;
});