# CurlYQL -
#
#     Using TclCurl to send YQL query
#

package require Tcl 8.6
package require TclOO

namespace eval ::CurlYQL {
    set useTclCurl 1
}

if {[catch {package require TclCurl}]} {
    package require http
    package require tls
    set ::CurlYQL::useTclCurl 0
}

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
        variable ncode

        set url "https://query.yahooapis.com/v1/public/yql"

        if {$::CurlYQL::useTclCurl == 1} {
            variable pairs

            set pairs {}
            lappend pairs "[curl::escape format]=[curl::escape json]"
            lappend pairs "[curl::escape q]=[curl::escape $query]"

            foreach {name value} $args {
                lappend pairs "[curl::escape $name]=[curl::escape $value]"
            }
        
            append url ? [join $pairs &]

            try {
                set curlHandle [curl::init]
                $curlHandle configure -url $url -bodyvar [namespace current]::html_result
                $curlHandle perform
                set ncode [$curlHandle getinfo responsecode]
            } on error {em} {
                error [curl::easystrerror $em]
            } finally {
                $curlHandle cleanup
            }
        } else {
            variable tok
            variable querystring

            try {
                # for https
                http::register https 443 [list ::tls::socket -ssl3 0 -ssl2 0 -tls1 1]

                set querystring [::http::formatQuery format json q $query {*}$args]
                append url ? $querystring

                set tok [http::geturl $url -method GET -timeout 1500]
                set ncode [::http::ncode $tok]
                set [namespace current]::html_result [http::data $tok]
            } on error {em} {
                error "Error: $em"
            } finally {
                if {[info exists tok]==1} {
                    http::cleanup $tok
                }
            }
        }

        if {$ncode != 200} {
            return -code error "ncode error"
        }

        return -code ok
    }
    
    #
    # get the results
    #
    method getResults {} {
        return $html_result
    }
}
