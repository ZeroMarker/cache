Class web.DHCXMLIO Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter IOStrLen = 1000;

/// /此类的目的是?完成JS与Cache之间的交互?
ClassMethod ReadXML(JSFunName As %String, CFlag As %String) As %Stream
{
	////%Stream
	////Test    d ##class(web.DHCXMLIO).ReadXML("","test1")
	s CFlag=$g(CFlag)
	
	s mystream= ##class(web.DHCDataStream).ReadServerXML(CFlag)
	
	d mystream.Rewind()
	;JSName
	While (stream.AtEnd = 0) {
		s IOStrLen=2000
		s mystr=stream.Read(.IOStrLen)
		s rtnval=JSFunName_"('"_$ZCVT($g(mystr),"O","JS")_"');"
		&javascript<#(rtnval)#>
	}
	q 0		;;;;$ZCVT($g(mystr),"O","JS") ;;$l(dd,$c(13))			;;;stream.Size	;;"Test"
}

ClassMethod TestInsert()
{
	;d ##class(web.DHCXMLIO).TestInsert()
	;
	s myobj=##class(User.DHCXMLPConfig).%New()
	
	s myobj.XPCFlag="XPCFlag12345"
	;d myobj.XPCFileData.Write("")
	
	d myobj.%Save()
	
	b
}

}
