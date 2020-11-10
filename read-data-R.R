## Read a flat file
camaraData <- read.table("./data/cameras.csv", sep = ",", header = TRUE)

## Download a XML file

## Download a Excel File
if(!file.exists("data")){dir.create("data")}
fileUrl<- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx"
download.file(fileUrl,destfile = "./data/gov.xlsx",method = "curl")



fileXMLUrl <-"https://data.baltimorecity.gov/api/views/dz54-2aru/rows.xml"
doc <- xmlTreeParse(fileUrl, useInternal= TRUE)
rootNode<- xmlRoot(doc)
xmlName(rootNode)
## Read a xml file
## 1. 53
## 2. TIDY DATA HAS ONE VARIABLE PER COLUNM
## 3. 36534720
## 4. 127
## 
########  Week 2
## MySQL extracting information
## basic data collection.
## https://genome.ucsc.edu/goldenPath/help/mysql.html source for genome
## crewating the connection
ucscDb<- dbConnect(MySQL(), user="genome", host="genome-mysql.cse.ucsc.edu")
result<- dbGetQuery(ucscDb,"show databases;"); dbDisconnect(ucscDb)
## now we will use genome database called hg19 so do the connection again

hg19<- dbConnect(MySQL(), user="genome", db="hg19", host="genome-mysql.cse.ucsc.edu")
allTables<- dbListTables(hg19)
length(allTables)

## [1] 12470 this is the total tables in the hg19 database
## select the first 5 tables 
allTables[1:5]

## imagen you know what table you are interested in: affyU133Plus2
dbListFields(hg19,"affyU133Plus2")
## [1] "bin"         "matches"     "misMatches"  "repMatches"  "nCount"     
## [6] "qNumInsert"  "qBaseInsert" "tNumInsert"  "tBaseInsert" "strand"     
## [11] "qName"       "qSize"       "qStart"      "qEnd"        "tName"      
## [16] "tSize"       "tStart"      "tEnd"        "blockCount"  "blockSizes" 
## [21] "qStarts"     "tStarts" 

dbGetQuery(hg19, "select count(*) from affyU133Plus2")
##   count(*)
## 1    58463

## Extractin data to a data frame
affyData <- dbReadTable(hg19, "affyU133Plus2")
head(affyData)

## In case table is too large and you need some information you can create a
## subset of information like this

query<- dbSendQuery(hg19, "select * from affyU133Plus2 where misMatches between 1 and 3")
affyMis <- fetch(query); quantile(affyMis$misMatches)
##   0%  25%  50%  75% 100% 
## 1    1    2    2    3 

## you can also get only a small sample like 10 rows of the table Remeber to
## clear the query because it is with a previous data. system return True to confirm.
affyMisSmall <- fetch(query, n=10); dbClearResult(query)
## [1] TRUE

## Checking dimensions
dim(affyMisSmall)
## [1] 10 22

## remeber to close the connection
dbDisconnect(hg19)
## [1] TRUE

