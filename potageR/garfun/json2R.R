#  Copyright (C) 2014 Jean-luc Reuillon
#  This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
#  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#  You should have received a copy of the GNU General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.

json2Ractu <- function(wh,wm,wb){

  hauth<-23
  veg<- readRDS("data/tempar")
  veg_h<-subset(veg,jardin=="H")
 
  if(nrow(veg_h)!=0) 
  {
  veg_h$numleg<-list(c(0))
  veg_h$numleg2<-list(c(0))
  

  for (i in 1:nrow(veg_h))
  {
    
    veg_h$numleg[[i]]<-match( veg_h$legume[[i]],param$list)
    veg_h$numleg2[[i]]<-match( veg_h$legume2[[i]],param$list)
  }

  ############
 
 # parjs_h<-readRDS("data/jsonessai.rds")
  parjs_h<-wh
  parjs_h$colegi<-parjs_h$left/caro
  parjs_h$colege<-(parjs_h$left+parjs_h$width)/caro 
  parjs_h$linegi<-hauth-(parjs_h$top+parjs_h$height)/caro
  parjs_h$linege<-hauth-parjs_h$top/caro
  
  zh<-merge(parjs_h,veg_h,by="parcelle")
  }else{
    zh<-NULL
  }  
  
####### pour jardin du milieu

#caro<-40
hautm<-60

veg<- readRDS("data/tempar")
veg_m<-subset(veg,jardin=="M")

if(nrow(veg_m)!=0) 
{
veg_m$numleg<-list(c(0))
veg_m$numleg2<-list(c(0))

for (i in 1:nrow(veg_m))
{
  veg_m$numleg[[i]]<-match( veg_m$legume[[i]],param$list)
  veg_m$numleg2[[i]]<-match( veg_m$legume2[[i]],param$list)
}

#parjs_m<-readRDS("data/canm")
parjs_m<-wm
parjs_m$colegi<-parjs_m$left/caro
parjs_m$colege<-(parjs_m$left+parjs_m$width)/caro 
parjs_m$linegi<-hautm-(parjs_m$top+parjs_m$height)/caro
parjs_m$linege<-hautm-parjs_m$top/caro

zm<-merge(parjs_m,veg_m,by="parcelle")
}else{
  zm<-NULL
}

####### pour jardin du bas

#caro<-40
hautb<-60

veg<- readRDS("data/tempar")

veg_b<-subset(veg,jardin=="B")

if(nrow(veg_b)!=0)
{
veg_b$numleg<-list(c(0))
veg_b$numleg2<-list(c(0))

for (i in 1:nrow(veg_b))
{
  veg_b$numleg[[i]]<-match( veg_b$legume[[i]],param$list)
  veg_b$numleg2[[i]]<-match( veg_b$legume2[[i]],param$list)
}

#parjs_b<-readRDS("data/canb")
parjs_b<-wb
parjs_b$colegi<-parjs_b$left/caro
parjs_b$colege<-(parjs_b$left+parjs_b$width)/caro 
parjs_b$linegi<-hautb-(parjs_b$top+parjs_b$height)/caro
parjs_b$linege<-hautb-parjs_b$top/caro

zb<-merge(parjs_b,veg_b,by="parcelle")
}else{
  zb<-NULL
}

#############
  
  z<-rbind(zh,zm,zb) 
  if(is.null(z)) return(NULL)

    z$texver<-ifelse(z$width>z$height,"H","V")
    z$parcelle<-as.character(z$parcelle)
  
  return(z)
}

####################################traitement fichier json en csv
extract_can <- function(tabx){
  
   #tabx<-readRDS("jarplan/data/jsonessai.rds")
  #tabx<-readRDS(paste0(dir,"jares/data/rjon_m.RDS"))
  
  
  parx<-data.frame(type=tabx[[1]],left=tabx[[4]],top=tabx[[5]],width=tabx[[6]],height=tabx[[7]])

  parcelle<-c("")
 l<-nrow(tabx)
  for( i in 1:l)
  {
    if(length(tabx$objects[[i]]$text[2])>0)
    {
      parcelle[i]<-tabx$objects[[i]]$text[2]
    }
   
  }
  parcelle<-as.data.frame(parcelle)

  par_x<-cbind(parcelle,parx)
#   }else{
#    par_x<-data.frame(parcelle="test",type="group",left=0,top=0,widh=0,height=0)
#   }
  
  return(par_x)
  #saveRDS(par_x,file=paste0("data/",file))
  
}


