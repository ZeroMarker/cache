Class web.DHCENS.STBLL.ORDER.METHOD.OrderExecuteInfo Extends (%RegisteredObject, %XML.Adaptor)
{

/// 302192||585||1^302192||584||1^302192||586||1,Y
/// 领药审核(静配用)
/// w ##class(web.DHCENS.STBLL.ORDER.METHOD.OrderExecuteInfo).GetOrderExeInfo("2715071||36||1").Read()
ClassMethod GetOrderExeInfo(Input As %String) As %GlobalCharacterStream
{
	set $zt="Exception"
	s Counter=0
	set request=##class(web.DHCENS.STBLL.ORDER.MODEL.Request).%New()
	set header=##class(web.DHCENS.STBLL.ORDER.MODEL.Header).%New()
	set header.SourceSystem="02"
	set MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.MessageID=MessageID
	set request.header=header
	set body=##class(web.DHCENS.STBLL.ORDER.MODEL.Body).%New()
	set OrderExecuteInfoRtObj=##class(web.DHCENS.STBLL.ORDER.MODEL.OrderExecuteInfoRt).%New()

	set ExeOrdRowidStr=Input
	set OrderRowid=$p(ExeOrdRowidStr,"||")
	set AdmRowid=$p(^OEORD(OrderRowid),"^",1)
	
	set OrderExecuteInfoRtObj.PAADMVisitNumber=AdmRowid
	set patRowId=$p($g(^PAADM(AdmRowid)),"^",1)
	set OrderExecuteInfoRtObj.PATPatientID=$p($g(^PAPER(patRowId,"PAT",1)),"^",1)
	set length=$l(ExeOrdRowidStr,"^")
	for i=1:1:length {
		set rowId=$p(ExeOrdRowidStr,"^",i)
		set ordExeItemObj=##class(web.DHCENS.STBLL.ORDER.MODEL.ordExeItem).%New()
		//s DspRowid=$o(^DHCOEDISQTY(0,"OEORE",rowId,""))
	    //continue:DspRowid=""
	    //s DspStatus=$p(^DHCOEDISQTY(DspRowid),"^",7)
	    //continue:DspStatus'="C"
		set ordExeItemObj=..ExeOrdItem(rowId)
		d OrderExecuteInfoRtObj.ordExeItems.Insert(ordExeItemObj)
		s Counter=Counter+1
	}
	if Counter=0 {
		s stream=##class(%GlobalCharacterStream).%New()
		d stream.Write("<Request><Header><SourceSystem>02</SourceSystem><MessageID>252017</MessageID></Header><Body><OrderExecuteInfoRt><PATPatientID></PATPatientID><PAADMVisitNumber></PAADMVisitNumber><OEORIInfoList><OEORIInfo><OEORIOrderItemID></OEORIOrderItemID><OrderDispDrugQuantity></OrderDispDrugQuantity><OrderDispDrugUnit></OrderDispDrugUnit><OrderExecuteID></OrderExecuteID><OrderExecuteStatus/><OrderRequredExDate></OrderRequredExDate><OrderRequredExTime></OrderRequredExTime><OrderExUserCode></OrderExUserCode><UpdateUserCode></UpdateUserCode><UpdateDate></UpdateDate><UpdateTime></UpdateTime><IsDrugAudit></IsDrugAudit><RecDeptCode></RecDeptCode></OEORIInfo></OEORIInfoList></OrderExecuteInfoRt></Body></Request>")
		q stream
	}
	s body.OrderExecuteInfoRt=OrderExecuteInfoRtObj
	s request.body=body
	d request.XMLExportToStream(.stream)
	q stream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

ClassMethod ExeOrdItem(ExeOrdRowid As %String) As web.DHCENS.STBLL.ORDER.MODEL.ordExeItem
{
	s obj=##class(web.DHCENS.STBLL.ORDER.MODEL.ordExeItem).%New()
	s OrderRowid=$p(ExeOrdRowid,"||",1)
	s OrderSubid=$p(ExeOrdRowid,"||",2)
	s ChildSubid=$p(ExeOrdRowid,"||",3)
	
	s ExeOrdInfo=$g(^OEORD(OrderRowid,"I",OrderSubid,"X",ChildSubid))
	s obj.OEORIOrderItemID=$p(ExeOrdRowid,"||",1,2)
	s DspRowid=$o(^DHCOEDISQTY(0,"OEORE",ExeOrdRowid,""))
	if DspRowid'="" {
		s obj.OrderDispDrugQuantity=$p(^DHCOEDISQTY(DspRowid),"^",5)
		s dosageUnitRowID = $p(^DHCOEDISQTY(DspRowid),"^",6)
		s:((dosageUnitRowID'="")&&(dosageUnitRowID'=0)) obj.OrderDispDrugUnit=$p($g(^CT("UOM",dosageUnitRowID)),"^",2)
	}
	s obj.OrderExecuteID=ExeOrdRowid
	
	s OeExeStatus=$p(ExeOrdInfo,"^",16)
	if OeExeStatus'="" {
		s OrderExecuteStatus=$p(^OEC("STAT",OeExeStatus),"^",1)
		if OrderExecuteStatus="F" {
			s obj.OrderExecuteStatus=1
		}
		else{
			s obj.OrderExecuteStatus=0
		} 
	}
	
	s obj.OrderRequredExDate=$zd($p(ExeOrdInfo,"^",1),3)
	s obj.OrderRequredExTime=$zt($p(ExeOrdInfo,"^",2))
	s docRowID=$p(ExeOrdInfo,"^",15)
	if docRowID'="" {
		set userId=$o(^SSU("SSUSR",0,"CTPCP",docRowID,""))	
		if userId'="" {
			set obj.OrderExUserCode=$p($g(^SSU("SSUSR",userId)),"^",1)
			s obj.UpdateUserCode=obj.OrderExUserCode
		}	
	}
	s obj.UpdateDate=$ZD(+$H,3)
	s obj.UpdateTime=$ZT($P($H,",",2))
	
	//lyh 20161224 停止执行记录消息增加“接收科室”
	set recDeptRowID = $p($g(^OEORD(OrderRowid,"I",OrderSubid,3)),"^",6)
	set:recDeptRowID'="" obj.RecDeptCode=$p($g(^CTLOC(recDeptRowID)),"^",1)
	q obj
}

/// Creator:lipan
/// Date:
/// Desc:获取护士执行医嘱信息
/// w ##class(web.DHCENS.STBLL.ORDER.METHOD.OrderExecuteInfo).GetNurExeInfo("747191||10||1").Read()
ClassMethod GetNurExeInfo(Input As %String) As %GlobalCharacterStream
{
	set $zt="Exception"
	s Counter=0
	set request=##class(web.DHCENS.STBLL.ORDER.MODEL.Request).%New()
	set header=##class(web.DHCENS.STBLL.ORDER.MODEL.Header).%New()
	set header.SourceSystem="02"
	set MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.MessageID=MessageID
	set request.header=header
	set body=##class(web.DHCENS.STBLL.ORDER.MODEL.Body).%New()
	set OrderExecuteInfoRtObj=##class(web.DHCENS.STBLL.ORDER.MODEL.OrderExecuteInfoRt).%New()

	set ExeOrdRowidStr=Input
	set OrderRowid=$p(ExeOrdRowidStr,"||")
	set AdmRowid=$p(^OEORD(OrderRowid),"^",1)
	
	set OrderExecuteInfoRtObj.PAADMVisitNumber=AdmRowid
	set patRowId=$p($g(^PAADM(AdmRowid)),"^",1)
	set OrderExecuteInfoRtObj.PATPatientID=$p($g(^PAPER(patRowId,"PAT",1)),"^",1)
	set length=$l(ExeOrdRowidStr,"^")
	for i=1:1:length {
		set rowId=$p(ExeOrdRowidStr,"^",i)
		set NurExeOrdObj=##class(web.DHCENS.STBLL.ORDER.MODEL.NurExeOrd).%New()
		set NurExeOrdObj=..NurExeOrdItem(rowId)
		d OrderExecuteInfoRtObj.NurExeOrds.Insert(NurExeOrdObj)
	}
	s body.OrderExecuteInfoRt=OrderExecuteInfoRtObj
	s request.body=body
	d request.XMLExportToStream(.stream)
	q stream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

ClassMethod NurExeOrdItem(ExeOrdRowid As %String) As web.DHCENS.STBLL.ORDER.MODEL.NurExeOrd
{
	s obj=##class(web.DHCENS.STBLL.ORDER.MODEL.NurExeOrd).%New()
	s OrderRowid=$p(ExeOrdRowid,"||",1)
	s OrderSubid=$p(ExeOrdRowid,"||",2)
	s ChildSubid=$p(ExeOrdRowid,"||",3)
	s ExStDate=$p($g(^OEORD(OrderRowid,"I",OrderSubid,"X",ChildSubid)),"^",1) 
	s ExStTime=$p($g(^OEORD(OrderRowid,"I",OrderSubid,"X",ChildSubid)),"^",2)
	s ExStDateTime=""
	s:ExStDate'="" ExStDate=$zd(ExStDate,3) 
	s:ExStTime'="" ExStTime=$zt(ExStTime,1) 
	s:ExStDate'="" ExStDateTime=ExStDate_" "_ExStTime
	
	s ExeOEORDateTime="",ExeOEORUserCode="",ExeOEORStatusCode=""
	s ExeOEORStatusId=$p($g(^OEORD(OrderRowid,"I",OrderSubid,"X",ChildSubid)),"^",16)
	
	s:ExeOEORStatusId'="" ExeOEORStatusCode=$p($g(^OEC("STAT",ExeOEORStatusId)),"^",1)
	if ExeOEORStatusCode="F" {
		s docRowID=$p($g(^OEORD(OrderRowid,"I",OrderSubid,"X",ChildSubid)),"^",15)
		set userId=$o(^SSU("SSUSR",0,"CTPCP",docRowID,""))	
		s:userId'="" ExeOEORUserCode=$p($g(^SSU("SSUSR",userId)),"^",1) 
		s ExeOEORDate=$p($g(^OEORD(OrderRowid,"I",OrderSubid,"X",ChildSubid)),"^",19)
		s ExeOEORTime=$p($g(^OEORD(OrderRowid,"I",OrderSubid,"X",ChildSubid)),"^",20)
		s:ExeOEORDate'="" ExeOEORDate=$zd(ExeOEORDate,3) 
		s:ExeOEORTime'="" ExeOEORTime=$zt(ExeOEORTime,1)
		s:ExeOEORDate'="" ExeOEORDateTime=ExeOEORDate_" "_ExeOEORTime 
	}
	s obj.ExStDateTime=ExStDateTime
	s obj.ExeOEORItemID=ExeOrdRowid
	s obj.ExeOEORUserCode=ExeOEORUserCode
	s obj.ExeOEORDateTime=ExeOEORDateTime
	q obj
}

/// Creator:lipan
/// CreatDate:2017-07-23
/// Desc:保存护士执行(撤销执行)医嘱信息
ClassMethod SaveNurExeInfo(Input As %GlobalCharacterStream) As %GlobalCharacterStream
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
		set SourceSystem=""
		set HosCode="DHSZHYYZY"			
		set tSC=tDocument.EvaluateExpression("/Request/Header/SourceSystem","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
			set fieldValue=tRes.GetAt(1).Value
			set SourceSystem=$tr(fieldValue,$c(0),"")
			set SourceSystem=$tr(fieldValue,$c(10),"")
		}			
		set tSC=tDocument.EvaluateExpression("/Request/Body/OrderExecuteInfoRt/NurExeOrdList","count(NurExeOrd)",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			set hsCount=tRes.GetAt(1).Value
			Quit:hsCount="0" "-1^信息为空"
			set (ExeOEORSkinTest,ExeOEORItemID,ExeOEORStatusCode,ExeOEORUserCode,ExeOEORUserDeptCode,ExeOEORQueryTypeCode,ExeOEORDate,ExeOEORTime)=""
			for i=1:1:hsCount {
				set tSC=tDocument.EvaluateExpression("/Request/Body/OrderExecuteInfoRt/NurExeOrdList/NurExeOrd["_i_"]/ExeOEORSkinTest","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set ExeOEORSkinTest=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/OrderExecuteInfoRt/NurExeOrdList/NurExeOrd["_i_"]/ExeOEORItemID","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set ExeOEORItemID=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/OrderExecuteInfoRt/NurExeOrdList/NurExeOrd["_i_"]/ExeOEORStatusCode","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set ExeOEORStatusCode=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/OrderExecuteInfoRt/NurExeOrdList/NurExeOrd["_i_"]/ExeOEORUserCode","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set ExeOEORUserCode=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/OrderExecuteInfoRt/NurExeOrdList/NurExeOrd["_i_"]/ExeOEORUserDeptCode","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set ExeOEORUserDeptCode=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/OrderExecuteInfoRt/NurExeOrdList/NurExeOrd["_i_"]/ExeOEORQueryTypeCode","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set ExeOEORQueryTypeCode=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/OrderExecuteInfoRt/NurExeOrdList/NurExeOrd["_i_"]/ExeOEORDate","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set ExeOEORDate=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/OrderExecuteInfoRt/NurExeOrdList/NurExeOrd["_i_"]/ExeOEORTime","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set ExeOEORTime=$tr(fieldValue,$c(0),"")
				}
				
				set:ExeOEORDate'="" ExeOEORDate=$zdh(ExeOEORDate,3)
				set:ExeOEORDate'="" ExeOEORDate=$zd(ExeOEORDate,4)
				set ExeOEORUserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(ExeOEORUserCode),""))
				set ExeOEORUserDeptID=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(ExeOEORUserDeptCode),""))
				set ExecFlag=##class(web.DHCLCNUREXCUTE).UpdateOrdGroup("",ExeOEORItemID,ExeOEORStatusCode,ExeOEORUserID,ExeOEORUserDeptID,"",ExeOEORDate,ExeOEORTime,"")
				if ((ExecFlag'="0")&&(ExecFlag'=-303)){
					set:InvalidStr'="" InvalidStr=InvalidStr_";医嘱"_ExeOEORItemID_":"_ExecFlag
					set:InvalidStr="" InvalidStr="医嘱"_ExeOEORItemID_":"_ExecFlag
				}
			}
			if (InvalidStr=""){
				s responseBody.ResultCode="0"
				s responseBody.ResultContent="成功"					
			}
			else {
			    s responseBody.ResultCode="-1"
				s responseBody.ResultContent=InvalidStr
			}
		}
		else {
		    s responseBody.ResultCode="-1"
			s responseBody.ResultContent="XML信息有误"
		}		
		s Response.Respbody=responseBody
	}       
    d Response.XMLExportToStream(.stream)
    q stream
    
Exception
	set Response=##class(web.DHCENS.STBLL.ORDER.MODEL.Response).%New()
	set header=##class(web.DHCENS.STBLL.ORDER.MODEL.Header).%New()
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.SourceSystem="02"
	set Response.header=header
	set responseBody=##class(web.DHCENS.STBLL.ORDER.MODEL.Respbody).%New()
	set responseBody.ResultCode="-1"
	set responseBody.ResultContent=$ze	
	set Response.Respbody=responseBody
    d Response.XMLExportToStream(.stream)
    q stream
}

}
