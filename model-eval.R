require(ggplot2)

# Import LoD evaluation data
importData <- function(filename){
  path <- paste("c:/CetDev/version9.0/write/t/", filename, sep="")
  d <- read.csv(file=path);
  d$Detail <- factor(d$Detail, as.character(d$Detail[1:5]))
  return(d)
}

# Plot triangles vs error
plot_tri_error <- function(data) {
  ggplot(data[as.character(data$Detail) != " base",], aes(Triangles, Error, color=Reducer, shape=Model)) +
    geom_point(size=3) +
    geom_line() +
    scale_x_log10() +
    scale_y_log10() +
    annotation_logticks()
}

# Insert B into A
insert <- function(A, B, s, n) {
  i <- 5*(s-1) + 1
  j <- i + 5*n - 1
  return(rbind(A, B[i:j,]))
}

create_header <- function(names) {
  return(setNames(data.frame(matrix(ncol=length(names), nrow=0)),names))
}

data1 <- importData("data1.csv")
data <- importData("data.csv")
data_tex <- importData("data-tex.csv")
data_notex <- importData("data-notex.csv")
data_tex_bound <- importData("data-tex-bound.csv")

mk_distance <- importData("mk-distance.csv")
mk2_distance_tex <- importData("mk2-distance-nobound.csv")
mk2_distance_tex_bound <- importData("mk2-distance-bound.csv")

mk2_distance_tex$Reducer <- rep("mk2 - texture, NO bound", nrow(mk2_distance_tex))
mk2_distance_tex_bound$Reducer <- rep("mk2 - texture, bound", nrow(mk2_distance_tex_bound))

comb <- create_header(colnames(data1))
comb <- insert(comb, mk_distance, 1, 2)
comb <- insert(comb, mk2_distance_tex, 1, 2)
comb <- insert(comb, mk2_distance_tex_bound, 1, 2)
plot_tri_error(comb)

data_tex$Reducer <- rep("mk2 - w/ texture", nrow(data_tex)) 
data_notex$Reducer <- rep("mk2 - w/o texture", nrow(data_notex)) 
data1$Reducer <- rep("mk - w/o texture", nrow(data1)) 
data_tex_bound$Reducer <- rep("mk2 - w/ texture & bound", nrow(data_tex_bound))

ggplot(data_tex[as.character(data_tex$Detail) != " base",], aes(Triangles, Error, color=Model)) +
  geom_point() +
  geom_line()

ggplot(data_notex[as.character(data_notex$Detail) != " base",], aes(Triangles, Error, color=Model)) +
  geom_point() +
  geom_line()

s <- 1
n <- 1
i <- 5*(s-1) + 1
j <- i + 5*n - 1

#data_comb <- rbind(data_tex[i:j,], data_notex[i:j,], data1[i:j,], data_tex_bound[i:j,])
data_comb <- setNames(data.frame(matrix(ncol=5, nrow=0)),colnames(data1))
data_comb <- rbind(data_comb, data_tex[i:j,])
#data_comb <- rbind(data_comb, data_notex[i:j,])
#data_comb <- rbind(data_comb, data1[i:j,])
data_comb <- rbind(data_comb, data_tex_bound[i:j,])
data_comb$Detail <- factor(data_comb$Detail, as.character(data$Detail[1:5]))
ggplot(data_comb[as.character(data_comb$Detail) != " base",], aes(Triangles, Error, color=Reducer, shape=Model)) +
  geom_point() +
  geom_line() +
  scale_x_log10() +
  scale_y_log10() +
  annotation_logticks()

ggplot(data[as.character(data$Detail) != " base",], aes(Triangles, Error, color=Model)) +
#ggplot(data, aes(Triangles, Error, color=Model)) +
  geom_point() +
  geom_line() +
  scale_x_log10() +
  scale_y_log10() +
  annotation_logticks()

ggplot(data1[as.character(data$Detail) != " base",], aes(Triangles, Error, color=Model)) +
  geom_point() +
  geom_line() +
  #coord_trans(x = "log10", y = "log10")
  scale_x_log10() +
  scale_y_log10() +
  annotation_logticks()

ggplot(data, aes(Triangles, Error, color=Model)) +
  geom_point() +
  geom_line() +
  scale_x_log10() +
  scale_y_log10() +
  annotation_logticks()

# Detail vs Percentage remaining triangles
ggplot(data, aes(x=Detail, y=Triangles/Triangles[as.character(data$Detail)==" base"], group=Model, color=Model)) +
  geom_line() +
  geom_point() +
  xlab("Detail") +
  ylab("Reduction level")
  
# Detail vs Triangles in reduced

ggplot(data, aes(x=Detail, y=Triangles, group=Model, color=Model)) +
  geom_line() +
  geom_point() +
  xlab("Detail") +
  ylab("Triangles")

ggplot(data, aes(Detail, Error, group=Model, color=Model)) +
  geom_line() +
  geom_point()

ggplot(data, aes(Triangles/Triangles[as.character(data$Detail)==" base"], Error, group=Model, color=Model)) +
  geom_line() +
  geom_point()

density <- data.frame(Detail=levels(data$Detail), Density=c(5000, 1000, 200, 50))

reduced_super <- data$Triangles[as.character(data$Detail) == " super"]
area_super <- reduced_super / 5000
reduced_high <- data$Triangles[as.character(data$Detail) == " high"]
area_high <- reduced_high / 1000
reduced_medium <- data$Triangles[as.character(data$Detail) == " medium"]
area_medium <- reduced_medium / 200
reduced_low <- data$Triangles[as.character(data$Detail) == " low"]
area_low <- reduced_low / 50
