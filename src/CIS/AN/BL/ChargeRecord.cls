Class CIS.AN.BL.ChargeRecord Extends %RegisteredObject
{

ClassMethod SaveChargeRecordDetails(dataPara As %String) As %String
{
	set $zt="Error"
	set sc=##class(CIS.AN.COM.String).ToArray(dataPara,.array)
	m firstData=array(1)
	set opsId=$get(firstData("OperSchedule"))
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set EpisodeID=operSchedule.EpisodeID
	set visitStatus=$p(^PAADM(EpisodeID),"^",20)
	quit:(visitStatus="D") "E^该患者已出院，不能再修改医嘱！"
	tstart
	
	set userId=$get(firstData("UpdateUser"))
	set chargeRecordID=..GetChargeRecord(opsId,userId)
	if (##class(CIS.AN.ChargeRecord).%ExistsId(chargeRecordID)=0)
	{
		trollback
		quit "E^收费记录单未生成。"	
	}
	
	set dataIndex=0,saveResult=""
	for
	{
		set dataIndex=$order(array(dataIndex))
		quit:(dataIndex="")
		kill chargeDetailData
		m chargeDetailData=array(dataIndex)
		set chargeDetailID=$get(chargeDetailData("RowId"))
		if (##class(CIS.AN.ChargeDetail).%ExistsId(chargeDetailID)=0)
		{
			set chargeDetailData("CreateUser")=	chargeDetailData("UpdateUser")
			set chargeDetailData("ChargeUser")=chargeDetailData("UpdateUser")
			set chargeDetailData("ChargeDate")=+$h
			set chargeDetailData("ChargeTime")=$piece($h,",",2)
		}
		
		if ($get(chargeDetailData("ChargeDT"))'="")
		{
			set chargeDT=$get(chargeDetailData("ChargeDT"))
			set chargeDetailData("ChargeDate")=##class(CIS.AN.COM.DateTime).ConvertToDateH($p(chargeDT,",",1))
			set chargeDetailData("ChargeTime")=##class(CIS.AN.COM.DateTime).ConvertToTimeH($p(chargeDT,",",2))
		}
		
		set chargeDetailData("ClassName")="CIS.AN.ChargeDetail"
		set chargeDetailData("ChargeRecord")=chargeRecordID
		set chargeDetailData("Status")="N"
		
		if $g(chargeDetailData("isRemoved"))="Y" set saveResult=##class(CIS.AN.COM.DataService).DelData(chargeDetailData("ClassName"),chargeDetailData("RowId"))
		else  set saveResult=##class(CIS.AN.COM.DataService).SaveData(.chargeDetailData)
		quit:($piece(saveResult,"^",1)'="S")
	}
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult	
	}
	
	tcommit
	quit "S^"
Error
	set $zt=""
	quit "E^"_$ze
}

ClassMethod GetChargeRecord(opsId As %String, userId As %String) As %String
{
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) ""
	set chargeRecordID=""
	&sql(select RowId into :chargeRecordID from CIS_AN.chargerecord where OperSchedule=:opsId)
	if (##class(CIS.AN.ChargeRecord).%ExistsId(chargeRecordID)=0)
	{
		set chargeRecord=##class(CIS.AN.ChargeRecord).%New()
		set chargeRecord.OperSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		;set chargeRecord.CreateUser=userId
		set chargeRecord.CreateUser=##class(CF.AN.SSUser).%OpenId(userId)		//update by chen  20200402
		set chargeRecord.CreateDate=+$h
		set chargeRecord.CreateTime=$p($h,",",2)
		set sc=chargeRecord.%Save()
		set chargeRecordID=chargeRecord.%Id()	
	}
	quit chargeRecordID
}

/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ChargeRecord","FindChargeRecordDetails","298","63","N")
Query FindChargeRecordDetails(deptId As %String, opsId As %String, status As %String = "") As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT RowId,
	   ChargeRecord,
	   ChargeRecord->OperSchedule As OperSchedule,
	   CIS_AN_COM.DateTime_ConvertToDateTime(ChargeDate,ChargeTime,'') As ChargeDT,
	   CIS_AN_COM.DateTime_ConvertToDateTime(AuditDate,AuditTime,'') As AuditDT,
	   CIS_AN_COM.DateTime_ConvertToDateTime(UpdateDate,UpdateTime,'') As UpdateDT,
	   ChargeUser,
	   CIS_AN_COM.String_GetDescByID('User.SSUser','SSUSRName',ChargeUser) As ChargeUserDesc,
	   AuditUser,
	   CIS_AN_COM.String_GetDescByID('User.SSUser','SSUSRName',AuditUser) As AuditUserDesc,
	   UpdateUser,
	   CIS_AN_COM.String_GetDescByID('User.SSUser','SSUSRName',UpdateUser) As UpdateUserDesc,
	   BillDept,
	   CIS_AN_COM.String_GetDescByID('User.CTLoc','CTLOCDesc',BillDept) As BillDeptDesc,
	   ExecDept,
	   CIS_AN_COM.String_GetDescByID('User.CTLoc','CTLOCDesc',ExecDept) As ExecDeptDesc,
	   UserDept,
	   CIS_AN_COM.String_GetDescByID('User.CTLoc','CTLOCDesc',UserDept) As UserDeptDesc,
	   BarCode,
	   Qty,
	   Unit,
	   CIS_AN_COM.String_GetDescByID('User.CTUOM','CTUOMDesc',Unit) As UnitDesc,
	   ArcimID,
	   ArcimDesc,
	   CIS_AN_BL.OEOrder_GetItemCatByArcimID(ArcimID) As OrderCatDesc,
	   CIS_AN_COM.String_GetDescByID('User.OEOrdItem','OEORIPrescNo',ExternalID) As PrescNo,
	   RTRIM(CONVERT(DECIMAL(10,6),Price)) AS Price,
	   Instruction,
	   Instruction->Description As InstrDesc,
	   PrescribedDose,
	   DoseUnit,
	   CIS_AN_COM.String_GetDescByID('User.CTUOM','CTUOMDesc',DoseUnit) As DoseUnitDesc,
	   Status,
	   %External(Status) As StatusDesc,
	   ChargeItem->ChargeCategory->Description As ChargeCategoryDesc,
	   CancelUser,
	   CIS_AN_COM.String_GetDescByID('User.SSUser','SSUSRName',CancelUser) As CancelUserDesc,
	   CIS_AN_COM.DateTime_ConvertToDateTime(CancelDate,CancelTime,'') As CancelDT,
	   Priority,
	   AlertQty
	   from CIS_AN.ChargeDetail
	   where BillDept=:deptId and ChargeRecord->OperSchedule=:opsId
	   and (:status [ Status or :status is null)
	   order by CIS_AN_BL.OEOrder_GetItemCatByArcimID(ArcimID)
}

Query FindChargeSets(deptId As %String = "") As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT *
	   from CF_AN.ChargeSet
	   where (Dept=:deptId) or (:deptId is null)
}

Query FindChargeSetItems(chargeSetId As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT RowId,
	   ChargeItem,
	   ChargeItem->Description As ChargeItemDesc,
	   ChargeItem->Price As Price,
	   DefQty,
	   Uom,
	   Uom->LocalDesc As UomDesc,
	   Active,
	   %External(Active) As ActiveDesc,
	   %ODBCOUT(ActiveDate) As ActiveDate,
	   %ODBCOUT(ExpireDate) As ExpireDate,
	   Seq
	   from CF_AN.ChargeSetItem
	   where ChargeSet=:chargeSetId
	   order by Seq
}

ClassMethod RemoveChargeRecordDetails(paraStr As %String) As %String
{
	set $zt="Error"
	set sc=##class(CIS.AN.COM.String).ToArray(paraStr,.array)
	set dataCount=0,delRet="S^"
	tstart
	for
	{
		set dataCount=$order(array(dataCount))
		quit:(dataCount="")
		set className=array(dataCount,"ClassName")
		set rowId=array(dataCount,"RowId")
		set chargeRecordDetail=##class(CIS.AN.ChargeDetail).%OpenId(rowId)
		set stockConsume=""
		set:(chargeRecordDetail.StockConsume'="") stockConsume=chargeRecordDetail.StockConsume.%Id()
		if (##class(CIS.AN.StockConsume).%ExistsId(stockConsume)=1)
		{
			set delRet=##class(CIS.AN.COM.DataService).DelData("CIS.AN.StockConsume",stockConsume)	
			quit:($piece(delRet,"^",1)'="S")
		}
		
		set delRet=##class(CIS.AN.COM.DataService).DelData(className,rowId)
		quit:($piece(delRet,"^",1)'="S")	
	}	
	if ($piece(delRet,"^",1)'="S")
	{
		trollback
		quit delRet	
	}
	
	tcommit
	quit "S^"
Error
	trollback
	quit "E^"_$ze
}

ClassMethod GetOrdExecInfo(orderId As %String) As %String [ SqlProc ]
{
	set dataObj=##class(CIS.AN.COM.Query).ToObject("web.UDHCJFORDCHK:FindOeordexecInfo",orderId,"","")
	set billFlag=dataObj.GetValue("TBillFlag")
	set collectQty=dataObj.GetValue("TCollectQty")
	quit billFlag_"#"_collectQty
}

/// Creator：      	陈长青
/// CreatDate：    	2017-2-27
/// Description： 	查询病人诊断信息
/// Table：        	MR_Diagnos,MR_DiagType
/// Input:			EpisodeID:病人就诊ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ChargeRecord","FindIMDRecord","29","2018-12-10","2018-12-10","1822088")
Query FindIMDRecord(locId As %String, startDate As %String, endDate As %String, medcareNo As %String = "", stockItemId As %String = "") As %Query(ROWSPEC = "OperDeptDesc,PatDeptDesc,OperDate,PatName,MedcareNo,SurgeonDesc,AssistantDesc,MaterialDesc,Spec,ExpireDate,BatchNo,RegCert,Manufacturer,Vendor,Qty") [ SqlProc ]
{
}

ClassMethod FindIMDRecordExecute(ByRef qHandle As %Binary, locId As %String, startDate As %String, endDate As %String, medcareNo As %String = "", stockItemId As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	set startDateH=##class(CIS.AN.COM.DateTime).ConvertToDateH(startDate)
	set endDateH=##class(CIS.AN.COM.DateTime).ConvertToDateH(endDate)
	for dateIndex=startDateH:1:endDateH
	{
		set stockConsumeId=0
		for
		{
			set stockConsumeId=$order(^CIS.AN.StockConsumeI("LocDate"," "_locId,dateIndex,stockConsumeId))
			quit:(stockConsumeId="")
			set stockConsume=##class(CIS.AN.StockConsume).%OpenId(stockConsumeId)
			continue:(stockConsume="")
			set curStockItemId=""
			set:(stockConsume.StockItemDr'="") curStockItemId=stockConsume.StockItemDr.%Id()
			continue:(stockItemId'="")&(curStockItemId'=stockItemId)	
			set EpisodeID=stockConsume.RecordSheet.OperSchedule.EpisodeID
			set curMedcareNo=##class(CIS.AN.COM.Admission).GetMedicareNo("",EpisodeID)
			continue:(medcareNo'="")&(curMedcareNo'=medcareNo)
			continue:(stockConsume.BarCode="")
			set opsId=stockConsume.RecordSheet.OperSchedule.%Id()
			set batchNo=""
			set:(stockConsume.StockTransferDr'="") batchNo=$tr(stockConsume.StockTransferDr.BatchNo,$c(0),"")
			set expireDate=""
			set:(stockConsume.StockTransferDr'="") expireDate=stockConsume.StockTransferDr.ExpiryDate
			set expireDate=$p(expireDate," ",1)
			set ^TMPIMDRecord($j,+opsId,+curStockItemId,batchNo,expireDate,+stockConsumeId)=""
		}	
	}
	
	set opsId=0
	for
	{
		set opsId=$order(^TMPIMDRecord($j,opsId))
		quit:(opsId="")
		set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		set EpisodeID=operSchedule.EpisodeID
		set curMedcareNo=##class(CIS.AN.COM.Admission).GetMedicareNo("",EpisodeID)
		set operScheduleQuery=##class(%ResultSet).%New("CIS.AN.BL.OperSchedule:FindOperScheduleList")
		set sc=operScheduleQuery.Execute("","","",opsId)
		set patName="",surgeonDesc="",circualNurseDesc="",operDeptDesc="",operDate="",assistantDesc="",patDeptDesc=""
		while(operScheduleQuery.%Next())
		{
			set patName=operScheduleQuery.Get("PatName")
			set surgeonDesc=operScheduleQuery.Get("SurgeonDesc")
			set circualNurseDesc=operScheduleQuery.Get("CircualNurseDesc")	
			set operDeptDesc=operScheduleQuery.Get("OperDeptDesc")
			set operDate=operScheduleQuery.Get("OperDate")
			set assistantDesc=operScheduleQuery.Get("AssistantDesc")
			set patDeptDesc=operScheduleQuery.Get("PatDeptDesc")
		}
		set curStockItemId=0
		for
		{
			set curStockItemId=$order(^TMPIMDRecord($j,opsId,curStockItemId))
			quit:(curStockItemId="")
			set stockItem=##class(DHCCL.Config.StockItem).%OpenId(curStockItemId)
			set spec=$tr(stockItem.Spec,$c(0),"")
			
			set batchNo=""
			for
			{
				set batchNo=$order(^TMPIMDRecord($j,opsId,curStockItemId,batchNo))
				quit:(batchNo="")
				set expireDate=""
				for
				{
					set expireDate=$order(^TMPIMDRecord($j,opsId,curStockItemId,batchNo,expireDate))
					quit:(expireDate="")
					set stockConsumeId=0,stockItemCount=0,manufacturer="",vendor="",regCert="",materialDesc=""
					for
					{
						set stockConsumeId=$order(^TMPIMDRecord($j,opsId,curStockItemId,batchNo,expireDate,stockConsumeId))
						quit:(stockConsumeId="")
						set stockConsume=##class(CIS.AN.StockConsume).%OpenId(stockConsumeId)
						continue:(stockConsume="")
						set curStockItemId=""
						set:(stockConsume.StockItemDr'="") curStockItemId=stockConsume.StockItemDr.%Id()	
						//set expireDate=""
						//set:(stockConsume.StockTransferDr'="") expireDate=stockConsume.StockTransferDr.ExpiryDate
						//set expireDate=$p(expireDate," ",1)
						//set batchNo=""
						//set:(stockConsume.StockTransferDr'="") batchNo=$tr(stockConsume.StockTransferDr.BatchNo,$c(0),"")
						set regCert=""
						set:(stockConsume.StockTransferDr'="") regCert=$tr(stockConsume.StockTransferDr.RegCert,$c(0),"")
						set manufacturer=""
						set:(stockConsume.StockTransferDr'="") manufacturer=$tr(stockConsume.StockTransferDr.Manufacturer,$c(0),"")
						set vendor=""
						set:(stockConsume.StockTransferDr'="") vendor=$tr(stockConsume.StockTransferDr.Vendor,$c(0),"")
						set stockItemCount=stockItemCount+stockConsume.Qty
						set qty=stockConsume.Qty	
						set materialDesc=stockConsume.StockItemDesc
					}
					continue:(stockItemCount=0)
					do OutputRow
				}
			}
				
		}	
	}
	
	k ^TMPIMDRecord($j)
	s qHandle=$lb(0,repid,0)
	q $$$OK

OutputRow
	s Data=$lb(operDeptDesc,patDeptDesc,operDate,patName,curMedcareNo,surgeonDesc,assistantDesc,materialDesc,spec,expireDate,batchNo,regCert,manufacturer,vendor,stockItemCount)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod FindIMDRecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindIMDRecordExecute ]
{
	s AtEnd=$li(qHandle,1)
	s repid=$li(qHandle,2)
	s ind=$li(qHandle,3)
	//
	s ind=$o(^CacheTemp(repid,ind))
	i ind="" {				// if there are no more rows, finish fetching
	s AtEnd=1
	s Row=""
	}
	else      {				// fetch row
	s Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindIMDRecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindIMDRecordExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

ClassMethod AddHVMConsume(barCode As %String, recordSheetID As %String, deptID As %String, userID As %String) As %String
{
	set $zt="Error"
	set chargeDetailID=$order(^CIS.AN.ChargeDetailI("IBarCode"," "_barCode,0))
	quit:(##class(CIS.AN.ChargeDetail).%ExistsId(chargeDetailID)) "E^条码对应的高值耗材已收费。"
	set stockTransferID=$order(^DHCCL.Model.StockTransferI("IBarCode"," "_barCode,0))
	set stockTransfer=##class(DHCCL.Model.StockTransfer).%OpenId(stockTransferID)
	set stockItem=stockTransfer.StockItemDr
	tstart
	set chargeRecordDetail=##class(CIS.AN.ChargeDetail).%New()
	set recordSheet=##class(CIS.AN.RecordSheet).%OpenId(recordSheetID)
	set chargeRecordID=##class(CIS.AN.BL.ChargeRecord).GetChargeRecord(recordSheet.OperSchedule.%Id(),userID)
	set chargeRecordDetail.ChargeRecord=##class(CIS.AN.ChargeRecord).%OpenId(chargeRecordID)
	set chargeRecordDetail.BillDept=deptID
	set chargeRecordDetail.UserDept=deptID
	set chargeRecordDetail.ExecDept=deptID
	set chargeRecordDetail.ChargeDate=+$h
	set chargeRecordDetail.ChargeTime=$p($h,",",2)
	set chargeRecordDetail.ChargeUser=userID
	set chargeRecordDetail.CreateDate=+$h
	set chargeRecordDetail.CreateTime=$p($h,",",2)
	set chargeRecordDetail.CreateUser=userID
	set chargeRecordDetail.Price=stockTransfer.Price
	set chargeRecordDetail.Qty=stockTransfer.Qty
	set chargeRecordDetail.Status="N"
	set chargeRecordDetail.Unit=stockTransfer.UomDr
	set chargeRecordDetail.UpdateUser=userID
	set chargeRecordDetail.UpdateDate=+$h
	set chargeRecordDetail.UpdateTime=$p($h,",",2)
	set chargeRecordDetail.ChargeItemDesc=stockItem.Description
	set chargeRecordDetail.BarCode=barCode
	set sc=chargeRecordDetail.%Save()
	if ($System.Status.IsError(sc))
	{
		trollback
		quit "E^"_$System.Status.GetErrorText(sc)	
	}
	tcommit
	quit "S^"
Error
	trollback
	quit "E^"_$ze
}

/// w ##class(CIS.AN.BL.ChargeRecord).AuditOrderList("50","118","3")
ClassMethod AuditOrderList(opsId As %String, locId As %String, userId As %String) As %String
{
	set $zt="Error"
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set opaId=operSchedule.ExternalID,EpisodeID=operSchedule.EpisodeID
	set EpisodeID=operSchedule.EpisodeID
	set visitStatus=$p(^PAADM(EpisodeID),"^",20)
	quit:(visitStatus="D") "E^该患者已出院，不能再审核医嘱！"
	
	set startDateH=+$h,startTimeH=$p($h,",",2),count=1
	set startDate=##class(CIS.AN.COM.DateTime).ConvertToDate(startDateH)
	set startTime=##class(CIS.AN.COM.DateTime).ConvertToTime(startTimeH)
	set rset=##class(%ResultSet).%New("CIS.AN.BL.ChargeRecord:FindChargeRecordDetails")
	set sc=rset.Execute(locId,opsId,"N")
	set orderDesc="",mainSplitChar="^",subSplitChar=$c(3),saveResult="E^未找到需要审核的医嘱"
	tstart
	while(rset.%Next())
	{
		set arcimId=rset.Get("ArcimID")
		set recvLocId=rset.Get("ExecDept")
		set seqNo=count
		set doseQty=rset.Get("PrescribedDose")
		set doseQtySum=rset.Get("Qty")
		set:(doseQty="") doseQty=doseQtySum
		set doseUomId=rset.Get("DoseUnit")
		set:(doseUomId="") doseUomId=rset.Get("Unit")
		set instruction=rset.Get("Instruction")
		set masterSeqNo=""
		set price=rset.Get("Price")
		set orderNote=""
		;set:(orderDesc'="") orderDesc=orderDesc_mainSplitChar
		set orderDesc=""
		set orderDesc=orderDesc_arcimId_subSplitChar_startDate_subSplitChar_startTime_subSplitChar_recvLocId_subSplitChar
		set orderDesc=orderDesc_doseQty_subSplitChar_doseQtySum_subSplitChar_doseUomId_subSplitChar_instruction_subSplitChar
		set orderDesc=orderDesc_seqNo_subSplitChar_masterSeqNo_subSplitChar_price_subSplitChar_orderNote
		set orderRet=##class(CIS.AN.BL.OEOrder).InsertOrderItemNew(EpisodeID,orderDesc,userId,locId,opsId)
		set ^TMPCCQ("SaveOrderItems")=orderRet
		if ($p(orderRet,"*",3)="V")
		{
			set rowId=rset.Get("RowId")
			set chargeRecord=##class(CIS.AN.ChargeDetail).%OpenId(rowId)
			set chargeRecord.Status="A"
			set chargeRecord.AuditUser=userId
			set chargeRecord.AuditDate=startDateH
			set chargeRecord.AuditTime=startTimeH
			set chargeRecord.ExternalID=$p(orderRet,"*",2)
			set sc=chargeRecord.%Save()
			set:($System.Status.IsError(sc)) saveResult="E^"_$System.Status.GetErrorText(sc)
			set saveResult="S^"	
		}
		else
		{
			set saveResult="E^"_orderRet	
		}
		quit:($p(saveResult,"^",1)="E")
		set count=count+1
	}
	if ($p(saveResult,"^",1)="E")
	{
		trollback
		quit saveResult
	}
	tcommit
	// 生成处方号
	//do ##class(DHCDoc.Interface.Inside.Service).GenPresno(EpisodeID,userId,"")
	quit "S^"
Error
	trollback
	quit "E^"_$ze
}

ClassMethod DelOrderList(orderIdPara As %String) As %String
{
	quit:(orderIdPara="") "E^医嘱ID参数值为空。"
	set $zt="Error"
	set orderIdCount=$l(orderIdPara,",")
	
	tstart
	set saveResult="S^未找到需要删除的医嘱。"
	for i=1:1:orderIdCount
	{
		set orderId=$p(orderIdPara,",",i)
		set chargeRecord=##class(CIS.AN.ChargeDetail).%OpenId(orderId)
		set:(chargeRecord.Status="A") saveResult="E^医嘱："_chargeRecord.ArcimDesc_"已审核，不能删除。"
		set:(chargeRecord.Status="C") saveResult="E^医嘱："_chargeRecord.ArcimDesc_"已撤销，不能删除。"
		quit:($p(saveResult,"^",1)="E")
		set sc=##class(CIS.AN.ChargeDetail).%DeleteId(orderId)
		set:($System.Status.IsError(sc)) saveResult="E^"_$System.Status.GetErrorText(sc)
		quit:($System.Status.IsError(sc))
	}
	if ($p(saveResult,"^",1)="E")
	{
		trollback
		quit saveResult	
	}
	tcommit
	quit "S^"
Error
	trollback
	quit "E^"_$ze
}

ClassMethod CancelOrderList(orderIdPara As %String, userId As %String) As %String
{
	quit:(orderIdPara="") "E^医嘱ID参数值为空。"
	set $zt="Error"
	set orderIdCount=$l(orderIdPara,"^")
	set firstOrderId=$p(orderIdPara,"^",1)
	set CRDInfo=##class(CIS.AN.ChargeDetail).%OpenId(firstOrderId)
	set operSchedule=CRDInfo.ChargeRecord.OperSchedule
	
	set EpisodeID=operSchedule.EpisodeID
	set visitStatus=$p(^PAADM(EpisodeID),"^",20)
	quit:(visitStatus="D") "E^该患者已出院，不能再撤销医嘱！"
	
	tstart
	set saveResult="S^未找到需要删除的医嘱。"
	
	for i=1:1:orderIdCount
	{
		set orderId=$p(orderIdPara,"^",i)
		set chargeRecord=##class(CIS.AN.ChargeDetail).%OpenId(orderId)
		set:(chargeRecord.Status="N") saveResult="E^存在未核实的医嘱，不能作废。"
		b //ccq
		quit:($p(saveResult,"^",1)="E")
		set chargeRecord.Status="C"
		set chargeRecord.CancelUser=userId
		set chargeRecord.CancelDate=+$h
		set chargeRecord.CancelTime=$p($h,",",2)
		set sc=chargeRecord.%Save()
		set:($System.Status.IsError(sc)) saveResult="E^"_$System.Status.GetErrorText(sc)
		b //ccq2
		quit:($System.Status.IsError(sc))
		set cancelRet=##class(appcom.OEOrdItem).Cancel(chargeRecord.ExternalID,userId)
		set:(+cancelRet'=0) saveResult="E^撤销HIS系统医嘱失败(错误代码："_cancelRet_")，请联系系统管理员。"
		quit:($p(saveResult,"^",1)="E")
	}
	if ($p(saveResult,"^",1)="E")
	{
		trollback
		quit saveResult	
	}
	tcommit
	quit "S^"
Error
	trollback
	quit "E^"_$ze
}

/// Creator：      	雍阳
/// CreatDate：    	2018-12-27
/// Description：   生成药品记费记录明细
/// Table：        	DHCAN_Model.ChargeRecord
/// Input:			opsId:手术计划ID
/// Return：       	string
/// d ##class(CIS.AN.BL.ChargeRecord).GenerateChargeDetail(144,164,1786)
ClassMethod GenerateChargeDetail(opsId, deptId, userId, recordSheetId = "") As %String
{
	set result=..GenerateAnaMethodChargeDetails(opsId, deptId, userId)
	set result=..GenerateDrugChargeDetails(opsId, deptId, userId, "",recordSheetId)
	b ;00
	set result=..GenerateEventChargeDetails(opsId, deptId, userId,recordSheetId)
	b ;insertaAll..
	quit result
}

/// Creator：      	雍阳
/// CreatDate：    	2018-12-27
/// Description：   生成麻醉方法记费记录明细
/// Table：        	DHCAN_Model.ChargeRecord
/// Input:			opsId:手术计划ID
/// Return：       	string
/// d ##class(CIS.AN.BL.ChargeRecord).GenerateAnaMethodChargeDetails(542,164,17418)
ClassMethod GenerateAnaMethodChargeDetails(opsId, deptId, userId) As %String
{
	set chargeRecordId=..GetChargeRecord(opsId,userId)
	if (##class(CIS.AN.ChargeRecord).%ExistsId(chargeRecordId)=0)
	{
		quit "E^收费记录单未生成。"	
	}
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set anaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
	set AnaesthesiaObj=##class(CIS.AN.Anaesthesia).%OpenId(anaId)
	set theatreInDT=AnaesthesiaObj.TheatreInDT
	set theatreOutDT=AnaesthesiaObj.TheatreOutDT
	set duration=##class(CIS.AN.COM.DateTime).CalculateDurationS(theatreInDT,theatreOutDT,"H")
	//write "duration: ",duration," h",!
	///取麻醉导管表数据
	//set anaesthesiaList=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.DataQueries:FindAnaesthesia",opsId)
	set anaesthesiaList=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.DataQueries:FindAnaestCatheter",opsId)
	kill data
	
	set data("ClassName")="CIS.AN.ChargeDetail"
	set data("ChargeRecord")=chargeRecordId
	set data("EpisodeID")=operSchedule.EpisodeID
	set data("PrescribedDose")=0
	set data("ActualDose")=0
	set data("DoseUnit")=""
	set data("Qty")=0
	set data("Unit")=""
	set data("UpdateUser")=userId
	set data("CreateUser")=userId
	set data("BillDept")=deptId
	set data("ExecDept")=deptId
	set data("ArcimID")=""
	set data("ArcimDesc")=""
	set data("Price")=""
	set data("Status")="N"
	set data("Source")="A"
	b ;11
	for i=1:1:anaesthesiaList.Size
	{
		set anaesthesia=anaesthesiaList.GetAt(i)
		quit:anaesthesia=""
		set anaMethodId=anaesthesia.GetValue("AnaMethod")
		
		///ygb 20220823
		set ChargeAnaMethodRecord = anaesthesia.GetValue("ChargeAnaMethodRecord")
		//write " ChargeRecord:",ChargeRecord
		//continue:(ChargeAnaMethodRecord'="")  //已生成计费明细的不再进入计算
		if (anaMethodId'="")
		{
			set ChargeDetailAnaMethodId=..GetChargeDetailIdByAnaMethod(chargeRecordId,anaMethodId)
			if (ChargeDetailAnaMethodId="")
			{
			
				set chargeDetailId= $$ChargeAnaMethod(anaMethodId)
				b ;012
				quit:chargeDetailId=""
				do BindAnaMethodData(anaesthesia.GetValue("RowId"),$P(chargeDetailId,"^",2))
			}
		}
		/// 插管收费
		//set anaCatheterRowId=$o(^CIS.AN.AnaestCatheterI("IAna",anaesthesia.GetValue("RowId"),""))
		set anaCatheterRowId=anaesthesia.GetValue("RowId")
		if anaCatheterRowId'=""
		{
			set ChargeDetailCatheterId=..GetChargeDetailIdByCatheter(chargeRecordId,anaCatheterRowId)
			///ygb 20220823
			//set ChargeCatheterRecord = anaesthesia.GetValue("ChargeCatheterRecord")
			//write " ChargeRecord:",ChargeRecord
			continue:(ChargeDetailCatheterId'="")  //已生成计费明细的不再进入计算
			set anaCatheter=##class(CIS.AN.AnaestCatheter).%OpenId(anaCatheterRowId)
			set catheterId=""
			if anaCatheter.Catheter'=""
			{
				set catheterId=anaCatheter.Catheter.%Id()
				set chargeDetailId= $$ChargeCatheter(catheterId,anaCatheterRowId)
				do BindCatheterData(anaesthesia.GetValue("RowId"),$P(chargeDetailId,"^",2))
			}
		}
	}

	quit "S^"
	
ChargeAnaMethod(anaMethodId)
	quit:anaMethodId=""
	set rowId="",ret=""
	for
	{
		set rowId=$o(^CF.AN.AnaMethodArcimI("IAnaMethod"," "_anaMethodId,rowId))
		quit:rowId=""
		set anaMethodArcim=##class(CF.AN.AnaMethodArcim).%OpenId(rowId)
		///增加截止时间限制  20220802  ygb
		set ruleEnddate=""
		continue:anaMethodArcim.Rule=""
		set Rule=##class(CF.AN.ArcimRule).%OpenId(anaMethodArcim.Rule.%Id())
		if (Rule.EndDate'="") set ruleEnddate=Rule.EndDate
		
		continue:(ruleEnddate'="")&&(ruleEnddate<+$h)
		set ret=""
		if anaMethodArcim.MethodArcimID'=""
		{
			set data("ArcimID")=anaMethodArcim.MethodArcimID
			set data("Qty")=1
			set data("Unit")=""
			set data("ChargeDate")=+$h
			set data("ChargeTime")=$p($h,",",2)
			set data("ChargeTime")=data("ChargeTime")\60*60
			set data("Price")=##class(CIS.AN.COM.DataAdapter).GetArcimPrice(data("ArcimID"),"",operSchedule.EpisodeID)
			set data("ArcimDesc")=##class(CIS.AN.BL.Admission).GetArcimDesc(data("ArcimID"))
			set data("AnaMethod")=anaMethodId
			write "charge anamethod: ",data("ArcimDesc"),!
		
			set ret= ##class(CIS.AN.COM.DataService).SaveData(.data)
		}
		b ;33333
		if (duration>anaMethodArcim.TimeOutHours)&&(anaMethodArcim.TimeOutArcimID'="")
		{
			set data("ArcimID")=anaMethodArcim.TimeOutArcimID
			set data("Qty")=duration-anaMethodArcim.TimeOutHours
			set data("Unit")=""
			set data("ChargeDate")=+$h
			set data("ChargeTime")=$p($h,",",2)
			set data("ChargeTime")=data("ChargeTime")\60*60
			set data("Price")=##class(CIS.AN.COM.DataAdapter).GetArcimPrice(data("ArcimID"),"",operSchedule.EpisodeID)
			set data("ArcimDesc")=##class(CIS.AN.BL.Admission).GetArcimDesc(data("ArcimID"))
			set data("AnaMethod")=anaMethodId
			write "charge anamethod timeout: ",data("ArcimDesc"), "  Qty:",data("Qty"),!
			
			set ret1= ##class(CIS.AN.COM.DataService).SaveData(.data)
			if (ret="")
			{
				set ret=ret1
			}
		}
		
		if anaMethodArcim.OrderSet'=""
		{
			set ret2= ..AddOrderSetToChargeDetail(opsId,anaMethodArcim.OrderSet,deptId, userId,anaMethodId)
			if (ret="")
			{
				set ret=ret2
			}
		}
	}
	quit ret
	
ChargeCatheter(catheterId,anaCatheterRowId)
	quit:catheterId=""
	
	set rowId=""
	set ret=""
	for
	{
		set rowId=$o(^CF.AN.CatheterArcimI("Catheter",catheterId,rowId))
		quit:rowId=""
		
		set catheterArcim=##class(CF.AN.CatheterArcim).%OpenId(rowId)
		///增加截止时间限制  20220802  ygb
		set ruleEnddate=""
		continue:catheterArcim.Rule=""
		set Rule=##class(CF.AN.ArcimRule).%OpenId(catheterArcim.Rule.%Id())
		if (Rule.EndDate'="") set ruleEnddate=Rule.EndDate
		
		continue:(ruleEnddate'="")&&(ruleEnddate<+$h)
		set data("ArcimID")=catheterArcim.ArcimID
		set data("PrescribedDose")=catheterArcim.DoseQty
		set data("ActualDose")=catheterArcim.DoseQty
		//set data("DoseUnit")=catheterArcim.DoseUom  //需要转换，对应表不一致
		set data("Qty")=catheterArcim.PackQty
		set data("ChargeDate")=+$h
		set data("ChargeTime")=$p($h,",",2)
		set data("ChargeTime")=data("ChargeTime")\60*60
		//set data("Unit")=catheterArcim.PackUom     //需要转换，对应表不一致
		set data("Price")=##class(CIS.AN.COM.DataAdapter).GetArcimPrice(data("ArcimID"),"",operSchedule.EpisodeID)
		set data("ArcimDesc")=##class(CIS.AN.BL.Admission).GetArcimDesc(data("ArcimID"))
		
		//write "charge catheter:",data("ArcimDesc"), "  Qty:",data("Qty"),!
		if (catheterArcim.ArcimID'="")
		{
			set data("Catheter")=anaCatheterRowId
			set ret= ##class(CIS.AN.COM.DataService).SaveData(.data)
		}
		if (catheterArcim.OrderSet'="")
		{
			set ret2=..AddOrderSetToChargeDetail(opsId,catheterArcim.OrderSet,deptId, userId,"",anaCatheterRowId)
		}
		if (ret="")
		{
			set ret=ret2
		}
		
	}
	
	quit ret
BindAnaMethodData(AnaestCatheterId,chargeDetailId)
	quit:'##class(CIS.AN.ChargeDetail).%ExistsId(chargeDetailId)
	
	set chargeDetail=##class(CIS.AN.ChargeDetail).%OpenId(chargeDetailId)
	set AnaestCatheter=##class(CIS.AN.AnaestCatheter).%OpenId(AnaestCatheterId)
	set AnaestCatheter.ChargeAnaMethodDetail=chargeDetail
	do AnaestCatheter.%Save()
	
	quit
BindCatheterData(AnaestCatheterId,chargeDetailId)
	quit:'##class(CIS.AN.ChargeDetail).%ExistsId(chargeDetailId)
	
	set chargeDetail=##class(CIS.AN.ChargeDetail).%OpenId(chargeDetailId)
	set AnaestCatheter=##class(CIS.AN.AnaestCatheter).%OpenId(AnaestCatheterId)
	set AnaestCatheter.ChargeCatheterDetail=chargeDetail
	do AnaestCatheter.%Save()
	
	quit
}

/// Creator：      	雍阳
/// CreatDate：    	2018-12-27
/// Description：   生成药品记费记录明细
/// Table：        	DHCAN_Model.ChargeRecord
/// Input:			opsId:手术计划ID
/// Return：       	string
/// w ##class(CIS.AN.BL.ChargeRecord).GenerateDrugChargeDetails(194,164,17418)
ClassMethod GenerateDrugChargeDetails(opsId, deptId, userId, categoryCode = "", recordSheetId = "") As %String
{
	set chargeRecordId=..GetChargeRecord(opsId,userId)
	if (##class(CIS.AN.ChargeRecord).%ExistsId(chargeRecordId)=0)
	{
		quit "E^收费记录单未生成。"	
	}
	
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set patWeight = operSchedule.PatWeight
	set EpisodeID = operSchedule.EpisodeID
	set InfusionPriority=+$o(^OECPR(0,"Code","STAT",""))
	set DrugPriority=+$o(^OECPR(0,"Code","ONE",""))
	
	kill drugArcimList
	
	set moduleCode = "AnaestRecord"
	set:recordSheetId="" recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCode(opsId,moduleCode,"")
	set drugDatas=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.AnaestRecord:FindDrugDatas",recordSheetId,"N",categoryCode)
	//break  //before integrate
	
	for i=1:1:(drugDatas.Size)
	{
		set drugData = drugDatas.GetAt(i)
		quit:drugData=""
		
		set drugDataRowId = drugData.GetValue("RowId")
		set dataCategoryCode=drugData.GetValue("CategoryCode")
		set dataMainCategoryCode=drugData.GetValue("MainCategoryCode")
		
		continue:(categoryCode'="")&&(dataCategoryCode'=categoryCode)
		
		set DataItem = drugData.GetValue("DataItem")
		//write "DataItem:",DataItem,""
		continue:DataItem="" //未考虑自定义项目
		
		set ChargeRecord = drugData.GetValue("ChargeRecord")
		//write " ChargeRecord:",ChargeRecord
		continue:(ChargeRecord'="")  //已生成计费明细的不再进入计算
		
		set ArcimID = drugData.GetValue("ArcimID")
		
		//考虑一个数据项对应多个医嘱项的情况
		set drugArcimId = ##class(CIS.AN.BL.ArcimRule).GetDrugArcim(DataItem,ArcimID)
		//write " ArcimId:",ArcimID," drugArcim:",drugArcimId,!
		if drugArcimId>0
		{
			set drugArcim=##class(CF.AN.DrugArcim).%OpenId(drugArcimId)
			set targetDoseUnit = $Order(^CT.AN.UomI("IExt"," "_drugArcim.DoseUom,""))
			set:targetDoseUnit="" targetDoseUnit = drugArcim.DoseUom
			
			set Instruction=drugData.GetValue("Instruction")
			set div=" "_Instruction
			
			set chargingDataItems(DataItem,div,"ArcimID")=drugArcim.ArcimID
			set chargingDataItems(DataItem,div,"Specification")=drugArcim.DoseQty  ///规格可能需要重新计算
			set chargingDataItems(DataItem,div,"DoseUnit")=drugData.GetValue("ArcimID")
			set chargingDataItems(DataItem,div,"AlertQty")=drugArcim.AlertQty
			set ChargeWeiHu=$p($g(^CT("UOM",drugArcim.DoseUom)),"^",2)
			set chargingDataItems(DataItem,div,"Unit")=drugArcim.PackUom
			
			set chargingDataItems(DataItem,div,"ExecDept")=drugArcim.RecvLoc
			set recvLoc=+##class(web.DHCDocOrderCommon).GetRecloc(EpisodeID,drugArcim.ArcimID)
			if (drugArcim.RecvLoc="") set chargingDataItems(DataItem,div,"ExecDept")=recvLoc
			
			//set chargingDataItems(DataItem,"Instruction")=drugArcim.Instruction //新表 用法ID
			set chargingDataItems(DataItem,div,"Instruction")=Instruction
			
			set DoseQty = drugData.GetValue("DoseQty")  //剂量
			set DoseUnit = drugData.GetValue("DoseUnit") //剂量单位 ID 对应
			set DoseUnitDesc = drugData.GetValue("DoseUnitDesc")  //剂量单位描述
			set Concentration = drugData.GetValue("Concentration")  //浓度
			set ConcentrationUnit = drugData.GetValue("ConcentrationUnit")  //浓度单位
			set hisDoseUnitId=""
			set:DoseUnit'="" hisDoseUnitId=$lg(^CT.AN.UomD(+DoseUnit),3)
			set chargingDataItems(DataItem,div,"DoseUnit")=hisDoseUnitId 
			set chargingDataItems(DataItem,div,"DoseUnitDesc")=DoseUnitDesc
			set:hisDoseUnitId="" chargingDataItems(DataItem,div,"DoseUnit")=drugArcim.DoseUom   ///剂量单位后续处理中是以CT.AN.Uom的RowId来处理的
			set:hisDoseUnitId="" chargingDataItems(DataItem,div,"DoseUnitDesc")=$p(^CT("UOM",drugArcim.DoseUom),"^",2) 
			
			set standardizedDoseQty=0
			set IsContinuous = drugData.GetValue("Continuous")
			
			///获取等效剂量单位
			set charginguomDrFirst="",charginguomDescFirst="",chargingQtyFirst=""
			set charginguomDrSecond="",charginguomDescSecond="",chargingQtySecond=""
			set EqualDoses=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.OEOrder:FindDrugEqual",drugArcim.ArcimID)
			set EqualDoseSize=EqualDoses.Size
			set EqualDoseUnit="",EqualDoseUnitDesc=""
			for edIndex=1:1:EqualDoseSize
			{
				set equalUomId=EqualDoses.GetAt(edIndex).GetValue("uomDr")
				set equalUomDesc=EqualDoses.GetAt(edIndex).GetValue("uomDesc")
				set equalQty=EqualDoses.GetAt(edIndex).GetValue("qty")
				if (edIndex=1)
				{
					set EqualDoseUnit=equalUomId
					set EqualDoseUnitDesc=equalUomDesc
					set chargingDataItems(DataItem,div,"Specification")=equalQty
				}
				if equalUomDesc=chargingDataItems(DataItem,div,"DoseUnitDesc")
				{
					set EqualDoseUnit=equalUomId
					set EqualDoseUnitDesc=equalUomDesc
					set chargingDataItems(DataItem,div,"Specification")=equalQty
					quit
				}
			}
			if dataCategoryCode="ANInhaledAnesthetics" set chargingDataItems(DataItem,div,"Specification")=1
			
			//b // zw EqualDose
			///连续用药通过速度计算
			if (IsContinuous="Y")
			{
				set Speed = drugData.GetValue("Speed")
				set SpeedUnit = drugData.GetValue("SpeedUnit")
			
				set StartDT = drugData.GetValue("StartDT")
				set EndDT = drugData.GetValue("EndDT")
				
				set timeSpan = ##class(CIS.AN.COM.DateTime).CalculateDurationS(StartDT,EndDT,"S")
				if (+Speed=0)&&(DoseQty>0) set standardizedDoseQty=DoseQty
				if (+Speed>0) set standardizedDoseQty = $$IntegrateContinuous(Speed,timeSpan,SpeedUnit,targetDoseUnit,Concentration,ConcentrationUnit)
				if dataCategoryCode="ANInhaledAnesthetics"
				{
					set standardizedDoseQty=20*timeSpan/3600
					set DoseUnit=$o(^CT.AN.UomI("ICode"," ML",""))
					set DoseUnitDesc="ml"
				}
			}
			else
			{
				//b //w DoseUnit,targetDoseUnit
				set concentrationUomId=""
				&sql(select RowId into :concentrationUomId from ct_an.concentrationuom where uom=:ConcentrationUnit)
				if (##class(CT.AN.ConcentrationUom).%ExistsId(concentrationUomId))
				{
					set concentrationUom=##class(CT.AN.ConcentrationUom).%OpenId(concentrationUomId)
					if (concentrationUom.SolventUom.%Id()=DoseUnit) && (Concentration>0)
					{
						set DoseQty=DoseQty*Concentration
						set DoseUnit=concentrationUom.SoluteUom.%Id()
					}
				}
				set standardizedDoseQty=DoseQty
				//if DoseUnitDesc'=chargingDataItems(DataItem,div,"DoseUnitDesc")
				if DoseUnit'=targetDoseUnit
				{
					set standardizedDoseQty = $$ConvertUnit(DoseQty,DoseUnit,targetDoseUnit)
				}
			}
			
			//write "after calculate dose", standardizedDoseQty,!
			//取等效单位的数据  ygb 20220822
			set chargingDataItems(DataItem,div,"DoseUnit")=EqualDoseUnit
			set chargingDataItems(DataItem,div,"DoseUnitDesc")=EqualDoseUnitDesc
			set chargingDataItems(DataItem,div,"TotalDose")=$g(chargingDataItems(DataItem,div,"TotalDose")) + standardizedDoseQty
			set chargingDataItems(DataItem,div,"RelatedDrugData",drugDataRowId)=""
			b ;123
		}
	}
	
	//write "calculate dose success",!
	//break //before insert all
	set DataItem=""
	for
	{
		set DataItem=$o(chargingDataItems(DataItem))
		quit:DataItem=""
		
		set div=""
		for
		{
			set div=$o(chargingDataItems(DataItem,div))
			quit:div=""
		
			set specification = $g(chargingDataItems(DataItem,div,"Specification"))
			set:+specification=0 specification=1
			set ArcimID=chargingDataItems(DataItem,div,"ArcimID")
			set doseUnit = $g(chargingDataItems(DataItem,div,"DoseUnit"))
			set unit = $g(chargingDataItems(DataItem,div,"Unit"))
			set execDept = chargingDataItems(DataItem,div,"ExecDept")
			set dose = $g(chargingDataItems(DataItem,div,"TotalDose"))
			set Instruction=chargingDataItems(DataItem,div,"Instruction")
			set AlertQty=$g(chargingDataItems(DataItem,div,"AlertQty"))
			set qty = dose \ specification
			if dose > (specification *qty)
			{
				set qty=qty + 1
			}
	
			set remainDose = (specification *qty) - dose
			set dose=$fn(dose,"",2)
			set prescribedDose = dose
		
			//write "insert charge detail: qty:", qty," dose:",dose,!
			//break //before insert
			b ;000
			set chargeDetailId=$$AddChargeDetail(qty,prescribedDose,dose,specification)
			//b  //before bind
			do BindDrugData(DataItem,div,chargeDetailId)
		}
	}
	
	quit "S^"
	
AddChargeDetail(qty,prescribedDose,dose,specification)
	kill data
	
	set data("ClassName")="CIS.AN.ChargeDetail"
	set data("ChargeRecord")=chargeRecordId
	set data("ChargeItem")=""
	set data("Qty")=qty
	set data("Unit")=unit
	set data("PrescribedDose")=prescribedDose
	set data("ActualDose")=dose
	set data("DoseUnit")=doseUnit
	set data("UpdateUser")=userId
	set data("CreateUser")=userId
	set data("BillDept")=deptId
	set data("ChargeDate")=+$h
	set data("ChargeTime")=$p($h,",",2)
	set data("ChargeTime")=data("ChargeTime")\60*60
	set data("ExecDept")=execDept
	set data("ArcimID")=ArcimID
	set data("Price")=##class(CIS.AN.COM.DataAdapter).GetArcimPrice(data("ArcimID"),"",operSchedule.EpisodeID)
	set data("ArcimDesc")=##class(CIS.AN.BL.Admission).GetArcimDesc(data("ArcimID"))
	set data("Status")="N"
	set data("Source")="A"
	set data("Instruction")=Instruction
	set data("AlertQty")=AlertQty
	if categoryCode="InVolume" set data("Priority")=InfusionPriority
	else  set data("Priority")=DrugPriority
	
	set foundDetailId=$$GetUnchargedDetail(chargeRecordId,ArcimID,Instruction)
	if foundDetailId'=""
	{
		set foundDetail=##class(CIS.AN.ChargeDetail).%OpenId(foundDetailId)
		if doseUnit=foundDetail.DoseUnit
		{
			set prescribedDose=prescribedDose+foundDetail.PrescribedDose
			set dose=dose+foundDetail.ActualDose
			
			set qty = dose \ specification
			if dose > (specification *qty)
			{
				set qty=qty + 1
			}
			
			set data("PrescribedDose")=prescribedDose
			set data("ActualDose")=dose
			set data("Qty")=qty
			set data("RowId")=foundDetailId
		}
	}
	
	set saveResult=##class(CIS.AN.COM.DataService).SaveData(.data)
	set chargeDetailId=+$p(saveResult,"^",2)
	
	quit chargeDetailId
	
BindDrugData(DataItem,div,chargeDetailId)
	quit:'##class(CIS.AN.ChargeDetail).%ExistsId(chargeDetailId)
	
	set chargeDetail=##class(CIS.AN.ChargeDetail).%OpenId(chargeDetailId)
	set drugDataRowId=""
	for
	{
		set drugDataRowId=$o(chargingDataItems(DataItem,div,"RelatedDrugData",drugDataRowId))
		quit:drugDataRowId=""
		
		set drugData=##class(CIS.AN.DrugData).%OpenId(drugDataRowId)
		set drugData.ChargeDetail=chargeDetail
		
		do drugData.%Save()
	}
	
	quit

IntegrateContinuous(speed,timeSpan,speedUnit,targetDoseUnit,concentration,concentrationUnitId)
	set doseUnit="",timeUnit="",weightUnit=""
	&sql(select DoseUom,TimeUom,WeightUom into:doseUnit,:timeUnit,:weightUnit from CT_AN.SpeedUom 
		where Uom=:speedUnit)
	
	set qty = speed
	if doseUnit="" set qty = 1
	
	set timeFactor = 3600 //$$ConvertUnit(1,timeUnit,UnitSecond)
	set qty = qty * timeSpan / timeFactor
	
	set concentrationUomId=""
	&sql(select RowId into :concentrationUomId from ct_an.concentrationuom where uom=:concentrationUnitId)
	if (##class(CT.AN.ConcentrationUom).%ExistsId(concentrationUomId))
	{
		set concentrationUom=##class(CT.AN.ConcentrationUom).%OpenId(concentrationUomId)
		if (concentrationUom.SolventUom.%Id()=doseUnit) && (concentration>0)
		{
			set qty=qty*concentration
			set doseUnit=concentrationUom.SoluteUom.%Id()
		}
	}
	
	if weightUnit'="" set qty=qty * patWeight
	set qty = $$ConvertUnit(qty,doseUnit,targetDoseUnit)
	quit qty
	
ConvertUnit(doseQty,sourceUnit,targetUnit)
	set factor=1
	quit:sourceUnit=targetUnit doseQty
	
	&sql(select Factor into:factor from CT_AN.UomConversion 
		where Source=:sourceUnit and Target=:targetUnit)
	
	quit doseQty*factor
	
GetUnchargedDetail(chargeRecordId,arcimID,Instruction)
	set foundDetailId="",detailId=""
	for
	{
		set detailId=$o(^CIS.AN.ChargeDetailI("IArcim",chargeRecordId," "_deptId," "_arcimID,detailId))
		quit:detailId=""
		
		set detail=##class(CIS.AN.ChargeDetail).%OpenId(detailId)
		set auditDate=detail.AuditDate
		if (auditDate="")
		{
			if ('$IsObject(detail.Instruction))&&(Instruction="") set foundDetailId=detailId
			if ($IsObject(detail.Instruction))&&(Instruction=detail.Instruction.%Id()) set foundDetailId=detailId
		}
		
		quit:foundDetailId
	}
	
	quit foundDetailId
}

/// Creator：      	雍阳
/// CreatDate：    	2018-12-27
/// Description：   生成事件记费记录明细
/// Table：        	DHCAN_Model.ChargeRecord
/// Input:			opsId:手术计划ID
/// Return：       	string
/// d ##class(CIS.AN.BL.ChargeRecord).GenerateEventChargeDetails(617,298,11886)
ClassMethod GenerateEventChargeDetails(opsId, deptId, userId, recordSheetId = "") As %String
{
	set chargeRecordId=..GetChargeRecord(opsId,userId)
	if (##class(CIS.AN.ChargeRecord).%ExistsId(chargeRecordId)=0)
	{
		quit "E^收费记录单未生成。"	
	}
	set EpisodeID = $lg(^CIS.AN.OperScheduleD(opsId),1)
	kill drugArcimList
	set DrugPriority=+$o(^OECPR(0,"Code","ONE",""))
	set NORMPriority=+$o(^OECPR(0,"Code","NORM",""))
	
	set moduleCode = "AnaestRecord"
	set:recordSheetId="" recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCode(opsId,moduleCode,"")
	
	///处理不与事件明细项关联的对应医嘱
	set anaDatas=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.AnaestRecord:FindAnaDatasByType",recordSheetId,"E")
	for i=1:1:(anaDatas.Size)
	{
		set anaData = anaDatas.GetAt(i)
		quit:anaData=""
		
		set ChargeRecord = anaData.GetValue("ChargeRecord")
		continue:(ChargeRecord'="")  //已生成计费明细的不再进入计算
		
		set anaDataRowId = anaData.GetValue("RowId")
		set DataItem = anaData.GetValue("DataItem")
		continue:(DataItem="")  //未考虑自定义项目
		
		set eventArcimId=""
		for
		{
			b ;02
			set eventArcimId = $o(^CF.AN.EventArcimI("IEventItem",DataItem,eventArcimId))
			quit:eventArcimId=""
			
			set eventArcim =##class(CF.AN.EventArcim).%OpenId(eventArcimId)
			continue:eventArcim.DetailItem'=""  ///与明细项关联的医嘱不处理
			
			continue:eventArcim.Rule=""
			set ruleEnddate=""
			set Rule=##class(CF.AN.ArcimRule).%OpenId(eventArcim.Rule.%Id())
			if (Rule.EndDate'="") set ruleEnddate=Rule.EndDate
			continue:(ruleEnddate'="")&&(ruleEnddate<+$h)
			
			set qty = eventArcim.PackQty
			set unit = eventArcim.PackUom
			set dose = eventArcim.DoseQty
			set doseUnit = eventArcim.DoseUom
			set execDept = eventArcim.RecvLoc
			set ArcimID = eventArcim.ArcimID
			set Instruction = eventArcim.Instruction
			set AlertQty = eventArcim.AlertQty
			if (eventArcim.ArcimID'="")
			{
				do AddChargeDetail(qty,dose,dose,NORMPriority,1,"",anaDataRowId)
			}
			
			if eventArcim.OrderSet'=""
			{
				do ..AddOrderSetToChargeDetail(opsId,eventArcim.OrderSet,deptId, userId)
			}
		}
	}
	
	///处理与事件明细项关联的对应医嘱
	set eventDatas=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.AnaestRecord:FindEventDatas",recordSheetId,"N")
	b ;01
	set EventDetailRule=""
	for i=1:1:(eventDatas.Size)
	{
		set eventData = eventDatas.GetAt(i)
		quit:eventData=""
		
		set eventItemDesc = eventData.GetValue("Description")
		set dataValue = eventData.GetValue("DataValue")
		if eventItemDesc["配方"
		{
			if dataValue="PCEA"
			{
				set EventDetailRule="PCEA"
			}
			else
			{
				set EventDetailRule="PCIA"
			} 
		}
		
		if eventItemDesc["曲马多"
		{
			set:dataValue>0 EventDetailRule="PCIA2"
		}
		
		if eventItemDesc["诺扬"
		{
			set:dataValue>0 EventDetailRule="PCIA1"
		}
		
		if eventItemDesc["布托啡诺"
		{
			set:dataValue>0 EventDetailRule="PCIA1"
		}
	}
	
	break //before integrate
	for i=1:1:(eventDatas.Size)
	{
		set eventData = eventDatas.GetAt(i)
		quit:eventData=""
		
		set eventDataRowId = eventData.GetValue("RowId")
		set EventDetailItemId=eventData.GetValue("EventDetailItem")
		//Write "EventDetailItem:",EventDetailItemId,!
		continue:EventDetailItemId="" //未考虑自定义项目
		
		set dose = eventData.GetValue("DataValue")
		continue:+dose<=0  //剂量为0
		
		set ChargeRecord = eventData.GetValue("ChargeRecord")
		continue:(ChargeRecord'="")  //已生成计费明细的不再进入计算
		
		set eventArcimId=""
		for
		{
			set eventArcimId = $o(^CF.AN.EventArcimI("IDetailItem",EventDetailItemId,eventArcimId))
			quit:eventArcimId=""
			
			set eventArcim =##class(CF.AN.EventArcim).%OpenId(eventArcimId)
			continue:(eventArcim.DetailValueRule'="")&&(eventArcim.DetailValueRule'=EventDetailRule)
			
			set ArcimID = eventArcim.ArcimID
			set unit = eventArcim.PackUom
			set doseUnit = eventArcim.DoseUom
			set doseUnitDesc = $p($g(^CT("UOM",+doseUnit)),"^",2)
			set execDept = eventArcim.RecvLoc
			set Instruction = eventArcim.Instruction
			set:eventArcim.DoseQty>0 dose=eventArcim.DoseQty
			set:eventArcim.PackQty>0 qty=eventArcim.PackQty
			set AlertQty = eventArcim.AlertQty
			set recvLoc=+##class(web.DHCDocOrderCommon).GetRecloc(EpisodeID,eventArcim.ArcimID)
			if (execDept="") set execDept=recvLoc
			
			///获取等效剂量单位
			set charginguomDrFirst="",charginguomDescFirst="",chargingQtyFirst=""
			set charginguomDrSecond="",charginguomDescSecond="",chargingQtySecond=""
			set EqualDoses=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.OEOrder:FindDrugEqual",eventArcim.ArcimID)
			set EqualDoseSize=EqualDoses.Size
			set specification=1
			
			for edIndex=1:1:EqualDoseSize
			{
				set equalUomId=EqualDoses.GetAt(edIndex).GetValue("uomDr")
				set equalUomDesc=EqualDoses.GetAt(edIndex).GetValue("uomDesc")
				set equalQty=EqualDoses.GetAt(edIndex).GetValue("qty")
				
				if equalUomId=doseUnit
				{
					set specification=equalQty
					quit
				}
			}
			
			set qty = dose \ specification
			if dose > (specification *qty)
			{
				set qty=qty + 1
			}
	
			set remainDose = (specification *qty) - dose
			set dose=$fn(dose,"",2)
			set prescribedDose = dose
			b ;01
			do AddChargeDetail(qty,dose,dose,DrugPriority,specification,eventDataRowId)
		}
	}
	
	//write "finished",!
	
	quit "S^"
	
AddChargeDetail(qty,prescribedDose,actualDose,priority,specification,eventDataRowId = "",anaDataRowId = "")
	kill data
	
	set data("ClassName")="CIS.AN.ChargeDetail"
	set data("ChargeRecord")=chargeRecordId
	set data("ChargeItem")=""
	set data("Qty")=qty
	set data("Unit")=unit
	set data("PrescribedDose")=prescribedDose
	set data("ActualDose")=actualDose
	set data("DoseUnit")=doseUnit
	set data("UpdateUser")=userId
	set data("CreateUser")=userId
	set data("BillDept")=deptId
	set data("ChargeDate")=+$h
	set data("ChargeTime")=$p($h,",",2)
	set data("ChargeTime")=data("ChargeTime")\60*60
	set data("ExecDept")=execDept
	set data("ArcimID")=ArcimID
	set data("Price")=##class(CIS.AN.COM.DataAdapter).GetArcimPrice(data("ArcimID"),"",operSchedule.EpisodeID)
	set data("ArcimDesc")=##class(CIS.AN.BL.Admission).GetArcimDesc(data("ArcimID"))
	set data("Status")="N"
	set data("Source")="A"
	set data("Priority")=priority
	set data("Instruction")=Instruction
	set data("AlertQty")=AlertQty
	
	set foundDetailId=$$GetUnchargedDetail(chargeRecordId,ArcimID)
	if foundDetailId'=""
	{
		set foundDetail=##class(CIS.AN.ChargeDetail).%OpenId(foundDetailId)
		if doseUnit=foundDetail.DoseUnit
		{
			set prescribedDose=prescribedDose+foundDetail.PrescribedDose
			set dose=dose+foundDetail.ActualDose
			
			set qty = dose \ specification
			if dose > (specification *qty)
			{
				set qty=qty + 1
			}
			
			set data("PrescribedDose")=prescribedDose
			set data("ActualDose")=dose
			set data("Qty")=qty
			set data("RowId")=foundDetailId
		}
	}
	
	//Write "found detail:",foundDetailId,!
	//write "adding charge detail:",data("ArcimDesc"),!
	set saveResult=##class(CIS.AN.COM.DataService).SaveData(.data)
	set chargeDetailId=+$p(saveResult,"^",2)
	if eventDataRowId'="" do BindEventData(eventDataRowId,chargeDetailId)
	if anaDataRowId'="" do BindAnaData(anaDataRowId,chargeDetailId)
	
	quit

BindEventData(eventDataRowId,chargeDetailId)
	quit:'##class(CIS.AN.ChargeDetail).%ExistsId(chargeDetailId)
	quit:'##class(CIS.AN.EventData).%ExistsId(eventDataRowId)
	
	set chargeDetail=##class(CIS.AN.ChargeDetail).%OpenId(chargeDetailId)
	set eventData=##class(CIS.AN.EventData).%OpenId(eventDataRowId)
	set eventData.ChargeDetail=chargeDetail
		
	do eventData.%Save()
	
	quit

BindAnaData(anaDataRowId,chargeDetailId)
	quit:'##class(CIS.AN.ChargeDetail).%ExistsId(chargeDetailId)
	quit:'##class(CIS.AN.AnaData).%ExistsId(anaDataRowId)
	
	set chargeDetail=##class(CIS.AN.ChargeDetail).%OpenId(chargeDetailId)
	set anaData=##class(CIS.AN.AnaData).%OpenId(anaDataRowId)
	set anaData.ChargeDetail=chargeDetail
		
	do anaData.%Save()
	
	quit

GetUnchargedDetail(chargeRecordId,arcimID)
	set foundDetailId="",detailId=""
	for
	{
		set detailId=$o(^CIS.AN.ChargeDetailI("IArcim",chargeRecordId," "_deptId," "_arcimID,detailId))
		quit:detailId=""
		
		set auditDate=$lg(^CIS.AN.ChargeDetailD(detailId),13)
		set:auditDate="" foundDetailId=detailId
		
		quit:foundDetailId
	}
	
	quit foundDetailId
}

/// 添加医嘱套进入记费明细
ClassMethod AddOrderSetToChargeDetail(opsId, ordersetId, deptId, userId, anaMethodId As %String = "", Catheter As %String = "") As %String
{
	set chargeRecordId=..GetChargeRecord(opsId,userId)
	if (##class(CIS.AN.ChargeRecord).%ExistsId(chargeRecordId)=0)
	{
		quit "E^收费记录单未生成。"	
	}
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set EpisodeID = operSchedule.EpisodeID
	set NORMPriority=+$o(^OECPR(0,"Code","NORM",""))
	set currentDate=+$h
	set found=0
	set dateId=""
	set chargeDetailId=""
	for
	{
		set dateId=$O(^ARCOS(ordersetId,"DATE",dateId),-1)
		quit:dateId=""
		quit:found
		
		set dateFrom=$p($g(^ARCOS(ordersetId,"Date",dateId)),"^",2)
		set dateTo=$p($g(^ARCOS(ordersetId,"Date",dateId)),"^",2)
		
		if (dateFrom<=currentDate)&&(dateTo>=currentDate) set found=1
		
		set itemId=0
		for
		{
			set itemId=$O(^ARCOS(ordersetId,"DATE",dateId,"ITM",itemId))
			b ;111
			quit:itemId=""
			
			set ArcimID=$p($g(^ARCOS(ordersetId,"DATE",dateId,"ITM",itemId)),"^",1)
			continue:ArcimID=""
			set qty=$p($g(^ARCOS(ordersetId,"DATE",dateId,"ITM",itemId)),"^",2)
			set uom=$p($g(^ARCOS(ordersetId,"DATE",dateId,"ITM",itemId)),"^",23)
			set Instruction=$p($g(^ARCOS(ordersetId,"DATE",dateId,"ITM",itemId)),"^",9)
			set dose=$p($g(^ARCOS(ordersetId,"DATE",dateId,"ITM",itemId)),"^",13)
			set actualDose=dose,prescribedDose=dose
			set doseUnit=$p($g(^ARCOS(ordersetId,"DATE",dateId,"ITM",itemId)),"^",10)
			set reloc=$p($g(^ARCOS(ordersetId,"DATE",dateId,"ITM",itemId)),"^",21)
			set chargeDetailId= $$AddChargeDetail(qty,prescribedDose,actualDose,NORMPriority,ArcimID,anaMethodId,Catheter)
		}
	}
	
	quit "S^"_chargeDetailId
AddChargeDetail(qty,prescribedDose,actualDose,priority,ArcimID,anaMethodId,Catheter)
	kill data
	
	set data("ClassName")="CIS.AN.ChargeDetail"
	set data("RowId")=""
	set data("ChargeRecord")=chargeRecordId
	set data("ChargeItem")=""
	set data("Qty")=qty
	set data("Unit")=uom
	set data("PrescribedDose")=prescribedDose
	set data("ActualDose")=actualDose
	set data("DoseUnit")=doseUnit
	set data("UpdateUser")=userId
	set data("CreateUser")=userId
	set data("BillDept")=deptId
	set data("ChargeDate")=+$h
	set data("ChargeTime")=$p($h,",",2)
	set data("ChargeTime")=data("ChargeTime")\60*60
	set data("ExecDept")=reloc
	if (reloc="") set data("ExecDept")=+##class(web.DHCDocOrderCommon).GetRecloc(EpisodeID,ArcimID)
	set data("ArcimID")=ArcimID
	set data("Price")=##class(CIS.AN.COM.DataAdapter).GetArcimPrice(ArcimID,"",operSchedule.EpisodeID)
	set data("ArcimDesc")=##class(CIS.AN.BL.Admission).GetArcimDesc(ArcimID)
	set data("Status")="N"
	set data("Source")="A"
	set data("Priority")=priority
	set data("Instruction")=Instruction
	set data("AlertQty")=""
	set data("AnaMethod")=anaMethodId
	set data("Catheter")=Catheter
	set saveResult=##class(CIS.AN.COM.DataService).SaveData(.data)
	b ;002
	set chargeDetailId=+$p(saveResult,"^",2)
	quit chargeDetailId
}

/// Creator：      	雍阳
/// CreatDate：    	2019-1-3
/// Description：   将记费明细转化为医嘱表对象
/// Table：        	DHCAN_Model.ChargeRecordDetail
/// Input:			chargeDetailId
/// Return：       	CIS.AN.BL.OEOrderItem
/// d ##class(CIS.AN.BL.ChargeRecord).ConvertChargeDetailToOEOrderItem(109)
ClassMethod ConvertChargeDetailToOEOrderItem(chargeDetailId) As CIS.AN.BL.OEOrderItem
{
	set chargeDetail=##class(CIS.AN.ChargeDetail).%OpenId(chargeDetailId)
	
	set result=##class(CIS.AN.BL.OEOrderItem).%New()
	
	set result.SingleDoseQty=chargeDetail.ActualDose
	set result.DoseQty=chargeDetail.PrescribedDose
	set result.DoseUom=chargeDetail.DoseUnit
	set result.ArcimID=chargeDetail.ArcimID
	set result.BillDept=chargeDetail.BillDept
	set result.ExecDept=chargeDetail.ExecDept
	set result.Instruction=""
	set:$IsObject(chargeDetail.Instruction) result.Instruction=chargeDetail.Instruction.ExternalID
	set result.EpisodeID=chargeDetail.ChargeRecord.OperSchedule.EpisodeID
	set result.AdmReason=$p(^PAADM(result.EpisodeID,1),"^",7)

	set result.PackQty=chargeDetail.Qty
	set result.PackUom=chargeDetail.Unit
	set result.Price=chargeDetail.Price
	
	set result.StartDate=chargeDetail.ChargeDate
	set result.StartTime=chargeDetail.ChargeTime
	set result.SeqNo=chargeDetail.%Id()
	set result.SkinTest="N"
	//set result.Priority=+$o(^OECPR(0,"Code","NORM",""))   //优先级 临时医嘱
	set result.Priority=chargeDetail.Priority
	
	set defDurId=0
	set phcduId=0
	for
	{
		set phcduId=$o(^PHCDU(phcduId)) 
		quit:(phcduId="")!(defDurId>0)
		quit:$p(^PHCDU(phcduId),"^",2)'=1
		set defDurId=phcduId
	}
	
	set result.Duration=$o(^PHCDU(0,"Code","1",""))  //疗程 默认 1天
	set result.MedicalInsurance=""
	set result.Note=""
	
	set opaId=chargeDetail.ChargeRecord.OperSchedule.ExternalID
	set result.Anaesthesia=$p(^DHCANOPArrange(opaId),"^",2)  //麻醉表ID
	set defFreqId=0,phcfrId=0
	set result.Frequency=$o(^PHCFR(0,"Code","ST",""))
	
	set arcimId=chargeDetail.ArcimID
	set itemCatId=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),1)),"^",10)
	set orderType=$p($g(^ARC("IC",itemCatId)),"^",7)
	set result.OrderType=orderType
	
	quit result
}

/// Creator：      	雍阳
/// CreatDate：    	2019-1-3
/// Description：   审核记费明细，并保存至医嘱表
/// Table：        	DHCAN_Model.ChargeRecordDetail
/// Input:			data:包含多个记费明细ID
/// Return：       	%String:result
/// w ##class(CIS.AN.BL.ChargeRecord).AuditChargeDetails($P(^tmpcshq("321"),"/",1),4133,93)
ClassMethod AuditChargeDetails(data As %String, userId As %String, locId As %String) As %String
{
	set result="S^"
	set sc=##class(CIS.AN.COM.String).ToArray(data,.array)
	//set ^tmpcshq("321")=data_"/"_userId_"/"_locId
	set index=0
	set EpisodeID=""
	for
	{
		set index=$o(array(index))
		quit:index=""
		
		continue:array(index,"ClassName")'="CIS.AN.ChargeDetail"
		
		set OEOrderItemList=##class(%ListOfObjects).%New()
		set rowId=array(index,"RowId")
		set chargeDetail=##class(CIS.AN.ChargeDetail).%OpenId(rowId)
		continue:(chargeDetail.AuditUser'="")||(chargeDetail.AuditDate'="")  ///已审核不再审核
		
		set OEOrderItem=..ConvertChargeDetailToOEOrderItem(rowId)
		set EpisodeID=OEOrderItem.EpisodeID
		set visitStatus=$p(^PAADM(EpisodeID),"^",20)
		if (visitStatus="D")
		{
			set result="E^该患者已出院，不能再审核医嘱！"
			quit
		}
		
		do OEOrderItemList.Insert(OEOrderItem)
		set insertrResult=##class(CIS.AN.BL.OEOrder).InsertOrderItem(EpisodeID,OEOrderItemList,userId,locId)
	
		set result="E^"
		if $p(insertrResult,"*",2)'=""
		{
			set result="S^"
			set ExternalID=$p(insertrResult,"*",2)
			set chargeDetail=##class(CIS.AN.ChargeDetail).%OpenId(rowId)
			set chargeDetail.AuditUser=userId
			set chargeDetail.AuditDate=+$h
			set chargeDetail.AuditTime=+$p($h,",",2)
			set chargeDetail.ExternalID=ExternalID
			set status=chargeDetail.%Save()
		}
		else
		{
			set result="E^"_insertrResult
		}
	}
	
	quit result
}

/// Creator：      	雍阳
/// CreatDate：    	2019-1-3
/// Description：   测试审核记费明细，并保存至医嘱表
/// Table：        	DHCAN_Model.ChargeRecordDetail
/// Input:			data:包含多个记费明细ID
/// Return：       	%String:result
/// d ##class(CIS.AN.BL.ChargeRecord).TestAudit(3,274,42)
ClassMethod TestAudit(chargeDetailId As %String, userId As %String, locId As %String) As %String
{
	set OEOrderItemList=##class(%ListOfObjects).%New()
	set index=0
	set EpisodeID=""
	set OEOrderItem=..ConvertChargeDetailToOEOrderItem(chargeDetailId)
	set EpisodeID=OEOrderItem.EpisodeID
	do OEOrderItemList.Insert(OEOrderItem)
	
	break //before Insert
	set result=##class(CIS.AN.BL.OEOrder).InsertOrderItem(EpisodeID,OEOrderItemList,userId,locId)
	
	quit result
}

ClassMethod GetChargeDetailIdByAnaMethod(chargeRecordID As %String, AnaMethod As %String) As %String
{
	quit:(##class(CIS.AN.ChargeRecord).%ExistsId(chargeRecordID)=0) ""
	set chargeDetailId=""
	&sql(select RowId into :chargeDetailId from CIS_AN.ChargeDetail where AnaMethod=:AnaMethod and ChargeRecord=:chargeRecordID)
	
	quit chargeDetailId
}

ClassMethod GetChargeDetailIdByCatheter(chargeRecordID As %String, Catheter As %String) As %String
{
	quit:(##class(CIS.AN.ChargeRecord).%ExistsId(chargeRecordID)=0) ""
	set chargeDetailId=""
	&sql(select RowId into :chargeDetailId from CIS_AN.ChargeDetail where Catheter=:Catheter and ChargeRecord=:chargeRecordID)
	
	quit chargeDetailId
}

}
