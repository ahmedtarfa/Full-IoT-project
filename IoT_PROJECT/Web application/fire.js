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

    
      var temp = document.getElementById("temp");
    
    firebaseRef.on("value", (snapshot) => {
      temp.textContent=snapshot.child("reading").child("temperature").val();
    });

    document.getElementById("off").addEventListener('click', off);
    function off() {
      firebaseRef.child("direction").update({
        moving: '5'
      });
      window.open("move.html", "_self");
  }