Class web.DHCENS.STBLL.LIS.METHOD.OEOrderStatus Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：lipan
/// CreatDate：2016—06-18
/// Description：接收标本
/// w ##class(web.DHCENS.STBLL.LIS.METHOD.OEOrderStatus).ExecuteStatus("")
ClassMethod ExecuteStatus(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set $zt="Exception"
	set suCount=0,faCount=0,faInfo=""
	ts
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(Input,.tDocument)
	set Response=##class(web.DHCENS.STBLL.LIS.MODEL.Response).%New()
	set header=##class(web.DHCENS.STBLL.LIS.MODEL.Header).%New()
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.SourceSystem="02"
	set Response.header=header
	set responseBody=##class(web.DHCENS.STBLL.LIS.MODEL.Respbody).%New()
	if $$$ISERR(tSC) {
		set responseBody.ResultCode="-1"
		set responseBody.ResultContent=tSC
		set Response.Respbody=responseBody
	}else{
		set (SpecimenID,ChargeCode,ChargeCount)=""
		set tSC=tDocument.EvaluateExpression("/Request/Body/SpecimenReceiveRt/SpecimenID","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set SpecimenID=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/SpecimenReceiveRt/ChargeInfos/ChargeInfo/ChargeCode","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set ChargeCode=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/SpecimenReceiveRt/ChargeInfos/ChargeInfo/ChargeCount","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set ChargeCount=$tr(fieldValue,$c(0),"")
		}
		s AmountInput=""
		set tSC=tDocument.EvaluateExpression("/Request/Body/SpecimenReceiveRt/OEORIOrderItemIDs","count(OEORIOrderItemID)",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			set hsCount=tRes.GetAt(1).Value
			Quit:hsCount="0" "-1^信息为空"
			s OrdRowIds=""
			for i=1:1:hsCount {
				set (ExecUserCode,ExecUserDesc,SpeciReceiveDate,SpeciReceiveTime,OrderItemID)=""
				set HosCode="DHSZHYYZY"	
				set tSC=tDocument.EvaluateExpression("/Request/Body/SpecimenReceiveRt/OEORIOrderItemIDs/OEORIOrderItemID["_i_"]","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set OrderItemID=$tr(fieldValue,$c(0),"")
					
					if OrdRowIds'=""{
						set OrdRowIds=OrdRowIds_"^"_OrderItemID
					}
					else {
							set OrdRowIds=OrderItemID
					}
				}
			}
				
			set tSC=tDocument.EvaluateExpression("/Request/Body/SpecimenReceiveRt/ExecUserCode","text()",.tRes)					
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
				set fieldValue=tRes.GetAt(1).Value
				set ExecUserCode=$tr(fieldValue,$c(0),"")
				set ExeUserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(ExecUserCode),""))
				set:ExeUserID'="" ExecUserDesc=$p($g(^SSU("SSUSR",ExeUserID)),"^",2)
			}
			set tSC=tDocument.EvaluateExpression("/Request/Body/SpecimenReceiveRt/SpeciReceiveDate","text()",.tRes)					
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
				set fieldValue=tRes.GetAt(1).Value
				set SpeciReceiveDate=$tr(fieldValue,$c(0),"")
			}
				
			set tSC=tDocument.EvaluateExpression("/Request/Body/SpecimenReceiveRt/SpeciReceiveTime","text()",.tRes)					
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
				set fieldValue=tRes.GetAt(1).Value
				set SpeciReceiveTime=$tr(fieldValue,$c(0),"")
			}
			
			set OrdRowIdsCount=$l(OrdRowIds,"^")
			set OrdFlag="",ErrorOrd=""
			
			for iOrd=1:1:OrdRowIdsCount
			{
				set OrderItemID=$p(OrdRowIds,"^",iOrd)
				set tmpInput=OrderItemID_"^"_SpecimenID_"^^"_ExecUserCode_"@"_ExecUserDesc_"^"_SpeciReceiveDate_"^"_SpeciReceiveTime				
				set AdmNo=$p(^OEORD(+OrderItemID),"^",1)
				set AdmType=$p($g(^PAADM(AdmNo)),"^",2)
				set OrdBillStatus=$p($g(^OEORD(+OrderItemID,"I",$p(OrderItemID,"||",2),3)),"^",5)
				set BillResult="0^成功^计费状态没问题"
				if ((AdmType'="I")&&(OrdBillStatus'="P")) set BillResult="-1^就诊状态为："_AdmType_"，计费状态为："_OrdBillStatus_"，医嘱号为："_OrderItemID_"不允许登记"
				set ExecFlag="" 
				if (($p(BillResult,"^",1)=0)&&(OrderItemID'="")&&(ExeUserID'="")){
					set ExecFlag=##class(appcom.OEOrdItem).Execute(OrderItemID,ExeUserID)
					set UpdateDateTime=SpeciReceiveDate_" "_SpeciReceiveTime
					set Position=""
					set Status="RECEIVE"
					set SourceSystem="LIS"
					set jsonstr="[{""OEOrdItemID"":"""_OrderItemID_""","_"""Position"":"""_Position_""","_"""ExamID"":"""_SpecimenID_""","_"""Status"":"""_Status_""","_"""UserID"":"""_ExecUserCode_""","_"""UserName"":"""_ExecUserDesc_""","_"""UpDateTime"":"""_UpdateDateTime_""","_"""SourceSystem"":"""_SourceSystem_""""_"}]"
					set jsonStream=##class(%GlobalCharacterStream).%New()
					d jsonStream.Write(jsonstr)
					set tSC=##class(%GlobalCharacterStream).%New()
					set tSC=##class(web.DHCENS.EnsHISService).DHCHisInterface("UpdateSystemStatus",jsonStream)
					set tSCStr=tSC.Read()
				}
				if (tSCStr'["成功")||(ExecFlag'=0)
				{
					set OrdFlag="-1"
					if ErrorOrd=""  set ErrorOrd=OrderItemID_":"_tSCStr_":"_ExecFlag
					else  set ErrorOrd=ErrorOrd_"^"_OrderItemID_":"_tSCStr_":"_ExecFlag
					q
				}
				else{
					set OrdFlag="0"
				}
		}		
		if ((ChargeCode'="")&&(ChargeCount'="")&&(ExecFlag=0)){
			if (AmountInput=""){
				s AmountInput=ChargeCode_"+"_OrdRowIds_"+"_ChargeCount
			}
			else {
				s AmountInput=AmountInput_"###"_ChargeCode_"+"_OrdRowIds_"+"_ChargeCount
			}
			if AmountInput="" {
				s responseBody.ResultCode="-1"
				s responseBody.ResultContent="试管数量为0"
				s RepObj.Respbody=responseBody
				d RepObj.XMLExportToStream(.stream)
				Quit stream
			}
			set Result=..AddTubeOrdItem(AmountInput)
			if $p(Result,"^",1)=0 {
				s responseBody.ResultCode="0"
				s responseBody.ResultContent="成功"
			}
			else{
				s responseBody.ResultCode="-1"
				s responseBody.ResultContent="失败"
			}
			s Response.Respbody=responseBody
			d Response.XMLExportToStream(.stream)
			Quit stream
			
			}
		}	
	}
	if OrdFlag="0"
	{
		tc
		set responseBody.ResultCode="0"
		set responseBody.ResultContent="成功"
	}
	elseif (OrdFlag'="0")&&(OrdFlag'="")
	{	
		tro
		set responseBody.ResultCode="-1"
		set responseBody.ResultContent=ErrorOrd_"医嘱接收处理有错误"
	}
	else
	{
		tro
		set responseBody.ResultCode="-1"
		set responseBody.ResultContent=BillResult
	}
	set Response.Respbody=responseBody
	d Response.XMLExportToStream(.stream)
	Quit stream
Exception
	if $TLEVEL>0
	{
	 	tro	
	}
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// w ##class(web.DHCENS.STBLL.LIS.METHOD.OEOrderStatus).testtt()
ClassMethod testtt() As %String
{
	s string="<Request><Header><SourceSystem>SYS0006</SourceSystem><MessageID>01</MessageID></Header><Body><SpecimenRejectRt><SpecimenID>0000487600</SpecimenID><OEORIOrderItemIDs><OEORIOrderItemID>7107||3</OEORIOrderItemID></OEORIOrderItemIDs><RefuseReason>test</RefuseReason><ExecUserCode>x</ExecUserCode><ExecUserDesc>管理员</ExecUserDesc><RefuseDate>2019-10-03</RefuseDate><RefuseTime>23:03:55</RefuseTime></SpecimenRejectRt></Body></Request>"
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write(string)
	s ret=..RejectStatus(stream)
	q ret.Read()
}

/// Creator：lipan
/// CreatDate：2016—06-18
/// Description：标本拒收
/// w ##class(web.DHCENS.STBLL.LIS.METHOD.OEOrderStatus).RejectStatus("")
ClassMethod RejectStatus(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set $zt="Exception"
	set suCount=0,faCount=0,faInfo=""
	set OrdFlag="-1"
	ts
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(Input,.tDocument)
	set Response=##class(web.DHCENS.STBLL.LIS.MODEL.Response).%New()
	set header=##class(web.DHCENS.STBLL.LIS.MODEL.Header).%New()
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.SourceSystem="02"
	set Response.header=header
	set responseBody=##class(web.DHCENS.STBLL.LIS.MODEL.Respbody).%New()
	if $$$ISERR(tSC) {
		set responseBody.ResultCode="-1"
		set responseBody.ResultContent=tSC
		set Response.Respbody=responseBody
	}else{
		set SpecimenID=""
		set tSC=tDocument.EvaluateExpression("/Request/Body/SpecimenRejectRt/SpecimenID","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set SpecimenID=$tr(fieldValue,$c(0),"")
		}
		s AmountInput=""
		set tSC=tDocument.EvaluateExpression("/Request/Body/SpecimenRejectRt/OEORIOrderItemIDs","count(OEORIOrderItemID)",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			set hsCount=tRes.GetAt(1).Value
			Quit:hsCount="0" "-1^信息为空"
			s OrdRowIds=""
			for i=1:1:hsCount {
				set (ExecUserCode,ExecUserDesc,SpeciReceiveDate,SpeciReceiveTime,OrderItemID)=""
				set HosCode="DHSZHYYZY"	
				set tSC=tDocument.EvaluateExpression("/Request/Body/SpecimenRejectRt/OEORIOrderItemIDs/OEORIOrderItemID["_i_"]","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set OrderItemID=$tr(fieldValue,$c(0),"")
					
					if OrdRowIds'=""{
						set OrdRowIds=OrdRowIds_"^"_OrderItemID
					}
					else {
							set OrdRowIds=OrderItemID
					}
				}
			}
			set tSC=tDocument.EvaluateExpression("/Request/Body/SpecimenRejectRt/ExecUserCode","text()",.tRes)	
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
				set fieldValue=tRes.GetAt(1).Value
				set ExecUserCode=$tr(fieldValue,$c(0),"")
				set ExeUserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(ExecUserCode),""))
				set:ExeUserID'="" ExecUserDesc=$p($g(^SSU("SSUSR",ExeUserID)),"^",2)
			}
				
			set tSC=tDocument.EvaluateExpression("/Request/Body/SpecimenRejectRt/RefuseDate","text()",.tRes)					
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
				set fieldValue=tRes.GetAt(1).Value
				set SpeciReceiveDate=$tr(fieldValue,$c(0),"")
			}
				
			set tSC=tDocument.EvaluateExpression("/Request/Body/SpecimenRejectRt/RefuseTime","text()",.tRes)					
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
				set fieldValue=tRes.GetAt(1).Value
				set SpeciReceiveTime=$tr(fieldValue,$c(0),"")
			}
				
			s tSCStr="",NoneErr=""	
			set OrdRowIdsCount=$l(OrdRowIds,"^")
			set OrdFlag="",ErrorOrd=""
			for iOrd=1:1:OrdRowIdsCount
			{
				set OrderItemID=$p(OrdRowIds,"^",iOrd)
				set tmpInput=OrderItemID_"^"_SpecimenID_"^^"_ExecUserCode_"@"_ExecUserDesc_"^"_SpeciReceiveDate_"^"_SpeciReceiveTime
				set AdmNo=$p(^OEORD(+OrderItemID),"^",1)
				set AdmType=$p($g(^PAADM(AdmNo)),"^",2)
				set OrdBillStatus=$p($g(^OEORD(+OrderItemID,"I",$p(OrderItemID,"||",2),3)),"^",5)
				set BillResult="0^成功^计费状态没问题"
				if ((AdmType'="I")&&(OrdBillStatus'="P")) set BillResult="-1^就诊状态为："_AdmType_"，计费状态为："_OrdBillStatus_"，医嘱号为："_OrderItemID_"不允许登记"
				set ExecFlag="" 
				if ExeUserID=""
				{
					s NoneErr="人员代码在系统不存在!"
				}
				if (($p(BillResult,"^",1)=0)&&(OrderItemID'="")&&(ExeUserID'="")){
					s OrdStatusDr=$p($g(^OEORD(+OrderItemID,"I",$p(OrderItemID,"||",2),1)),"^",13)
					s OrdStatusCode=$p($g(^OEC("OSTAT",OrdStatusDr)),"^",1)
					if OrdStatusCode="E" s ExecFlag=##class(appcom.OEOrdItem).Verify(OrderItemID,ExeUserID)
					else  if OrdStatusCode="V"  s ExecFlag="0"
					set UpdateDateTime=SpeciReceiveDate_" "_SpeciReceiveTime
					set Position=""
					set Status="REJECT"
					set SourceSystem="LIS"
					set jsonstr="[{""OEOrdItemID"":"""_OrderItemID_""","_"""Position"":"""_Position_""","_"""ExamID"":"""_SpecimenID_""","_"""Status"":"""_Status_""","_"""UserID"":"""_ExecUserCode_""","_"""UserName"":"""_ExecUserDesc_""","_"""UpDateTime"":"""_UpdateDateTime_""","_"""SourceSystem"":"""_SourceSystem_""""_"}]"
					set jsonStream=##class(%GlobalCharacterStream).%New()
					d jsonStream.Write(jsonstr)
					set tSC=##class(%GlobalCharacterStream).%New()
					set tSC=##class(web.DHCENS.EnsHISService).DHCHisInterface("UpdateSystemStatus",jsonStream)
					set tSCStr=tSC.Read()
				}
				if (tSCStr'["成功")||(ExecFlag'=0)
				{
					set OrdFlag="-1"
					if ErrorOrd=""  set ErrorOrd=OrderItemID_":"_tSCStr_":"_ExecFlag
					else  set ErrorOrd=ErrorOrd_"^"_OrderItemID_":"_tSCStr_":"_ExecFlag
					q
				}
				else{
					set OrdFlag="0"
				}
			}
		}
	}
	if OrdFlag="0"
	{
		tc
		set responseBody.ResultCode="0"
		set responseBody.ResultContent="成功"
	}
	elseif (OrdFlag'="0")&&(OrdFlag'="")
	{	
		tro
		set responseBody.ResultCode="-1"
		set responseBody.ResultContent=ErrorOrd_"医嘱接收处理有错误"_","_NoneErr
	}
	else
	{
		tro
		set responseBody.ResultCode="-1"
		set responseBody.ResultContent=BillResult_","_NoneErr
	}
	set Response.Respbody=responseBody
	d Response.XMLExportToStream(.stream)
	Quit stream
Exception
	if $TLEVEL>0
	{
	 	tro	
	}
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator：lipan
/// CreatDate：2016—06-18
/// Description：踢回标本
/// w ##class(web.DHCENS.STBLL.LIS.METHOD.OEOrderStatus).SpecimenRevocation("")
ClassMethod SpecimenRevocation(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set $zt="Exception"
	set suCount=0,faCount=0,faInfo=""
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(Input,.tDocument)
	set Response=##class(web.DHCENS.STBLL.LIS.MODEL.Response).%New()
	set header=##class(web.DHCENS.STBLL.LIS.MODEL.Header).%New()
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.SourceSystem="02"
	set Response.header=header
	set responseBody=##class(web.DHCENS.STBLL.LIS.MODEL.Respbody).%New()
	if $$$ISERR(tSC) {
		set responseBody.ResultCode="-1"
		set responseBody.ResultContent=tSC
		set Response.Respbody=responseBody
	}else{
		set SourceSystemHer=""
		set tSC=tDocument.EvaluateExpression("/Request/Header/SourceSystem","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set SourceSystemHer=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/SpecimenRevocationRt/OrderItemIDs","count(OrderItemID)",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			set hsCount=tRes.GetAt(1).Value
			Quit:hsCount="0" "-1^信息为空"
			for i=1:1:hsCount {
				set (OrderItemID,SpecimenID,ExecUserCode,SpeciReceiveDate,SpeciReceiveTime)=""
				set HosCode="DHSZHYYZY"	              
				set tSC=tDocument.EvaluateExpression("/Request/Body/SpecimenRevocationRt/OrderItemIDs/OrderItemID["_i_"]","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set OrderItemID=$tr(fieldValue,$c(0),"")
				}
				
				set tSC=tDocument.EvaluateExpression("/Request/Body/SpecimenRevocationRt/ExecUserCode","text()",.tRes)	
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set ExecUserCode=$tr(fieldValue,$c(0),"")
				}
				set ExeUserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(ExecUserCode),""))
				set ExecFlag="" 
				if ((OrderItemID'="")&&(ExeUserID'="")){
					s ExecFlag=##class(appcom.OEOrdItem).Verify(OrderItemID,ExeUserID)
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

ClassMethod AddTubeOrdItem(Input As %String) As %String
{
	set $ZTrap = "SendMessageET"
	set ResultFlag="0"
	set Length=$l(Input,"###")
	set AppDeptCode="",DoctorCode="",DoctorCode="",ARecDeptCode="",BBExtCode="",SPECCode="",InsertCode="False"
	ts
	for k=1:1:Length {
		set TmpTube=$p(Input,"###",k)
		set OrdRowIDs=$p(TmpTube,"+",2)
		set Rowid=$p(OrdRowIDs,"^",1)
		set OEORDRowId=$p(Rowid,"||",1)
		set OEORIChildsub=$p(Rowid,"||",2)
		set AdmRowId=$p(^OEORD(OEORDRowId),"^",1)
		set TmpLength=$L(OrdRowIDs,"^")
		set DoctorRowID=$P(^OEORD(OEORDRowId,"I",OEORIChildsub,7),"^",1)
		set DoctorCode=$p(^SSU("SSUSR",DoctorRowID),"^",1)
		set DoctorCode=$$ALPHAUP^SSUTIL4(DoctorCode)
		set UserRowId=$o(^SSU("SSUSR",0,"SSUSR_Initials",DoctorCode,""),-1)
		for k1=1:1:TmpLength {
			set TmpRowId=$p(OrdRowIDs,"^",k1)
			if $d(^User.EnsAmountOfTubeI("IndexAdmRowIdAndLabRowId"," "_AdmRowId," "_TmpRowId)) {
				set TubeID=$O(^User.EnsAmountOfTubeI("IndexAdmRowIdAndLabRowId"," "_AdmRowId," "_TmpRowId,""))
				set ID=$List(^User.EnsAmountOfTubeD(TubeID),5)
				set BillState=$p($g(^OEORD($P(ID,"||",1),"I",$p(ID,"||",2),3)),"^",5)
				q:BillState="P"
				set retStr=##class(web.DHCOEOrdItem).Stop(TmpRowId,UserRowId)
				&sql(Delete from SQLUSER.EnsAmountOfTube where Lab_RowId=:TmpRowId)
				if (SQLCODE'=0) {
					s ResultFlag="-1"
				}
			}
		}
	}
	if ResultFlag="-1" {
		tro
		Quit "-1^失败"
	}
	
	for i=1:1:Length {
		set TmpTube=$p(Input,"###",i)
		set arcimCode=$p(TmpTube,"+",1)
		set OrdRowIDs=$p(TmpTube,"+",2)
		set Rowid=$p(OrdRowIDs,"^",1)
		set OEORDRowId=$p(Rowid,"||",1)
		set OEORIChildsub=$p(Rowid,"||",2)
		set AdmRowId=$p(^OEORD(OEORDRowId),"^",1)
		set qty=$p(TmpTube,"+",3)
		set ordDeptDr=$P(^OEORD(OEORDRowId,"I",OEORIChildsub,7),"^",2)
		set AppDeptCode=$p(^CTLOC(ordDeptDr),"^",1)
		
		set recDeptDr=$P(^OEORD(OEORDRowId,"I",OEORIChildsub,3),"^",6)
		set userDr=$P(^OEORD(OEORDRowId,"I",OEORIChildsub,1),"^",11)
		set docDr=userDr
		set DoctorCode=$p(^SSU("SSUSR",userDr),"^",1)
				
		set sub = $O(^ARCIM(0,"Code",arcimCode,""))
		set ver = $O(^ARCIM(0,"Code",arcimCode,sub,""))
		set itemMast = sub_"||"_ver //医嘱项Rowid
		
		set OrderSeqNo=1
		set itemCat=$p($g(^ARCIM(sub,ver,1)),"^",10)  //医嘱子类
		set OrderType=$p($g(^ARC("IC",itemCat)),"^",7)
		set BillTypeRowid="1"
		set (OrderDrugFormRowid,OrderDepProcNotes,OrderDoseQty,OrderDoseUOMRowid,OrderQtySum,OrderFreqRowid)=""
		set (OrderDurRowid,OrderInstrRowid,PHPrescType,OrderMasterSeqNo,OrderSkinTest,OrderPhSpecInstr,OrderCoverMainIns)=""
		set (OrderActionRowid,OrderARCOSRowid,OrderEndDate,OrderEndTime,OrderLabSpecRowid)=""
		set OrderStartDate=$zd(+$h,4)
		set OrderStartTime=$p($h,",",2)
		set:OrderStartTime'="" OrderStartTime=$p($zt(OrderStartTime,1),":",1,2)
		set OEORIPriorityCode=3 
		Set OrderItemStr=itemMast_"^"_OrderType_"^"_OEORIPriorityCode_"^"_OrderStartDate_"^"_OrderStartTime_"^"_qty_"^"_"" 
		Set OrderItemStr=OrderItemStr_"^"_recDeptDr_"^"_BillTypeRowid_"^"_OrderDrugFormRowid_"^"_OrderDepProcNotes
		Set OrderItemStr=OrderItemStr_"^"_OrderDoseQty_"^"_OrderDoseUOMRowid_"^"_OrderQtySum_"^"_OrderFreqRowid_"^"_OrderDurRowid_"^"_OrderInstrRowid
		Set OrderItemStr=OrderItemStr_"^"_PHPrescType_"^"_OrderMasterSeqNo_"^"_OrderSeqNo_"^"_OrderSkinTest_"^"_OrderPhSpecInstr_"^"_OrderCoverMainIns
		Set OrderItemStr=OrderItemStr_"^"_OrderActionRowid_"^"_OrderARCOSRowid_"^"_OrderEndDate_"^"_OrderEndTime_"^"_OrderLabSpecRowid
		set res = ##class(DHCDoc.Interface.Inside.ServiceOrd).SaveOrderItems(AdmRowId,OrderItemStr,userDr,ordDeptDr,docDr,"")
		if ($p(res,"*",2)'="") {
			set RowId = $P(res,"*",2)
			set TmpLength=$L(OrdRowIDs,"^")
			for j=1:1:TmpLength {
				set TmpRowId=$p(OrdRowIDs,"^",j)
				s obj=##class(User.EnsAmountOfTube).%New()
				s obj.AdmRowId=AdmRowId
				s obj.LabRowId=TmpRowId
				s obj.TubeItemCode=arcimCode
				s obj.TubeRowId=RowId
				s obj.IntInsDate=+$h
				s obj.IntInsTime=$p($h,",",2)
				s sc=obj.%Save()
			}
		}
		else {
			set ResultFlag=-1
		}
	}
	if ResultFlag'="0" {
		tro
		Q "-1^计算失败"
	}
	else {
		tc 
		Q "0^成功"
	}
SendMessageET
	if $TLEVEL>0
	{
	 	tro	
	}
    Quit "-1^"_$ze
}

/// w ##class(web.DHCENS.STBLL.LIS.METHOD.OEOrderStatus).test()
ClassMethod test() As %String
{
	s stream=##class(%GlobalCharacterStream).%New()
	;s Input="<Request><Header><SourceSystem>LIS</SourceSystem><MessageID>121</MessageID></Header><Body><SpecimenRevocationRt><SpecimenID>111</SpecimenID><OrderItemIDs><OrderItemID>32||4</OrderItemID></OrderItemIDs><RevocationReason>测试</RevocationReason><ExecUserCode>demo</ExecUserCode><RevocationDate>2016-06-28</RevocationDate><RevocationTime>09:01:01</RevocationTime></SpecimenRevocationRt></Body></Request>"
	s Input="<Request><Header><SourceSystem>SYS0006</SourceSystem><MessageID></MessageID></Header><Body><SpecimenReceiveRt><SpecimenID>1000004052</SpecimenID><OEORIOrderItemIDs><OEORIOrderItemID>120||8</OEORIOrderItemID></OEORIOrderItemIDs><ExecUserCode>doctor</ExecUserCode><SpeciReceiveDate>2019-08-22</SpeciReceiveDate><SpeciReceiveTime>17:22:00</SpeciReceiveTime></SpecimenReceiveRt></Body></Request>"
	d stream.Write(Input)
	
	s return =..ExecuteStatus(stream)
	q return
}

}
