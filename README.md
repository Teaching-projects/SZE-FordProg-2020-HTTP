# SZE-FordProg-2020-HTTP

## Felhasznált technológiák:
  [CUP](http://www2.cs.tum.edu/projects/cup/) (Construction of Useful Parsers): LALR parszer, a terminálisok,
  nem terminálisok halmaza, a nyelvtan és a
  különböző "action code"-ok adhatók meg, amelyeket feldolgoz.
     
     src\main\cup\parser.cup
  
  [JFlex](https://www.jflex.de/): JAVA-hoz készített, JAVA nyelven íródott DFA alapú lexikai elemző.
  Itt adhatók meg a különböző reguláris kifejezések és a hozzájuk tartozó műveletek.
    
     src\main\jflex\Scanner.jflex

## HTTP Request példák:
  Valid JSON:

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
    
  Valid XML:

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


    
## HTTP request feldolgozás:

### Terminálisok, nem terminálisok
     //http request adatok
     terminal HTTP_VERSION, METHOD, PATH, STATUS_CODE_AND_RESON;
     terminal String SIMPLE_STRING, HEADER_FIELD_VALUE;
     //json feldolgozás
     terminal COMMA, COLON;
     terminal LEFT_BRACE, RIGHT_BRACE, LEFT_SQUARE_BRACKET, RIGHT_SQUARE_BRACKET;
     terminal TRUE, FALSE, NULL, NUMBER_WITH_FRACTION, STRING;
     //xml feldolgozás
     terminal XML_VERSION, XML_OPEN, XML_CLOSE;
     
     //http request adatok
     non terminal http_request;
     non terminal start_line, http_header_element, http_body;
     non terminal String header, header_field_name;
     non terminal json_body_cotent, xml_body_content;
     //json feldolgozás
     non terminal array, object, key_value_list, key_value, value_list, value;
     //xml feldolgozás
     non terminal xml_elements, xml_value;
     
### Makrók

    //Makrók
    http_version = (HTTP\/)(1\.1|2\.0)
    method = [GET | HEAD | POST | PUT | DELETE]
    path = \/(.*)
    status_code_and_reson = [ \t]+[0-9]{3}[ \t]+([a-zA-Z]+)
    
    simple_string = [a-zA-Z-]+
    header_field_value = [ \t]+[^\r\n]+
    
    character = [^\\\"\u0000-\u001f]*|\\[\"\\bfnrt\/]|\\u[0-9A-Fa-f]{4}
    string = \"{character}*\"
    number_with_fraction = -?(0|[1-9][0-9]*)(\.[0-9]+)?
    whitespaces = [ \t\r\n\f]
    
    xml_version = (<\?xml)(.*)(\?>)
    xml_open = <([a-zA-Z]*)>
    xml_close = <\/([a-zA-Z]*)>

###Tokenek
    "," { return sf.newSymbol("Comma",Symbols.COMMA, yytext()); }
    ":" { return sf.newSymbol("Colon",Symbols.COLON, yytext()); }
    
    "{" { return sf.newSymbol("Left brace",Symbols.LEFT_BRACE, yytext()); }
    "}" { return sf.newSymbol("Right brace",Symbols.RIGHT_BRACE, yytext()); }
    
    "[" { return sf.newSymbol("Left square bracket",Symbols.LEFT_SQUARE_BRACKET, yytext()); }
    "]" { return sf.newSymbol("Right square bracket",Symbols.RIGHT_SQUARE_BRACKET, yytext()); }
    
    "true" { stringObjectMap.put("asd", true); return sf.newSymbol("True",Symbols.TRUE, yytext()); }
    "false" { return sf.newSymbol("False",Symbols.FALSE, yytext()); }
    "null" { return sf.newSymbol("Null",Symbols.NULL, yytext()); }
    
    {http_version} { return sf.newSymbol("HTTP version",Symbols.HTTP_VERSION); }
    {status_code_and_reson} { return sf.newSymbol("Status code and reason",Symbols.STATUS_CODE_AND_RESON); }
    {method} { return sf.newSymbol("Http method",Symbols.METHOD); }
    {path} { return sf.newSymbol("Http path",Symbols.PATH); }
    {simple_string} { return sf.newSymbol("Simple string",Symbols.SIMPLE_STRING, yytext()); }
    {header_field_value} { return sf.newSymbol("Header field value",Symbols.HEADER_FIELD_VALUE, yytext()); }
    
    {number_with_fraction} { return sf.newSymbol("Number with fraction",Symbols.NUMBER_WITH_FRACTION, yytext()); }
    {string} { return sf.newSymbol("String",Symbols.STRING, yytext()); }
    
    {xml_version} { return sf.newSymbol("XML version",Symbols.XML_VERSION, yytext()); }
    {xml_open} { return sf.newSymbol("XML tag open",Symbols.XML_OPEN, yytext()); }
    {xml_close} { return sf.newSymbol("XML tag close",Symbols.XML_CLOSE, yytext()); }
    
    {whitespaces} {  }
    
    . { throw new Error("Illegal character: " + yytext() + " at line " + (yyline + 1) + ", column " + (yycolumn + 1)); }

### Nyelvtan

  ![Image of Request](https://mdn.mozillademos.org/files/13827/HTTPMsgStructure2.png)

  1. A request 3 részből áll: start_line, http_header_element, http_body
     > http_request ::= start_line http_header_element http_body;
  2. A start_line a kérést és a választ is feldolgozza
     válasz esetén: HTTP verzióból, státusz és indoklás kódból áll
     kérés esetén: kérés metódus (GET, POST, DELETE, stb), útvonal és HTTP verzióból áll
     > start_line ::= HTTP_VERSION STATUS_CODE_AND_RESON | METHOD PATH HTTP_VERSION;
  3. A http fejléc lehet üres, vagy tartalmazhat fejléc elemeket                                                                                                                                                 
     > http_header_element ::= /*empty*/ | http_header_element:hhe header:hd {: RESULT = hhe + hd; :};
  4. A fejléc elem név kettőspont érték alakú                                                                                                                                                       
     > header ::= header_field_name:hfn COLON:c HEADER_FIELD_VALUE:hfv {: RESULT = hfn + c + hfv; headerFieldNameValueMap.put(hfn, hfv); :};
  5. A fejléc név: SIMPLE_STRING alakú (sima szöveg feldolgozás)                                                                                                                                       
     > header_field_name ::= SIMPLE_STRING:ss {: RESULT =ss; :};
  6. A kérés törzse lehet üres, vagy tartalmazhat JSON, XML adatot                                                                                                                                                      
     > http_body ::= /*empty*/ | json_body_cotent {: isJson = true; :} | xml_body_content;
  7. Az XML törzs állhat XML verzióból és XML elemekből, vagy verzió nélkül csak XML elemekből                                                                                                                                                       
     > xml_body_content ::= XML_VERSION:value xml_elements {: string.append(value); :} | xml_elements;
  8. Az XML elem nyító tagből, értékből és zárótagből épül fel                                                                                                                                                      
     > xml_elements ::= XML_OPEN:xo xml_value XML_CLOSE:xc {: string.append(xo); string.append(xc); :};
  9. Az XML érték lehet szöveg, szám, XML elem vagy XML érték és elem együttese                                                                                                                                                       
     > xml_value ::= xml_elements | xml_value xml_elements | SIMPLE_STRING:value {: string.append(value); :} | NUMBER_WITH_FRACTION:value {: string.append(value); :};
  10. JSON törzs kezdődhet objektumként vagy tömbként
       > json_body_cotent ::= object:jbco {: RESULT = jbco; :} | array:jbca {: RESULT = jbca; :};
  11. JSON értéke lehet szöveg, szám, objektum, tömb, igaz, hamis vagy null érték                                                                                                                                                       
       > value ::= STRING:value {: string.append(value); :}
       | NUMBER_WITH_FRACTION:value {: string.append(value); :}
       | object
       | array
       | TRUE:value {: string.append(value); :}
       | FALSE:value {: string.append(value); :}
       | NULL:value {: string.append(value); :};
  12. JSON objektum lehet az alábbi {} vagy { key_value_list }                                                                                                                                                       
       > object ::= LEFT_BRACE:lb RIGHT_BRACE:rb {: string.append(lb); string.append(rb); :}
       > | LEFT_BRACE:lb key_value_list RIGHT_BRACE:rb {: string.append(lb); string.append(rb); :};
  13. JSON tömb lehet az alábbi [] vagy [ value_list ]                                                                                                                                                         
       > array ::= LEFT_SQUARE_BRACKET:lsb RIGHT_SQUARE_BRACKET:rsb {: string.append(lsb); string.append(rsb); :}
       | LEFT_SQUARE_BRACKET:lsb value_list RIGHT_SQUARE_BRACKET:rsb {: string.append(lsb); string.append(rsb); :};
  14. a kulcsérték az alábbi módon épül fel: szöveg kettőspont érték                              
       > key_value ::= STRING:s COLON:c value {: string.append(s); string.append(c); :};
  15. a kulcslista lehet egy egyszerű kulcsérték vagy kulcslista kettőspont kulcsérték                                                                                                                                                      
       > key_value_list ::= key_value_list COMMA:c key_value {: string.append(c); :}
       | key_value;
  16. az értéklista lehet egy egyszerá érték vagy értéklista kettőspont érték                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
       > value_list ::= value_list COMMA:c value {: string.append(c); :}
       | value;

## Futtatás:
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
