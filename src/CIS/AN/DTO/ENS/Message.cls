Class CIS.AN.DTO.ENS.Message Extends (CIS.AN.DTO.Abstract.Request, CIS.AN.DTO.Abstract.Message, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLTYPE = "Request";

Parameter XMLNAME = "Request";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// if debug is 1, then write console logs
Parameter DEBUG = 0;

Property Header As CIS.AN.DTO.ENS.Request.Header;

Property Body As CIS.AN.DTO.ENS.Message.Body;

ClassMethod CloneFromXML(xml As %GlobalCharacterStream, contentNode As %String, modelName As %String = "") As CIS.AN.DTO.ENS.Request
{
	set request=##class(CIS.AN.DTO.ENS.Request).Create()
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
				do reader.Correlate(contentNode,"CIS.AN.DTO.ENS.Request.Arguments")
				while (reader.Next(.obj,.sc))
				{
					do arguments.CloneInit(obj)
				}
			}
		}
	}
	
	quit request
}

ClassMethod CloneFromObject(object As %RegisteredObject, modelName As %String = "") As CIS.AN.DTO.ENS.Request
{
	if ..#DEBUG=1 write "AIS: request clone from object start...",!
	set result=##class(CIS.AN.DTO.ENS.Request).%New()
	if ..#DEBUG=1 write "AIS: request header clone from object start...",!
	set result.Header=##class(CIS.AN.DTO.ENS.Request.Header).CloneFromObject($property(object,"Header"))
	if ..#DEBUG=1 write "AIS: request body clone from object start...",!
	set result.Body=##class(CIS.AN.DTO.ENS.Request.Body).CloneFromObject($property(object,"Body"),modelName)
	if ..#DEBUG=1 write "AIS: request clone from object end",!
	
	quit result
}

Method ReadStream(xml As %GlobalCharacterStream) As %Status
{
	set reader=##class(%XML.Reader).%New()
	set sc=reader.OpenStream(xml)
	
	set header=##this.Header
	set sourceSystem="",messageID=""
	do reader.Correlate("Request","CIS.AN.DTO.ENS.Decode.Request")
	while (reader.Next(.obj,.sc))
	{
		do header.CloneInit(obj.Header)
	}
	
	quit $$$OK
}

Method ToXML() As %GlobalCharacterStream
{
	set xml=##class(%GlobalCharacterStream).%New()
    //set ret=##this.XMLExportToStream(.xml)
    
    do xml.Write("<Request>")
    do xml.Write("<Header>")
    do xml.Write("<SourceSystem>"_##this.Header.SourceSystem_"</SourceSystem>")
    do xml.Write("<MessageID>"_##this.Header.MessageID_"</MessageID>")
    do xml.Write("</Header>")
    do xml.Write("<Body>")
    do xml.Write("<MsgSendRt>")
    do xml.Write("<Context>"_##this.Body."﻿MsgSendRt".Context_"</Context>")
    do xml.Write("<ActionTypeCode>"_##this.Body."﻿MsgSendRt".ActionTypeCode_"</ActionTypeCode>")
    do xml.Write("<PAADMVisitNumber>"_##this.Body."﻿MsgSendRt".PAADMVisitNumber_"</PAADMVisitNumber>")
    do xml.Write("<FromUserRowId>"_##this.Body."﻿MsgSendRt".FromUserRowId_"</FromUserRowId>")
    do xml.Write("<OEORIOrderItemID>"_##this.Body."﻿MsgSendRt".OEORIOrderItemID_"</OEORIOrderItemID>")
    do xml.Write("<ToUserRowId>"_##this.Body."﻿MsgSendRt".ToUserRowId_"</ToUserRowId>")
    do xml.Write("<OtherInfoJson>"_##this.Body."﻿MsgSendRt".OtherInfoJson_"</OtherInfoJson>")
    do xml.Write("<ToLocRowId>"_##this.Body."﻿MsgSendRt".ToLocRowId_"</ToLocRowId>")
    do xml.Write("<EffectiveDays>"_##this.Body."﻿MsgSendRt".EffectiveDays_"</EffectiveDays>")
    do xml.Write("<CreateLoc>"_##this.Body."﻿MsgSendRt".CreateLoc_"</CreateLoc>")
    do xml.Write("</MsgSendRt>")
    do xml.Write("</Body>")
    do xml.Write("</Request>")
    
    quit xml
}

Method Default() As %Status
{
	quit ##this.Header.Default()
}

Method Compose(model As CIS.AN.DTO.ENS.Message.Content) As %Status
{
	quit ##this.Body.Compose(model)
}

}
