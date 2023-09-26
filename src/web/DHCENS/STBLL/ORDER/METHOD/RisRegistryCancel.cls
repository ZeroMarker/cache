Class web.DHCENS.STBLL.ORDER.METHOD.RisRegistryCancel Extends (%RegisteredObject, %XML.Adaptor)
{

/// 服务编码:S0023
/// Creator:lipan
/// CreatDate:2016-07-21
ClassMethod RegistryCancel(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set $zt="Exception"
	set suCount=0,faCount=0,faInfo=""
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(Input,.tDocument)
	set Response=##class(web.DHCENS.STBLL.ORDER.MODEL.Response).%New()
	set header=##class(web.DHCENS.STBLL.ORDER.MODEL.Header).%New()
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.SourceSystem="02"
	set Response.header=header
	set responseBody=##class(web.DHCENS.STBLL.ORDER.MODEL.Respbody).%New()
	if $$$ISERR(tSC) {
		set responseBody.ResultCode="-1"
		set responseBody.ResultContent=tSC
		set Response.Respbody=responseBody
	}else{
		set tSC=tDocument.EvaluateExpression("/Request/Body/RisRegistryCancelRt/OEORIOrderItemIDs","count(OEORIOrderItemID)",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			set hsCount=tRes.GetAt(1).Value
			Quit:hsCount="0" "-1^信息为空"
			for i=1:1:hsCount {
				set (OrderItemID,SpecimenID,ExecUserCode,SpeciReceiveDate,SpeciReceiveTime)=""
				set HosCode="HNSRMYY"	
				set tSC=tDocument.EvaluateExpression("/Request/Body/RisRegistryCancelRt/OEORIOrderItemIDs/OEORIOrderItemID["_i_"]","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set OrderItemID=$tr(fieldValue,$c(0),"")
				}
				
				set tSC=tDocument.EvaluateExpression("/Request/Body/RisRegistryCancelRt/UpdateUserCode","text()",.tRes)	
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set ExecUserCode=$tr(fieldValue,$c(0),"")
				}
				set ExeUserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(ExecUserCode),""))
				set ExecFlag="" 
				if ((OrderItemID'="")&&(ExeUserID'="")){
					s ExecFlag=##class(web.DHCEMInterface).GetExaReqPartExeStatus($p(OrderItemID,"^",1,2),$p(OrderItemID,"^",3),"V")
				}
				if ExecFlag="0" {
					set responseBody.ResultCode="0"
					set responseBody.ResultContent="成功"
				}elseif ExecFlag="-100" {
					set responseBody.ResultCode="-1"
					set responseBody.ResultContent="医嘱不存在"
				}elseif ExecFlag="-209"{
					set responseBody.ResultCode="-1"
					set responseBody.ResultContent="执行状态的医嘱才能变为核实"
				}elseif ExecFlag=""{
					set responseBody.ResultCode="-1"
					set responseBody.ResultContent="医嘱号或执行人为空"
				}else{
					set responseBody.ResultCode="-1"
					set responseBody.ResultContent="保存失败"
				}
			}

		}else{
			set responseBody.ResultCode="-1"
			set responseBody.ResultContent="消息结构有误"
		}
		set Response.Respbody=responseBody
	}
	d Response.XMLExportToStream(.stream)
	Quit stream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

}
