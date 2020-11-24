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
## subsetting review

set.seed(13435)
X<- data.frame("var1"=sample(1:5),"var2"=sample(6:10),"var3"=sample(11:15))
X<-x[sample(1:5),];X$var[c(1,3)] = NA
X

X[(X$var1 <= 3 & X$var3 >11),]

X[order(X$var1,X$var3),]

## using plyr library
library(plyr)
arrange(X,var1)
arrange(x,desc(var1))
##adding rows
X$var4<- rnorm(5)
X
## other way to do it
Y<-cbind(X,rnorm(5))
Y

## getting data from the web.
if(file.exists("/.data")){dir.create("./data")}
fileUrl<- "https://data.baltimorecity.gov/api/views/k5ry-ef3g/rows.csv"
download.file(fileUrl, destfile = "./data/restaurants.csv", method = "curl")
restData<- read.csv("./data/restaurants.csv")

## look a bit
head(restData,n=3)
tail(restData, n=3)
summary(restData)
str(restData)
quantile(restData$councilDistrict,na.rm=TRUE)
quantile(restData$councilDistrict,probs=c(0.5,0.75,0.9))
table(restData$zipCode, useNA = "ifany") ##here is important useNA = "ifany" to make sure you are not missing NA values.
table(restData$councilDistrict, restData$zipCode)
## check for missing values
sum(is.na(restData$councilDistrict))
any(is.na(restData$councilDistrict))
all(restData$zipCode>0)
## [1] FALSE  return false beccause one of the zipcodes is negative

## row and columns sums
colSums(is.na(restData))
all(colSums(is.na(restData))==0)

## values with specific characteristics
table(restData$zipCode %in% c("21212")) ## you can also use == insted %in%
table(restData$zipCode %in% c("21212","21213")) ## the colon is used like "or"
restData[restData$zipCode %in% c("21212","21213"),]

## Cross tabs
data("UCBAdmissions")
DF=as.data.frame(UCBAdmissions)
summary(DF)

xt<- xtabs(Freq ~ Gender + Admit, data=DF)
xt

## Flat tables
warpbreaks$replicate <-rep(1:9, len =54)
xt=xtabs(breaks ~.,data=warpbreaks)
xt
## summary of the flat table 
ftable(xt)

## Size of the data set 
fakeData = rnorm(1e5)
object.size(fakeData) ## give you the size in bytes

print(object.size(fakeData),units = "Mb")

### Creating new variables
## creating sequences
s1 <- seq(1,10,by=2); s1
s2<- seq(1,10,length=3); s2
x<-c(1,3,8,25,100); seq(along =x) ## this is to create a index for the vector x

## subsetting variables
restData$nearMe = restData$neighborhood %in% c("Roland Park","Homeland")
table(restData$nearMe)

## creating binary variables
restData$zipWrong = ifelse(restData$zipCode<0, TRUE, FALSE)
table(restData$zipWrong, restData$zipCode<0)

## Easier cutting
library(Hmisc)

## reshaping data
library(reshape2)
head(mtcars)

mtcars$carname<-rownames(mtcars)
## creating id variables and measure values
carMelt<- melt(mtcars,id=c("carname","gear","cyl"), measure.vars = c("mpg","hp"))
head(carMelt, n=3)

## casting data frames change something in the dataframe
cylData<-dcast(carMelt,cyl~variable)
cylData

##cyl mpg hp
##1   4  11 11
##2   6   7  7
##3   8  14 14

cylData<- dcast(carMelt, cyl~variable,mean)
cylData

##cyl      mpg        hp
##1   4 26.66364  82.63636
##2   6 19.74286 122.28571
##3   8 15.10000 209.21429

## Merging Data
if(!file.exists("./data")){dir.create("./data")}
fileUrl1="https://dl.dropboxusercontent/u/7710864/data/reviews-apr29.csv"
fileUrl2="https://dl.dropboxusercontent/u/7710864/data/solutions-apr29.csv"
download.file(fileUrl1="./data/reviews.csv", method="curl")
download.file(fileUrl2="./data/solutions.csv", method = "curl")
reviews =read.csv("./data/reviews.csv"); solutions<- read.csv("./data/solutions.csv")
head(reviews,2)

## Merging
mergeData = merge(reviews,solutions,by.x="solution_id",by.y="id", all=TRUE)
head(mergeData)

## is possible to merge all columns with common names
