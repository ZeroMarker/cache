Class CIS.AN.DTO.ENS.Response.Header Extends (CIS.AN.DTO.Abstract.Model, %XML.Adaptor)
{

Parameter XMLNAME = "Header";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// if debug is 1, then write console logs
Parameter DEBUG = 0;

Property SourceSystem As %String;

Property MessageID As %String;

ClassMethod Create() As CIS.AN.DTO.ENS.Response.Header
{
	quit ##class(CIS.AN.DTO.ENS.Response.Header).%New()
}

ClassMethod CloneFromObject(object As %RegisteredObject) As CIS.AN.DTO.ENS.Response.Header
{
	set result=##class(CIS.AN.DTO.ENS.Response.Header).%New()
	set result.SourceSystem=$property(object,"SourceSystem")
	set result.MessageID=$property(object,"MessageID")
	
	quit result
}

Method Default() As %Status
{
	set ##this.SourceSystem="Mediway.AIS"
	set ##this.MessageID=""
	
	quit $$$OK
}

}
