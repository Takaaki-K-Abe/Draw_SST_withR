# NOAAからのSSTデータのダウンロード
# 参考url https://hansenjohnson.org/post/sst-in-r/

return_nc_fname <- function(date){
  # 年月日
  ymd = format(date, '%Y%m%d')
  nc_fname <- paste0("sst_ncfiles/oisst-avhrr-v02r01.", ymd, ".nc")
  return(nc_fname)
}