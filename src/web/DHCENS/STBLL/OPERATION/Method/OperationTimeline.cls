Class web.DHCENS.STBLL.OPERATION.Method.OperationTimeline Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：lipan
/// CreatDate：2016—06-29
/// Description：入手术室
/// Table：
/// Input：01：进手术室 02：进手术间 03：麻醉开始 04：麻醉结束 05：出手术间 06：出手术室
///        07：入恢复室 08：出恢复室 09：三方核对开始 10:其他 11：手术开始  12：手术结束
/// Return：
/// Others: 
/// w ##class(web.DHCENS.STBLL.OPERATION.Method.OperationTimeline).EnterOperationRoom ()
ClassMethod EnterOperationRoom(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set $zt="Exception"
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(Input,.tDocument)
	d Input.Rewind()
	set Response=##class(web.DHCENS.STBLL.OPERATION.Model.Response).%New()
	set header=##class(web.DHCENS.STBLL.OPERATION.Model.Header).%New()
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.SourceSystem="02"
	set Response.header=header
	set responseBody=##class(web.DHCENS.STBLL.OPERATION.Model.Respbody).%New()
	if $$$ISERR(tSC) {
		set responseBody.ResultCode="-1"
		set responseBody.ResultContent=tSC
		set Response.Respbody=responseBody
	}else{
		set (PAADMVisitNumber,OPERApplicationNum,EnterDateTime)=""
		set HosCode="DHSZHYYZY"	
		set tSC=tDocument.EvaluateExpression("/Request/Body/EnterOperationRoomRt/PAADMVisitNumber","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
			set fieldValue=tRes.GetAt(1).Value
			set PAADMVisitNumber=$tr(fieldValue,$c(0),"")
		}		
		set tSC=tDocument.EvaluateExpression("/Request/Body/EnterOperationRoomRt/OPERApplicationNum","text()",.tRes)	
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set OPERApplicationNum=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/EnterOperationRoomRt/EnterDateTime","text()",.tRes)	
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set EnterDateTime=$tr(fieldValue,$c(0),"")
		}		
		set OpaID=##class(CIS.AN.SRV.OperService).GetOpaIdByOpsId(OPERApplicationNum)
		///	set dataTimeStr="入手术科室日期^入手术科室时间^离手术科室日期^离手术科室时间^入手术间日期^时间^离手术间日期^时间^麻醉开始日期^时间^麻醉结束日期^时间^手术开始日期^时间^手术结束日期^时间^气管插管日期^时间^气管拔管日期^时间^入PACU日期^时间^离PACU日期^时间^离手术室去向"
		set dataTimeStr=$p(EnterDateTime," ",1)_"^"_$p(EnterDateTime," ",2)_"^^^^^^^^^^^^^^^^^^^^^^"
		set tSC=##class(CIS.AN.SRV.OperService).SaveKeyEventTime(OpaID,dataTimeStr)
		if tSC="0" {
			set responseBody.ResultCode="0"
			set responseBody.ResultContent="成功"
		}
		else {
			set responseBody.ResultCode="-1"
			set responseBody.ResultContent=tSC
		}
		set Response.Respbody=responseBody
	}   
    
    d Response.XMLExportToStream(.stream)
    q stream
    
Exception
	set Response=##class(web.DHCENS.STBLL.OPERATION.Model.Response).%New()
	set header=##class(web.DHCENS.STBLL.OPERATION.Model.Header).%New()
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.SourceSystem="02"
	set Response.header=header
	set responseBody=##class(web.DHCENS.STBLL.OPERATION.Model.Respbody).%New()
	set responseBody.ResultCode="-1"
	set responseBody.ResultContent=$ze
	set Response.Respbody=responseBody
    d Response.XMLExportToStream(.stream)
    q stream
}

/// Description:手术开始
ClassMethod OperationBegan(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set $zt="Exception"
	
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(Input,.tDocument)
	d Input.Rewind()
	set Response=##class(web.DHCENS.STBLL.OPERATION.Model.Response).%New()
	set header=##class(web.DHCENS.STBLL.OPERATION.Model.Header).%New()
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.SourceSystem="02"
	set Response.header=header
	set responseBody=##class(web.DHCENS.STBLL.OPERATION.Model.Respbody).%New()
	if $$$ISERR(tSC) {
		set responseBody.ResultCode="-1"
		set responseBody.ResultContent=tSC
		set Response.Respbody=responseBody
	}else{
		set (PAADMVisitNumber,OPERApplicationNum,OperationBeganDateTime)=""
		set HosCode="DHSZHYYZY"	
		set tSC=tDocument.EvaluateExpression("/Request/Body/EnterOperationRoomRt/PAADMVisitNumber","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
			set fieldValue=tRes.GetAt(1).Value
			set PAADMVisitNumber=$tr(fieldValue,$c(0),"")
		}			
		set tSC=tDocument.EvaluateExpression("/Request/Body/EnterOperationRoomRt/OPERApplicationNum","text()",.tRes)	
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set OPERApplicationNum=$tr(fieldValue,$c(0),"")
		}		
		set tSC=tDocument.EvaluateExpression("/Request/Body/EnterOperationRoomRt/OperationBeganDateTime","text()",.tRes)	
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set OperationBeganDateTime=$tr(fieldValue,$c(0),"")
		}
		set OpaID=##class(CIS.AN.SRV.OperService).GetOpaIdByOpsId(OPERApplicationNum)
		///	set dataTimeStr="入手术科室日期^入手术科室时间^离手术科室日期^离手术科室时间^入手术间日期^时间^离手术间日期^时间^麻醉开始日期^时间^麻醉结束日期^时间^手术开始日期^时间^手术结束日期^时间^气管插管日期^时间^气管拔管日期^时间^入PACU日期^时间^离PACU日期^时间^离手术室去向"
		set dataTimeStr="^^^^^^^^^^^^"_$p(OperationBeganDateTime," ",1)_"^"_$p(OperationBeganDateTime," ",2)_"^^^^^^^^^^^^^^"
		set tSC=##class(CIS.AN.SRV.OperService).SaveKeyEventTime(OpaID,dataTimeStr)
		if tSC="0" {
			set responseBody.ResultCode="0"
			set responseBody.ResultContent="成功"
		}
		else {
			set responseBody.ResultCode="-1"
			set responseBody.ResultContent=tSC
		}
		s Response.Respbody=responseBody
	}   
    
    d Response.XMLExportToStream(.stream)
    q stream
    
Exception
	set Response=##class(web.DHCENS.STBLL.OPERATION.Model.Response).%New()
	set header=##class(web.DHCENS.STBLL.OPERATION.Model.Header).%New()
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.SourceSystem="02"
	set Response.header=header
	set responseBody=##class(web.DHCENS.STBLL.OPERATION.Model.Respbody).%New()
	set responseBody.ResultCode="-1"
	set responseBody.ResultContent=$ze
	set Response.Respbody=responseBody
    d Response.XMLExportToStream(.stream)
    q stream
}

/// Description:麻醉开始
ClassMethod AnesthesiaBegan(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set $zt="Exception"
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(Input,.tDocument)
	d Input.Rewind()
	set Response=##class(web.DHCENS.STBLL.OPERATION.Model.Response).%New()
	set header=##class(web.DHCENS.STBLL.OPERATION.Model.Header).%New()
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.SourceSystem="02"
	set Response.header=header
	set responseBody=##class(web.DHCENS.STBLL.OPERATION.Model.Respbody).%New()
	if $$$ISERR(tSC) {
		set responseBody.ResultCode="-1"
		set responseBody.ResultContent=tSC
		set Response.Respbody=responseBody
	}else{
		set (PAADMVisitNumber,OPERApplicationNum,AnesthesiaBeganDateTime)=""
		set HosCode="DHSZHYYZY"	
		set tSC=tDocument.EvaluateExpression("/Request/Body/EnterOperationRoomRt/PAADMVisitNumber","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
			set fieldValue=tRes.GetAt(1).Value
			set PAADMVisitNumber=$tr(fieldValue,$c(0),"")
		}		
		set tSC=tDocument.EvaluateExpression("/Request/Body/EnterOperationRoomRt/OPERApplicationNum","text()",.tRes)	
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set OPERApplicationNum=$tr(fieldValue,$c(0),"")
		}		
		set tSC=tDocument.EvaluateExpression("/Request/Body/EnterOperationRoomRt/AnesthesiaBeganDateTime","text()",.tRes)	
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set AnesthesiaBeganDateTime=$tr(fieldValue,$c(0),"")
		}
		set OpaID=##class(CIS.AN.SRV.OperService).GetOpaIdByOpsId(OPERApplicationNum)
		///	set dataTimeStr="入手术科室日期^入手术科室时间^离手术科室日期^离手术科室时间^入手术间日期^时间^离手术间日期^时间^麻醉开始日期^时间^麻醉结束日期^时间^手术开始日期^时间^手术结束日期^时间^气管插管日期^时间^气管拔管日期^时间^入PACU日期^时间^离PACU日期^时间^离手术室去向"
		set dataTimeStr="^^^^^^^^"_$p(AnesthesiaBeganDateTime," ",1)_"^"_$p(AnesthesiaBeganDateTime," ",2)_"^^^^^^^^^^^^^^^^^^"
		set tSC=##class(CIS.AN.SRV.OperService).SaveKeyEventTime(OpaID,dataTimeStr)
		if tSC="0" {
			set responseBody.ResultCode="0"
			set responseBody.ResultContent="成功"
		}
		else {
			set responseBody.ResultCode="-1"
			set responseBody.ResultContent=tSC
		}	
		s Response.Respbody=responseBody
	}   
    
    d Response.XMLExportToStream(.stream)
    q stream
    
Exception
	set Response=##class(web.DHCENS.STBLL.OPERATION.Model.Response).%New()
	set header=##class(web.DHCENS.STBLL.OPERATION.Model.Header).%New()
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.SourceSystem="02"
	set Response.header=header
	set responseBody=##class(web.DHCENS.STBLL.OPERATION.Model.Respbody).%New()
	set responseBody.ResultCode="-1"
	set responseBody.ResultContent=$ze
	set Response.Respbody=responseBody
    d Response.XMLExportToStream(.stream)
    q stream
}

/// Description:麻醉结束
ClassMethod AnesthesiaOver(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set $zt="Exception"
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(Input,.tDocument)
	d Input.Rewind()
	set Response=##class(web.DHCENS.STBLL.OPERATION.Model.Response).%New()
	set header=##class(web.DHCENS.STBLL.OPERATION.Model.Header).%New()
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.SourceSystem="02"
	set Response.header=header
	set responseBody=##class(web.DHCENS.STBLL.OPERATION.Model.Respbody).%New()
	if $$$ISERR(tSC) {
		set responseBody.ResultCode="-1"
		set responseBody.ResultContent=tSC
		set Response.Respbody=responseBody
	}else{
		set (PAADMVisitNumber,OPERApplicationNum,AnesthesiaOverDateTime)=""
		set HosCode="DHSZHYYZY"	
		set tSC=tDocument.EvaluateExpression("/Request/Body/EnterOperationRoomRt/PAADMVisitNumber","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
			set fieldValue=tRes.GetAt(1).Value
			set PAADMVisitNumber=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/EnterOperationRoomRt/OPERApplicationNum","text()",.tRes)	
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set OPERApplicationNum=$tr(fieldValue,$c(0),"")
		} 
		set tSC=tDocument.EvaluateExpression("/Request/Body/EnterOperationRoomRt/AnesthesiaOverDateTime","text()",.tRes)	
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set AnesthesiaOverDateTime=$tr(fieldValue,$c(0),"")
		}  
		set OpaID=##class(CIS.AN.SRV.OperService).GetOpaIdByOpsId(OPERApplicationNum)
		///	set dataTimeStr="入手术科室日期^入手术科室时间^离手术科室日期^离手术科室时间^入手术间日期^时间^离手术间日期^时间^麻醉开始日期^时间^麻醉结束日期^时间^手术开始日期^时间^手术结束日期^时间^气管插管日期^时间^气管拔管日期^时间^入PACU日期^时间^离PACU日期^时间^离手术室去向"
		set dataTimeStr="^^^^^^^^^^"_$p(AnesthesiaOverDateTime," ",1)_"^"_$p(AnesthesiaOverDateTime," ",2)_"^^^^^^^^^^^^^^^^"
		set tSC=##class(CIS.AN.SRV.OperService).SaveKeyEventTime(OpaID,dataTimeStr)
		if tSC="0" {
			set responseBody.ResultCode="0"
			set responseBody.ResultContent="成功"
		}
		else {
			set responseBody.ResultCode="-1"
			set responseBody.ResultContent=tSC
		}	
		s Response.Respbody=responseBody	
	}   
    
    d Response.XMLExportToStream(.stream)
    q stream
    
Exception
	set Response=##class(web.DHCENS.STBLL.OPERATION.Model.Response).%New()
	set header=##class(web.DHCENS.STBLL.OPERATION.Model.Header).%New()
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.SourceSystem="02"
	set Response.header=header
	set responseBody=##class(web.DHCENS.STBLL.OPERATION.Model.Respbody).%New()
	set responseBody.ResultCode="-1"
	set responseBody.ResultContent=$ze
	set Response.Respbody=responseBody
    d Response.XMLExportToStream(.stream)
    q stream
}

/// Description:手术结束
ClassMethod OperationOver(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set $zt="Exception"
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(Input,.tDocument)
	d Input.Rewind()
	set Response=##class(web.DHCENS.STBLL.OPERATION.Model.Response).%New()
	set header=##class(web.DHCENS.STBLL.OPERATION.Model.Header).%New()
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.SourceSystem="02"
	set Response.header=header
	set responseBody=##class(web.DHCENS.STBLL.OPERATION.Model.Respbody).%New()
	if $$$ISERR(tSC) {
		set responseBody.ResultCode="-1"
		set responseBody.ResultContent=tSC
		set Response.Respbody=responseBody
	}else{
		set (PAADMVisitNumber,OPERApplicationNum,OperationOverDateTime)=""
		set HosCode="DHSZHYYZY"	
		set tSC=tDocument.EvaluateExpression("/Request/Body/EnterOperationRoomRt/PAADMVisitNumber","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
			set fieldValue=tRes.GetAt(1).Value
			set PAADMVisitNumber=$tr(fieldValue,$c(0),"")
		}		
		set tSC=tDocument.EvaluateExpression("/Request/Body/EnterOperationRoomRt/OPERApplicationNum","text()",.tRes)	
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set OPERApplicationNum=$tr(fieldValue,$c(0),"")
		}		
		set tSC=tDocument.EvaluateExpression("/Request/Body/EnterOperationRoomRt/OperationOverDateTime","text()",.tRes)	
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set OperationOverDateTime=$tr(fieldValue,$c(0),"")
		}
		set OpaID=##class(CIS.AN.SRV.OperService).GetOpaIdByOpsId(OPERApplicationNum)
		///	set dataTimeStr="入手术科室日期^入手术科室时间^离手术科室日期^离手术科室时间^入手术间日期^时间^离手术间日期^时间^麻醉开始日期^时间^麻醉结束日期^时间^手术开始日期^时间^手术结束日期^时间^气管插管日期^时间^气管拔管日期^时间^入PACU日期^时间^离PACU日期^时间^离手术室去向"
		set dataTimeStr="^^^^^^^^^^^^^^"_$p(OperationOverDateTime," ",1)_"^"_$p(OperationOverDateTime," ",2)_"^^^^^^^^^^^^"
		set tSC=##class(CIS.AN.SRV.OperService).SaveKeyEventTime(OpaID,dataTimeStr)
		if tSC="0" {
			set responseBody.ResultCode="0"
			set responseBody.ResultContent="成功"
		}
		else {
			set responseBody.ResultCode="-1"
			set responseBody.ResultContent=tSC
		}	
		s Response.Respbody=responseBody	
	}   
    
    d Response.XMLExportToStream(.stream)
    q stream
    
Exception
	set Response=##class(web.DHCENS.STBLL.OPERATION.Model.Response).%New()
	set header=##class(web.DHCENS.STBLL.OPERATION.Model.Header).%New()
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.SourceSystem="02"
	set Response.header=header
	set responseBody=##class(web.DHCENS.STBLL.OPERATION.Model.Respbody).%New()
	set responseBody.ResultCode="-1"
	set responseBody.ResultContent=$ze
	set Response.Respbody=responseBody
    d Response.XMLExportToStream(.stream)
    q stream
}

/// Description:离开手术室
ClassMethod LeaveOperationRoom(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set $zt="Exception"
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(Input,.tDocument)
	d Input.Rewind()
	set Response=##class(web.DHCENS.STBLL.OPERATION.Model.Response).%New()
	set header=##class(web.DHCENS.STBLL.OPERATION.Model.Header).%New()
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.SourceSystem="02"
	set Response.header=header
	set responseBody=##class(web.DHCENS.STBLL.OPERATION.Model.Respbody).%New()
	if $$$ISERR(tSC) {
		set responseBody.ResultCode="-1"
		set responseBody.ResultContent=tSC
		set Response.Respbody=responseBody
	}else{
		set (PAADMVisitNumber,OPERApplicationNum,LeaveOperationRoomDateTime)=""
		set HosCode="DHSZHYYZY"	
		set tSC=tDocument.EvaluateExpression("/Request/Body/EnterOperationRoomRt/PAADMVisitNumber","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
			set fieldValue=tRes.GetAt(1).Value
			set PAADMVisitNumber=$tr(fieldValue,$c(0),"")
		}		
		set tSC=tDocument.EvaluateExpression("/Request/Body/EnterOperationRoomRt/OPERApplicationNum","text()",.tRes)	
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set OPERApplicationNum=$tr(fieldValue,$c(0),"")
		}	
		set tSC=tDocument.EvaluateExpression("/Request/Body/EnterOperationRoomRt/LeaveOperationRoomDateTime","text()",.tRes)	
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set LeaveOperationRoomDateTime=$tr(fieldValue,$c(0),"")
		}
		set OpaID=##class(CIS.AN.SRV.OperService).GetOpaIdByOpsId(OPERApplicationNum)
		///	set dataTimeStr="入手术科室日期^入手术科室时间^离手术科室日期^离手术科室时间^入手术间日期^时间^离手术间日期^时间^麻醉开始日期^时间^麻醉结束日期^时间^手术开始日期^时间^手术结束日期^时间^气管插管日期^时间^气管拔管日期^时间^入PACU日期^时间^离PACU日期^时间^离手术室去向"
		set dataTimeStr="^^"_$p(LeaveOperationRoomDateTime," ",1)_"^"_$p(LeaveOperationRoomDateTime," ",2)_"^^^^^^^^^^^^^^^^^^^^^^^^"
		set tSC=##class(CIS.AN.SRV.OperService).SaveKeyEventTime(OpaID,dataTimeStr)
		if tSC="0" {
			set responseBody.ResultCode="0"
			set responseBody.ResultContent="成功"
		}
		else {
			set responseBody.ResultCode="-1"
			set responseBody.ResultContent=tSC
		}	
		s Response.Respbody=responseBody	
	}   
    
    d Response.XMLExportToStream(.stream)
    q stream
    
Exception
	set Response=##class(web.DHCENS.STBLL.OPERATION.Model.Response).%New()
	set header=##class(web.DHCENS.STBLL.OPERATION.Model.Header).%New()
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.SourceSystem="02"
	set Response.header=header
	set responseBody=##class(web.DHCENS.STBLL.OPERATION.Model.Respbody).%New()
	set responseBody.ResultCode="-1"
	set responseBody.ResultContent=$ze
	set Response.Respbody=responseBody
    d Response.XMLExportToStream(.stream)
    q stream
}

/// Description:入恢复室
ClassMethod EnterRecoveryRoom(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set $zt="Exception"
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(Input,.tDocument)
	d Input.Rewind()
	set Response=##class(web.DHCENS.STBLL.OPERATION.Model.Response).%New()
	set header=##class(web.DHCENS.STBLL.OPERATION.Model.Header).%New()
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.SourceSystem="02"
	set Response.header=header
	set responseBody=##class(web.DHCENS.STBLL.OPERATION.Model.Respbody).%New()
	if $$$ISERR(tSC) {
		set responseBody.ResultCode="-1"
		set responseBody.ResultContent=tSC
		set Response.Respbody=responseBody
	}else{
		set (PAADMVisitNumber,OPERApplicationNum,EnterRecoveryRoomDateTime)=""
		set HosCode="DHSZHYYZY"	
		set tSC=tDocument.EvaluateExpression("/Request/Body/EnterOperationRoomRt/PAADMVisitNumber","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
			set fieldValue=tRes.GetAt(1).Value
			set PAADMVisitNumber=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/EnterOperationRoomRt/OPERApplicationNum","text()",.tRes)	
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set OPERApplicationNum=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/EnterOperationRoomRt/EnterRecoveryRoomDateTime","text()",.tRes)	
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set EnterRecoveryRoomDateTime=$tr(fieldValue,$c(0),"")
		}
		set OpaID=##class(CIS.AN.SRV.OperService).GetOpaIdByOpsId(OPERApplicationNum)
		///	set dataTimeStr="入手术科室日期^入手术科室时间^离手术科室日期^离手术科室时间^入手术间日期^时间^离手术间日期^时间^麻醉开始日期^时间^麻醉结束日期^时间^手术开始日期^时间^手术结束日期^时间^气管插管日期^时间^气管拔管日期^时间^入PACU日期^时间^离PACU日期^时间^离手术室去向"
		set dataTimeStr="^^^^^^^^^^^^^^^^^^^^"_$p(EnterRecoveryRoomDateTime," ",1)_"^"_$p(EnterRecoveryRoomDateTime," ",2)_"^^^^^^"
		set tSC=##class(CIS.AN.SRV.OperService).SaveKeyEventTime(OpaID,dataTimeStr)
		if tSC="0" {
			set responseBody.ResultCode="0"
			set responseBody.ResultContent="成功"
		}
		else {
			set responseBody.ResultCode="-1"
			set responseBody.ResultContent=tSC
		}	
		s Response.Respbody=responseBody	
	}   
    
    d Response.XMLExportToStream(.stream)
    q stream
    
Exception
	set Response=##class(web.DHCENS.STBLL.OPERATION.Model.Response).%New()
	set header=##class(web.DHCENS.STBLL.OPERATION.Model.Header).%New()
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.SourceSystem="02"
	set Response.header=header
	set responseBody=##class(web.DHCENS.STBLL.OPERATION.Model.Respbody).%New()
	set responseBody.ResultCode="-1"
	set responseBody.ResultContent=$ze
	set Response.Respbody=responseBody
    d Response.XMLExportToStream(.stream)
    q stream
}

/// Description:离开恢复室
ClassMethod LeaveRecoveryRoom(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set $zt="Exception"	
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(Input,.tDocument)
	d Input.Rewind()
	set Response=##class(web.DHCENS.STBLL.OPERATION.Model.Response).%New()
	set header=##class(web.DHCENS.STBLL.OPERATION.Model.Header).%New()
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.SourceSystem="02"
	set Response.header=header
	set responseBody=##class(web.DHCENS.STBLL.OPERATION.Model.Respbody).%New()
	if $$$ISERR(tSC) {
		set responseBody.ResultCode="-1"
		set responseBody.ResultContent=tSC
		set Response.Respbody=responseBody
	}else{
		set (PAADMVisitNumber,OPERApplicationNum,LeaveRecoveryRoomDateTime)=""
		set HosCode="DHSZHYYZY"	
		set tSC=tDocument.EvaluateExpression("/Request/Body/EnterOperationRoomRt/PAADMVisitNumber","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
			set fieldValue=tRes.GetAt(1).Value
			set PAADMVisitNumber=$tr(fieldValue,$c(0),"")
		}		
		set tSC=tDocument.EvaluateExpression("/Request/Body/EnterOperationRoomRt/OPERApplicationNum","text()",.tRes)	
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set OPERApplicationNum=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/EnterOperationRoomRt/LeaveRecoveryRoomDateTime","text()",.tRes)	
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set LeaveRecoveryRoomDateTime=$tr(fieldValue,$c(0),"")
		}
		set OpaID=##class(CIS.AN.SRV.OperService).GetOpaIdByOpsId(OPERApplicationNum)
		///	set dataTimeStr="入手术科室日期^入手术科室时间^离手术科室日期^离手术科室时间^入手术间日期^时间^离手术间日期^时间^麻醉开始日期^时间^麻醉结束日期^时间^手术开始日期^时间^手术结束日期^时间^气管插管日期^时间^气管拔管日期^时间^入PACU日期^时间^离PACU日期^时间^离手术室去向"
		set dataTimeStr="^^^^^^^^^^^^^^^^^^^^^^"_$p(LeaveRecoveryRoomDateTime," ",1)_"^"_$p(LeaveRecoveryRoomDateTime," ",2)_"^^^^"
		set tSC=##class(CIS.AN.SRV.OperService).SaveKeyEventTime(OpaID,dataTimeStr)
		if tSC="0" {
			set responseBody.ResultCode="0"
			set responseBody.ResultContent="成功"
		}
		else {
			set responseBody.ResultCode="-1"
			set responseBody.ResultContent=tSC
		}	
		s Response.Respbody=responseBody		
	}   
    
    d Response.XMLExportToStream(.stream)
    q stream
    
Exception
	set Response=##class(web.DHCENS.STBLL.OPERATION.Model.Response).%New()
	set header=##class(web.DHCENS.STBLL.OPERATION.Model.Header).%New()
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.SourceSystem="02"
	set Response.header=header
	set responseBody=##class(web.DHCENS.STBLL.OPERATION.Model.Respbody).%New()
	set responseBody.ResultCode="-1"
	set responseBody.ResultContent=$ze
	set Response.Respbody=responseBody
    d Response.XMLExportToStream(.stream)
    q stream
}

/// Creator：lipan
/// CreatDate：2016—06-29
/// Description：入手术间
/// Table：
/// Input：01：进手术室 02：进手术间 03：麻醉开始 04：麻醉结束 05：出手术间 06：出手术室
///        07：入恢复室 08：出恢复室 09：三方核对开始 10:其他 11：手术开始  12：手术结束
/// Return：
/// Others: 
/// w ##class(web.DHCENS.STBLL.OPERATION.Method.OperationTimeline).EnterOperationTheatre()
ClassMethod EnterOperationTheatre(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set $zt="Exception"
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(Input,.tDocument)
	d Input.Rewind()
	set Response=##class(web.DHCENS.STBLL.OPERATION.Model.Response).%New()
	set header=##class(web.DHCENS.STBLL.OPERATION.Model.Header).%New()
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.SourceSystem="02"
	set Response.header=header
	set responseBody=##class(web.DHCENS.STBLL.OPERATION.Model.Respbody).%New()
	if $$$ISERR(tSC) {
		set responseBody.ResultCode="-1"
		set responseBody.ResultContent=tSC
		set Response.Respbody=responseBody
	}else{
		set (PAADMVisitNumber,OPERApplicationNum,EnterDateTime)=""
		set HosCode="DHSZHYYZY"	
		set tSC=tDocument.EvaluateExpression("/Request/Body/EnterOperationRoomRt/PAADMVisitNumber","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
			set fieldValue=tRes.GetAt(1).Value
			set PAADMVisitNumber=$tr(fieldValue,$c(0),"")
		}		
		set tSC=tDocument.EvaluateExpression("/Request/Body/EnterOperationRoomRt/OPERApplicationNum","text()",.tRes)	
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set OPERApplicationNum=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/EnterOperationRoomRt/EnterOperationTheatreDateTime","text()",.tRes)	
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set EnterDateTime=$tr(fieldValue,$c(0),"")
		}		
		set OpaID=##class(CIS.AN.SRV.OperService).GetOpaIdByOpsId(OPERApplicationNum)
		///	set dataTimeStr="入手术科室日期^入手术科室时间^离手术科室日期^离手术科室时间^入手术间日期^时间^离手术间日期^时间^麻醉开始日期^时间^麻醉结束日期^时间^手术开始日期^时间^手术结束日期^时间^气管插管日期^时间^气管拔管日期^时间^入PACU日期^时间^离PACU日期^时间^离手术室去向"
		set dataTimeStr="^^^^"_$p(EnterDateTime," ",1)_"^"_$p(EnterDateTime," ",2)_"^^^^^^^^^^^^^^^^^^^^^^"
		set tSC=##class(CIS.AN.SRV.OperService).SaveKeyEventTime(OpaID,dataTimeStr)
		if tSC="0" {
			set responseBody.ResultCode="0"
			set responseBody.ResultContent="成功"
		}
		else {
			set responseBody.ResultCode="-1"
			set responseBody.ResultContent=tSC
		}
		set Response.Respbody=responseBody
	}   
    
    d Response.XMLExportToStream(.stream)
    q stream
    
Exception
	set Response=##class(web.DHCENS.STBLL.OPERATION.Model.Response).%New()
	set header=##class(web.DHCENS.STBLL.OPERATION.Model.Header).%New()
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.SourceSystem="02"
	set Response.header=header
	set responseBody=##class(web.DHCENS.STBLL.OPERATION.Model.Respbody).%New()
	set responseBody.ResultCode="-1"
	set responseBody.ResultContent=$ze
	set Response.Respbody=responseBody
    d Response.XMLExportToStream(.stream)
    q stream
}

/// Creator：lipan
/// CreatDate：2016—06-29
/// Description：出手术间
/// Table：
/// Input：01：进手术室 02：进手术间 03：麻醉开始 04：麻醉结束 05：出手术间 06：出手术室
///        07：入恢复室 08：出恢复室 09：三方核对开始 10:其他 11：手术开始  12：手术结束
/// Return：
/// Others: 
/// w ##class(web.DHCENS.STBLL.OPERATION.Method.OperationTimeline).LeaveOperationTheatre()
ClassMethod LeaveOperationTheatre(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set $zt="Exception"
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(Input,.tDocument)
	d Input.Rewind()
	set Response=##class(web.DHCENS.STBLL.OPERATION.Model.Response).%New()
	set header=##class(web.DHCENS.STBLL.OPERATION.Model.Header).%New()
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.SourceSystem="02"
	set Response.header=header
	set responseBody=##class(web.DHCENS.STBLL.OPERATION.Model.Respbody).%New()
	if $$$ISERR(tSC) {
		set responseBody.ResultCode="-1"
		set responseBody.ResultContent=tSC
		set Response.Respbody=responseBody
	}else{
		set (PAADMVisitNumber,OPERApplicationNum,LeaveOperationRoomDateTime)=""
		set HosCode="DHSZHYYZY"	
		set tSC=tDocument.EvaluateExpression("/Request/Body/EnterOperationRoomRt/PAADMVisitNumber","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
			set fieldValue=tRes.GetAt(1).Value
			set PAADMVisitNumber=$tr(fieldValue,$c(0),"")
		}		
		set tSC=tDocument.EvaluateExpression("/Request/Body/EnterOperationRoomRt/OPERApplicationNum","text()",.tRes)	
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set OPERApplicationNum=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/EnterOperationRoomRt/LeaveOperationTheatreDateTime","text()",.tRes)	
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set LeaveOperationTheatreDateTime=$tr(fieldValue,$c(0),"")
		}		
		set OpaID=##class(CIS.AN.SRV.OperService).GetOpaIdByOpsId(OPERApplicationNum)
		///	set dataTimeStr="入手术科室日期^入手术科室时间^离手术科室日期^离手术科室时间^入手术间日期^时间^离手术间日期^时间^麻醉开始日期^时间^麻醉结束日期^时间^手术开始日期^时间^手术结束日期^时间^气管插管日期^时间^气管拔管日期^时间^入PACU日期^时间^离PACU日期^时间^离手术室去向"
		set dataTimeStr="^^^^^^"_$p(LeaveOperationTheatreDateTime," ",1)_"^"_$p(LeaveOperationTheatreDateTime," ",2)_"^^^^^^^^^^^^^^^^^^^^^^"
		set tSC=##class(CIS.AN.SRV.OperService).SaveKeyEventTime(OpaID,dataTimeStr)
		if tSC="0" {
			set responseBody.ResultCode="0"
			set responseBody.ResultContent="成功"
		}
		else {
			set responseBody.ResultCode="-1"
			set responseBody.ResultContent=tSC
		}
		set Response.Respbody=responseBody
	}   
    
    d Response.XMLExportToStream(.stream)
    q stream
    
Exception
	set Response=##class(web.DHCENS.STBLL.OPERATION.Model.Response).%New()
	set header=##class(web.DHCENS.STBLL.OPERATION.Model.Header).%New()
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.SourceSystem="02"
	set Response.header=header
	set responseBody=##class(web.DHCENS.STBLL.OPERATION.Model.Respbody).%New()
	set responseBody.ResultCode="-1"
	set responseBody.ResultContent=$ze
	set Response.Respbody=responseBody
    d Response.XMLExportToStream(.stream)
    q stream
}

}
