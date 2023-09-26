/// 手术相关统计
Class CIS.AN.BL.OperStatistic Extends %RegisteredObject
{

/// Creator：      	雍阳
/// CreatDate：    	2019-1-8
/// Description： 	查询麻醉病人统计
/// Table：        	CIS.AN.Anaesthesia
/// Input:			1.startDate:开始日期，2.endDate:结束日期
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.AnaesthesiaStatistic","FindPatient","2018-12-04","2018-12-04","")
Query FindSoreAssess(startDate As %String, endDate As %String, filterMedcareNo As %String = "") As %Query(ROWSPEC = "RowId,Date,PatDept,PatName,Gender,Age,MedcareNo,Operation,Surgeon,AnaDoctor,AssessNurseName,OperDuration,TheatreDuration,AnaestMethod,ScattTriggerResult,PreOperAssessmentResult,InOperAssessmentResult,PostOperAssessmentResult,NursingMeasures,VisitNurseName,PressureSore") [ SqlProc ]
{
}

ClassMethod FindSoreAssessExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, filterMedcareNo As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	set startDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(startDate,"")
	set endDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(endDate,"")
	if (startDateH>endDateH)
	{
		s qHandle=$lb(0,repid,0)
		q $$$OK	
	}
	
	set moduleCode="AnaestRecord"
	set indexNode="OPDate"
	
	for date=startDateH:1:endDateH
	{
		set dateStr=$zd(date,3)
		set Month=$e(dateStr,0,4)_"年"_$e(dateStr,6,7)_"月"
		set Day=$e(dateStr,9,10)
		set opsId=0
		for
		{
			set opsId=$order(^CIS.AN.OperScheduleI(indexNode,date,opsId))
			quit:(opsId="")
			
			set theatreInTime=##class(CIS.AN.BL.OperData).GetOperDataByCode(opsId,"OperCount","TheatreInTime")
			set theatreOutTime=##class(CIS.AN.BL.OperData).GetOperDataByCode(opsId,"OperCount","TheatreOutTime")
			continue:(theatreInTime="")!(theatreOutTime="")
		
			set assessNurse=##class(CIS.AN.BL.Signature).GetUserBySignature(opsId,"OperPressuresore","AssessmentNurseSign")
			continue:assessNurse=""
			set assessNurseUser=##class(CIS.AN.COM.Admission).GetUserIDByCareProv(assessNurse)
			set userInfo=##class(CIS.AN.COM.Admission).GetUserTypeName(assessNurseUser)
			set assessNurseName=$p(userInfo,"^",2)
			
			set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			set patDeptID=operSchedule.PatDeptID
			set patDeptDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",patDeptID)
		
			set PatName="",Gender="",Age="",MedcareNo=""
			set OperScheduleId=opsId
			set MedcareNo=""
			
			set patQuery=##class(%ResultSet).%New("CIS.AN.COM.Admission:FindPatient")
			set sc=patQuery.Execute(operSchedule.EpisodeID)
			while(patQuery.%Next())
			{
				set PatName=patQuery.Get("PatName")
				set Gender=patQuery.Get("PatGender")
				set Age=patQuery.Get("PatAge")	
				set MedcareNo=patQuery.Get("MedcareNo")
			}
			
			continue:(filterMedcareNo'="")&&(MedcareNo'[filterMedcareNo)
			
			set Operation=""
			
			set anaOperQuery=##class(%ResultSet).%New("CIS.AN.BL.OperationList:FindOperationList")
			set sc=anaOperQuery.Execute(opsId)
	
			set operationList="",surgeonList=""
			while(anaOperQuery.%Next())
			{
				set operationDesc=anaOperQuery.Get("OperationDesc")
				set operNote=anaOperQuery.Get("OperNote")
				set:operationDesc="" operationDesc=operNote
				set:operationDesc'="" operationList=operationList_$lb(operationDesc)
				
				set surgeon=anaOperQuery.Get("SurgeonDesc")
				set:surgeon'="" surgeonList=surgeonList_$lb(surgeon)
			}
			
			set operation=$ListToString(operationList,"+")
			set surgeon=$ListToString(surgeonList,",")
			set anaestMethod=##class(CIS.AN.BL.OperSchedule).GetAnaestMethod(opsId)
			
			set anesthesiologist=operSchedule.Anesthesiologist
			set anesthesiologistDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTCareProv","CTPCPDesc",anesthesiologist)
			set:(anesthesiologistDesc="") anesthesiologistDesc=anesthesiologist
	
			set theatreDuration=$e(theatreInTime,12,19)_"~"_$e(theatreOutTime,12,19)
			
			set operStartDT=operSchedule.OperStartDT
			set operEndDT=operSchedule.OperFinishDT
			set operDuration=$e(operStartDT,12,19)_"~"_$e(operEndDT,12,19)
			
			set ScattTriggerResult=##class(CIS.AN.BL.OperData).GetOperDataByCode(opsId,"OperPressuresore","ScattTriggerResult")
			set PreOperAssessmentResult=##class(CIS.AN.BL.OperData).GetOperDataByCode(opsId,"OperPressuresore","PreOperAssessmentResult")
			set InOperAssessmentResult=##class(CIS.AN.BL.OperData).GetOperDataByCode(opsId,"OperPressuresore","InOperAssessmentResult")
			set PostOperAssessmentResult=##class(CIS.AN.BL.OperData).GetOperDataByCode(opsId,"OperPressuresore","PostOperAssessmentResult")
			
			set nursingMeasures=""
			set RelievePressure=##class(CIS.AN.BL.OperData).GetOperDataByCode(opsId,"OperPressuresore","RelievePressure")
			set RelievePressureText=##class(CIS.AN.BL.OperData).GetOperDataByCode(opsId,"OperPressuresore","RelievePressureText")
			set BasicNursing=##class(CIS.AN.BL.OperData).GetOperDataByCode(opsId,"OperPressuresore","BasicNursing")
			set LocalProcessing=##class(CIS.AN.BL.OperData).GetOperDataByCode(opsId,"OperPressuresore","LocalProcessing")
			set LocalProcessingText=##class(CIS.AN.BL.OperData).GetOperDataByCode(opsId,"OperPressuresore","LocalProcessingText")
			set nursingMeasures="减轻压力: "_RelievePressure_" "_RelievePressureText_"<br>基础护理: "_BasicNursing_"<br>局部处理: "_LocalProcessing_" "_LocalProcessingText
			
			set visitNurseName=""
			set visitNurse=##class(CIS.AN.BL.Signature).GetUserBySignature(opsId,"OperPressuresore","VisitNurseSign")
			if visitNurse'=""
			{
				set visitNurseUser=##class(CIS.AN.COM.Admission).GetUserIDByCareProv(visitNurse)
				set userInfo=##class(CIS.AN.COM.Admission).GetUserTypeName(visitNurseUser)
				set visitNurseName=$p(userInfo,"^",2)
			}
			
			set PressureSore=##class(CIS.AN.BL.OperData).GetOperDataByCode(opsId,"OperPressuresore","PressureSore")
			
			do restoreOutput
		}	
	}
	
	set date=""
	for
	{
		set date=$o(outputList(date))
		quit:date=""
		
		set assessNurseUser=""
		for
		{
			set assessNurseUser=$o(outputList(date,assessNurseUser))
			quit:assessNurseUser=""
			
			set opsId=""
			for
			{
				set opsId=$o(outputList(date,assessNurseUser,opsId))
				quit:opsId=""
				
				set data=outputList(date,assessNurseUser,opsId)
				do OutputRow
			}
		}
	}
	s qHandle=$lb(0,repid,0)
	q $$$OK

restoreOutput
	set outputList(date,assessNurseUser,opsId)=$lb(opsId,dateStr,patDeptDesc,PatName,Gender,
								Age,MedcareNo,operation,surgeon,anesthesiologistDesc,
								assessNurseName,operDuration,theatreDuration,anaestMethod,ScattTriggerResult,
								PreOperAssessmentResult,InOperAssessmentResult,PostOperAssessmentResult,nursingMeasures,visitNurseName,
								PressureSore)
	quit

OutputRow
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1
	q
}

ClassMethod FindSoreAssessFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSoreAssessExecute ]
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

ClassMethod FindSoreAssessClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSoreAssessExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// Creator：      	雍阳
/// CreatDate：    	2019-1-8
/// Description： 	查询麻醉病人统计
/// Table：        	CIS.AN.Anaesthesia
/// Input:			1.startDate:开始日期，2.endDate:结束日期
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.OperStatistic","FindChargeDetails","2019-04-18","2019-04-18","116")
Query FindChargeDetails(startDate As %String, endDate As %String, deptId As %String, filterItemId As %String = "", medcareNo As %String = "") As %Query(ROWSPEC = "CRDRowId,PatName,PatGender,PatAge,PatDeptDesc,PatBedCode,MedcareNo,RegNo,OperationDesc,OperDate,SurgeonDesc,AnesthesiologistDesc,ScrubNurseDesc,CircualNurseDesc,ChargeItemDesc,ChargeQty,ChargeDate,Price,TotalPrice,ChargeUomDesc,PrescNo,StatusDesc,BillStatus,InstrDesc,AuditUserDesc") [ SqlProc ]
{
}

ClassMethod FindChargeDetailsExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, deptId As %String, filterItemId As %String = "", medcareNo As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	set startDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(startDate,"")
	set endDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(endDate,"")
	if (startDateH>endDateH)
	{
		s qHandle=$lb(0,repid,0)
		q $$$OK	
	}
	for i=startDateH:1:endDateH
	{
		set arcimID=""
		for	
		{
			set arcimID=$o(^CIS.AN.ChargeRecordDetailI("ArcimDate",i," "_deptId,arcimID))
			quit:(arcimID="")
			continue:(filterItemId'="")&((" "_filterItemId)'=arcimID)
			set CRDRowId=""
			for
			{
				set CRDRowId=$o(^CIS.AN.ChargeRecordDetailI("ArcimDate",i," "_deptId,arcimID,CRDRowId))
				quit:(CRDRowId="")
				set CRDInfo=##class(CIS.AN.ChargeRecordDetail).%OpenId(CRDRowId)
				continue:(CRDInfo.Status'="A")		// 只取已审核的医嘱
				set EpisodeID=CRDInfo.ChargeRecord.OperSchedule.EpisodeID
				set curMedCareNo=##class(CIS.AN.COM.Admission).GetMedicareNo("",EpisodeID)
				continue:(medcareNo'="")&(curMedCareNo'=medcareNo)
				set opsId=CRDInfo.ChargeRecord.OperSchedule.%Id()
				set opsObj=##class(CIS.AN.COM.Query).ToObject("CIS.AN.BL.OperScheduleStatistics:FindOperScheduleList","","","",opsId)
				set patName=opsObj.GetValue("PatName")
				set patGender=opsObj.GetValue("PatGender")
				set patAge=opsObj.GetValue("PatAge")
				set patDeptDesc=opsObj.GetValue("PatDeptDesc")
				set patBedCode=opsObj.GetValue("PatBedCode")
				set curMedcareNo=opsObj.GetValue("MedcareNo")
				set regNo=opsObj.GetValue("RegNo")
				set operationDesc=opsObj.GetValue("OperInfo")
				set operDate=opsObj.GetValue("OperDate")
				set surgeonDesc=opsObj.GetValue("SurgeonDesc")
				set anesthesiologistDesc=opsObj.GetValue("AnesthesiologistDesc")
				set scrubNurseDesc=opsObj.GetValue("ScrubNurseDesc")
				set circualNurseDesc=opsObj.GetValue("CircualNurseDesc")
				set chargeItemDesc=CRDInfo.ChargeItemDesc
				set chargeQty=+CRDInfo.ChargeQty
				set chargeDate=##class(CIS.AN.COM.DateTime).ConvertToDate(CRDInfo.ChargeDate,"")
				set price=+CRDInfo.Price
				set totalPrice=price*chargeQty
				set chargeUomDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTUOM","CTUOMDesc",CRDInfo.ChargeUom)
				set prescNo=##class(CIS.AN.COM.String).GetDescByID("User.OEOrdItem","OEORIPrescNo",CRDInfo.ExternalID)
				set statusDesc=##class(CIS.AN.ChargeRecordDetail).StatusLogicalToDisplay(CRDInfo.Status)
				set ordExecInfo=##class(CIS.AN.BL.ChargeRecord).GetOrdExecInfo(CRDInfo.ExternalID)
				set billStatus=$p(ordExecInfo,"#",1)
				set instrDesc=##class(CIS.AN.COM.String).GetDescByID("User.PHCInstruc","PHCINDesc1",CRDInfo.Instruction)
				set auditUserDesc=##class(CIS.AN.COM.String).GetDescByID("User.SSUser","SSUSRName",CRDInfo.AuditUser)
				do OutputRow
			}	
		}
	}
	s qHandle=$lb(0,repid,0)
	q $$$OK

OutputRow
	s ^CacheTemp(repid,ind)=$lb(CRDRowId,patName,patGender,patAge,patDeptDesc,patBedCode,curMedcareNo,regNo,operationDesc,operDate,surgeonDesc,anesthesiologistDesc,scrubNurseDesc,circualNurseDesc,chargeItemDesc,chargeQty,chargeDate,price,totalPrice,chargeUomDesc,prescNo,statusDesc,billStatus,instrDesc,auditUserDesc)
	s ind=ind+1
	q
}

ClassMethod FindChargeDetailsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindChargeDetailsExecute ]
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

ClassMethod FindChargeDetailsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindChargeDetailsExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// Creator：      	雍阳
/// CreatDate：    	2019-1-8
/// Description： 	查询麻醉病人统计
/// Table：        	CIS.AN.Anaesthesia
/// Input:			1.startDate:开始日期，2.endDate:结束日期
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.OperStatistic","FindChargeSum","2019-04-18","2019-04-18","116")
Query FindChargeSum(startDate As %String, endDate As %String, deptId As %String, filterItemId As %String = "", medcareNo As %String = "", orderCategoryId As %String = "", itemCatId As %String = "") As %Query(ROWSPEC = "ArcimID,ChargeItemDesc,ChargeUomDesc,TotalQty,TotalPrice,OrderCatId,OrderCatDesc,ItemCatId,ItemCatDesc") [ SqlProc ]
{
}

ClassMethod FindChargeSumExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, deptId As %String, filterItemId As %String = "", medcareNo As %String = "", orderCategoryId As %String = "", itemCatId As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	set startDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(startDate,"")
	set endDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(endDate,"")
	if (startDateH>endDateH)
	{
		s qHandle=$lb(0,repid,0)
		q $$$OK	
	}
	k dataArr
	set itemCount=1
	for i=startDateH:1:endDateH
	{
		set arcimID=""
		for	
		{
			set arcimID=$o(^CIS.AN.ChargeRecordDetailI("ArcimDate",i," "_deptId,arcimID))
			quit:(arcimID="")
			continue:(filterItemId'="")&((" "_filterItemId)'=arcimID)
			set curArcimID=$tr(arcimID," ","")
			do ##class(CIS.AN.BL.OEOrder).GetArimByID(curArcimID,.arcimArr)
			set curOrderCatId=arcimArr(1,"OrderCatId")
			continue:(orderCategoryId'="")&(orderCategoryId'=curOrderCatId)
			set curItemCatId=arcimArr(1,"ItemCatId")
			continue:(itemCatId'="")&(itemCatId'=curItemCatId)
			set curOrderCatDesc=arcimArr(1,"OrderCatDesc")
			set curItemCatDesc=arcimArr(1,"ItemCatDesc")
			set CRDRowId="",totalChargeQty=0,totalPrice=0,chargeItemDesc="",chargeUomDesc=""
			for
			{
				set CRDRowId=$o(^CIS.AN.ChargeRecordDetailI("ArcimDate",i," "_deptId,arcimID,CRDRowId))
				quit:(CRDRowId="")
				set CRDInfo=##class(CIS.AN.ChargeRecordDetail).%OpenId(CRDRowId)
				continue:(CRDInfo.Status'="A")		// 只取已审核的医嘱
				set EpisodeID=CRDInfo.ChargeRecord.OperSchedule.EpisodeID
				set curMedCareNo=##class(CIS.AN.COM.Admission).GetMedicareNo("",EpisodeID)
				continue:(medcareNo'="")&(curMedCareNo'=medcareNo)
				set chargeItemDesc=CRDInfo.ChargeItemDesc
				set totalChargeQty=totalChargeQty+CRDInfo.ChargeQty
				set chargeDate=##class(CIS.AN.COM.DateTime).ConvertToDate(CRDInfo.ChargeDate,"")
				set price=+CRDInfo.Price
				set totalPrice=totalPrice+(price*CRDInfo.ChargeQty)
				set chargeUomDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTUOM","CTUOMDesc",CRDInfo.ChargeUom)
			}
			continue:(chargeItemDesc="")
			set dataArr($tr(arcimID," ",""),itemCount)=$lb(chargeItemDesc,totalChargeQty,totalPrice,chargeUomDesc,curOrderCatId,curOrderCatDesc,curItemCatId,curItemCatDesc)	
			set itemCount=itemCount+1
		}
	}
	
	set arcimID=""
	for
	{
		set arcimID=$o(dataArr(arcimID))
		quit:(arcimID="")
		set itemIndex=0,totalQty=0,totalPrice=0,chargeItemDesc="",chargeUomDesc="",orderCatId="",orderCatDesc="",ARCItemCatId="",itemCatDesc=""
		for
		{
			set itemIndex=$o(dataArr(arcimID,itemIndex))
			quit:(itemIndex="")
			set totalQty=totalQty+$lg(dataArr(arcimID,itemIndex),2)
			set totalPrice=totalPrice+$lg(dataArr(arcimID,itemIndex),3)
			set chargeItemDesc=$lg(dataArr(arcimID,itemIndex),1)
			set chargeUomDesc=$lg(dataArr(arcimID,itemIndex),4)
			set orderCatId=$lg(dataArr(arcimID,itemIndex),5)
			set orderCatDesc=$lg(dataArr(arcimID,itemIndex),6)
			set ARCItemCatId=$lg(dataArr(arcimID,itemIndex),7)
			set itemCatDesc=$lg(dataArr(arcimID,itemIndex),8)
		}	
		do OutputRow
	}
	s qHandle=$lb(0,repid,0)
	q $$$OK

OutputRow
	s ^CacheTemp(repid,ind)=$lb(arcimID,chargeItemDesc,chargeUomDesc,totalQty,totalPrice,orderCatId,orderCatDesc,ARCItemCatId,itemCatDesc)
	s ind=ind+1
	q
}

ClassMethod FindChargeSumFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindChargeSumExecute ]
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

ClassMethod FindChargeSumClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FFindChargeSumExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

ClassMethod GetChargeSum(startDate As %String, endDate As %String, deptId As %String, filterItemId As %String = "", medcareNo As %String = "", orderCategoryId As %String = "", itemCatId As %String = "") As %String
{
	set rs=##class(%ResultSet).%New("CIS.AN.BL.OperStatistic:FindChargeSum")
	set sc=rs.Execute(startDate,endDate,deptId,filterItemId,medcareNo,orderCategoryId,itemCatId)
	while(rs.%Next())
	{
		set price=rs.Get("TotalPrice")	
	}
}

/// 202003+dyl+手术包统计
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.OperStatistic","MaterialList","2020-02-27","","N")
Query MaterialList(stdate, enddate, showDetail As %String = "N") As %Query(ROWSPEC = "opaId,room,ordno,Id,tcssdr,cssdpack,tnumber,opName,regNo,patName")
{
}

ClassMethod MaterialListExecute(ByRef qHandle As %Binary, stdate, enddate, showDetail As %String = "N") As %Status
{
	s repid=$i(^CacheTemp)
 	s ind=1
 	s sdate=##Class(web.DHCANOPCom).ConvertToDateH(stdate)
	s edate=##Class(web.DHCANOPCom).ConvertToDateH(enddate)
	k roomList,cssdList
	
 	f date=sdate:1:+edate d
	.s opaId=""
	.f  s opaId=$O(^CIS.AN.OperScheduleI("OPDate",date,opaId)) q:opaId=""  d
		..set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opaId)
		..s oproomdr=operSchedule.OperRoom
		..s oproom=""
		..i oproomdr'="" s oproomdr=operSchedule.OperRoom.%Id(),oproom=operSchedule.OperRoom.Description
		..q:oproom=""
		..s opordno=operSchedule.OperSeq 
		..i +opordno=0 s opordno="未排"
		..s roomList(oproom,opordno,opaId)=""
	s tmproomdr="" 
	f  s tmproomdr=$o(roomList(tmproomdr)) q:tmproomdr=""  d
		.s tmpord=""
		.f  s tmpord=$o(roomList(tmproomdr,tmpord)) q:tmpord=""  d
			..s tmpopaId=""
			..f  s tmpopaId=$o(roomList(tmproomdr,tmpord,tmpopaId)) q:tmpopaId=""  d
				...set operScheduleObj=##class(CIS.AN.OperSchedule).%OpenId(tmpopaId)
				...s admId=operScheduleObj.EpisodeID
				...set patInfoObj=##class(CIS.AN.COM.Query).ToObject("CIS.AN.BL.Admission:FindPatient",admId)
		 		...s papmiId=patInfoObj.GetValue("PatientID")
		 		...s regNo=patInfoObj.GetValue("RegNo")
		 		...s patName=patInfoObj.GetValue("PatName")
		 		...s planOperData=##class(CIS.AN.BL.OperScheduleList).GetPlanOperList(tmpopaId,.planOperData)
		 		...s opName=planOperData(1,"OperationDesc")
				...s sheetId="" 
				...f  s sheetId=$o(^CIS.AN.RecordSheetI("IOPS",tmpopaId,sheetId)) q:sheetId=""  d
					....s sheetObj=##class(CIS.AN.RecordSheet).%OpenId(sheetId)
					....s DataModule=sheetObj.DataModule.Code
					....q:DataModule'="AN_OPS_016"
					....s matId=""  f  s matId=$o(^CIS.AN.MaterialPackI("IMPack",sheetId,matId)) q:matId=""  d
						.....s materialList=##class(CIS.AN.MaterialPack).%OpenId(matId)
						.....q:'($isobject(materialList.MaterialPackId))
						.....s tcssdr = materialList.MaterialPackId.%Id()
						.....s cssdpack=materialList.MaterialPackId.Description
						.....s tnumber=materialList.MaterialNumber
						.....s cssdList(tcssdr,matId)=cssdpack_"^"_tnumber
						.....q:showDetail="N"
					 	.....d OutPutdetail
		 		...d OutPutRoomTotal
 	s cssdid=""
 	f  s cssdid=$o(cssdList(cssdid)) q:cssdid=""  d
 		.s singlenum=0
 		.s cssdopaId="" f  s cssdopaId=$o(cssdList(cssdid,cssdopaId)) q:cssdopaId=""  d
 			..s cssdpack=$p(cssdList(cssdid,cssdopaId),"^",1)
 			..s num=$p(cssdList(cssdid,cssdopaId),"^",2)
 			..s singlenum=singlenum+num
 		.d OutPutTotalPack
 	s qHandle=$lb(0,repid,0)
	q $$$OK

OutPutTotalPack
 	s Data=$lb("总计","","","",cssdid,cssdpack,singlenum,"","","")
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q 0
 		
OutPutdetail
	
 	s Data=$lb("","","",Id,tcssdr,cssdpack,tnumber,"","","")
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q 0
 	
OutPutRoomTotal
	q:showDetail="N"
 	s Data=$lb(tmpopaId,tmproomdr,tmpord,"-","-","-","-",opName,regNo,patName)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q 0
}

ClassMethod MaterialListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MaterialListExecute ]
{
	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {
 		s AtEnd=1
 		s Row=""
 	}
 	else {			
 		s Row=^CacheTemp(repid,ind)
 		//w "<b>"_$List(Row,3)_"</b>"
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod MaterialListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MaterialListExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

Query FindPostVisitInvest(startDate As %String, endDate As %String) As %Query(ROWSPEC = "PatName,MedicareNo,DeptDesc,AnaMethodDesc,Analgesia,SpecialCondition,TreatMeasures,PCIAFormula,AnaDoctorDesc") [ SqlProc ]
{
}

ClassMethod FindPostVisitInvestExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String) As %Status
{
	
	set startDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(startDate,"")
	set endDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(endDate,"")
	if (startDateH>endDateH)
	{
		s qHandle=$lb(0,repid,0)
		q $$$OK	
	}
	for date=startDateH:1:endDateH
	{
		set opsId=0
		for
		{
			set opsId=$order(^CIS.AN.OperScheduleI("OPDate",date,opsId))
			quit:(opsId="")
			s PatName="",MedicareNo="",DeptDesc="",AnaMethodDesc="",Analgesia="",SpecialCondition="",TreatMeasures="",PCIAFormula="",AnaDoctorDesc=""
			set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			set statusCode=$System.SQL.UPPER(operSchedule.Status.Code)
			continue:((statusCode'="FINISH")&(statusCode'="AREAOUT"))
			set PatName=operSchedule.PatName
			set MedicareNo=##class(CIS.AN.BL.Admission).GetMedicareNo("",operSchedule.EpisodeID)
			set DeptDesc=operSchedule.AppDeptID.Description
			set anaestObj=##class(CIS.AN.COM.Query).ToObject("CIS.AN.BL.Anaesthesia:FindAnaesthesia",opsId)
			set AnaMethod=anaestObj.GetValue("AnaMethod")				// 麻醉方法ID
			set AnaMethodDesc=##class(CIS.AN.COM.String).GetDescByID("CT.AN.AnaMethod","Description",AnaMethod)	// 麻醉方法名称
			set AnaDoctorDesc=anaestObj.GetValue("AnesthesiologistDesc")
			//^CIS.AN.AnaesthesiaI("IOPS")
			set AnaesthesiaId=$o(^CIS.AN.AnaesthesiaI("IOPS",opsId,0))
			if ((AnaesthesiaId'="")&&(##class(CIS.AN.Anaesthesia).%ExistsId(AnaesthesiaId)))
			{
				set Anaesthesia=##class(CIS.AN.Anaesthesia).%OpenId(AnaesthesiaId)
				//set Analgesia=Anaesthesia.AnalgesiaWay
				set:Analgesia="PCIA" PCIAFormula=Anaesthesia.PostAnalgesia
			}
			set ^CacheTemp(repid,ind)=$lb(PatName,MedicareNo,DeptDesc,AnaMethodDesc,Analgesia,SpecialCondition,TreatMeasures,PCIAFormula,AnaDoctorDesc)
			set qHandle=$lb(0,repid,0)
			set ind=ind+1
		}
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod FindPostVisitInvestFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
	Set AtEnd=1
	Set Row=""
	}
	Else      {				// fetch row
	Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindPostVisitInvestClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

// d ##class(CIS.AN.BL.OperStatistic).GetOperList("2020-04-01","2020-04-21","298",^TMPCCQ("GetOperList","ExtInfo"),"1","100")

ClassMethod GetOperList(startDate As %String, endDate As %String, deptId As %String, extInfo As %String = "", page As %String = "0", rows As %String = "0") As %String
{
	set ^TMPCCQ("GetOperList","ExtInfo")=extInfo
	set rs=##class(%ResultSet).%New("CIS.AN.BL.OperScheduleList:FindOperScheduleList")
	set sc=rs.Execute(startDate,endDate,deptId)
	if (extInfo'="")
	{
		do ##class(CIS.AN.COM.String).ToArray(extInfo,.extArray)
		set queryCount=0
		set extIndex=0
		for
		{
			set extIndex=$o(extArray(extIndex))
			quit:(extIndex="")
			set queryCount=queryCount+1
		}
	}
	
	set condition=""
	
	set pageNo=+page
	set rows=+rows
	set startRowNo=0
	if (pageNo>0)&(rows>0)
	{
		set startRowNo=(pageNo-1)*rows	
	}
	set colCount=rs.GetColumnCount()
	set rowNo=0,displayRows=0
	if (rows>0)
	{
		write "{"_"""rows"":["	
	}
	else
	{
		write "["	
	}
	k ^TMPCCQ("OperListQuery",$j)
	while(rs.%Next())
	{
		set extIndex=0,condition=""
		if (extInfo'="")
		{
			for
			{
				set extIndex=$o(extArray(extIndex))
				quit:(extIndex="")
				set queryCode=extArray(extIndex,"Code")
				set operator=extArray(extIndex,"Operator")
				set queryValue=extArray(extIndex,"Value")
				set logical=extArray(extIndex,"Logical")
				set operType=extArray(extIndex,"OperType")
				set operChar=$case(+operator,0:"=",1:"'=",2:">",3:"<",4:">=",5:"<=")
				set:(operType="text") operChar=$case(+operator,0:"=",1:"'=",2:"[",3:"'[")
				set logicalChar=$case(+logical,0:"&",1:"!",:"")
				set dataValue=rs.Get(queryCode)
				
				set:(operType="text") condition=condition_"("""_dataValue_""" "_operChar_" """_queryValue_""")"
				set:(operType="number") condition=condition_"("_(+dataValue)_" "_operChar_" "_(+queryValue)_")"
				set:(extIndex<queryCount) condition=condition_logicalChar
			}
			if (condition'="")
			{
				b //ccq
				s str="^TMPCCQ(""OperListQuery"","_$j_")=("_condition_")"
				s @str
				continue:'(^TMPCCQ("OperListQuery",$j))	
			}
		}
		
		
		if ((rowNo>=startRowNo)&&(displayRows<rows))!(rows=0)
		{
			write:(displayRows>0) ","
			write "{"
			set rowData=""
			for colIndex=1:1:colCount
			{
				set colName=rs.GetColumnName(colIndex)
				set currentData=rs.GetData(colIndex)
				continue:(colName="_parentId")&(currentData="")
				set:(colIndex>1) rowData=rowData_","
				set value=rs.GetData(colIndex)
				set value=$replace(value,$c(10),"\n")
				set rowData=rowData_""""_rs.GetColumnName(colIndex)_""":"_""""_value_""""	
			}	
			write rowData
			write "}",!
			set displayRows=displayRows+1
		}
		set rowNo=rowNo+1
	}
	
	if (rows>0)
	{
		write "]"_",""total"":"_rowNo_"}"	
	}
	else
	{
		write "]"	
	}
	
	quit ""
}

}
