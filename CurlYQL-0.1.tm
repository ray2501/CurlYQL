# CurlYQL -
#
#     Using TclCurl to send YQL query
#

package require Tcl 8.6
package require TclOO
package require TclCurl

package provide CurlYQL 0.1

oo::class create CurlYQL {
    variable html_result
    
    constructor {} {
        set html_result ""
    }
    
    destructor {
    }    
    
    method query {query args} {
        variable url
        variable pairs

        set url "https://query.yahooapis.com/v1/public/yql"
        set pairs {}

        lappend pairs "[curl::escape format]=[curl::escape json]"
        lappend pairs "[curl::escape q]=[curl::escape $query]"
        
        foreach {name value} $args {
            lappend pairs "[curl::escape $name]=[curl::escape $value]"
        }
    
        append url ? [join $pairs &]

        set curlHandle [curl::init]
        $curlHandle configure -url $url -bodyvar [namespace current]::html_result
        catch { $curlHandle perform } curlErrorNumber
        if { $curlErrorNumber != 0 } {
            error [curl::easystrerror $curlErrorNumber]
        }

        $curlHandle cleanup
    }
    
    #
    # get the results
    #
    method getResults {} {
        return $html_result
    }
}

