extract.sst <- function(coordxy, rasterfile){
  sst_raster <- raster(rasterfile, sep="", varname = "sst")
  ras.ext <- raster::extract(sst_raster, coordxy)
  return(ras.ext)
}

extract.sst.cor <- function(coordxy, rasterfile){
  sst_raster <- raster(rasterfile, sep="", varname = "sst")
  ras.ext <- raster::extract(sst_raster, coordxy)
  return(ras.ext)
}

extract.sst.rasterfile <- function(rasterfile, coordxy){
  sst_raster <- raster(rasterfile, sep="", varname = "sst")
  ras.ext <- raster::extract(sst_raster, coordxy)
  return(ras.ext)
}
