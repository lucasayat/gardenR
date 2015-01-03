/////// arbres jardin1
 $(document).ready(function() {
var valarb1="off";
  document.getElementById("adarb1").onclick = function() 
      {
      var valarb1="on"
      Shiny.onInputChange("adtree1", valarb1);
       valarb1 = "off"
      setTimeout(function(){Shiny.onInputChange("adtree1",valarb1)}, 50);
      
       };
  

document.getElementById("suparb1").onclick = function() 
   {
       var elimarb1 =0;
       Shiny.onInputChange("suptree1", elimarb1);
       numarb1=prompt("Numero à supprimer?:");
       if (numarb1==null) {
          elimarb1= 0;    
          }else{
       suparbre1 = confirm("Supprimer la ligne"+numarb1+"?");
       if( suparbre1== true) {
          elimarb1=numarb1; 
          }else{
         elimarb1 = 0;   
       }}
        Shiny.onInputChange("suptree1", elimarb1);
       };

/// allees jardin1

document.getElementById("adal1").onclick = function() 
      {
      var alajout1="on"
      Shiny.onInputChange("adallee1", alajout1);
       alajout1 = "off"
      setTimeout(function(){Shiny.onInputChange("adallee1",alajout1)}, 50);
       };
  


document.getElementById("supal1").onclick = function() 
   {
       var elimal1 =0;
       Shiny.onInputChange("supallee1", elimal1);
       numallee1=prompt("Numero à supprimer?:");
       if (numallee1==null) {
        elimal1= 0;
          }else{
       supallee1 = confirm("Supprimer la ligne"+numallee1+"?");
       if( supallee1== true) {
          elimal1=numallee1; 
          }else{
         elimal1 = 0;   
       }}
        Shiny.onInputChange("supallee1", elimal1);
       };
  
 /////////// arbres jardin2 
var valarb2="off";
  document.getElementById("adarb2").onclick = function() 
      {
      var valarb2="on"
      Shiny.onInputChange("adtree2", valarb2);
       valarb2 = "off"
      setTimeout(function(){Shiny.onInputChange("adtree2",valarb2)}, 50);
      
       };
  

document.getElementById("suparb2").onclick = function() 
   {
       var elimarb2 =0;
       Shiny.onInputChange("suptree2", elimarb2);
       numarb2=prompt("Numero à supprimer?:");
       if (numarb2==null) {
          elimarb2= 0;    
          }else{
       suparbre2 = confirm("Supprimer la ligne"+numarb2+"?");
       if( suparbre2== true) {
          elimarb2=numarb2; 
          }else{
         elimarb2 = 0;   
       }}
        Shiny.onInputChange("suptree2", elimarb2);
       };

/// allees jardin2

document.getElementById("adal2").onclick = function() 
      {
      var alajout2="on"
      Shiny.onInputChange("adallee2", alajout2);
       alajout2 = "off"
      setTimeout(function(){Shiny.onInputChange("adallee2",alajout2)}, 50);
       };
  


document.getElementById("supal2").onclick = function() 
   {
       var elimal2 =0;
       Shiny.onInputChange("supallee2", elimal2);
       numallee2=prompt("Numero à supprimer?:");
       if (numallee2==null) {
        elimal2= 0;
          }else{
       supallee2 = confirm("Supprimer la ligne"+numallee2+"?");
       if( supallee2== true) {
          elimal2=numallee2; 
          }else{
         elimal2 = 0;   
       }}
        Shiny.onInputChange("supallee2", elimal2);
       };   
////////// jardin3
/////////// arbres jardin3 
var valarb3="off";
  document.getElementById("adarb3").onclick = function() 
      {
      var valarb3="on"
      Shiny.onInputChange("adtree3", valarb3);
       valarb3 = "off"
      setTimeout(function(){Shiny.onInputChange("adtree3",valarb3)}, 50);
      
       };
  

document.getElementById("suparb3").onclick = function() 
   {
       var elimarb3 =0;
       Shiny.onInputChange("suptree3", elimarb3);
       numarb3=prompt("Numero à supprimer?:");
       if (numarb3==null) {
          elimarb3= 0;    
          }else{
       suparbre3 = confirm("Supprimer la ligne"+numarb3+"?");
       if( suparbre3== true) {
          elimarb3=numarb3; 
          }else{
         elimarb3 = 0;   
       }}
        Shiny.onInputChange("suptree3", elimarb3);
       };

/// allees jardin3

document.getElementById("adal3").onclick = function() 
      {
      var alajout3="on"
      Shiny.onInputChange("adallee3", alajout3);
       alajout3 = "off"
      setTimeout(function(){Shiny.onInputChange("adallee3",alajout3)}, 50);
       };
  


document.getElementById("supal3").onclick = function() 
   {
       var elimal3 =0;
       Shiny.onInputChange("supallee3", elimal3);
       numallee3=prompt("Numero à supprimer?:");
       if (numallee3==null) {
        elimal3= 0;
          }else{
       supallee3 = confirm("Supprimer la ligne"+numallee3+"?");
       if( supallee3== true) {
          elimal3=numallee3; 
          }else{
         elimal3 = 0;   
       }}
        Shiny.onInputChange("supallee3", elimal3);
       };   
/////////////// fin   
 });       
