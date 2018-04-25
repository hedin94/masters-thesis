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

# Plot triangles vs error
plot_tri_geom_error <- function(data) {
  ggplot(data[as.character(data$Detail) != " base",], aes(Triangles, GeoError, color=Reducer, shape=Model)) +
    geom_point(size=3) +
    geom_line() +
    scale_x_log10() +
    scale_y_log10() +
    annotation_logticks()
}

# Plot triangles vs error
plot_tri_tex_error <- function(data) {
  ggplot(data[as.character(data$Detail) != " base",], aes(Triangles, TexError, color=Reducer, shape=Model)) +
    geom_point(size=3) +
    geom_line() +
    scale_x_log10() +
    scale_y_log10() +
    annotation_logticks()
}

# Plot triangles vs error
plot_tri_color_error <- function(data) {
  ggplot(data[as.character(data$Detail) != " base",], aes(Triangles, GeoError*ColError, color=Reducer, shape=Model)) +
    geom_point(size=3) +
    geom_line() +
    scale_x_log10() +
    scale_y_log10() +
    annotation_logticks()
}

# Plot triangles vs error
plot_tri_geom_tex_error <- function(data) {
  ggplot(data[as.character(data$Detail) != " base",], aes(Triangles, GeoError*TexError, color=Reducer, shape=Model)) +
    geom_point(size=3) +
    geom_line() +
    scale_x_log10() +
    scale_y_log10() +
    annotation_logticks()
}


# Plot triangles vs error
plot_error <- function(data, y) {
  ggplot(data[as.character(data$Detail) != " base",], 
         aes_string("Triangles", y, color="Reducer", shape="Model")) +
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

mk2_luminance_novol_tex <- importData("mk2-luminance-novol-nobound.csv")
mk2_luminance_novol_tex_bound <- importData("mk2-luminance-novol-bound.csv")
mk2_luminance_vol_tex <- importData("Backup/mk2-luminance-vol-nobound.csv")
mk2_luminance_vol_tex_bound <- importData("Backup/mk2-luminance-vol-bound.csv")
mk2_luminance_volA_tex <- importData("mk2-luminance-vol-nobound.csv")     #### Area weighted
mk2_luminance_volA_tex_bound <- importData("mk2-luminance-vol-bound.csv") #### Area weighted
mk2_luminance_novol_tex$Reducer <- rep("mk2 - texture, NO vol, NO bound", nrow(mk2_luminance_novol_tex))
mk2_luminance_novol_tex_bound$Reducer <- rep("mk2 - texture, NO vol, bound", nrow(mk2_luminance_novol_tex_bound))
mk2_luminance_vol_tex$Reducer <- rep("mk2 - texture, vol, NO bound", nrow(mk2_luminance_vol_tex))
mk2_luminance_vol_tex_bound$Reducer <- rep("mk2 - texture, vol, bound", nrow(mk2_luminance_vol_tex_bound))
mk2_luminance_volA_tex$Reducer <- rep("mk2 - texture, volA, NO bound", nrow(mk2_luminance_volA_tex))
mk2_luminance_volA_tex_bound$Reducer <- rep("mk2 - texture, volA, bound", nrow(mk2_luminance_volA_tex_bound))

mk2_hausdorff_volA_tex <- importData("mk2-hausdorff-volarea-nobound.csv")
mk2_hausdorff_volA_tex_bound <- importData("mk2-hausdorff-volarea-bound.csv")
mk2_hausdorff_volA_tex$Reducer <- rep("mk2 - texture, volA, NO bound", nrow(mk2_hausdorff_volA_tex))
mk2_hausdorff_volA_tex_bound$Reducer <- rep("mk2 - texture, volA, bound", nrow(mk2_hausdorff_volA_tex_bound))

mk2_hausdorff_giraffe <- importData("mk2-hausdorff-giraffe.csv")
mk2_hausdorff_800 <- importData("mk2-hausdorff-800.csv")

comb <- create_header(colnames(data1))
comb <- insert(comb, mk_distance, 1, 2)
comb <- insert(comb, mk2_distance_tex, 1, 2)
comb <- insert(comb, mk2_distance_tex_bound, 1, 2)
plot_tri_error(comb)

# Luminance
comb <- create_header(colnames(data1))
comb <- insert(comb, mk2_luminance_vol_tex, 4, 1)
comb <- insert(comb, mk2_luminance_vol_tex_bound, 4, 1)
comb <- insert(comb, mk2_luminance_volA_tex, 4, 1)
comb <- insert(comb, mk2_luminance_volA_tex_bound, 4, 1)
plot_tri_error(comb)

# RGB distance
comb <- create_header(colnames(data1))
comb <- insert(comb, mk2_distance_tex, 1, 2)
comb <- insert(comb, mk2_distance_tex_bound, 1, 2)
plot_tri_error(comb)

# Hausdorff
comb <- create_header(colnames(data1))
comb <- insert(comb, mk2_hausdorff_volA_tex, 1, 1)
comb <- insert(comb, mk2_hausdorff_volA_tex_bound, 1, 1)
plot_tri_geom_error(comb)
plot_tri_tex_error(comb)
plot_tri_color_error(comb)
plot_tri_geom_tex_error(comb)

comb <- create_header(colnames(data1))
comb <- insert(comb, mk2_hausdorff_800, 1, 5)
plot_error(mk2_hausdorff_800, "GeoError")
plot_error(mk2_hausdorff_800, "TexError")
plot_error(mk2_hausdorff_800, "ColError")
plot_error(mk2_hausdorff_800, "GeoError * ColError")
plot_error(mk2_hausdorff_800, "GeoError + ColError")

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


library(dplyr)
library(reshape2)

comb <- create_header(colnames(data1))
comb <- insert(comb, mk2_hausdorff_vol_tex, 1, 1)
comb <- insert(comb, mk2_hausdorff_vol_tex_bound, 1, 1)


df <- comb
Summary <- df %>%
  group_by(Reducer, Detail) %>%
  summarise(Mean = mean(Error), SD = sd(Error))

pd <- position_dodge(0.1)

ggplot(Summary, aes(x=Detail, y=Mean, colour=Reducer, group=Reducer)) + 
  geom_errorbar(aes(ymin=Mean-SD, ymax=Mean+SD), width=.1, position=pd) +
  geom_line(position=pd) +
  geom_point(position=pd)


