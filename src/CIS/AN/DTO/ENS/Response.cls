Class CIS.AN.DTO.ENS.Response Extends (CIS.AN.DTO.Abstract.Response, %XML.Adaptor)
{

Parameter XMLNAME = "Response";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// if debug is 1, then write console logs
Parameter DEBUG = 0;

Property Header As CIS.AN.DTO.ENS.Response.Header;

Property Body As CIS.AN.DTO.ENS.Response.Body;

ClassMethod Create() As CIS.AN.DTO.ENS.Response
{
	set result=##class(CIS.AN.DTO.ENS.Response).%New()
	set result.Header=##class(CIS.AN.DTO.ENS.Response.Header).Create()
	set result.Body=##class(CIS.AN.DTO.ENS.Response.Body).Create()
	quit result
}

ClassMethod CloneFromXML(xml As %GlobalCharacterStream, contentNode As %String, modelName As %String) As CIS.AN.DTO.ENS.Response
{
	if ..#DEBUG=1 write "response clone from xml: ContentNode",contentNode," modelName:",modelName,!
	set response=##class(CIS.AN.DTO.ENS.Response).Create()
	if $$$ISOK(response.ReadStream(xml))
	{
		if (contentNode'="")&&(modelName'="")
		{
			set reader=##class(%XML.Reader).%New()
			set sc=reader.OpenStream(xml)
			set struct=response.Body.Struct
			do reader.Correlate(contentNode,modelName)
			while (reader.Next(.obj,.sc))
			{
				do struct.Models.Insert(obj)
			}
		}
	}
	
	quit response
}

ClassMethod CloneFromObject(object As %RegisteredObject, modelName As %String = "") As CIS.AN.DTO.ENS.Response
{
	set result=##class(CIS.AN.DTO.ENS.Response).%New()
	if ..#DEBUG=1 write "response header clone start",!
	set result.Header=##class(CIS.AN.DTO.ENS.Response.Header).CloneFromObject($property(object,"Header"))
	if ..#DEBUG=1 write "response body clone start",!
	set result.Body=##class(CIS.AN.DTO.ENS.Response.Body).CloneFromObject($property(object,"Body"),modelName)
	
	quit result
}

Method ReadStream(xml As %GlobalCharacterStream) As %Status
{
	if ..#DEBUG=1 write "reading response xml...",!
	set reader=##class(%XML.Reader).%New()
	set sc=reader.OpenStream(xml)
	
	set header=##this.Header
	set body=##this.Body
	do reader.Correlate("Response","CIS.AN.DTO.ENS.Decode.Response")
	while (reader.Next(.obj,.sc))
	{
		if ..#DEBUG=1 write "Correlate succeed: ResultCode",obj.Body.ResultCode,!
		do header.CloneInit(obj.Header)
		do body.CloneInit(obj.Body)
	}
	if ..#DEBUG=1 write "response ResultCode:"
	if ..#DEBUG=1 write ##this.Body.ResultCode,!
	if ##this.Body.ResultCode'=0 quit $$$ERROR()
	quit $$$OK
}

Method ToXML() As %GlobalCharacterStream
{
	set xml=##class(%GlobalCharacterStream).%New()
    set ret=##this.XMLExportToStream(.xml)
    
    quit xml
}

Method Succeed() As %Status
{
	quit ##this.Body.Succeed()
}

Method Fail(reason As %String) As %Status
{
	quit ##this.Body.Fail(reason)
}

Method IsSuccess() As %Boolean
{
	quit ##this.Body.IsSuccess()
}

Method IsFailed() As %Boolean
{
	quit ##this.Body.IsFailed()
}

Method Compose(models As %ListOfObjects) As %Status
{
	quit ##this.Body.Compose(models)
}

Method Default() As %Status
{
	quit ##this.Header.Default()
}

}
