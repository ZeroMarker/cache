Class web.DHCENS.STBLL.ORDER.METHOD.StopOrdItems Extends (%RegisteredObject, %XML.Adaptor)
{

/// 服务编码:S0017
/// Creator:lipan
/// CreatDate:2016-07-05
ClassMethod UpdateOrdersState(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set $zt="Exception"
	
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(Input,.tDocument)
	d Input.Rewind()
	s ExecFlag=""
	set Response=##class(web.DHCENS.STBLL.ORDER.MODEL.Response).%New()
	set header=##class(web.DHCENS.STBLL.ORDER.MODEL.Header).%New()
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.SourceSystem="02"
	set Response.header=header
	set responseBody=##class(web.DHCENS.STBLL.ORDER.MODEL.Respbody).%New()
	set InvalidFlag=0,InvalidStr=""
	if $$$ISERR(tSC) {
		set responseBody.ResultCode="-1"
		set responseBody.ResultContent=tSC
		set Response.Respbody=responseBody
	}else{
			set PATPatientID="",UpdateUserCode=""
			set HosCode="HNSRMYY"	
			set tSC=tDocument.EvaluateExpression("/Request/Body/UpdateOrdersRt/PATPatientID","text()",.tRes)					
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
				set fieldValue=tRes.GetAt(1).Value
				set PATPatientID=$tr(fieldValue,$c(0),"")
			}
			
			set tSC=tDocument.EvaluateExpression("/Request/Body/UpdateOrdersRt/UpdateUserCode","text()",.tRes)					
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
				set fieldValue=tRes.GetAt(1).Value
				set UpdateUserCode=$tr(fieldValue,$c(0),"")
			}
			
			set tSC=tDocument.EvaluateExpression("/Request/Body/UpdateOrdersRt/OEORIInfoList","count(OEORIInfo)",.tRes)
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
				set hsCount=tRes.GetAt(1).Value
				Quit:hsCount="0" "-1^信息为空"
				s (OEORIOrderItemID,OEORIStatusCode)=""
				b ;22
				for i=1:1:hsCount {
					set tSC=tDocument.EvaluateExpression("/Request/Body/UpdateOrdersRt/OEORIInfoList/OEORIInfo["_i_"]/OEORIOrderItemID","text()",.tRes)					
					if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
						set fieldValue=tRes.GetAt(1).Value
						set OEORIOrderItemID=$tr(fieldValue,$c(0),"")
					}
					set tSC=tDocument.EvaluateExpression("/Request/Body/UpdateOrdersRt/OEORIInfoList/OEORIInfo["_i_"]/OEORIStatusCode","text()",.tRes)					
					if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
						set fieldValue=tRes.GetAt(1).Value
						set OEORIStatusCode=$tr(fieldValue,$c(0),"")
					}
					set IsFlag=..IsStopOrder(OEORIOrderItemID,OEORIStatusCode)
					if 'IsFlag{
						s InvalidFlag=1
						s TmpStr="医嘱号:"_OEORIOrderItemID_"已收费不能修改医嘱状态为:"_OEORIStatusCode
						if InvalidStr=""{
							s InvalidStr=TmpStr
						}
						else{
							s InvalidStr=InvalidStr_"^^^"_TmpStr
						}
						continue
					}
					
					set OstatRowid=$o(^OEC("OSTAT",0,"Code",$$ALPHAUP^SSUTIL4(OEORIStatusCode),""))
					set ExeUserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(UpdateUserCode),""))
					set ExecFlag="" 
					if ((OEORIOrderItemID'="")&&(ExeUserID'="")&&(OstatRowid'="")){
						s ExecFlag=##class(appcom.OEOrdItem).UpdateStatus(OEORIOrderItemID,ExeUserID,OstatRowid)
					}
					
				}
				if ((ExecFlag=0)||(ExecFlag=100)){
						s responseBody.ResultCode="0"
						s responseBody.ResultContent="成功"
					
					}
				else {
				    s responseBody.ResultCode="-1"
					s responseBody.ResultContent="失败"
				}
				if (InvalidFlag=1){
					s responseBody.ResultCode="-1"
					s responseBody.ResultContent=InvalidStr
				}
			}
		
		s Response.Respbody=responseBody
	}   
    
    d Response.XMLExportToStream(.stream)
    q stream
    
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	b ;2
	Quit stream
}

ClassMethod IsStopOrder(ordRowId As %String, OrderStatuCode As %String) As %String
{
	set ord = $P(ordRowId,"||",1)
	set sub = $P(ordRowId,"||",2)
	set ordstr3 = $g(^OEORD(ord,"I",sub,3))
	set OEORIBillStatusCode = $P(ordstr3,"^",5)
	q:((OEORIBillStatusCode="P")&&(OrderStatuCode="U")) "0"
	q:((OEORIBillStatusCode="P")&&(OrderStatuCode="D")) "0"
	q:((OEORIBillStatusCode="P")&&(OrderStatuCode="C")) "0"
	
	q "1"
}

}
