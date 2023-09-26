Class web.SAXHandler Extends (%RegisteredObject, %XML.Adaptor, %XML.SAX.ContentHandler) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

ClassMethod ParseStream(mystream As %Stream) As %String
{
 // create an instance of MyHandler class
 Set handler = ##class(SAXHandler).%New()

 // now parse the file using the handler
 Set sc = ##class(%XML.SAX.Parser).ParseStream(mystream,handler)
 if $$$ISOK(sc){
	    
 }
}

Method startElement(uri As %Library.String, localname As %Library.String, qname As %Library.String, attrs As %Library.List)
{
	Write !,"Element: ",localname
	w qname,!
}

}
