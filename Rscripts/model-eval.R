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
plot_error <- function(data, error) {
  ggplot(data[as.character(data$Detail) != "base",], 
         aes_string("Triangles", error, color="Reducer", shape="Model")) +
    geom_point(size=3) +
    geom_line() +
    scale_x_log10() +
    scale_y_log10() +
    annotation_logticks()
}

plot_error_labeled <- function(data, error, xlabel, ylabel) {
  ggplot(data[as.character(data$Detail) != "base",], 
         aes_string("Triangles", error, color="Model", shape="Reducer")) +
    geom_point(size=3) +
    geom_line() +
    scale_x_log10() +
    scale_y_log10() +
    annotation_logticks() +
    xlab(xlabel) +
    ylab(ylabel)
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

#######################
mk2_luminance_tex <- importData("mk2-luminance-novol-nobound.csv")
mk2_luminance_tex_bound <- importData("mk2-luminance-novol-bound.csv")
mk2_luminance_tex_vol <- importData("Backup/mk2-luminance-vol-nobound.csv")
mk2_luminance_tex_vol_bound <- importData("Backup/mk2-luminance-vol-bound.csv")

mk2_luminance_tex$Reducer <- rep("texture", nrow(mk2_luminance_novol_tex))
mk2_luminance_tex_bound$Reducer <- rep("texture, seam", nrow(mk2_luminance_novol_tex))
mk2_luminance_tex_vol$Reducer <- rep("texture, volume", nrow(mk2_luminance_novol_tex))
mk2_luminance_tex_vol_bound$Reducer <- rep("texture, volume, seam", nrow(mk2_luminance_novol_tex))
#######################

mk2_luminance_tex$Reducer <- rep("mk2 - texture", nrow(mk2_luminance_tex))
mk2_luminance_novol_tex_bound$Reducer <- rep("mk2 - texture, seam", nrow(mk2_luminance_tex_bound))
mk2_luminance_vol_tex$Reducer <- rep("mk2 - texture, vol", nrow(mk2_luminance_votex))
mk2_luminance_vol_tex_bound$Reducer <- rep("mk2 - texture, vol, seam", nrow(mk2_luminance_vol_tex_bound))
mk2_luminance_tex <- importData("Backup/mk2-luminance-novol-nobound.csv")
mk2_luminance_tex$Reducer <- rep("mk2 - texture", nrow(mk2_luminance_volA_tex_bound))

mk2_hausdorff_giraffe <- importData("mk2-hausdorff-giraffe.csv")

mk2_hausdorff_200 <- importData("mk2-hausdorff-200.csv")
mk2_hausdorff_600 <- importData("mk2-hausdorff-600.csv")
mk2_hausdorff_610 <- importData("mk2-hausdorff-610.csv")
mk2_hausdorff_700 <- importData("mk2-hausdorff-700.csv")
mk2_hausdorff_710 <- importData("mk2-hausdorff-710.csv")
mk2_hausdorff_800 <- importData("mk2-hausdorff-800.csv")
mk2_hausdorff_810 <- importData("mk2-hausdorff-810.csv")
mk2_hausdorff_900 <- importData("mk2-hausdorff-900.csv")
mk2_hausdorff_910 <- importData("mk2-hausdorff-910.csv")
mk2_hausdorff_1000 <- importData("mk2-hausdorff-1000.csv")



volume <- data.frame(Detail=factor(c(" base", " super", " high", " medium", " low"), 
                                   c(" base", " super", " high", " medium", " low")))

factor(levels=c(" base", " super", " high", " medium", " low"))
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

plot_error(mk2_hausdorff_800, "GeoError")
plot_error(mk2_hausdorff_800, "TexError")
plot_error(mk2_hausdorff_800, "ColError")
plot_error(mk2_hausdorff_800, "sqrt(ColError)")
plot_error(mk2_hausdorff_800, "GeoError * ColError")
plot_error(mk2_hausdorff_800, "GeoError + ColError")


mk2_hausdorff_800 <- importData("mk2-hausdorff-800.csv")
mk2_hausdorff_1000 <- importData("mk2-hausdorff-1000.csv")

comb <- create_header(colnames(mk2_hausdorff_800))
comb <- insert(comb, mk2_hausdorff_800, 1, 4)

comb <- create_header(colnames(mk2_hausdorff_1000))
comb <- insert(comb, mk2_hausdorff_1000, 1, 4)

plot_error(comb, "GeoError")
plot_error(comb, "TexError")
plot_error(comb, "ColError")
plot_error(comb, "sqrt(ColError)")
plot_error(comb, "GeoError * ColError")
plot_error(comb, "GeoError + ColError")

plot_error_labeled(comb, "sqrt(GeoError)", "Triangles", "Rms geometric error")
plot_error_labeled(comb, "sqrt(ColError)", "Triangles", "Rms color error")
plot_error_labeled(comb, "sqrt(LumError)", "Triangles", "Rms luminance error")
plot_error_labeled(comb, "sqrt(GeoError)*sqrt(ColError)", "Triangles", "Rms geometric * rms color error")
plot_error_labeled(comb, "sqrt(GeoError)+sqrt(ColError)", "Triangles", "Rms geometric + rms color error")
plot_error_labeled(comb, "GeoMaxError", "Triangles", "Max geometric error")
plot_error_labeled(comb, "ColMaxError", "Triangles", "Max color error")

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

comb <- create_header(colnames(data1))
comb <- insert(comb, mk2_luminance_tex, 1, 9)
comb <- insert(comb, mk2_luminance_tex_bound, 1, 9)
comb <- insert(comb, mk2_luminance_tex_vol, 1, 9)
comb <- insert(comb, mk2_luminance_tex_vol_bound, 1, 9)

comb <- create_header(colnames(mk2_hausdorff_200))
comb <- insert(comb, mk2_hausdorff_200, 1, 4)
comb <- insert(comb, mk2_hausdorff_600, 1, 4)
comb <- insert(comb, mk2_hausdorff_610, 1, 4)
comb <- insert(comb, mk2_hausdorff_700, 1, 4)
comb <- insert(comb, mk2_hausdorff_710, 1, 4)
comb <- insert(comb, mk2_hausdorff_800, 1, 4)
comb <- insert(comb, mk2_hausdorff_810, 1, 4)
comb <- insert(comb, mk2_hausdorff_900, 1, 4)
comb <- insert(comb, mk2_hausdorff_910, 1, 4)

pd <- position_dodge(0.1)

mk2_hausdorff_800 <- importData("mk2-hausdorff-800.csv")

df <- mk2_hausdorff_800[as.character(mk2_hausdorff_800$Detail) != " base",]
df <- mk2_hausdorff_800
df <- comb[as.character(comb$Detail) != "base",]

Summary <- df %>%
  group_by(Reducer, Detail) %>%
  summarise(Mean = mean(GeoError), SD = sd(GeoError))

ggplot(Summary, aes(x=Detail, y=Mean, colour=Reducer, group=Reducer, shape=Reducer)) + 
  geom_errorbar(aes(ymin=Mean-SD, ymax=Mean+SD), width=.3, position=pd) +
  geom_line(position=pd) +
  scale_shape_manual(values=c(19, 18, 17, 15)) +
  geom_point(position=pd, size=3) +
  ylab("Rms luminance error") +
  scale_y_log10() +
  annotation_logticks()

ggplot(comb, aes(x=Detail, y=ColError, colour=Reducer, group=Reducer, shape=Model)) + 
  scale_shape_manual(values=c(15, 16, 17, 0, 1, 2, 6, 7, 8)) +
  geom_point(size=4) 

rms <- aggregate(Error*Error ~ Detail+Reducer, df, sum) %>%
  setNames(c("Detail", "Reducer", "Error")) %>%
  aggregate(Error ~ Detail+Reducer, ., sqrt)

ggplot(rms, aes(x=Detail, y=Error/9, colour=Reducer, group=Reducer, shape=Reducer)) + 
  scale_shape_manual(values=c(19, 18, 17, 15)) +
  geom_point(size=4) +
  geom_line()

