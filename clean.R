
library(R.oo)

# Lendo arquivos das areas

names <- dir(pattern = "area-[0-9]{2}.csv")
areas <- NULL
for(n in names){
  area <- read.table(n, sep="|", quote="", stringsAsFactors = FALSE, header=TRUE, comment.char = "")
  area$area <- area[1,2]
  area[area$ISSN == "","ISSN"] <- NA
  area$estrato <- trim(area$estrato)

  lines <- grep("\\(", area$titulo)
  titulos <- area[lines,3]
  titulos.t <- gsub("(.*)(\\(.*\\))(.*)","\\1 \\3",titulos)
  titulos.t <- trim(titulos.t)
  titulos.o <- gsub("(.*)\\((.*)\\)(.*)","\\2",titulos)
  area[lines,"titulo"] <- titulos.t
  area[lines,"obs"] <- titulos.o
  areas <- rbind(areas,area)
}


## Testando duplicatas invalidas

tmp <- split(areas, factor(areas$area))
fac <- function(dt){
  t.1 <- apply(table(dt$ISSN,dt$estrato), 1, function(l) length(l[l > 0]))
  newdt <- data.frame(issn = names(t.1), count = t.1)
}

tmp.2 <- lapply(tmp, function(x) {
  t <- fac(x)
  t[t$count > 1,]
})


## convertendo para N3
areas$issn <- gsub("-","", areas$ISSN)
lines <- grep("\"", areas$titulo)
areas[lines, "titulo"] <- gsub("\"", "", areas[lines,"titulo"])

out <- areas[,c(7,3,2,4,5)]
out <- areas[!is.na(areas$issn),]
out <- out[order(out$issn),]
write.table(out, file = "qualis.text", row.names = FALSE, sep="|", quote = FALSE)


