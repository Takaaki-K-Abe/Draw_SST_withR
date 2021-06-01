# libraries
library(raster)
library(ncdf4)
library(maps)
library(mapdata)
library(raster)
library(tidyverse)
library(knitr)

# 関数のロード
source("functions/sst_dl.R")
source("functions/return_nc_fname.R")
source("functions/extractSST.R")
source("functions/drawSST.R")

# 日付
stdate = as.Date("2019-10-01")
enddate = as.Date("2019-10-31")
dats <- seq(stdate, enddate, by = "day")
sapply(dats, sst_dl)

## 水温の図の作成

# list型で読み込むnetcdf file名を出力
datefiles <- lapply(dats, return_nc_fname)

# 描写範囲
Latrange = c(25, 45)
Lonrange = c(125, 150)

drawsimpleSST <- function(sst_raster, LonRange, Latranges, Title){
  
  jet.colors <- colorRampPalette(c("#00007F", "blue", "#007FFF", "cyan", "#7FFF7F", "yellow", "#FF7F00", "red", "#7F0000"))

  spdf.sst <- as(sst_raster, "SpatialPixelsDataFrame")

  df.sst <- as.data.frame(spdf.sst) %>% 
    rename(sst = Daily.sea.surface.temperature) %>%
    filter(x > min(Lonrange) - 1 & x < max(Lonrange) + 1) %>% 
    filter(y > min(Latrange) - 1 & y < max(Latrange) + 1)
    
  mapdat <- map_data("world") 
    # filter(long > min(Lonrange) - 1 & long < max(Lonrange) + 1) %>% 
    # filter(lat > min(Latrange) - 1 & lat < max(Latrange) + 1)

  sst <- ggplot(df.sst, aes(x=x, y=y)) +
  # カラーマップ
  geom_raster(aes(fill=sst)) +
  # 等高線
  geom_contour(aes(z=sst), colour="black", binwidth= 5) +
  # 陸地
  geom_polygon(
    data=mapdat, aes(x=long, y=lat,group=group),
    fill = "grey", color = "grey"
  ) +
  # カラーマップの設定
  scale_fill_gradientn(limits=c(0,35), colours=jet.colors(9)) +
  labs(
    title=Title,
    x="Longitude", y="Latitude",
    fill="Temperature(°C)") +
  coord_fixed( xlim=Lonrange, ylim=Latrange ) +
  theme_bw() + scale_x_continuous(expand=c(0,0))

  return(sst)
}

## リストでデータを描写する

sst_rasters <- lapply(datefiles, raster, sep="", varname="sst")
titles <- lapply(dats, format, "%y%m%d")

# 描写したfigureをlistに格納する
sst_figs <- list()
for(i in 1:length(datefiles)){
  sst_figs[[i]] <- drawsimpleSST(sst_rasters[[i]], Lonrange, Latrange, titles[[i]])
}

# save figures

# directory setting
dir = "SSTpng"
# directory check
if(!file.exists(dir)){
  dir.create(dir)
}

for(i in 1:length(sst_figs)){
  fpath = paste0( dir, "/sst_", format(dats[i], "%y%m%d"), ".png")
  ggsave(
    file=fpath, plot=sst_figs[[i]],
    width=5, height=5
    )
}



