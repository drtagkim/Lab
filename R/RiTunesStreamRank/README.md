# Introduction

Maintainer: Taekyung Kim, PhD., Associate Professor, Kwangwoon University
Collaborator: Dongwon Lee, PhD., Professor, Korea University

# Install

## R

Install R: R>=4.0.3

## How to Install RiTunesStreamRank

Make sure that you have installed the latest R(>=4.0.3) and the following packages: tidyverse, jsonlite,purrr,RSQLite, and DBI. If you do not have those, execute the following codes to install dependenceis:

    install.packages("tidyverse")
    install.packages("rvest")
    install.packages("remotes")
    
To install RiTunesStreamRank, run the following:

    remotes::install_github("drtagkim/Lab/R/RiTunesStreamRank")
    
# Code Example

    library(RiTunesStreamRank)
    run_to_sqlite('testitunes.db')
    
If you need more information, run the following in R Console:

    ?run_to_sqlite
    
## SQLite3

RiTunesStreamRank exports data into an SQLite3 file. If you need more information about SQLite3, visit the following sites.

* [SQLite3 home](https://www.sqlite.org/index.html)
* [W3School SQL tutorial](https://www.w3schools.com/sql/default.asp)
* [Tutorial Point - SQLite3](http://www.tutorialspoint.com/sqlite/)

## HeidiSQL

HeidiSQL Version 11 supports SQLite3. This wonderful sQL workbench helps you mimimize efforts and save time. Vist the following site to download the software and find useful resources.

https://www.heidisql.com/