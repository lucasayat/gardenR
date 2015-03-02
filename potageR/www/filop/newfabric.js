/*  Copyright (C) 2014 Jean-luc Reuillon 
  This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
  This program is distributed in the hope that it will be useful,but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
You should have received a copy of the GNU General Public License along with this program. If not, see <http://www.gnu.org/licenses/>. */

$(document).ready(function(){

var caro=40;
//var col_parcelle ="#f4efe9";
var leges =20;

var partab =[];

/*
Shiny.addCustomMessageHandler("tempar",function(par) {
 partab = eval(par);
console.log("tempar:"+partab.length);
console.log("partab de tempar:"+partab);
});
*/
var parid=[];

var parnew = "stop";
var selstop="stop";
var change;


var samid;
var nomparid;
var id_nouvelle_parcelle;

var ram1;
var ram2;
////// essai 



//////// tableau des id des icones
var legid =['aucun','artich','asperg','auber','betrav', 'chard','carot','celeriac',
'chou','conc','courg','endiv','fennel','feve','fraise',
'framb','bean','haricov','epima','onion', 'panais','leek','pois', 'pepper','potato','pum','radis','salad','tomat','turnip','spin','mache'];


var trid=['apple','apricot','cherry','pear','plum','peach','rubarb','gb'];

////// creation canvas
Shiny.addCustomMessageHandler("coorcan",function(message) {
var long=message.long;
var larg=message.larg;

var  w_canh = larg[0]*caro;
var  h_canh = long[0]*caro;

var w_cam = larg[1]*caro;
var h_cam = long[1]*caro;

var w_cab = larg[2]*caro;
var h_cab = long[2]*caro;


    var can = {
        h1 : new fabric.Canvas('canh1', {width : w_canh, height : h_canh}),
        h2 : new fabric.Canvas('canh2', {backgroundColor: 'transparent',width : w_canh, height : h_canh,})
    }; 

      var cam = {
        m1 : new fabric.Canvas('cam1', {width : w_cam, height : h_cam}),
        m2 : new fabric.Canvas('cam2', {backgroundColor: 'transparent',width : w_cam, height : h_cam,})
    };


      var cab = {
        b1 : new fabric.Canvas('cab1', {width : w_cab, height : h_cab}),
        b2 : new fabric.Canvas('cab2', {backgroundColor: 'transparent',width : w_cab, height : h_cab,})
    };




 
//var can.h1 = new fabric.Canvas('canh',{width : w_canh, height : h_canh});
////******** remplissage jardin du haut

Shiny.addCustomMessageHandler("fill_h1",function(message) {
can.h1.clear();
addgrid(can.h1,w_canh,h_canh);
addnum(can.h1,w_canh,h_canh);
var don = eval(message.leg);

//console.log("don :"+ donjson_h);
//var listicon = JSON.stringify(legid);
//Shiny.onInputChange("icon",legid);

for (var i=0 ; i < don.length ; i++)
{

   var gauche = don[i].left;
   var haut = don[i].top;
   var largeur=don[i].width;
   var hauteur = don[i].height;
   var nom = don[i].parcelle;
   var numleg=[];
   var numleg = don[i].numleg;
    var rang = don[i].nbran;
    
 //  console.log("g1 :"+gauche+"h :"+ haut+"l  :"+largeur+"h :"+hauteur+"nom :"+nom+  //"numleg :"+numleg+" rang :"+rang);
  modifad(can.h1,gauche,haut,largeur,hauteur,nom,numleg,rang,true);
 // can.h1.renderAll();
}

var tri_h=eval(message.tree);
//console.log(tri_h);

for (var j=0; j<tri_h.length;j++)
{
triad(jardin=can.h1,tree_l=tri_h[j].l,tree_t=tri_h[j].t,tree_nom=tri_h[j].nom,tree_scr=tri_h[j].scr,taille=tri_h[j].taille,tree_num=tri_h[j].num);  
}

var  allee_h =eval(message.al);
//var al_h =[{a:11,b:2,c:11,d:25},{a:2,b:10,c:11,d:10},{a:10,b:10,c:15,d:20}];
//console.log(allee_h[0].a)
allee(can.h1,allee_h);

can.h1.renderAll();

 var json = JSON.stringify(can.h1);
  Shiny.onInputChange("json_h", json);
 // console.log(json);
});



///*
Shiny.addCustomMessageHandler("fill_h2",function(message) {
 can.h2.clear();
addgrid(can.h2,w_canh,h_canh);
addnum(can.h2,w_canh,h_canh);
var don = eval(message.leg);
var parcol=eval(message.col);
//console.log("don :"+ don);

for (var i=0 ; i < don.length ; i++)
{
 
   var gauche = don[i].left;
   var haut = don[i].top;
   var largeur=don[i].width;
   var hauteur = don[i].height;
   var nom = don[i].parcelle;
   var nomleg2=JSON.stringify(don[i].legume2);
   var numleg2=[];
    var numleg2 =don[i].numleg2;
    var rang2 = don[i].nbran2;
    var parcol2 = parcol[numleg2[0]-1];
   // console.log("nomleg2 :"+nomleg2);
//   console.log("g2 :"+gauche+"h :"+ haut+"l  :"+largeur+"h :"+hauteur+"nom :"+nom+      //"numleg :"+numleg2+" rang :"+rang2);
  if (numleg2 != 1)
  {
      modifad(can.h2,gauche,haut,largeur,hauteur,nom,numleg2,rang2,false,col_parcelle=parcol2,nomleg=nomleg2);
  }
}

var tri_h=eval(message.tree);
//console.log(tri_h);

for (var j=0; j<tri_h.length;j++)
{
triad(jardin=can.h2,tree_l=tri_h[j].l,tree_t=tri_h[j].t,tree_nom=tri_h[j].nom,tree_scr=tri_h[j].scr,taille=tri_h[j].taille,tree_num=tri_h[j].num);  
}

var  allee_h =eval(message.al);
//var al_h =[{a:11,b:2,c:11,d:25},{a:2,b:10,c:11,d:10},{a:10,b:10,c:15,d:20}];
//console.log(allee_h[0].a)
allee(can.h2,allee_h);
can.h2.renderAll(); 
});
//*/
///////// fill milieu
Shiny.addCustomMessageHandler("fill_m1",function(message) {
cam.m1.clear();

addgrid(cam.m1,w_cam,h_cam);
addnum(cam.m1,w_cam,h_cam);

var don = eval(message.leg);
//console.log("don :"+ donjson_h);

for (var i=0 ; i < don.length ; i++)
{
   var gauche = don[i].left;
   var haut = don[i].top;
   var largeur=don[i].width;
   var hauteur = don[i].height;
   var nom = don[i].parcelle;
   var numleg=[];
   var numleg =don[i].numleg;
    var rang = don[i].nbran;
//    console.log("g :"+gauche+"h :"+ haut+"l  :"+largeur+"h :"+hauteur+"nom :"+nom+ //"numleg :"+numleg+" rang :"+rang);
  modifad(cam.m1,gauche,haut,largeur,hauteur,nom,numleg,rang,true);
}

var tri_m=eval(message.tree);
//console.log(tri_h);

for (var j=0; j<tri_m.length;j++)
{
triad(jardin=cam.m1,tree_l=tri_m[j].l,tree_t=tri_m[j].t,tree_nom=tri_m[j].nom,tree_scr=tri_m[j].scr,taille=tri_m[j].taille,tree_num=tri_m[j].num);  
}

var  allee_m =eval(message.al);
//var al_h =[{a:11,b:2,c:11,d:25},{a:2,b:10,c:11,d:10},{a:10,b:10,c:15,d:20}];
//console.log(allee_h[0].a)
allee(cam.m1,allee_m);

cam.m1.renderAll();
 var json = JSON.stringify(cam.m1);
 Shiny.onInputChange("json_m", json);



});


///*
Shiny.addCustomMessageHandler("fill_m2",function(message) {
cam.m2.clear();

addgrid(cam.m2,w_cam,h_cam);
addnum(cam.m2,w_cam,h_cam);
var don = eval(message.leg);
var parcol=eval(message.col);
//console.log("don :"+ don[0]);

for (var i=0 ; i < don.length ; i++)
{
   var gauche = don[i].left;
   var haut = don[i].top;
   var largeur=don[i].width;
   var hauteur = don[i].height;
   var nom = don[i].parcelle;
   var nomleg2=JSON.stringify(don[i].legume2);
   var numleg2=[];
    var numleg2 =don[i].numleg2;
    var rang2 = don[i].nbran2;
    var parcol2 = parcol[numleg2[0]-1];
    console.log("nomleg2 :"+nomleg2);
//   console.log("milieu g :"+gauche+"h :"+ haut+"l  :"+largeur+"h :"+hauteur+"nom //:"+nom+ //"numleg :"+numleg2+" rang :"+rang2);
   if (numleg2 != 1)
  {
  modifad(cam.m2,gauche,haut,largeur,hauteur,nom,numleg2,rang2,false,col_parcelle=parcol2,nomleg=nomleg2);
  
  }
}

var tri_m=eval(message.tree);
//console.log(tri_h);

for (var j=0; j<tri_m.length;j++)
{
triad(jardin=cam.m2,tree_l=tri_m[j].l,tree_t=tri_m[j].t,tree_nom=tri_m[j].nom,tree_scr=tri_m[j].scr,taille=tri_m[j].taille,tree_num=tri_m[j].num);  
}

var  allee_m =eval(message.al);
//var al_h =[{a:11,b:2,c:11,d:25},{a:2,b:10,c:11,d:10},{a:10,b:10,c:15,d:20}];
//console.log(allee_h[0].a)
allee(cam.m2,allee_m);

cam.m2.renderAll(); 

});

///////// fill bas
Shiny.addCustomMessageHandler("fill_b1",function(message) {
cab.b1.clear();
addgrid(cab.b1,w_cab,h_cab);
addnum(cab.b1,w_cab,h_cab);

var don = eval(message.leg);
//console.log("don :"+ don);

for (var i=0 ; i < don.length ; i++)
{
   var gauche = don[i].left;
   var haut = don[i].top;
   var largeur=don[i].width;
   var hauteur = don[i].height;
   var nom = don[i].parcelle;
   var numleg=[];
   var numleg =don[i].numleg;
    var rang = don[i].nbran;
//    console.log("g :"+gauche+"h :"+ haut+"l  :"+largeur+"h :"+hauteur+"nom :"+nom+ //"numleg :"+numleg+" rang :"+rang);
  modifad(cab.b1,gauche,haut,largeur,hauteur,nom,numleg,rang,true);
}

var tri_b=eval(message.tree);
//console.log(tri_h);

for (var j=0; j<tri_b.length;j++)
{
triad(jardin=cab.b1,tree_l=tri_b[j].l,tree_t=tri_b[j].t,tree_nom=tri_b[j].nom,tree_scr=tri_b[j].scr,taille=tri_b[j].taille,tree_num=tri_b[j].num);  
}

var  allee_b =eval(message.al);
//var al_h =[{a:11,b:2,c:11,d:25},{a:2,b:10,c:11,d:10},{a:10,b:10,c:15,d:20}];
//console.log(allee_h[0].a)
allee(cab.b1,allee_b);

cab.b1.renderAll();
 var json = JSON.stringify(cab.b1);
  Shiny.onInputChange("json_b", json);

});


///*
Shiny.addCustomMessageHandler("fill_b2",function(message) {
cab.b2.clear();
addgrid(cab.b2,w_cab,h_cab);
addnum(cab.b2,w_cab,h_cab);

var don = eval(message.leg);
var parcol=eval(message.col);
//console.log("don :"+ don[0]);

for (var i=0 ; i < don.length ; i++)
{
   var gauche = don[i].left;
   var haut = don[i].top;
   var largeur=don[i].width;
   var hauteur = don[i].height;
   var nom = don[i].parcelle;
   var nomleg2=JSON.stringify(don[i].legume2);
   var numleg2=[];
    var numleg2 =don[i].numleg2;
    var rang2 = don[i].nbran2;
    var parcol2 = parcol[numleg2[0]-1];
    console.log("nomleg2 :"+nomleg2);
//    console.log("g :"+gauche+"h :"+ haut+"l  :"+largeur+"h :"+hauteur+"nom :"+nom+ //"numleg :"+numleg+" rang :"+rang);
  if (numleg2 != 1)
  {
  modifad(cab.b2,gauche,haut,largeur,hauteur,nom,numleg2,rang2,false,col_parcelle=parcol2,nomleg=nomleg2);
   
  }
}
var tri_b=eval(message.tree);
//console.log(tri_h);

for (var j=0; j<tri_b.length;j++)
{
triad(jardin=cab.b2,tree_l=tri_b[j].l,tree_t=tri_b[j].t,tree_nom=tri_b[j].nom,tree_scr=tri_b[j].scr,taille=tri_b[j].taille,tree_num=tri_b[j].num);  
}

var  allee_b =eval(message.al);
//var al_h =[{a:11,b:2,c:11,d:25},{a:2,b:10,c:11,d:10},{a:10,b:10,c:15,d:20}];
//console.log(allee_h[0].a)
allee(cab.b2,allee_b);


cab.b2.renderAll();
});



//////////////fin remplissage des canvas

function allee(jardin,datal) {  
  var colal ='#abf3b4'
for (var i=0 ; i < datal.length ; i++)
{  
var a=datal[i].a;
var b=datal[i].b;
var c=datal[i].c;
var d=datal[i].d;
//var colal=datal[i].col;

jardin.add(new fabric.Line([a*caro, b*caro,c*caro, d*caro ],
          {
        stroke: colal,
        strokeWidth: 20,
      selectable: false
          }
          ));
};

};


///////////selection

can.h1.on('mouse:down',function(){
 
Shiny.onInputChange("change","GO");
setTimeout(function(){Shiny.onInputChange("change","stop")}, 50); 
var objact = can.h1.getActiveObject();

if ( objact) { 
    console.log(objact);
    nomparid = objact._objects[1].text;
    Shiny.onInputChange("OK_h","OK");
     Shiny.onInputChange("OK_m","NO");
     Shiny.onInputChange("OK_b","NO");
}else{
  
  nomparid = null;
}
Shiny.onInputChange("parsel_h",nomparid);
Shiny.onInputChange("jardin_h","H");
//console.log("nom : "+nomparid);

});


cam.m1.on('mouse:down',function(){
   
Shiny.onInputChange("change","GO");
setTimeout(function(){Shiny.onInputChange("change","stop")}, 50);
 
var objact_m = cam.m1.getActiveObject();

if ( objact_m) { 
    nomparid = objact_m._objects[1].text; 
    Shiny.onInputChange("OK_h","NO");
     Shiny.onInputChange("OK_m","OK");
     Shiny.onInputChange("OK_b","NO");
}else{
  nomparid = null;
}
Shiny.onInputChange("parsel_m",nomparid);
Shiny.onInputChange("jardin_m","M");

});


//////
cab.b1.on('mouse:down',function(){
   
Shiny.onInputChange("change","GO");
setTimeout(function(){Shiny.onInputChange("change","stop")}, 50);
 
var objact_b = cab.b1.getActiveObject();

if ( objact_b) { 
    if(objact_b._objects) {
      nomparid = objact_b._objects[1].text;
    }else{
      nomparid =null;
    }
     
    Shiny.onInputChange("OK_h","NO");
     Shiny.onInputChange("OK_m","NO");
     Shiny.onInputChange("OK_b","OK");
}else{
  nomparid = null;
}
Shiny.onInputChange("parsel_b",nomparid);
Shiny.onInputChange("jardin_b","B");
//console.log("nom_b : "+nomparid);

});


/////////creer et dessiner rectangle de parcelle

document.getElementById("pos").onclick = function()
{ 
rectad(can.h1);

};
          
 document.getElementById("pos_m").onclick = function()
{ 
rectad(cam.m1); 
};
 
 document.getElementById("pos_b").onclick = function()
{ 
rectad(cab.b1);

}; 
 
//// enregistrement


document.getElementById("rec").onclick = function() 
   {
     jarec(can.h1);
     var json = JSON.stringify(can.h1);
     Shiny.onInputChange("json_h", json);
     console.log(json)
};

document.getElementById("rec_m").onclick = function() 
   {
     jarec(cam.m1);
};

document.getElementById("rec_b").onclick = function() 
   {
     jarec(cab.b1);
};




////////// lert sur enregistrement
 var jarec =  function (jardin) {
     
      if (jardin == can.h1) {              
                                    Shiny.onInputChange("OK_h","OK");
                                    Shiny.onInputChange("OK_m","NO");
                                    Shiny.onInputChange("OK_b","NO");
                             } 
      if (jardin == cam.m1) {
                           Shiny.onInputChange("OK_h","NO");
                           Shiny.onInputChange("OK_m","OK");
                           Shiny.onInputChange("OK_b","NO");
                           } 
         
         if (jardin == cab.b1) {
                           Shiny.onInputChange("OK_h","NO");
                           Shiny.onInputChange("OK_m","NO");
                           Shiny.onInputChange("OK_b","OK");
                           } 
           if(parid[0]< 1){alert("0 rang pour cette parcelle ??")};
           
   var newparcel = new LertButton('Identifiant', function() {
    
    //////// nouvelle parcelle faire le test même parcelle sur tableau js
     var id_nouvelle_parcelle = prompt("Nom de la parcelle");
     //Shiny.onInputChange("newname", id_nouvelle_parcelle);
     Shiny.onInputChange("parnew", "stop");

     /////////test nouveau nom de parcelle existant
         nomparid = id_nouvelle_parcelle;
         var same = false;
        for(var k=0;k<partab.length;k++)
        {
          if(id_nouvelle_parcelle == partab[k]) {same =true }
          
        }
        // console.log("same :"+same);
     
     
      if (jardin == can.h1) {Shiny.onInputChange("parsel_h",id_nouvelle_parcelle );} 
      if (jardin == cam.m1) {Shiny.onInputChange("parsel_m",id_nouvelle_parcelle );}                           
      if (jardin == cab.b1) {Shiny.onInputChange("parsel_b",id_nouvelle_parcelle );}
       
  
    if ( same == true) 
      {
        alert("nom existant");
          same=false;
           return;
       } else {
        Shiny.onInputChange("parnew", "GO");
  setTimeout(function(){ Shiny.onInputChange("parnew", "stop"); },500);  
         modifad(jardin);
        partab.push(id_nouvelle_parcelle);
        
        var json = JSON.stringify(jardin);
        if (jardin == can.h1) {Shiny.onInputChange("json_h", json);} 
        if (jardin == cam.m1) {Shiny.onInputChange("json_m", json);}
        if (jardin == cab.b1) {Shiny.onInputChange("json_b", json);}
     
       }  
     
	});
   /////// modif des donnees seulement
	var modifold = new LertButton('Infos', function() {

  Shiny.onInputChange("parnew", "GO");
  modifad(jardin);
  setTimeout(function(){ Shiny.onInputChange("parnew", "stop"); },500);
   
  var json = JSON.stringify(jardin);
  if (jardin == can.h1) {Shiny.onInputChange("json_h", json);} 
   if (jardin == cam.m1) {Shiny.onInputChange("json_m", json);}
   if (jardin == cab.b1) {Shiny.onInputChange("json_b", json);}

	});
  
//////// 
  var close = new LertButton('Quitter', function() {
    return;
    
	});
  
	var message = "Modification de la parcelle :"+" "+nomparid;
  var jarecLert = new Lert(
		message,
		[newparcel,modifold,close],
		{
			defaultButton:modifold,
			icon:'i/pot.jpg'
		});

	jarecLert.display();

}
////////// nom nouvelle parcelle
 var jarecnew =  function (jardin) {
          
      if (jardin == can.h1) {              
                            Shiny.onInputChange("OK_h","OK");
                            Shiny.onInputChange("OK_m","NO");
                            Shiny.onInputChange("OK_b","NO");
                             } 
      if (jardin == cam.m1) {
                           Shiny.onInputChange("OK_h","NO");
                           Shiny.onInputChange("OK_m","OK");
                           Shiny.onInputChange("OK_b","NO");
                           } 
         
         if (jardin == cab.b1) {
                           Shiny.onInputChange("OK_h","NO");
                           Shiny.onInputChange("OK_m","NO");
                           Shiny.onInputChange("OK_b","OK");
                           } 
    
    //////// nouvelle parcelle faire le test même parcelle sur tableau js
     var id_nouvelle_parcelle = prompt("Nom de la parcelle");
    // Shiny.onInputChange("newname", id_nouvelle_parcelle);
     Shiny.onInputChange("parnew", "stop");

     /////////test nouveau nom de parcelle existant
         nomparid = id_nouvelle_parcelle;
         
         if(nomparid==null)
         {
         var delob=jardin.getActiveObject();
         jardin.remove(delob);
         return;
         }
         
         var same = false;
         if(partab)
         {
        for(var k=0;k<partab.length;k++)
        {
          if(id_nouvelle_parcelle == partab[k]) {same =true }
          
        }
         }
        // console.log("same :"+same);
     

    if ( same == true) 
      {
        alert("nom existant");
          same=false;
           return;
           
       } else {
       
       
      if (jardin == can.h1) {Shiny.onInputChange("parsel_h",id_nouvelle_parcelle );} 
      if (jardin == cam.m1) {Shiny.onInputChange("parsel_m",id_nouvelle_parcelle );}                           
      if (jardin == cab.b1) {Shiny.onInputChange("parsel_b",id_nouvelle_parcelle );}
         
        Shiny.onInputChange("parnew", "GO");
        setTimeout(function(){ Shiny.onInputChange("parnew", "stop"); },500);  
         modifad(canvas=jardin);
        partab.push(id_nouvelle_parcelle);
        //console.log("partab apres push"+partab);
        
        var json = JSON.stringify(jardin);
        
        if (jardin == can.h1) {Shiny.onInputChange("json_h", json);} 
        if (jardin == cam.m1) {Shiny.onInputChange("json_m", json);}
        if (jardin == cab.b1) {Shiny.onInputChange("json_b", json);}
        
        
   
       }  
       

}

/////////supprimer parcelle

   document.getElementById("del").onclick = function() 
   {           
    function deleteObject(){
      var delobj = can.h1.getActiveObject();
     // console.log(delobj._objects[1].text);
      if (delobj)
             {
      Shiny.onInputChange("parnew","stop");
        if(delobj._objects)
        {
      var parsup = delobj._objects[1].text;
        var del_h = confirm("Supprimer la parcelle :"+parsup+" ?")
          if(del_h==true) 
         {
      Shiny.onInputChange("parsup", parsup);
      
      var index = partab.indexOf(parsup);
      partab.splice(index, 1);
     // console.log("new partab: "+partab);
      
       can.h1.remove(delobj);
         }
         }else{
           can.h1.remove(delobj);
            }
             }
             
      };
   
deleteObject();

 var json = JSON.stringify(can.h1);
  Shiny.onInputChange("json_h", json); 
};

//////////

   document.getElementById("del_m").onclick = function() 
   {           
    function deleteObject(){
      var delobj = cam.m1.getActiveObject();
     // console.log(delobj);
      if (delobj)
             {
      Shiny.onInputChange("parnew","stop");
        if(delobj._objects)
        {
      var parsup = delobj._objects[1].text; 
        var del_m = confirm("Supprimer la parcelle :"+parsup+" ?")
          if(del_m==true) 
         {
      Shiny.onInputChange("parsup", parsup);
      
      var index = partab.indexOf(parsup);
      partab.splice(index, 1);
       cam.m1.remove(delobj);
         }
         
        }else{
           cam.m1.remove(delobj);
            }
             }
             
      };
   
deleteObject();

 var json = JSON.stringify(cam.m1);
  Shiny.onInputChange("json_m", json); 
};

/////
   document.getElementById("del_b").onclick = function() 
   {           
    function deleteObject(){
      var delobj = cab.b1.getActiveObject();
      //console.log(delobj);
      if (delobj)
             {
      Shiny.onInputChange("parnew","stop");
        if(delobj._objects)
        {

      var parsup = delobj._objects[1].text; 
      var del_b = confirm("Supprimer la parcelle :"+parsup+" ?")
          if(del_b==true) 
         {
        Shiny.onInputChange("parsup", parsup);
      
      var index = partab.indexOf(parsup);
      partab.splice(index, 1);
      
       cab.b1.remove(delobj); 
          }
          }else{
          cab.b1.remove(delobj);
          }
            }            
      };
   
deleteObject();

 var json = JSON.stringify(cab.b1);
  Shiny.onInputChange("json_b", json); 
};

////


//////////////// grid add remove

 $("#grid").click(function() {
addgrid(can.h1,w_canh,h_canh);
addgrid(can.h2,w_canh,h_canh);

addnum(can.h1,w_canh,h_canh);
addnum(can.h2,w_canh,h_canh);

});

 $("#grid_m").click(function() {
addgrid(cam.m1,w_cam,h_cam);
addgrid(cam.m2,w_cam,h_cam);

addnum(cam.m1,w_cam,h_cam);
addnum(cam.m2,w_cam,h_cam);

});


 $("#grid_b").click(function() {
addgrid(cab.b1,w_cab,h_cab);
addgrid(cab.b2,w_cab,h_cab);

addnum(cab.b1,w_cab,h_cab);
addnum(cab.b2,w_cab,h_cab);

});

//************************Remove Grid***************
$("#ungrid").click(function () {
 ungrid(can.h1);
  delem(can.h1,'text');
 ungrid(can.h2);
  delem(can.h2,'text');
});

 $("#ungrid_m").click(function () {
 ungrid(cam.m1);
  delem(cam.m1,'text');
 ungrid(cam.m2);
  delem(cam.m2,'text');
});
 
 $("#ungrid_b").click(function () {
 ungrid(cab.b1);
  delem(cab.b1,'text');
 ungrid(cab.b2);
  delem(cab.b2,'text');
}); 
 
/////////// choix couleur du fond

var couleur_h = document.getElementById('colh');        
  $("#gocolh").click(function () {
  can.h1.backgroundColor=couleur_h.value;
  can.h1.renderAll();
  can.h2.backgroundColor=couleur_h.value;
  can.h2.renderAll();
  Shiny.onInputChange("couleur_h", couleur_h.value);
     });

var couleur_m = document.getElementById('colm');         
  $("#gocolm").click(function () {
  cam.m1.backgroundColor=couleur_m.value;
  cam.m1.renderAll();
  cam.m2.backgroundColor=couleur_m.value;
  cam.m2.renderAll();
  Shiny.onInputChange("couleur_m", couleur_m.value);
     });



var couleur_b = document.getElementById('colb');         
  $("#gocolb").click(function () {
  cab.b1.backgroundColor=couleur_b.value;
  cab.b1.renderAll();
  cab.b2.backgroundColor=couleur_b.value;
  cab.b2.renderAll();
  Shiny.onInputChange("couleur_b", couleur_b.value);
     });
     
var coulparam = document.getElementById('colparam'); 
  $("#gocolparam").click(function () {
  Shiny.onInputChange("couleg", coulparam.value);
     }); 
     
var coulal = document.getElementById('colR'); 
  $("#gocolex").click(function () {
  Shiny.onInputChange("colex", coulal.value);
     });

///////////////////image png
   document.getElementById("png").onclick = function() 
   { 
  window.open(can.h1.toDataURL('picong'), "");
            can.h1.forEachObject(function(o){
                if(o.get("title") == "||Watermark||"){
                    can.h1.sendToBack(o);
                }
            });
            can.h1.renderAll();
};

   document.getElementById("png_m").onclick = function() 
   { 
  window.open(cam.m1.toDataURL('picong'), "");
            cam.m1.forEachObject(function(o){
                if(o.get("title") == "||Watermark||"){
                    cam.m1.sendToBack(o);
                }
            });
            cam.m1.renderAll();
};

   document.getElementById("png_b").onclick = function() 
   { 
  window.open(cam.m1.toDataURL('picong'), "");
            cab.b1.forEachObject(function(o){
                if(o.get("title") == "||Watermark||"){
                    cab.b1.sendToBack(o);
                }
            });
            cab.b1.renderAll();
};

////// envoi donnees sur legume et nbrangs pour modifad

Shiny.addCustomMessageHandler("parcelid",function(tablid) 
{
parid = eval(tablid);
//console.log("parid :"+ parid);
//console.log("rang1 :" + parid[0]+"rang2 :"+parid[1]+" nbumleg1 :"+parid[2]+"leg2 //:"+ parid[3]);
});
//console.log("parid :"+ parid);

////

////////// fonction add et modif
function modifad (canvas,par_l,par_t,par_w,par_h,par_nom,numleg,rang, select,col_parcelle,nomleg){
   
  //var jardin = can.h1
   var echelle = 0.8;
    var obj = canvas.getActiveObject();
   
    console.log(obj);
    if (col_parcelle && rang==0) {col_parcelle=col_parcelle;}else{col_parcelle ="#f4efe9";}       
    if (nomleg) {nomleg_par=nomleg+"Per2";}else{ nomleg_par="";}      
    
   if(obj)
   {
   var par_l = obj.left;
  // console.log("parleft :"+par_l);
   //var essai = obj.get('left');
   //console.log("essai :"+essai);
    if(par_l<0) {par_l=obj.originalLeft;
   //console.log("origLeft :"+obj.originalLeft);    
                }
   var par_t =  obj.top;
    if(par_t<0) {par_t = obj.originalTop}
   var par_w = obj.currentWidth;
   var par_h = obj.currentHeight;
   var par_nom = nomparid;
   var numleg = parid[2];
   var rang = parid[0];
   var select = true;
   }

  var parect = new fabric.Rect({
    left: 0,
    top: 0,
    width:par_w ,
    height:par_h ,
    padding: 0,
    centeredScaling: false    
  });
  
  parect.set('fill', col_parcelle);
  parect.setShadow("5px 5px 2px rgba(94, 128, 191, 0.5)");
  parect.set({ strokeWidth: 3, stroke: '#c4dcf3'});
  
  var partext = new fabric.Text( par_nom,
  {
    left : 0,
    top : 0,
    fontSize: 12,
    fontWeight : 'bold',
    textAlign: "left",
    fill: 'red'
  });

  var parnomleg = new fabric.Text( nomleg_par,
  {
    left : 2,
    top : 15,
    fontSize: 12,
    fontWeight : 'bold',
    textAlign: "left",
    fill: 'blue'
  });



var tab=[parect,partext,parnomleg];


//console.log("numleg ;"+numleg+'rajgs :'+rang);

//if(numleg == 0)  {var rang = 0}

if (par_h>par_w) {
  var esprang = Math.round((par_w)/rang)*0.9;
  var lonrang = Math.round(par_h/leges)-1;
  
}else{
 var esprang = Math.round(par_h/rang)*0.9 ;
 var lonrang = Math.round(par_w/leges)-1;
 partext.setAngle(-90);
 partext.setLeft(-5);
 partext.setTop(par_h*0.9);
}

var legin = 0;

if (numleg != 1) 
{
//for (var l=0 ; l < rang; l++)
//{
for (var t=0 ; t < lonrang; t++)
{
for (var l=0 ; l < rang; l++)
{
 
var img = document.getElementById(legid[numleg[legin]-1]);
if(legin < numleg.length-1) 
{legin=legin+1;
}else{
  legin = 0;
}
var imagin = new fabric.Image(img, {
});
// console.log("image ;"+img+"scr :"+legid[numleg]);
 
 if (par_h>par_w) {
  imagin.set({ left :  l*esprang });
  imagin.set({top :15+ t*leges});
}else{ 
  imagin.set({ top : par_h*0.05 + l*esprang });
  imagin.set({left : 15 +t*leges});
 
}
  imagin.scale(echelle);  
  tab.push(imagin);
}}
}else{
var img = document.getElementById(legid[0]);
var imagin = new fabric.Image(img, {
  left : par_w/3,
  top : par_h/3
});
imagin.scale(echelle);
 tab.push(imagin); 
}


var groupir = new fabric.Group(tab, {
  left: par_l,
  top: par_t,
  width:par_w ,
  height:par_h ,
  lockRotation:true,
  selectable: select
});
//groupir.set({ left: obj.left, top: obj.top });
groupir.set('borderColor', 'red');
groupir.set('cornerColor','red');
groupir.set('cornerSize',12);
groupir.set('hoverCursor','pointer');
//groupir.setShadow("10px 10px 5px rgba(94, 128, 191, 0.5)");
//groupir.set('hoverCursor','all-scroll');

var pardim =[par_l,par_t,par_w,par_h]
//console.log("pardim :"+ pardim)
canvas.add(groupir);
canvas.remove(obj);
canvas.renderAll();
//selstop="GO";
  
}
////////// fonction arbre fruitiers non selectable
function triad (jardin,tree_l,tree_t,tree_nom,tree_scr,taille,tree_num){
  
  var parect = new fabric.Rect({
    left: 0,
    top: 0,
    width:50,
    height:70 ,
    padding: 0,
    centeredScaling: false
    
  });
 
  parect.set('fill', 'transparent');
  
  var partext = new fabric.Text( tree_num+"_"+tree_nom,
  {
    left : 0,
    top : 0,
    fontSize: 12,
    fontWeight : 'bold',
    textAlign: "center",
    fill: 'blue'
  });


 var img = document.getElementById(trid[tree_scr-1]);
var imagin = new fabric.Image(img, {
  left : 10,
  top : 20,
});

imagin.scale(taille);

var tree_tab=[parect,partext,imagin];

var tree_group = new fabric.Group(tree_tab, {
   left: tree_l*caro,
   top: tree_t*caro,  
   selectable: false
});
//groupir.set({ left: tree_l, top: tree_t});

//console.log("tree_tab :"+tree_tab);

jardin.add(tree_group);

jardin.renderAll();
//selstop="GO";
  
}


/////////////fonctions grid

function addgrid(jardin,w,h) {
  var grid = caro;
  var max=Math.max(w,h);

for (var i = 0; i < (max / grid); i++) {
  jardin.add(new fabric.Line([ i * grid, 0, i * grid, max], { stroke: '#999', selectable: false , sendToBack: true}));


}
for (var i = 0; i < (max / grid); i++) {   
  jardin.add(new fabric.Line([ 0, i * grid, max, i * grid], { stroke: '#999', selectable: false ,  sendToBack: true }))

} 
  
}

/////////////fonctions addnum

function addnum(jardin,w,h) {
  var grid = caro;
//  var w = w_canh;
//  var h = h_canh;
 // var max=Math.max(w,h);

for (var i = 0; i < (w / grid); i++) {
  
jardin.add(new fabric.Text(i+1+"",{left:grid*(i+0.8),top:0,fontSize:10,fill:'blue',
selectable:false}));


}
for (var i = 0; i < (h / grid); i++) {   

jardin.add(new fabric.Text((i+1).toString(),{left:5,top:grid*(i+0.7),fontSize:10,fill:'blue',
selectable:false}));

} 
  
}

//////////// delem oter element par son type
function delem(jardin,typelem) {
    var canObject = new Array();
    canObject = jardin.getObjects();
   
    while(1){
      for(var tempObjNumber = 0;tempObjNumber<canObject.length;tempObjNumber++){
        if(jardin.item(tempObjNumber).type == typelem )
        {
         
         jardin.item(tempObjNumber).remove();
          jardin.renderAll();
        }
      }
      jardin.renderAll();
      canObject = jardin.getObjects();
      var textStatus = false;
      for(var tempObjNumber = 0;tempObjNumber<canObject.length;tempObjNumber++){
        if(jardin.item(tempObjNumber).type == typelem){
          textStatus = true;
        }
      }
      if(textStatus){
        canObject = jardin.getObjects();
        continue;
      }else{
        break;
      }       
    }
    
  };


/////////////oter la grille sans les allées
///*
function ungrid(jardin) {
    var canObject = new Array();
    canObject = jardin.getObjects();
   
    while(1){
      for(var tempObjNumber = 0;tempObjNumber<canObject.length;tempObjNumber++){
        if(jardin.item(tempObjNumber).type == 'line' && jardin.item(tempObjNumber).stroke == '#999')
        {
         
         jardin.item(tempObjNumber).remove();
          jardin.renderAll();
        }
      }
      jardin.renderAll();
      canObject = jardin.getObjects();
      var lineStatus = false;
      for(var tempObjNumber = 0;tempObjNumber<canObject.length;tempObjNumber++){
        if(jardin.item(tempObjNumber).type == 'line' && jardin.item(tempObjNumber).stroke == '#999'){
          lineStatus = true;
        }
      }
      if(lineStatus){
        canObject = jardin.getObjects();
        continue;
      }else{
        break;
      }       
    }
    
  };
  //*/


 ///////////////creer le rectangle de la parcelle (bouton creer)
 function rectad(jardin){

               jardin.isDrawingMode=false;
                //Declaring the variables
                var canDraw = true;
                var rec=true;
                var isMouseDown=false;
                var OriginX=new Array();
                var OriginY= new Array();               
                var refRect;
                var ram1=jardin._offset.left;
                var ram2=jardin._offset.top;  
                
               // var ram1=495.2812805175781;
                //var ram2=259.74307175292967;
              // console.log("ram1 ="+ram1); 
               //console.log("ram2 ="+ram2); 
                
                if( canDraw && ram1>10) {               
                //Setting the mouse events
                jardin.on('mouse:down',function(event){
                    //Defining the procedure
                    isMouseDown=true;
                    OriginX=[];
                    OriginY=[];
                       
                    //Getting the mouse Co-ordinates
                 
                    var posX=event.e.pageX;
                    var posY=event.e.pageY;
                       
                    OriginX.push(posX-ram1);
                    OriginY.push(posY-ram2);
                  // console.log("originX :"+ OriginX);
                    
                    //Creating the rectangle object
                    var rect=new fabric.Rect({
                        left:OriginX[0],
                        top:OriginY[0],
                        strokeWidth:2,
                        borderColor:"red",
                        fill:'lightgreen'
                    });
                                         
                    jardin.add(rect);
                   rect.lockRotation=true;
                   refRect = rect;  //**Reference of rectangle object
                  // console.log(rect);
                });
                }
   
                jardin.on('mouse:move', function(event){
                    // Defining the procedure
                  if(refRect) {
                    if(canDraw) {
                        //Getting the mouse Co-ordinates
                                   
                        var posX=event.e.pageX-ram1;
                        var posY=event.e.pageY-ram2;
                                              
                        refRect.setWidth(Math.abs((posX-refRect.get('left'))));
                        refRect.setHeight(Math.abs((posY-refRect.get('top'))));                                                 

                       refRect.setCoords();
                       // console.log(refRect);
                       jardin.setActiveObject(refRect);
                       refRect.active=true;
                       jardin.renderAll(); 
                         
                     }} 
                     

   });               
               
                jardin.on('mouse:up',function(){ 
                 // jardin.calcOffset(); 
                canDraw = false; 
                
                if(rec && refRect ) {
                 jarecnew(jardin);                       
                  rec = false;
          //setTimeout(function(){ jardin.deactivateAll().renderAll(); },500);   
               jardin.deactivateAll().renderAll();                           
                }
                
                
                });

 }
 
 ////////// rectriction aux limites du 
 function limit(jardin) {
   
jardin.on('object:moving', function (e) {
        var obj = e.target;
    // if object is too big ignore
     // console.log("objet move"+obj);
    //if(obj.currentHeight > obj.canvas.height || obj.currentWidth > obj.canvas.width
    //   ){return;}        
        obj.setCoords();        
        // top-left  corner
        if(obj.getBoundingRect().top < 0 || obj.getBoundingRect().left < 0){
            obj.top = Math.max(obj.top, obj.top-obj.getBoundingRect().top);
            obj.left = Math.max(obj.left, obj.left-obj.getBoundingRect().left);
        }
        // bot-right corner
        if(obj.getBoundingRect().top+obj.getBoundingRect().height  > obj.canvas.height || obj.getBoundingRect().left+obj.getBoundingRect().width  > obj.canvas.width){
            obj.top = Math.min(obj.top, obj.canvas.height-obj.getBoundingRect().height+obj.top-obj.getBoundingRect().top);
            obj.left = Math.min(obj.left, obj.canvas.width-obj.getBoundingRect().width+obj.left-obj.getBoundingRect().left);
        }
});
 };
 limit(can.h1);
 limit(cam.m1);
 limit(cab.b1);
////////////
 
}); 

});