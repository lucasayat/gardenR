library("shiny")
library("shinyBS")
#library("shinyTable")
library("jsonlite")
#library("rCharts")
library("png")
options(RCHART_WIDTH = 800, RCHART_HEIGHT = 400)
##########
shinyUI(pageWithSidebar(

        headerPanel("",
                             
               tags$head(
    tags$script(type="text/javascript", src = "newfabric.js"),
    tags$script(type="text/javascript", src = "fabric.min.js"),
    tags$script(type="text/javascript", src = "lert.js"),
    
    tags$link(rel="stylesheet", type="text/css",href="style.css"),
    tags$link(rel="stylesheet", type="text/css",href="lert.css")
     )),
      
sidebarPanel(id="pan1",
   # checkboxInput('jarmem','Utiliser le fichier en memoire.'),  
   downloadButton("fichactu","Sauvegarder"),
    fileInput('jarold', "",accept='.RDS'),  
    
    
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
         dateInput(inputId="plant1",label="Plant.",format="yyyy-mm-dd",language="fr",value="2015-03-01"),
         dateInput(inputId="rec1",label="Recolte",format="yyyy-mm-dd",language="fr",value="2015-03-01"),
         dateInput(inputId="finrec1",label="Fin rec.",format="yyyy-mm-dd",language="fr",value="2015-03-01"),
         h5("Commentaires:"),
         tags$textarea(id="com1", rows=2, cols=24, "Com1"),
         tags$img(src="aqualeg1.jpg", width="150px",height="20px")),
         
         
  wellPanel(
    h2("Période 2"),
    h5(numericInput("rang2","",value=0)," rangs de :"),
    checkboxGroupInput("legum2","",choices=read.csv("data/param.csv",stringsAsFactors =FALSE)$list,
                       selected=read.csv("data/param.csv",stringsAsFactors =FALSE)$list[1]),
  
  #h5(verbatimTextOutput("lonleg2")),          
  dateInput(inputId="sem2",label="Semis",format="yyyy-mm-dd",language="fr",value="2015-03-01"),
  dateInput(inputId="plant2",label="Plant.",format="yyyy-mm-dd",language="fr",value="2015-03-01"),
  dateInput(inputId="rec2",label="Recolte",format="yyyy-mm-dd",language="fr",value="2015-03-01"),
  dateInput(inputId="finrec2",label="Fin rec.",format="yyyy-mm-dd",language="fr",value="2015-03-01"),
  h5("Commentaires:"),
  HTML('<textarea id="com2" rows="2" cols="20">ajouter commentaire</textarea>'),
  tags$img(src="alegume1.jpg", id="test", width="300px",height="20px")),
  
 
  br(),
  tableOutput("tabpar")
  
  ))),

    
  mainPanel(
    tabsetPanel(id="pan2",
                
          ###################
               tabPanel(h4("Jardin du Haut"), 
          tabsetPanel(
                tabPanel(h5("Période 1"),  
          textOutput('parselh'),
         tags$input(type = "button",id = "pos" ,value="Creer"),
         tags$input(type = "button",id = "rec" ,value="Enregistrer"),
      
         tags$input(type = "button",id = "del" ,value="Supprimer"),
      
         tags$input(type = "button",id = "png" ,value="Image"),
           
         
      tags$canvas(id="canh1",style="border:3px solid #0000ff"),
      plotOutput("chemh1",width="900px",height="50px"),
      h4("Choisir la couleur du fond -->",
         tags$input(type = "color",id = "colh" ,value="#efeef2"),
         tags$input(type = "button",id = "gocolh" ,value="appliquer cette couleur"),
         tags$input(type = "button",id = "ungrid" ,value="ôter la grille"),
         tags$input(type = "button",id = "grid" ,value="remettre la grille")
       
         )),
      tabPanel(h5("Période 2"), 
     tags$canvas(id="canh2",style="border:3px solid #0000ff"),
     plotOutput("chemh2",width="900px",height="50px")),
    
     tabPanel(h5("Archives"), 
              fluidRow(
                column(1, 
                       #  sliderInput("anm","",min=2014,max=2015,value=2014,step=1,animate=T),
                       radioButtons("ano","",choices=c(2014,2015))),
                column(8,
    plotOutput("archo",width="700px",height="850px"))
    
      )))), 

    ###############
    tabPanel(h4("Jardin du milieu"), 
                      tabsetPanel(id="jami",
                                  tabPanel(h5("Période 1"),      
             textOutput('parselm'),
             tags$input(type = "button",id = "pos_m" ,value="Creer"),
             tags$input(type = "button",id = "rec_m" ,value="Enregistrer"),
             
             tags$input(type = "button",id = "del_m" ,value="Supprimer"),
             
             tags$input(type = "button",id = "png_m" ,value="Image"), 
            
            fluidRow(
              column(6, 
             tags$canvas(id="cam1",style="border:3px solid #0000ff"),
             plotOutput("chem1",width="400px",height="50px")),

             column(2,
                    tags$input(type = "button",id = "gocolm" ,value="appliquer la couleur -->"),
                       tags$input(type = "color",id = "colm" ,value="#efeef2"),
                        tags$input(type = "button",id = "ungrid_m" ,value="ôter la grille"),
                        tags$input(type = "button",id = "grid_m" ,value="remettre la grille")))),
            
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
    tabPanel(h4("Jardin du bas"), 
             tabsetPanel(id="jaba",
                         tabPanel(h5("Période 1"),  
             
             textOutput('parselb'),
             tags$input(type = "button",id = "pos_b" ,value="Creer"),
             tags$input(type = "button",id = "rec_b" ,value="Enregistrer"),
             
             tags$input(type = "button",id = "del_b" ,value="Supprimer"),
             
             tags$input(type = "button",id = "png_b" ,value="Image"),
         
            fluidRow(
              column(9,
                      tags$canvas(id="cab1",style="border:3px solid #0000ff"),
                      plotOutput("chemb1",width="600px",height="50px")),
              column(2,
                     h4("Couleur:",
                        tags$input(type = "color",id = "colb" ,value="#efeef2")),
                     tags$input(type = "button",id = "gocolb" ,value="appliquer la couleur"),
                     br(),
                     tags$input(type = "button",id = "ungrid_b" ,value="ôter la grille"),
                     br(),
                     tags$input(type = "button",id = "grid_b" ,value="remettre la grille")    
                     ))),
            tabPanel(h5("Période 2"), 
                     tags$canvas(id="cab2",style="border:3px solid #0000ff"),
                     plotOutput("chemb2",width="600px",height="50px")
                     ),
              
                  
            tabPanel(h5("Archives"),               
                     fluidRow(
                       column(1, 
                              #  sliderInput("anm","",min=2014,max=2015,value=2014,step=1,animate=T),
                              radioButtons("anb","",choices=c(2014,2015))),
                       column(8,
            plotOutput("jaroba",width="600px",height="2000px")
             
    )))))
 
  
###############
            ))))