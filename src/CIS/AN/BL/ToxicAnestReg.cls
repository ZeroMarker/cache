Class CIS.AN.BL.ToxicAnestReg Extends %RegisteredObject
{

/// Creator：      	雍阳
/// CreatDate：    	2018-7-26
/// Description： 	查询毒麻药登记记录
/// Table：        	CIS.AN.ToxicAnestReg, CIS.AN.ToxicAnestClaim
/// Input:			1.claimUser：领取人(麻醉医生)ID，2.startDate:开始日期，3.endDate:结束日期
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ToxicAnestReg","FindToxicAnestRegList","","2018-07-30","2018-07-30")
Query FindToxicAnestRegList(claimUser As %String, startDate As %String, endDate As %String, isActive As %String = "Y") As %Query(ROWSPEC = "RowId,CareProv,CareProvDesc,RegDate,ClaimDate,ClaimTime,ClaimDT,ApplyDate,ApplyTime,ApplyDT,ReturnDate,ReturnTime,ReturnDT,ApplyCheckUser,ApplyCheckUserName,ClaimCheckUser,ClaimCheckUserName,ReturnCheckUser,ReturnCheckUserName,IsActive,ClaimDetails,ReturnDetails") [ SqlProc ]
{
}

ClassMethod FindToxicAnestRegListExecute(ByRef qHandle As %Binary, claimUser As %String, startDate As %String, endDate As %String, isActive As %String = "Y") As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	set startDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(startDate,"")
	set endDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(endDate,"")
	if (startDateH>endDateH) set endDateH=startDateH
	
	set:claimUser'="" claimUser = " "_claimUser
	
	for date=startDateH:1:endDateH
	{
		set RowId=""
		for
		{
			if claimUser'="" set RowId=$o(^CIS.AN.ToxicAnestRegI("CPDate",claimUser,date,RowId))
			else  set RowId=$o(^CIS.AN.ToxicAnestRegI("Date",date,RowId))
			quit:RowId=""
			
			set regRecord=##class(CIS.AN.ToxicAnestReg).%OpenId(RowId)
			set IsActive=regRecord.IsActive
			continue:(isActive'="")&&(IsActive'=isActive)
			
			set CareProv=regRecord.CareProv
			set CareProvDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTCareProv","CTPCPDesc",CareProv)
			set RegDate = ##class(CIS.AN.COM.DateTime).ConvertToDate(regRecord.RegDate,"")
			set ClaimDate = ##class(CIS.AN.COM.DateTime).ConvertToDate(regRecord.ClaimDate,"")
			set ClaimTime = ##class(CIS.AN.COM.DateTime).ConvertToTime(regRecord.ClaimTime,"")
			set ClaimDT = ##class(CIS.AN.COM.DateTime).ConvertToDateTime(regRecord.ClaimDate,regRecord.ClaimTime,"")
			set ApplyDate = ##class(CIS.AN.COM.DateTime).ConvertToDate(regRecord.ApplyDate,"")
			set ApplyTime = ##class(CIS.AN.COM.DateTime).ConvertToTime(regRecord.ApplyTime,"")
			set ApplyDT = ##class(CIS.AN.COM.DateTime).ConvertToDateTime(regRecord.ApplyDate,regRecord.ApplyTime,"")
			set ReturnDate = ##class(CIS.AN.COM.DateTime).ConvertToDate(regRecord.ReturnDate,"")
			set ReturnTime = ##class(CIS.AN.COM.DateTime).ConvertToTime(regRecord.ReturnTime,"")
			set ReturnDT = ##class(CIS.AN.COM.DateTime).ConvertToDateTime(regRecord.ReturnDate,regRecord.ReturnTime,"")
			set ApplyCheckUser=regRecord.ApplyCheckUser
			set ApplyCheckUserName=##class(CIS.AN.COM.String).GetDescByID("User.SSUser","SSUSRName",ApplyCheckUser)
			set ClaimCheckUser=regRecord.ClaimCheckUser
			set ClaimCheckUserName=##class(CIS.AN.COM.String).GetDescByID("User.SSUser","SSUSRName",ClaimCheckUser)
			set ReturnCheckUser=regRecord.ReturnCheckUser
			set ReturnCheckUserName=##class(CIS.AN.COM.String).GetDescByID("User.SSUser","SSUSRName",ReturnCheckUser)
			
			set ClaimDetails=..GetClaimDetails(RowId)
			set ReturnDetails=..GetReturnDetails(RowId)
			
			do OutputRow
		}
	}
	
	s qHandle=$lb(0,repid,0)
	q $$$OK
OutputRow
	s Data=$lb(RowId,CareProv,CareProvDesc,RegDate,ClaimDate,
			ClaimTime,ClaimDT,ApplyDate,ApplyTime,ApplyDT,
			ReturnDate,ReturnTime,ReturnDT,ApplyCheckUser,ApplyCheckUserName,
			ClaimCheckUser,ClaimCheckUserName,ReturnCheckUser,ReturnCheckUserName,IsActive,
			ClaimDetails,ReturnDetails)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod FindToxicAnestRegListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindToxicAnestRegListExecute ]
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

ClassMethod FindToxicAnestRegListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindToxicAnestRegListExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// Creator：      	雍阳
/// CreatDate：    	2018-7-26
/// Description： 	查询毒麻药领用明细
/// Table：        	CIS.AN.ToxicAnestReg, CIS.AN.ToxicAnestClaim
/// Input:			1.claimUser：领取人(麻醉医生)ID，2.startDate:开始日期，3.endDate:结束日期
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ToxicAnestReg","FindToxicAnestClaimList","","2018-07-30","2018-07-30")
Query FindToxicAnestClaimList(claimUser As %String, startDate As %String, endDate As %String) As %Query(ROWSPEC = "RowId,RegRecord,DataItem,DataItemDesc,Batch,ElectronicCode,Specification,Dose,DoseUnit,DoseUnitDesc,QtyUnit,QtyUnitDesc,Status,StatusDesc,UseDate,UseTime,UseDT,ReturnDate,ReturnTime,ReturnDT,RelatedOper,Patient") [ SqlProc ]
{
}

ClassMethod FindToxicAnestClaimListExecute(ByRef qHandle As %Binary, claimUser As %String, startDate As %String, endDate As %String) As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	set startDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(startDate,"")
	set endDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(endDate,"")
	if (startDateH>endDateH) set endDateH=startDateH
	set:claimUser'="" claimUser = " "_claimUser
	
	for date=startDateH:1:endDateH
	{
		set RegRecord=""
		for
		{
			if claimUser'="" set RegRecord=$o(^CIS.AN.ToxicAnestRegI("CPDate",claimUser,date,RegRecord))
			else  set RegRecord=$o(^CIS.AN.ToxicAnestRegI("Date",date,RegRecord))
			quit:RegRecord=""
			
			do LoopClaimRecord(RegRecord)
		}
	}
	
	s qHandle=$lb(0,repid,0)
	q $$$OK
	
LoopClaimRecord(RegRecord)
	set RowId=""
	for
	{
		set RowId=$o(^CIS.AN.ToxicAnestClaimI("Reg",RegRecord,RowId))
		quit:RowId=""
		
		set claimRecord=##class(CIS.AN.ToxicAnestClaim).%OpenId(RowId)
		set DataItem=claimRecord.DataItem.%Id()
		set DataItemDesc=claimRecord.DataItem.Description
		set Batch=claimRecord.Batch
		set ElectronicCode=claimRecord.ElectronicCode
		set Specification=claimRecord.Specification
		set Dose=claimRecord.Dose
		if (claimRecord.DoseUnit'="")
		{
			set DoseUnit=claimRecord.DoseUnit.%Id()
			set DoseUnitDesc=claimRecord.DoseUnit.Description
		}
		if (claimRecord.QtyUnit'="")
		{
			set QtyUnit=claimRecord.QtyUnit.%Id()
			set QtyUnitDesc=claimRecord.QtyUnit.Description
		}
		set Status=claimRecord.Status
		set StatusDesc=$s(Status="A":"已请领",Status="C":"已领取",Status="U":"已使用",Status="R":"已退还",1:"")
		set UseDate = ##class(CIS.AN.COM.DateTime).ConvertToDate(claimRecord.UseDate,"")
		set UseTime = ##class(CIS.AN.COM.DateTime).ConvertToTime(claimRecord.UseTime,"")
		set UseDT = ##class(CIS.AN.COM.DateTime).ConvertToDateTime(claimRecord.UseDate,claimRecord.UseTime,"")
		set ReturnDate = ##class(CIS.AN.COM.DateTime).ConvertToDate(claimRecord.ReturnDate,"")
		set ReturnTime = ##class(CIS.AN.COM.DateTime).ConvertToTime(claimRecord.ReturnTime,"")
		set ReturnDT = ##class(CIS.AN.COM.DateTime).ConvertToDateTime(claimRecord.ReturnDate,claimRecord.ReturnTime,"")
		
		if (claimRecord.RelatedOper'="")
		{
			set RelatedOper=claimRecord.RelatedOper.%Id()
			set Patient=""
			if (RelatedOper'="")
			{
				set patQuery=##class(%ResultSet).%New("CIS.AN.COM.Admission:FindPatient")
				set sc=patQuery.Execute(claimRecord.RelatedOper.EpisodeID)
				while(patQuery.%Next())
				{
					set PatName=patQuery.Get("PatName")
					set PatGender=patQuery.Get("PatGender")
					set PatAge=patQuery.Get("PatAge")	
					set Patient=patName_"("_patGender_" "_patAge_")"
					//set RegNo=patQuery.Get("RegNo")
					//set medcareNo=patQuery.Get("MedcareNo")
					//set patientID=patQuery.Get("PatientID")
					//set mradmID=patQuery.Get("MRAdmID")
				}
			}
		}
		
		do OutputRow
	}
	
	quit
	
OutputRow
	s Data=$lb(RowId,RegRecord,DataItem,DataItemDesc,Batch,
			ElectronicCode,Specification,Dose,DoseUnit,DoseUnitDesc,
			QtyUnit,QtyUnitDesc,Status,StatusDesc,UseDate,
			UseTime,UseDT,ReturnDate,ReturnTime,ReturnDT,
			RelatedOper,Patient)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod FindToxicAnestClaimListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindToxicAnestClaimListExecute ]
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

ClassMethod FindToxicAnestClaimListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindToxicAnestClaimListExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// Creator：      	雍阳
/// CreatDate：    	2018-7-26
/// Description： 	获取毒麻药领取药品信息
/// Table：        	CIS.AN.ToxicAnestClaim
/// Input:			1.regRecordID：毒麻药登记记录ID
/// Return：       	%String:已领取的药品分类总计明细
/// w ##class(CIS.AN.BL.ToxicAnestReg).GetClaimDetails(1)
ClassMethod GetClaimDetails(regRecordID) As %String
{
	kill dataItemList
	set claimRowId=""
	for
	{
		set claimRowId=$o(^CIS.AN.ToxicAnestClaimI("Reg",regRecordID,claimRowId))
		quit:claimRowId=""
		
		set claimRecord=##class(CIS.AN.ToxicAnestClaim).%OpenId(claimRowId)
		if (claimRecord.Status'="") && ("CUR"[claimRecord.Status) //已领取、已使用、已退还，都算已领取
		{
			set dataItemRowId=claimRecord.DataItem.%Id()
			set dataItemDesc=claimRecord.DataItem.Description
			set dataItemList(dataItemRowId,"Desc")=dataItemDesc
			set dataItemList(dataItemRowId,"Qty")=$get(dataItemList(dataItemRowId,"Qty"))+1
		}
	}
	
	set dataItemRowId="",result=""
	for
	{
		set dataItemRowId=$o(dataItemList(dataItemRowId))
		quit:dataItemRowId=""
		
		set:result'="" result=result_"<br>"
		set result=result_dataItemList(dataItemRowId,"Desc")_" "_dataItemList(dataItemRowId,"Qty")_"支" //默认单位为"支"，?自行设置单位?
	}
	
	quit result
}

/// Creator：      	雍阳
/// CreatDate：    	2018-7-26
/// Description： 	获取毒麻药退还药品信息
/// Table：        	CIS.AN.ToxicAnestClaim
/// Input:			1.regRecordID：毒麻药登记记录ID
/// Return：       	%String:已退还的药品分类总计明细
ClassMethod GetReturnDetails(regRecordID) As %String
{
	kill dataItemList
	set claimRowId=""
	for
	{
		set claimRowId=$o(^CIS.AN.ToxicAnestClaimI("Reg",regRecordID,claimRowId))
		quit:claimRowId=""
		
		set claimRecord=##class(CIS.AN.ToxicAnestClaim).%OpenId(claimRowId)
		if (claimRecord.Status'="") && ("R"[claimRecord.Status) //已退还
		{
			set dataItemRowId=claimRecord.DataItem.%Id()
			set dataItemDesc=claimRecord.DataItem.Description
			set dataItemList(dataItemRowId,"Desc")=dataItemDesc
			set dataItemList(dataItemRowId,"Qty")=$get(dataItemList(dataItemRowId,"Qty"))+1
		}
	}
	
	set dataItemRowId="",result=""
	for
	{
		set dataItemRowId=$o(dataItemList(dataItemRowId))
		quit:dataItemRowId=""
		
		set:result'="" result=result_"<br>"
		set result=result_dataItemList(dataItemRowId,"Desc")_" "_dataItemList(dataItemRowId,"Qty")_"支"
	}
	
	quit result
}

/// Creator：      	雍阳
/// CreatDate：    	2018-7-26
/// Description： 	保存毒麻药领取登记记录
/// Table：        	CIS.AN.ToxicAnestReg，CIS.AN.ToxicAnestClaim
/// Input:			1.data:登记
/// Return：       	%String:保存成功或失败
ClassMethod SaveToxicAnestReg(data, userId) As %String
{
	quit:(data="") "E^保存的数据不能为空！"
	
	set $zt="Error"
	tstart
	set sc=##class(CIS.AN.COM.String).ToArray(data,.array)
	set index=0,saveResult="S^"
	for
	{
		set index=$order(array(index))
		quit:(index="")
		continue:($get(array(index,"ClassName"))'="CIS.AN.ToxicAnestReg")
		kill regRecord
		m regRecord=array(index)
		set regRecord("UpdateDate")=+$h
		set regRecord("UpdateTime")=$p($h,",",2)
		set regRecord("UpdateUser")=userId
		set saveResult=##class(CIS.AN.COM.DataService).SaveData(.regRecord)
		quit:($piece(saveResult,"^",1)'="S")
		set guid = regRecord("Guid")
		set regRecordRowId=+$piece(saveResult,"^",2)
		set subIndex=0,saveResult="S^"
		for
		{
			set subIndex=$order(array(subIndex))
			quit:(subIndex="")
			continue:($get(array(subIndex,"ClassName"))'="CIS.AN.ToxicAnestClaim")
			continue:($get(array(subIndex,"RegGuid"))'=guid)
			kill claimRecord
			m claimRecord=array(subIndex)
			set claimRecord("RegRecord")=regRecordRowId
			if $g(claimRecord("isRemoved"))="true"
			{
				if $g(claimRecord("RowId"))>0 set saveResult=##class(CIS.AN.COM.DataService).DelData(claimRecord("ClassName"),claimRecord("RowId"))
			}
			else
			{
				set saveResult=##class(CIS.AN.COM.DataService).SaveData(.claimRecord)
			}
			quit:($piece(saveResult,"^",1)'="S")
		}
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
	trollback
	quit "E^"_$ze
}

/// Creator：      	雍阳
/// CreatDate：    	2018-7-26
/// Description： 	生成毒麻药领取登记日结
/// Table：        	CIS.AN.ToxicAnestReg，CIS.AN.ToxicAnestClaim
/// Input:			1.date:日期
/// Return：       	json
/// w ##class(CIS.AN.BL.ToxicAnestReg).GetToxicAnestDaySummary("2018-08-01","2018-08-01")
ClassMethod GetToxicAnestDaySummary(startdate As %String, enddate As %String) As %String
{
	kill dataItemList
	set startdateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(startdate,"")
	set enddateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(enddate,"")
	
	for date=startdateH:1:enddateH
	{
		do loopSingleDate(date)
	}
	
	do outputJson
	quit ""
	
loopSingleDate(date)
	set RowId=""
	for
	{
		set RowId=$o(^CIS.AN.ToxicAnestRegI("Date",date,RowId))
		quit:RowId=""
			
		set regRecord=##class(CIS.AN.ToxicAnestReg).%OpenId(RowId)
		set CareProv=regRecord.CareProv
		set CareProvDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTCareProv","CTPCPDesc",CareProv)
		set RegDate = ##class(CIS.AN.COM.DateTime).ConvertToDate(regRecord.RegDate,"")
		set ClaimDate = ##class(CIS.AN.COM.DateTime).ConvertToDate(regRecord.ClaimDate,"")
		set ClaimTime = ##class(CIS.AN.COM.DateTime).ConvertToTime(regRecord.ClaimTime,"")
		set ClaimDT = ##class(CIS.AN.COM.DateTime).ConvertToDateTime(regRecord.ClaimDate,regRecord.ClaimTime,"")
		set ApplyDate = ##class(CIS.AN.COM.DateTime).ConvertToDate(regRecord.ApplyDate,"")
		set ApplyTime = ##class(CIS.AN.COM.DateTime).ConvertToTime(regRecord.ApplyTime,"")
		set ApplyDT = ##class(CIS.AN.COM.DateTime).ConvertToDateTime(regRecord.ApplyDate,regRecord.ApplyTime,"")
		set ReturnDate = ##class(CIS.AN.COM.DateTime).ConvertToDate(regRecord.ReturnDate,"")
		set ReturnTime = ##class(CIS.AN.COM.DateTime).ConvertToTime(regRecord.ReturnTime,"")
		set ReturnDT = ##class(CIS.AN.COM.DateTime).ConvertToDateTime(regRecord.ReturnDate,regRecord.ReturnTime,"")
		set ApplyCheckUser=regRecord.ApplyCheckUser
		set ApplyCheckUserName=##class(CIS.AN.COM.String).GetDescByID("User.SSUser","SSUSRName",ApplyCheckUser)
		set ClaimCheckUser=regRecord.ClaimCheckUser
		set ClaimCheckUserName=##class(CIS.AN.COM.String).GetDescByID("User.SSUser","SSUSRName",ClaimCheckUser)
		set ReturnCheckUser=regRecord.ReturnCheckUser
		set ReturnCheckUserName=##class(CIS.AN.COM.String).GetDescByID("User.SSUser","SSUSRName",ReturnCheckUser)
		set dataItemList("Node","CareProv",CareProv)=CareProvDesc
		do summaryDataItem(RowId)
	}
	
	quit
	
summaryDataItem(regRecordID)
	set claimRowId=""
	for
	{
		set claimRowId=$o(^CIS.AN.ToxicAnestClaimI("Reg",regRecordID,claimRowId))
		quit:claimRowId=""
		
		set claimRecord=##class(CIS.AN.ToxicAnestClaim).%OpenId(claimRowId)
		set dataItemId=claimRecord.DataItem.%Id()
		set dataItemDesc=claimRecord.DataItem.Description
		set dataItemList("Node","DataItem",dataItemId)=dataItemDesc
		
		if (claimRecord.Status="R") //已退还
		{
			set dataItemList(CareProv, dataItemId,"ReturnedQty")=$get(dataItemList(CareProv, dataItemId,"ReturnedQty"))+1
		}
		if (claimRecord.Status="U")  //已使用
		{
			set dataItemList(CareProv, dataItemId,"UsedQty")=$get(dataItemList(CareProv, dataItemId,"UsedQty"))+1
		}
		if (claimRecord.Status="C")  //领取未退
		{
			set dataItemList(CareProv, dataItemId,"UnreturnedQty")=$get(dataItemList(CareProv, dataItemId,"UnreturnedQty"))+1
		}
		if (claimRecord.Status'="A") 
		{
			set dataItemList(CareProv, dataItemId,"ClaimedQty")=$get(dataItemList(CareProv, dataItemId,"ClaimedQty"))+1
		}
	}
	
	quit
	
outputJson
	set CareProv=""
	write "{","""rows"":","["
	set isFirst=1
	for
	{
		set CareProv=$o(dataItemList("Node","CareProv",CareProv))
		quit:CareProv=""
		if 'isFirst write ","
		write "{""CareProvDesc"":""",dataItemList("Node","CareProv",CareProv),""""
		set dataItemId=""
		for
		{
			set dataItemId=$o(dataItemList(CareProv,dataItemId))
			quit:dataItemId=""
			
			write ",""i_"_dataItemId_"_ReturnedQty"":",+$g(dataItemList(CareProv, dataItemId,"ReturnedQty"))
			write ",""i_"_dataItemId_"_UsedQty"":",+$g(dataItemList(CareProv, dataItemId,"UsedQty"))
			write ",""i_"_dataItemId_"_UnreturnedQty"":",+$g(dataItemList(CareProv, dataItemId,"UnreturnedQty"))
			write ",""i_"_dataItemId_"_ClaimedQty"":",+$g(dataItemList(CareProv, dataItemId,"ClaimedQty"))
			
		}
		write "}"
		set isFirst=0
	}
	
	write "]",","
	
	write """columns"":","["
	write "["
	write "{""field"":""CareProvDesc"",""title"":""领取人"",""width"":60,""colspan"":1,""rowspan"":2}"
	set dataItemId=""
	for
	{
		set dataItemId=$o(dataItemList("Node","DataItem",dataItemId))
		quit:dataItemId=""
		write ",{""title"":"""_dataItemList("Node","DataItem",dataItemId)_""",""width"":60,""colspan"":4,""rowspan"":1}"
	}
	write "],"
	write "["
	set dataItemId=""
	set isFirst=1
	for
	{
		set dataItemId=$o(dataItemList("Node","DataItem",dataItemId))
		quit:dataItemId=""
		if 'isFirst write ","
		write "{""field"":""i_"_dataItemId_"_ClaimedQty"",""title"":""已领取"",""width"":60}"
		write ",{""field"":""i_"_dataItemId_"_UsedQty"",""title"":""已使用"",""width"":60","}"
		write ",{""field"":""i_"_dataItemId_"_ReturnedQty"",""title"":""已退还"",""width"":60","}"
		write ",{""field"":""i_"_dataItemId_"_UnreturnedQty"",""title"":""未退还"",""width"":60","}"
		set isFirst=0
	}
	
	write "]"
	write "]"
	
	write "}"
	
	quit
}

}
