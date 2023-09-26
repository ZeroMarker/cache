/// 麻醉恢复记录
Class CIS.AN.BL.PACURecord Extends %RegisteredObject
{

/// 时间列的格式
Parameter TimeColumnFormat = 2;

/// Creator：      	陈长青
/// CreatDate：    	2017-03-20
/// Description： 	查询时间轴信息
/// Table：        	DHCAN.TimeLine
/// Input:			opsId:手术计划ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.PACURecord","FindTimeLines","1")
Query FindTimeLines(sheetId As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT *,
	%ODBCOUT(StartDate) As StartDate,
	%ODBCOUT(StartTime) As StartTime,
	%ODBCOUT(EndDate) As EndDate,
	%ODBCOUT(EndTime) As EndTime,
	%ODBCOUT(StartDate)_" "_%ODBCOUT(StartTime) As StartDT,
	%ODBCOUT(EndDate)_" "_%ODBCOUT(EndTime) As EndDT
	from CIS_AN.TimeLine where RecordSheet=:sheetId
}

/// Creator：      	陈长青
/// CreatDate：    	2017-03-20
/// Description： 	获取麻醉监护的起始时间
/// Table：        	
/// Input:			opsId:手术计划ID
/// Return：       	麻醉监护起始时间字符串(格式为yyyy-mm-dd HH:mm)
/// Debug:			w ##class(CIS.AN.BL.PACURecord).GetRecordStartDT("")
ClassMethod GetRecordStartDT(opsId As %String) As %String
{
	set result=""
	if (##class(CIS.AN.OperSchedule).%ExistsId(opsId))
	{
		set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		set anaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
		set AnaesthesiaObj=##class(CIS.AN.Anaesthesia).%OpenId(anaId)
		set PACUInDT=AnaesthesiaObj.PACUInDT
		
		if (PACUInDT'="")
		{
			set PACUInDate=##class(CIS.AN.COM.DateTime).ConvertToDateH($piece(PACUInDT," ",1))		
		}
		else
		{
			set PACUInDate=##class(CIS.AN.COM.DateTime).ConvertToDateH(operSchedule.OperDate)	
		}
	}	
	else
	{
		set PACUInDT=""	
		set PACUInDate=##class(CIS.AN.COM.DateTime).ConvertToDateH($piece(PACUInDT," ",1))	
	}
	
	set PACUInTime=##class(CIS.AN.COM.DateTime).ConvertToTimeH($piece(PACUInDT," ",2))		
	set minutes=##class(CIS.AN.COM.DateTime).GetMinutes(PACUInTime)
	set seconds=##class(CIS.AN.COM.DateTime).GetSeconds(PACUInTime)
	set overplus=(minutes#10)
	if (overplus>=5){
		set PACUInTime=(+PACUInTime)-((overplus-5)*60)-(+seconds)	
	}
	else
	{
		set PACUInTime=(+PACUInTime)-(overplus*60)-(+seconds)	
	}
	set result=##class(CIS.AN.COM.DateTime).ConvertToDateTime(PACUInDate,PACUInTime)
	quit result
}

/// Creator：      	雍阳
/// CreatDate：    	2018-04-03
/// Description： 	获取麻醉监护的结束时间
/// Table：        	
/// Input:			opsId:手术计划ID
/// Return：       	麻醉监护结束时间字符串(格式为yyyy-mm-dd HH:mm)
/// Debug:			w ##class(CIS.AN.BL.PACURecord).GetRecordEndDT("")
ClassMethod GetRecordEndDT(opsId As %String) As %String
{
	set result=""
	if (##class(CIS.AN.OperSchedule).%ExistsId(opsId))
	{
		set anaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
		set anaesthesiaObj=##class(CIS.AN.Anaesthesia).%OpenId(anaId)
		set PACUOutDT=anaesthesiaObj.PACUOutDT
		
		if (PACUOutDT'="")
		{
			set result=PACUOutDT
		}
		else
		{
			set result=##class(CIS.AN.COM.DateTime).ConvertToDateTime(+$h,+$piece($h,",",2))
		}
	}
	
	quit result
}

/// Creator：      	陈长青
/// CreatDate：    	2017-10-11
/// Description： 	启动麻醉监护
/// Table：        	DHCAN.OperSchedule
/// Input:			data:启动监护参数
/// Return：       	启动成功返回"S^"，失败返回"E^原因"
/// Debug:			w ##class(CIS.AN.BL.PACURecord).StartRecord("")
ClassMethod StartRecord(data As %String) As %String
{
	
	tstart
	set result=""
	set status=##class(CIS.AN.COM.String).ToArray(data,.array)
	merge operSchedule=array(1)
	if ($get(operSchedule("Status"))="")&($get(operSchedule("StatusCode"))'="")
	{
		set operSchedule("Status")=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode(operSchedule("StatusCode"))
	}	
	
	set opsId=operSchedule("RowId")
	if (opsId="")
	{
		trollback
		quit "E^无手术安排表ID"	
	}
	set operScheduleObj=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set EpisodeID=operScheduleObj.EpisodeID
	set EpisodeObj=##class(User.PAAdm).%OpenId(EpisodeID)
	if (EpisodeObj.PAADMVisitStatus="D")||(EpisodeObj.PAADMVisitStatus="P")||(EpisodeObj.PAADMVisitStatus="C")
	{
		trollback
		quit "E^就诊状态不对"	
	}
	set saveResult=##class(CIS.AN.COM.DataService).SaveData(.operSchedule)
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult		
	}
	
	set anaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
	set AnaesthesiaObj=##class(CIS.AN.Anaesthesia).%OpenId(anaId)
	set formerDT=AnaesthesiaObj.PACUInDT
	set currentDT=operSchedule("PACUInDT")
	
	set anaesthesia("ClassName")="CIS.AN.Anaesthesia"
	set anaesthesia("RowId")=anaId
	set anaesthesia("PACUInDT")=currentDT
	set saveResult=##class(CIS.AN.COM.DataService).SaveData(.anaesthesia)
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult		
	}
	
	/// 写入手术操作过程 CCQ 20200225
	set saveResult=##class(CIS.AN.BL.SurgicalProcedure).SaveProcedureByDT(operSchedule("RowId"),"PI",operSchedule("UpdateUser"),currentDT)
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult		
	}
	
	tcommit
	
	set opsId=operSchedule("RowId")
	do ..CreatePACURecord(operSchedule("RowId"))
	do ..AutoCreateParaItem(operSchedule("RowId"))
	do ..AutoCreateDeviceUsage(operSchedule("RowId"),operSchedule("UpdateUser"),operSchedule("PACUInDT"))
	if ($get(operSchedule("isStarting"))'="N"){//开始监护按钮的特殊处理
		set personalSetting=..GetPersonalSetting("PACURecord",operSchedule("UpdateUser"))
		if (personalSetting.GetValue("AutoApplyTemplate")'="")
		{
			set moduleCode = "PACURecord"
			set recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCode(operSchedule("RowId"),moduleCode,"")
			do ..ApplyTemplate(recordSheetId,personalSetting.GetValue("AutoApplyTemplate"),operSchedule("UpdateUser"))
		}
		else
		{
			set moduleCode = "PACURecord"
			set recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCode(operSchedule("RowId"),moduleCode,"")
			set publicTemplateId=..GetPublicTempalte(moduleCode)
			if publicTemplateId'="" do ..ApplyTemplate(recordSheetId,publicTemplateId,operSchedule("UpdateUser"))
		}
		
		do ..AutoCreateEvent(operSchedule("RowId"),operSchedule("UpdateUser"),operSchedule("PACUInDT"),"PACUIn")
		do ..TriggerEvent(operSchedule("RowId"),"RoomOut","PACUIn")
	}
	
	do ..AfterStartRecord(opsId)
	quit "S^"
}

ClassMethod AfterStartRecord(opsId) As %Status
{
	try
	{
		// 回写旧表
		set saveResult=##class(CIS.AN.SRV.OperAppService).StartPACURecord(opsId,"")
	}
	catch(e)
	{
		
	}
	
	quit $$$OK
}

/// w ##class(CIS.AN.BL.PACURecord).CreatePACURecord("220")
ClassMethod CreatePACURecord(opsId) As %String
{
	set pacuRecordId=..GetPACURecordId(opsId)
	if pacuRecordId=""
	{
		set pacuRecord=##class(CIS.AN.PACURecord).%New()
		set pacuRecord.OperSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		
		set inSteward=##class(CIS.AN.StewardAssessment).%New()
		set inSteward.OperSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		do inSteward.%Save()
		set inStewardId=inSteward.%Id()
		set pacuRecord.InSteward=inSteward
		
		set outSteward=##class(CIS.AN.StewardAssessment).%New()
		set outSteward.OperSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		do outSteward.%Save()
		set outStewardId=outSteward.%Id()
		set pacuRecord.OutSteward=outSteward
		
		do pacuRecord.%Save()
		set pacuRecordId=pacuRecord.%Id()
	}
	
	quit pacuRecordId
}

/// w ##class(CIS.AN.BL.AnaestRecord).GetPublicTempalte()
ClassMethod GetPublicTempalte(moduleCode As %String = "PACURecord") As %String
{
	set rowId="",foundTemplateId=""
	for
	{
		set rowId=$o(^CF.AN.ModuleTemplateI("IType"," PUBLIC",rowId))
		quit:rowId=""
		
		set template=##class(CF.AN.ModuleTemplate).%OpenId(rowId)
		continue:template.DataModule.Code'=moduleCode
		
		set foundTemplateId=rowId
		quit
	}
	
	quit foundTemplateId
}

/// Creator：      	雍阳
/// CreatDate：    	2018-09-17
/// Description： 	启动麻醉监护后自动创建默认事件
/// Table：        	CIS.AN.OperSchedule
/// Input:			opsId:手术排班表ID
/// Return：       	启动成功返回"S^"，失败返回"E^原因"
/// Debug:			w ##class(CIS.AN.BL.PACURecord).AutoCreateDefaultEvents("")
ClassMethod GetPersonalSetting(moduleCode As %String, userId As %String) As CIS.AN.COM.DataObject
{
	set moduleId = ##class(CIS.AN.BL.DataModule).GetDataModuleID(moduleCode)
	set foundRowId = "",autoCreateEvent="",autoApplyTemplate=""
	&sql(SELECT RowId,AutoCreateEvent,AutoApplyTemplate into :foundRowId,:autoCreateEvent,:autoApplyTemplate
		from CF_AN.personalsetting 
		where DataModule=:moduleId
		and UserID=:userId)
	
	set dataObject=##class(CIS.AN.COM.DataObject).%New()
	set keyValuePair=##class(CIS.AN.COM.KeyValuePair).%New()
	set keyValuePair.Key="RowId"
	set keyValuePair.Value=foundRowId
	do dataObject.KeyValuePairs.Insert(keyValuePair)
	set keyValuePair=##class(CIS.AN.COM.KeyValuePair).%New()
	set keyValuePair.Key="AutoCreateEvent"
	set keyValuePair.Value=$s(foundRowId="":"Y",1:autoCreateEvent)
	do dataObject.KeyValuePairs.Insert(keyValuePair)
	set keyValuePair=##class(CIS.AN.COM.KeyValuePair).%New()
	set keyValuePair.Key="AutoApplyTemplate"
	set keyValuePair.Value=autoApplyTemplate
	do dataObject.KeyValuePairs.Insert(keyValuePair)
	
	quit dataObject
}

/// Creator：      	雍阳
/// CreatDate：    	2018-09-17
/// Description： 	启动麻醉监护后自动创建术中事件和间断用药的项目
/// Table：        	CIS.AN.OperSchedule
/// Input:			opsId:手术排班表ID
/// Return：       	启动成功返回"S^"，失败返回"E^原因"
/// Debug:			w ##class(CIS.AN.BL.PACURecord).AutoCreateParaItem("")
ClassMethod AutoCreateParaItem(opsId As %String) As %String
{
	tstart
	set moduleCode = "PACURecord"
	set recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCode(opsId,moduleCode,"")
	
	set result="",saveResult=""
	kill data
	
	set data("ClassName")="CIS.AN.ParaItem"
	set data("RecordSheet")=recordSheetId
	
	set paraItemId=$$GetParaItemId(recordSheetId,"OperationEvent")
	if (paraItemId="")
	{
		set data("CategoryItem")=""
		set data("Code")="OperationEvent"
		set data("Description")="PACU事件"
		set DataCategory=$o(^CT.AN.DataCategoryI("ICode"," "_$ZCVT(data("Code"),"U"),""))
		set data("DataCategory")=DataCategory
		set data("Seq")="1"
	
		if (data("DataCategory")'="")
		{
			set saveResult=##class(CIS.AN.COM.DataService).SaveData(.data)
		}

		break  //after save OperationEvent
		if ($piece(saveResult,"^",1)'="S")
		{
			trollback
			quit saveResult		
		}
	}
	
	set paraItemId=$$GetParaItemId(recordSheetId,"OperationDrug")
	if (paraItemId="")
	{
		set data("CategoryItem")=""
		set data("Code")="OperationDrug"
		set data("Description")="间断用药"
		set DataCategory=$o(^CT.AN.DataCategoryI("ICode"," "_$ZCVT(data("Code"),"U"),""))
		set data("DataCategory")=DataCategory
		set data("Seq")="2"
	
		if (data("DataCategory")'="")
		{
			set saveResult=##class(CIS.AN.COM.DataService).SaveData(.data)
		}

		if ($piece(saveResult,"^",1)'="S")
		{
			trollback
			quit saveResult		
		}
	}
	
	tcommit
	quit "S^"
	
GetParaItemId(recordSheetId,code)
	set result=""
	&sql(SELECT RowId into :result FROM CIS_AN.ParaItem 
		WHERE RecordSheet=:recordSheetId and Code=:code)
	quit result
}

/// Creator：      	雍阳
/// CreatDate：    	2018-09-17
/// Description： 	启动麻醉监护后自动创建入手术间事件
/// Table：        	CIS.AN.OperSchedule
/// Input:			opsId:手术排班表ID
/// Return：       	启动成功返回"S^"，失败返回"E^原因"
/// Debug:			w ##class(CIS.AN.BL.PACURecord).AutoCreateEvent("7","274","2018-09-25 09:00","OperRoomIn")
ClassMethod AutoCreateEvent(opsId As %String, userId As %String, dateTime As %String, eventCode As %String = "OperRoomIn", userDefinedItemId As %String = "") As %String
{
	tstart
	
	set moduleCode = "PACURecord"
	set recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCode(opsId,moduleCode,"")
	set paraItemId=$$GetParaItemId(recordSheetId,"OperationEvent")
	set dataItemId=$$GetDataItemId(eventCode)
	
	if (recordSheetId="")||(paraItemId="") ||((dataItemId="")&&(userDefinedItemId=""))
	{
		trollback
		quit "E^数据错误"		
	}
	set rowId=$$GetExistedAnaDataId(paraItemId,dataItemId,userDefinedItemId)
	set date=$p(dateTime," ",1)
	set time=$p(dateTime," ",2)
	
	set result="",saveResult=""
	kill data
	
	set data("ClassName")="CIS.AN.AnaData"
	set data("RowId")=rowId
	set data("ParaItem")=paraItemId
	set data("DataItem")=dataItemId
	set data("UserDefinedItem")=userDefinedItemId
	set data("EditFlag")="N"
	set data("StartDate")=date
	set data("StartTime")=time
	set data("EndDate")=date
	set data("EndTime")=time
	set data("CreateUserID")=userId
	set data("Source")="M"
	set saveResult=##class(CIS.AN.COM.DataService).SaveData(.data)

	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult		
	}
	
	tcommit
	quit "S^"
	
GetParaItemId(recordSheetId,code)
	set result=""
	&sql(SELECT RowId into :result FROM CIS_AN.ParaItem 
		WHERE RecordSheet=:recordSheetId and Code=:code)
	quit result
	
GetDataItemId(code)
	set result=""
	&sql(SELECT RowId into :result FROM CT_AN.DataItem
		WHERE Code=:code)
	quit result
	
GetExistedAnaDataId(paraItemId,dataItemId,userDefinedItemId)
	set result=""
	&sql(SELECT RowId into :result FROM CIS_AN.AnaData
		WHERE ParaItem=:paraItemId 
		and ((DataItem=:categoryItemId and DataItem is not NULL)
			or (UserDefinedItem=:userDefinedItemId and UserDefinedItem is not NULL)))
			
	quit result
}

/// Creator：      	雍阳
/// CreatDate：    	2018-10-23
/// Description： 	自动生成设备使用记录
/// Table：        	CIS.AN.EquipRecord
/// Input:			opsId：手术计划ID
/// Return：       	启动成功返回"S^"，失败返回"E^原因"
/// Debug:			w ##class(CIS.AN.BL.PACURecord).AutoCreateDeviceUsage("9035","7463","2018-11-5 9:30:00")
ClassMethod AutoCreateDeviceUsage(opsId As %String, userId As %String, datetime As %String) As %String
{
	set operSchedule = ##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set pacuBed = operSchedule.PACUBed
	quit:pacuBed=""
	
	set OperDeptID = operSchedule.PACUBed.OperDeptID
	set hospitalId = $p($g(^CTLOC(+OperDeptID)),"^",22)
	set hospitalDesc = $p($g(^CT("HOSP",+hospitalId)),"^",2)
	
	set moduleCode = "PACURecord"
	set recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCode(opsId,moduleCode,"")
	
	set ANDeptCode="ANDEPT"
	if hospitalDesc["华西院区" set ANDeptCode="HXANDEPT"
	
	set anDeptId=##class(CIS.AN.BL.DataConfiguration).GetValueByKey(ANDeptCode)
	set devices = ##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.ConfigQueries:FindDeptEquipAN",anDeptId,pacuBed.%Id(),"")
	
	set date=$p(datetime," ",1)
	set time=$p(datetime," ",2)
	
	set saveResult=""
	tstart
	
	for i=1:1:(devices.Size)
	{
		set device = devices.GetAt(i)
		quit:device=""
		
		set equipId = device.GetValue("RowId")
		set equipRecordId = $$GetEquipRecordId(recordSheetId,equipId)
		
		//write "Equip:",equipId,"  existed equip record:",equipRecordId,!
		continue:(equipRecordId'="")&&(usageEndDate'="") //已停止的设备不再修改时间
		
		kill equipRecord
		set equipRecord("ClassName")="CIS.AN.EquipRecord"
		set equipRecord("RowId")=equipRecordId
		set equipRecord("RecordSheet")=recordSheetId
		set equipRecord("Equip")=equipId
		set equipRecord("StartDate")=date
		set equipRecord("StartTime")=time
		set equipRecord("UpdateUser")=userId
		
		set saveResult=##class(CIS.AN.COM.DataService).SaveData(.equipRecord)

		if ($piece(saveResult,"^",1)'="S")
		{
			quit
		}
	}
	
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit
	}
	tcommit
	quit saveResult

GetEquipRecordId(recordSheetId,equipId)
	set result="",usageEndDate=""
	&sql(SELECT RowId,EndDate into :result,:usageEndDate FROM CIS_AN.EquipRecord
		WHERE RecordSheet=:recordSheetId and Equip=:equipId)
	quit result
}

/// Creator：      	雍阳
/// CreatDate：    	2018-08-03
/// Description： 	停止麻醉监护
/// Table：        	CIS.AN.OperSchedule
/// Input:			data:停止监护参数
/// Return：       	启动成功返回"S^"，失败返回"E^原因"
/// Debug:			w ##class(CIS.AN.BL.PACURecord).StopRecord(^TMPAN("PACURecord","StopRecord"))
ClassMethod StopRecordOld(data As %String) As %String
{
	tstart
	set result="",saveResult=""
	set status=##class(CIS.AN.COM.String).ToArray(data,.array)
	kill operSchedule,anathesia
	
	set anaesthesia("ClassName")="CIS.AN.Anaesthesia"
	
	set i = ""
	for
	{
		set i = $o(array(i))
		quit:i=""
		
		kill PLIST
		merge PLIST = array(i)
		
		continue:$g(PLIST("ClassName"))=""
		
		if (PLIST("ClassName")="CIS.AN.OperSchedule")
		{
			merge operSchedule=PLIST
			if ($get(PLIST("Status"))="")&($get(PLIST("StatusCode"))'="")
			{
				set PLIST("Status")=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode(PLIST("StatusCode"))
			}
			
			set anaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId($get(PLIST("RowId")))
			set anaesthesia("RowId")=anaId
			set anaesthesia("PACUOutDT")=PLIST("PACUOutDT")
			set anaesthesia("AreaOutTransLoc")=PLIST("AreaOutTransLoc")
		}
		elseif (PLIST("ClassName")="CIS.AN.AnaestEvaluation")
		{
			set rowId = $o(^CIS.AN.AnaestEvaluationI("OPS",PLIST("OperSchedule"),""))
			set PLIST("RowId")=rowId
			set PLIST("EvaluateDate")=+$h
			set PLIST("EvaluateTime")=$p($h,",",2)
		}
		
		set saveResult=##class(CIS.AN.COM.DataService).SaveData(.PLIST)
		if ($piece(saveResult,"^",1)'="S")
		{
			trollback
			quit	
		}
	}
	
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult		
	}

	set saveResult=##class(CIS.AN.COM.DataService).SaveData(.anaesthesia)
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult		
	}
	
	/// 写入手术操作过程 CCQ 20200225
	set saveResult=##class(CIS.AN.BL.SurgicalProcedure).SaveProcedureAfterStop(operSchedule("RowId"),"PO",operSchedule("UpdateUser"),operSchedule("PACUOutDT"))
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult		
	}
	
	// 回写旧表 CCQ20200402
	set saveResult=##class(CIS.AN.SRV.OperAppService).StopPACURecord(operSchedule("RowId"),"")
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult		
	}
	
	tcommit
	
	do ..StopAllContinuousData(operSchedule("RowId"),operSchedule("PACUOutDT"))
	do ..StopAllDeviceUsage(operSchedule("RowId"),operSchedule("PACUOutDT"))
	do ..AutoCreateEvent(operSchedule("RowId"),operSchedule("UpdateUser"),operSchedule("PACUOutDT"),"PACUOut")
	do ..SubmitRecord(operSchedule("RowId"),operSchedule("UpdateUser"))
	
	quit "S^"
}

/// Creator：      	雍阳
/// CreatDate：    	2018-08-03
/// Description： 	停止麻醉监护
/// Table：        	CIS.AN.OperSchedule
/// Input:			data:停止监护参数
/// Return：       	启动成功返回"S^"，失败返回"E^原因"
/// Debug:			w ##class(CIS.AN.BL.PACURecord).StopRecord(^TMPAN("PACURecord","StopRecord"))
ClassMethod StopRecord(data As %String) As %String
{
	tstart
	set result="",saveResult=""
	set status=##class(CIS.AN.COM.String).ToArray(data,.array)
	kill schedule,anaesthesia,PLIST
	
	merge PLIST = array(1)
	
	set anaesthesia("ClassName")="CIS.AN.Anaesthesia"
	set schedule("ClassName")="CIS.AN.OperSchedule"
	
	set schedule("RowId")=PLIST("RowId")
	set schedule("StatusCode")=PLIST("StatusCode")
	set schedule("UpdateUser")=PLIST("UpdateUser")
	
	if ($get(schedule("Status"))="")&($get(schedule("StatusCode"))'="")
	{
		set schedule("Status")=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode(schedule("StatusCode"))
	}

	set saveResult=##class(CIS.AN.COM.DataService).SaveData(.schedule)
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult		
	}
	
	set anaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId($get(schedule("RowId")))
	set anaesthesia("RowId")=anaId
	set anaesthesia("PACUOutDT")=PLIST("PACUOutDT")
	set anaesthesia("AreaOutTransLoc")=PLIST("AreaOutTransLoc")

	set saveResult=##class(CIS.AN.COM.DataService).SaveData(.anaesthesia)
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult		
	}
	
	/// 写入手术操作过程 CCQ 20200225
	set saveResult=##class(CIS.AN.BL.SurgicalProcedure).SaveProcedureAfterStop(PLIST("RowId"),"PO",PLIST("UpdateUser"),PLIST("PACUOutDT"))
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult		
	}
	
	tcommit
	set opsId=PLIST("RowId")
	do ..StopAllContinuousData(PLIST("RowId"),PLIST("PACUOutDT"))
	do ..StopAllDeviceUsage(PLIST("RowId"),PLIST("PACUOutDT"))
	do ..AutoCreateEvent(PLIST("RowId"),PLIST("UpdateUser"),PLIST("PACUOutDT"),"PACUOut")
	do ..SubmitRecord(PLIST("RowId"),PLIST("UpdateUser"))
	do ..TriggerEvent(PLIST("RowId"),"PACUIn","Finish")
	
	do ..AfterStopRecord(opsId)
	quit "S^"
}

ClassMethod AfterStopRecord(opsId) As %Status
{
	try
	{
		// 回写旧表
		set saveResult=##class(CIS.AN.SRV.OperAppService).StopPACURecord(opsId,"")
	}
	catch(e)
	{
	}
	
	quit $$$OK
}

/// Creator：      	雍阳
/// CreatDate：    	2020-11-4
/// Description： 	提交表单
/// Table：        	CIS.AN.RecordSheet
/// Input:			opsId:手术计划ID
/// Return：       	启动成功返回"S^"，失败返回"E^原因"
/// Debug:			w ##class(CIS.AN.BL.AnaestRecord).SubmitRecord("")
ClassMethod SubmitRecord(opsId As %String, userId As %String) As %String
{
	set moduleCode = "AnaestRecord"
	set recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCode(opsId,moduleCode,"")
	
	set recordSheet=##class(CIS.AN.RecordSheet).%OpenId(recordSheetId)
	set editFlag=recordSheet.EditFlag
	
	if editFlag="N"
	{
		kill savingData
		set savingData("ClassName")="CIS.AN.RecordSheet"
		set savingData("RowId")=recordSheetId
		set savingData("EditFlag")="S"
		set savingData("SubmitUser")=userId
		set savingData("SubmitDate")=+$h
		set savingData("SubmitTime")=$p($h,",",2)
		set saveResult=##class(CIS.AN.COM.DataService).SaveData(.savingData)
	}
	
	quit "S^"
}

/// Creator：      	雍阳
/// CreatDate：    	2018-09-25
/// Description： 	停止PACU监护
/// Table：        	CIS.AN.OperSchedule
/// Input:			data:停止监护参数
/// Return：       	启动成功返回"S^"，失败返回"E^原因"
/// Debug:			w ##class(CIS.AN.BL.PACURecord).StopRecord("")
ClassMethod StopPACURecord(data As %String) As %String
{
	tstart
	set result=""
	set status=##class(CIS.AN.COM.String).ToArray(data,.array)
	merge operSchedule=array(1)
	if ($get(operSchedule("Status"))="")&($get(operSchedule("StatusCode"))'="")
	{
		set operSchedule("Status")=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode(operSchedule("StatusCode"))
	}	
	set saveResult=##class(CIS.AN.COM.DataService).SaveData(.operSchedule)
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult		
	}
	tcommit
	
	quit "S^"
}

/// Creator：      	雍阳
/// CreatDate：    	2018-09-25
/// Description： 	停止麻醉监护时，停止所有连续用药
/// Table：        	CIS.AN.DrugData
/// Input:			
/// Return：       	启动成功返回"S^"，失败返回"E^原因"
/// Debug:			w ##class(CIS.AN.BL.PACURecord).StopAllContinuousData("7","2018-09-25 11:00")
ClassMethod StopAllContinuousData(opsId, dateTime) As %String
{
	set moduleCode="PACURecord"
	set recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCode(opsId,moduleCode,"")
	
	set date=$p(dateTime," ",1)
	set time=$p(dateTime," ",2)
	
	kill data
	set data("ClassName")="CIS.AN.AnaData"
	
	set continuousDataList=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.PACURecord:FindContinuousData",recordSheetId)
	set continuousData=""
	for i=1:1:(continuousDataList.Size)
	{
		set continuousData=continuousDataList.GetAt(i)
		quit:continuousData=""
		
		set rowId=continuousData.GetValue("RowId")
		set endDate=continuousData.GetValue("EndDate")
		set endTime=continuousData.GetValue("EndTime")
		if (endDate=2980013)
		{
			set data("RowId")=rowId
			set data("EndDate")=date
			set data("EndTime")=time
			set saveResult=##class(CIS.AN.COM.DataService).SaveData(.data)
		}
	}
	
	quit "S^"
}

/// Creator：      	雍阳
/// CreatDate：    	2018-09-25
/// Description： 	停止麻醉监护时，停止所有设备使用
/// Table：        	CIS.AN.EquipRecord
/// Input:			
/// Return：       	启动成功返回"S^"，失败返回"E^原因"
/// Debug:			w ##class(CIS.AN.BL.PACURecord).StopAllDeviceUsage("7","2018-09-25 11:00")
ClassMethod StopAllDeviceUsage(opsId, dateTime) As %String
{
	set moduleCode="PACURecord"
	set recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCode(opsId,moduleCode,"")
	
	set date=$p(dateTime," ",1)
	set time=$p(dateTime," ",2)
	
	kill data
	set data("ClassName")="CIS.AN.EquipRecord"
	
	set ret=..GetEquipUsage(recordSheetId,.deviceUsages)
	set deviceUsage="",rowId=""
	for
	{
		set rowId=$o(deviceUsages(rowId))
		quit:rowId=""
		
		set endDate=$g(deviceUsages(rowId,"EndDate"))
		set endTime=$g(deviceUsages(rowId,"EndTime"))
		if (endDate=2980013)||(endDate="")
		{
			set data("RowId")=rowId
			set data("EndDate")=date
			set data("EndTime")=time
			set saveResult=##class(CIS.AN.COM.DataService).SaveData(.data)
		}
	}
	
	quit "S^"
}

/// Creator：      	陈长青
/// CreatDate：    	2017-10-11
/// Description： 	查询麻醉记录数据
/// Table：        	DHCAN.RecordData
/// Input:			opsId:手术计划ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.PACURecord","FindSheetRecords","1","N")
Query FindAnaDatas(sheetId As %String, editFlag As %String = "") As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT RowId,
	   ParaItem,
	   %ODBCOUT(StartDate) As StartDate,
	   %ODBCOUT(StartTime) As StartTime,
	   %ODBCOUT(EndDate) As EndDate,
	   %ODBCOUT(EndTime) As EndTime,
	   DataValue,
	   EditFlag,
	   FromData,
	   Continuous,
	   CreateUserID,
	   %ODBCOUT(CreateDate)_' '_%ODBCOUT(CreateTime) As CreateDT,
	   %ODBCOUT(StartDate)_' '_%ODBCOUT(StartTime) As StartDT,
	   %ODBCOUT(EndDate)_' '_%ODBCOUT(EndTime) As EndDT,
	   DataItem As DataItem,
	   DataItem->Code As DataItemCode,
	   DataItem->Description As DataItemDesc,
	   DataItem->ItemCategory As ItemCategory,
	   UserDefinedItem,
	   UserDefinedItem->Description As UserDefinedItemDesc,
	   CIS_AN_Com.String_AlterDesc(DataItem->Description,UserDefinedItem->Description) As DataItemDesc,
	   CIS_AN_Com.String_AlterDesc(DataItem->ItemCategory,UserDefinedItem->ItemCategory) As ItemCategory,
	   ParaItem->DataCategory As DataCategory,
	   ParaItem->Description As ParaItemDesc
	   from CIS_AN.AnaData 
       where ParaItem->RecordSheet=:sheetId
       and (EditFlag=:editFlag or :editFlag is null)
}

/// Creator：      	雍阳
/// CreatDate：    	2018-9-25
/// Description： 	查询所有连续数据
/// Table：        	CIS_AN.AnaData
/// Input:			recordSheetId:表单ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.DataQueries","FindContinuousData")
Query FindContinuousData(recordSheetId As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT *
	from CIS_AN.AnaData
	where ParaItem->RecordSheet=:recordSheetId
	and ((not EndDate=StartDate) or (not EndTime=StartTime))
	and EditFlag="N"
}

/// Creator：      	陈长青
/// CreatDate：    	2017-11-7
/// Description： 	查询麻醉记录数据
/// Table：        	DHCAN.DrugData
/// Input:			opsId:手术计划ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.PACURecord","FindDrugDatas","1","N")
Query FindDrugDatas(sheetId As %String, editFlag As %String = "") As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT *,
	   CIS_AN_Com.String_PatchFloat(DoseQty) As DoseQty,
	   CIS_AN_Com.String_PatchFloat(Speed) As Speed,
	   CIS_AN_Com.String_PatchFloat(Concentration) As Concentration,
	   DoseUnit->Description As DoseUnitDesc,
	   SpeedUnit->Description As SpeedUnitDesc,
	   ConcentrationUnit->Description As ConcentrationUnitDesc,
	   CIS_AN_COM.String_GetDescByID('User.PHCInstruc','PHCINDesc1',Instruction) As InstructionDesc,
	   CIS_AN_Com.String_GetDescByID("User.ARCItmMast","ARCIMDesc",ArcimID) As ArcimDesc,
	   CIS_AN_Com.String_GetDescByID("User.CTLoc","CTLOCDesc",RecvLoc) As RecvLocDesc,
	   %ODBCOUT(AnaData->StartDate)_' '_%ODBCOUT(AnaData->StartTime) As StartDT,
	   %ODBCOUT(AnaData->EndDate)_' '_%ODBCOUT(AnaData->EndTime) As EndDT
	   from CIS_AN.DrugData 
       where AnaData->ParaItem->RecordSheet=:sheetId
       and (:editFlag="" or AnaData->EditFlag=:editFlag)
}

/// Creator：      	陈长青
/// CreatDate：    	2017-10-11
/// Description： 	保存麻醉记录数据
/// Table：        	DHCAN.RecordData
/// Input:			opsId:手术计划ID，data:数据参数，userId:用户ID，moduleId:模块ID
/// Return：       	保存成功返回"S^"，失败返回"E^原因"
/// Debug:			w ##class(CIS.AN.BL.PACURecord).StartRecord("")
ClassMethod SaveAnaDataOld(opsId As %String, data As %String, userId As %String, moduleId As %String) As %String
{
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术计划不存在！"
	quit:(data="") "E^保存的数据不能为空！"
	
	set $zt="Error"
	tstart
	set sc=##class(CIS.AN.COM.String).ToArray(data,.array)
	set objIndex=0,saveResult="S^"
	for
	{
		set objIndex=$order(array(objIndex))
		quit:(objIndex="")
		kill anaData
		m anaData=array(objIndex)
		set saveResult=##class(CIS.AN.COM.DataService).SaveData(.anaData)
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

/// Creator：      	陈长青
/// CreatDate：    	2017-10-11
/// Description： 	保存麻醉记录数据
/// Table：        	DHCAN.RecordData
/// Input:			opsId:手术计划ID，data:数据参数，userId:用户ID，moduleId:模块ID
/// Return：       	保存成功返回"S^"，失败返回"E^原因"
/// Debug:			w ##class(CIS.AN.BL.PACURecord).StartRecord("")
ClassMethod SaveAnaData(opsId As %String, data As %String, userId As %String, moduleId As %String) As %String
{
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术计划不存在！"
	quit:(data="") "E^保存的数据不能为空！"
	
	kill anathesia
	set anaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
	set anathesia("RowId")=anaId
	set anathesia("ClassName")="CIS.AN.Anaesthesia"
	
	set needSyncEventCode("PACUIn")="PACUInDT"
	set needSyncEventCode("PACUOut")="PACUOutDT"
	
	
	set $zt="Error"
	tstart
	set sc=##class(CIS.AN.COM.String).ToArray(data,.array)
	set objIndex=0,saveResult="S^"
	for
	{
		set objIndex=$order(array(objIndex))
		quit:(objIndex="")
		kill anaData
		m anaData=array(objIndex)
		set:$g(anaData("Source"))="" anaData("Source")="M"
		set anaData("UpdateUser")=userId
		set anaData("UpdateDate")=+$h
		set anaData("UpdateTime")=$p($h,",",2)
		if $g(anaData("RowId"))="" set anaData("CreateUserID")=userId
		set saveResult=##class(CIS.AN.COM.DataService).SaveData(.anaData)
		quit:($piece(saveResult,"^",1)'="S")
		
		do SyncEventDateTime(.anaData)
	}
	
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult	
	}
	
	set saveResult=##class(CIS.AN.COM.DataService).SaveData(.anathesia)
		
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult	
	}
	tcommit
	quit "S^"
	
SyncEventDateTime(anaData)
	if ($g(anaData("ItemCategory"))="E")&&($g(anaData("DataItem"))'="")
	{
		set dataItemCode=$$GetDataItemCode(anaData("DataItem"))
		if $d(needSyncEventCode(dataItemCode))
		{
			set field=needSyncEventCode(dataItemCode)
			set value=$g(anaData("StartDate"))_" "_$g(anaData("StartTime"))
			do SetANADateTime(field,value,$g(anaData("EditFlag")))
		}
	}
	quit

GetDataItemCode(dataItemId)
	set dataItemCode=""
	&sql(SELECT Code into :dataItemCode FROM CT_AN.DataItem 
		WHERE RowId=:dataItemId)
	if SQLCODE quit ""
	quit dataItemCode
	
SetANADateTime(field,value,editflag)
	//if (editflag="D")&&('$d(opsData(field))) set value=""
	set anathesia(field)=value
	quit

Error
	trollback
	quit "E^"_$ze
}

/// Creator：      	陈长青
/// CreatDate：    	2017-10-11
/// Description： 	保存麻醉记录药品数据
/// Table：        	DHCAN.RecordData  DHCAN.DrugData
/// Input:			opsId:手术计划ID，data:数据参数，userId:用户ID，moduleId:模块ID
/// Return：       	保存成功返回"S^"，失败返回"E^原因"
/// Debug:			w ##class(CIS.AN.BL.PACURecord).SaveDrugData("")
ClassMethod SaveDrugData(opsId As %String, data As %String, userId As %String, moduleId As %String) As %String
{
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术计划不存在！"
	//quit:(##class(CT.AN.DataModule).%ExistsId(moduleId)=0) "E^数据模块不存在！"
	quit:(data="") "E^保存的数据不能为空！"
	
	set $zt="Error"
	tstart
	set sc=##class(CIS.AN.COM.String).ToArray(data,.array)
	set anaDataIndex=0,saveResult="S^"
	for
	{
		set anaDataIndex=$order(array(anaDataIndex))
		quit:(anaDataIndex="")
		continue:($get(array(anaDataIndex,"ClassName"))'="CIS.AN.AnaData")
		kill anaData
		m anaData=array(anaDataIndex)
		
		set:$g(anaData("Source"))="" anaData("Source")="M"
		set anaData("UpdateUser")=userId
		set anaData("UpdateDate")=+$h
		set anaData("UpdateTime")=$p($h,",",2)
		if $g(anaData("RowId"))="" set anaData("CreateUserID")=userId
		
		set saveResult=##class(CIS.AN.COM.DataService).SaveData(.anaData)
		quit:($piece(saveResult,"^",1)'="S")
		set guid = $g(anaData("Guid"))
		set anaDataRowId=+$piece(saveResult,"^",2)
		set drugDataIndex=0,saveResult="S^"
		for
		{
			set drugDataIndex=$order(array(drugDataIndex))
			quit:(drugDataIndex="")
			continue:($get(array(drugDataIndex,"ClassName"))'="CIS.AN.DrugData")
			continue:($get(array(drugDataIndex,"AnaDataGuid"))'=guid)
			kill drugData
			m drugData=array(drugDataIndex)
			set drugData("AnaData")=anaDataRowId
			set saveResult=##class(CIS.AN.COM.DataService).SaveData(.drugData)
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

/// Creator：      	陈长青
/// CreatDate：    	2017-11-9
/// Description： 	查询药品项目
/// Table：        	
/// Input:			filterDesc:安全组名称筛选字符串
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.PACURecord","FindDrugItems")
Query FindDrugItems() As %Query(ROWSPEC = "RowId,DataItem,DoseUnit,DoseUnitDesc,DoseQty,Concentration,ConcentrationUnit,ConcentrationUnitDesc,Reason,Speed,SpeedUnit,SpeedUnitDesc,RecvLocID,Duration,ArcimID,ArcimDesc,InstrID,InstrDesc,InstrShortDesc,EqualUomID,EqualUomDesc,EqualUomCode,DefaultDose,EqualQty") [ SqlProc ]
{
}

ClassMethod FindDrugItemsExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	set query=##class(%ResultSet).%New("CIS.AN.BL.CodeQueries:FindDrugItem")
	set equivQuery=##class(%ResultSet).%New("CIS.AN.COM.Admission:FindDoseEquiv")
	set sc=query.Execute("")
	while(query.%Next())
	{
		set drgFormID=query.Get("DrgFormID")
		continue:(drgFormID="")
		set rowId=query.Get("RowId")
		set dataItem=query.Get("DataItem")
		set doseUnit=query.Get("DoseUnit")
		set doseUnitDesc=query.Get("DoseUnitDesc")
		set doseQty=query.Get("DoseQty")
		set concentration=query.Get("Concentration")
		set concentrationUnit=query.Get("ConcentrationUnit")
		set concentrationUnitDesc=query.Get("ConcentrationUnitDesc")
		set reason=query.Get("Reason")
		set speed=query.Get("Speed")
		set speedUnit=query.Get("SpeedUnit")
		set speedUnitDesc=query.Get("SpeedUnitDesc")
		set recvLocID=query.Get("RecvLocID")
		set duration=query.Get("Duration")
		set arcimID=query.Get("ArcimID")
		set arcimDesc=query.Get("ArcimDesc")
		set instrID=drgFormID.PHCDFPHCINDR.%Id()
		set instrDesc=drgFormID.PHCDFPHCINDR.PHCINDesc1
		set instrShortDesc=drgFormID.PHCDFPHCINDR.PHCINDesc2
		set sc=equivQuery.Execute(drgFormID.%Id())
		
		while(equivQuery.%Next())
		{
			set equalUomID=equivQuery.Get("UomID")
			set equalUomDesc=equivQuery.Get("UomDesc")
			set equalUomCode=equivQuery.Get("UomCode")
			set defaultDose=equivQuery.Get("DefaultDose")
			set equalQty=equivQuery.Get("EqualQty")
			do OutputRow	
		}	
	}
	
	s qHandle=$lb(0,repid,0)
	q $$$OK	
OutputRow
	s Data=$lb(rowId,dataItem,doseUnit,doseUnitDesc,doseQty,
		concentration,concentrationUnit,concentrationUnitDesc,reason,speed,
		speedUnit,speedUnitDesc,recvLocID,duration,arcimID,
		arcimDesc,instrID,instrDesc,instrShortDesc,equalUomID,
		equalUomDesc,equalUomCode,defaultDose,equalQty)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod FindDrugItemsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDrugItemsExecute ]
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

ClassMethod FindDrugItemsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDrugItemsExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// Creator：      	陈长青
/// CreatDate：    	2017-11-29
/// Description： 	保存麻醉记录事件数据
/// Table：        	DHCAN.RecordData  DHCAN.EventData
/// Input:			opsId:手术计划ID，data:数据参数，userId:用户ID，moduleId:模块ID
/// Return：       	保存成功返回"S^"，失败返回"E^原因"
/// Debug:			w ##class(CIS.AN.BL.PACURecord).SaveEventData("")
ClassMethod SaveEventDataOld(opsId As %String, data As %String, userId As %String, moduleId As %String) As %String
{
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术计划不存在！"
	//quit:(##class(CT.AN.DataModule).%ExistsId(moduleId)=0) "E^数据模块不存在！"
	quit:(data="") "E^保存的数据不能为空！"
	
	set $zt="Error"
	tstart
	set sc=##class(CIS.AN.COM.String).ToArray(data,.array)
	set dataIndex=0,saveResult=""
	for
	{
		set dataIndex=$order(array(dataIndex))
		quit:(dataIndex="")
		continue:($get(array(dataIndex,"ClassName"))'="CIS.AN.AnaData")
		kill anaData
		m anaData=array(dataIndex)
		set saveResult=##class(CIS.AN.COM.DataService).SaveData(.anaData)
		quit:($piece(saveResult,"^",1)'="S")
		set guid = $g(anaData("Guid"))
		set anaDataRowId=$piece(saveResult,"^",2)
		set detailIndex=0
		for
		{
			set detailIndex=$order(array(detailIndex))
			quit:(detailIndex="")
			continue:($get(array(detailIndex,"ClassName"))'="CIS.AN.EventData")
			continue:($get(array(detailIndex,"AnaDataGuid"))'=guid)
			kill detailData
			m detailData=array(detailIndex)
			set detailData("AnaData")=anaDataRowId
			set saveResult=##class(CIS.AN.COM.DataService).SaveData(.detailData)
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

/// Creator：      	陈长青
/// CreatDate：    	2017-11-29
/// Description： 	保存麻醉记录事件数据
/// Table：        	DHCAN.RecordData  DHCAN.EventData
/// Input:			opsId:手术计划ID，data:数据参数，userId:用户ID，moduleId:模块ID
/// Return：       	保存成功返回"S^"，失败返回"E^原因"
/// Debug:			w ##class(CIS.AN.BL.PACURecord).SaveEventData(^TMPAN("SaveEventData","opsId"),^TMPAN("SaveEventData","data"),^TMPAN("SaveEventData","userId"),^TMPAN("SaveEventData","moduleId"))
ClassMethod SaveEventData(opsId As %String, data As %String, userId As %String, moduleId As %String) As %String
{
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术计划不存在！"
	//quit:(##class(CT.AN.DataModule).%ExistsId(moduleId)=0) "E^数据模块不存在！"
	quit:(data="") "E^保存的数据不能为空！"
	
	kill anathesia
	set anaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
	set anathesia("RowId")=anaId
	set anathesia("ClassName")="CIS.AN.Anaesthesia"
	
	set needSyncEventCode("PACUIn")="PACUInDT"
	set needSyncEventCode("PACUOut")="PACUOutDT"
	
	set $zt="Error"
	tstart
	set sc=##class(CIS.AN.COM.String).ToArray(data,.array)
	set dataIndex=0,saveResult=""
	for
	{
		set dataIndex=$order(array(dataIndex))
		quit:(dataIndex="")
		continue:($get(array(dataIndex,"ClassName"))'="CIS.AN.AnaData")
		kill anaData
		m anaData=array(dataIndex)
		set:$g(anaData("Source"))="" anaData("Source")="M"
		
		set anaData("UpdateUser")=userId
		set anaData("UpdateDate")=+$h
		set anaData("UpdateTime")=$p($h,",",2)
		if $g(anaData("RowId"))="" set anaData("CreateUserID")=userId
		
		set saveResult=##class(CIS.AN.COM.DataService).SaveData(.anaData)
		quit:($piece(saveResult,"^",1)'="S")
		
		do SyncEventDateTime(.anaData)
		
		set guid = $g(anaData("Guid"))
		set anaDataRowId=$piece(saveResult,"^",2)
		set detailIndex=0
		for
		{
			set detailIndex=$order(array(detailIndex))
			quit:(detailIndex="")
			continue:($get(array(detailIndex,"ClassName"))'="CIS.AN.EventData")
			continue:($get(array(detailIndex,"AnaDataGuid"))'=guid)
			kill detailData
			m detailData=array(detailIndex)
			set detailData("AnaData")=anaDataRowId
			set saveResult=##class(CIS.AN.COM.DataService).SaveData(.detailData)
			quit:($piece(saveResult,"^",1)'="S")
		}
		quit:($piece(saveResult,"^",1)'="S")
	}	
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult	
	}
	
	set saveResult=##class(CIS.AN.COM.DataService).SaveData(.anathesia)
		
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult	
	}
	
	tcommit
	
	
	quit "S^"
	
SyncEventDateTime(anaData)
	if ($g(anaData("ItemCategory"))="E")&&($g(anaData("DataItem"))'="")
	{
		set dataItemCode=$$GetDataItemCode(anaData("DataItem"))
		if $d(needSyncEventCode(dataItemCode))
		{
			set field=needSyncEventCode(dataItemCode)
			set value=$g(anaData("StartDate"))_" "_$g(anaData("StartTime"))
			do SetANADateTime(field,value,$g(anaData("EditFlag")))
		}
	}
	quit


GetDataItemCode(dataItemId)
	set dataItemCode=""
	&sql(SELECT Code into :dataItemCode FROM CT_AN.DataItem 
		WHERE RowId=:dataItemId)
	if SQLCODE quit ""
	quit dataItemCode
	
SetANADateTime(field,value,editflag)
	//if (editflag="D")&&('$d(opsData(field))) set value=""
	set anathesia(field)=value
	quit

Error
	trollback
	quit "E^"_$ze
}

/// Creator：      	陈长青
/// CreatDate：    	2017-11-29
/// Description： 	查询麻醉记录事件明细数据
/// Table：        	DHCAN.EventData
/// Input:			opsId:手术计划ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.PACURecord","FindDrugDatas","1","N")
Query FindEventDatas(sheetId As %String, editFlag As %String = "") As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT *,
	   EventDetailItem->Description As Description,
	   EventDetailItem->Unit As Unit,
	   AnaData->DataItem As DataItem
	   from CIS_AN.EventData 
       where AnaData->ParaItem->RecordSheet=:sheetId
}

/// Creator：      	陈长青
/// CreatDate：    	2018-1-11
/// Description： 	保存麻醉记录间断给药数据
/// Table：        	DHCAN.RecordData  DHCAN.DrugData
/// Input:			opsId:手术计划ID，data:数据参数，userId:用户ID，moduleId:模块ID
/// Return：       	保存成功返回"S^"，失败返回"E^原因"
/// Debug:			w ##class(CIS.AN.BL.PACURecord).SaveIntrmiDrugData("")
ClassMethod SaveIntrmiDrugData(opsId As %String, data As %String, userId As %String, moduleId As %String) As %String
{
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术计划不存在！"
	//quit:(##class(CT.AN.DataModule).%ExistsId(moduleId)=0) "E^数据模块不存在！"
	quit:(data="") "E^保存的数据不能为空！"
	
	set $zt="Error"
	tstart
	set sc=##class(CIS.AN.COM.String).ToArray(data,.array)
	set dataIndex=0,saveResult=""
	for
	{
		set dataIndex=$order(array(dataIndex))
		quit:(dataIndex="")
		continue:($get(array(dataIndex,"ClassName"))'="CIS.AN.AnaData")
		kill anaData
		m anaData=array(dataIndex)
		set saveResult=##class(CIS.AN.COM.DataService).SaveData(.anaData)
		quit:($piece(saveResult,"^",1)'="S")
		set guid = $g(anaData("Guid"))
		set anaDataRowId=$piece(saveResult,"^",2)
		set detailIndex=0
		for
		{
			set detailIndex=$order(array(detailIndex))
			quit:(detailIndex="")
			continue:($get(array(detailIndex,"ClassName"))'="CIS.AN.DrugData")
			continue:($get(array(detailIndex,"AnaDataGuid"))'=guid)
			kill detailData
			m detailData=array(detailIndex)
			set detailData("AnaData")=anaDataRowId
			set saveResult=##class(CIS.AN.COM.DataService).SaveData(.detailData)
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

/// Creator：       雍阳
/// CreatDate：    	2018-05-29
/// Description： 	保存麻醉方法数据
/// Table：        	CIS.AN.Anaesthesia  CIS.AN.AnaestCatheter
/// Input:			opsId:手术计划ID，data:数据参数
/// Return：       	保存成功返回"S^"，失败返回"E^原因"
/// Debug:			w ##class(CIS.AN.BL.PACURecord).SaveAnaestCatheter("")
ClassMethod SaveAnaestCatheter(opsId As %String, data As %String) As %String
{
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术计划不存在！"
	quit:(data="") "E^保存的数据不能为空！"
	
	set $zt="Error"
	tstart
	set sc=##class(CIS.AN.COM.String).ToArray(data,.array)
	set anaIndex=0,saveResult=""
	for
	{
		set anaIndex=$order(array(anaIndex))
		quit:(anaIndex="")
		kill anaesthesia
		merge anaesthesia=array(anaIndex)
		continue:($get(anaesthesia("ClassName"))'="CIS.AN.Anaesthesia")
		set saveResult=##class(CIS.AN.COM.DataService).SaveData(.anaesthesia)
		quit:($piece(saveResult,"^",1)'="S")
		set anaesthesiaID=$piece(saveResult,"^",2),guid=$g(anaesthesia("Guid"))
		set catheterIndex=0
		for
		{
			set catheterIndex=$order(array(catheterIndex))
			quit:(catheterIndex="")
			kill catheter
			merge catheter=array(catheterIndex)
			continue:($get(catheter("ClassName"))'="CIS.AN.AnaestCatheter")
			set AnaesthesiaGuid=catheter("AnaesthesiaGuid")
			continue:(AnaesthesiaGuid'=guid)
			set catheter("Anaesthesia")=anaesthesiaID
			set saveResult=##class(CIS.AN.COM.DataService).SaveData(.catheter)
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
/// CreatDate：    	2018-04-03
/// Description： 	获取生命体征分组后的数据
/// Table：        	DHCAN.RecordData
/// Input:			opsId:手术计划ID，moduleId:模块ID
/// Return：       	数据Json
/// Debug:			w ##class(CIS.AN.BL.PACURecord).GetVitalSignGroupedData(12,77)
ClassMethod GetVitalSignGroupedData(opsId, moduleId) As %String
{
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术计划不存在！"
	quit:(##class(CT.AN.DataModule).%ExistsId(moduleId)=0) "E^数据模块不存在！"
	kill paraItemGroup
	kill paraItemSeq
	
	set recordSheetID=##class(CIS.AN.BL.RecordSheet).GetRecordSheetId(opsId,moduleId,"")
	set paraItemObjects=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.DataQueries:FindParaItems",recordSheetID)
	
	for i=1:1:(paraItemObjects.Size)
	{
		set paraItemObject = paraItemObjects.GetAt(i)
		continue:paraItemObject=""
		
		set paraItemRowId = paraItemObject.GetValue("RowId")
		set paraItemDesc = paraItemObject.GetValue("Description")
		set seq = paraItemObject.GetValue("Seq")
		set dataCategory = paraItemObject.GetValue("DataCategory")
		if (dataCategory = 1)||(dataCategory = 2) set paraItemSeq(seq,paraItemRowId) = paraItemDesc
	}
	
	set recordDatas=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.PACURecord:FindAnaDatas",recordSheetID,"N")
	break
	for i=1:1:(recordDatas.Size)
	{
		set recordData = recordDatas.GetAt(i)
		continue:recordData=""
		set paraItemId = recordData.GetValue("ParaItem")
		set rowId = recordData.GetValue("RowId")
		set dataValue = recordData.GetValue("DataValue")
		set date = recordData.GetValue("StartDate")
		set time = recordData.GetValue("StartTime")
		set dateH = $zdh(date,3)
		set timeH = $zth(time)
	
		set paraItemGroup(paraItemId,rowId)="""col_"_$replace(date,"-","")_$replace(time,":","")_""":{""RowId"":"_rowId_",""ParaItem"":"""_paraItemId_""",""StartDate"":"""_date_""",""StartTime"":"""_time_""",""StartDT"":"""_date_" "_time_""",""DataValue"":"""_dataValue_"""}"
	}
	
	write "{""rows"":["
	
	set seq="",total=0,isFirstItem=1
	for
	{
	
		set seq=$order(paraItemSeq(seq))
		quit:seq=""
		
		set paraItemId=""
		for
		{
			set paraItemId=$order(paraItemSeq(seq,paraItemId))
			quit:paraItemId=""
		
			if 'isFirstItem write ","
			write "{""ParaItem"":""",paraItemId,""",""ParaItemDesc"":""",paraItemSeq(seq,paraItemId),""""
			
			set total=total+1
			set rowId=""
			for
			{
				set rowId=$order(paraItemGroup(paraItemId,rowId))
				quit:rowId=""
				write ",",paraItemGroup(paraItemId,rowId)
			}
		
			write "}"
			set isFirstItem=0
		}
	}
	
	write "],""timeColumnList"":"
	
	do ..GetTimeColumnList(opsId)
	
	write ",""total"":",total
	
	write "}"
	
	quit ""
}

/// Creator：      	雍阳
/// CreatDate：    	2018-04-07
/// Description： 	获取时间列的数据
/// Table：        	DHCAN.TimeLine
/// Input:			opsId:手术计划ID
/// Return：       	数据Json
/// Debug:			w ##class(CIS.AN.BL.PACURecord).GetTimeColumnList(12,27)
ClassMethod GetTimeColumnList(opsId) As %String
{
	kill timeColumnList,timelineList,groupList
	set timeColumnFormat=..#TimeColumnFormat
	
	set startDateTime = ##class(CIS.AN.BL.PACURecord).GetRecordStartDT(opsId)
	set endDateTime = ##class(CIS.AN.BL.PACURecord).GetRecordEndDT(opsId)
	set startDate = ##class(CIS.AN.COM.DateTime).ConvertToDateH($piece(startDateTime," ",1))
	set startTime = ##class(CIS.AN.COM.DateTime).ConvertToTimeH($piece(startDateTime," ",2))
	set endDate = ##class(CIS.AN.COM.DateTime).ConvertToDateH($piece(endDateTime," ",1))
	set endTime = ##class(CIS.AN.COM.DateTime).ConvertToTimeH($piece(endDateTime," ",2))
	
	set endDate=startDate,endTime= 20*3600 - 1200
	
	set timelines=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.PACURecord:FindTimeLines",opsId)
	
	set timelineCount=0
	for i=1:1:(timelines.Size)
	{
		set timeline=timelines.GetAt(i)
		quit:timeline=""
		set timelineCount=i
		set interval=timeline.GetValue("ColumnMinutes")
		set timelineStartDate=timeline.GetValue("StartDate")
		set timelineStartTime=timeline.GetValue("StartTime")
		set timelineEndDate=timeline.GetValue("EndDate")
		set timelineEndTime=timeline.GetValue("EndTime")
		
		set timelineList(i,"StartDate")=timelineStartDate
		set timelineList(i,"StartTime")=timelineStartTime
		set timelineList(i,"EndDate")=timelineEndDate
		set timelineList(i,"EndTime")=timelineEndTime
		
		set groupList(i)=$zt(timelineStartTime,timeColumnFormat)_" ~ "_$zt(timelineEndTime,timeColumnFormat)
		
		set columnCount=(timelineEndDate-timelineStartDate)*60*24\interval
		set columnCount=columnCount+((timelineEndTime-timelineStartTime)\interval\60)
		for j=0:1:columnCount
		{
			set dateTime = ##class(CIS.AN.COM.DateTime).DateTimeAdd(timelineStartDate,timelineStartTime,j*60*interval)
			set date=$piece(dateTime,"^",1)
			set time=$piece(dateTime,"^",2)
			set timeColumnList(date,time)=$zt(time,timeColumnFormat)
			set groupList(i,"col_"_$zd(date,8)_$replace($zt(time),":",""))=""
			set groupList(0,"col_"_$zd(date,8)_$replace($zt(time),":",""))=""
		}
	}
	
	set defaultInterval=5  //默认每列间隔5分钟
	set groupList(0)=$zt(startTime,timeColumnFormat)_" ~ "_$zt(endTime,timeColumnFormat)
	set date=startDate,time=startTime
	set dateTime=date_"^"_time
	set columnCount=(endDate-startDate)*60*24\defaultInterval
	set columnCount=columnCount+((endTime-startTime)\defaultInterval\60)
	for i=0:1:columnCount
	{
		set:i>0 dateTime=##class(CIS.AN.COM.DateTime).DateTimeAdd(date,time,defaultInterval*60)
		set date=$piece(dateTime,"^",1)
		set time=$piece(dateTime,"^",2)
		quit:##class(CIS.AN.COM.DateTime).CompareDateTime(date,time,endDate,endTime)>0

		set isInTimeLine=0
		for j=1:1:timelineCount
		{
			if ((##class(CIS.AN.COM.DateTime).CompareDateTime(date,time,timelineList(j,"StartDate"),timelineList(j,"StartTime"))>=0) && ((##class(CIS.AN.COM.DateTime).CompareDateTime(timelineList(j,"EndDate"),timelineList(j,"EndTime"),date,time))>=0))
			{
				set date=timelineList(j,"EndDate")
				set time=timelineList(j,"EndTime")
				set isInTimeLine=1
			}
		}
		
		continue:isInTimeLine
		
		set timeColumnList(date,time)=$zt(time,timeColumnFormat)
		set groupList(0,"col_"_$zd(date,8)_$replace($zt(time),":",""))=""
	}
	
	write "{"
	write """columns"":["
	set isFirstColumn=1
	set date=""
	for
	{
		set date=$o(timeColumnList(date))
		quit:date=""
		
		set time=""
		for
		{
			set time=$o(timeColumnList(date,time))
			quit:time=""
			
			if 'isFirstColumn write ","
			write "{"
			write """field"":""col_",$zd(date,8),$replace($zt(time),":",""),""""
			write ",""title"":""",timeColumnList(date,time),""""
			write ",""date"":""",$zd(date,3),""""
			write ",""time"":""",$zt(time),""""
			write "}"
			
			set isFirstColumn=0
		}
	}
	
	//write ",{""field"":""col_",20180912091234,""",""title"":""","9:34","""}"
	write "]"
	write ",""groups"":["
	
	set isFirstGroup=1
	set groupId=""
	for
	{
		set groupId=$o(groupList(groupId))
		quit:groupId=""
		
		if 'isFirstGroup write ","
		set groupDesc=groupList(groupId)
		write "{","""text"":","""",groupDesc,""",""columns"":["
		
		set columnField="",isFirstColumn=1
		for
		{
			set columnField=$o(groupList(groupId,columnField))
			quit:columnField=""
			
			if 'isFirstColumn write ","
			write """", columnField,""""
			set isFirstColumn=0
		} 
		
		write "]}"
		set isFirstGroup=0
	}
	write "]"
	
	write "}"
	
	quit ""
}

/// Creator：      	雍阳
/// CreatDate：    	2018-8-6
/// Description： 	恢复记录保存
/// Table：        	CIS.AN.OperSchedule，CT.AN.PACUTransaction
/// Input:			1.data:登记，2.userId:用户
/// Return：       	%String:保存成功或失败
ClassMethod TransactPACU(data, userId) As %String
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
		set isOperSchedule=($get(array(index,"ClassName"))="CIS.AN.OperSchedule")
		set isPACUTransaction=($get(array(index,"ClassName"))="CIS.AN.PACUTransaction")
		continue:('isOperSchedule)&&('isPACUTransaction)
		kill record
		merge record=array(index)
		
		if isOperSchedule
		{
			if $g(record("isChangedSteward")) ="Y"
			{
				kill steward,pacuRecord
				set steward("ClassName")="CIS.AN.StewardAssessment"
				set steward("AssessUser")=userId
				set steward("AssessDate")=+$h
				set steward("AssessTime")=$p($h,",",2)
				set steward("OperSchedule")=record("RowId")
			
				set steward("RowId")=$g(record("InPACUSteward"))
				set steward("Score")=$g(record("InPACUStewardScore"))
				set steward("Conscious")=$g(record("InPACUStewardConscious"))
				set steward("Respiration")=$g(record("InPACUStewardRespiration"))
				set steward("Motion")=$g(record("InPACUStewardMotion"))

				if (steward("Score")'="")
				{
					set saveResult=##class(CIS.AN.COM.DataService).SaveData(.steward)
					quit:($piece(saveResult,"^",1)'="S")
					set:steward("RowId")="" pacuRecord("InSteward")=$p(saveResult,"^",2)
				}
			
				set steward("RowId")=$g(record("OutPACUSteward"))
				set steward("Score")=$g(record("OutPACUStewardScore"))
				set steward("Conscious")=$g(record("OutPACUStewardConscious"))
				set steward("Respiration")=$g(record("OutPACUStewardRespiration"))
				set steward("Motion")=$g(record("OutPACUStewardMotion"))
				if (steward("Score")'="")
				{
					set saveResult=##class(CIS.AN.COM.DataService).SaveData(.steward)
					quit:($piece(saveResult,"^",1)'="S")
					set:steward("RowId")="" pacuRecord("OutSteward")=$p(saveResult,"^",2)
				}
			}
			
			set pacuRecord("ClassName")="CIS.AN.PACURecord"
			set pacuRecord("RowId")=..GetMainPACURecordId(record("RowId"))
			set pacuRecord("OperSchedule")=record("RowId")
			set saveResult=##class(CIS.AN.COM.DataService).SaveData(.pacuRecord)
			quit:($piece(saveResult,"^",1)'="S")
			
			set anaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(record("RowId"))
			kill anathesia
			set anathesia("ClassName")="CIS.AN.Anaesthesia"
			set anathesia("RowId")=anaId
			set anathesia("OperSchedule")=record("RowId")
			if $g(record("isReturnToWait"))="Y" set anathesia("PACUInDT")=""
			set:$g(record("PACUInDT"))'="" anathesia("PACUInDT")=record("PACUInDT")
			set:$g(record("PACUOutDT"))'="" anathesia("PACUOutDT")=record("PACUOutDT")
			set:$g(record("AreaOutTransLoc"))'="" anathesia("AreaOutTransLoc")=record("AreaOutTransLoc")
			set saveResult=##class(CIS.AN.COM.DataService).SaveData(.anathesia)
			quit:($piece(saveResult,"^",1)'="S")
			
			if ($get(record("Status"))="")&($get(record("StatusCode"))'="")
			{
				set record("Status")=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode(record("StatusCode"))
			}
		}
		
		if isPACUTransaction
		{
			set record("UpdateDate")=+$h
			set record("UpdateTime")=$p($h,",",2)
			set record("UpdateUser")=userId
		}
		set saveResult=##class(CIS.AN.COM.DataService).SaveData(.record)
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
/// CreatDate：    	2018-06-25
/// Description： 	查询可用的科室设备
/// Table：        	
/// Input:			deptId:科室ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.PACURecord","FindDeptEquips")
Query FindDeptEquips(deptId As %String) As %Query(ROWSPEC = "RowId,EquipCode,EquipDesc,Manufacturer,EquipMFRDesc,EquipModel,EquipModelDesc,EquipType,EquipTypeDesc,SerialNumber,Location,LocDesc,LastUsageRecordId,LastUsageStartDT,LastUsageEndDT") [ SqlProc ]
{
}

ClassMethod FindDeptEquipsExecute(ByRef qHandle As %Binary, deptId As %String) As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	set query=##class(%ResultSet).%New("CIS.AN.BL.ConfigQueries:FindDeptEquip")
	set sc=query.Execute(deptId)
	while(query.%Next())
	{
		set RowId=query.Get("RowId")
		set EquipCode=query.Get("EquipCode")
		set EquipDesc=query.Get("EquipDesc")
		set Manufacturer=query.Get("Manufacturer")
		set EquipMFRDesc=query.Get("EquipMFRDesc")
		set EquipModel=query.Get("EquipModel")
		set EquipModelDesc=query.Get("EquipModelDesc")
		set EquipType=query.Get("EquipType")
		set EquipTypeDesc=query.Get("EquipTypeDesc")
		set SerialNumber=query.Get("SerialNumber")
		set Location=query.Get("Location")
		set LocDesc=query.Get("LocDesc")
		do LastUsage(RowId)
		do OutputRow
	}
	
	s qHandle=$lb(0,repid,0)
	q $$$OK	
	
LastUsage(equipId)
	set LastUsageRecordId=$order(^CIS.AN.EquipRecordI("Equip",equipId,""),-1)
	if LastUsageRecordId="" quit
	set usageStartDate = $lg(^CIS.AN.EquipRecordD(LastUsageRecordId),3)
	set usageStartTime = $lg(^CIS.AN.EquipRecordD(LastUsageRecordId),4)
	set usageEndDate = $lg(^CIS.AN.EquipRecordD(LastUsageRecordId),5)
	set usageEndTime = $lg(^CIS.AN.EquipRecordD(LastUsageRecordId),6)
	set LastUsageStartDT = $zd(usageStartDate,3)_" "_$zt(usageStartTime)
	set LastUsageEndDT = $zd(usageEndDate,3)_" "_$zt(usageEndTime)
	quit
OutputRow
	s Data=$lb(RowId,EquipCode,EquipDesc,Manufacturer,EquipMFRDesc,
	EquipModel,EquipModelDesc,EquipType,EquipTypeDesc,SerialNumber,
	Location,LocDesc,LastUsageRecordId,LastUsageStartDT,LastUsageEndDT)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod FindDeptEquipsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDeptEquipsExecute ]
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

ClassMethod FindDeptEquipsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDeptEquipsExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// Creator：      	雍阳
/// CreatDate：    	2018-06-26
/// Description： 	保存术中使用设备
/// Table：        	CIS_AN.EquipRecord
/// Input:			opsId:手术计划ID，data:数据参数，userId:用户ID
/// Return：       	保存成功返回"S^"，失败返回"E^原因"
/// Debug:			w ##class(CIS.AN.BL.PACURecord).SaveDeviceUsage("")
ClassMethod SaveDeviceUsage(opsId As %String, data As %String, userId As %String) As %String
{
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术计划不存在！"
	quit:(data="") "E^保存的数据不能为空！"
	
	set $zt="Error"
	tstart
	set sc=##class(CIS.AN.COM.String).ToArray(data,.array)
	set objIndex=0,saveResult="S^"
	for
	{
		set objIndex=$order(array(objIndex))
		quit:(objIndex="")
		kill usage
		m usage=array(objIndex)
		set usage("ClassName")="CIS.AN.EquipRecord"
		if $g(usage("isRemoved"))="Y" set saveResult=##class(CIS.AN.COM.DataService).DelData(usage("ClassName"),usage("RowId"))
		else  set saveResult=##class(CIS.AN.COM.DataService).SaveData(.usage)
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
/// CreatDate：    	2018-06-26
/// Description： 	保存模板
/// Table：        	CF_AN.ModuleTemplate,CF_AN.ModuleTmplItem
/// Input:			opsId:手术计划ID，data:数据参数，userId:用户ID
/// Return：       	保存成功返回"S^"，失败返回"E^原因"
/// Debug:			w ##class(CIS.AN.BL.PACURecord).SaveTemplate(77,.data,10209)
ClassMethod SaveTemplate(moduleId As %String, data As %String, userId As %String) As %String
{
	m ^TempAnDebug("SaveTemplate-data")=data
	set ^TempAnDebug("SaveTemplate-moduleId")=moduleId_" "_userId
	quit:(##class(CT.AN.DataModule).%ExistsId(moduleId)=0) "E^数据模块不存在！"
	quit:(data="") "E^保存的数据不能为空！"
	
	set sc=##class(CIS.AN.COM.String).ToArray(data,.array)
	set $zt="Error"
	tstart
	
	kill templates,teplateItems,templateDatas,templateDrugs,templateEvents
	set index=0
	for
	{
		set index=$order(array(index))
		quit:(index="")
		
		if (array(index,"ClassName")="CF.AN.ModuleTemplate")
		{
			merge templates(index)=array(index)
		}
		elseif (array(index,"ClassName")="CF.AN.ModuleTmplItem")
		{
			merge teplateItems(index)=array(index)
		}
		elseif (array(index,"ClassName")="CF.AN.UserPreferedData")
		{
			merge templateDatas(index)=array(index)
		}
		elseif (array(index,"ClassName")="CF.AN.UserPreferedDrug")
		{
			merge templateDrugs(index)=array(index)
		}
		elseif (array(index,"ClassName")="CF.AN.UserPreferedEventDetail")
		{
			merge templateEvents(index)=array(index)
		}
	}
	
	
	set objIndex=0,saveResult="S^"
	for
	{
		set objIndex=$order(templates(objIndex))
		quit:(objIndex="")
		kill template
		merge template=templates(objIndex)
		continue:template("ClassName")'="CF.AN.ModuleTemplate"
		set template("UserID")=userId
		set saveResult=##class(CIS.AN.COM.DataService).SaveData(.template)
		quit:($piece(saveResult,"^",1)'="S")
		set guid = $g(template("Guid"))
		set templateRowId=+$piece(saveResult,"^",2)
		set itemIndex=0,saveResult="S^"
		for
		{
			set itemIndex=$order(teplateItems(itemIndex))
			quit:(itemIndex="")
			continue:($get(teplateItems(itemIndex,"ClassName"))'="CF.AN.ModuleTmplItem")
			continue:($get(teplateItems(itemIndex,"TemplateGuid"))'=guid)
			kill templateItem
			merge templateItem=array(itemIndex)
			set templateItem("Template")=templateRowId
            if teplateItems(itemIndex,"Description")="自主呼吸" b
			if $g(templateItem("isRemoved"))="Y" set saveResult=##class(CIS.AN.COM.DataService).DelData(templateItem("ClassName"),templateItem("RowId"))
			else  set saveResult=##class(CIS.AN.COM.DataService).SaveData(.templateItem)
			
			quit:($piece(saveResult,"^",1)'="S")
		}
		
		set dataIndex=0,saveResult="S^"
		for
		{
			set dataIndex=$order(templateDatas(dataIndex))
			quit:(dataIndex="")
			continue:($get(templateDatas(dataIndex,"ClassName"))'="CF.AN.UserPreferedData")
			continue:($get(templateDatas(dataIndex,"TemplateGuid"))'=guid)
			continue:($g(templateDatas(dataIndex,"isRemoved"))="Y")&&($g(templateDatas(dataIndex,"RowId"))="")
			kill preferedData
			merge preferedData=templateDatas(dataIndex)
			set preferedData("Template")=templateRowId
			set preferedData("CreateUserID")=userId
			set preferedData("DataModule")=moduleId
			if $g(preferedData("isRemoved"))="Y"
			{
				set saveResult=##class(CIS.AN.COM.DataService).DelData(preferedData("ClassName"),preferedData("RowId"))
				quit:($piece(saveResult,"^",1)'="S")
			}
			else  
			{
				set saveResult=##class(CIS.AN.COM.DataService).SaveData(.preferedData)
				quit:($piece(saveResult,"^",1)'="S")
			
				set dataGuid = $g(preferedData("Guid"))
				set dataRowId=+$piece(saveResult,"^",2)
				set subIndex=0,saveResult="S^"
				for
				{
					set subIndex=$order(templateDrugs(subIndex))
					quit:(subIndex="")
					continue:($get(templateDrugs(subIndex,"ClassName"))'="CF.AN.UserPreferedDrug")
					continue:($get(templateDrugs(subIndex,"DataGuid"))'=dataGuid)
					kill subData
					merge subData=templateDrugs(subIndex)
					set subData("UserPreferedData")=dataRowId
					set saveResult=##class(CIS.AN.COM.DataService).SaveData(.subData)
					quit:($piece(saveResult,"^",1)'="S")
				}
				quit:($piece(saveResult,"^",1)'="S")
			
				set subIndex=0,saveResult="S^"
				for
				{
					set subIndex=$order(templateEvents(subIndex))
					quit:(subIndex="")
					continue:($get(templateEvents(subIndex,"ClassName"))'="CF.AN.UserPreferedEventDetail")
					continue:($get(templateEvents(subIndex,"DataGuid"))'=dataGuid)
					kill subData
					merge subData=templateEvents(subIndex)
					set subData("UserPreferedData")=dataRowId
					set saveResult=##class(CIS.AN.COM.DataService).SaveData(.subData)
					quit:($piece(saveResult,"^",1)'="S")
				}
				quit:($piece(saveResult,"^",1)'="S")
			}
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
/// CreatDate：    	2018-12-20
/// Description： 	应用模板前删除所有事件和间断用药数据
/// Table：        	CIS_AN.AnaData
/// Input:			recordSheetId:表单ID，userId:用户ID
/// Return：       	保存成功返回"S^"，失败返回"E^原因"
/// Debug:			w ##class(CIS.AN.BL.PACURecord).ClearEventData("40",3)
ClassMethod ClearEventData(recordSheetId As %String, userId As %String) As %String
{
	set eventCode="OperationEvent",intrmiDrugCode="OperationDrug" //术中事件和间断用药现在用代码进行对应
	set paraItems = ##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.DataQueries:FindParaItems",recordSheetId)
	
	set eventParaItemId="",intrmiDrugParaItemId=""
	
	for i=1:1:(paraItems.Size)
	{
		set paraItem=paraItems.GetAt(i)
		quit:paraItem=""
		
		set ParaItemCode=paraItem.GetValue("Code")
		set:(ParaItemCode=eventCode) eventParaItemId=paraItem.GetValue("RowId")
		set:(ParaItemCode=intrmiDrugCode) intrmiDrugParaItemId=paraItem.GetValue("RowId")
	}
	
	kill data
	set data("ClassName")="CIS.AN.AnaData"
	set data("RowId")=""
	set data("EditFlag")="D"
	
	set anaDatas = ##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.PACURecord:FindAnaData",templateId)
	set saveResult = "S^"
	//
	tstart
	
	for i=1:1:(anaDatas.Size)
	{
		set anaData=anaDatas.GetAt(i)
		quit:anaData=""
		
		set paraItemId=anaData.GetValue("ParaItem")
		if (paraItemId=eventParaItemId)
		{
			set data("RowId")=anaData.GetValue("RowId")
			
			// 直接删除
			//set savingResult=##class(CIS.AN.COM.DataService).SaveData(data("ClassName"),data("RowId"))
			
			// 设置编辑状态为D
			set saveResult=##class(CIS.AN.COM.DataService).SaveData(.data)
			quit:($piece(saveResult,"^",1)'="S")
		}
	}
	
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult	
	}
	tcommit
}

/// Creator：      	雍阳
/// CreatDate：    	2018-12-20
/// Description： 	应用模板前删除所有用药数据
/// Table：        	CIS_AN.AnaData
/// Input:			recordSheetId:表单ID，userId:用户ID
/// Return：       	保存成功返回"S^"，失败返回"E^原因"
/// Debug:			w ##class(CIS.AN.BL.AnaestRecord).ClearDrugData("40",3)
ClassMethod ClearDrugData(recordSheetId As %String, userId As %String) As %String
{
	
	kill data
	set data("ClassName")="CIS.AN.AnaData"
	set data("RowId")=""
	set data("EditFlag")="D"
	
	set drugDatas = ##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.PACURecord:FindDrugDatas",recordSheetId,"N")
	set saveResult = "S^"
	//
	tstart
	
	for i=1:1:(drugDatas.Size)
	{
		set drugData=drugDatas.GetAt(i)
		quit:drugData=""
		
		set data("RowId")=drugData.GetValue("AnaData")
			
		// 设置编辑状态为D
		set saveResult=##class(CIS.AN.COM.DataService).SaveData(.data)
		quit:($piece(saveResult,"^",1)'="S")
	}
	
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult	
	}
	tcommit
	
	quit saveResult
}

/// Creator：      	雍阳
/// CreatDate：    	2018-06-26
/// Description： 	应用模板
/// Table：        	CF_AN.ModuleTemplate,CF_AN.ModuleTmplItem
/// Input:			templateId：模板ID，recordSheetId：表单ID，userId：用户ID
/// Return：       	保存成功返回"S^"，失败返回"E^原因"
/// Debug:			w ##class(CIS.AN.BL.AnaestRecord).ApplyTemplate("40",3)
ClassMethod ApplyTemplate(recordSheetId As %String, templateId As %String, userId As %String, data As %String = "") As %String
{
	quit:(##class(CIS.AN.RecordSheet).%ExistsId(recordSheetId)=0) "E^表单不存在！"
	quit:(##class(CF.AN.ModuleTemplate).%ExistsId(templateId)=0) "E^模板不存在！"
	
	set eventCode="OperationEvent",intrmiDrugCode="OperationDrug" //术中事件和间断用药现在用代码进行对应
	
	kill applyParams
	set applyParams("DrugAccordingToTemplate")="Y"
	set applyParams("EventAccordingToTemplate")="Y"
	if data'=""
	{
		set sc=##class(CIS.AN.COM.String).ToArray(data,.array)
		merge applyParams=array(1)
	}
	
	set saveResult="S^"
	set $zt="Error"
	tstart
	
	set paraItems = ##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.DataQueries:FindParaItems",recordSheetId)
	set templateItems = ##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.ConfigQueries:GetModuleTemplateItem",templateId)
	set templateDatas = ##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.ConfigQueries:GetModuleTemplateData",templateId)
	set templateDrugs = ##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.ConfigQueries:GetModuleTemplateDrug",templateId)
	set templateEvents = ##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.ConfigQueries:GetModuleTemplateEvent",templateId)
	kill seqList
	
	for index=1:1:(templateItems.Size)
	{
		set templateItem=templateItems.GetAt(index)
		quit:templateItem=""
		
		set categoryItemId=templateItem.GetValue("CategoryItem")
		set userDefinedItemId=templateItem.GetValue("UserDefinedItem")
		
		set existedCateItemCount=0,existedUserDefItemCount=0
		set:categoryItemId'="" existedCateItemCount=$$ExistCategoryItem(categoryItemId)
		set:userDefinedItemId'="" existedUserDefItemCount=$$ExistUserDefinedItem(userDefinedItemId)
		if (categoryItemId="")&&(userDefinedItemId="") set existedCateItemCount=1
		
		if ('existedCateItemCount)&&('existedUserDefItemCount) //已存在此项目则不添加
		{
			set category=templateItem.GetValue("Category")
			set seqList(+category)=$g(seqList(+category))+1
		
			kill data
			set data("ClassName")="CIS.AN.ParaItem"
			set data("RecordSheet")=recordSheetId
			set data("CategoryItem")=categoryItemId
			set data("UserDefinedItem")=userDefinedItemId
			set data("Code")=templateItem.GetValue("Code")
			set data("Description")=templateItem.GetValue("Description")
			set data("DataCategory")=templateItem.GetValue("DataCategory")
			set:data("DataCategory")="" data("DataCategory")=category
			set data("Seq")=seqList(+category)+$$GetLastSequence(category)
			
			set saveResult=##class(CIS.AN.COM.DataService).SaveData(.data)
			quit:($piece(saveResult,"^",1)'="S")
			set paraItemRowId=$p(saveResult,"^",2)
			
			kill data
			set data("ClassName")="CIS.AN.ParaItemAttr"
			set data("ParaItem")=paraItemRowId
			set data("Unit")=templateItem.GetValue("Unit")
			set data("DoseUnitVisible")=templateItem.GetValue("DoseUnitVisible")
			set data("SpeedUnitVisible")=templateItem.GetValue("SpeedUnitVisible")
			set data("ConcentrationVisible")=templateItem.GetValue("ConcentrationVisible")
			set data("Concentration")=templateItem.GetValue("Concentration")
			set data("ConcentrationUnit")=templateItem.GetValue("ConcentrationUnit")
			set data("Continuous")=templateItem.GetValue("Continuous")
			set data("Duration")=templateItem.GetValue("Duration")
			set data("Note")=templateItem.GetValue("Note")
			set data("InstructionVisible")=templateItem.GetValue("InstructionVisible")
			set data("Instruction")=templateItem.GetValue("Instruction")
			
			set saveResult=##class(CIS.AN.COM.DataService).SaveData(.data)
			quit:($piece(saveResult,"^",1)'="S")
		}
	}
	
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult	
	}
	tcommit
	
	set recordSheet = ##class(CIS.AN.RecordSheet).%OpenId(recordSheetId)
	set recordStartDT = ..GetRecordStartDT(recordSheet.OperSchedule.%Id())
	set recordStartDate=$zdh($p(recordStartDT," ",1),3),recordStartTime=$zth($p(recordStartDT," ",2))
	
	set paraItems=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.DataQueries:FindParaItems",recordSheetId)
	
	tstart
	for i=1:1:(templateDatas.Size)
	{
		set userPreferedData=templateDatas.GetAt(i)
		quit:userPreferedData=""
		
		set generateTimeSpan=userPreferedData.GetValue("GenerateTimeSpan")
		set startDateTime=##class(CIS.AN.COM.DateTime).DateTimeAdd(recordStartDate,recordStartTime,generateTimeSpan*60)
		set startDate=$p(startDateTime,"^",1),startTime=$p(startDateTime,"^",2)
		
		set type=userPreferedData.GetValue("Type")
		if (type="D")||(type="I")
		{
			if ($g(applyParams("DrugAccordingToTemplate"))="N")&&($g(applyParams("DrugStartDT"))'="")
			{
				set startDT=$g(applyParams("DrugStartDT"))
				set startDate=$p(startDT," ",1),startTime=$p(startDT," ",2)
				set startDate=##class(CIS.AN.COM.DateTime).ConvertToDateH(startDate)
				set startTime=##class(CIS.AN.COM.DateTime).ConvertToTimeH(startTime)
			}
		}
		
		if (type="E")
		{
			if ($g(applyParams("EventAccordingToTemplate"))="N")&&($g(applyParams("EventStartDT"))'="")
			{
				set startDT=$g(applyParams("EventStartDT"))
				set startDate=$p(startDT," ",1),startTime=$p(startDT," ",2)
				set startDate=##class(CIS.AN.COM.DateTime).ConvertToDateH(startDate)
				set startTime=##class(CIS.AN.COM.DateTime).ConvertToTimeH(startTime)
			}
		}
		
		set timeSpanMinutes=userPreferedData.GetValue("TimeSpanMinutes")
		set continuous=userPreferedData.GetValue("Continuous")
		if continuous="Y"
		{
			if (timeSpanMinutes>0)
			{
				set endDateTime=##class(CIS.AN.COM.DateTime).DateTimeAdd(startDate,startTime,timeSpanMinutes*60)
				set endDate=$p(endDateTime,"^",1)
				set endTime=$p(endDateTime,"^",2)
			}
			else
			{
				set endDate="9999-12-31"
				set endTime="00:00:00"
			}
		}
		else
		{
			set endDate=startDate
			set endTime=startTime
		}
		
		set userPreferedDataRowId=userPreferedData.GetValue("RowId")
		set categoryItem=userPreferedData.GetValue("CategoryItem")
		set userDefinedItem=userPreferedData.GetValue("UserDefinedItem")
		set dataItem=userPreferedData.GetValue("DataItem")
		set code=""
		continue:(type="D")&&(categoryItem="")&&(userDefinedItem="")
		
		if type="E" set categoryItem="",code=eventCode
		else  if type="I" set categoryItem="",code=intrmiDrugCode
		
		set paraItemId=$$GetParaItem(categoryItem,code)
		//write categoryItem," | ",dataItem," | ",type," | ",paraItemId,!
		continue:paraItemId=""
		
		set existedAnaDataId=""
		set existedLogRowId = $o(^CIS.AN.UserPrefere8A05I("IData",recordSheetId,userPreferedDataRowId,""))
		if existedLogRowId'="" 
		{
			//write "  log:",existedLogRowId,"  anaData:"
			set log = ##class(CIS.AN.UserPreferedDataAutoLog).%OpenId(existedLogRowId)
			set:log.AnaData.EditFlag="N" existedAnaDataId = log.AnaData.%Id()
			//write existedAnaDataId,!
		}
		
		if (existedAnaDataId'="")
		{
			kill anaData
			set anaData("ClassName")="CIS.AN.AnaData"
			set anaData("RowId")=existedAnaDataId
			set anaData("ParaItem")=paraItemId
			set anaData("StartDate")=startDate
			set anaData("StartTime")=startTime
			set anaData("EndDate")=endDate
			set anaData("EndTime")=endTime
			set anaData("DataValue")=""
			set anaData("EditFlag")="N"
			
			set saveResult=##class(CIS.AN.COM.DataService).SaveData(.anaData)
			quit:($piece(saveResult,"^",1)'="S")
		}
		else
		{
			kill anaData
			set anaData("ClassName")="CIS.AN.AnaData"
			set anaData("RowId")=""
			set anaData("ParaItem")=paraItemId
			set anaData("DataItem")=dataItem
			set anaData("StartDate")=startDate
			set anaData("StartTime")=startTime
			set anaData("EndDate")=endDate
			set anaData("EndTime")=endTime
			set anaData("DataValue")=""
			set anaData("EditFlag")="N"
			set anaData("FromData")=""
			set anaData("CreateUserID")=userId
			set anaData("CategoryItem")=userPreferedData.GetValue("CategoryItem")
			set anaData("UserDefinedItem")=userPreferedData.GetValue("UserDefinedItem")
			set anaData("Source")="M"
			set anaData("Continuous")=userPreferedData.GetValue("Continuous")
			set:anaData("Continuous")="" anaData("Continuous")="N"
		
			set saveResult=##class(CIS.AN.COM.DataService).SaveData(.anaData)
			quit:($piece(saveResult,"^",1)'="S")
			set anaDataRowId=$p(saveResult,"^",2)
		
			break //after save data
		
			// 保存用户偏好数据自动生成记录，用于自动校对(修改开始时间后自动校对到最新的开始时间)
			if existedLogRowId=""
			{
				kill logData
				set logData("ClassName")="CIS.AN.UserPreferedDataAutoLog"
				set logData("RecordSheet")=recordSheetId
				set logData("UserPreferedData")=userPreferedDataRowId
				set logData("AnaData")=anaDataRowId
				set saveResult=##class(CIS.AN.COM.DataService).SaveData(.logData)
				quit:($piece(saveResult,"^",1)'="S")
				break //after save autolog
			}
		
			for j=1:1:(templateDrugs.Size)
			{
				set userPreferedDrug=templateDrugs.GetAt(j)
				quit:userPreferedDrug=""
			
				set userPreferedDataRowId=userPreferedDrug.GetValue("UserPreferedData")
				continue:userPreferedDataRowId'=userPreferedData.GetValue("RowId")
		
				kill drugData
				set drugData("ClassName")="CIS.AN.DrugData"
				set drugData("AnaData")=anaDataRowId
				set drugData("DoseQty")=userPreferedDrug.GetValue("DoseQty")
				set drugData("DoseUnit")=userPreferedDrug.GetValue("DoseUnit")
				set drugData("Instruction")=userPreferedDrug.GetValue("Instruction")
				set drugData("Concentration")=userPreferedDrug.GetValue("Concentration")
				set drugData("ConcentrationUnit")=userPreferedDrug.GetValue("ConcentrationUnit")
				set drugData("Speed")=userPreferedDrug.GetValue("Speed")
				set drugData("SpeedUnit")=userPreferedDrug.GetValue("SpeedUnit")
				set drugData("Reason")=userPreferedDrug.GetValue("Reason")
				set drugData("Description")=userPreferedDrug.GetValue("Description")
				set drugData("DataItem")=userPreferedDrug.GetValue("DataItem")
				set drugData("ArcimID")=userPreferedDrug.GetValue("ArcimID")
				set drugData("UserDefinedItem")=userPreferedDrug.GetValue("UserDefinedItem")
				set drugData("Continuous")=userPreferedDrug.GetValue("Continuous")
				set drugData("TCI")=userPreferedDrug.GetValue("TCI")
			
				set saveResult=##class(CIS.AN.COM.DataService).SaveData(.drugData)
				quit:($piece(saveResult,"^",1)'="S")
			}
			quit:($piece(saveResult,"^",1)'="S")
		
			break //after save drug
		
			for j=1:1:(templateEvents.Size)
			{
				set userPreferedEvent=templateEvents.GetAt(j)
				quit:userPreferedEvent=""
			
				set userPreferedDataRowId=userPreferedEvent.GetValue("UserPreferedData")
				continue:userPreferedDataRowId'=userPreferedData.GetValue("RowId")
		
				kill drugData
				set drugData("ClassName")="CIS.AN.EventData"
				set drugData("AnaData")=anaDataRowId
				set drugData("EventDetailItem")=userPreferedEvent.GetValue("EventDetailItem")
				set drugData("DataValue")=userPreferedEvent.GetValue("DataValue")
				set drugData("DataUnit")=userPreferedEvent.GetValue("DataUnit")
			
				set saveResult=##class(CIS.AN.COM.DataService).SaveData(.drugData)
				quit:($piece(saveResult,"^",1)'="S")
			}
			break //after save event
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
	
ExistCategoryItem(categoryItemId)
	set count=0
	set paraItemCount=0
	
	for i=1:1:(paraItems.Size)
	{
		set paraItem=paraItems.GetAt(i)
		quit:paraItem=""
		
		set CategoryItem=paraItem.GetValue("CategoryItem")
		set UserDefinedItem=paraItem.GetValue("UserDefinedItem")
		if ((UserDefinedItem="")&&(categoryItemId=CategoryItem)) set count=count+1
	}
	
	quit count

ExistUserDefinedItem(userDefinedItemId)
	set count=0
	set paraItemCount=0
	
	for i=1:1:(paraItems.Size)
	{
		set paraItem=paraItems.GetAt(i)
		quit:paraItem=""
		
		set CategoryItem=paraItem.GetValue("CategoryItem")
		set UserDefinedItem=paraItem.GetValue("UserDefinedItem")
		if ((CategoryItem="")&&(userDefinedItemId=UserDefinedItem)) set count=count+1
	}
	
	quit count
	
GetLastSequence(dataCategoryID)  //获取最大序号
	set lastSeq=0
	set paraItemCount=0
	for i=1:1:(paraItems.Size)
	{
		set paraItem=paraItems.GetAt(i)
		quit:paraItem=""
		
		set MainDataCategory=paraItem.GetValue("MainDataCategory")
		set DataCategory=paraItem.GetValue("DataCategory")
		set Seq=paraItem.GetValue("Seq")
		
		if (DataCategory=dataCategoryID) || (MainDataCategory = dataCategoryID)
		{
			if Seq>lastSeq set lastSeq=Seq
		}
	}
	
	quit lastSeq

	
GetParaItem(categoryItem,code)
	set foundParaItem=""
	for j=1:1:(paraItems.Size)
	{
		set paraItem = paraItems.GetAt(j)
		quit:paraItem=""
		
		set paraCategoryItem=paraItem.GetValue("CategoryItem")
		set paraItemCode=paraItem.GetValue("Code")
		if ((categoryItem'="")&&(paraCategoryItem=categoryItem))||((code'="")&&(paraItemCode=code))
		{
			set foundParaItem = paraItem.GetValue("RowId")
			quit
		}
	}
	
	quit foundParaItem
}

/// Creator：      	雍阳
/// CreatDate：    	2018-08-22
/// Description： 	保存麻醉记录显示项目属性
/// Table：        	CIS.AN.ParaItemAttr
/// Input:			opsId:手术计划ID，data:数据参数，userId:用户ID
/// Return：       	保存成功返回"S^"，失败返回"E^原因"
/// Debug:			w ##class(CIS.AN.BL.PACURecord).SaveDrugData("")
ClassMethod SaveParaItemAttr(opsId As %String, data As %String, userId As %String) As %String
{
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术计划不存在！"
	//quit:(##class(CT.AN.DataModule).%ExistsId(moduleId)=0) "E^数据模块不存在！"
	quit:(data="") "E^保存的数据不能为空！"
	
	set $zt="Error"
	
	tstart
	set sc=##class(CIS.AN.COM.String).ToArray(data,.array)
	set index=1,saveResult="S^"
	merge savingData=array(index)
	
	set paraItemRowId=savingData("ParaItem")
	if (paraItemRowId="")
	{
		trollback
		quit "E^保存的数据错误！"	
	}
	
	set rowId=$o(^CIS.AN.ParaItemAttrI("IParaItem",paraItemRowId,""))
	set savingData("RowId")=rowId
	
	set saveResult=##class(CIS.AN.COM.DataService).SaveData(.savingData)
	
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
/// CreatDate：    	2018-09-25
/// Description： 	自动同步采集数据
/// Table：        	CIS.AN.CollectData，CIS.AN.AnaData
/// Input:			
/// Return：       	保存成功返回"S^"，失败返回"E^原因"
/// Debug:			w ##class(CIS.AN.BL.PACURecord).AutoSyncCollectData()
ClassMethod AutoSyncCollectData() As %String
{
	set date = +$h
	set moduleCode = "PACURecord"
	set operScheduleList=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.OperScheduleList:FindOperOpsIdList",date-1,date,"PACUIn")
	
	set operSchedule=""
	for i=1:1:(operScheduleList.Size)
	{
		set operSchedule=operScheduleList.GetAt(i)
		quit:operSchedule=""
		set opsId=operSchedule.GetValue("RowId")
		set recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCode(opsId,moduleCode,"")
		do ..SyncCollectData(opsId,recordSheetId)
	}
	
	quit "S^"
}

/// Creator：      	雍阳
/// CreatDate：    	2018-09-14
/// Description： 	同步采集数据
/// Table：        	CIS.AN.CollectData，CIS.AN.AnaData
/// Input:			opsId:手术计划ID,recordSheetID:表单ID
/// Return：       	保存成功返回"S^"，失败返回"E^原因"
/// Debug:			w ##class(CIS.AN.BL.PACURecord).SyncCollectData(2,20)
ClassMethod SyncCollectData(opsId As %String, recordSheetID As %String) As %String
{
	set equipId="",startDate="",startTime="",endDate="",endTime=""
	kill equipUsage,timeList
	
	do ..GetEquipUsage(recordSheetID,.equipUsage)
	do ..GetCollectTimeList(opsId,recordSheetID,.timeList)
	set RowId=""
	for{
		set RowId=$o(equipUsage(RowId))
		quit:RowId=""
		
		set equipId=equipUsage(RowId,"Equip")
		set startDate=equipUsage(RowId,"StartDate")
		set startTime=equipUsage(RowId,"StartTime")
		set endDate=equipUsage(RowId,"EndDate")
		set endTime=equipUsage(RowId,"EndTime")
		
		if endDate = "" set endDate = +$h,endTime = $p($h,",",2)
		write "equipId:",equipId,"  startDT:",startDate," ",startTime,"  endDT:",endDate," ",endTime,!
		do ##class(CIS.AN.BL.CollectData).SyncData(recordSheetID,equipId,.timeList)
	}
	
	quit "S^"
}

/// Creator：      	雍阳
/// CreatDate：    	2018-09-20
/// Description： 	获取采集时间列的数据
/// Table：        	CIS.AN.TimeLine
/// Input:			opsId:手术计划ID
/// Return：       	数据Json
/// Debug:			w ##class(CIS.AN.BL.PACURecord).GetCollectTimeList(12,27)
ClassMethod GetCollectTimeList(opsId, recordSheetID, ByRef timeColumnList) As %String
{
	kill timelineList
	set timeColumnFormat=..#TimeColumnFormat
	
	set startDateTime = ##class(CIS.AN.BL.PACURecord).GetRecordStartDT(opsId)
	set endDateTime = ##class(CIS.AN.BL.PACURecord).GetRecordEndDT(opsId)
	set startDate = ##class(CIS.AN.COM.DateTime).ConvertToDateH($piece(startDateTime," ",1))
	set startTime = ##class(CIS.AN.COM.DateTime).ConvertToTimeH($piece(startDateTime," ",2))
	set endDate = ##class(CIS.AN.COM.DateTime).ConvertToDateH($piece(endDateTime," ",1))
	set endTime = ##class(CIS.AN.COM.DateTime).ConvertToTimeH($piece(endDateTime," ",2))
	
	//set endDate=startDate,endTime= 20*3600 - 1200
	
	set timelines=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.PACURecord:FindTimeLines",recordSheetID)
	
	set timelineCount=0
	for i=1:1:(timelines.Size)
	{
		set timeline=timelines.GetAt(i)
		quit:timeline=""
		set timelineCount=i
		set interval=timeline.GetValue("ColumnMinutes")
		set timelineStartDate=timeline.GetValue("StartDate")
		set timelineStartTime=timeline.GetValue("StartTime")
		set timelineEndDate=timeline.GetValue("EndDate")
		set timelineEndTime=timeline.GetValue("EndTime")
		
		set timelineList(i,"StartDate")=timelineStartDate
		set timelineList(i,"StartTime")=timelineStartTime
		set timelineList(i,"EndDate")=timelineEndDate
		set timelineList(i,"EndTime")=timelineEndTime
		
		set columnCount=(timelineEndDate-timelineStartDate)*60*24\interval
		set columnCount=columnCount+((timelineEndTime-timelineStartTime)\interval\60)
		for j=0:1:columnCount
		{
			set dateTime = ##class(CIS.AN.COM.DateTime).DateTimeAdd(timelineStartDate,timelineStartTime,j*60*interval)
			set date=$piece(dateTime,"^",1)
			set time=$piece(dateTime,"^",2)
			set timeColumnList(date,time)=$zt(time,timeColumnFormat)
		}
	}
	
	set defaultInterval=5  //默认每列间隔5分钟
	set date=startDate,time=startTime
	set columnCount=(endDate-startDate)*60*24\defaultInterval
	set columnCount=columnCount+((endTime-startTime)\defaultInterval\60)
	for i=0:1:columnCount
	{
		set dateTime=##class(CIS.AN.COM.DateTime).DateTimeAdd(date,time,defaultInterval*60)
		set date=$piece(dateTime,"^",1)
		set time=$piece(dateTime,"^",2)
		quit:##class(CIS.AN.COM.DateTime).CompareDateTime(date,time,endDate,endTime)>0

		set isInTimeLine=0
		for j=1:1:timelineCount
		{
			quit:isInTimeLine
			if ((##class(CIS.AN.COM.DateTime).CompareDateTime(date,time,timelineList(j,"StartDate"),timelineList(j,"StartTime"))>=0) && ((##class(CIS.AN.COM.DateTime).CompareDateTime(timelineList(j,"EndDate"),timelineList(j,"EndTime"),date,time))>=0))
			{
				set date=timelineList(j,"EndDate")
				set time=timelineList(j,"EndTime")
				set isInTimeLine=1
			}
		}
		
		continue:isInTimeLine
		
		set timeColumnList(date,time)=$zt(time,timeColumnFormat)
	}
	
	quit ""
}

/// Creator：      	雍阳
/// CreatDate：    	2018-09-14
/// Description： 	获取表单所有设备使用记录
/// Table：        	CF.AN.DeptEquip，CIS.AN.EquipRecord
/// Input:			recordSheetID:表单ID
/// Return：       	返回设备Id和时间
/// Debug:			w ##class(CIS.AN.BL.PACURecord).SyncCollectData("")
ClassMethod GetEquipUsage(recordSheetID As %String, ByRef equipUsage As %List) As %String
{
	set RowId=""
	for
	{
		set RowId=$o(^CIS.AN.EquipRecordI("Sheet",recordSheetID,RowId))
		quit:RowId=""
		
		set equipUsage(RowId)=""
		set equipUsage(RowId,"Equip")=$lg(^CIS.AN.EquipRecordD(RowId),2)
		set equipUsage(RowId,"StartDate")=$lg(^CIS.AN.EquipRecordD(RowId),3)
		set equipUsage(RowId,"StartTime")=$lg(^CIS.AN.EquipRecordD(RowId),4)
		set equipUsage(RowId,"EndDate")=$lg(^CIS.AN.EquipRecordD(RowId),5)
		set equipUsage(RowId,"EndTime")=$lg(^CIS.AN.EquipRecordD(RowId),6)
	}
	
	quit ""
}

/// Creator：      	雍阳
/// CreatDate：    	2018-09-19
/// Description： 	保存自定义项目
/// Table：        	CIS_AN.ParaItem
/// Input:			recordSheetID:表单ID,dataCategoryID:数据分类ID,userDefinedItemID:自定义项目ID
/// Return：       	"S^"成功，"E^"错误
/// Debug:			w ##class(CIS.AN.BL.PACURecord).SaveUserDefDataItem("")
ClassMethod SaveUserDefDataItem(recordSheetID As %String, dataCategoryID As %String, userDefinedItemID As %String) As %String
{
	quit:(##class(CIS.AN.RecordSheet).%ExistsId(recordSheetID)=0) "E^手术表单不存在！"
	quit:(##class(CT.AN.DataCategory).%ExistsId(dataCategoryID)=0) "E^数据分类不存在！"
	quit:(##class(CF.AN.UserDefDataItem).%ExistsId(userDefinedItemID)=0) "E^自定义项目不存在！"
	
	set nextSeq=$$GetLastSequence() + 1 
	set Code = $lg(^CF.AN.UserDefDataItemD(userDefinedItemID),1)
	set Description = $lg(^CF.AN.UserDefDataItemD(userDefinedItemID),2)
	
	tstart
	kill paraItemObj
	set paraItemObj("ClassName")="CIS.AN.ParaItem"
	set paraItemObj("RecordSheet")=recordSheetID
	set paraItemObj("DataCategory")=dataCategoryID
	set paraItemObj("Code")=Code
	set paraItemObj("Description")=Description
	set paraItemObj("UserDefinedItem")=userDefinedItemID
	set paraItemObj("Seq")=nextSeq
	
	set saveResult=##class(CIS.AN.COM.DataService).SaveData(.paraItemObj)
	
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult	
	}
	tcommit
	quit "S^"
	
	
GetLastSequence()  //获取最大序号
	set lastSeq=0
	set paraItems=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.DataQueries:FindParaItems",recordSheetID)
	set paraItemCount=0
	for i=1:1:(paraItems.Size)
	{
		set paraItem=paraItems.GetAt(i)
		quit:paraItem=""
		
		set MainDataCategory=paraItem.GetValue("MainDataCategory")
		set DataCategory=paraItem.GetValue("DataCategory")
		set Seq=paraItem.GetValue("Seq")
		
		if (DataCategory=dataCategoryID) || (MainDataCategory = dataCategoryID)
		{
			if Seq>lastSeq set lastSeq=Seq
		}
	}
	
	quit lastSeq
}

/// Creator：      	雍阳
/// CreatDate：    	2018-09-21
/// Description： 	获取安全核查是否确认
/// Table：        	CIS_AN.OperData
/// Input:			opsId:手术排班ID
/// Return：       	"Y^2018-09-10 12:00"已核查，"N^"未核查
/// Debug:			w ##class(CIS.AN.BL.PACURecord).GetAnaestSafetyCheck("")
ClassMethod GetAnaestSafetyCheck(opsId) As %String
{
	set moduleCode = "OperSafetyCheck"
	kill codeList
	
	set codeList("PreAN")="PreANAnaestChecked"
	set codeList("PreOP")="PreOPAnaestChecked"
	set codeList("PreOut")="PreOutAnaestChecked"
	
	write "{"
	
	set key="",isFirst=1
	for
	{
		set key=$o(codeList(key))
		quit:key=""
		
		if 'isFirst write ","
		set code=codeList(key)
		do GetOperData(key,code)
		
		set isFirst=0
	}
	
	write "}"
	
	quit ""
	
GetOperData(key,code)
	write """",key,""":{"
	set operData = ##class(CIS.AN.BL.OperData).GetOperDataObjectByCode(opsId,moduleCode,code)
	
	set Checked="",Date="",Time="",DateTime=""
	set DataValue = operData.GetValue("DataValue")
	if DataValue'="" {
		set Checked = $s(DataValue="Y":"true",1:"false")
		set UpdateDate = operData.GetValue("UpdateDate")
		set UpdateTime = operData.GetValue("UpdateTime")
		set Date = $zd(UpdateDate,3)
		set Time = $zt(UpdateTime,..#TimeColumnFormat)
		set DateTime = Date_" "_Time
	}
	else
	{
		set Checked="false"
	}
	
	write """Checked"":",Checked,","
	write """Date"":","""",Date,"""",","
	write """Time"":","""",Time,"""",","
	write """DateTime"":","""",DateTime,""""
	write "}"
	
	quit
}

/// Creator：      	雍阳
/// CreatDate：    	2018-09-19
/// Description： 	保存用户偏好数据
/// Table：        	CF_AN.UserPreferedData
/// Input:			data:数据
/// Return：       	"S^"成功，"E^"错误
/// Debug:			w ##class(CIS.AN.BL.PACURecord).SaveUserDefDataItem("")
ClassMethod SaveUserPreferedData(moduleId As %String, data As %String, userId As %String) As %String
{
	quit:(##class(CT.AN.DataModule).%ExistsId(moduleId)=0) "E^手术表单不存在！"
	quit:(userId="") "E^用户不存在！"
	quit:(data="") "E^保存的数据不能为空！"
	
	set $zt="Error"
	tstart
	set sc=##class(CIS.AN.COM.String).ToArray(data,.array)
	set index=0,saveResult="S^"
	for
	{
		set index=$order(array(index))
		quit:(index="")
		continue:($get(array(index,"ClassName"))'="CF.AN.UserPreferedData")
		continue:($g(array(index,"isRemoved"))="Y")&&($g(array(index,"RowId"))="")
		kill preferedData
		m preferedData=array(index)
		set preferedData("DataModule")=moduleId
		if $g(usage("isRemoved"))="Y" set saveResult=##class(CIS.AN.COM.DataService).DelData(preferedData("ClassName"),preferedData("RowId"))
		else  set saveResult=##class(CIS.AN.COM.DataService).SaveData(.preferedData)
		quit:($piece(saveResult,"^",1)'="S")
		
		set guid = $g(preferedData("Guid"))
		set dataRowId=+$piece(saveResult,"^",2)
		set subIndex=0,saveResult="S^"
		for
		{
			set subIndex=$order(array(subIndex))
			quit:(subIndex="")
			continue:($get(array(subIndex,"ClassName"))'="CF.AN.UserPreferedDrug")&&($get(array(subIndex,"ClassName"))'="CF.AN.UserPreferedEventDetail")
			continue:($get(array(subIndex,"DataGuid"))'=guid)
			kill subData
			m subData=array(subIndex)
			set subData("UserPreferedData")=dataRowId
			set saveResult=##class(CIS.AN.COM.DataService).SaveData(.subData)
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
/// CreatDate：    	2018-09-19
/// Description： 	应用用户偏好数据
/// Table：        	CF_AN.UserPreferedData
/// Input:			data:数据
/// Return：       	"S^"成功，"E^"错误
/// Debug:			w ##class(CIS.AN.BL.PACURecord).ApplyUserPreferedData("57",2,"2018-11-15 15:45:00")
ClassMethod ApplyUserPreferedData(recordSheetId As %String, dataRowId As %String, startDateTime As %String) As %String
{
	quit:(##class(CF.AN.UserPreferedData).%ExistsId(dataRowId)=0) "E^用户偏好数据不存在！"
	quit:(startDateTime="") "E^开始时间！"
	
	set eventCode="OperationEvent",intrmiDrugCode="OperationDrug" //术中事件和间断用药现在用代码进行对应
	
	set startDate=$p(startDateTime," ",1)
	set startTime=$p(startDateTime," ",2)
	set startDateH=##class(CIS.AN.COM.DateTime).ConvertToDateH(startDate)
	set startTimeH=##class(CIS.AN.COM.DateTime).ConvertToTimeH(startTime)
	
	set paraItems=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.DataQueries:FindParaItems",recordSheetId)
	set userPreferedDatas=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.PACURecord:FindUserPreferedData",dataRowId)
	set userPreferedDrugs=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.PACURecord:FindUserPreferedDrug",dataRowId)
	set userPreferedEvents=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.PACURecord:FindUserPreferedEvent",dataRowId)
	
	set $zt="Error"
	tstart
	
	for i=1:1:(userPreferedDatas.Size)
	{
		set userPreferedData=userPreferedDatas.GetAt(i)
		quit:userPreferedData=""
		
		set timeSpanMinutes=userPreferedData.GetValue("TimeSpanMinutes")
		set continuous=userPreferedData.GetValue("Continuous")
		if continuous="Y"
		{
			if (timeSpanMinutes>0)
			{
				set endDateTime=##class(CIS.AN.COM.DateTime).DateTimeAdd(startDateH,startTimeH,timeSpanMinutes*60)
				set endDate=$p(endDateTime,"^",1)
				set endTime=$p(endDateTime,"^",2)
			}
			else
			{
				set endDate="9999-12-31"
				set endTime="00:00:00"
			}
		}
		else
		{
			set endDate=startDate
			set endTime=startTime
		}
		
		set categoryItem=userPreferedData.GetValue("CategoryItem")
		set type=userPreferedData.GetValue("Type")
		set code=""

		if type="E" set categoryItem="",code=eventCode
		else  if type="I" set categoryItem="",code=intrmiDrugCode
		
		set paraItemId=$$GetParaItem(categoryItem,code)
		continue:paraItemId=""
		
		kill anaData
		set anaData("ClassName")="CIS.AN.AnaData"
		set anaData("ParaItem")=paraItemId
		set anaData("StartDate")=startDate
		set anaData("StartTime")=startTime
		set anaData("EndDate")=endDate
		set anaData("EndTime")=endTime
		set anaData("DataValue")=""
		set anaData("EditFlag")="N"
		set anaData("FromData")=""
		set anaData("CreateUserID")=userPreferedData.GetValue("CreateUserID")
		set anaData("CategoryItem")=userPreferedData.GetValue("CategoryItem")
		set anaData("UserDefinedItem")=userPreferedData.GetValue("UserDefinedItem")
		set anaData("Source")="M"
		set anaData("Continuous")=userPreferedData.GetValue("Continuous")
		
		set saveResult=##class(CIS.AN.COM.DataService).SaveData(.anaData)
		quit:($piece(saveResult,"^",1)'="S")
		set anaDataRowId=$p(saveResult,"^",2)
		
		for i=1:1:(userPreferedDrugs.Size)
		{
			set userPreferedDrug=userPreferedDrugs.GetAt(i)
			quit:userPreferedDrug=""
			
			set userPreferedDataRowId=userPreferedDrug.GetValue("UserPreferedData")
			continue:userPreferedDataRowId'=userPreferedData.GetValue("RowId")
		
			kill drugData
			set drugData("ClassName")="CIS.AN.DrugData"
			set drugData("AnaData")=anaDataRowId
			set drugData("DoseQty")=userPreferedDrug.GetValue("DoseQty")
			set drugData("DoseUnit")=userPreferedDrug.GetValue("DoseUnit")
			set drugData("Instruction")=userPreferedDrug.GetValue("Instruction")
			set drugData("Concentration")=userPreferedDrug.GetValue("Concentration")
			set drugData("ConcentrationUnit")=userPreferedDrug.GetValue("ConcentrationUnit")
			set drugData("Speed")=userPreferedDrug.GetValue("Speed")
			set drugData("SpeedUnit")=userPreferedDrug.GetValue("SpeedUnit")
			set drugData("Reason")=userPreferedDrug.GetValue("Reason")
			set drugData("Description")=userPreferedDrug.GetValue("Description")
			set drugData("DataItem")=userPreferedDrug.GetValue("DataItem")
			set drugData("UserDefinedItem")=userPreferedDrug.GetValue("UserDefinedItem")
			
			set saveResult=##class(CIS.AN.COM.DataService).SaveData(.drugData)
			quit:($piece(saveResult,"^",1)'="S")
		}
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
	
GetParaItem(categoryItem,code)
	set foundParaItem=1
	for j=1:1:(paraItems.Size)
	{
		set paraItem = paraItems.GetAt(j)
		quit:paraItem=""
		
		set paraCategoryItem=paraItem.GetValue("CategoryItem")
		set paraItemCode=paraItem.GetValue("Code")
		if ((categoryItem'="")&&(paraCategoryItem=categoryItem))||((code'="")&&(paraItemCode=code))
		{
			set foundParaItem = paraItem.GetValue("RowId")
			quit
		}
	}
	
	quit foundParaItem
}

/// Creator：      	雍阳
/// CreatDate：    	2018-10-30
/// Description： 	查询药品项
/// Table：        	CF.AN.UserPreferedData
/// Input:			
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.PACURecord","FindUserPreferedData","2")
Query FindUserPreferedData(dataRowId As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT *
	from CF_AN.UserPreferedData
	where RowId=:dataRowId
}

/// Creator：      	雍阳
/// CreatDate：    	2018-10-30
/// Description： 	查询药品项
/// Table：        	CF.AN.UserPreferedDrug
/// Input:			
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.PACURecord","FindUserPreferedDrug","2")
Query FindUserPreferedDrug(dataRowId As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT *
	from CF_AN.UserPreferedDrug
	where UserPreferedData=:dataRowId
}

/// Creator：      	雍阳
/// CreatDate：    	2018-10-30
/// Description： 	查询药品项
/// Table：        	CF.AN.UserPreferedDrug
/// Input:			
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.PACURecord","FindUserPreferedEvent","2")
Query FindUserPreferedEvent(dataRowId As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT *
	from CF_AN.UserPreferedEventDetail
	where UserPreferedData=:dataRowId
}

/// 同步手术关键事件的时间
ClassMethod SyncEventTime(opsId) As %String
{
	quit:'##class(CIS.AN.OperSchedule).%ExistsId(ospId) "E^手术安排记录ID错误"
	
	kill needSyncEventCode
	set needSyncEventCode("PACUIn")="PACUInDT"
	set needSyncEventCode("PACUOut")="PACUOutDT"
	
	set moduleCode = "PACURecord"
	set recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCode(opsId,moduleCode,"")
	
	kill anathesia
	set anaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
	set anathesia("RowId")=anaId
	set anathesia("ClassName")="CT.AN.Anaesthesia"
	
	set anaDatas = ##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.PACURecord:FindAnaDatas",recordSheetId,"N")
	for i=1:1:anaDatas.Size
	{
		set anaData = anaDatas.GetAt(i)
		quit:anaData=""
		
		continue:anaData.GetValue("ItemCategory")'="E"  // 非事件数据退出
		
		set itemCode = anaData.GetValue("DataItemCode")
		if ($d(needSyncEventCode(itemCode)))
		{
			set anathesia(needSyncEventCode(itemCode))=anaData.GetValue("StartDT")
		}
	}
	
	tstart
	
	set saveResult=##class(CIS.AN.COM.DataService).SaveData(.anathesia)
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult	
	}
	tcommit
	
	quit "S^Ok!"
}

/// Creator：      	雍阳
/// CreatDate：    	2018-12-18
/// Description： 	是否已打印
/// Table：        	CIS.AN.RecordSheet
/// Input:			opsId:手术安排ID
/// Return：       	Y,N
/// w ##class(CIS.AN.BL.PACURecord).SyncEventTime()
ClassMethod IsPrinted(opsId) As %String
{
	set moduleCode = "PACURecord"
	set recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCode(opsId,moduleCode,"")
	set recordSheet=##class(CIS.AN.RecordSheet).%OpenId(recordSheetId)
	set result="Y"
	//if recordSheet.PrintDate>0  set result="Y"
	
	quit result
}

/// w ##class(CIS.AN.BL.PACURecord).GetPACURecordId(3)
ClassMethod GetPACURecordId(opsId As %String) As %String
{
	set rowId=""
	&sql(select top 1 RowId into :rowId from cis_an.pacurecord where operschedule=:opsId)
	
	if SQLCODE quit ""
	quit rowId
}

/// Creator：      	雍阳
/// CreatDate：    	2020-02-21
/// Description： 	保存表格填写的PACU记录数据
/// Table：        	DHCAN.Model.AnaData
/// Input:			
/// Return：       	
/// w ##class(DHCAN.BLL.PACURecord).SavePACUData(29,^TMPAN("SavePACUData","Param"),10717,79)
ClassMethod SavePACUData(opsId, data, userId, moduleId) As %String
{
	//set ^TMPAN("SavePACUData","Param")=data
	quit:moduleId="" "E^模块不存在"
	set recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdNew(opsId,moduleId,"")
	quit:recordSheetId="" "E^表单不存在"
	
	set PACUCategoryCode="PACUDataTable" //暂时固定代码
	
	set sc=##class(CIS.AN.COM.String).ToArray(data,.array)
	do ..GetPACUDataGroups(recordSheetId,.datagroups)
	do ..GetParaItemGroups(recordSheetId,.paraItemGroups)
	do ..GetCategoryItemGroups(.categoryItemGroups)
	
	break //
	tstart
	set index=0,saveResult="S^"
	for
	{
		set index = $o(array(index))
		quit:index=""
		
		set datetime = array(index,"DateTime")
		set dateH = ##class(CIS.AN.COM.DateTime).ConvertToDateH($p(datetime," ",1))
		set timeH = ##class(CIS.AN.COM.DateTime).ConvertToTimeH($p(datetime," ",2))
		set dataItemCode=""
		for
		{
			set dataItemCode=$o(array(index,dataItemCode))
			quit:dataItemCode=""
			
			continue:dataItemCode="DateTime"
			
			set existedData = $g(datagroups(dateH,timeH,dataItemCode))
			if existedData'="" set datagroups(dateH,timeH,dataItemCode,"Checked")=1
			
			kill anaData
		
			set anaData("ClassName")="CIS.AN.AnaData"
			set anaData("CreateUserID")=userId
			set anaData("CreateDate")=+$h
			set anaData("CreateTime")=$p($h,",",2)
			set anaData("UserDefinedItem")=""
			set anaData("Source")="M"
			set anaData("Continuous")="N"
			set anaData("UpdateUser")=userId
			set anaData("UpdateDate")=+$h
			set anaData("UpdateTime")=$p($h,",",2)
			set anaData("FromData")=""
		
			set value = array(index,dataItemCode)
			set rowId = ""
			if existedData'=""
			{
				set rowId=$lg(existedData,1)
				set oldValue=$lg(existedData,2)
				continue:value=oldValue
			}
			
			continue:(value="")&&(rowId="")
		
			set anaData("RowId")=rowId
			set anaData("StartDate")=dateH
			set anaData("StartTime")=timeH
			set anaData("EndDate")=dateH
			set anaData("EndTime")=timeH
			set anaData("EditFlag")="N"
			
			set categoryItem=$g(categoryItemGroups(PACUCategoryCode,dataItemCode))
			continue:categoryItem=""
			set categoryItemId=$lg(categoryItem,1)
			set dataItemId=$lg(categoryItem,4)
			set anaData("CategoryItem")=categoryItemId
			set anaData("DataItem")=dataItemId
			
			break //
			
			set paraItem=$g(paraItemGroups(categoryItemId))
			if paraItem="" set paraItemId=$$AddParaItem(dataItemCode,categoryItem)
			else  set paraItemId=$lg(paraItem,1)
			continue:paraItemId=""
			set anaData("ParaItem")=paraItemId
			
			if value'="" set anaData("DataValue")=value
			else  set anaData("EditFlag")="D"
			
			set saveResult=##class(CIS.AN.COM.DataService).SaveData(.anaData)
			if ($piece(saveResult,"^",1)'="S")
			{
				quit
			}
		}
		
		if ($piece(saveResult,"^",1)'="S")
		{
			quit
		}
	}
	
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult	
	}
	
	set dateH=""
	for
	{
		set dateH=$o(datagroups(dateH))
		quit:dateH=""
		
		set timeH=""
		for
		{
			set timeH=$o(datagroups(dateH,timeH))
			quit:timeH=""
			
			set dataItemCode=""
			for
			{
				set dataItemCode=$o(datagroups(dateH,timeH,dataItemCode))
				quit:dataItemCode=""
				
				continue:$g(datagroups(dateH,timeH,dataItemCode,"Checked"))
				
				kill anaData
				set anaData("ClassName")="CIS.AN.AnaData"
				set anaData("RowId")=$lg(datagroups(dateH,timeH,dataItemCode),1)
				set anaData("EditFlag")="D"
				
				set saveResult=##class(CIS.AN.COM.DataService).SaveData(.anaData)
				if ($piece(saveResult,"^",1)'="S") quit
			}
			if ($piece(saveResult,"^",1)'="S") quit
		}
		if ($piece(saveResult,"^",1)'="S") quit
	}
	
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult	
	}
	tcommit
	
	quit "S^"
	
AddParaItem(dataItemCode,categoryItem)
	kill addingParaItem
	
	set addingParaItem("ClassName")="CIS.AN.ParaItem"
	set addingParaItem("RowId")=""
	set addingParaItem("RecordSheet")=recordSheetId
	set addingParaItem("CategoryItem")=categoryItemId
	set addingParaItem("Code")=dataItemCode
	set addingParaItem("Description")=$lg(categoryItem,2)
	set addingParaItem("DataCategory")=$lg(categoryItem,3)
	
	set saveResult=##class(CIS.AN.COM.DataService).SaveData(.addingParaItem)
	set paraItemRowId=$p(saveResult,"^",2)
	if ($piece(saveResult,"^",1)'="S") quit ""
	
	quit paraItemRowId
}

/// Creator：      	雍阳
/// CreatDate：    	2020-02-20
/// Description： 	获取界面项目分组数据
/// Table：        	DHCAN.Model.RecParaItem
/// Input:			opsId:手术计划ID，moduleId:模块ID
/// Return：       	数据Json
/// Debug:			w ##class(DHCAN.BLL.PACURecord).GetPACUDataJson(12,27)
ClassMethod GetParaItemGroups(recordSheetID, ByRef itemGroups) As %String
{
	kill itemGroups
	set paraItemObjects=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.DataQueries:FindParaItems",recordSheetID)
	
	for i=1:1:(paraItemObjects.Size)
	{
		set paraItemObject = paraItemObjects.GetAt(i)
		continue:paraItemObject=""
		
		set paraItemRowId = paraItemObject.GetValue("RowId")
		set paraItemDesc = paraItemObject.GetValue("Description")
		set categoryItem = paraItemObject.GetValue("CategoryItem")
		set:categoryItem'="" itemGroups(categoryItem) = $lb(paraItemRowId,paraItemDesc)
	}
	
	quit ""
}

/// Creator：      	雍阳
/// CreatDate：    	2020-02-20
/// Description： 	获取数据项目分组数据
/// Table：        	DHCAN.Model.RecParaItem
/// Input:			opsId:手术计划ID，moduleId:模块ID
/// Return：       	数据Json
/// Debug:			w ##class(DHCAN.BLL.PACURecord).GetCategoryItemGroups(.array)
ClassMethod GetCategoryItemGroups(ByRef itemGroups) As %String
{
	kill itemGroups
	set itemObjects=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.CodeQueries:FindCategoryItem","","")
	
	for i=1:1:(itemObjects.Size)
	{
		set itemObject = itemObjects.GetAt(i)
		continue:itemObject=""
		
		set rowId = itemObject.GetValue("RowId")
		set desc = itemObject.GetValue("ItemDesc")
		set dataItemCode = itemObject.GetValue("ItemCode")
		set categoryCode = itemObject.GetValue("CategoryCode")
		set category = itemObject.GetValue("DataCategory")
		set dataItem = itemObject.GetValue("DataItem")
		set itemGroups(categoryCode,dataItemCode) = $lb(rowId,desc,category,dataItem)
	}
	
	quit ""
}

/// Creator：      	雍阳
/// CreatDate：    	2018-04-03
/// Description： 	获取生命体征分组后的数据
/// Table：        	DHCAN.RecordData
/// Input:			opsId:手术计划ID，moduleId:模块ID
/// Return：       	数据Json
/// Debug:			w ##class(CIS.AN.BL.PACURecord).GetPACUDataGroups(4,.dataGroups)
ClassMethod GetPACUDataGroups(recordSheetID, ByRef dataGroups) As %String
{
	kill dataGroups
	set recordDatas=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.PACURecord:FindAnaDatas",recordSheetID,"N")
	for i=1:1:(recordDatas.Size)
	{
		set recordData = recordDatas.GetAt(i)
		continue:recordData=""
		set paraItemId = recordData.GetValue("ParaItem")
		set dataItemCode = recordData.GetValue("DataItemCode")
		set rowId = recordData.GetValue("RowId")
		set dataValue = recordData.GetValue("DataValue")
		set date = recordData.GetValue("StartDate")
		set time = recordData.GetValue("StartTime")
		set dateH = $zdh(date,3)
		set timeH = $zth(time)
		//write rowId," ",date," ",time," ",dataItemCode,!
		set:dataItemCode'="" dataGroups(dateH,timeH,dataItemCode)=$lb(rowId,dataValue)
	}
	
	quit ""
}

/// Creator：      	雍阳
/// CreatDate：    	2018-04-03
/// Description： 	获取生命体征分组后的数据
/// Table：        	DHCAN.RecordData
/// Input:			opsId:手术计划ID，moduleId:模块ID
/// Return：       	数据Json
/// Debug:			w ##class(DHCAN.BLL.PACURecord).GetPACUDataJson(29,79)
ClassMethod GetPACUDataJson(opsId, moduleId) As %String
{
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术计划不存在！"
	quit:(##class(CT.AN.DataModule).%ExistsId(moduleId)=0) "E^数据模块不存在！"
	kill datagroups
	set recordSheetID=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdNew(opsId,moduleId,"")
	
	do ..GetPACUDataGroups(recordSheetID,.datagroups)
	
	write "{""rows"":["
	
	set dateH="",total=0,isFirstRow=1
	for
	{
	
		set dateH=$order(datagroups(dateH))
		quit:dateH=""
		
		set timeH=""
		for
		{
			set timeH=$order(datagroups(dateH,timeH))
			quit:timeH=""
		
			set datetime=$zd(dateH,3)_" "_$zt(timeH)
			if 'isFirstRow write ","
			write "{""DateTime"":""",datetime,""""
			
			set total=total+1
			set dataItemCode=""
			for
			{
				set dataItemCode=$order(datagroups(dateH,timeH,dataItemCode))
				quit:dataItemCode=""
				set value=$lg(datagroups(dateH,timeH,dataItemCode),2)
				write ",""",dataItemCode,""":""",value,""""
			}
		
			write "}"
			set isFirstRow=0
		}
	}
	
	write "],""total"":",total
	
	write "}"
	
	quit ""
}

/// Creator：      	雍阳
/// CreatDate：    	2018-8-3
/// Description： 	查询当前入恢复室的病人列表
/// Table：        	CIS.AN.OperSchedule
/// Input:			
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.PACURecord","FindPACUList")
Query FindPACUList(filterDate As %String = "", finished As %String = "") As %Query(ROWSPEC = "InPACUSteward,InPACUStewardScore,InPACUStewardConscious,InPACUStewardRespiration,InPACUStewardMotion,OutPACUSteward,OutPACUStewardScore,OutPACUStewardConscious,OutPACUStewardRespiration,OutPACUStewardMotion,RowId,OPSID,EpisodeID,ExtAnaestID,PatName,PatGender,PatAge,PatDOB,RegNo,MedcareNo,PatientID,MRAdmID,AdmReason,PatCardID,Patient,PatDeptID,PatDeptDesc,PatWardID,PatWardDesc,PatBedID,PatBedCode,AppDeptID,AppDeptDesc,AppCareProvID,AppCareProvDesc,OperDeptID,OperDeptDesc,AnaDept,AnaDeptDesc,SourceType,SourceTypeDesc,Status,StatusDesc,StatusColor,StatusCode,OperDate,OperTime,OperDuration,ReentryOperation,Anaesthesia,AnaesthesiaDesc,PrevAnaMethod,PrevAnaMethodDesc,PlanOperSeq,PlanSeq,SeqType,SeqTypeDesc,PrevDiagnosis,PrevDiagnosisDesc,PlanOperDesc,PlanOperNote,PlanSurgeonDesc,PlanAsstDesc,PlanFirstAsstDesc,OperDesc,OperNote,SurgeonDesc,AsstDesc,FirstAsstDesc,BodySite,OperPosition,SurIntership,SurVisitors,SurgicalMaterials,SpecialConditions,HighConsume,IsoOperation,ECC,TransAutoblood,PrepareBlood,InfectionOper,MIS,Antibiosis,OperRequirement,BloodType,RHBloodType,HbsAg,HcvAb,HivAb,Syphilis,OperRoom,RoomDesc,RoomCode,OperSeq,ScrubNurse,ScrubNurseDesc,CircualNurse,CircualNurseDesc,InternshipNurse,FirstScrubNurse,FirstScrubNurseDesc,SecScrubNurse,SecScrubNurseDesc,FirstCirNurse,FirstCirNurseDesc,SecCirNurse,SecCirNurseDesc,WardBed,TheatreInDT,TheatreOutDT,OperStartDT,OperFinishDT,AnaStartDT,AnaFinishDT,TubeInDT,TubeOutDT,AreaInDT,AreaOutDT,PACUInDT,PACUOutDT,ECGDoctor,OperDateTime,AnaestID,AnaMethod,AnaMethodDesc,AnaExpert,AnaExpertDesc,Anesthesiologist,AnesthesiologistDesc,AnaAssistant,AnaAssistantDesc,AnaStaff,BodySiteDesc,OperPositionDesc,PreopAdmDays,PACUDuration,ROperDuration,WaitDuration,InfectionOperDesc,AntibiosisDesc,MainAnaesthesia,AppDateTime,PostDiagnosis,PostDiagnosisDesc,BladeType,BladeTypeDesc,ASAClass,ASAClassDesc,PreOperNote,PreMedication,PreFasting,PreFastingDesc,PatHeight,PatWeight,AnaestMethod,AnaCareProv,SurCareProv,ReentryOperationDesc,IsoOperationDesc,ECCDesc,TransAutoBloodDesc,PrepareBloodDesc,MISDesc,BladeTypeDesc,RHBloodTypeDesc,HbsAgDesc,HcvAbDesc,HivAbDesc,SyphilisDesc,BloodTypeDesc,DaySurgery,TheatreInTime,AnestStartTime,OperStartTime,OperEndTime,AnestEndTime,TheatreOutTime,OPAID,ArrOperRoom,ArrRoomCode,ArrRoomDesc,ArrOperSeq,ArrScrubNurse,ArrScrubNurseDesc,ArrCircualNurse,ArrCircualNurseDesc,ArrFirstScrubNurse,ArrFirstScrubNurseDesc,ArrSecScrubNurse,ArrSecScrubNurseDesc,ArrFirstCirNurse,ArrFirstCirNurseDesc,ArrSecCirNurse,ArrSecCirNurseDesc,MDROS,PlanSurgeonExpert,SurgeonExpert,TheatreOutTransLoc,TheatreOutTransLocDesc,OPAdmType,ComeHosTime,PatPhoneNumber,PatNeedNotice,AppUserID,ArrAnaExpert,ArrAnaExpertDesc,ArrAnesthesiologist,ArrAnesthesiologistDesc,ArrAnaAssistant,ArrAnaAssistantDesc,ArrAnaStaff,ArrAnaMethod,ArrAnaMethodDesc,PACUBed,PACUBedDesc,MDROSDesc,OPFeeFlag,OPFeeFlagDesc,ANFeeFlag,ANFeeFlagDesc,OperRiskAssessment,OperSafetyCheck,OperCount,AnaestConsent,PrevANVisit,PostANVisit,AnaestRecord,PACURecord,AnaestConclusion,MainPACURecordID,PACUDoctor,PACUDoctorDesc,PACUShiftDoctor,PACUShiftDoctorDesc,WardReceiveCareProv,CarriedTube,Complication,PostOperNote,PACUInSteward,PACUInStewardScore,PACUOutSteward,PACUOutStewardScore,AnaDept,AnaDeptDesc,PACUInTime,PACUOutTime,OperExecDeptID,OperExecDeptDesc,ArrOperTime,PACUInStewardConscious,PACUInStewardRespiration,PACUInStewardMotion,PACUOutStewardConscious,PACUOutStewardRespiration,PACUOutStewardMotion") [ SqlProc ]
{
}

ClassMethod FindPACUListExecute(ByRef qHandle As %Binary, filterDate As %String = "", finished As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	set startDateH=+$h-1
	set endDateH=+$h
	
	if filterDate'=""
	{
		set endDateH=##class(CIS.AN.COM.DateTime).ConvertToDateH(filterDate)
		set startDateH=+endDateH-1
	}
	
	//set startDateH=$zdh("2020-08-18",3)
	//set endDateH=$zdh("2020-08-18",3)
	
	set indexNode="OPDate"
	for date=startDateH:1:endDateH
	{
		set opsId=0
		for
		{
			set opsId=$order(^CIS.AN.OperScheduleI(indexNode,date,opsId))
			quit:(opsId="")
			
			set anaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
			continue:('##class(CIS.AN.Anaesthesia).%ExistsId(anaId))
			set anaestthesia=##class(CIS.AN.Anaesthesia).%OpenId(anaId)
			continue:(anaestthesia.TheatreOutTransLoc'="PACU") //仅此处判断，手术结束后转到位置为恢复室的手术
			
			continue:(finished="Y")&&(anaestthesia.PACUOutDT="") //结束
			
			set pacuRecordId=..GetMainPACURecordId(opsId)
			if (pacuRecordId'="")
			{
				set pacuRecord=##class(CIS.AN.PACURecord).%OpenId(pacuRecordId)
				set inPACUSteward="",score="",conscious="",respiration="",motion=""
				if (pacuRecord.InSteward'="")
				{
					set inPACUSteward = pacuRecord.InSteward.%Id()
					set score = pacuRecord.InSteward.Score
					set conscious = pacuRecord.InSteward.Conscious
					set respiration = pacuRecord.InSteward.Respiration
					set motion = pacuRecord.InSteward.Motion
				}
				set steward = $lb(inPACUSteward,score,conscious,respiration,motion)
			
				set outPACUSteward="",score="",conscious="",respiration="",motion=""
				if (pacuRecord.OutSteward'="")
				{
					set outPACUSteward = pacuRecord.OutSteward.%Id()
					set score = pacuRecord.OutSteward.Score
					set conscious = pacuRecord.OutSteward.Conscious
					set respiration = pacuRecord.OutSteward.Respiration
					set motion = pacuRecord.OutSteward.Motion
				}
				set steward = steward_$lb(outPACUSteward,score,conscious,respiration,motion)
			}
			else
			{
				set steward = $lb("","","","","","","","","","")
			}
			
			do OutputRow
		}	
	}
	s qHandle=$lb(0,repid,0)
	q $$$OK
OutputRow
	s ^CacheTemp(repid,ind)=steward_##class(CIS.AN.BL.OperScheduleList).GetOperSchedule(opsId)
	s ind=ind+1
	q
}

ClassMethod FindPACUListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPACUListExecute ]
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

ClassMethod FindPACUListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPACUListExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// w ##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(3)
ClassMethod GetMainPACURecordId(opsId As %String) As %String
{
	set rowId=""
	&sql(select top 1 RowId into :rowId from cis_an.pacurecord where operschedule=:opsId)
	
	if SQLCODE quit ""
	quit rowId
}

/// ygb  20210812
/// 重返监护
ClassMethod ReStartRecord(data As %String) As %String
{
	s ^TMPYGB("ReStartRecord")=data
	tstart
	set result=""
	set status=##class(CIS.AN.COM.String).ToArray(data,.array)
	merge operSchedule=array(1)
	if ($get(operSchedule("Status"))="")&($get(operSchedule("StatusCode"))'="")
	{
		set operSchedule("Status")=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode(operSchedule("StatusCode"))
	}	
	
	set opsId=operSchedule("RowId")
	if (opsId="")
	{
		trollback
		quit "E^无手术安排表ID"	
	}
	
	set saveResult=##class(CIS.AN.COM.DataService).SaveData(.operSchedule)
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult		
	}
	
	set anaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
	set AnaesthesiaObj=##class(CIS.AN.Anaesthesia).%OpenId(anaId)
	set formerDT=AnaesthesiaObj.PACUInDT
	set currentDT=operSchedule("PACUInDT")
	
	// 回写旧表 CCQ20200402
	set saveResult=##class(CIS.AN.SRV.OperAppService).StartPACURecord(operSchedule("RowId"),"")
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult		
	}
	
	tcommit
	
	do ..CreatePACURecord(operSchedule("RowId"))
	do ..AutoCreateParaItem(operSchedule("RowId"))
	do ..AutoCreateDeviceUsage(operSchedule("RowId"),operSchedule("UpdateUser"),operSchedule("PACUInDT"))
	if ($get(operSchedule("isStarting"))'="N"){//开始监护按钮的特殊处理
		set personalSetting=..GetPersonalSetting("PACURecord",operSchedule("UpdateUser"))
		if (personalSetting.GetValue("AutoApplyTemplate")'="")
		{
			set moduleCode = "PACURecord"
			set recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCode(operSchedule("RowId"),moduleCode,"")
			do ..ApplyTemplate(recordSheetId,personalSetting.GetValue("AutoApplyTemplate"),operSchedule("UpdateUser"))
		}
		else
		{
			set moduleCode = "PACURecord"
			set recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCode(operSchedule("RowId"),moduleCode,"")
			set publicTemplateId=..GetPublicTempalte(moduleCode)
			if publicTemplateId'="" do ..ApplyTemplate(recordSheetId,publicTemplateId,operSchedule("UpdateUser"))
		}
	}
	quit "S^"
}

ClassMethod TriggerEvent(opsId, originalStatusCode, currentStatusCode) As %String
{
	try
	{
		set args=##class(CIS.AN.DTO.Event.Args.OnStatusChange).%New()
		set args.RowId=opsId
		set args.OriginalStatusCode=originalStatusCode
		set args.CurrentStatusCode=currentStatusCode
		
		set sc=##class(CIS.AN.SRV.Event.OnStatusChange).Trigger(args)
	}
	catch(e)
	{
		write e.DisplayString(),!
	}
	quit ""
}

}
