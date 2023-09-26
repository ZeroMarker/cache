Class CIS.OPApp.DTO.ENS.Response.Header Extends (CIS.OPApp.DTO.Abstract.Model, %XML.Adaptor)
{

Parameter XMLNAME = "Header";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// if debug is 1, then write console logs
Parameter DEBUG = 0;

Property SourceSystem As %String;

Property MessageID As %String;

ClassMethod Create() As CIS.OPApp.DTO.ENS.Response.Header
{
	quit ##class(CIS.OPApp.DTO.ENS.Response.Header).%New()
}

ClassMethod CloneFromObject(object As %RegisteredObject) As CIS.OPApp.DTO.ENS.Request.Header
{
	set result=##class(CIS.OPApp.DTO.ENS.Response.Header).%New()
	set result.SourceSystem=$property(object,"SourceSystem")
	set result.MessageID=$property(object,"MessageID")
	
	quit result
}

Method Default() As %Status
{
	set ##this.SourceSystem="Mediway.OPApp"
	set ##this.MessageID=""
	
	quit $$$OK
}

}
