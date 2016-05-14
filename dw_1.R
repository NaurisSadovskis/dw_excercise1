library(dplyr) 
library(tidyr)


# 0. load the data
data <- tbl_df(read.csv("./refine_original.csv", sep = ";"))

# 1. clean up brand names
data$company <- gsub("^([Aa][Kk](.*)[Zz][Oo0])", replacement = "akzo", data$company)
data$company <- gsub("^([PpFf][HhIi](.*)[Pp][Ss])", replacement = "philips", data$company)
data$company <- gsub("^([Vv][Aa][Nn](.*)[Ee][Nn])", replacement = "van houten", data$company)
data$company <- gsub("^([Uu][Nn](.*)[Ee][Rr])", replacement = "unilever", data$company)

data$company <- as.factor(data$company)

# 2. separate product code & number
data <- separate(data, Product.code...number, c("product_code", "product_number"), sep = "-") 

# 3. add product categories
data$product_category <- paste(data$product_code)
data$product_category <- as.factor(data$product_category)
levels(data$product_category) <- c(p = "Smartphone", v = "TV", x = "Laptop", q = "Tablet")

# 4. add full address for geocoding
data <- unite(data, "full_address", c(address, city, country), sep = ", ")

# 4.x optional - re-arrange table
data <- subset(data, select=c(1,2,6,3,4,5))

# 5 - create dummy variables
data$company_philips <- as.numeric(data$company == "philips")
data$company_akzo <- as.numeric(data$company == "akzo")
data$company_van_houten <- as.numeric(data$company == "van_houten")
data$company_unilever <- as.numeric(data$company == "unilever")

data$product_smartphone <- as.numeric(data$product_code == "p")
data$product_tv <- as.numeric(data$product_code == "v")
data$product_laptop <- as.numeric(data$product_code == "x")
data$product_tablet <- as.numeric(data$product_code == "q")

# 6 - write to csv
write.csv(data, "refine_clean.csv")

