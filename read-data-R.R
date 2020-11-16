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

#### reading from HDF5
##  The name HDF stands for hierarchical data format and that's because 
## the data is stored in groups which contains zero or more data sets, 
## along with their metadata. Each of these groups has a group header, 
## with the group name, and a list of attributes corresponding to that group. 
## They also have a group symbol table which has a list of the objects in 
## the group.

## Once package is installed and the file created you can create a groups
created = h5createGroup("example.h5","foo")
created = h5createGroup("example.h5", "baa")
created = h5createGroup("example.h5","foo/fobaa")
h5ls("example.h5")
## group  name     otype dclass dim
## 0     /   baa H5I_GROUP           
## 1     /   foo H5I_GROUP           
## 2  /foo fobaa H5I_GROUP  

## Write Groups

#######   Webscraping #####
## Open a connection
con = url("http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en")
htmlCode = readLines(con)
close(con)
htmlCode
"https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
sqldf("select * from acs where AGEP < 50 and pwgtp1")
## Answers to quiz 2 https://rpubs.com/ninjazzle/DS-JHU-3-2-Q2
# Getting and Cleaning data on Coursera Data Science Courses
# Quiz2 study note
# Question 1

library(httr)
require(httpuv)
require(jsonlite)

oauth_endpoints("github")

myapp <- oauth_app("github", "38e093d472d919cf750a","e54e15d23251c09c2056389eec8ac93cb20ddfaf")
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp) # need authorize the permission on popup menu
req <- GET("https://api.github.com/users/jtleek/repos", config(token = github_token))
stop_for_status(req)
output <- content(req)
list(output[[5]]$name, output[[5]]$created_at)
===================================
  # Question 2
  install.packages("RMySQL")
install.packages("sqldf")

# Since the following error msgs listed as follow are shown, 
# Error in mysqlNewConnection(drv, ...) : RS-DBI driver: (Failed to connect to database: Error: Can't connect to local MySQL server through socket '/tmp/mysql.sock' (2) )
# Error msg: tcltk package being missing

# Two additional settings are attched 
options(sqldf.driver = "SQLite") # as per FAQ #7 force SQLite
options(gsubfn.engine = "R") # as per FAQ #5 use R code rather than tcltk
# reference link 1: http://stackoverflow.com/questions/8219747/sqldf-package-in-r-querying-a-data-frame
# reference link 2: https://code.google.com/p/sqldf/

library(RMySQL)
library(sqldf)

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
f <- file.path(getwd(), "ss06pid.csv")
download.file(url, destfile=f, method="curl") # need specify method="curl"for my mac OS
acs <- read.csv("ss06pid.csv")
acs <- data.table(read.csv(f)) # data.table() and data.frame both work in this case. 
sqldf("select pwgtp1 from acs where AGEP < 50") 
query1 <- sqldf("select pwgtp1 from acs where AGEP < 50")
# str(query1)
# 'data.frame':    10093 obs. of  1 variable:
#$ pwgtp1: int  87 88 94 91 539 192 153 232 205 226 ...

query2 <- sqldf("select pwgtp1 from acs")
# str(query2)
# 'data.frame':    14931 obs. of  1 variable:
# $ pwgtp1: int  87 88 94 91 539 192 153 232 205 226 ...

query3 <- sqldf("select * from acs where AGEP < 50 and pwgtp1")
query4 <- sqldf("select * from acs where AGEP < 50")
identical(query3, query4)
# [1] TRUE
# str(query3)
# 'data.frame':    10093 obs. of  239 variables:
# $ RT      : Factor w/ 1 level "P": 1 1 1 1 1 1 1 1 1 1 ...
# $ SERIALNO: int  186 186 186 186 306 395 395 506 506 506 ...
# ......

#NOTE:
#query1, query2, query3 and query4 are all right form of syntax, but only query1 would get the right answer for the question we are interested in.
#

=============================================
  # Question 3
  
  # unique(acs$AGEP)
  # [1] 43 42 16 14 29 40 15 28 30  4  1 18 37 39  3 87 70 49 45
  # [20] 50 60 59 61 64 35 12 19 31  9  0 33 32 20 88 53 58 69 68
  # [39] 48 24 27 74 56 75 17 38 55 26 23 86 81 77  7 51 13 11 82
  # [58] 47 46 80 21 54 78 67 22  2 76  6 71 34 10  5 65 62 63 57
  # [77] 52 79 83 66 25 93  8 36 41 44 84 72 73 85 89
  
  #  query1 <- sqldf("select unique AGEP from acs")
  # Error in sqliteSendQuery(con, statement, bind.data) : 
#     error in statement: near "unique": syntax error

#  query2 <- sqldf("select AGEP where unique from acs")
# Error in sqliteSendQuery(con, statement, bind.data) : 
#     error in statement: near "unique": syntax error

#  query3 <- sqldf("select distinct AGEP from acs")
#  query4 <- sqldf("select distinct pwgtp1 from acs")

==============================
  # Question 4
  
  con <- url("http://biostat.jhsph.edu/~jleek/contact.html") 
htmllines <- readLines(con)
close(con)

# check the structure of htmllines
# str(htmllines)
# chr [1:180] "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">" ...

# head(htmllines)
# [1] "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">"
# [2] ""  

# > nchar(htmllines[10])
# [1] 45
# > nchar(htmllines[20])
# [1] 31
# > nchar(htmllines[30])
# [1] 7
# > nchar(htmllines[100])
# [1] 25


=====================================================================
  # Question 5
  install.packages("XML")
library(XML)

url2 <- "http://www.cpc.ncep.noaa.gov/data/indices/wksst8110.for"

f2 <- file.path(getwd(), "WeeklySST.txt")
download.file(url2, destfile=f2, method="curl")
# read.fwf(file, widths, header = FALSE, sep = "\t",
# skip = 0, row.names, col.names, n = -1,
# buffersize = 2000, ...)
data <-read.fwf("WeeklySST.txt", widths=c(14,5,8,5,8,5,8,5,8), header = FALSE, skip=4)
sum(data[,4])

##### Week 3
