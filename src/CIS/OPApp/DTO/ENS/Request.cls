Class CIS.OPApp.DTO.ENS.Request Extends (CIS.OPApp.DTO.Abstract.Request, %XML.Adaptor)
{

Parameter XMLNAME = "Request";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// if debug is 1, then write console logs
Parameter DEBUG = 0;

Property Header As CIS.OPApp.DTO.ENS.Request.Header;

Property Body As CIS.OPApp.DTO.ENS.Request.Body;

ClassMethod Create() As CIS.OPApp.DTO.ENS.Request
{
	set result=##class(CIS.OPApp.DTO.ENS.Request).%New()
	set result.Header=##class(CIS.OPApp.DTO.ENS.Request.Header).Create()
	set result.Body=##class(CIS.OPApp.DTO.ENS.Request.Body).Create()
	quit result
}

ClassMethod CloneFromXML(xml As %GlobalCharacterStream, contentNode As %String, modelName As %String = "") As CIS.OPApp.DTO.ENS.Request
{
	if ..#DEBUG=1 write "request clone from xml: ContentNode",contentNode," modelName:",modelName,!
	set request=##class(CIS.OPApp.DTO.ENS.Request).Create()
	if $$$ISOK(request.ReadStream(xml))
	{
		if (contentNode'="")
		{
			set reader=##class(%XML.Reader).%New()
			set sc=reader.OpenStream(xml)
			if modelName'=""
			{
				set struct=request.Body.Struct
				do reader.Correlate(contentNode,modelName)
				while (reader.Next(.obj,.sc))
				{
					do struct.Models.Insert(obj)
				}
			}
			else
			{
				set arguments=request.Body.Arguments
				do reader.Correlate(contentNode,"CIS.OPApp.DTO.ENS.Request.Arguments")
				while (reader.Next(.obj,.sc))
				{
					do arguments.CloneInit(obj)
				}
			}
		}
	}
	
	quit request
}

ClassMethod CloneFromObject(object As %RegisteredObject, modelName As %String = "") As CIS.OPApp.DTO.ENS.Request
{
	if ..#DEBUG=1 write "request clone from object start...",!
	set result=##class(CIS.OPApp.DTO.ENS.Request).%New()
	if ..#DEBUG=1 write "request header clone from object start...",!
	set result.Header=##class(CIS.OPApp.DTO.ENS.Request.Header).CloneFromObject($property(object,"Header"))
	if ..#DEBUG=1 write "request body clone from object start...",!
	set result.Body=##class(CIS.OPApp.DTO.ENS.Request.Body).CloneFromObject($property(object,"Body"),modelName)
	if ..#DEBUG=1 write "request clone from object end",!
	quit result
}

Method ReadStream(xml As %GlobalCharacterStream) As %Status
{
	if ..#DEBUG=1 write "reading response xml...",!
	set reader=##class(%XML.Reader).%New()
	set sc=reader.OpenStream(xml)
	
	set header=##this.Header
	set body=##this.Body
	do reader.Correlate("Response","CIS.OPApp.DTO.ENS.Decode.Request")
	while (reader.Next(.obj,.sc))
	{
		if ..#DEBUG=1 write "Correlate succeed",!
		do header.CloneInit(obj.Header)
		do body.CloneInit(obj.Body)
	}
	
	quit $$$OK
}

Method ToXML() As %GlobalCharacterStream
{
	set xml=##class(%GlobalCharacterStream).%New()
    set ret=##this.XMLExportToStream(.xml)
    
    quit xml
}

Method Default() As %Status
{
	quit ##this.Header.Default()
}

Method Compose(models As %ListOfObjects) As %Status
{
	do ##this.Body.Compose(models)
	quit $$$OK
}

}
