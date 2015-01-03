

library("shiny")
# setwd("~/gardenR/")

# runApp("jardinor")

library("shinyBS")
#library("chron")
library("jsonlite")
library("png")
#library("rCharts")
library("shinyTable")

source("filop/jarplot.R")
source("filop/json2R.R")
# rm(list=ls())
#######
shinyServer(function(input, output, clientData, session) {
  
  #########


  don<-readRDS("data/jardini")
  options(stringsAsFactors = FALSE)
  param <- read.csv("data/param.csv")
  ##### 
 
################taille canvas

observe({
  
  dimjars<-data.frame( long=c(23,60,60),larg=c(21,10,15))
  
  session$sendCustomMessage(type='coorcan',message=list(long=dimjars$long,larg=dimjars$larg))

  
})


  ######## reprise du fichier tempar toute les 1 0.5s  
  
  tempar<- reactiveFileReader(500, session, "data/tempar",readRDS)
  tabarb<- reactiveFileReader(500, session, "data/trees",readRDS)
  tabal<- reactiveFileReader(500, session, "data/datal",readRDS)
  ##########
 output$rang<-renderText({
 input$change
 })
  
  output$tabdon<-renderTable({  
  veg<-tempar()
  return(veg)
})
####### receuil et sauvegardes canvas  
wh<-reactive({
  if(!is.null(input$json_h))
  {
    rjon_h<-fromJSON(input$json_h)
  
    wh<-rjon_h$objects
    wh<-subset(wh, wh$width>10 & wh$height>10)
    #saveRDS(wh,"data/jsonessai.rds")
    wh<-extract_can(wh)
    return(wh)
  }
  
})


wm<-reactive({
  if(!is.null(input$json_m))
  {
    rjon_m<-fromJSON(input$json_m)
    wm<-rjon_m$objects
    wm<-subset(wm, wm$width>10 & wm$height>10)
    wm<-extract_can(wm)
    return(wm)
  }
})

wb<-reactive({
  if(!is.null(input$json_b))
  {
    rjon_b<-fromJSON(input$json_b)
    wb<-rjon_b$objects
    wb<-subset(wb, wb$width>10 & wb$height>10)
   
    wb<-extract_can(wb)
    return(wb)
  }
})

######### synchronisation de newdon (taille et position des parcelles) et tempar(reste)
newdon<-reactive({
  input$rec1
  input$rec2
  input$rec3
  input$parnew
  input$parsup
  input$fichactu
  input$jarold
  
  m<-json2Ractu(wh=wh(),wm=wm(),wb=wb()) 
  if(is.null(m))
  {
  m<-don[[2]]
  } 
  saveRDS(m,"data/newdon")
  #saveRDS(m,"~/git/jari/data/newdon.rds")
  
  return(m)
})



############envoi données pour remplissage des canvas au depart après choix d'un fichier RDS

jar<-reactive ({       
 input$jarold
  inFile <- input$jarold 
 if (is.null(inFile))
 { jar<-don
        }else{
  jar<-readRDS(inFile$datapath)

  }
  return(jar)

})

############ debut fichier perso
observe({
 jar()
  if(!is.null(jar()))
  {
     
    newdon<-jar()[[2]]
    
     trees<-jar()[[3]] 
    #trees<-readRDS("data/trees")
     saveRDS(trees,file="data/trees")
    
    datal<-jar()[[4]]    
    saveRDS(datal,file="data/datal")
    
    leg14<-readRDS("data/jardin2014")
    
    if(length(newdon$parcelle)>0)
    {
      tempar<-subset(newdon,select=c(parcelle,jardin,texver,legume,nbran,datesem,dateplant,daterec,
                                     finrec,comment,legume2,nbran2,datesem2,dateplant2,daterec2,
                                     finrec2,comment2))
    }else{
      tempar<-readRDS("data/temparini")
    }
        
    saveRDS(tempar,file="data/tempar")   
 
    
observe({  
  #newdon <- readRDS("~/ajar/jarplan/data/newdon.rds")
  #newdon<-newdon()
  
  newdon_h<-subset(newdon,jardin=="H")
  #newdon_h<-newdon
  donjson_h<-toJSON(newdon_h)
  #trees<-jar()[[2]]
  trih<-toJSON(subset(trees,trees$jar=="H"))
  #datal<-readRDS("data/datal")
  alh<-toJSON(subset(datal,datal$j=="H"))
  param <- read.csv("data/param.csv",stringsAsFactors =FALSE)
  parcol<-toJSON(param[,3])
  session$sendCustomMessage(type='fill_h1',message=list(leg=donjson_h,tree=trih,al=alh))
  session$sendCustomMessage(type='fill_h2',message=list(leg=donjson_h,tree=trih,al=alh,col=parcol))
  
  
})

observe({  
  #newdon_m <- newdon
  newdon_m<-subset(newdon,jardin=="M")
  donjson_m<-toJSON(newdon_m) 
  #trees<-readRDS("data/trees")
  trim<-toJSON(subset(trees,trees$jar=="M"))
  #datal<-readRDS("data/datal")
  alm<-toJSON(subset(datal,datal$j=="M"))
  param <- read.csv("data/param.csv",stringsAsFactors =FALSE)
  parcol<-toJSON(param[,3])
  session$sendCustomMessage(type='fill_m1',message=list(leg=donjson_m,tree=trim,al=alm))
  session$sendCustomMessage(type='fill_m2',message=list(leg=donjson_m,tree=trim,al=alm,col=parcol))
  
})

observe({  
  #newdon_b <- newdon
  newdon_b<-subset(newdon,jardin=="B")
  donjson_b<-toJSON(newdon_b)
  #trees<-readRDS("data/trees")
  trib<-toJSON(subset(trees,trees$jar=="B"))
  #datal<-readRDS("data/datal")
  alb<-toJSON(subset(datal,datal$j=="B"))
  param <- read.csv("data/param.csv",stringsAsFactors =FALSE)
  parcol<-toJSON(param[,3])
  session$sendCustomMessage(type='fill_b1',message=list(leg=donjson_b,tree=trib,al=alb))
  session$sendCustomMessage(type='fill_b2',message=list(leg=donjson_b,tree=trib,al=alb,col=parcol))
})


############ fin chargement fichier
########" envoi nom de parcelle
# observe({
#   jar()
#   input$parnew
#   #parc<-readRDS("data/tempar")
#   parc<-tempar()
#   par<-as.character(parc$parcelle)
#   if(length(par)!=0) 
#   session$sendCustomMessage(type='tempar',par)  
# })

###### envoi des donnees N° legume et nbre rangs


observe({
  input$legum1
 if (!is.null(input$legum1))
  {
  legum1<-input$legum1
  nlegum1<-match(legum1,param$list)
  legum2<-input$legum2
  nlegum2<-match(legum2,param$list)
  rang1<-input$rang1
  rang2<-input$rang2
  tablid<-c(rang1,rang2,list(nlegum1),list(nlegum2))
  tablid<-toJSON(tablid)
  session$sendCustomMessage(type='parcelid',tablid)
  }  
 
})


########## affiche nom de la parcelle selectionnée et jardin
japar<-reactive({
  input$parsel_h
  input$parsel_m
  input$parsel_b
  jar<-""
  par<-""
  if(!is.null(input$OK_h)){if (input$OK_h=="OK"){ 
      if(!is.null(input$parsel_h))
      {par<-input$parsel_h
        jar<-"H"}}}
  
if(!is.null(input$OK_m)){if (input$OK_m=="OK"){ 
  if(!is.null(input$parsel_m))
  {par<-input$parsel_m
  jar<-"M"}}}

if(!is.null(input$OK_b)){if (input$OK_b=="OK"){ 
  if(!is.null(input$parsel_b))
  {par<-input$parsel_b
   jar<-"B"}}}

japar<-c(par,jar)
  return(japar)
})


output$parselh<-renderText({
  if(!is.null(input$OK_h))
    {if (input$OK_h=="OK")
    { 
  par<-paste("Parcelle :",japar()[1])
  return(par)
  }else{
    return(NULL)
  }}
})


output$parselm<-renderText({
  if(!is.null(input$OK_m))
  {if (input$OK_m=="OK")
  { 
    par<-paste("Parcelle :",japar()[1])
    return(par)
  }else{
    return(NULL)
  }}
})


output$parselb<-renderText({
  if(!is.null(input$OK_b))
  {if (input$OK_b=="OK")
  { 
    par<-paste("Parcelle :",japar()[1])
    return(par)
  }else{
    return(NULL)
  }}
})

########envoi des données de la parcelle selectonnée 
observe({
   japar()
  if(!is.null(japar())) {nomparsel<-japar()[1]
  }else{
     nomparsel<-""
  }
  
  if(!is.null(input$change))   
  {
    if(input$change == "GO")
    {            
      if(nomparsel!="")
      {
        data <- tempar()
        selin<-which(data$parcelle == nomparsel)
        
        if(length(selin)>0)
          {
          if(selin!=0)
          {
        #legume1<-as.vector(data$legume[[selin]])
        # updateTextInput(session, "parid",label = "",value = data$parcelle[selin])
        updateCheckboxGroupInput(session, "legum1",label = "",selected = data$legume[[selin]])
        updateNumericInput(session,"rang1",label="", value=data$nbran[selin])
        updateDateInput(session,"sem1",label="Semis",value=data$datesem[selin]) 
        updateDateInput(session,"plant1",label="Plant.", value=data$dateplant[selin]) 
        updateDateInput(session,"rec1",label="Recolte",value=data$daterec[selin])
        updateDateInput(session,"finrec1",label="Fin rec:",value=data$finrec[selin])
        updateTextInput(session, "com1",label = "Commentaires:",value = data$comment[selin])
        
        if (length(data$legume2[selin])>0) {   
          
          updateCheckboxGroupInput(session, "legum2",label = "",selected = data$legume2[[selin]])
          updateNumericInput(session,"rang2",label="",value=data$nbran2[selin])
          updateDateInput(session,"sem2",label="Semis",value=data$datesem2[selin])
          updateDateInput(session,"plant2",label="Plant.",value=data$dateplant2[selin])
          updateDateInput(session,"rec2",label="Recolte",value=data$daterec2[selin])
          updateDateInput(session,"finrec2",label="Fin rec",value=data$finrec2[selin])
          updateTextInput(session, "com2", label = "Commentaires:", value = data$comment2[selin])
        }else{
          updateTextInput(session,"legum2",label="",value="aucun") 
          updateNumericInput(session,"rang2",label="",value=0)
          updateDateInput(session,"sem2",label="Semis", value="2015-03-01")
          updateDateInput(session,"plant2",label="Plant.",value="2015-03-01")
          updateDateInput(session,"rec2",label="Recolte",value="2015-06-01")
          updateDateInput(session,"finrec2",label="Fin rec.",value="2015-06-01")
          updateTextInput(session, "com2",label = "Commentaires:",value = "comment") 
        }
        }}}else{
        #   updateTextInput(session, "parid",label = "",value = "aucune")
          updateCheckboxGroupInput(session, "legum1",label = "",selected=param$list[1])
          updateNumericInput(session,"rang1",label="", value= 0)
          updateDateInput(session,"sem1",label="Semis", value=as.Date("2015-03-01"))
          updateDateInput(session,"plant1",label="Plant.",value=as.Date("2015-03-01"))
          updateDateInput(session,"rec1",label="Recolte",value=as.Date("2015-06-01"))
          updateDateInput(session,"finrec1",label="Fin rec",value=as.Date("2015-06-01"))
          updateTextInput(session, "com1",label = "Commentaires:",value = "comment") 
          updateTextInput(session,"legum2",label="",value="aucun") 
          updateNumericInput(session,"rang2",label="Nbre rangs:",value=0)
          updateDateInput(session,"sem2",label="Semis", value=as.Date("2015-03-01"))
          updateDateInput(session,"plant2",label="Plant.",value=as.Date("2015-03-01"))
          updateDateInput(session,"rec2",label="Recolte",value=as.Date("2015-10-01"))
          updateDateInput(session,"finrec2",label="Fin rec.",value=as.Date("2015-10-01"))
          updateTextInput(session, "com2",label = "Commentaires:",value = "comment")                
        }
    }}
  
  
})

########enregistrer dans tempar les modifs d'une parcelle

observe({
  input$parnew
  if(!is.null(input$parnew))
   {    
    if (input$parnew== "GO")
     {    
      
      if ( !is.null(input$legum1)  & !is.null(japar()))
      {
        tempar<-tempar()       
        
        parnew<-as.data.frame(t(matrix(0,17)))
        colnames(parnew)<-c( "parcelle"  , "jardin" ,    "texver"   ,   
                             "legume" ,    "nbran"  ,    "datesem"  ,  "dateplant",
                             "daterec",    "finrec" ,   
                             "comment" ,   "legume2",    "nbran2"  ,   "datesem2"  ,
                             "dateplant2", "daterec2",   "finrec2"  ,  "comment2" )
    
        
      parnew <- data.frame(lapply(parnew, as.character), stringsAsFactors=FALSE)
        
        parnew$parcelle<-japar()[1]
        parnew$jardin<-japar()[2]
        parnew$texver<-"H"
        parnew$legume<-list(input$legum1)
        parnew$nbran<-input$rang1
        parnew$comment<-input$com1
        parnew$legume2<-list(input$legum2)
        parnew$nbran2<-input$rang2
        parnew$comment2<-input$com2
        
     parnew$datesem<-as.Date(input$sem1)
     parnew$dateplant<-as.Date(max(input$plant1,input$sem1))   
     parnew$daterec<-as.Date(input$rec1)
     parnew$finrec<-as.Date(max(input$rec1,input$finrec1))
     parnew$datesem2<-as.Date(input$sem2)
     parnew$dateplant2<-as.Date(max(input$sem2,input$plant2))  
     parnew$daterec2<-as.Date(input$rec2)
     parnew$finrec2<-as.Date(max(input$rec2,input$finrec2))
     
        
        tempar$datesem<-as.Date(tempar$datesem)
        tempar$dateplant<-as.Date(tempar$dateplant)
        tempar$daterec<-as.Date(tempar$daterec)
        tempar$finrec<-as.Date(tempar$finrec)
        tempar$datesem2<-as.Date(tempar$datesem2)
        tempar$dateplant2<-as.Date(tempar$dateplant2)
        tempar$daterec2<-as.Date(tempar$daterec2)
        tempar$finrec2<-as.Date(tempar$finrec2)
        
        y<-which(tempar$parcelle == as.character(parnew$parcelle[1]))
        
        if( length(y) == 0 )
        {
          tempar<-rbind(tempar,parnew)
          # tempar<-tempar[-(nrow(tempar)-1),]
                 }else{
          tempar<-tempar[-y,]
          tempar<-rbind(tempar,parnew)       
        }
        
        saveRDS(tempar,file="data/tempar")
     
       }}}
})


##########supprimer parcelle de tempar; parnew mis a null (dans newfabric.js)
observe ({
  input$parsup
  if (!is.null(input$parsup))
  {
    #parsup<-input$parsup
   # x<-parsup$objects
    #nomparsup<-x[[2]]$text
    data<-tempar()
    selsup<-which(data$parcelle == input$parsup)
    if(length(selsup)!=0)
      {
     data<-data[-selsup,]
     saveRDS(data,file="data/tempar") 
      }}

})
###############
####### gestion des elements fixes
##########jardin1 elements fixes

output$jar1<-renderPlot({
  
jardin(input$long1,input$larg1,"")

input$adtree1
hx1<-input$trix1
bx1<-input$trix1+1
hy1<-input$long1-input$triy1
by1<-input$long1-input$triy1-1
rect(bx1+0.3,by1-0.5,hx1,hy1,col="green",density=10)
points(hx1,hy1,pch=19,cex=2,col='red')
text(hx1+0.5,hy1-0.2,labels="arbre")
points(bx1,by1,pch=10,cex=6,col='red')

alox1<-input$alox1
aloy1<-input$long1-input$aloy1
albax1<-input$albax1
albay1<-input$long1-input$albay1
segments(albax1,albay1,alox1,aloy1,col="red",lwd=5)
text((alox1+albax1)/2,(aloy1+albay1)/2,labels="allée",col="blue")

verger<-subset(tabarb(),jar=="H")
if(length(verger$num>0))
{
rect(verger$l,input$long1-verger$t,verger$l+1,input$long1-verger$t-1,border="blue",col='green',density=30)
text(verger$l+0.5,input$long1-verger$t+0.2,labels=paste(verger$num,verger$nom),col="blue")
points(verger$l,input$long1-verger$t,pch=19,cex=1,col='blue')
points(verger$l+1,input$long1-verger$t-1,pch=10,cex=verger$taille*5,col='blue')
}

al<-subset(tabal(),j=="H")
l<-length(al$num)
if(l>0)
{
  for(i in 1:l)
  {
    segments(al$a,input$long1-al$b,al$c,input$long1-al$d,col="blue",lwd=5)
    text(al$a,input$long1-al$b,labels=paste("Allée N°",al$num))
  }
}

h <-input$clic1 
if(!is.null(h)) {points(h$x,h$y,pch=19,col="purple",cex=4)} 

})

output$plotjar1<-renderUI({
  w1<-paste0(input$larg1*30,"px")
  h1<-paste0(input$long1*30,"px")    
  plotOutput("jar1",width=w1,height=h1,
             hoverId=NULL,
             hoverDelay=200,
             clickId="clic1",
             hoverDelayType="debounce")
})

output$tabjar1<-renderUI({

      div(fluidRow(
        column(2),
        column(3,
               h3("Allées du 1er jardin"),
               tableOutput("tabal1")),
        column(6,
               h3("Arbres et plantes perennes du 1er jardin"), 
               tableOutput("tabarb1"))))
})

########## arbres
observe({
  input$C1
  h1 <-isolate(input$clic1)
  if(is.null(h1)) return(NULL)  
  updateNumericInput(session,"trix1",value=round(h1$x,0))
  updateNumericInput(session,"triy1",value=round(input$long1-h1$y,0))  
})

observe ({
  input$adtree1
  
  if(!is.null(input$adtree1))
  {
    if(input$adtree1 == "on")
    {
      #tree<-readRDS("data/trees")
      tree<-isolate(tabarb())
      num<-ifelse(length(tree$num)==0,1,max(tree$num)+1)
      
      ajout<-data.frame(num=num,l=input$trix1,t=input$triy1,nom=input$var1,
                        scr=as.integer(input$esp1),taille=as.integer(input$size1),jar="H",
                        plantation=input$plantan1,recolte=input$div1,stringsAsFactors = FALSE)
      
      q<-rbind(tree,ajout)
            
      saveRDS(q,"data/trees")
      
    updateTextInput(session, "var1", value ="")  
     updateTextInput(session, "div1", value ="")     
    }}  
})


observe({
  input$suptree1
  elim<-as.integer(input$suptree1)
  
  if(length(elim)>0)
  {
    if(elim >0)
    {     
      tab<-isolate(tabarb()) 
      tab$num<-as.integer(tab$num)
      num<-as.integer(which(tab$num==elim))     
      q<-tab[-num,]      
      saveRDS(q,"data/trees")      
    }} 
})


output$tabarb1 <-  renderTable({
  default.stringsAsFactors()
  arb1<-subset(tabarb(),jar=="H")
  if(length(arb1$num)==0) (arb1<-as.data.frame(matrix("",1,9)))
  arb1<-nomtri(arb1)
  colnames(arb1)<-c("Num","large","long","variété","espèce","taille","jardin","année_plant.","Commentaires")   
  return(arb1)
},digits=0,include.rownames = FALSE
)

########" allées

output$jarpal1<-output$jartri1<-renderText({
  h1 <-input$clic1 
  if(is.null(h1)) return(NULL)  
  p1<-paste("X =",round(h1$x,0),"m,  Y =",round(input$long1-h1$y,0),"m")
  return(p1)
})

observe({
  input$A1
  h1 <-isolate(input$clic1)
  if(is.null(h1)) return(NULL)  
  updateNumericInput(session,"alox1",value=round(h1$x,0))
  updateNumericInput(session,"aloy1",value=round(input$long1-h1$y,0))  
})

observe({
  input$B1
  h1 <-isolate(input$clic1)
  if(is.null(h1)) return(NULL)  
  updateNumericInput(session,"albax1",value=round(h1$x,0))
  updateNumericInput(session,"albay1",value=round(input$long1-h1$y,0))  
})


observe ({
  input$adallee1
  
  if(!is.null(input$adallee1))
  {
    if(input$adallee1 == "on")
    {
      
      al1<-isolate(tabal())
      num<-ifelse(length(al1$num)==0,1,max(al1$num)+1)
      
      ajout1<-data.frame(num=num,a=input$alox1,b=input$aloy1,c=input$albax1,
                        d=input$albay1,j="H",col="green",stringsAsFactors = FALSE)                  
     
      q<-rbind(al1,ajout1)
      
      saveRDS(q,"data/datal")
    }}  
})

observe({
  input$supallee1
  elim<-as.integer(input$supallee1)
  
  if(length(elim)>0)
  {
    if(elim >0)
    {     
      tab<-isolate(tabal()) 
      tab$num<-as.integer(tab$num)
      num<-as.integer(which(tab$num==elim))     
      q<-tab[-num,]      
      saveRDS(q,"data/datal")      
    }} 
})

output$tabal1 <-  renderTable({
  default.stringsAsFactors()
  al1<-subset(tabal(),j=="H")
  if(length(al1$num)==0) (al1<-as.data.frame(matrix("",1,7)))
  colnames(al1)<-c("Num","a","b","c","d","jardin","couleur")   
  return(al1)
},digits=0,include.rownames = FALSE
)
################fin élements jard1
###############jardin2 elements fixes
output$jar2<-renderPlot({
  
  jardin(input$long2,input$larg2,"") 
  #input$adtree2
  hx2<-input$trix2
  bx2<-input$trix2+1
  hy2<-input$long2-input$triy2
  by2<-input$long2-input$triy2-1
  rect(bx2+0.3,by2-0.5,hx2,hy2,col="green",density=10)
  points(hx2,hy2,pch=19,cex=2,col='red')
  text(hx2+0.5,hy2-0.2,labels="arbre")
  points(bx2,by2,pch=10,cex=6,col='red')
  
  alox2<-input$alox2
  aloy2<-input$long2-input$aloy2
  albax2<-input$albax2
  albay2<-input$long2-input$albay2
  segments(albax2,albay2,alox2,aloy2,col="red",lwd=5)
  text((alox2+albax2)/2,(aloy2+albay2)/2,labels="allée",col="blue")
  
  verger<-subset(tabarb(),jar=="M")
  if(length(verger$num>0))
  {
    rect(verger$l,input$long2-verger$t,verger$l+1,input$long2-verger$t-1,border="blue",col='green',density=30)
    text(verger$l+0.5,input$long2-verger$t+0.2,labels=paste(verger$num,verger$nom),col="blue")
    points(verger$l,input$long2-verger$t,pch=19,cex=1,col='blue')
    points(verger$l+1,input$long2-verger$t-1,pch=10,cex=verger$taille*5,col='blue')
  }
  
  al<-subset(tabal(),j=="M")
  l<-length(al$num)
  if(l>0)
  {
    for(i in 1:l)
    {
      segments(al$a,input$long2-al$b,al$c,input$long2-al$d,col="blue",lwd=5)
      text(al$a,input$long2-al$b,labels=paste("Allée N°",al$num))
    }
  }
  
  h <-input$clic2 
  if(!is.null(h)) {points(h$x,h$y,pch=19,col="purple",cex=4)} 
  
})

output$plotjar2<-renderUI({
  w2<-paste0(input$larg2*30,"px")
  h2<-paste0(input$long2*30,"px")    
  plotOutput("jar2",width=w2,height=h2,
             hoverId=NULL,
             hoverDelay=200,
             clickId="clic2",
             hoverDelayType="debounce")
})

output$tabjar2<-renderUI({
  
  div(fluidRow(
    column(2),
    column(3,
           h3("Allées du 2ème jardin"),
           tableOutput("tabal2")),
    column(6,
           h3("Arbres et plantes perennes du 1er jardin"), 
           tableOutput("tabarb2"))))
})

output$jarpal2<-output$jartri2<-renderText({
  h2 <-input$clic2 
  if(is.null(h2)) return(NULL)  
  p1<-paste("X =",round(h2$x,0),"m,  Y =",round(input$long2-h2$y,0),"m")
  return(p1)
})

observe({
  input$A2
  h2 <-isolate(input$clic2)
  if(is.null(h2)) return(NULL)  
  updateNumericInput(session,"alox2",value=round(h2$x,0))
  updateNumericInput(session,"aloy2",value=round(input$long2-h2$y,0))  
})

observe({
  input$B2
  h2 <-isolate(input$clic2)
  if(is.null(h2)) return(NULL)  
  updateNumericInput(session,"albax2",value=round(h2$x,0))
  updateNumericInput(session,"albay2",value=round(input$long2-h2$y,0))  
})


observe ({
  input$adallee2
  
  if(!is.null(input$adallee2))
  {
    if(input$adallee2 == "on")
    {
      
      al2<-isolate(tabal())
      num<-ifelse(length(al2$num)==0,1,max(al2$num)+1)
      
      ajout2<-data.frame(num=num,a=input$alox2,b=input$aloy2,c=input$albax2,
                        d=input$albay2,j="M",col="green",stringsAsFactors = FALSE)                  
      
      q<-rbind(al2,ajout2)
      
      saveRDS(q,"data/datal")
    }}  
})

observe({
  input$supallee2
  elim<-as.integer(input$supallee2)
  
  if(length(elim)>0)
  {
    if(elim >0)
    {     
      tab<-isolate(tabal()) 
      tab$num<-as.integer(tab$num)
      num<-as.integer(which(tab$num==elim))     
      q<-tab[-num,]      
      saveRDS(q,"data/datal")      
    }} 
})

observe({
  input$C2
  h2 <-isolate(input$clic2)
  if(is.null(h2)) return(NULL)  
  updateNumericInput(session,"trix2",value=round(h2$x,0))
  updateNumericInput(session,"triy2",value=round(input$long2-h2$y,0))  
})

observe ({
  input$adtree2
  
  if(!is.null(input$adtree2))
  {
    if(input$adtree2 == "on")
    {
      #tree<-readRDS("data/trees")
      tree<-isolate(tabarb())
      num<-ifelse(length(tree$num)==0,1,max(tree$num)+1)
      
      ajout2<-data.frame(num=num,l=input$trix2,t=input$triy2,nom=input$var2,
                        scr=as.integer(input$esp2),taille=as.integer(input$size2),jar="M",
                        plantation=input$plantan2,recolte=input$div2,stringsAsFactors = FALSE)
      
      q<-rbind(tree,ajout2)
      
      saveRDS(q,"data/trees")
      
      updateTextInput(session, "var2", value ="")  
      updateTextInput(session, "div2", value ="")     
    }}  
})


observe({
  input$suptree2
  elim<-as.integer(input$suptree2)
  
  if(length(elim)>0)
  {
    if(elim >0)
    {     
      tab<-isolate(tabarb()) 
      tab$num<-as.integer(tab$num)
      num<-as.integer(which(tab$num==elim))     
      q<-tab[-num,]      
      saveRDS(q,"data/trees")      
    }} 
})



output$tabarb2 <-  renderTable({
 
  arb2<-subset(tabarb(),jar=="M")
  if(length(arb2$num)==0) (arb2<-as.data.frame(matrix("",1,9),stringAsFactors=FALSE))
  arb2<-nomtri(arb2)
  colnames(arb2)<-c("Num","large","long","variété","espèce","taille","jardin","année_plant.","Commentaires")   
  return(arb2)
},digits=0,include.rownames = FALSE
)


output$tabal2 <-  renderTable({
 
  al2<-subset(tabal(),j=="M")
  if(length(al2$num)==0) (al2<-as.data.frame(matrix("",1,7)))
  colnames(al2)<-c("Num","a","b","c","d","jardin","couleur")   
  return(al2)
},digits=0,include.rownames = FALSE
)


######### nom des jardins
output$nomjard1<-renderText({
  n1<-"Jardin du haut"
  return(n1)
})

output$nomjard2<-renderText({
  n2<-"Jardin du milieu"
  return(n2)
})

output$nomjard3<-renderText({
  n3<-"Jardin du bas"
  return(n3)
})
##############tableau des arbres


output$tabarb<-  renderDataTable({
  default.stringsAsFactors()
  arb<-tabarb()
  
  if(length(arb$num)==0) {arb<-as.data.frame(matrix("",1,9))}
  arb<-nomtri(arb)
  colnames(arb)<-c("Num","large","long","variété","espèce","taille","jardin","année_plant.","Commentaires")   
  
  return(arb)
},options = list(orderClasses = TRUE,lengthMenu = c(10,50,100), pageLength = 50)
  #initComplete = I("function(settings, json) {alert('Tableau des arbres fruitiers et plantes perennes de tous les jardins');}"))
)

########### table interactive des parcelles
output$tabpar<- renderTable({
  tempar()
  if(nrow(tempar())==0) return(NULL)
  tab<-data.frame(parcelle=tempar()[,1],
                  jardin=tempar()[,2],
                  legume=editleg(tempar()[,4]))
  
  
  return(tab)
  
})
##################### calendrier legumes

output$planleg<- renderUI ({ 
  
  # newdon<-json2Ractu(wh=wh(),wm=wm(),wb=wb())
  data<-tempar()
  data<-data[data$legume!="aucun",]
  
  l<-length(data$legume)
  if(l==0) return(NULL)
  
  output$plot<-renderPlot({planleg(data=data,date=input$dateleg,an=2015)})
  
  w<-"600px"
  h <-paste0(30*l+200,"px")
  
  plotOutput("plot",width=w,height=h)
  
  
})


###########tableau des legumes

output$tableg <-  renderDataTable({
  
  leg2014<-tableg(datan=leg14,an=2014) 
  
  newdon<-newdon()
  if(nrow(newdon)!=0)
  {
    leg2015<-tableg(datan=newdon,an=2015) 
  }else{
    leg2015<-leg2014[0,]
    colnames(leg2015)<-c("Legume","Long_2015")
    
  } 
  
  legan<-merge(leg2014,leg2015,by="Legume",all=TRUE,sort=TRUE)
  
  legan<-legan[order(legan$Legume),]
  return(legan)
},options = list(orderClasses = TRUE,lengthMenu = c(10, 25, 50), 
                 pageLength = 50)
)
######### tableau des parcelles

output$tabparcel<- renderDataTable({
  newdon<-newdon()
  if(nrow(newdon)!=0)
  {
    tab<-data.frame(identifiant=newdon$parcelle,
                    jardin=newdon$jardin,
                    legume=editleg((newdon$legume)),
                    long= as.numeric(newdon$height)/caro,
                    larg=as.numeric(newdon$width)/caro,
                    rangs=as.numeric(newdon$nbran),
                    lon=0,commentaires=newdon$comment)
    
    for (i in 1:nrow(tab))
    {
      tab$lon[i]<-round(max(tab$long[i],tab$larg[i])*tab$rangs[i],0)
    }
    
    tab[,c(1,2,3,6,7,8)]
  }
},

options = list(orderClasses = TRUE,lengthMenu = c(10, 30, 60), 
               pageLength = 30,
               columnDefs = list(list(sWidth=c("80px"), aTargets=c(list(0),list(1),list(2),list(3),list(4)))))
#fnInitComplete = I("function(oSettings, json) {alert('Done.');}"))

)

########couleurs

tab_param<-reactive({
  param <- read.csv("data/param.csv",stringsAsFactors =FALSE)
  if(!is.null(input$couleg))
  {
    param$coul[param$list==input$hexaleg]<-input$couleg
   write.csv(param,file="data/param.csv", row.names=FALSE)
   #saveRDS(param,"data/param.rds")
    return(param)
  }else{
    return(param)
  }
  
}) 


output$couplot<-renderPlot({
  par(mar=c(0,0,0,0))
 tab<-tab_param()
 n<-nrow(tab)
  plot(x=c(0,0),y=c(2,10),xlim=c(0,1),ylim=c(0,n)
       ,cex=0,axes=T,xlab="",ylab="")
    
  for (i in 1:n)
  {
    text(0.6,n+1-i+0.5,labels=tab[i,1],pos=4,cex=1.5)     
    rect(0.1,n+1-i,0.6,n+1-i+1,col=tab[i,3],border=tab[i,3])
    legicon<-param$icon[param$list==tab[i,1]]
    image<-get(legicon)
    
    if(length(image)>0){     
      rasterImage(image,0,n+1-i,0.07,n+1-i+1)}      
     } 
  
})


######## archiv jardin du haut

output$archo <- renderPlot({
  
  jardin(23,21,titre=paste("Jardin du haut",an))
  coloral(0,0,21,1,coul="lightblue")
  coloral(0,23,21,24,coul="lightblue")  
  coloral(11,1,11.5,23)
  coloral(2,12.5,11,13)


  if(input$ano==2014) {donan<-leg14}
  if(input$ano==2015) {donan<-newdon()}
  
  loch<-subset(donan,donan[,11]=="H")
  loch$parcelle<-as.character(loch$parcelle)
  #loch$legume<-as.character(loch$legume)
  
  nbH<-nrow(loch)
  if (nbH>=1) {
    
    for (i in 1:nbH)
    {
      
      couleur<-param[param$list==loch$legume[[i]][1],3]
    
      careleg(loch$colegi[i],loch$linegi[i],loch$colege[i],loch$linege[i],
              coul=couleur,legs=loch$legume[i],
              texver=loch$texver[i])
    }
  }  
})
######## archiv jardin du milieu

output$jaromil <- renderPlot({
  
  jardin(60,10,titre=paste("Jardin du milieu",an))
  

  if(input$anm==2014) {donan<-leg14}
  if(input$anm==2015) {donan<-newdon()}
  
  locm<-subset(donan,donan[,11]=="M")
  locm$parcelle<-as.character(locm$parcelle)
  #locm$legume<-as.character(locm$legume)
  
  nbM<-nrow(locm)
  if (nbM>=1) {
    
    for (i in 1:nbM)
    {
      couleur<-param[param$list==locm$legume[[i]][1],3]
      careleg(locm$colegi[i],locm$linegi[i],locm$colege[i],locm$linege[i],
              coul=couleur,legs=locm$legume[i],
              texver=locm$texver[i])
    }
  }  
})
######## archiv jardin du bas

output$jaroba <- renderPlot({
  
  jardin(60,15,titre=paste("Jardin du bas",an))

  if(input$anb==2014) {donan<-leg14}
  if(input$anb==2015) {donan<-newdon()}

  locb<-subset(donan,donan[,11]=="B")
  locb$parcelle<-as.character(locb$parcelle)
  #locb$legume<-as.character(locb$legume)
  
  nbB<-nrow(locb)
  if (nbB>=1) {
    
    for (i in 1:nbB)
    {
      couleur<-param[param$list==locb$legume[[i]][1],3]
  
      careleg(locb$colegi[i],locb$linegi[i],locb$colege[i],locb$linege[i],
              coul=couleur,legs=locb$legume[i],
              texver=locb$texver[i])
    }
  } 
  
})

# ############### chemins
# 
# output$chemh1<-output$chemh2 <-renderPlot ({
#   chemin()  
# })
# 
# output$chem1 <-output$chem2 <-renderPlot ({
#   chemin()  
# })
# 
# output$chemb1 <- output$chemb2 <- renderPlot ({
#   chemin(N=c(0,0.5,0.1,0.5))  
# })
# 
# 

###############archives calendrier legumes
output$planlegold <- renderUI ({ 
  

  if(input$anileg==2014) {donan<-leg14
                            an<-2014   }
  if(input$anileg==2015) {donan<-newdon()
                            an<-2015}
  data<-donan[donan$legume[1]!="aucun",]
  
  l<-length(data$legume)
  
  output$plotold<-renderPlot({planleg(data=data,date=input$dateleg,an=an)})     
  
  w<-"600px"
  h <-paste0(30*l+200,"px")
  
  plotOutput("plotold",width=w,height=h)
  
  
})


###########sauvegarde
output$fichactu <- downloadHandler(
  filename = function() { paste0("jardin_",Sys.Date(),".rds")},
  
  content = function(file) {
    
  dimjars<-data.frame( long=c(23,60,60),larg=c(21,10,15))
   leg<-newdon()  
   trees<-readRDS("data/trees")
  
   datal<-readRDS("data/datal")

   jardon<-list(dimjars,leg,trees,datal)

   saveRDS(jardon,file)
    
  },contentType = 'application/RDS'
)

##################fin fichier perso
  }
})

#########fin
})


