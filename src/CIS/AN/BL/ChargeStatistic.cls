/// 记费统计
Class CIS.AN.BL.ChargeStatistic Extends %RegisteredObject
{

/// 记费项目统计
ClassMethod GetAnDocChargeStat(deptId, startDate, endDate) As %String
{
	set startDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(startDate,"")
	set endDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(endDate,"")
	quit:(startDateH>endDateH) "{""rows"":[]}"
	
	set indexNode="OPDate"
	
	for date=startDateH:1:endDateH
	{
		set opsId=0
		for
		{
			set opsId=$order(^CIS.AN.OperScheduleI(indexNode,date,opsId))
			quit:(opsId="")
		}
	}
	
SingleChargeRecord(opsId)
	set chargeDetails=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.ChargeStatistic:FindChargeRecordDetails",deptId,opsId)
}

/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ChargeStatistic","FindChargeRecordDetails",14,"14556")
Query FindChargeRecordDetails(deptId As %String, chargeRecordId As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT *,
	   Unit As UnitDesc,
	   ChargeItem->ChargeCategory As ChargeCategory,
	   ChargeItem->ChargeCategory->Description As ChargeCategoryDesc
	   from CIS_AN.ChargeDetail
	   where BillDept=:deptId and ChargeRecord=:chargeRecordId
}

/// Creator：      	雍阳
/// CreatDate：    	2018-12-06
/// Description： 	分日期统计麻醉医生工作量
/// Table：        	CIS.AN.OperSchedule
/// Input:			1.startDate:开始日期，2.endDate:结束日期，3.andocId:麻醉医生ID
/// Return：       	ResultSet
/// w ##class(CIS.AN.BL.ChargeStatistic).HasChargeDetail("14","121321")
ClassMethod HasChargeDetail(deptId As %String, opsId As %String) As %String
{
	set result=""
	set chargeRecordId=$o(^CIS.AN.ChargeRecordI("OperSchedule",opsId,""))
	if chargeRecordId=0 quit ""
	
	&sql(SELECT top 1 RowId into :result
	   from CIS_AN.ChargeDetail
	   where BillDept=:deptId and ChargeRecord=:chargeRecordId)
	   
	quit result
}

/// Creator：      	雍阳
/// CreatDate：    	2018-12-06
/// Description： 	分日期统计麻醉医生工作量
/// Table：        	CIS.AN.OperSchedule
/// Input:			1.startDate:开始日期，2.endDate:结束日期，3.andocId:麻醉医生ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ChargeStatistic","NarcoticStatistic","2018-12-29","2018-12-29", "14")
Query NarcoticStatistic(startDate As %String, endDate As %String, deptId As %String) As %Query(ROWSPEC = "AnaDoctor,AnaDoctorId,UserId,Qty1,Qty2,Qty3,Qty4,Qty5,Qty6,Qty7,Qty8,Signed") [ SqlProc ]
{
}

ClassMethod NarcoticStatisticExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, deptId As %String) As %Status
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
	
	set indexNode="OPDate"	
	kill resultList
	
	for date=startDateH:1:endDateH+1
	{
		set opsId=0
		for
		{
			set opsId=$order(^CIS.AN.OperScheduleI(indexNode,date,opsId))
			quit:(opsId="")
			
			set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			set anesthesiologist=operSchedule.Anesthesiologist
			set anaExpert=operSchedule.AnaExpert
			
			set:anesthesiologist="" anesthesiologist=anaExpert
			
			continue:anesthesiologist="" //无麻醉医生不计算
			
			set statusCode=operSchedule.Status.Code
			continue:(statusCode'="RoomOut")&&(statusCode'="Finish")&&(statusCode'="PACUIn")
			continue:operSchedule.AnaStartDT=""  //无麻醉开始时间不计算
			
			set theatreInDT=operSchedule.TheatreInDT
			set theatreInTime=$e(theatreInDT,12,19)
			set theatreInTimeH=##class(CIS.AN.COM.DateTime).ConvertToTimeH(theatreInTime,"")
			continue:(date=startDateH)&&(theatreInTimeH<21600)
			continue:(date>endDateH)&&(theatreInTimeH>=21600)
			
			set anesthesiologistDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTCareProv","CTPCPDesc",anesthesiologist)

			set resultList(anesthesiologistDesc)=anesthesiologist
			do InquireChargeRecord(opsId)
		}
	}
	
	kill anaDoctorSeqs
	set anaDoctorSeqs(1,"张勤功")=1
	set anaDoctorSeqs(2,"邓丽云")=2
	set anaDoctorSeqs(3,"刘毅")=3
	set anaDoctorSeqs(4,"程周军")=4
	set anaDoctorSeqs(5,"王根才")=5
	set anaDoctorSeqs(6,"王汉川")=6
	set anaDoctorSeqs(7,"武毅彬")=7
	set anaDoctorSeqs(8,"李树鹏")=8
	set anaDoctorSeqs(9,"冯晋潞")=9
	set anaDoctorSeqs(10,"吕进")=10
	set anaDoctorSeqs(11,"白日虹")=11
	set anaDoctorSeqs(12,"牛悦峰")=12
	set anaDoctorSeqs(13,"杜轶鹏")=13
	set anaDoctorSeqs(14,"康荣")=14
	set anaDoctorSeqs(15,"韩静")=15
	set anaDoctorSeqs(16,"郭晋铎")=16
	set anaDoctorSeqs(17,"田旻")=17
	set anaDoctorSeqs(18,"李国华")=18
	set anaDoctorSeqs(19,"常钧")=19
	set anaDoctorSeqs(20,"贾志勇")=20
	set anaDoctorSeqs(21,"侯磊")=21
	set anaDoctorSeqs(22,"李宇")=22
	set anaDoctorSeqs(23,"张建平")=23
	set anaDoctorSeqs(24,"蔡越")=24
	set anaDoctorSeqs(25,"朱毅")=25
	set anaDoctorSeqs(26,"金星")=26
	set anaDoctorSeqs(27,"翁晋晖")=27
	set anaDoctorSeqs(28,"赵艳丽")=28
	set anaDoctorSeqs(29,"那志萍")=29
	set anaDoctorSeqs(30,"张晓婷")=30
	set anaDoctorSeqs(31,"高昶蕤")=31
	set anaDoctorSeqs(32,"王宏")=32
	set anaDoctorSeqs(33,"王宏志")=33
	set anaDoctorSeqs(34,"张劲")=34
	set anaDoctorSeqs(35,"韩潞潞")=35
	set anaDoctorSeqs(36,"赵丽")=36
	set anaDoctorSeqs(37,"牛静")=37
	set anaDoctorSeqs(38,"刘娜")=38
	set anaDoctorSeqs(39,"刘超杰")=39
	set anaDoctorSeqs(40,"崔昕龙")=40

	kill rowTotal
	
	kill resultList("崔昕龙")
	
	set anaDoctorSeq=""
	for
	{
		set anaDoctorSeq=$o(anaDoctorSeqs(anaDoctorSeq))
		quit:anaDoctorSeq=""
		
		kill row
		set anesthesiologistDesc=$o(anaDoctorSeqs(anaDoctorSeq,""))
		set row("AnaDoctor")=anesthesiologistDesc
		set row("AnaDoctorId")=$g(resultList(anesthesiologistDesc))
		set row("UserId")=""
		set:row("AnaDoctorId")'="" row("UserId")=$o(^SSU("SSUSR",0,"CTPCP",row("AnaDoctorId"),""))
		set row("Qty1")=$g(resultList(anesthesiologistDesc,246))
		set rowTotal("Qty1")=$g(rowTotal("Qty1"))+row("Qty1")
		set row("Qty2")=$g(resultList(anesthesiologistDesc,247))
		set rowTotal("Qty2")=$g(rowTotal("Qty2"))+row("Qty2")
		set row("Qty3")=$g(resultList(anesthesiologistDesc,245))
		set rowTotal("Qty3")=$g(rowTotal("Qty3"))+row("Qty3")
		set row("Qty4")=$g(resultList(anesthesiologistDesc,248))
		set rowTotal("Qty4")=$g(rowTotal("Qty4"))+row("Qty4")
		set row("Qty5")=$g(resultList(anesthesiologistDesc,250))
		set rowTotal("Qty5")=$g(rowTotal("Qty5"))+row("Qty5")
		set row("Qty6")=$g(resultList(anesthesiologistDesc,251))
		set rowTotal("Qty6")=$g(rowTotal("Qty6"))+row("Qty6")
		set row("Qty7")=$g(resultList(anesthesiologistDesc,252))
		set rowTotal("Qty7")=$g(rowTotal("Qty7"))+row("Qty7")
		set row("Qty8")=$g(resultList(anesthesiologistDesc,249))
		set rowTotal("Qty8")=$g(rowTotal("Qty8"))+row("Qty8")
		set row("Signed")=$s($d(resultList(anesthesiologistDesc))>0:"√",1:"")
		do OutputRow
	}
	
	set row("AnaDoctor")="合计"
	set row("AnaDoctorId")=""
	set row("UserId")=""
	set row("Qty1")=$g(rowTotal("Qty1"))
	set row("Qty2")=$g(rowTotal("Qty2"))
	set row("Qty3")=$g(rowTotal("Qty3"))
	set row("Qty4")=$g(rowTotal("Qty4"))
	set row("Qty5")=$g(rowTotal("Qty5"))
	set row("Qty6")=$g(rowTotal("Qty6"))
	set row("Qty7")=$g(rowTotal("Qty7"))
	set row("Qty8")=$g(rowTotal("Qty8"))
	set row("Signed")=""
	do OutputRow
	
	s qHandle=$lb(0,repid,0)
	q $$$OK
	
InquireChargeRecord(opsId)
	set chargeRecordId=$o(^CIS.AN.ChargeRecordI("OperSchedule",opsId,""))
	if chargeRecordId=0 quit ""
	
	set chargeDetails=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.ChargeStatistic:FindChargeRecordDetails",deptId,chargeRecordId)
	
	for i=1:1:chargeDetails.Size
	{
		set chargeDetail = chargeDetails.GetAt(i)
		quit:chargeDetail=""
		
		set chargeCategory=chargeDetail.GetValue("ChargeCategory")
		continue:chargeCategory'=9 //非毒麻药不计算,暂时以ID判断
		
		set chargeItem=chargeDetail.GetValue("ChargeItem")
		set qty=chargeDetail.GetValue("Qty")
		set resultList(anesthesiologistDesc,chargeItem)=$g(resultList(anesthesiologistDesc,chargeItem))+qty
	}
	
	if opsId=14551 break //after inquire
	quit
	
OutputRow
	set AnaDoctor=$g(row("AnaDoctor"))
	set AnaDoctorId=$g(row("AnaDoctorId"))
	set UserId=$g(row("UserId"))
	set Qty1=$g(row("Qty1"))
	set Qty2=$g(row("Qty2"))
	set Qty3=$g(row("Qty3"))
	set Qty4=$g(row("Qty4"))
	set Qty5=$g(row("Qty5"))
	set Qty6=$g(row("Qty6"))
	set Qty7=$g(row("Qty7"))
	set Qty8=$g(row("Qty8"))
	set Signed=$g(row("Signed"))
	set ^CacheTemp(repid,ind)=$lb(AnaDoctor,AnaDoctorId,UserId,Qty1,Qty2,Qty3,Qty4,Qty5,Qty6,Qty7,Qty8,Signed)
	set ind=ind+1
	q
}

ClassMethod NarcoticStatisticFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = NarcoticStatisticExecute ]
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

ClassMethod NarcoticStatisticClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = NarcoticStatisticExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// Creator：      	雍阳
/// CreatDate：    	2018-1-8
/// Description： 	查询一次性高低值耗材使用登记
/// Table：        	MR_Diagnos,MR_DiagType
/// Input:			EpisodeID:病人就诊ID
/// Return：       	ResultSet
/// d ##class(CIS.AN.BL.ChargeStatistic).GetMaterialSummary("29","2018-12-10","2018-12-10","1822088")
ClassMethod GetMaterialSummary(locId As %String, startDate As %String, endDate As %String, medcareNo As %String = "") As %String
{
	set startDateH=##class(CIS.AN.COM.DateTime).ConvertToDateH(startDate)
	set endDateH=##class(CIS.AN.COM.DateTime).ConvertToDateH(endDate)
	set operListResultSet=##class(%ResultSet).%New("CIS.AN.BL.OperationList:FindOperationList")
	set patientResultSet=##class(%ResultSet).%New("CIS.AN.COM.Admission:FindPatient")
	
	kill materialUsageList
	
	for dateIndex=startDateH:1:endDateH
	{
		set chargeDetailId=0
		for
		{
			set chargeDetailId=$order(^CIS.AN.ChargeDetailI("ChargeDate",dateIndex,chargeDetailId))
			quit:(chargeDetailId="")
			
			set chargeDetail=##class(CIS.AN.ChargeDetail).%OpenId(chargeDetailId)
			continue:(chargeDetail="")
			
			continue:(chargeDetail.BillDept'=locId) /// 非当前科室不统计
			continue:(chargeDetail.BarCode'="") 	/// 扫描记费的不统计
			continue:chargeDetail.ChargeItem=""  	/// 未对应记费项目不统计
			
			set chargeItem=""
			if chargeDetail.ChargeItem'="" 
			{
				set chargeItem=chargeDetail.ChargeItem.%Id()
			}
			
			set opsId=chargeDetail.ChargeRecord.OperSchedule.%Id()
			set patDeptID=chargeDetail.ChargeRecord.OperSchedule.PatDeptID
			set patDeptDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",patDeptID)
		
			set materialUsageList(dateIndex,+patDeptDesc,+opsId,chargeItem,+chargeDetailId)=""
		}	
	}
	
	kill columns
	write "{"
	write """rows"":["
	
	set isFirstRow=1
	set dateIndex=""
	for
	{
		set dateIndex=$order(materialUsageList(dateIndex))
		quit:dateIndex=""
		
		set operDate=$zd(dateIndex,3)
		
		set patDeptID=""
		for
		{
			set patDeptID=$order(materialUsageList(dateIndex,patDeptID))
			quit:patDeptID=""
			
			set opsId=0
			for
			{
				set opsId=$order(materialUsageList(dateIndex,patDeptID,opsId))
				quit:(opsId="")
				
				set operDeptDesc="",patName="",curMedcareNo="",circualNurse="",circualNurseDesc=""
				set surgeonDesc="",assistantDesc="",operationDesc=""
				set stockItemCount=0
				do GetOperScheduleInfo(opsId)
				continue:(medcareNo'="")&(curMedcareNo'=medcareNo)  ///筛选需显示的病人住院号
			
				if 'isFirstRow write ","
				write "{"
				write """PatName"":""",patName,""",""MedcareNo"":""",curMedcareNo,"""",","
				write """Surgeon"":""",surgeonDesc,""",""CircualNurse"":""",circualNurseDesc,""""
				
				set chargeItem=""
				for
				{
					set chargeItem=$order(materialUsageList(dateIndex,patDeptID,opsId,chargeItem))
					quit:(chargeItem="")
					
					set manufacturer="",vendor="",regCert="",materialDesc=""
					set price="",materialDesc="",materialCode="",qty="",uomDesc="",stockItemCount=0
					set chargeDetailId=0
					for
					{
						set chargeDetailId=$order(materialUsageList(dateIndex,patDeptID,opsId,chargeItem,chargeDetailId))
						quit:(chargeDetailId="")
					
						do GetChargeDetailInfo(chargeDetailId)
						set stockItemCount=stockItemCount+qty
					}	
				
					continue:(stockItemCount<=0)
					
					set columns("ChargeItem_"_chargeItem)=materialDesc
					set columns("ChargeItem_"_chargeItem,"Qty")=$g(columns("ChargeItem_"_chargeItem,"Qty"))+stockItemCount
					write ",","""ChargeItem_",chargeItem,""":",stockItemCount
				}
				
				write "}"
				set isFirstRow=0
			}	
		}
	}
	
	write ","
	write "{"
	write """PatName"":""合计"",""MedcareNo"":""""",","
	write """Surgeon"":"""",""CircualNurse"":"""""

	kill columnSequence
	set columnName=""
	for
	{
		set columnName=$o(columns(columnName))
		quit:columnName=""
		
		set stockItemCount=columns(columnName,"Qty")
		write ",","""",columnName,""":",stockItemCount
		set columnSequence(+stockItemCount,columnName)=columns(columnName)
	}
	write "}"
	
	write "]",","
	write """frozenColumns"":","[["
	write "{","""field"":""PatName"",""title"":""姓名"",""width"":80","}"
	write ",","{","""field"":""MedcareNo"",""title"":""住院号"",""width"":90","}"
	write ",","{","""field"":""Surgeon"",""title"":""医师"",""width"":80","}"
	write ",","{","""field"":""CircualNurse"",""title"":""巡回"",""width"":80","}"
	write "]]",","
	write """columns"":","[["
	
	set isFirstColumn=1
	set seq=""
	for
	{
		set seq=$o(columnSequence(seq),-1)
		quit:seq=""
		
		set columnName=""
		for
		{
			set columnName=$o(columnSequence(seq,columnName))
			quit:columnName=""
		
			if 'isFirstColumn write ","
			write "{","""field"":""",columnName,""",""title"":""",columnSequence(seq,columnName),""",""width"":40","}"
			set isFirstColumn=0
		}
	}
	
	write "]]"
	write "}"
	
	quit ""
	
GetChargeDetailInfo(chargeDetailId)
	set chargeDetail=##class(CIS.AN.ChargeDetail).%OpenId(chargeDetailId)		
	set materialDesc=chargeDetail.ChargeItemDesc
	set materialCode="",price=""
	if chargeDetail.ChargeItem'=""
	{
		set materialCode=chargeDetail.ChargeItem.Code
		set price=chargeDetail.ChargeItem.Price
		set:chargeDetail.ChargeItem.Unit'="" uomDesc=chargeDetail.ChargeItem.Unit.LocalDesc
	}
	set qty=chargeDetail.Qty
	
	quit
	
GetOperScheduleInfo(opsId)	
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	
	set sc=patientResultSet.Execute(operSchedule.EpisodeID)
	while(patientResultSet.%Next())
	{
		set patName=patientResultSet.Get("PatName")
		set patGender=patientResultSet.Get("PatGender")
		set patAge=patientResultSet.Get("PatAge")	
		//set patName=patName_"("_patGender_" "_patAge_")"
		set curMedcareNo=patientResultSet.Get("MedcareNo")
	}
		
	set assistantList=""
	set surgeonList=""
	set operList=""
			
	set sc=operListResultSet.Execute(opsId)
	while(operListResultSet.%Next())
	{
		set surgeon=operListResultSet.Get("Surgeon")
		set surgeonDesc=operListResultSet.Get("SurgeonDesc")
		set:surgeonDesc="" surgeonDesc=surgeon
		set surgeonList=surgeonList_$lb(surgeonDesc)
				
		set assistant=operListResultSet.Get("Assistant")
		set assistantDesc=operListResultSet.Get("AssistantDesc")
		set assistantList=##class(CIS.AN.COM.String).ConcatString(assistantDesc,operListResultSet.Get("AssistantDesc"),",")
				
		set operationDesc=operListResultSet.Get("OperationDesc")
		set operNote=operListResultSet.Get("OperNote")
		set:operationDesc="" operationDesc=operNote
		set operList=operList_$lb(operationDesc)
	}
			
	if $ll(surgeonList)>1 set surgeonDesc=$ListToString(surgeonList,",")
	set assistant=assistantList
	if $ll(operList)>1 set operationDesc=$ListToString(operList,"+")
	
	set circualNurse=operSchedule.CircualNurse
	set signCircualNurse=##class(CIS.AN.BL.Signature).GetCircualNurseBySignature(opsId)
	set:(signCircualNurse'="") circualNurse=signCircualNurse
	set circualNurseDesc=##class(CIS.AN.BL.OperationList).GetAssistantDesc(circualNurse)
	
	quit
}

}
