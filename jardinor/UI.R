library("shiny")
library("shinyBS")
library("shinyTable")
library("jsonlite")
#library("reshape2")
#library("rCharts")
library("png")
options(RCHART_WIDTH = 800, RCHART_HEIGHT = 400)
##########
shinyUI(navbarPage(
         
             h2("Garden",  tags$img(src="Rlogo.png", width="40px",height="40px")),              
                   
                   tabPanel(h4("Home"),
                            
                            headerPanel("",
                                        
                                        tags$head(
                                          
                                          includeScript("filop/newfabric.js"),
                                          includeScript("filop/adelar.js"),
                                          #includeScript("filop/supev.js"),
                                          includeScript("filop/fabric.min.js"),
                                          includeScript("filop/lert.js"), 
                                          includeCSS("www/css/style.css"),
                                          includeCSS("www/css/lert.css"),
                                          includeCSS("www/css/bundled-css.css")
                                        )),               
                            
                            
                            
                            fluidRow(
                              
                              column(5,
                     tags$img(src="jardino.png", id="pot", width="450px",height="490px")  
                                     
                              ),
                              column(6,
                                     h2("Organiseur de jardin potager :"),        
                            h4("Structures:"),
                            h6("A la première utilisation, définir les",span("dimensions ",style="color:blue"), "du ou des jardins",
                            "puis positionner les", span("arbres fruitiers ",style="color:blue"), "et les", span("allées. ",style="color:blue"),
                              " Sauvegarder le fichier et le recharger pour que ces éléments apparaissent dans le jardin des légumes."),
                            br(),
                            h4("Légumes: plan des légumes de l'année en cours."),
                            h6("Cliquer sur", span("creer ",style="color:blue"), "puis dessiner une parcelle avec la souris et la nommer.",
                            "Selectionner un ou des légumes et le nombre de rangs sur le panneau de gauche.",
                              "Renseigner les dates de semis, plantation et récolte probables puis plus tard réalisées.",
                             "Faire de même pour la periode 2 avant d'", span("enregistrer ",style="color:blue"), "la parcelle."),
                           br(),
                            h4("Sauvegarder avant de quitter l'application:"),
                            
    h6("Aucune donnée n'est persistante.
       Aussi, avant de quitter l'application,", downloadButton("fichactu","Sauvegarder"),"le projet dans un fichier,
       pour pouvoir le", span("reprendre",style="color:blue;"), "plus tard.",br(),br(),
       fileInput('jarold', "",accept='.RDS'))           
                                 
            
                            
                           ))),   
                   
                   ################
                   tabPanel(h4("Structures"),
                            tabsetPanel(
                              tabPanel(h4("1er jardin"),
                                      
                                       fluidRow(
                                         column(2,  
                                               textInput("jar1nom","Nom :"),
                                                h4("Dimensions du jardin"), 
                                               wellPanel(
                                                 sliderInput("larg1","Largeur:",min=0,max=30,step=1,value=21),
                                                 sliderInput("long1","Longeur:",min=0,max=60,step=1,value=23)),
                                                
                                               h4("Allées"), 
                                               wellPanel(id="al1",
                                                        h6('Cliquer sur le plan,',style="color:purple"),
                                                         em(textOutput("jarpal1"),style="color:red"),
                                                         em('puis attribuer les coordonnées du point à ',style="color:purple"), br(),
                                                 fluidRow(
                                                   
                                                   column(6,  
                                                         
                                                          actionButton("A1","un bout",icon=icon("fa fa-pencil fa-fw")),
                                                          numericInput("alox1","X",value=10),
                                                          numericInput("aloy1","Y",value=1)),
                                                   column(6, 
                                                          actionButton("B1","à l'autre",icon=icon("fa fa-pencil fa-fw")),
                                                          numericInput("albax1","X",value=10),
                                                          numericInput("albay1","Y",value=5))),
                                                 
                                                # h5( tags$input(type = "button",id = "gocolal1" ,value="Appliquer cette couleur:"),
                                                 #    tags$input(type = "color",id = "colal1" ,value="#efeef2")),
                                                 h5(
                                                   tags$input(type = "button",id = "adal1" ,value="Ajouter cette allée"),
                                                   br(), br(),
                                                   tags$input(type = "button",id = "supal1" ,value="Supprimer une allée")))),
                                         
                                                
                                      
                                         column(8,                        
                                                             
                                                uiOutput("plotjar1")
                                                   ),
                                         column(2,
                                               
                                                h4("Arbres"),
                                                wellPanel(
                                                  h6('Cliquer sur le plan',style="color:purple"),                                                  
                                                  em(textOutput("jartri1"),style="color:red;",align="left"),
                                                  em('puis attribuer les coordonnées du point ',style="color:purple"), br(),
                                                  actionButton("C1","en cliquant ici",icon= icon("fa fa-pencil fa-fw")),
                                                  em('ou en les rentrant manuellement ici:',style="color:purple"), br(),
                                                    numericInput("trix1","largeur...:",value=5),br(),
                                                     numericInput("triy1","Longueur:",value=5),
                                                  
                                                  selectInput("esp1","Espèce",choices=c("pommier"=1,
                                                                                        "abricotier"=2,
                                                                                        "cerisier"=3,
                                                                                        "poirier"=4,
                                                                                        "prunier"=5,
                                                                                        "pêcher"=6,
                                                                                        "rhubarbe"=7,
                                                                                        "groseiller"=8)),
                                                  textInput("var1","Variété"),    
                                                  selectInput("size1","Grosseur de l'icone",choices=c("petit"=1,
                                                                                                      "moyen"=1.5,
                                                                                                      "gros"=2 ,
                                                                                                      "très gros"=2.5)),
                                                  numericInput("plantan1","Année de plantation",value=format(Sys.Date(),"%Y")),
                                                  textInput("div1","commentaires"),
                                                  tags$input(type = "button",id = "adarb1" ,value="Ajouter cette plante"),
                                                  br(),br(),
                                                  tags$input(type = "button",id = "suparb1" ,value="Supprimer une plante")
                                                ))),
                                       uiOutput("tabjar1")
                                       ),
                                                
                                             
                                         
                                         
                              
                              tabPanel(h4("2ème jardin"),
                                       fluidRow(
                                         column(2,  
                                                textInput("jar2nom","Nom :"),
                                                h4("Dimensions du jardin"), 
                                                wellPanel(
                                                  sliderInput("larg2","Largeur:",min=0,max=30,step=1,value=10),
                                                  sliderInput("long2","Longeur:",min=0,max=60,step=1,value=60)),
                                                
                                                h4("Allées"), 
                                                wellPanel(id="al2",
                                                          h6('Cliquer sur le plan,',style="color:purple"),
                                                          em(textOutput("jarpal2"),style="color:red"),
                                                          em('puis attribuer les coordonnées du point à ',style="color:purple"), br(),
                                                          fluidRow(
                                                            
                                                            column(6,  
                                                                   
                                                                   actionButton("A2","un bout",icon=icon("fa fa-pencil fa-fw")),
                                                                   numericInput("alox2","X",value=10),
                                                                   numericInput("aloy2","Y",value=1)),
                                                            column(6, 
                                                                   actionButton("B2","à l'autre",icon=icon("fa fa-pencil fa-fw")),
                                                                   numericInput("albax2","X",value=10),
                                                                   numericInput("albay2","Y",value=5))),
                                                          
                                                          # h5( tags$input(type = "button",id = "gocolal1" ,value="Appliquer cette couleur:"),
                                                          #    tags$input(type = "color",id = "colal1" ,value="#efeef2")),
                                                          h5(
                                                            tags$input(type = "button",id = "adal2" ,value="Ajouter cette allée"),
                                                            br(), br(),
                                                            tags$input(type = "button",id = "supal2" ,value="Supprimer une allée")))),
                                         
                                         
                                         
                                         column(8,                        
                                                
                                                uiOutput("plotjar2")
                                         ),
                                         column(2,
                                                
                                                h4("Arbres"),
                                                wellPanel(
                                                  h6('Cliquer sur le plan',style="color:purple"),                                                  
                                                  em(textOutput("jartri2"),style="color:red;",align="left"),
                                                  em('puis attribuer les coordonnées du point ',style="color:purple"), br(),
                                                  actionButton("C2","en cliquant ici",icon= icon("fa fa-pencil fa-fw")),
                                                  em('ou en les rentrant manuellement ici:',style="color:purple"), br(),
                                                  numericInput("trix2","largeur...:",value=5),br(),
                                                  numericInput("triy2","Longueur:",value=5),
                                                  
                                                  selectInput("esp2","Espèce",choices=c("pommier"=1,
                                                                                        "abricotier"=2,
                                                                                        "cerisier"=3,
                                                                                        "poirier"=4,
                                                                                        "prunier"=5,
                                                                                        "pêcher"=6,
                                                                                        "rhubarbe"=7,
                                                                                        "groseiller"=8)),
                                                  textInput("var2","Variété"),    
                                                  selectInput("size2","Grosseur de l'icone",choices=c("petit"=1,
                                                                                                      "moyen"=1.5,
                                                                                                      "gros"=2 ,
                                                                                                      "très gros"=2.5)),
                                                  numericInput("plantan2","Année de plantation",value=format(Sys.Date(),"%Y")),
                                                  textInput("div2","commentaires"),
                                                  tags$input(type = "button",id = "adarb2" ,value="Ajouter cette plante"),
                                                  br(),br(),
                                                  tags$input(type = "button",id = "suparb2" ,value="Supprimer une plante")
                                                ))),
                                       uiOutput("tabjar2")
                              ),

                              tabPanel(h4("3ème jardin"),                                      
                                       fluidRow(
                                         column(2,  
                                                textInput("jar3nom","Nom :"),
                                                h4("Dimensions du jardin"), 
                                                wellPanel(
                                                  sliderInput("larg3","Largeur:",min=0,max=30,step=1,value=15),
                                                  sliderInput("long3","Longeur:",min=0,max=60,step=1,value=60)),
                                                
                                                h4("Allées"), 
                                                wellPanel(id="al3",
                                                          h6('Cliquer sur le plan,',style="color:purple"),
                                                          em(textOutput("jarpal3"),style="color:red"),
                                                          em('puis attribuer les coordonnées du point à ',style="color:purple"), br(),
                                                          fluidRow(
                                                            
                                                            column(6,  
                                                                   
                                                                   actionButton("A3","un bout",icon=icon("fa fa-pencil fa-fw")),
                                                                   numericInput("alox3","X",value=10),
                                                                   numericInput("aloy3","Y",value=1)),
                                                            column(6, 
                                                                   actionButton("B3","à l'autre",icon=icon("fa fa-pencil fa-fw")),
                                                                   numericInput("albax3","X",value=10),
                                                                   numericInput("albay3","Y",value=5))),
                                                          
                                                          # h5( tags$input(type = "button",id = "gocolal1" ,value="Appliquer cette couleur:"),
                                                          #    tags$input(type = "color",id = "colal1" ,value="#efeef3")),
                                                          h5(
                                                            tags$input(type = "button",id = "adal3" ,value="Ajouter cette allée"),
                                                            br(), br(),
                                                            tags$input(type = "button",id = "supal3" ,value="Supprimer une allée")))),
                                         
                                         
                                         
                                         column(8,                    
                                                
                                                uiOutput("plotjar3")
                                         ),
                                         column(2,
                                                
                                                h4("Arbres"),
                                                wellPanel(
                                                  h6('Cliquer sur le plan',style="color:purple"),                                                  
                                                  em(textOutput("jartri3"),style="color:red;",align="left"),
                                                  em('puis attribuer les coordonnées du point ',style="color:purple"), br(),
                                                  actionButton("C3","en cliquant ici",icon= icon("fa fa-pencil fa-fw")),
                                                  em('ou en les rentrant manuellement ici:',style="color:purple"), br(),
                                                  numericInput("trix3","largeur...:",value=5),br(),
                                                  numericInput("triy3","Longueur:",value=5),
                                                  
                                                  selectInput("esp3","Espèce",choices=c("pommier"=1,
                                                                                        "abricotier"=2,
                                                                                        "cerisier"=3,
                                                                                        "poirier"=4,
                                                                                        "prunier"=5,
                                                                                        "pêcher"=6,
                                                                                        "rhubarbe"=7,
                                                                                        "groseiller"=8)),
                                                  textInput("var3","Variété"),    
                                                  selectInput("size3","Grosseur de l'icone",choices=c("petit"=1,
                                                                                                      "moyen"=1.5,
                                                                                                      "gros"=2 ,
                                                                                                      "très gros"=2.5)),
                                                  numericInput("plantan3","Année de plantation",value=format(Sys.Date(),"%Y")),
                                                  textInput("div3","commentaires"),
                                                  tags$input(type = "button",id = "adarb3" ,value="Ajouter cette plante"),
                                                  br(),br(),
                                                  tags$input(type = "button",id = "suparb3" ,value="Supprimer une plante")
                                                ))),
                                       uiOutput("tabjar3")                                 
                                       ),
                              
                              tabPanel(h4("Plantes perennes"),
                                       dataTableOutput("tabarb"))         
                            )),                 
#########################"               
  
   tabPanel(h4("Légumes"),

      
    
    fluidRow(
      column(3,

       
        fluidRow(
         column(3,
        
    #textOutput('verif'),
     #textOutput('verisame'),
      wellPanel(   
         div(id="legicon",
      tags$div(tags$img(src="aucun.png", id="aucun", width="50px"),title="à définir",class="tip"), 
      tags$div(tags$img(src="artich.png", id="artich"), title="artichaut",class="tip"),
      tags$div( tags$img(src="asperg.png", id="asperg"), title="asperges",class="tip"),
      tags$div( tags$img(src="auber.png", id="auber"),title ="aubergines",class="tip"),
      tags$div( tags$img(src="betrav.png", id="betrav"),title="betteraves",class="tip"),     
      tags$div( tags$img(src="chard.png", id="chard"),title="bettes",class="tip"), 
      tags$div( tags$img(src="carot.png", id="carot"),title="carottes",class="tip"),            
      tags$div( tags$img(src="celeriac.png", id="celeriac"),title="celeris",class="tip"),            
      tags$div( tags$img(src="chou.png", id="chou"),title="choux",class="tip"),                         
      tags$div( tags$img(src="conc.png", id="conc"),title="concombres",class="tip"),
      tags$div( tags$img(src="courg.png", id="courg"),title="courgettes",class="tip"),
      tags$div( tags$img(src="endiv.png", id="endiv"),title="endives",class="tip"),
      tags$div( tags$img(src="fennel.png", id="fennel"),title="fenouils",class="tip"),
      tags$div( tags$img(src="feve.png", id="feve"),title="feves",class="tip"),
      tags$div( tags$img(src="fraise.png", id="fraise"),title="fraises",class="tip"),
      tags$div( tags$img(src="framb.png", id="framb"),title="framboises",class="tip"),
      tags$div( tags$img(src="bean.png", id="bean"),title="haricots grains",class="tip"),
      tags$div( tags$img(src="haricov.png", id="haricov"),title="haricots verts",class="tip"),
      tags$div( tags$img(src="epima.png", id="epima"),title="mais",class="tip"),
      tags$div( tags$img(src="onion.png", id="onion"),title="oignons",class="tip"),
      tags$div( tags$img(src="panais.png", id="panais"),title="panais",class="tip"),
      tags$div( tags$img(src="leek.png", id="leek"),title="poireaux",class="tip"),
      tags$div( tags$img(src="pois.png", id="pois"),title="pois",class="tip"),      
      tags$div( tags$img(src="pepper.png", id="pepper"),title="poivrons",class="tip"),
      tags$div( tags$img(src="potato.png", id="potato"),title="pomme de terre",class="tip"),
      tags$div( tags$img(src="pum.png", id="pum"),title="potirons",class="tip"),
      tags$div( tags$img(src="radis.png", id="radis"),title="radis",class="tip"),
      tags$div( tags$img(src="salad.png", id="salad"),title="salades",class="tip"),
      tags$div( tags$img(src="tomat.png", id="tomat"),title="tomates",class="tip"),
      tags$div( tags$img(src="turnip.png", id="turnip"),title="navets",class="tip"),
      tags$div( tags$img(src="spin.png", id="spin"),title="epinards",class="tip"),
      tags$div( tags$img(src="mache.png", id="mache"),title="maches",class="tip"),
      br(),
      br(),
      tags$div( tags$img(src="tree_apple.png", id="apple"),title="pommier",class="tip"),
      tags$div( tags$img(src="tree_apricot.png", id="apricot"),title="abricotier",class="tip"),
      tags$div( tags$img(src="tree_cherry.png", id="cherry"),title="cerisier",class="tip"),
      tags$div( tags$img(src="tree_pear.png", id="pear"),title="poirier",class="tip"),
      tags$div( tags$img(src="tree_plum.png", id="plum"),title="prunier",class="tip"),
      tags$div( tags$img(src="tree_peach.png", id="peach"),title="pècher",class="tip"),
      tags$div( tags$img(src="tree_rubarb.png", id="rubarb"),title="rhubarbe",class="tip"),
      tags$div( tags$img(src="tree_gb.png", id="gb"),title="groseiller",class="tip")
      ))),
  
  column(9, 
          
         wellPanel(         
         h2("Période 1"),
         h5(numericInput("rang1","",value=0),"rangs de :"),
         checkboxGroupInput("legum1","",choices=read.csv("data/param.csv",stringsAsFactors =FALSE)$list
                            ,selected=read.csv("data/param.csv",stringsAsFactors =FALSE)$list[1]),
         
         dateInput(inputId="sem1",label="Semis",format="yyyy-mm-dd",language="fr",value="2015-03-01"),
         dateInput(inputId="plant1",label="Plantation",format="yyyy-mm-dd",language="fr",value="2015-03-01"),
         dateInput(inputId="rec1",label="Recolte",format="yyyy-mm-dd",language="fr",value="2015-03-01"),
         dateInput(inputId="finrec1",label="Fin recolte",format="yyyy-mm-dd",language="fr",value="2015-03-01"),
         h5("Commentaires:"),
         tags$textarea(id="com1", rows=2, cols=24, "Com1")),
       #  tags$img(src="aqualeg1.jpg", width="150px",height="20px")),
         
         
  wellPanel(
    h2("Période 2"),
    h5(numericInput("rang2","",value=0)," rangs de :"),
    checkboxGroupInput("legum2","",choices=read.csv("data/param.csv",stringsAsFactors =FALSE)$list,
                       selected=read.csv("data/param.csv",stringsAsFactors =FALSE)$list[1]),
  
  #h5(verbatimTextOutput("lonleg2")),          
  dateInput(inputId="sem2",label="Semis",format="yyyy-mm-dd",language="fr",value="2015-03-01"),
  dateInput(inputId="plant2",label="Plantation",format="yyyy-mm-dd",language="fr",value="2015-03-01"),
  dateInput(inputId="rec2",label="Recolte",format="yyyy-mm-dd",language="fr",value="2015-03-01"),
  dateInput(inputId="finrec2",label="Fin recolte",format="yyyy-mm-dd",language="fr",value="2015-03-01"),
  h5("Commentaires:"),
  HTML('<textarea id="com2" rows="2" cols="20">ajouter commentaire</textarea>')),
  #tags$img(src="alegume1.jpg", id="test", width="300px",height="20px")),
  
 
  br(),
  tableOutput("tabpar")
  
    ))),
  column(1),
  column(8,

    tabsetPanel(
                
          ###################
          tabPanel(h4(textOutput("nomjard1")), 
                   tabsetPanel(
                     tabPanel(h5("Période 1"),  
                              textOutput('parselh'),
                              tags$input(type = "button",id = "pos" ,value="Creer"),
                              tags$input(type = "button",id = "rec" ,value="Enregistrer"),
                              
                              tags$input(type = "button",id = "del" ,value="Supprimer"),
                              
                              tags$input(type = "button",id = "png" ,value="Image"),
                              
                              
                              tags$canvas(id="canh1",style="border:3px solid #0000ff"),
                              
                              h4("Choisir la couleur du fond -->",
                                 tags$input(type = "color",id = "colh" ,value="#efeef2"),
                                 tags$input(type = "button",id = "gocolh" ,value="appliquer cette couleur"),
                                 tags$input(type = "button",id = "ungrid" ,value="ôter la grille"),
                                 tags$input(type = "button",id = "grid" ,value="remettre la grille")
                                 
                              )),
                     tabPanel(h5("Période 2"), 
                              tags$canvas(id="canh2",style="border:3px solid #0000ff")),
                             
                     
                     tabPanel(h5("Archives"), 
                              fluidRow(
                                column(1, 
                                       #  sliderInput("anm","",min=2014,max=2015,value=2014,step=1,animate=T),
                                       radioButtons("ano","",choices=c(2014,2015))),
                                column(8,
                                       plotOutput("archo",width="700px",height="850px"))
                                
                              )))), 
          
          ###############
          tabPanel(h4(textOutput("nomjard2")), 
                   tabsetPanel(id="jami",
                               tabPanel(h5("Période 1"),      
                                        textOutput('parselm'),
                                        tags$input(type = "button",id = "pos_m" ,value="Creer"),
                                        tags$input(type = "button",id = "rec_m" ,value="Enregistrer"),
                                        
                                        tags$input(type = "button",id = "del_m" ,value="Supprimer"),
                                        
                                        tags$input(type = "button",id = "png_m" ,value="Image"), 
                                       
                                                 tags$canvas(id="cam1",style="border:3px solid #0000ff"),
                                        
                                                 tags$input(type = "button",id = "gocolm" ,value="appliquer la couleur -->"),
                                                 tags$input(type = "color",id = "colm" ,value="#efeef2"),
                                                 tags$input(type = "button",id = "ungrid_m" ,value="ôter la grille"),
                                                 tags$input(type = "button",id = "grid_m" ,value="remettre la grille")),
                               
                               tabPanel(h5("Période 2"),              
                                        tags$canvas(id="cam2",style="border:3px solid #0000ff")),
                               
                               tabPanel(h5("Archives"),  
                                        fluidRow(
                                          column(1, 
                                                 #  sliderInput("anm","",min=2014,max=2015,value=2014,step=1,animate=T),
                                                 radioButtons("anm","",choices=c(2014,2015))),
                                          column(8,
                                                 plotOutput("jaromil",width="400px",height="2200px"))
                                          
                                        )))), 
          
          
          ###############
          tabPanel(h4(textOutput("nomjard3")), 
                   tabsetPanel(id="jaba",
                               tabPanel(h5("Période 1"),  
                                        
                                        textOutput('parselb'),
                                        tags$input(type = "button",id = "pos_b" ,value="Creer"),
                                        tags$input(type = "button",id = "rec_b" ,value="Enregistrer"),
                                        
                                        tags$input(type = "button",id = "del_b" ,value="Supprimer"),
                                        
                                        tags$input(type = "button",id = "png_b" ,value="Image"),
                                        
                                       
                                                 tags$canvas(id="cab1",style="border:3px solid #0000ff"),
                         
                                                 tags$input(type = "button",id = "gocolb" ,value="appliquer la couleur ->"),
                                                 tags$input(type = "color",id = "colb" ,value="#efeef2"),
                                                 tags$input(type = "button",id = "ungrid_b" ,value="ôter la grille"),
                                                 tags$input(type = "button",id = "grid_b" ,value="remettre la grille")    
                                          ),
                               tabPanel(h5("Période 2"), 
                                        tags$canvas(id="cab2",style="border:3px solid #0000ff")
                                       
                               ),
                               
                               
                               tabPanel(h5("Archives"),               
                                        fluidRow(
                                          column(1, 
                                                 #  sliderInput("anm","",min=2014,max=2015,value=2014,step=1,animate=T),
                                                 radioButtons("anb","",choices=c(2014,2015))),
                                          column(8,
                                                 plotOutput("jaroba",width="600px",height="2000px")
                                                 
                                          ))))))))),
          
    
  ##########
  tabPanel(h4("Calendrier"),
  dateInput(inputId="dateleg",label="Date",format="yyyy-mm-dd",language="fr",value=Sys.Date()),
      fluidRow(
        column(6,   
  h3("Planning 2015"),
            
              uiOutput("planleg")),
  column(6, 
             # h3("Archives"),
              
              sliderInput("anileg","annee",min=2014,max=2015,value=2014,step=1,animate=T),
              uiOutput("planlegold")))),
     
     #####################
tabPanel(h4("Tableaux"),
    fluidRow(
      column(5,
    h4("Liste des legumes"),       
        dataTableOutput("tableg")),
      column(7,
     h4("Liste des parcelles"),     
        dataTableOutput("tabparcel")))),

tabPanel(h4("Couleurs"),
         fluidRow(
           
           column(4,
                  plotOutput("couplot",height="800px")),
           column(6,
                  h4("Choix de la couleur:",       
                     tags$input(type = "color",id = "colparam" ,value="#efeef2")),
                  tags$input(type = "button",id = "gocolparam" ,value="Affecter au legume"),
                  br(),
                  br(),
                  selectInput("hexaleg","",choices=read.csv("data/param.csv",stringsAsFactors =FALSE)$list,   multiple=F,selectize=F)
                  
           )))





            ))
