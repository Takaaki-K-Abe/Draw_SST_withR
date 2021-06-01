# NOAAからのSSTデータのダウンロード
# 参考url https://hansenjohnson.org/post/sst-in-r/

drawSST <- function(sst_raster, LonRange, LatRange){
  jet.colors <- colorRampPalette(c("#00007F", "blue", "#007FFF", "cyan", "#7FFF7F", "yellow", "#FF7F00", "red", "#7F0000"))

  # rasterをspdfにする
  spdf.sst <- as(sst_raster, "SpatialPixelsDataFrame")

  # sstをデータフレーム型にする
  df.sst <- as.data.frame(spdf.sst) %>% 
  rename(sst = Daily.sea.surface.temperature) %>%
  filter(x > min(Lonrange) - 1 & x < max(Lonrange) + 1) %>% 
  filter(y > min(Latrange) - 1 & y < max(Latrange) + 1)
  
  # 日本の地図
  mapdat <- map_data("japan") %>% 
    filter(long > min(Lonrange) - 1 & long < max(Lonrange) + 1) %>% 
    filter(lat > min(Latrange) - 1 & lat < max(Latrange) + 1)

  #sst <- ggplot(df.sst, aes(x=x-0.125, y=y+0.125)) +
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
  # タグの位置情報
  geom_point(
    data = locs, 
    aes(x=lon, y=lat, shape=loc), size=3
  ) +
  scale_shape_manual(values=c(17, 16)) +
  # カラーマップの設定
  scale_fill_gradientn(limits=c(10,30), colours=jet.colors(9)) +
  labs(x="Longitude", y="Latitude", fill="Temperature(C)") +
  coord_fixed( xlim=Lonrange, ylim=Latrange ) +
  theme_bw() + scale_x_continuous(expand=c(0,0))
  
  return(sst)
}