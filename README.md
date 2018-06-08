# CurlYQL

This package is using TclCurl to send YQL query.

[Yahoo! Query Language](https://developer.yahoo.com/yql/)  (YQL) is 
an SQL-like query language created by Yahoo! as part of their Developer Network.

This extension needs Tcl 8.6, TclOO and [TclCurl](https://bitbucket.org/smh377/tclcurl) package.
If TclCurl does not exist, this extension will try to use
[http](http://www.tcl.tk/man/tcl/TclCmd/http.htm) and tls package.


## Interface

The library has 1 TclOO class, CurlYQL.


## Example

This example is using [rl_json](https://github.com/RubyLane/rl_json) to parse JSON result.

    package require CurlYQL
    package require rl_json

    set curlyql [CurlYQL new]
    set querystring {select wind from weather.forecast where }
    append querystring {woeid in (select woeid from geo.places(1)}
    append querystring { where text="chicago, il")}
    $curlyql query $querystring
    set query_result [$curlyql getResults]
    
    if {[::rl_json::json exists $query_result query]==1} {
        set created [::rl_json::json get $query_result query created]
        puts "created: $created"
        set lang [::rl_json::json get $query_result query lang]
        puts "lang: $lang"
        set rows [::rl_json::json get $query_result query results channel wind]
    
        puts "========================================"
        foreach {key value} $rows {        
            puts "$key: $value"
        }
        puts "========================================\n"
    }
    
    $curlyql destroy
