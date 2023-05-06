---
title: "rcode-analysis"
output: html_document
date: "2023-05-06"
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## R Markdown

This is an R Markdown document. Markdown is a simple formatting syntax for authoring HTML, PDF, and MS Word documents. For more details on using R Markdown see <http://rmarkdown.rstudio.com>.

When you click the **Knit** button a document will be generated that includes both content as well as the output of any embedded R code chunks within the document. You can embed an R code chunk like this:

```{r}

df = read.csv("combined.csv")


head(df)
```

## Including Plots

You can also embed plots, for example:

```{r}
#install.packages("dplyr")
library(dplyr)

df <- df %>% 
  select(-OffenseCode, -LocationStreetNumber, -LocationDirectional, -CaseStatus, -OCANumber)

```

```{r}
# loop to check and modify IncidentFromDate
for (i in 1:(length(df$IncidentFromDate)-1)) {
  # check if length is less than 7
  if (nchar(df$IncidentFromDate[i]) < 7) {
    df <- df[-i, ] # remove the row
  }
  # check for mm/dd format
  if (substr(df$IncidentFromDate[i], 2, 2) == "/") {
    df$IncidentFromDate[i] <- paste0("0", df$IncidentFromDate[i])
  }
  # check for yyyy/mm/dd format
  if (substr(df$IncidentFromDate[i], 5, 5) == "/") {
    df$IncidentFromDate[i] <- paste0(substr(df$IncidentFromDate[i], 1, 3), "0", substr(df$IncidentFromDate[i], 4, nchar(df$IncidentFromDate[i])))
  }
}

# loop to remove rows containing "missing" in IncidentFromDate
for (i in 1:(length(df$IncidentFromDate)-1)) {
  # check if IncidentFromDate contains "missing"
  if (grepl("missing", df$IncidentFromDate[i])) {
    df <- df[-i, ] # remove the row
  }
}

```

```{r}
df$IncidentFromDate <- as.POSIXct(df$IncidentFromDate, format="%m/%d/%Y")

df
```

```{r}
# For some reason why i do it at the same time it drops the entire df
df1 <- df[df$Offense.Description != "Non-Crime (not reported to state)", ]
# Filter out rows where the "Offense Description" column equals "Non-Crime (not reported to state)"
df1 <- df[df$Offense.Description != "Non-Crime (not reported to state)", ]

# Filter out rows where the "Offense Description" column equals "no offense description"
df1 <- df1[df1$Offense.Description != "no offense description", ]

# Filter out rows where the "Offense Description" column equals "non-crime"
df1 <- df1[df1$Offense.Description != "non-crime", ]

# Filter out rows where the "Offense Description" column equals "All Other Offenses"
df1 <- df1[df1$Offense.Description != "All Other Offenses", ]

# Filter out rows where the "Offense Description" column equals "Miscellaneous Offenses"
df1 <- df1[df1$Offense.Description != "Miscellaneous Offenses", ]

# Filter out rows where the "Offense Description" column equals "NULL"
df1 <- df1[complete.cases(df1$Offense.Description),]

df1 <- df1[df1$Offense.Description != "NULL", ]

df1 <- df1[df1$Offense.Description != "", ]

write.csv(df1, "df1.csv", row.names = FALSE)

```

```{r}
# install.packages('tidyverse')
library(tidyverse)

ggplot(df1, aes(x = Offense.Description)) +
  geom_bar(fill = "black") +
  theme_bw() +
  labs(x = "Offense Description", y = "Count")
```
