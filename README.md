# CurlYQL

This package is using TclCurl to send YQL query.

[Yahoo! Query Language](https://developer.yahoo.com/yql/)  (YQL) is an SQL-like query language created by Yahoo!
as part of their Developer Network.

This extension needs Tcl 8.6, TclOO and [TclCurl](https://bitbucket.org/smh377/tclcurl) package.


## Interface

The library has 1 TclOO class, CurlYQL.


## Example

This example is using [rl_json](https://github.com/RubyLane/rl_json) to parse JSON result.

    package require CurlYQL
    package require rl_json

    set curlyql [CurlYQL new]
    set querystring {select * from csv where url=}
    append querystring {'http://download.finance.yahoo.com/d/quotes.csv?}
    append querystring {s=SPY,VOO,IVV&f=sl1d1t1c1ohgv&e=.csv' and }
    append querystring {columns='symbol,price,date,time,change,col1,high,low,col2'}
    $curlyql query $querystring
    set query_result [$curlyql getResults]

    if {[::rl_json::json exists $query_result query]==1} {
        set rows [::rl_json::json get $query_result query results row]

        puts "========================================\n"
        foreach row $rows {        
            puts "symbol: [dict get $row symbol]"
            puts "price: [dict get $row price]"
            puts "date: [dict get $row date]"
            puts "time: [dict get $row time]"
            puts "change: [dict get $row change]"
            puts "col1: [dict get $row col1]"
            puts "high: [dict get $row high]"
            puts "low: [dict get $row low]"
            puts "col2: [dict get $row col2]"
            puts "========================================\n"
        }
    }

    $curlyql destroy
