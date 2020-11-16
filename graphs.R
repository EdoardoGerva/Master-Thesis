
###### How to construct gprahs from archs #######

library(bnlearn)
#read the data
data <- read.csv("data_per_grafici//relief_iter10.txt",sep="")
data <- data[,2:3]
data_episcan  <- read.csv("Relieff_data//ReliefF_output_top400_corrected.csv")
nodes <- colnames(data_episcan)

e <- empty.graph(nodes)
arcs(e) = data
e


x <- as.graphNEL(e)
n <- nodes(e)
names(n) <- n


library(igraph)
links <- data

net <- graph_from_data_frame(d=links, vertices=nodes, directed=T) 
net <- simplify(net, remove.multiple = F, remove.loops = T) 

size <- nodes
rel <- read.csv("data_per_grafici//subnetwork_relief.txt",sep="")
rel <- unique(c(rel[,1],rel[,2]))

#set the sieze of nodes
size2 <- rep(0, times = length(size))
for(i in c(1:length(size))){
  if(size[i] %in% rel){
    cat('\nyes')
    size2[i] <- 7
  }
  else(size2[i] <- 1)
}
#set the labels, font and colors of nodes
colvert <- rep("0", times = nrow(totedg))
nm <- rep("0", times = length(size))
font <- rep(0, times = length(size))
for(i in c(1:length(size))){
  if(size[i] %in% rel){
    nm[i]<-size[i]
    font[i] <- 10
    colvert[i]<-"steelblue1"
  }
  else{font[i] <- 0
  nm[i]<-NA
  colvert[i]<-"skyblue1"
  }
}
#set size, arrows and colors of the edges
totedg <- data
rel2 <- read.csv("data_per_grafici//subnetwork_relief.txt",sep="")
edg <- rep(0, times = nrow(totedg))
arr <- rep(0, times = nrow(totedg))
col <- rep("0", times = nrow(totedg))
for(i in c(1:length(edg))){
  
  snp1<- totedg[i,1]
  snp2<- totedg[i,2]
  row1 <- data.frame(snp1=snp1, snp2=snp2)
  row2 <- data.frame(snp1=snp2, snp2=snp1)
  
  if(nrow(merge(row1,rel2))>0||nrow(merge(row2,rel2))>0){
    edg[i]<-15
    arr[i]<-8
    col[i]<-"steelblue1"
  }
  else{edg[i]<-1
  arr[i]<-1
  col[i]<-"gray66"
  }
}

#create the graph. position of the nodes in the image changes with the seed
set.seed(111)
name = paste("plot_seed_relief_",111,".png",sep="")
png(name, width = 6000, height = 10000)
  
plot(net, rescale=TRUE, edge.arrow.size=arr, edge.curved=.3,edge.width=edg,edge.color=col,
       vertex.color=colvert,vertex.frame.color="black",	 
       vertex.label=nm, vertex.label.color="black", vertex.label.dist=0, vertex.size=size2,
       vertex.label.cex=font,vertex.label.degree=-pi/2)
dev.off()



