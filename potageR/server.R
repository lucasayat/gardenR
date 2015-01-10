

library("shiny")
# setwd("~/gardenR/potageR/")
# setwd("~/gardenR/")
# runApp("potageR")
# rm(list=ls())

library("shinyBS")
#library("chron")
library("jsonlite")
library("png")
#library("shinyTable")

source("www/jarplot.R")
source("www/json2R.R")
don<-readRDS("data/jardon.rds")

#######
shinyServer(function(input, output, clientData, session) {

  don14<-readRDS("data/jardin2014")
  
  tabal<-don[[4]]
  tabal<-subset(tabal, tabal$j != "")
  saveRDS(tabal,file="data/datal")
  tab<-don[[3]]
  l<-length(tab)
  tab<-subset(tab,tab$nom != "" & tab$jar != "")
  saveRDS(tab,file="data/trees")

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
################verifs
output$verif<-renderTable({
'hello'
  
})

  ######## reprise du fichier tempar toute les 1 secondes   
  
  tempar<- reactiveFileReader(500, session, "data/tempar",readRDS)
 
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
    saveRDS(wh,"data/jsonessai.rds")
    
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
  return(m)
})



############envoi dxonnées pour remplissage des canvas au depart après choix d'un fichier RDS

jar<-reactive ({       
 input$jarold
  inFile <- input$jarold 
 if (is.null(inFile))
 { jar<-don[[2]]
        }else{
  jar<-readRDS(inFile$datapath)
  jar<-jar[[2]]
  }
  return(jar)

})


observe({
 jar()
  if(!is.null(jar()))
{
     
    newdon<-jar()
    tempar<-subset(newdon,select=c(parcelle,jardin,texver,legume,nbran,datesem,dateplant,daterec,
                                   finrec,comment,legume2,nbran2,datesem2,dateplant2,daterec2,
                                   finrec2,comment2))
    leg14<-readRDS("data/jardin2014")
    saveRDS(tempar,file="data/tempar")   
    observe({  
      #newdon <- readRDS("~/ajar/jarplan/data/newdon.rds")
      #newdon<-newdon()
      newdon_h<-subset(newdon,jardin=="H")
      donjson_h<-toJSON(newdon_h)
      trees<-readRDS("data/trees")
      trih<-toJSON(subset(trees,trees$jar=="H"))
      datal<-readRDS("data/datal")
      alh<-toJSON(subset(datal,datal$j=="H"))
      param <- read.csv("data/param.csv",stringsAsFactors =FALSE)
      parcol<-toJSON(param[,3])
      session$sendCustomMessage(type='fill_h1',message=list(leg=donjson_h,tree=trih,al=alh))
      session$sendCustomMessage(type='fill_h2',message=list(leg=donjson_h,tree=trih,al=alh,col=parcol))
      
      
    })
    
    observe({  
      #newdon <- newdon()
      newdon_m<-subset(newdon,jardin=="M")
      donjson_m<-toJSON(newdon_m) 
      trees<-readRDS("data/trees")
      trim<-toJSON(subset(trees,trees$jar=="M"))
      datal<-readRDS("data/datal")
      alm<-toJSON(subset(datal,datal$j=="M"))
      param <- read.csv("data/param.csv",stringsAsFactors =FALSE)
      parcol<-toJSON(param[,3])
      session$sendCustomMessage(type='fill_m1',message=list(leg=donjson_m,tree=trim,al=alm))
      session$sendCustomMessage(type='fill_m2',message=list(leg=donjson_m,tree=trim,al=alm,col=parcol))
      
    })
    
    observe({  
      #newdon <- readRDS("data/newdon")
      newdon_b<-subset(newdon,jardin=="B")
      donjson_b<-toJSON(newdon_b)
      trees<-readRDS("data/trees")
      trib<-toJSON(subset(trees,trees$jar=="B"))
      datal<-readRDS("data/datal")
      alb<-toJSON(subset(datal,datal$j=="B"))
      param <- read.csv("data/param.csv",stringsAsFactors =FALSE)
      parcol<-toJSON(param[,3])
      session$sendCustomMessage(type='fill_b1',message=list(leg=donjson_b,tree=trib,al=alb))
      session$sendCustomMessage(type='fill_b2',message=list(leg=donjson_b,tree=trib,al=alb,col=parcol))
    })
    

##################### calendrier legumes
# 
# output$planleg<- renderUI ({ 
#   
#    newdon<-newdon()
#   data<-newdon[newdon[,13]!="aucun",]
#   l<-length(data$legume)
#   output$plot<-renderPlot({planleg(data=data,date=input$dateleg,an=2015)})
#   
#   w<-"800px"
#   h <-paste0(30*l+200,"px")
#   
#   plotOutput("plot",width=w,height=h)
#   
#   
# })
# 

###########tableau des legumes
# 
# output$tableg <-  renderDataTable({
#  # m<-json2Ractu(wh=wh(),wm=wm(),wb=wb())
#   m<-newdon()
#   leg2015<-tableg(datan=m,an=2015)
#   leg2014<-tableg(datan=don14,an=2014)
#   
#   legan<-merge(leg2014,leg2015,by="Legume",all=TRUE,sort=TRUE)
#   legan<-legan[order(legan$Legume),]
#   return(legan)
# },options = list(bSortClasses = TRUE,aLengthMenu = c(10, 25, 50), 
#                  iDisplayLength = 50)
# )
# ######### tableau des parcelles
# 
# output$tabparcel<- renderDataTable({
#   
#   newdon<-newdon()
#   tab<-data.frame(identifiant=newdon$parcelle,
#                   jardin=newdon$jardin,
#                   legume=editleg((newdon$legume)),
#                   long= as.numeric(newdon$height)/caro,
#                   larg=as.numeric(newdon$width)/caro,
#                   rangs=as.numeric(newdon$nbran),
#                   lon=0,commentaires=newdon$comment)
#   
#   for (i in 1:nrow(tab))
#   {
#     tab$lon[i]<-round(max(tab$long[i],tab$larg[i])*tab$rangs[i],0)
#   }
#   
#   tab[,c(1,2,3,6,7,8)]
# },
# 
# options = list(bSortClasses = TRUE,aLengthMenu = c(10, 30, 60), 
#                iDisplayLength = 30,
#                aoColumnDefs = list(list(sWidth=c("80px"), aTargets=c(list(0),list(1),list(2),list(3),list(4)))))
# #fnInitComplete = I("function(oSettings, json) {alert('Done.');}"))
# 
# )
# 

##################

observe({
  input$parnew
  parc<-readRDS("data/tempar")
  par<-parc$parcelle
  session$sendCustomMessage(type='tempar',par)
  
})



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
    data<-tempar()
    selsup<-which(data$parcelle == input$parsup)
    if(length(selsup)!=0)
      {
     data<-data[-selsup,]
     saveRDS(data,file="data/tempar") 
      }}

})
#######
########### table interactive des parcelles
output$tabpar<- renderTable({
  tempar()
  tab<-data.frame(parcelle=tempar()[,1],
                  jardin=tempar()[,2],
                  legume=editleg(tempar()[,4]))
  
  
  return(tab)
  
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

############### chemins

output$chemh1<-output$chemh2 <-renderPlot ({
  chemin()  
})

output$chem1 <-output$chem2 <-renderPlot ({
  chemin()  
})

output$chemb1 <- output$chemb2 <- renderPlot ({
  chemin(N=c(0,0.5,0.1,0.5))  
})



###########sauvegarde
output$fichactu <- downloadHandler(
  filename = function() { paste0("jardin_",Sys.Date(),".rds")},
  
  content = function(file) {
  
    dimjars<-data.frame( long=c(23,60,60),larg=c(21,10,15))
    #leg<- readRDS("data/newdon")
    leg<-newdon()
    trees<-don[[3]]
    datal<-don[[4]]
    
    jardon<-list(dimjars,leg,trees,datal)
    
    saveRDS(jardon,file)
    
  },contentType = 'application/RDS'
)


  }
})

#########fin
})


