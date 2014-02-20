var app = {
    // Application Constructor
    initialize: function() {
        this.bindEvents();
    },
    // Bind Event Listeners
    //
    // Bind any events that are required on startup. Common events are:
    // 'load', 'deviceready', 'offline', and 'online'.
    bindEvents: function() {
        document.addEventListener('deviceready', this.onDeviceReady, false);
    },
    // deviceready Event Handler
    //
    // The scope of 'this' is the event. In order to call the 'receivedEvent'
    // function, we must explicity call 'app.receivedEvent(...);'
    onDeviceReady: function() {
        app.receivedEvent('deviceready');
    },
    // Update DOM on a Received Event
    receivedEvent: function(id) {
        console.log('Received Event: ' + id);
    }
};

//------------------------------------------------------------------------------------------------------------------
$(document).ready(function() {

var BirdWings= "up";
var FastFallSpeed = -10;

var myClock = setInterval(function(){myClockWork()},100);

function myClockWork()
{
 if ($("#bird").position().top>2000)
 {
   //game over
   $("#bird").css({"left": "0px"});
   $("#bird").css({"top": "400px"});
  FastFallSpeed = -10;
 } else
 {
   FastFallSpeed = FastFallSpeed + 10;

   $("#bird").css({"left": ($("#bird").position().left+10)+"px"} );
   $("#bird").css({"top": ($("#bird").position().top+FastFallSpeed)+"px"} );

   if (BirdWings=="up")
   {
      $("#bird").attr("src","img/flappy/fly2.png");
      BirdWings="down";
   } else
   if (BirdWings=="down")
   {
      $("#bird").attr("src","img/flappy/fly1.png");
      BirdWings="up";
   }
 }
}


$(document).bind('touchstart click', function(){
 FastFallSpeed = -30;
 $("#bird").css({"top": ($("#bird").position().top-60)+"px"} );
});


});

