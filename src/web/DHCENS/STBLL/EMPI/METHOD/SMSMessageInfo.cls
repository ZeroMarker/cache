Class web.DHCENS.STBLL.EMPI.METHOD.SMSMessageInfo Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2016—08-08
/// Description：短信信息
/// Table：
/// Input：
/// Return：
/// Others：w ##class(web.DHCENS.STBLL.EMPI.METHOD.SMSMessageInfo).MessageInfo("1,7778")
ClassMethod MessageInfo(input As %String) As %GlobalCharacterStream
{
	set request=##class(web.DHCENS.STBLL.EMPI.MODEL.Request).%New()
	set header=##class(web.DHCENS.STBLL.EMPI.MODEL.Header).%New()
	set header.SourceSystem="02"
	set MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.MessageID=MessageID
	set request.header=header
	set body=##class(web.DHCENS.STBLL.EMPI.MODEL.Body).%New()
	set Obj=##class(web.DHCENS.STBLL.EMPI.MODEL.SMSMessageInfo).%New()
	set length=$l(input,",")
	set Obj.Mobile=$p(input,",",1)
	set Obj.Content=$p(input,",",2,length)
	set body.messInfo=Obj
	set request.body=body
	d request.XMLExportToStream(.stream)
	set (request,header,body,Obj)=""
	b ;01
	Quit stream
Exception
	b ;err
	set request.body=body
	do request.XMLExportToStream(.stream)
	set (request,header,body,Obj)=""
	Quit stream
}

/// Creator：lipan
/// CreatDate：2016—09-26
/// Description：各厂商回传报告成功,给短信平台发送短信信息
/// Table：
/// Input：
/// Return：
/// Others：w ##class(web.DHCENS.STBLL.EMPI.METHOD.SMSMessageInfo).SaveMessageInfo("")
ClassMethod SaveMessageInfo(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	Set $ZTrap = "Except"
	d Input.Rewind()
	set Response=##class(web.DHCENS.STBLL.EMPI.MODEL.Response).%New()
	set header=##class(web.DHCENS.STBLL.EMPI.MODEL.Header).%New()
	set header.SourceSystem="02"
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set Response.header=header
	
	set responseBody=##class(web.DHCENS.STBLL.EMPI.MODEL.Respbody).%New()	
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(Input,.tDocument)
	if $$$ISERR(tSC) {
		set responseBody.ResultCode="-1"
		set responseBody.ResultContent=tSC
		set Response.Respbody=responseBody
	}else{	
		set PatName="",PATPatientID="",Mobile="",Content=""
		set tSC=tDocument.EvaluateExpression("/Request/Body/MessageInfo/PatName","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
			set fieldValue=tRes.GetAt(1).Value
			set PatName=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/MessageInfo/PATPatientID","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
			set fieldValue=tRes.GetAt(1).Value
			set PATPatientID=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/MessageInfo/Mobile","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
			set fieldValue=tRes.GetAt(1).Value
			set Mobile=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/MessageInfo/Content","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
			set fieldValue=tRes.GetAt(1).Value
			set Content=$tr(fieldValue,$c(0),"")
		}
		
		if Mobile=""{
			
		}
		set result=##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000043",Mobile_","_Content)
		b ;
	}
	
	q "00"
Except
	b ;err
	Quit stream
}

}
