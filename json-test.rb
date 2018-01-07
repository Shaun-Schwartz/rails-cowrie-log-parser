require 'json'

info = JSON.parse('{
    "query_status" : {
        "query_status_code" : "OK",
        "query_status_description" : "Query successfully performed."
    },
    "ip_address" : "124.204.42.34",
    "geolocation_data" : {
        "continent_code" : "AS",
        "continent_name" : "Asia",
        "country_code_iso3166alpha2" : "CN",
        "country_code_iso3166alpha3" : "CHN",
        "country_code_iso3166numeric" : "156",
        "country_code_fips10-4" : "CH",
        "country_name" : "China",
        "region_code" : "CH22",
        "region_name" : "Beijing"
    }
}')
p info['geolocation_data']['country_name']
p info['geolocation_data']['region_name']
