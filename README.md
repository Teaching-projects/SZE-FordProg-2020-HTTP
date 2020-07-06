# SZE-FordProg-2020-HTTP

  Valid JSON HTTP Request példa:

    HTTP/1.1 200 OK
    Date: Wed, 01 Jul 2020 06:34:30 GMT
    Content-Type: application/json
    Content-Length: 19
    Connection: keep-alive
    Set-Cookie: __cfduid=dbbd99dc2787dfe10333547dc6464202d1593585270; expires=Fri, 31-Jul-20 06:34:30 GMT; path=/; domain=.reqbin.com; HttpOnly; SameSite=Lax; Secure
    CF-Cache-Status: DYNAMIC
    cf-request-id: 03aaae9824000091da64267200000001
    Expect-CT: max-age=604800, report-uri="https://report-uri.cloudflare.com/cdn-cgi/beacon/expect-ct"
    Server: cloudflare
    CF-RAY: 5abe1a06ae1491da-EWR
    
    {"success":"true"}
    
  Valid XML HTTP Request példa:

    HTTP/1.1 200 OK
    Date: Wed, 01 Jul 2020 07:55:15 GMT
    Content-Type: application/xml; charset=utf-8
    Content-Length: 132
    Transfer-Encoding: chunked
    Connection: keep-alive
    Set-Cookie: __cfduid=d0a7026a5a10ccaca01af9254d5186c111593590115; expires=Fri, 31-Jul-20 07:55:15 GMT; path=/; domain=.reqbin.com; HttpOnly; SameSite=Lax; Secure
    CF-Cache-Status: DYNAMIC
    cf-request-id: 03aaf885360000f035a0be8200000001
    Expect-CT: max-age=604800, report-uri="https://report-uri.cloudflare.com/cdn-cgi/beacon/expect-ct"
    Server: cloudflare
    CF-RAY: 5abe904eb9f0f035-EWR
    Content-Encoding: gzip
    
    <?xml version="1.0" encoding="utf-8"?><Response><ResponseCode>0</ResponseCode><ResponseMessage>Success</ResponseMessage></Response>

  A HTTP az alábbi műveletek elvégzésére alkalmas:

    -Content-Length ellenőrzés
    -Content-Type ellenőrzés
    -Request ellenőrzés

# Futtatás:
  •	mvn clean install exec:java
  
  •	az eredmény a futtatásnál látszik:
	
	  JSON request content
	  Invalid type request: application/xml
	  Content-Length: 19
	  Content-Length matching
	  This is an invalid HTTP request file
	  
	  JSON request content
	  Valid JSON request
	  Content-Length: 16
	  Content-Length not matching
	  This is an invalid HTTP request file
	  
	  JSON request content
	  Valid JSON request
	  Content-Length: 19
	  Content-Length matching
	  This is a valid HTTP request file
	  
	  XML request content
	  Invalid type request: application/json
	  Content-Length: 132
	  Content-Length matching
	  This is an invalid HTTP request file
	  
	  XML request content
	  Valid XML request
	  Content-Length: 130
	  Content-Length not matching
	  This is an invalid HTTP request file
	  
	  XML request content
	  Valid XML request
	  Content-Length: 132
	  Content-Length matching
	  This is a valid HTTP request file
