package jsonxmlparser;

import java_cup.runtime.SymbolFactory;
import java.io.InputStreamReader;
import java.lang.Exception;
import java.util.*;

%%
%cup
%unicode
%line
%column
%class Scanner
%{
    private SymbolFactory sf;
    StringBuffer string = new StringBuffer();

    Map<String, Object> stringObjectMap = new HashMap<>();

    public Scanner(java.io.FileInputStream r, SymbolFactory sf){
        this(new InputStreamReader(r));
        this.sf=sf;
    }
%}
%eofval{
    return sf.newSymbol("EOF",Symbols.EOF);
%eofval}

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

%%
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
