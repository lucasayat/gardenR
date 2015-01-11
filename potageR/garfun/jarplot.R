#  Copyright (C) 2014 Jean-luc Reuillon
#  This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
#  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#  You should have received a copy of the GNU General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.


param <- read.csv("data/param.csv",stringsAsFactors =FALSE)

caro<-40
an<-2015

############# fonction dessin jardin
aucun<-readPNG("www/aucun.png")
auber<-readPNG("www/auber.png")
asperg<-readPNG("www/asperg.png")
artich<-readPNG("www/artich.png")
bean<-readPNG("www/bean.png")
betrav<-readPNG("www/betrav.png")
carot<-readPNG("www/carot.png")
celeriac<-readPNG("www/celeriac.png")
chard<-readPNG("www/chard.png")
chou<-readPNG("www/chou.png")
conc<-readPNG("www/conc.png")
courg<-readPNG("www/courg.png")
endiv<-readPNG("www/endiv.png")
epima<-readPNG("www/epima.png")
fennel<-readPNG("www/fennel.png")
feve<-readPNG("www/feve.png")
fraise<-readPNG("www/fraise.png")
framb<-readPNG("www/framb.png")
haricov<-readPNG("www/haricov.png")
leek<-readPNG("www/leek.png")
onion<-readPNG("www/onion.png")
panais<-readPNG("www/panais.png")
pepper<-readPNG("www/pepper.png")
pois<-readPNG("www/pois.png")
potato<-readPNG("www/potato.png")
pum<-readPNG("www/pum.png")
radis<-readPNG("www/radis.png")
salad<-readPNG("www/salad.png")
tomat<-readPNG("www/tomat.png")
turnip<-readPNG("www/turnip.png")
spin<-readPNG("www/spin.png")
mache<-readPNG("www/mache.png")
###########


jardin<-function (lon,lar,titre=""){
  
  par(bty="n",bg="transparent",mar=c(5,5,6,3))
  
  plot(lon,lar,cex=0,axes=F,main="",
       xlim=c(0,lar),ylim= c(0,lon),
       ylab="",xlab="",cex.axis=0.5)
  color<-"blue"
  axis(2,  lon:0, 0:lon,lwd=0.5,las=2,cex.axis=0.8,col=color,col.axis=color)
  axis(1,  0:lar, 0:lar,lwd=0.5,las=1,cex.axis=0.8,col=color,col.axis=color)
  axis(3,  0:lar, 0:lar,lwd=0.5,las=1,cex.axis=0.8,col=color,col.axis=color)
  axis(4,  lon:0, 0:lon,lwd=0.5,las=2,cex.axis=0.8,col=color,col.axis=color)
 
  mtext("Largeur (X)", side=1, line=3, col="purple", cex=2)
  mtext("Longueur (Y)", side=2, line=3, col="purple", cex=2)
    #grid(nx=lar+1,ny=lon+1,col = "red", lty = 1, lwd = 0.5)
     grid(col = "blue", lty = 1, lwd = 0.5)
  abline(h=0:lon, v=0:lon, col="gray", lty=3)
  
}
############# dessin des allées

coloral<-function  (coli,lini,cole,line,coul="green",lib="",or=0,gros=0.8){
  rect(coli,lini,cole,line,col=coul,border=NA)
  text((coli+cole)/2,(lini+line)/2,labels=lib,srt=or,cex=gros)
}


###############

chemin <-function  (N=c(0.2,0.5,0.1,0.5)) {
  par(mar=c(0,0,0,0))
  plot.new()
  coul<-"yellow"
  rect(0,0,1,1,border=coul,col=coul)
  text(0.5,0.5,"Chemin de Reilhat",cex=2)
  arrows(N[1],N[2],N[3],N[4],lwd=5,col="blue",code=2)
  x<-ifelse(N[1]>N[3],N[3]-0.05,N[3]+0.05)
  text(x,N[4],"N",col="blue",cex=3)
  
}
###### legumes en planches de couleur
lablist <-function(a){
  if(length(a)>0)
   lab<-a[[1]][1]
  if(length(a[[1]])>1)
  {
   for (i in 2:length(a[[1]]))
   {
     lab<-paste(lab,",",a[[1]][i])
   }}
  return(lab)
}


careleg<- function (colegi,linegi,colege,linege,
                coul="green",legs="",texver="H") 
{
    
  or<-ifelse(texver=="H",0,90)
  xbot<-min(colegi,colege)
  ybot<-min(linegi,linege)
  xtop<-max(colegi,colege)
  ytop<-max(linegi,linege)

  rect(xbot,ybot,xtop,ytop,border="blue",lwd=1,col=coul)
  text ((xbot+xtop)/2,(ybot+ytop)/2,labels=lablist(legs),font=2,srt=or,
         col="black")
 
}


###############calendrier legume
editleg<-function(a){
  #  a<-list("a","b","c")
  
  text<-rep("",length(a))
  for (l in 1:length(a))
  {
    for (k in 1:length(a[[l]]))
    {
      text[l]<-ifelse (k==1,text[l]<-a[[l]][k],
      text[l]<-paste(text[[l]],a[[l]][k],sep="-")) 
    }  
  }
  return(text)
}


 planleg <-function(data,date=Sys.Date(),icon=FALSE,an) {
   #  data<-don14;  icon <-TRUE ; an=2014
    
   par(mar=c(5,6,5,6))
  par(bg="transparent")
  g<-subset(data,select=c("datesem","dateplant","daterec",
            "finrec","datesem2","dateplant2","daterec2","finrec2"))
  
  for(i in 1:length(data$legume)) {g$legume[i]<-list(c(data$legume[[i]]))}
  for(j in 1:length(data$legume2)) {g$legume2[j]<-list(c(data$legume2[[j]]))}
  #g<-g[which(duplicated(g$legume)==FALSE),]
  g<-g[order(g$datesem),]
  
 coul<-c("yellow","green","cyan2","orange","darkgreen","cyan3")
 gros<-1
 
  sem<-as.Date(g$datesem)
  plant<-as.Date(g$dateplant)
  rec<-as.Date(g$daterec)
  finrec<-as.Date(g$finrec)
 
  sem2<-as.Date(g$datesem2)
  plant2<-as.Date(g$dateplant2)
  rec2<-as.Date(g$daterec2)
  finrec2<-as.Date(g$finrec2)
 
  deb<-paste0(an,"-01-01")
  fin<-paste0(an,"-12-31")
  zs<-as.Date(c(deb,fin))
  
  nleg<-nrow(g)
 
  lab<- c("janv","fev","Mars","Avr","Mai","Juin",
          "Juil","Aout","Sept","Oct","Nov","Dec")
  dec<-10
  plot(zs-dec,y=c(0,nleg),x=c(0,12),type="p",cex=0,xaxt="n",ylab="",xlab="",axes=F)
  
 dates <- seq(as.Date(paste0("01/01/",an), format = "%d/%m/%Y"),
               by = "months", length = length(lab))
  axis.Date(3, at = seq(zs[1]-dec,zs[2]-dec,length.out=12),
            labels=lab, format= "%Y/%m/%d", las = 1,
            cex.axis=gros)
  grid(nx=24,ny=nleg,col="plum")
  
    # z<-month.day.year(date)
     z<-(2015-an)*365
    date<-as.Date(date-z)
   #date<-as.POSIXlt(date)
    abline(v=date,col="red",lwd=2)
    text(date,nleg,labels="",srt=0,col="red",pos=3)

   gros=1
  v<-0.5
  v1<-0.7
  t1<-editleg(g$legume)
  t2<-editleg(g$legume2)
  for (i in 1:nleg)
  {      
    text(sem[i],nleg-i+v1,labels=t1[i],pos=4,cex=gros,font=2,col='red')
    rect(sem[i],nleg-i,plant[i],nleg-i+v,col=coul[1],border=coul[1])
    if (plant[i]> sem[i]){
    text(sem[i],nleg-i+v/2,labels="Pepiniere",cex=0.8,font=3,pos=4,col="blue")
    }
    rect(plant[i],nleg-i,rec[i],nleg-i+v,col=coul[2],border=coul[2])
    
    if (rec[i]>plant[i]){
      text(plant[i],nleg-i+v/2,labels="En terre-> recolte",cex=0.8,font=3,pos=4,col="blue")}
    rect(rec[i],nleg-i,finrec[i],nleg-i+v,col=coul[3],border=coul[3])
    if (finrec[i]>rec[i]){
      text(rec[i],nleg-i+v/2,labels="Recolte",cex=0.8,font=3,pos=4,col="red")}
    
    if(g$legume2[[i]][1]!="aucun"){
   
     rect(sem2[i],nleg-i,plant2[i],nleg-i+v,col=coul[4],border=coul[4])
     rect(plant2[i],nleg-i,rec2[i],nleg-i+v,col=coul[5],border=coul[5])
     rect(rec2[i],nleg-i,finrec2[i],nleg-i+v,col=coul[6],border=coul[6])
     text(sem2[i],nleg-i+v1,labels=t2[i],pos=4,cex=gros,col="red",font=2)
    }
    
    if (icon==TRUE) {
       legicon<-param$icon[param$list==g$legume[[i]]]
      image<-get(legicon)
      
      if(length(image)>0){     
      rasterImage(image,zs[1],nleg-i+0.2,zs[1]+20,nleg-i+1)}      
    }      
  }  
 
 }
###########  table longueur culture par légume

 tablegold<-function(datan=newdon,an=2014){

   
  tableg<-data.frame(
  code=datan[,1],
  jardin=datan[,11],
  legume=datan[,13],
  legume2=datan[,20],
  long= as.numeric(datan[,6])/caro,
  larg=as.numeric(datan[,5])/caro,
  rangs1=as.numeric(datan[,14]),
  rangs2=as.numeric(datan[,21]),
  longleg1=0,longleg2=0)

for (i in 1:nrow(tableg))
{
  tableg$longleg1[i]<-max(tableg$long[i],tableg$larg[i])*tableg$rangs1[i]
  if(tableg$legume2[i] !="aucun"){
    tableg$longleg2[i]<-max(tableg$long[i],tableg$larg[i])*tableg$rangs2[i]
    
  }}

tablegume1<-as.data.frame(aggregate(longleg1~legume,data=tableg,FUN=sum)) 
colnames(tablegume1)<-c("Legume","Long")

tablegume2<-as.data.frame(aggregate(longleg2~legume2,data=tableg,FUN=sum))
colnames(tablegume2)<-c("Legume","Long")

tablegume<-rbind(tablegume1,tablegume2)
tablegume<-subset(tablegume,tablegume$Legume!="aucun")

tablegume<-as.data.frame(aggregate(Long~Legume,data=tablegume,FUN=sum))

tablegume$longlegume<-paste(round(tablegume$Long,0),"m")
longan<-paste("Long",an,sep="_")
tablegume<-tablegume[order(tablegume$Legume),]
colnames(tablegume)<-c("Legume","Long",longan)
tablegume<-tablegume[,c(1,3)]

return(tablegume)

 }
#############


tableg<-function(datan,an){
    
  if(nrow(datan)==0) return(NULL)
  tablegi<-subset(datan,select=c("parcelle","jardin","legume",
                "legume2","width","height","nbran","nbran2"))
  tablegi$long<-as.numeric(tablegi$height)/caro
  tablegi$larg<-as.numeric(tablegi$width)/caro
  
  leg1<-data.frame(matrix(0,ncol=4,nrow=100)) 
  colnames(leg1)<-c("leg","long","larg","rang")
  leg1$leg<-as.character(leg1$leg)
  
  n<-1
  for (i in 1:nrow(tablegi))
  {
    l1<-length(tablegi$legume[[i]])
    for (j in 1:l1)
    {
      leg1$leg[n]<-tablegi$legume[[i]][j]
      leg1$long[n]<-tablegi$long[i]
      leg1$larg[n]<-tablegi$larg[i]
      leg1$rang[n]<-tablegi$nbran[i]/l1
      n<-n+1
    }  
  }
  leg1<-subset(leg1,leg1$leg !="0")
  
  
  leg2<-data.frame(matrix(0,ncol=4,nrow=100)) 
  colnames(leg2)<-c("leg","long","larg","rang")
  leg2$leg<-as.character(leg2$leg)
  
  n<-1
  for (i in 1:nrow(tablegi))
  {
    l2<-length(tablegi$legume2[[i]])
    for (j in 1:l2)
    {
      leg2$leg[n]<-tablegi$legume2[[i]][j]
      leg2$long[n]<-tablegi$long[i]
      leg2$larg[n]<-tablegi$larg[i]
      leg2$rang[n]<-tablegi$nbran2[i]/l2
      n<-n+1
    }  
  }
  leg2<-subset(leg2,leg2$leg !="0" )
  leg2<-subset(leg2,leg2$leg != "aucun")
  tableg<-rbind(leg1,leg2)

  for (i in 1:nrow(tableg))
  {
    tableg$longleg[i]<-max(tableg$long[i],tableg$larg[i])*tableg$rang[i]
  }
  
  tablegume<-as.data.frame(aggregate(longleg~leg,data=tableg,FUN=sum)) 
  colnames(tablegume)<-c("Legume","Long")
 
  tablegume$longlegume<-paste(round(tablegume$Long,0),"m")
  longan<-paste("Long",an,sep="_")
  tablegume<-tablegume[order(tablegume$Legume),]
  colnames(tablegume)<-c("Legume","Long",longan)
  tablegume<-tablegume[,c(1,3)]
  
  return(tablegume)
  
}
##########
nomtri<-function(arb){
  
  if(length(arb$num)>0) 
    {
    for(i in 1:length(arb$num))
    {
      arb$scr[i]<-switch(arb$scr[i],
                         "1"="pommier",
                         "2"="abricotier",
                         "3"="cerisier",
                         "4"="poirier",
                         "5"="prunier",
                         "6"="pêcher",
                         "7"="rhubarbe",
                         "8"="groseiller")      
    }}  
  return(arb)
  }

############


