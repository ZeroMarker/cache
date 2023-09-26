Class web.HXGYPrinter.XMLFileIO Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

ClassMethod ReadFileXML(TempletName As %String) As %FileCharacterStream
{
	s TempletName=$g(TempletName)
	s xx=##class(User.HXReportSchema).%OpenId(TempletName)
	q xx.SchemaContent
}

ClassMethod ReadSignData(CTPCPRowId As %String) As %FileCharacterStream
{
	s CTPCPRowId=$g(CTPCPRowId)
	s xx=##class(User.DHCCTPcpExtra).%OpenId(CTPCPRowId)
	if $IsObject(xx)
	{
		q xx.Sign
	}
	else
	{
		q ""
	}
}

ClassMethod ReadSignFile(JSFunName As %String, CTPCPRowId As %String) As %Stream
{
	s CTPCPRowId=$g(CTPCPRowId)
	s stream= ..ReadSignData(CTPCPRowId)
	q:stream="" -1
	d stream.Rewind()
	s ii=0
	While (stream.AtEnd = 0) {
		s ii=ii+1
		s IOStrLen=2000
		s mystr=stream.Read(.IOStrLen)
		s rtnval=JSFunName_"('"_$ZCVT($g(mystr),"O","JS")_"');"
		&javascript<#(rtnval)#>
	}
	q 0
}

ClassMethod ReadXMLFile(JSFunName As %String, TempletName As %String) As %Stream
{
	s TempletName=$g(TempletName)
	s stream= ..ReadFileXML(TempletName)
	d stream.Rewind()
	s ii=0
	While (stream.AtEnd = 0) {
		s ii=ii+1
		s IOStrLen=2000
		s mystr=stream.Read(.IOStrLen)
		s rtnval=JSFunName_"('"_$ZCVT($g(mystr),"O","JS")_"');"
		&javascript<#(rtnval)#>
	}
	q 0
}

}
