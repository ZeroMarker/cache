/// 麻醉记录业务逻辑类
Class CIS.AN.BL.AnaestRecord Extends %RegisteredObject
{

/// 时间列的格式
Parameter TimeColumnFormat = 2;

/// Creator：      	陈长青
/// CreatDate：    	2017-03-20
/// Description： 	查询时间轴信息
/// Table：        	DHCAN.TimeLine
/// Input:			opsId:手术计划ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.AnaestRecord","FindTimeLines","1")
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
/// Debug:			w ##class(CIS.AN.BL.AnaestRecord).GetRecordStartDT("")
ClassMethod GetRecordStartDT(opsId As %String) As %String
{
	set result=""
	if (##class(CIS.AN.OperSchedule).%ExistsId(opsId))
	{
		set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		set anaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
		set AnaesthesiaObj=##class(CIS.AN.Anaesthesia).%OpenId(anaId)
		set theatreInDT=AnaesthesiaObj.TheatreInDT
		
		if (theatreInDT'="")
		{
			set theatreInDate=##class(CIS.AN.COM.DateTime).ConvertToDateH($piece(theatreInDT," ",1))		
		}
		else
		{
			set theatreInDate=##class(CIS.AN.COM.DateTime).ConvertToDateH(operSchedule.OperDate)	
		}
	}	
	else
	{
		set theatreInDT=""	
		set theatreInDate=##class(CIS.AN.COM.DateTime).ConvertToDateH($piece(theatreInDT," ",1))	
	}
	//set theatreInDate=##class(CIS.AN.COM.DateTime).ConvertToDateH($piece(theatreInDT," ",1))
	set theatreInTime=##class(CIS.AN.COM.DateTime).ConvertToTimeH($piece(theatreInDT," ",2))		
	set minutes=##class(CIS.AN.COM.DateTime).GetMinutes(theatreInTime)
	set seconds=##class(CIS.AN.COM.DateTime).GetSeconds(theatreInTime)
	set overplus=(minutes#10)
	if (overplus>=5){
		set theatreInTime=(+theatreInTime)-((overplus-5)*60)-(+seconds)	
	}
	else
	{
		set theatreInTime=(+theatreInTime)-(overplus*60)-(+seconds)	
	}
	set result=##class(CIS.AN.COM.DateTime).ConvertToDateTime(theatreInDate,theatreInTime)
	quit result
}

/// Creator：      	雍阳
/// CreatDate：    	2018-04-03
/// Description： 	获取麻醉监护的结束时间
/// Table：        	
/// Input:			opsId:手术计划ID
/// Return：       	麻醉监护结束时间字符串(格式为yyyy-mm-dd HH:mm)
/// Debug:			w ##class(CIS.AN.BL.AnaestRecord).GetRecordEndDT("")
ClassMethod GetRecordEndDT(opsId As %String) As %String
{
	set result=""
	if (##class(CIS.AN.OperSchedule).%ExistsId(opsId))
	{
		set anaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
		set AnaesthesiaObj=##class(CIS.AN.Anaesthesia).%OpenId(anaId)
		set TheatreOutDT=AnaesthesiaObj.TheatreOutDT
		set duration=##class(CIS.AN.COM.DateTime).CalculateDurationS(AnaesthesiaObj.TheatreInDT,AnaesthesiaObj.TheatreOutDT)
		
        // 麻醉结束时间>麻醉开始时间时,才认为麻醉结束时间有效；否则，返回当前时间
		if (duration>0)
		{
			set result=TheatreOutDT
		}
		else
		{
			set result=##class(CIS.AN.COM.DateTime).ConvertToDateTime(+$h,+$piece($h,",",2))
		}
	}
	
	quit result
}

/// Creator：      	雍阳
/// CreatDate：    	2018-04-03
/// Description： 	获取气管拔管的时间
/// Table：        	
/// Input:			opsId:手术计划ID
/// Return：       	气管拔管结束时间字符串(格式为yyyy-mm-dd HH:mm)
/// Debug:			w ##class(CIS.AN.BL.AnaestRecord).GetTubeOutDT("")
ClassMethod GetTubeOutDT(opsId As %String) As %String
{
	set result=""
	if (##class(CIS.AN.OperSchedule).%ExistsId(opsId))
	{
		set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		set TubeOutDT=operSchedule.TubeOutDT
		
		if (TubeOutDT'="")
		{
			set result=TubeOutDT
		}
		else
		{
			set result=##class(CIS.AN.COM.DateTime).ConvertToDateTime(+$h,+$piece($h,",",2))
		}
	}
	
	quit result
}

/// Creator：      	雍阳
/// CreatDate：    	2019-01-21
/// Description： 	获取麻醉记录中的手术开始时间
/// Table：        	
/// Input:			opsId:手术计划ID
/// Return：       	手术开始时间字符串(格式为yyyy-mm-dd HH:mm)
/// Debug:			w ##class(CIS.AN.BL.AnaestRecord).GetOperStartDT("")
ClassMethod GetOperStartDT(opsId As %String) As %String
{
	set result=""
	set moduleCode = "AnaestRecord"
	set recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCodeNew(opsId,moduleCode,"")
	set paraItemId=$$GetParaItemId(recordSheetId,"OperationEvent")
	set:paraItemId'="" result=$$GetAnaDataDT(paraItemId,"OperStart")
	
	quit result

GetParaItemId(recordSheetId,code)
	set paraItemId=""
	&sql(SELECT RowId into :paraItemId FROM CIS_AN.ParaItem 
		WHERE RecordSheet=:recordSheetId and Code=:code)
	quit paraItemId
	
GetAnaDataDT(paraItemId,code)
	set anaDate="",anaTime=""
	
	&sql(SELECT StartDate,StartTime into :anaDate,:anaTime FROM CIS_AN.AnaData
		WHERE ParaItem=:paraItemId and DataItem->Code=:code)
		
	if anaDate'="" quit $zd(anaDate,3)_" "_$zt(anaTime)
	
	quit ""
}

/// Creator：      	陈长青
/// CreatDate：    	2017-10-11
/// Description： 	启动麻醉监护
/// Table：        	DHCAN.OperSchedule
/// Input:			data:启动监护参数
/// Return：       	启动成功返回"S^"，失败返回"E^原因"
/// Debug:			w ##class(CIS.AN.BL.AnaestRecord).StartRecord("^TMPYGBStartRecord("StartRecord")")
ClassMethod StartRecord(data As %String) As %String
{
	set ^TMPYGBStartRecord("StartRecord")=data
	set opsId="",formerDT="",currentDT=""
	tstart
	set saveResult="S^"
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
	set anaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
	set AnaesthesiaObj=##class(CIS.AN.Anaesthesia).%OpenId(anaId)
	set formerDT=AnaesthesiaObj.TheatreInDT
	set currentDT=operSchedule("TheatreInDT")
	
	set saveResult=##class(CIS.AN.COM.DataService).SaveData(.operSchedule)
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult		
	}
	
	set anaesthesia("ClassName")="CIS.AN.Anaesthesia"
	set anaesthesia("RowId")=anaId
	set anaesthesia("TheatreInDT")=currentDT
	set saveResult=##class(CIS.AN.COM.DataService).SaveData(.anaesthesia)
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult		
	}
	
	/// 写入手术操作过程 CCQ 20200225
	set saveResult=##class(CIS.AN.BL.SurgicalProcedure).SaveProcedureByDT(operSchedule("RowId"),"RI",operSchedule("UpdateUser"),currentDT)
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult		
	}
	
	tcommit
	
	do ..AutoCreateParaItem(operSchedule("RowId"))
	do ..AutoCreateDeviceUsage(operSchedule("RowId"),operSchedule("UpdateUser"),operSchedule("TheatreInDT"))
	
	set personalSetting=..GetPersonalSetting("AnaestRecord",operSchedule("UpdateUser"))
		
	if ($get(operSchedule("isStarting"))'="N") //修改开始时间时不调用自动生成的方法
	{
		if (personalSetting.GetValue("AutoCreateEvent")="Y")
		{
			//do ..AutoCreateDefaultEvents(operSchedule("RowId"),operSchedule("UpdateUser"),operSchedule("TheatreInDT"))
		}
		if (personalSetting.GetValue("AutoApplyTemplate")'="")
		{
			set moduleCode = "AnaestRecord"
			set recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCode(operSchedule("RowId"),moduleCode,"")
			do ..ApplyTemplate(recordSheetId,personalSetting.GetValue("AutoApplyTemplate"),operSchedule("UpdateUser"))
		}
		else
		{
			set moduleCode = "AnaestRecord"
			set recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCode(operSchedule("RowId"),moduleCode,"")
			set publicTemplateId=..GetPublicTemplate(moduleCode)
			if publicTemplateId'="" do ..ApplyTemplate(recordSheetId,publicTemplateId,operSchedule("UpdateUser"))
		}
		
		do ..GenerateDefaultValue(operSchedule("RowId"))
		do ..AutoGenerateUserPreferedData(operSchedule("RowId"),operSchedule("UpdateUser"),operSchedule("TheatreInDT"))
		do ..AutoCreateEvent(operSchedule("RowId"),operSchedule("UpdateUser"),operSchedule("TheatreInDT"),"OperRoomIn")
		do ..SyncPatInfo(operSchedule("RowId"))
		do ..TriggerEvent(operSchedule("RowId"),"Arrange","RoomIn")
	}
	else
	{
		//set ^TMPAN("StartRecord",opsId)=formerDT_" -> "_currentDT
		set timeSpan=##class(CIS.AN.COM.DateTime).CalculateDurationS(formerDT,currentDT,"S")
		do ..TranslateData(opsId,timeSpan)
		do ..RemoveOutrangedData(opsId,currentDT)
	}
	
	do ..AfterStartRecord(opsId)
	quit saveResult
}

ClassMethod AfterStartRecord(opsId) As %Status
{
	try
	{
		// 回写旧表
		set saveResult=##class(CIS.AN.SRV.OperAppService).StartANRecord(opsId,"")
	}
	catch(e)
	{
		
	}
	
	quit $$$OK
}

ClassMethod GetPublicTemplate(moduleCode As %String = "AnaestRecord") As %String
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
/// CreatDate：    	2020-03-17
/// Description： 	启动麻醉监护时自动同步病人信息（身高体重从术前访视中）
/// Table：        	CIS.AN.OperSchedule
/// Input:			opsId:手术排班表ID
/// Return：       	启动成功返回"S^"，失败返回"E^原因"
/// Debug:			w ##class(CIS.AN.BL.AnaestRecord).SyncPatInfo("220")
ClassMethod SyncPatInfo(opsId As %String) As %String
{
	set moduleCode = "AN_ANS_004"
	set recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCode(opsId,moduleCode,"")
	set patHeight=##class(CIS.AN.BL.OperData).GetOperDataByCodeNew(recordSheetId,"PatHeight")
	set patWeight=##class(CIS.AN.BL.OperData).GetOperDataByCodeNew(recordSheetId,"PatWeight")
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set:patHeight'="" operSchedule.PatHeight=patHeight
	set:patWeight'="" operSchedule.PatWeight=patWeight
	
	do operSchedule.%Save()
	
	set mainAnaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
	set anaCatheterId=$o(^CIS.AN.AnaestCatheterI("IAna",mainAnaId,""))
	if (anaCatheterId="")&&(operSchedule.PrevAnaMethod'="")
	{
		if ##class(CT.AN.AnaMethod).%ExistsId(operSchedule.PrevAnaMethod)
		{
			set anaCatheter=##class(CIS.AN.AnaestCatheter).%New()
			set anaCatheter.Anaesthesia=##class(CIS.AN.Anaesthesia).%OpenId(mainAnaId)
			set anaCatheter.AnaMethod=##class(CT.AN.AnaMethod).%OpenId(operSchedule.PrevAnaMethod)
			do anaCatheter.%Save()
		}
	}
	
	quit "S^"
}

/// Creator：      	雍阳
/// CreatDate：    	2018-09-17
/// Description： 	启动麻醉监护后自动创建默认事件
/// Table：        	CIS.AN.OperSchedule
/// Input:			opsId:手术排班表ID
/// Return：       	启动成功返回"S^"，失败返回"E^原因"
/// Debug:			w ##class(CIS.AN.BL.AnaestRecord).AutoCreateDefaultEvents("")
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
/// Description： 	启动麻醉监护后自动创建默认事件
/// Table：        	CIS.AN.OperSchedule
/// Input:			opsId:手术排班表ID
/// Return：       	启动成功返回"S^"，失败返回"E^原因"
/// Debug:			w ##class(CIS.AN.BL.AnaestRecord).AutoCreateDefaultEvents("")
ClassMethod AutoCreateDefaultEvents(opsId, userId, baseDateTime) As %String
{
	// 开始监护
	do ..AutoCreateEvent(opsId,userId,baseDateTime,"OperRoomIn")
	// + 5分钟
	set recordStartDT=baseDateTime
	set recordStartDate=$p(recordStartDT," ",1)
	set recordStartTime=$p(recordStartDT," ",2)
	set recordStartDate=##class(CIS.AN.COM.DateTime).ConvertToDateH(recordStartDate)
	set recordStartTime=##class(CIS.AN.COM.DateTime).ConvertToTimeH(recordStartTime)
	set eventDateTime=##class(CIS.AN.COM.DateTime).DateTimeAdd(recordStartDate,recordStartTime,300)
	set eventDateTime=$tr(eventDateTime,"^"," ")
	// 耗材
	//do ..AutoCreateEvent(opsId,userId,eventDateTime,"","7")
	//do ..AutoCreateEvent(opsId,userId,eventDateTime,"","12")
	//do ..AutoCreateEvent(opsId,userId,eventDateTime,"","11")
	// + 10分钟
	set eventDateTime=##class(CIS.AN.COM.DateTime).DateTimeAdd(recordStartDate,recordStartTime,600)
	set eventDateTime=$tr(eventDateTime,"^"," ")
	// 耗材
	//do ..AutoCreateEvent(opsId,userId,eventDateTime,"","13")
	//do ..AutoCreateEvent(opsId,userId,eventDateTime,"","61")
	//do ..AutoCreateEvent(opsId,userId,eventDateTime,"","134")
	//do ..AutoCreateEvent(opsId,userId,eventDateTime,"","83")
	// + 30分钟
	set eventDateTime=##class(CIS.AN.COM.DateTime).DateTimeAdd(recordStartDate,recordStartTime,1800)
	set eventDateTime=$tr(eventDateTime,"^"," ")
	// 麻醉开始
	do ..AutoCreateEvent(opsId,userId,eventDateTime,"AnaStart","")
	// + 35分钟
	set eventDateTime=##class(CIS.AN.COM.DateTime).DateTimeAdd(recordStartDate,recordStartTime,2100)
	set eventDateTime=$tr(eventDateTime,"^"," ")
	// 插管
	do ..AutoCreateEvent(opsId,userId,eventDateTime,"TubeIn","")
	// + 40分钟
	set eventDateTime=##class(CIS.AN.COM.DateTime).DateTimeAdd(recordStartDate,recordStartTime,2400)
	set eventDateTime=$tr(eventDateTime,"^"," ")
	// 手术开始
	do ..AutoCreateEvent(opsId,userId,eventDateTime,"OperStart","")
	// + 45分钟
	set eventDateTime=##class(CIS.AN.COM.DateTime).DateTimeAdd(recordStartDate,recordStartTime,2700)
	set eventDateTime=$tr(eventDateTime,"^"," ")
	// 血气分析
	//do ..AutoCreateEvent(opsId,userId,eventDateTime,"","659")
	// + 150分钟
	set eventDateTime=##class(CIS.AN.COM.DateTime).DateTimeAdd(recordStartDate,recordStartTime,9000)
	set eventDateTime=$tr(eventDateTime,"^"," ")
	// 手术结束
	do ..AutoCreateEvent(opsId,userId,eventDateTime,"OperEnd","")
	// + 155分钟
	set eventDateTime=##class(CIS.AN.COM.DateTime).DateTimeAdd(recordStartDate,recordStartTime,9300)
	set eventDateTime=$tr(eventDateTime,"^"," ")
	// 拔管
	do ..AutoCreateEvent(opsId,userId,eventDateTime,"TubeOut","")
	quit ""
}

/// Creator：      	雍阳
/// CreatDate：    	2018-09-17
/// Description： 	启动麻醉监护后自动创建术中事件和间断用药的项目
/// Table：        	CIS.AN.OperSchedule
/// Input:			opsId:手术排班表ID
/// Return：       	启动成功返回"S^"，失败返回"E^原因"
/// Debug:			w ##class(CIS.AN.BL.AnaestRecord).AutoCreateParaItem("")
ClassMethod AutoCreateParaItem(opsId As %String) As %String
{
	tstart
	set moduleCode = "AnaestRecord"
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
		set data("Description")="术中事件"
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
/// Debug:			w ##class(CIS.AN.BL.AnaestRecord).AutoCreateEvent("898","10209","2021-07-29 09:43:00","OperRoomOut")
ClassMethod AutoCreateEvent(opsId As %String, userId As %String, dateTime As %String, eventCode As %String = "OperRoomIn", userDefinedItemId As %String = "") As %String
{
	tstart
	set moduleCode = "AnaestRecord"
	set recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCode(opsId,moduleCode,"")
	set paraItemId=$$GetParaItemId(recordSheetId,"OperationEvent")
	set dataItemId=$$GetDataItemId(eventCode)
	
	if (recordSheetId="")||(paraItemId="") || ((dataItemId="")&&(userDefinedItemId=""))
	{
		trollback
		quit "E^数据错误"		
	}
	
	set dataSource="M",rowId=""
	set:dataItemId'="" rowId=$$GetExistedAnaDataId(paraItemId,dataItemId)
	set:userDefinedItemId'="" rowId=$$GetExistedAnaDataIdNew(paraItemId,userDefinedItemId)
	
	if (rowId'="")&&(dataSource'="A")
	{
		trollback
		quit "E^用户已手工改动的数据不再自动修正 paraItem:"_paraItemId_" rowId:"_rowId_" source:"_dataSource_" DataItem:"_dataItemId_" UserDefItem:"_userDefinedItemId	
	}
	
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
	set data("Source")="A"
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
	
GetExistedAnaDataId(paraItemId,dataItemId)
	set result="",dataSource="M"
	&sql(SELECT RowId,Source into :result,:dataSource FROM CIS_AN.AnaData
		WHERE ParaItem=:paraItemId 
		and (DataItem=:dataItemId and DataItem is not NULL))
		
	quit result
	
GetExistedAnaDataIdNew(paraItemId,userDefinedItemId)
	set result="",dataSource="M"
	&sql(SELECT RowId,Source into :result,:dataSource FROM CIS_AN.AnaData
		WHERE ParaItem=:paraItemId 
		and (UserDefinedItem=:userDefinedItemId and UserDefinedItem is not NULL))
		
	quit result
}

/// Creator：      	雍阳
/// CreatDate：    	2018-10-23
/// Description： 	自动生成设备使用记录
/// Table：        	CIS.AN.EquipRecord
/// Input:			opsId：手术计划ID
/// Return：       	启动成功返回"S^"，失败返回"E^原因"
/// Debug:			w ##class(CIS.AN.BL.AnaestRecord).AutoCreateDeviceUsage("9035","7463","2018-11-5 9:30:00")
ClassMethod AutoCreateDeviceUsage(opsId As %String, userId As %String, datetime As %String) As %String
{
	set operSchedule = ##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set operRoom = operSchedule.OperRoom
	quit:operRoom=""
	
	set moduleCode = "AnaestRecord"
	set recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCode(opsId,moduleCode,"")
	
	;set anDeptId = "116"
	set anDeptId=##class(CIS.AN.BL.DataConfiguration).GetValueByKey("ANDEPT")
	set devices=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.ConfigQueries:FindDeptEquipAN",anDeptId,operRoom.%Id(),"")
	
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
/// CreatDate：    	2018-12-04
/// Description： 	开始监护时生成默认值
/// Table：        	CIS.AN.OperSchedule
/// Input:			opsId:手术安排ID
/// Return：       	启动成功返回"S^"，失败返回"E^原因"
/// Debug:			w ##class(CIS.AN.BL.AnaestRecord).GenerateDefaultValue("")
ClassMethod GenerateDefaultValue(opsId As %String) As %String
{
	quit:'##class(CIS.AN.OperSchedule).%ExistsId(opsId) ""
	
	set anaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
	set anaesthesia=##class(CIS.AN.Anaesthesia).%OpenId(anaId)
	//术前禁食默认为是
	set preFasting=anaesthesia.PreFasting
	if preFasting="" set anaesthesia.PreFasting="Y"
	
	do anaesthesia.%Save()
	quit ""
}

/// Creator：      	雍阳
/// CreatDate：    	2018-12-04
/// Description： 	开始监护时自动生成用户偏好数据
/// Table：        	CIS.AN.OperSchedule, CF.AN.UserPreferedData
/// Input:			opsId:手术安排ID
/// Return：       	启动成功返回"S^"，失败返回"E^原因"
/// Debug:			w ##class(CIS.AN.BL.AnaestRecord).AutoGenerateUserPreferedData("7609",6683,"2020-07-06 10:20:00")
ClassMethod AutoGenerateUserPreferedData(opsId As %String, userId As %String, datetime As %String) As %String
{
	set moduleCode = "AnaestRecord"
	set moduleId=##class(CIS.AN.BL.DataModule).GetDataModuleID(moduleCode)
	set recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCode(opsId,moduleCode,"")
	quit:recordSheetId="" "E^无对应表单"
	
	set eventCode="OperationEvent",intrmiDrugCode="OperationDrug" //术中事件和间断用药现在用代码进行对应
	
	set paraItems=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.DataQueries:FindParaItems",recordSheetId)
	set userPreferedDatas = ##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.ConfigQueries:FindUserPreferedData",moduleId,userId)
	set userPreferedDrugs=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.ConfigQueries:FindUserPreferedDrug",moduleId,userId)
	
	set date=$p(datetime," ",1)
	set time=$p(datetime," ",2)
	set date=##class(CIS.AN.COM.DateTime).ConvertToDateH(date)
	set time=##class(CIS.AN.COM.DateTime).ConvertToTimeH(time)
	
	set $zt="Error"
	tstart
	
	set saveResult="None"
	
	for i=1:1:(userPreferedDatas.Size)
	{
		set userPreferedData=userPreferedDatas.GetAt(i)
		quit:userPreferedData=""
		
		continue:userPreferedData.GetValue("AutoGenerate")'="Y" //不自动生成的不处理
		
		set GenerateTimeSpan = +userPreferedData.GetValue("GenerateTimeSpan")
		set startDateTime=##class(CIS.AN.COM.DateTime).DateTimeAdd(date,time,GenerateTimeSpan*60)
		set startDate=$p(startDateTime,"^",1)
		set startTime=$p(startDateTime,"^",2)
		set endDate=startDate
		set endTime=startTime
	
		set userPreferedDataRowId = userPreferedData.GetValue("RowId")
		//write "userPreferedData:",userPreferedDataRowId
		
		set existedAnaDataId=""
		set existedLogRowId = $o(^CT.AN.UserPrefDataALogI("Data",recordSheetId,userPreferedDataRowId,""))
		if existedLogRowId'="" 
		{
			//write "  log:",existedLogRowId,"  anaData:"
			set log = ##class(CT.AN.UserPreferedDataAutoLog).%OpenId(existedLogRowId)
			continue:log.AnaData.EditFlag="D" //已删除（用户已修改）的数据将不再继续自动校对
			set existedAnaDataId = log.AnaData.%Id()
			//write existedAnaDataId,!
		}
		
		break //before create or update
		if existedAnaDataId'=""  //修改对应数据的开始结束时间
		{
			break //before update
			kill anaData
			set anaData("ClassName")="CIS.AN.AnaData"
			set anaData("RowId")=existedAnaDataId
			set anaData("StartDate")=startDate
			set anaData("StartTime")=startTime
			set anaData("EndDate")=endDate
			set anaData("EndTime")=endTime
			set saveResult=##class(CIS.AN.COM.DataService).SaveData(.anaData)
			quit:($piece(saveResult,"^",1)'="S")
			break //after update
		}
		else  // 新生成数据
		{
			break //before create
			set categoryItem=userPreferedData.GetValue("CategoryItem")
			set type=userPreferedData.GetValue("Type")
			set userDefinedItem=userPreferedData.GetValue("UserDefinedItem")
			set code=""
		
			if type="E" set code=eventCode
			else  if type="I" set code=intrmiDrugCode
		
			set paraItemId=$$GetParaItem(code)
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
			set anaData("Source")="A"
			set anaData("Continuous")=userPreferedData.GetValue("Continuous")
		
			set saveResult=##class(CIS.AN.COM.DataService).SaveData(.anaData)
			quit:($piece(saveResult,"^",1)'="S")
			set anaDataRowId=$p(saveResult,"^",2)
			
			break //after create
		
			// 保存用户偏好数据自动生成记录，用于自动校对(修改开始时间后自动校对到最新的开始时间)
			kill logData
			set logData("ClassName")="CT.AN.UserPreferedDataAutoLog"
			set logData("RecordSheet")=recordSheetId
			set logData("UserPreferedData")=userPreferedDataRowId
			set logData("AnaData")=anaDataRowId
			set saveResult=##class(CIS.AN.COM.DataService).SaveData(.logData)
			quit:($piece(saveResult,"^",1)'="S")
			break //after save autolog
		
			// 保存用户偏好数据中对应的药品数据
			for j=1:1:(userPreferedDrugs.Size)
			{
				set userPreferedDrug=userPreferedDrugs.GetAt(j)
				quit:userPreferedDrug=""
			
				set drugDataRowId=userPreferedDrug.GetValue("UserPreferedData")
				continue:drugDataRowId'=userPreferedDataRowId
		
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
				set drugData("TCI")=userPreferedDrug.GetValue("TCI")
			
				set saveResult=##class(CIS.AN.COM.DataService).SaveData(.drugData)
				quit:($piece(saveResult,"^",1)'="S")
			}
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
	
GetParaItem(code)
	set foundParaItem=1
	for j=1:1:(paraItems.Size)
	{
		set paraItem = paraItems.GetAt(j)
		quit:paraItem=""
		
		set paraItemCode=paraItem.GetValue("Code")
		if ((code'="")&&(paraItemCode=code))
		{
			set foundParaItem = paraItem.GetValue("RowId")
			quit
		}
	}
	
	quit foundParaItem
}

/// Creator：      	雍阳
/// CreatDate：    	2018-12-04
/// Description： 	平移事件和用药数据
/// Table：        	CIS.AN.OperSchedule, CF.AN.UserPreferedData
/// Input:			opsId:手术安排ID
/// Return：       	启动成功返回"S^"，失败返回"E^原因"
/// Debug:			w ##class(CIS.AN.BL.AnaestRecord).TranslateData("7754",1800)
ClassMethod TranslateData(opsId As %String, timeSpan As %Integer) As %String
{
	set moduleCode = "AnaestRecord"
	set recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCode(opsId,moduleCode,"")
	quit:recordSheetId="" "E^无对应表单"
	
	set saveResult="S^"
	set anaDatas = ##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.AnaestRecord:FindAnaDatas",recordSheetId,"N")
	
	tstart
	set startDate="",startTime="",endDate="",endTime=""
	for i=1:1:anaDatas.Size
	{
		set anaData=anaDatas.GetAt(i)
		quit:anaData=""
		
		continue:(anaData.GetValue("ItemCategory")="V")&&(anaData.GetValue("Continuous")'="Y") //生命体征且非持续的数据不修改
		//continue:(anaData.GetValue("Source")="A") //为自动生成的数据自动修改，不进行自动调整
		
		set rowId=anaData.GetValue("RowId")
		set data=##class(CIS.AN.AnaData).%OpenId(rowId)
		
		set startDate=data.StartDate
		set startTime=data.StartTime
		set startDateTime=##class(CIS.AN.COM.DateTime).DateTimeAdd(startDate,startTime,timeSpan)
		set startDate=$p(startDateTime,"^",1)
		set startTime=$p(startDateTime,"^",2)
		set data.StartDate=startDate
		set data.StartTime=startTime
		
		set endDate=data.EndDate
		set endTime=data.EndTime
		if (endDate'="")&&(endDate<2900000)
		{
			set endDateTime=##class(CIS.AN.COM.DateTime).DateTimeAdd(endDate,endTime,timeSpan)
			set endDate=$p(endDateTime,"^",1)
			set endTime=$p(endDateTime,"^",2)
			set data.EndDate=endDate
			set data.EndTime=endTime
		}
		
		do data.%Save()
	}
	
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult	
	}
	
	tcommit
	
	quit "S^"
}

/// Creator：      	雍阳
/// CreatDate：    	2018-12-04
/// Description： 	删除小于开始时间的生命体征数据
/// Table：        	CIS.AN.OperSchedule, CF.AN.UserPreferedData
/// Input:			opsId:手术安排ID
/// Return：       	启动成功返回"S^"，失败返回"E^原因"
/// Debug:			w ##class(CIS.AN.BL.AnaestRecord).RemoveOutrangedData("7754","2018-10-16 10:30:00")
ClassMethod RemoveOutrangedData(opsId As %String, theatreInDT As %String) As %String
{
	set moduleCode = "AnaestRecord"
	set recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCode(opsId,moduleCode,"")
	quit:recordSheetId="" "E^无对应表单"
	
	set saveResult="S^"
	set anaDatas = ##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.AnaestRecord:FindAnaDatas",recordSheetId,"N")
	
	tstart
	
	set startDate="",startTime="",endDate="",endTime=""
	for i=1:1:anaDatas.Size
	{
		set anaData=anaDatas.GetAt(i)
		quit:anaData=""
		
		//只删除采集的生命体征数据
		continue:(anaData.GetValue("ItemCategory")'="V")
		continue:(anaData.GetValue("Continuous")="Y")
		continue:(anaData.GetValue("Source")="M")
		
		set rowId=anaData.GetValue("RowId")
		set startDate=anaData.GetValue("StartDate")
		set startTime=anaData.GetValue("StartTime")
		set startDateTime=startDate_" "_startTime
		set compareResult=##class(CIS.AN.COM.DateTime).CompareDateTimeS(theatreInDT,startDateTime)
		if compareResult>0
		{
			set saveResult=##class(CIS.AN.COM.DataService).DelData("CIS.AN.AnaData",rowId)
		}
	}
	
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult	
	}
	
	tcommit
	
	quit "S^"
}

/// Creator：      	雍阳
/// CreatDate：    	2018-08-03
/// Description： 	停止麻醉监护
/// Table：        	CIS.AN.OperSchedule
/// Input:			data:停止监护参数
/// Return：       	启动成功返回"S^"，失败返回"E^原因"
/// Debug:			w ##class(CIS.AN.BL.AnaestRecord).StopRecord("^TMPAN("Debug","StopRecord","Param")")
ClassMethod StopRecord(data As %String) As %String
{
	set ^TMPAN("Debug","StopRecord","Param")=data
	tstart
	set result="",saveResult=""
	set status=##class(CIS.AN.COM.String).ToArray(data,.array)
	kill schedule,anaesthesia,evaluation,PLIST
	
	merge PLIST = array(1)
	
	set anaesthesia("ClassName")="CIS.AN.Anaesthesia"
	set schedule("ClassName")="CIS.AN.OperSchedule"
	set evaluation("ClassName")="CIS.AN.AnaestEvaluation"
	
	set schedule("RowId")=PLIST("RowId")
	set schedule("StatusCode")=PLIST("StatusCode")
	set schedule("UpdateUser")=PLIST("UpdateUser")

	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId($get(PLIST("RowId")))
	if (operSchedule.Status.Code="Stop") set schedule("StatusCode")="Stop" ///停止的手术结束时不修改为术毕？
			
	if ($g(PLIST("TheatreOutTransLoc"))'="PACU") set schedule("StatusCode")="Finish" ///离室去向非PACU直接置为完成
			
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
	set anaesthesia("TheatreOutDT")=PLIST("TheatreOutDT")
	set anaesthesia("TheatreOutTransLoc")=PLIST("TheatreOutTransLoc")

	set saveResult=##class(CIS.AN.COM.DataService).SaveData(.anaesthesia)
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult		
	}
	
	set rowId = $o(^CIS.AN.AnaestEvaluationI("IOPS",PLIST("RowId"),""))
	set evaluation("RowId")=rowId
	set evaluation("OperSchedule")=PLIST("RowId")
	set evaluation("GeneralAnInduction")=PLIST("GeneralAnInduction")
	set evaluation("GeneralAnMaintain")=PLIST("GeneralAnMaintain")
	set evaluation("GeneralAnEnding")=PLIST("GeneralAnEnding")
	set evaluation("IntraspinalAn")=PLIST("IntraspinalAn")
	set evaluation("NerveBlock")=PLIST("NerveBlock")
	set evaluation("Complication")=PLIST("Complication")
	set evaluation("EvaluateUser")=PLIST("UpdateUser")

	set evaluation("EvaluateDate")=+$h
	set evaluation("EvaluateTime")=$p($h,",",2)
		
	set saveResult=##class(CIS.AN.COM.DataService).SaveData(.evaluation)
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult
	}
	
	/// 写入手术操作过程 CCQ 20200225
	set saveResult=##class(CIS.AN.BL.SurgicalProcedure).SaveProcedureAfterStop(PLIST("RowId"),"RO",PLIST("UpdateUser"),PLIST("TheatreOutDT"))
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult		
	}
	
	tcommit
	set opsId=PLIST("RowId")
	
	do ..StopAllContinuousData(PLIST("RowId"),PLIST("TheatreOutDT"))
	do ..StopAllDeviceUsage(PLIST("RowId"),PLIST("TheatreOutDT"))
	do ..AutoCreateEvent(PLIST("RowId"),PLIST("UpdateUser"),PLIST("TheatreOutDT"),"OperRoomOut")
	do ..SyncEventTime(PLIST("RowId"))
	do ..SubmitRecord(PLIST("RowId"),PLIST("UpdateUser"))
	do ..TriggerEvent(PLIST("RowId"),"RoomIn","RoomOut")
	
	do ..AfterStopRecord(opsId)
	quit "S^"
}

ClassMethod AfterStopRecord(opsId) As %Status
{
	try
	{
		// 回写旧表
		set saveResult=##class(CIS.AN.SRV.OperAppService).StopANRecord(opsId,"")
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
/// Debug:			w ##class(CIS.AN.BL.AnaestRecord).StopRecord("")
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
/// Debug:			w ##class(CIS.AN.BL.AnaestRecord).StopAllContinuousData("7","2018-09-25 11:00")
ClassMethod StopAllContinuousData(opsId, dateTime) As %String
{
	set moduleCode="AnaestRecord"
	set recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCode(opsId,moduleCode,"")
	
	set date=$p(dateTime," ",1)
	set time=$p(dateTime," ",2)
	
	kill data
	set data("ClassName")="CIS.AN.AnaData"
	
	set continuousDataList=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.AnaestRecord:FindContinuousData",recordSheetId)
	set continuousData=""
	for i=1:1:(continuousDataList.Size)
	{
		set continuousData=continuousDataList.GetAt(i)
		quit:continuousData=""
		
		set rowId=continuousData.GetValue("RowId")
		set endDate=continuousData.GetValue("EndDate")
		set endTime=continuousData.GetValue("EndTime")
		if (endDate>=2980000)||(endDate="")
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
/// Debug:			w ##class(CIS.AN.BL.AnaestRecord).StopAllDeviceUsage("7","2018-09-25 11:00")
ClassMethod StopAllDeviceUsage(opsId, dateTime) As %String
{
	set moduleCode="AnaestRecord"
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

/// Creator：      	雍阳
/// CreatDate：    	2018-12-28
/// Description： 	撤销监护
/// Table：        	CIS.AN.OperSchedule
/// Input:			data:停止监护参数
/// Return：       	启动成功返回"S^"，失败返回"E^原因"
/// Debug:			w ##class(CIS.AN.BL.AnaestRecord).RevokeRecord("")
ClassMethod RevokeRecord(opsId As %String, userId As %String) As %String
{
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术申请记录不存在。"
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	quit:(operSchedule.Status.Code'="RoomIn") "E^该手术不是术中状态，不能撤销监护"
	set arrangeStatusId=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode("Arrange")
	quit:(##class(CT.AN.OperStatus).%ExistsId(arrangeStatusId)=0) "E^安排状态不存在"
	
	set anaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
	quit:anaId="" "E^麻醉数据表记录不存在"
	set anaesthesia=##class(CIS.AN.Anaesthesia).%OpenId(anaId)
	
	tstart
	set operSchedule.Status=##class(CT.AN.OperStatus).%OpenId(arrangeStatusId)
	set sc=operSchedule.%Save()
	if ($System.Status.IsError(sc))
	{
		trollback
		quit "E^"_$System.Status.GetErrorText(sc)
	}
	
	set anaesthesia.RevokeUser=userId
	set anaesthesia.RevokeDate=+$h
	set anaesthesia.RevokeTime=+$p($h,",",2)
	set sc=anaesthesia.%Save()
	if ($System.Status.IsError(sc))
	{
		trollback
		quit "E^"_$System.Status.GetErrorText(sc)
	}
	tcommit
	
	do ..ClearParaItem(opsId)
	do ..ClearDeviceUsage(opsId)
	do ..ClearKeyEventTime(opsId)
	do ..TriggerEvent(opsId,"RoomIn","Arrange")
	
	quit "S^"
}

/// Creator：      	雍阳
/// CreatDate：    	2018-12-28
/// Description： 	撤销监护，清空显示项目
/// Table：        	CIS.AN.OperSchedule
/// Input:			data:停止监护参数
/// Return：       	启动成功返回"S^"，失败返回"E^原因"
/// Debug:			w ##class(CIS.AN.BL.AnaestRecord).ClearParaItem("")
ClassMethod ClearParaItem(opsId As %String) As %String
{
	set moduleCode="AnaestRecord"
	set recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCode(opsId,moduleCode,"")
	
	set paraItems=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.DataQueries:FindParaItems",recordSheetId)
	
	for i=1:1:paraItems.Size
	{
		set paraItem=paraItems.GetAt(i)
		quit:paraItem=""
		
		set paraItemRowId=paraItem.GetValue("RowId")
		do ##class(CIS.AN.COM.DataService).DelData("CIS.AN.ParaItem",paraItemRowId)
	}
	
	quit "S^"
}

/// Creator：      	雍阳
/// CreatDate：    	2018-12-28
/// Description： 	撤销监护，清空设备使用记录
/// Table：        	CIS.AN.OperSchedule
/// Input:			data:停止监护参数
/// Return：       	启动成功返回"S^"，失败返回"E^原因"
/// Debug:			w ##class(CIS.AN.BL.AnaestRecord).ClearDeviceUsage("")
ClassMethod ClearDeviceUsage(opsId As %String) As %String
{
	set moduleCode="AnaestRecord"
	set recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCode(opsId,moduleCode,"")
	
	set ret=..GetEquipUsage(recordSheetId,.deviceUsages)
	
	set rowId=""
	for
	{
		set rowId=$o(deviceUsages(rowId))
		quit:rowId=""
		
		do ##class(CIS.AN.COM.DataService).DelData("CIS.AN.EquipRecord",rowId)
	}
	
	quit "S^"
}

/// Creator：      	雍阳
/// CreatDate：    	2018-12-28
/// Description： 	撤销监护，清空关键事件时间点
/// Table：        	CIS.AN.OperSchedule
/// Input:			data:停止监护参数
/// Return：       	启动成功返回"S^"，失败返回"E^原因"
/// Debug:			w ##class(CIS.AN.BL.AnaestRecord).ClearKeyEventTime("")
ClassMethod ClearKeyEventTime(opsId As %String) As %String
{
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术申请记录不存在。"
	set anaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
	quit:anaId="" "E^麻醉数据表记录不存在"
	
	set anaesthesia=##class(CIS.AN.Anaesthesia).%OpenId(anaId)
	set anaesthesia.TheatreInDT=""
	set anaesthesia.AnaStartDT=""
	set anaesthesia.TubeInDT=""
	set anaesthesia.TubeOutDT=""
	set anaesthesia.AnaFinishDT=""
	set anaesthesia.OperStartDT=""
	set anaesthesia.OperFinishDT=""
	set anaesthesia.TheatreOutDT=""
	
	///清空麻醉单上下表头区域数据   20220127  ygb
	set anaesthesia.ASAClass=""
	set anaesthesia.PreFasting=""
	set anaesthesia.PreOperNote=""
	set anaesthesia.PreMedication=""
	set anaesthesia.ECGDoctor=""
	set sc=anaesthesia.%Save()
	quit:($System.Status.IsError(sc)) "E^"_$System.Status.GetErrorText(sc)
	
	
	///删除交接班数据
	&sql(delete from CIS_AN.OperShift where OperSchedule=:opsId)
	quit "S^"
}

/// Creator：      	yongyang
/// CreatDate：    	2020-10-11
/// Description： 	查询麻醉记录数据,通过类型区分
/// Table：        	CIS.AN.AnaData
/// Input:			sheetId:手术表单ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.AnaestRecord","FindAnaDatasByType","1344","E")
Query FindAnaDatasByType(sheetId As %String, type As %String = "E") As %SQLQuery(CONTAINID = 1) [ SqlProc ]
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
	   ParaItem->CategoryItem As CategoryItem,
	   DataItem As DataItem,
	   DataItem->Code As DataItemCode,
	   DataItem->Description As DataItemDesc,
	   DataItem->ItemCategory As ItemCategory,
	   UserDefinedItem,
	   UserDefinedItem->Description As UserDefinedItemDesc,
	   CIS_AN_COM.String_AlterDesc(DataItem->Description,UserDefinedItem->Description) As DataItemDesc,
	   CIS_AN_COM.String_AlterDesc(DataItem->ItemCategory,UserDefinedItem->ItemCategory) As ItemCategory,
	   ParaItem->DataCategory As DataCategory,
	   ParaItem->Description As ParaItemDesc,
	   Source,
	   ChargeDetail->ChargeRecord As ChargeRecord
	   from CIS_AN.AnaData 
       where ParaItem->RecordSheet=:sheetId
       and EditFlag='N'
       and (DataItem->ItemCategory=:type or :type is null)
       order by StartDate,StartTime
}

/// Creator：      	陈长青
/// CreatDate：    	2017-10-11
/// Description： 	查询麻醉记录数据
/// Table：        	DHCAN.RecordData
/// Input:			opsId:手术计划ID
/// Return：       	ResultSet
/// w ##class(%ResultSet).RunQuery("CIS.AN.BL.AnaestRecord","FindSheetRecords","4173","N")
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
	   ParaItem->CategoryItem As CategoryItem,
	   DataItem As DataItem,
	   DataItem->Code As DataItemCode,
	   DataItem->Description As DataItemDesc,
	   DataItem->ItemCategory As ItemCategory,
	   UserDefinedItem,
	   UserDefinedItem->Description As UserDefinedItemDesc,
	   CIS_AN_COM.String_AlterDesc(DataItem->Description,UserDefinedItem->Description) As DataItemDesc,
	   CIS_AN_COM.String_AlterDesc(DataItem->ItemCategory,UserDefinedItem->ItemCategory) As ItemCategory,
	   ParaItem->DataCategory As DataCategory,
	   ParaItem->Description As ParaItemDesc,
	   Source,
	   CIS_AN_BL.AnaestRecord_CalcSumQty(RowId) As SumQty,
	   CIS_AN_BL.AnaestRecord_GetSumUom(RowId) As SumUom,
	   CIS_AN_BL.AnaestRecord_AbnormalVitalSign(RowId) As AbnormalVitalSign,
	   SignDoctor,
	   SignNurse,
	   CIS_AN_COM.String_GetDescByID('User.CTCareProv','CTPCPDesc',SignDoctor,'Y') As SignDoctorDesc,
	   CIS_AN_COM.String_GetDescByID('User.CTCareProv','CTPCPDesc',SignNurse,'Y') As SignNurseDesc
	   from CIS_AN.AnaData 
       where ParaItem->RecordSheet=:sheetId
       and (EditFlag=:editFlag or :editFlag is null)
       and CIS_AN_BL.AnaestRecord_VitalSignVisible(ParaItem->RecordSheet->OperSchedule,ParaItem->RecordSheet,StartDate,StartTime,DataItem->Code)='Y'
       order by StartDate,StartTime
}

/// Creator：      	雍阳
/// CreatDate：    	2020-10-12
/// Description： 	根据事件数据隐藏生命体征
/// Table：        	CIS_AN.AnaData
/// Input:			recordSheetId:表单ID
/// Return：       	Y/N
/// w ##class(CIS.AN.BL.AnaestRecord).VitalSignVisible(490,1256,65628,74100,"ControlResp")
ClassMethod VitalSignVisible(opsId, recordSheetId, startDate, startTime, dataItemCode) As %String [ SqlProc ]
{
	
	// 这里的Code根据项目情况自行修改
	set NSBPItemCode="NSBP"
	set NDBPItemCode="NDBP"
	set ASBPItemCode="ASBP"
	set ADBPItemCode="ADBP"
	
	set RespItemCode="Respiration"
	set ControlRespItemCode="ControlResp"
	
	set itemCodeList=$lb(NSBPItemCode,NDBPItemCode,ASBPItemCode,ADBPItemCode,RespItemCode,ControlRespItemCode)
	
	if '$ListFind(itemCodeList,dataItemCode) quit "Y"
	
	// 这里的Code根据项目情况自行修改
	set StartABPItemCode="MeasureInvasiveBP"  //开始测有创血压，不显示无创，仅显示有创
	set EndABPItemCode="MeasureBP" //结束测有创血压，不显示有创，仅显示无创
	set StartVentilationItemCode="MechanicalVentilation" //开始机控呼吸，不显示自主，仅显示机控
	set EndVentilationItemCode="TubeOut" //结束机控呼吸，不显示机控，仅显示自主
	
	set controlItemCodeList=$lb(StartABPItemCode,EndABPItemCode,StartVentilationItemCode,EndVentilationItemCode)
	set timeMark=(+$h)_","_((+$p($h,",",2)\5)*5)
	if '$d(^TMPAN("AnaestRecord",opsId,recordSheetId,timeMark,"EventParaItem"))
	{
		kill ^TMPAN("AnaestRecord",opsId,recordSheetId)
		set EventParaItemCode="OperationEvent"
		set paraItemId=""
		for
		{
			set paraItemId=$o(^CIS.AN.ParaItemI("ISheet",recordSheetId,paraItemId))
			quit:paraItemId=""
		
			set paraItem=##class(CIS.AN.ParaItem).%OpenId(paraItemId)
			set code=paraItem.Code
			quit:code=EventParaItemCode
		}
	
		set ^TMPAN("AnaestRecord",opsId,recordSheetId,timeMark,"EventParaItem")=paraItemId
		
		kill countList
		if paraItemId'=""
		{
			set rowId=""
			for
			{
				set rowId=$o(^CIS.AN.AnaDataI("IParaItem",paraItemId,rowId))
				quit:rowId=""
			
				set anaData=##class(CIS.AN.AnaData).%OpenId(rowId)
				continue:anaData.EditFlag'="N"
			
				set code=""
				set:$IsObject(anaData.DataItem) code=anaData.DataItem.Code
				continue:'$ListFind(controlItemCodeList,code)
			
				set date=anaData.StartDate
				set time=anaData.StartTime
				set type=$s((code=StartABPItemCode)||(code=EndABPItemCode):"ABP",
							(code=StartVentilationItemCode)||(code=EndVentilationItemCode):"ControlResp",
							1:"ABP")
				set flag=$s((code=StartABPItemCode)||(code=StartVentilationItemCode):"Start",
							(code=EndABPItemCode)||(code=EndVentilationItemCode):"End",
							1:"Start")
				set countList(flag)=$g(countList(flag))+1
				set ^TMPAN("AnaestRecord",opsId,recordSheetId,timeMark,type,flag,date,time)=countList(flag)
			}
		}
	}
	
	set result="Y"
	
	if (dataItemCode=ASBPItemCode)||(dataItemCode=ADBPItemCode)
	{
		set date=startDate
		set time=""
		set startIndex=""
		set time=$o(^TMPAN("AnaestRecord",opsId,recordSheetId,timeMark,"ABP","Start",date,startTime),-1)
		if time=""
		{
			set date=date-1
			set time=$o(^TMPAN("AnaestRecord",opsId,recordSheetId,timeMark,"ABP","Start",date,""),-1)
		}
		set:time'="" startIndex=^TMPAN("AnaestRecord",opsId,recordSheetId,timeMark,"ABP","Start",date,time)
		
		set eventEndIndex=""
		if time'="" 
		{
			set eventStartDate=date,eventStartTime=time
			set date=eventStartDate
			set time=""
			set eventEndIndex=""
			set time=$o(^TMPAN("AnaestRecord",opsId,recordSheetId,timeMark,"ABP","End",date,eventStartTime))
			if time=""
			{
				set date=date+1
				set time=$o(^TMPAN("AnaestRecord",opsId,recordSheetId,timeMark,"ABP","End",date,""))
			}
			set:time'="" eventEndIndex=^TMPAN("AnaestRecord",opsId,recordSheetId,timeMark,"ABP","End",date,time)
		}
		
		set date=startDate
		set time=""
		set endIndex=""
		set time=$o(^TMPAN("AnaestRecord",opsId,recordSheetId,timeMark,"ABP","End",date,startTime))
		if time=""
		{
			set date=date+1
			set time=$o(^TMPAN("AnaestRecord",opsId,recordSheetId,timeMark,"ABP","End",date,""))
		}
		set:time'="" endIndex=^TMPAN("AnaestRecord",opsId,recordSheetId,timeMark,"ABP","End",date,time)
		
		if (startIndex'="")&&((startIndex=endIndex)||(endIndex=eventEndIndex)) set result="Y"
		else  set result="N"
	}
	
	if (dataItemCode=NSBPItemCode)||(dataItemCode=NDBPItemCode)
	{
		set date=startDate
		set time=""
		set startIndex=""
		set time=$o(^TMPAN("AnaestRecord",opsId,recordSheetId,timeMark,"ABP","Start",date,startTime),-1)
		if time=""
		{
			set date=date-1
			set time=$o(^TMPAN("AnaestRecord",opsId,recordSheetId,timeMark,"ABP","Start",date,""),-1)
		}
		set:time'="" startIndex=^TMPAN("AnaestRecord",opsId,recordSheetId,timeMark,"ABP","Start",date,time)
		
		set date=startDate
		set time=""
		set endIndex=""
		set time=$o(^TMPAN("AnaestRecord",opsId,recordSheetId,timeMark,"ABP","End",date,startTime),-1)
		if time=""
		{
			set date=date-1
			set time=$o(^TMPAN("AnaestRecord",opsId,recordSheetId,timeMark,"ABP","End",date,""),-1)
		}
		set:time'="" endIndex=^TMPAN("AnaestRecord",opsId,recordSheetId,timeMark,"ABP","End",date,time)
		
		if startIndex=endIndex set result="Y"
		else  set result="N"
	}
	
	if (dataItemCode=ControlRespItemCode)
	{
		set date=startDate
		set time=""
		set startIndex=""
		set time=$o(^TMPAN("AnaestRecord",opsId,recordSheetId,timeMark,"ControlResp","Start",date,startTime + 1),-1)
		if time=""
		{
			set date=date-1
			set time=$o(^TMPAN("AnaestRecord",opsId,recordSheetId,timeMark,"ControlResp","Start",date,""),-1)
		}
		set:time'="" startIndex=^TMPAN("AnaestRecord",opsId,recordSheetId,timeMark,"ControlResp","Start",date,time)
		
		set eventEndIndex=""
		if time'="" 
		{
			set eventStartDate=date,eventStartTime=time
			set date=eventStartDate
			set time=""
			set eventEndIndex=""
			set time=$o(^TMPAN("AnaestRecord",opsId,recordSheetId,timeMark,"ControlResp","End",date,eventStartTime))
			if time=""
			{
				set date=date+1
				set time=$o(^TMPAN("AnaestRecord",opsId,recordSheetId,timeMark,"ControlResp","End",date,""))
			}
			set:time'="" eventEndIndex=^TMPAN("AnaestRecord",opsId,recordSheetId,timeMark,"ControlResp","End",date,time)
		}
		
		set date=startDate
		set time=""
		set endIndex=""
		set time=$o(^TMPAN("AnaestRecord",opsId,recordSheetId,timeMark,"ControlResp","End",date,startTime - 1))
		if time=""
		{
			set date=date+1
			set time=$o(^TMPAN("AnaestRecord",opsId,recordSheetId,timeMark,"ControlResp","End",date,""))
		}
		set:time'="" endIndex=^TMPAN("AnaestRecord",opsId,recordSheetId,timeMark,"ControlResp","End",date,time)
		
		if (startIndex'="")&&((startIndex=endIndex)||(endIndex=eventEndIndex)) set result="Y"
		else  set result="N"
	}
	
	if (dataItemCode=RespItemCode)
	{
		set date=startDate
		set time=""
		set startIndex=""
		set time=$o(^TMPAN("AnaestRecord",opsId,recordSheetId,timeMark,"ControlResp","Start",date,startTime),-1)
		if time=""
		{
			set date=date-1
			set time=$o(^TMPAN("AnaestRecord",opsId,recordSheetId,timeMark,"ControlResp","Start",date,""),-1)
		}
		set:time'="" startIndex=^TMPAN("AnaestRecord",opsId,recordSheetId,timeMark,"ControlResp","Start",date,time)
		
		set date=startDate
		set time=""
		set endIndex=""
		set time=$o(^TMPAN("AnaestRecord",opsId,recordSheetId,timeMark,"ControlResp","End",date,startTime),-1)
		if time=""
		{
			set date=date-1
			set time=$o(^TMPAN("AnaestRecord",opsId,recordSheetId,timeMark,"ControlResp","End",date,""),-1)
		}
		set:time'="" endIndex=^TMPAN("AnaestRecord",opsId,recordSheetId,timeMark,"ControlResp","End",date,time)
		
		if startIndex=endIndex set result="Y"
		else  set result="N"
	}
	
	quit result
}

/// Creator：      	雍阳
/// CreatDate：    	2018-9-25
/// Description： 	查询所有连续数据
/// Table：        	CIS_AN.AnaData
/// Input:			recordSheetId:表单ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.AnaestRecord","FindContinuousData",3518)
Query FindContinuousData(recordSheetId As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT *
	from CIS_AN.AnaData
	where ParaItem->RecordSheet=:recordSheetId
	and ((not EndDate=StartDate) or (not EndTime=StartTime) or (EndDate is null))
	and EditFlag="N"
}

/// Creator：      	陈长青
/// CreatDate：    	2017-11-7
/// Description： 	查询麻醉记录数据
/// Table：        	DHCAN.DrugData
/// Input:			opsId:手术计划ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.AnaestRecord","FindDrugDatas","1","N")
Query FindDrugDatas(sheetId As %String, editflag As %String = "", categoryCode As %String = "") As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT *,
	   CIS_AN_COM.String_PatchFloat(DoseQty) As DoseQty,
	   CIS_AN_COM.String_PatchFloat(Speed) As Speed,
	   CIS_AN_COM.String_PatchFloat(Concentration) As Concentration,
	   DoseUnit->Description As DoseUnitDesc,
	   SpeedUnit->Description As SpeedUnitDesc,
	   ConcentrationUnit->Description As ConcentrationUnitDesc,
	   CIS_AN_COM.String_GetDescByID("CT.AN.Instruction","Description",Instruction) As InstructionDesc,
	   CIS_AN_COM.String_GetDescByID("User.ARCItmMast","ARCIMDesc",ArcimID) As ArcimDesc,
	   CIS_AN_COM.String_GetDescByID("User.CTLoc","CTLOCDesc",RecvLoc) As RecvLocDesc,
	   AnaData->ParaItem->CategoryItem->DataCategory->Code As CategoryCode,
	   AnaData->ParaItem->DataCategory->Code As MainCategoryCode,
	   AnaData->Continuous As Continuous,
	   %ODBCOUT(AnaData->StartDate)_' '_%ODBCOUT(AnaData->StartTime) As StartDT,
	   %ODBCOUT(AnaData->EndDate)_' '_%ODBCOUT(AnaData->EndTime) As EndDT,
	   ChargeDetail->ChargeRecord As ChargeRecord
	   from CIS_AN.DrugData 
       where AnaData->ParaItem->RecordSheet=:sheetId
       and (AnaData->EditFlag=:editflag or :editflag is null)
       and (:categoryCode is null or AnaData->ParaItem->CategoryItem->DataCategory->Code=:categoryCode or AnaData->ParaItem->DataCategory->Code=:categoryCode)
}

/// w ##class(CIS.AN.BL.AnaestRecord).AbnormalVitalSign("348")
ClassMethod AbnormalVitalSign(anaDataId As %String) As %String [ SqlProc ]
{
	set ret=""
	if (##class(CIS.AN.AnaData).%ExistsId(anaDataId))
	{
		set anaData=##class(CIS.AN.AnaData).%OpenId(anaDataId)
		set dataValue=anaData.DataValue
		if $IsObject(anaData.DataItem)
		{
			set dataItemId=anaData.DataItem.%Id()
			set itemCategory=anaData.DataItem.ItemCategory
			if itemCategory="V"
			{
				set WarningMax="",WarningMin=""
				&sql(select WarningMin,WarningMax into :WarningMin,:WarningMax from CT_AN.VitalSign where DataItem=:dataItemId)
				if 'SQLCODE
				{
					//w "Min ",WarningMin,"   Max ",WarningMax,"  value ",dataValue,!
					if (WarningMin'="")&&(dataValue<WarningMin) set ret=1
					if (WarningMax'="")&&(dataValue>WarningMax) set ret=1
				}
			}
		}
	}
	
	quit ret
}

/// w ##class(CIS.AN.BL.AnaestRecord).CalcSumQty("7247")
ClassMethod CalcSumQty(anDataId As %String) As %String [ SqlProc ]
{
	set ret=""
	if (##class(CIS.AN.AnaData).%ExistsId(anDataId))
	{
		set anData=##class(CIS.AN.AnaData).%OpenId(anDataId)
		set drugDataId=""
		&sql(select RowId into :drugDataId from CIS_AN.drugdata where AnaData=:anDataId)
		if (##class(CIS.AN.DrugData).%ExistsId(drugDataId))
		{
			set drugData=##class(CIS.AN.DrugData).%OpenId(drugDataId)
			set speed=+drugData.Speed,speedUom=drugData.SpeedUnit
			if (speed>0)&(speedUom'="")
			{
				set ret=..CalcSpeedSumQty(anData,drugData)
			
				
			}
			elseif (+drugData.DoseQty>0)
			{
				set ret=drugData.DoseQty	
			}	
		}	
		else
		{
			set ret=anData.DataValue	
		}
	}
	
	quit ret
}

ClassMethod CalcSpeedSumQty(anaData As CIS.AN.AnaData, drugData As CIS.AN.DrugData) As %String
{
	set speedUnitId=drugData.SpeedUnit.%Id(),speedUomId="",ret="",speed=+drugData.Speed
	set concentrationUnitId="",concentrationUomId=""
	if $IsObject(drugData.ConcentrationUnit) set concentrationUnitId=drugData.ConcentrationUnit.%Id()
	set patWeight=+anaData.ParaItem.RecordSheet.OperSchedule.PatWeight
	set today=+$h,now=$p($h,",",2),endDate=anaData.EndDate,endTime=anaData.EndTime
	if (endDate>(anaData.StartDate+3))
	{
		set endDate=anaData.StartDate+3
		if (endDate>today)
		{
			set endDate=today,endTime=now	
		}	
	}
	
	set totalMin=##class(CIS.AN.COM.DateTime).CalculateDuration(anaData.StartDate,anaData.StartTime,endDate,endTime,"M")
	set timeMinUomId=""
	
	&sql(select RowId into :timeMinUomId from ct_an.uom where Code="MINUTE")
	&sql(select RowId into :speedUomId from ct_an.speeduom where uom=:speedUnitId)
	&sql(select RowId into :concentrationUomId from ct_an.concentrationuom where uom=:concentrationUnitId)
	if (##class(CT.AN.SpeedUom).%ExistsId(speedUomId))
	{
		set speedUom=##class(CT.AN.SpeedUom).%OpenId(speedUomId)
		set timeUomId=""
		set:(speedUom.TimeUom'="") timeUomId=speedUom.TimeUom.%Id()
		set uomConversionId=""
		set factor=1
		if timeMinUomId=timeUomId 
		{
			set factor=1
		}
		else
		{
			&sql(select RowId into :uomConversionId from ct_an.uomconversion where target=:timeUomId and source=:timeMinUomId)
			if (SQLCODE=0)&&(##class(CT.AN.UomConversion).%ExistsId(uomConversionId)){
				set uomConversion=##class(CT.AN.UomConversion).%OpenId(uomConversionId)
				set factor=+uomConversion.Factor
			}
		}
		set:(speedUom.WeightUom="") patWeight=1
		set:(patWeight=0) patWeight=1
		set ret=(speed*totalMin*patWeight)*factor
		if (##class(CT.AN.ConcentrationUom).%ExistsId(concentrationUomId))
		{
			set concentrationUom=##class(CT.AN.ConcentrationUom).%OpenId(concentrationUomId)
			if (concentrationUom.SolventUom.%Id()=speedUom.DoseUom.%Id()) && (drugData.Concentration>0)
			{
				set ret=ret*drugData.Concentration
			}
		}
	}
	quit ret
}

/// w ##class(CIS.AN.BL.AnaestRecord).GetSumUom("7247")
ClassMethod GetSumUom(anaDataId) As %String [ SqlProc ]
{
	set doseUom=""
	set drugDataId=$O(^CIS.AN.DrugDataI("IAnaData",anaDataId,""))
	if (##class(CIS.AN.DrugData).%ExistsId(drugDataId))
	{	
		set drugData=##class(CIS.AN.DrugData).%OpenId(drugDataId)
		if drugData.SpeedUnit'=""
		{
			set speedUom=drugData.SpeedUnit.%Id()
			
			set speedUomLinkId=$o(^CT.AN.SpeedUomI("IUom",speedUom,""))
			if speedUomLinkId'="" 
			{
				set speedUomLinkDoseUomId=$lg(^CT.AN.SpeedUomD(speedUomLinkId),2)
				set doseUom=$lg(^CT.AN.UomD(speedUomLinkDoseUomId),2)
			}
		
			set concentrationUnitId=""
			if ($IsObject(drugData.ConcentrationUnit)) && drugData.Concentration>0
			{
				set concentrationUnitId=drugData.ConcentrationUnit.%Id()
			}
			
			if (concentrationUnitId'="")
			{
				set concentrationUomId=$o(^CT.AN.ConcentrationUomI("IUom",concentrationUnitId,""))
				if concentrationUomId'=""
				{
					set concentrationUom=##class(CT.AN.ConcentrationUom).%OpenId(concentrationUomId)
					if (concentrationUom.SolventUom.%Id()=speedUomLinkDoseUomId) && (drugData.Concentration>0)
					{
						set doseUom=concentrationUom.SoluteUom.Description
					}
				}
			}
		}
		elseif drugData.DoseUnit'=""
		{
			set doseUom=drugData.DoseUnit.Description
		}
	}
	
	quit doseUom
}

/// Creator：      	陈长青
/// CreatDate：    	2017-10-11
/// Description： 	保存麻醉记录数据
/// Table：        	DHCAN.RecordData
/// Input:			opsId:手术计划ID，data:数据参数，userId:用户ID，moduleId:模块ID
/// Return：       	保存成功返回"S^"，失败返回"E^原因"
/// Debug:			w ##class(CIS.AN.BL.AnaestRecord).StartRecord("")
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
/// Debug:			w ##class(CIS.AN.BL.AnaestRecord).StartRecord("")
ClassMethod SaveAnaData(opsId As %String, data As %String, userId As %String, moduleId As %String) As %String
{
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术计划不存在！"
	quit:(data="") "E^保存的数据不能为空！"
	
	kill anathesia
	set anaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
	set anathesia("RowId")=anaId
	set anathesia("ClassName")="CIS.AN.Anaesthesia"
	
	set needSyncEventCode("OperStart")="OperStartDT"
	set needSyncEventCode("OperEnd")="OperFinishDT"
	set needSyncEventCode("TubeIn")="TubeInDT"
	set needSyncEventCode("TubeOut")="TubeOutDT"
	set needSyncEventCode("OperRoomIn")="TheatreInDT"
	set needSyncEventCode("OperRoomOut")="TheatreOutDT"
	set needSyncEventCode("AnaStart")="AnaStartDT"
	set needSyncEventCode("AnaEnd")="AnaFinishDT"
	
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
/// Debug:			w ##class(CIS.AN.BL.AnaestRecord).SaveDrugData("")
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
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.AnaestRecord","FindDrugItems")
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
/// Debug:			w ##class(CIS.AN.BL.AnaestRecord).SaveEventData("")
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
			continue:($get(array(detailIndex,"ClassName"))'="CT.AN.EventData")
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
/// Debug:			w ##class(CIS.AN.BL.AnaestRecord).SaveEventData(^TMPAN("SaveEventData","opsId"),^TMPAN("SaveEventData","data"),^TMPAN("SaveEventData","userId"),^TMPAN("SaveEventData","moduleId"))
ClassMethod SaveEventData(opsId As %String, data As %String, userId As %String, moduleId As %String) As %String
{
	// w ##class(CIS.AN.BL.AnaestRecord).SaveEventData(63,data,10209,27)
	s ^TempAnDebug("SaveEventData")=data
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术计划不存在！"
	//quit:(##class(CT.AN.DataModule).%ExistsId(moduleId)=0) "E^数据模块不存在！"
	quit:(data="") "E^保存的数据不能为空！"
	
	kill anathesia
	set anaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
	set anathesia("RowId")=anaId
	set anathesia("ClassName")="CIS.AN.Anaesthesia"
	
	set needSyncEventCode("OperStart")="OperStartDT"
	set needSyncEventCode("OperEnd")="OperFinishDT"
	set needSyncEventCode("TubeIn")="TubeInDT"
	set needSyncEventCode("TubeOut")="TubeOutDT"
	set needSyncEventCode("OperRoomIn")="TheatreInDT"
	set needSyncEventCode("OperRoomOut")="TheatreOutDT"
	set needSyncEventCode("AnaStart")="AnaStartDT"
	set needSyncEventCode("AnaEnd")="AnaFinishDT"
	
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
	b
	set saveResult=##class(CIS.AN.COM.DataService).SaveData(.anathesia)
		
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult	
	}
	
	tcommit
	
	kill ^TMPAN("AnaestRecord",opsId)
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
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.AnaestRecord","FindEventDatas","1","N")
Query FindEventDatas(sheetId As %String, editFlag As %String = "") As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT *,
	   EventDetailItem->Description As Description,
	   EventDetailItem->Unit As Unit,
	   ChargeDetail->ChargeRecord As ChargeRecord
	   from CIS_AN.EventData 
       where AnaData->ParaItem->RecordSheet=:sheetId
       and (AnaData->EditFlag=:editflag or :editflag is null)
}

/// Creator：      	陈长青
/// CreatDate：    	2018-1-11
/// Description： 	保存麻醉记录间断给药数据
/// Table：        	DHCAN.RecordData  DHCAN.DrugData
/// Input:			opsId:手术计划ID，data:数据参数，userId:用户ID，moduleId:模块ID
/// Return：       	保存成功返回"S^"，失败返回"E^原因"
/// Debug:			w ##class(CIS.AN.BL.AnaestRecord).SaveIntrmiDrugData("")
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
/// Debug:			w ##class(CIS.AN.BL.AnaestRecord).SaveAnaestCatheter("")
ClassMethod SaveAnaestCatheter(opsId As %String, data As %String) As %String
{
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术计划不存在！"
	quit:(data="") "E^保存的数据不能为空！"
	
	set mainAnaesthesiaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
	set $zt="Error"
	tstart
	set sc=##class(CIS.AN.COM.String).ToArray(data,.array)
	set anaIndex=0,saveResult=""
	for
	{
		set anaIndex=$order(array(anaIndex))
		quit:(anaIndex="")
		kill PLIST
		merge PLIST=array(anaIndex)
		continue:($get(PLIST("ClassName"))'="CIS.AN.AnaestCatheter")
		set PLIST("Anaesthesia")=mainAnaesthesiaId
		if $g(PLIST("isRemoved"))="Y"
		{
			set saveResult=##class(CIS.AN.COM.DataService).DelData(PLIST("ClassName"),PLIST("RowId"))
		}
		else 
		{
			set saveResult=##class(CIS.AN.COM.DataService).SaveData(.PLIST)
		}
		quit:($piece(saveResult,"^",1)'="S")
	}
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult	
	}
	
	do ##class(CIS.AN.BL.Anaesthesia).SyncAnaMethod(mainAnaesthesiaId)
	//麻醉方法回传旧表保证对外接口数据准确
	set operSchedule=""
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set ORAnaestID=operSchedule.ExtAnaestID	
	set opaId=operSchedule.ExternalID
	set EpisodeID=$p(ORAnaestID,"||",1),AnaSub=$p(ORAnaestID,"||",2)
	&sql(select top 1 AnaMethod into :firstAnaMethod from CIS_AN.AnaestCatheter where Anaesthesia=:mainAnaesthesiaId)
	set $p(^OR(EpisodeID,"ANA",AnaSub),"^",5)=firstAnaMethod
	set ret=##Class(EMRservice.BIEMRService).SetOperation(EpisodeID,opaId)
	
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
/// Debug:			w ##class(CIS.AN.BL.AnaestRecord).GetVitalSignGroupedData(12,27)
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
		set dataItem = paraItemObject.GetValue("DataItem")
		set dataCategoryCode = paraItemObject.GetValue("DataCategoryCode")
		set seq=dataCategoryCode_"_"_seq
		if (dataCategoryCode = "VitalSign")||(dataCategoryCode = "MonitorItems")
		{
			set paraItemSeq(seq,paraItemRowId) = paraItemDesc
			set paraItemSeq(seq,paraItemRowId,"DataItem") = dataItem
		}
	}
	
	set recordDatas=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.AnaestRecord:FindAnaDatas",recordSheetID,"N")
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
			write "{""ParaItem"":""",paraItemId,""",""ParaItemDesc"":""",paraItemSeq(seq,paraItemId),""",""DataItem"":""",paraItemSeq(seq,paraItemId,"DataItem"),""""
			
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
/// Debug:			w ##class(CIS.AN.BL.AnaestRecord).GetTimeColumnList(12,27)
ClassMethod GetTimeColumnList(opsId) As %String
{
	kill timeColumnList,timelineList,groupList
	set timeColumnFormat=..#TimeColumnFormat
	
	set startDateTime = ##class(CIS.AN.BL.AnaestRecord).GetRecordStartDT(opsId)
	set endDateTime = ##class(CIS.AN.BL.AnaestRecord).GetRecordEndDT(opsId)
	set startDate = ##class(CIS.AN.COM.DateTime).ConvertToDateH($piece(startDateTime," ",1))
	set startTime = ##class(CIS.AN.COM.DateTime).ConvertToTimeH($piece(startDateTime," ",2))
	set endDate = ##class(CIS.AN.COM.DateTime).ConvertToDateH($piece(endDateTime," ",1))
	set endTime = ##class(CIS.AN.COM.DateTime).ConvertToTimeH($piece(endDateTime," ",2))
	// 如果正在手术，只同步至当前时间；当手术结束后，按麻醉时间同步
	if ((endDate>+$h)||((endDate=+$h)&&(endTime>$p($h,",",2)))) {
		set endDate=+$h
		set endTime=$p($h,",",2)
	}
	//set endDate=startDate,endTime= 20*3600 - 1200
	
	set timelines=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.AnaestRecord:FindTimeLines",opsId)
	
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
		
		if isOperSchedule && ($g(record("isChangedSteward")) ="Y")
		{
			kill steward
			set steward("ClassName")="CT.AN.StewardAssessment"
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
				set:steward("RowId")="" record("InPACUSteward")=$p(saveResult,"^",2)
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
				set:steward("RowId")="" record("OutPACUSteward")=$p(saveResult,"^",2)
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
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.AnaestRecord","FindDeptEquips")
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
/// Debug:			w ##class(CIS.AN.BL.AnaestRecord).SaveDeviceUsage("")
ClassMethod SaveDeviceUsage(opsId As %String, data As %String, userId As %String) As %String
{
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术计划不存在！"
	quit:(data="") "E^保存的数据不能为空！"
	set ^tempyx("123")=data
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
/// Debug:			w ##class(CIS.AN.BL.AnaestRecord).SaveTemplate("")
ClassMethod SaveTemplate(moduleId As %String, data As %String, userId As %String) As %String
{
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
/// Debug:			w ##class(CIS.AN.BL.AnaestRecord).ClearEventData("40",3)
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
		//set:(ParaItemCode=intrmiDrugCode) intrmiDrugParaItemId=paraItem.GetValue("RowId")
	}
	
	kill data
	set data("ClassName")="CIS.AN.AnaData"
	set data("RowId")=""
	set data("EditFlag")="D"
	
	set anaDatas = ##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.AnaestRecord:FindAnaDatas",recordSheetId,"N")
	set saveResult = "S^"
	//
	tstart
	
	for i=1:1:(anaDatas.Size)
	{
		set anaData=anaDatas.GetAt(i)
		quit:anaData=""
		
		set paraItemId=anaData.GetValue("ParaItem")
		if (paraItemId=eventParaItemId)||(paraItemId=intrmiDrugParaItemId)
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
	
	quit saveResult
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
	
	set drugDatas = ##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.AnaestRecord:FindDrugDatas",recordSheetId,"N")
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
	;set recordStartDT = ..GetRecordStartDT(recordSheet.OperSchedule.%Id())
	set opsId=recordSheet.OperSchedule.%Id()
	if (##class(CIS.AN.OperSchedule).%ExistsId(opsId))
	{
		set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		set anaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
		set AnaesthesiaObj=##class(CIS.AN.Anaesthesia).%OpenId(anaId)
		set theatreInDT=AnaesthesiaObj.TheatreInDT
		
		if (theatreInDT'="")
		{
			set theatreInDate=##class(CIS.AN.COM.DateTime).ConvertToDateH($piece(theatreInDT," ",1))		
		}
		else
		{
			set theatreInDate=##class(CIS.AN.COM.DateTime).ConvertToDateH(operSchedule.OperDate)	
		}
	}	
	else
	{
		set theatreInDT=""	
		set theatreInDate=##class(CIS.AN.COM.DateTime).ConvertToDateH($piece(theatreInDT," ",1))	
	}
	set theatreInTime=##class(CIS.AN.COM.DateTime).ConvertToTimeH($piece(theatreInDT," ",2))		
	set recordStartDT=##class(CIS.AN.COM.DateTime).ConvertToDateTime(theatreInDate,theatreInTime)
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
/// Debug:			w ##class(CIS.AN.BL.AnaestRecord).SaveDrugData("")
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
/// Table：        	CT.AN.CollectData，CIS.AN.AnaData
/// Input:			
/// Return：       	保存成功返回"S^"，失败返回"E^原因"
/// Debug:			w ##class(CIS.AN.BL.AnaestRecord).AutoSyncCollectData()
ClassMethod AutoSyncCollectData() As %String
{
	d ##class(CIS.AN.BL.AnaestRecord).AutoSyncCollectANData()
	d ##class(CIS.AN.BL.PACURecord).AutoSyncCollectData()
	
	quit "S^"
}

ClassMethod AutoSyncCollectANData() As %String
{
	set date = +$h
	set moduleCode = "AnaestRecord"
	set operScheduleList=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.OperScheduleList:FindOperOpsIdList",date-1,date,"RoomIn")
	b ;001
	set operSchedule=""
	for i=1:1:(operScheduleList.Size)
	{
		set operSchedule=operScheduleList.GetAt(i)
		quit:operSchedule=""
		set opsId=operSchedule.GetValue("RowId")
	    set anRecordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCode(opsId,moduleCode,"")
		if (anRecordSheetId'="")
		{
			do ..SyncCollectData(opsId,anRecordSheetId,moduleCode)
		}
		
	}
	
	// 启动采集任务
	w ##class(CIS.AN.BL.CollectTask).StartAllTask()
	
	quit "S^"
}

/// Creator：      	钟鸣远
/// CreatDate：    	2021-01-14
/// Description： 	同步采集数据
/// Table：        
/// Input:			
/// Return：       	
/// Debug:			w ##class(CIS.AN.BL.AnaestRecord).SyncCollectData(2,20)
ClassMethod RestartAllANTask()
{
	
	w ##class(CIS.AN.BL.CollectTask).StartAllTask("StopEq")
	Set curTime=$PIECE($HOROLOG,",",2)
	For {
		 Set span=$PIECE($HOROLOG,",",2)-curTime
		  If (span>2)
	       {
		    // 停止后延迟2s启动任务
		    Quit
	       }
		 }
	w ##class(CIS.AN.BL.CollectTask).StartAllTask("StartEq")
	quit "S^"
}

/// Creator：      	雍阳
/// CreatDate：    	2018-09-14
/// Description： 	同步采集数据
/// Table：        	CT.AN.CollectData，CIS.AN.AnaData
/// Input:			opsId:手术计划ID,recordSheetID:表单ID
/// Return：       	保存成功返回"S^"，失败返回"E^原因"
/// Debug:			w ##class(CIS.AN.BL.AnaestRecord).SyncCollectData(2,20)
ClassMethod SyncCollectData(opsId As %String, recordSheetID As %String, moduleCode As %String = "AnaestRecord") As %String
{
	set equipId="",startDate="",startTime="",endDate="",endTime=""
	kill equipUsage,timeList
	
	do ..GetEquipUsage(recordSheetID,.equipUsage)
	if (moduleCode="PACURecord")
	{
	    do ..GetPACUCollectTimeList(opsId,recordSheetID,.timeList)
	}
	else
	{
		do ..GetCollectTimeList(opsId,recordSheetID,.timeList)
	}
	
	set RowId=""
	for{
		set RowId=$o(equipUsage(RowId))
		b //ccq
		quit:RowId=""
		
		set equipId=equipUsage(RowId,"Equip")
		set startDate=equipUsage(RowId,"StartDate")
		set startTime=equipUsage(RowId,"StartTime")
		set endDate=equipUsage(RowId,"EndDate")
		set endTime=equipUsage(RowId,"EndTime")
		
		if endDate = "" set endDate = +$h,endTime = $p($h,",",2)
		write "equipId:",equipId,"  startDT:",startDate," ",startTime,"  endDT:",endDate," ",endTime,!
		break //
		do ##class(CIS.AN.BL.CollectData).SyncData(recordSheetID,equipId,.timeList)
	}
	
	quit "S^"
}

/// Creator：      	雍阳
/// CreatDate：    	2018-09-20
/// Description： 	获取采集时间列的数据
/// Table：        	CT.AN.TimeLine
/// Input:			opsId:手术计划ID
/// Return：       	数据Json
/// Debug:			w ##class(CIS.AN.BL.AnaestRecord).GetCollectTimeList(12,27)
ClassMethod GetCollectTimeList(opsId, recordSheetID, ByRef timeColumnList) As %String
{
	kill timelineList
	set timeColumnFormat=..#TimeColumnFormat
	
	set startDateTime = ##class(CIS.AN.BL.AnaestRecord).GetRecordStartDT(opsId)
	set endDateTime = ##class(CIS.AN.BL.AnaestRecord).GetRecordEndDT(opsId)
	set startDate = ##class(CIS.AN.COM.DateTime).ConvertToDateH($piece(startDateTime," ",1))
	set startTime = ##class(CIS.AN.COM.DateTime).ConvertToTimeH($piece(startDateTime," ",2))
	set endDate = ##class(CIS.AN.COM.DateTime).ConvertToDateH($piece(endDateTime," ",1))
	set endTime = ##class(CIS.AN.COM.DateTime).ConvertToTimeH($piece(endDateTime," ",2))
	
	//set endDate=startDate,endTime= 20*3600 - 1200
	// 如果正在手术，只同步至当前时间；当手术结束后，按麻醉时间同步
	if ((endDate>+$h)||((endDate=+$h)&&(endTime>$p($h,",",2)))) {
		set endDate=+$h
		set endTime=$p($h,",",2)
	}
	set timelines=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.AnaestRecord:FindTimeLines",recordSheetID)
	
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

ClassMethod GetPACUCollectTimeList(opsId, recordSheetID, ByRef timeColumnList) As %String
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
	// 如果正在手术，只同步至当前时间；当手术结束后，按麻醉时间同步
	if ((endDate>+$h)||((endDate=+$h)&&(endTime>$p($h,",",2)))) {
		set endDate=+$h
		set endTime=$p($h,",",2)
	}
	set timelines=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.AnaestRecord:FindTimeLines",recordSheetID)
	
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
/// Debug:			w ##class(CIS.AN.BL.AnaestRecord).SyncCollectData("")
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
/// Debug:			w ##class(CIS.AN.BL.AnaestRecord).SaveUserDefDataItem()
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
/// Debug:			w ##class(CIS.AN.BL.AnaestRecord).GetAnaestSafetyCheck("66")
ClassMethod GetAnaestSafetyCheck(opsId) As %String
{
	set moduleCode = "AN_ANS_007"
	kill codeList
	
	set codeList("PreAN")="PreANCheckDT"
	set codeList("PreOP")="PreOPCheckDT"
	set codeList("PreOut")="PreOutCheckDT"
	
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
		set Checked = $s(DataValue'="":"true",1:"false")
		set UpdateDate = operData.GetValue("UpdateDate")
		set UpdateTime = operData.GetValue("UpdateTime")
		set Date = $p(DataValue," ",1)
		set Time = $p(DataValue," ",2)
		set Time =##class(CIS.AN.COM.DateTime).ConvertToTimeH(Time)
		set Time =##class(web.DHCClinicCom).ConvertToTime(Time)
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
/// Debug:			w ##class(CIS.AN.BL.AnaestRecord).SaveUserDefDataItem("")
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
		
		kill preferedData
		m preferedData=array(index)
		set preferedData("DataModule")=moduleId
		continue:($g(preferedData("isRemoved"))="Y")&&($g(preferedData("RowId"))="")
		
		if $g(preferedData("isRemoved"))="Y" set saveResult=##class(CIS.AN.COM.DataService).DelData(preferedData("ClassName"),preferedData("RowId"))
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
/// Debug:			w ##class(CIS.AN.BL.AnaestRecord).ApplyUserPreferedData("39",19225,"4,5","2023-05-11 17:34:00")
ClassMethod ApplyUserPreferedData(recordSheetId As %String, userId As %String, dataRowId As %String, startDateTime As %String) As %String
{
	//quit:(##class(CF.AN.UserPreferedData).%ExistsId(dataRowId)=0) "E^用户偏好数据不存在！"
	quit:(startDateTime="") "E^开始时间！"
	
	set eventCode="OperationEvent",intrmiDrugCode="OperationDrug" //术中事件和间断用药现在用代码进行对应
	
	set startDate=$p(startDateTime," ",1)
	set startTime=$p(startDateTime," ",2)
	set startDateH=##class(CIS.AN.COM.DateTime).ConvertToDateH(startDate)
	set startTimeH=##class(CIS.AN.COM.DateTime).ConvertToTimeH(startTime)
	
	set paraItems=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.DataQueries:FindParaItems",recordSheetId)
	set userPreferedDatas=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.AnaestRecord:FindUserPreferedData",userId, dataRowId)
	set userPreferedDrugs=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.AnaestRecord:FindUserPreferedDrug",userId, dataRowId)
	
	break //before
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
		set userDefinedItem=userPreferedData.GetValue("UserDefinedItem")
		set DataItem=userPreferedData.GetValue("DataItem")
		set code=""

		if type="E" set categoryItem="",code=eventCode
		else  if type="I" set categoryItem="",code=intrmiDrugCode
		
		set paraItemId=$$GetParaItem(categoryItem,code,userDefinedItem)
		if (paraItemId="")
		{
			set saveResult="E^请先添加项目"
			trollback
		}
		break //after get paraitem
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
		set anaData("DataItem")=DataItem
		set anaData("Continuous")=userPreferedData.GetValue("Continuous")
		
		set saveResult=##class(CIS.AN.COM.DataService).SaveData(.anaData)
		quit:($piece(saveResult,"^",1)'="S")
		set anaDataRowId=$p(saveResult,"^",2)
		
		for j=1:1:(userPreferedDrugs.Size)
		{
			set userPreferedDrug=userPreferedDrugs.GetAt(j)
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
	
GetParaItem(categoryItem,code,userDefinedItem)
	set foundParaItem=""
	for j=1:1:(paraItems.Size)
	{
		set paraItem = paraItems.GetAt(j)
		quit:paraItem=""
		
		set paraCategoryItem=paraItem.GetValue("CategoryItem")
		set paraItemCode=paraItem.GetValue("Code")
		set paraUserDefinedItem=paraItem.GetValue("UserDefinedItem")
		if ((categoryItem'="")&&
			(paraCategoryItem=categoryItem))||
			((code'="")&&(paraItemCode=code)||
			((userDefinedItem'="")&&(paraItemCode=userDefinedItem)))
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
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.AnaestRecord","FindUserPreferedData","2")
Query FindUserPreferedData(userId As %String, dataRowId As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT *
	from CF_AN.UserPreferedData
	where CreateUserID=:userId 
	and (","_:dataRowId_",")[(","||RowId||",")
}

/// Creator：      	雍阳
/// CreatDate：    	2018-10-30
/// Description： 	查询药品项
/// Table：        	CF.AN.UserPreferedDrug
/// Input:			
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.AnaestRecord","FindUserPreferedDrug","2")
Query FindUserPreferedDrug(userId As %String, dataRowId As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT *
	from CF_AN.UserPreferedDrug
	where UserPreferedData->CreateUserID=:userId 
	and (","_:dataRowId_",")[(","||UserPreferedData||",")
}

/// Creator：      	雍阳
/// CreatDate：    	2018-12-18
/// Description： 	同步手术关键事件的时间，前台打印麻醉监护记录时执行一次同步
/// Table：        	CIS.AN.OperSchedule
/// Input:			opsId:手术安排ID
/// Return：       	
/// w ##class(CIS.AN.BL.AnaestRecord).SyncEventTime()
ClassMethod SyncEventTime(opsId) As %String
{
	quit:'##class(CIS.AN.OperSchedule).%ExistsId(opsId) "E^手术安排记录ID错误"
	
	kill needSyncEventCode
	kill surgicalProcedure
	set needSyncEventCode("OperStart")="OperStartDT"
	set needSyncEventCode("OperEnd")="OperFinishDT"
	set needSyncEventCode("TubeIn")="TubeInDT"
	set needSyncEventCode("TubeOut")="TubeOutDT"
	set needSyncEventCode("OperRoomIn")="TheatreInDT"
	set needSyncEventCode("OperRoomOut")="TheatreOutDT"
	set needSyncEventCode("AnaStart")="AnaStartDT"
	set needSyncEventCode("AnaEnd")="AnaFinishDT"
	
	set moduleCode = "AnaestRecord"
	set recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCode(opsId,moduleCode,"")
	
	kill anathesia
	set anaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
	set anathesia("RowId")=anaId
	set anathesia("ClassName")="CIS.AN.Anaesthesia"
	
	set anaDatas = ##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.AnaestRecord:FindAnaDatas",recordSheetId,"N")
	for i=1:1:anaDatas.Size
	{
		set anaData = anaDatas.GetAt(i)
		quit:anaData=""
		
		continue:anaData.GetValue("ItemCategory")'="E"  // 非事件数据退出
		
		set itemCode = anaData.GetValue("DataItemCode")
		if (itemCode'="")&&($d(needSyncEventCode(itemCode)))
		{
			set anathesia(needSyncEventCode(itemCode))=anaData.GetValue("StartDT")
			set surgicalProcedure(needSyncEventCode(itemCode))=anaData.GetValue("StartDT")_"^"_anaData.GetValue("CreateUserID")
		}
	}
	
	//break //before save
	tstart
	
	set saveResult=##class(CIS.AN.COM.DataService).SaveData(.anathesia)
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult	
	}
	
	set saveResult=##class(CIS.AN.BL.SurgicalProcedure).SaveProcedureForKeyEvent(opsId,.surgicalProcedure)
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
/// w ##class(CIS.AN.BL.AnaestRecord).GetAnaEventTime("","OperStart")
ClassMethod GetAnaEventTime(opsId, eventCode) As %String
{
	quit:'##class(CIS.AN.OperSchedule).%ExistsId(opsId) "E^手术安排记录ID错误"
	
	set moduleCode = "AnaestRecord"
	set recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCode(opsId,moduleCode,"")
	set eventParaItemId=$$GetParaItemId(recordSheetId,"OperationEvent")
	
	set eventDate="",eventTime="",eventDateTime="",matched=0
	
	&sql(SELECT Count(RowId),StartDate,StartTime into :matched,:eventDate,:eventTime FROM CIS_AN.AnaData
		WHERE ParaItem=:eventParaItemId and EditFlag="N"
		and DataItem->Code=:eventCode)
	
	if matched<=0
	{
		set eventDateTime=""
	}
	else
	{
		set eventDateTime=$zd(eventDate,3)_" "_$zt(eventTime)
	}
	
	quit eventDateTime
	
GetParaItemId(recordSheetId,code)
	set result=""
	&sql(SELECT RowId into :result FROM CIS_AN.ParaItem 
		WHERE RecordSheet=:recordSheetId and Code=:code)
	quit result
}

/// Creator：      	雍阳
/// CreatDate：    	2018-12-18
/// Description： 	是否已打印
/// Table：        	CIS.AN.RecordSheet
/// Input:			opsId:手术安排ID
/// Return：       	Y,N
/// w ##class(CIS.AN.BL.AnaestRecord).SyncEventTime()
ClassMethod IsPrinted(opsId) As %String
{
	set moduleCode = "AnaestRecord"
	set recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCode(opsId,moduleCode,"")
	set recordSheet=##class(CIS.AN.RecordSheet).%OpenId(recordSheetId)
	set result="Y"
	if recordSheet.PrintDate>0  set result="Y"
	
	quit result
}

/// w ##class(CIS.AN.BL.AnaestRecord).resyncEventTime("2018-11-01","2018-11-10")
ClassMethod resyncEventTime(startDate, endDate) As %String
{
	set startDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(startDate,"")
	set endDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(endDate,"")
	if (startDateH>endDateH) quit "E^开始日期大于结束日期"
	
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
			
			set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			set anesthesiologist=operSchedule.Anesthesiologist
			continue:anesthesiologist=""
			
			set statusCode=operSchedule.Status.Code
			continue:(statusCode'="RoomIn")&&(statusCode'="RoomOut")&&(statusCode'="PACUIn")&&(statusCode'="Finish")
			
			write "excute sync event time: ",opsId,!
			do ..SyncEventTime(opsId)
		}
	}
	
	quit "over"
}

/// w ##class(CIS.AN.BL.AnaestRecord).CalcDrugSumQty("185")
ClassMethod CalcDrugSumQty(drugDataId As %String) As %String [ SqlProc ]
{
	set ret=""
	if (##class(CIS.AN.DrugData).%ExistsId(drugDataId))
	{
		set drugData=##class(CIS.AN.DrugData).%OpenId(drugDataId)
		set speed=+drugData.Speed,speedUom=drugData.SpeedUnit
		if (speed>0)&(speedUom'="")
		{
			set ret=..CalcSpeedSumQty(drugData.AnaData,drugData)
				
		}
		elseif (+drugData.DoseQty>0)
		{
			set ret=drugData.DoseQty	
		}	
	}
	
	quit ret
}

/// w ##class(CIS.AN.BL.AnaestRecord).GetInOutSummary(1)
ClassMethod GetInOutSummary(opsId) As %String
{
	kill totalInfo
	/// 入量
	kill summaryCodeList,summaryCategory
	/// summaryCategory(分类代码)=汇总代码
	set summaryCategory("Crystalloid")="Crystalloid"
	set summaryCategory("Colloid")="Colloid"
	set summaryCategory("RedCell")="RedCell"
	set summaryCategory("Plasma")="Plasma"
	set summaryCategory("BloodPlate")="BloodPlate"
	
	set categoryCode=""
	for
	{
		set categoryCode=$o(summaryCategory(categoryCode))
		quit:categoryCode=""
		
		set summaryCode=summaryCategory(categoryCode)
		set categoryId=$o(^CT.AN.DataCategoryI("ICode"," "_$ZCVT(categoryCode,"U"),""))
		
		continue:categoryId=""
		set categoryItemId=""
		for
		{
			set categoryItemId=$o(^CT.AN.DataCateItemI("IDataCategory",categoryId,categoryItemId))
			quit:categoryItemId=""
			
			set dataItemId=$lg(^CT.AN.DataCateItemD(categoryItemId),2)
			set summaryCodeList(dataItemId,summaryCode)=""
		}
	}
	
	set moduleCode = "AnaestRecord"
	set recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCode(opsId,moduleCode,"")
	set drugDatas=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.AnaestRecord:FindDrugDatas",recordSheetId,"N")
	for i=1:1:(drugDatas.Size)
	{
		set drugData = drugDatas.GetAt(i)
		continue:drugData=""
		set dataItemId = drugData.GetValue("DataItem")
		set rowId = drugData.GetValue("RowId")
		continue:(dataItemId="")||('$d(summaryCodeList(dataItemId)))
		
		set sumQty=..CalcDrugSumQty(rowId)
		set summaryCode=""
		for
		{
			set summaryCode=$o(summaryCodeList(dataItemId,summaryCode))
			quit:summaryCode=""
			
			set totalInfo(summaryCode)=$g(totalInfo(summaryCode))+sumQty
		}
	}
	
	set totalInfo("TotalInfusion")=$g(totalInfo("Crystalloid"))+$g(totalInfo("Colloid"))+$g(totalInfo("Plasma"))
	
	///出量
	set paraItemId=""
	for
	{
		set paraItemId=$o(^CIS.AN.ParaItemI("ISheet",recordSheetId,paraItemId))
		quit:paraItemId=""
		
		set summaryCode=""
		set paraItem=##class(CIS.AN.ParaItem).%OpenId(paraItemId)
		if (paraItem.CategoryItem'="") && (paraItem.CategoryItem.DataItem'="")
		{
			if paraItem.CategoryItem.DataItem.Code="BleedingVolume"
			{
				set summaryCode="BloodLoss"	
			}
			if paraItem.CategoryItem.DataItem.Code="UrineVolume"
			{
				set summaryCode="UrineVolume"	
			}
		}
		continue:summaryCode=""
		
		set anaDataId=""
		for
		{
			set anaDataId=$o(^CIS.AN.AnaDataI("IParaItem",paraItemId,anaDataId))
			quit:anaDataId=""
			
			set editFlag=$lg(^CIS.AN.AnaDataD(anaDataId),7)
			continue:editFlag="D"
			
			set sumQty=..CalcSumQty(anaDataId)
			set totalInfo(summaryCode)=$g(totalInfo(summaryCode))+sumQty
		}
	}
	
	set totalInfo("TotalOutVolume")=$g(totalInfo("BloodLoss"))+$g(totalInfo("UrineVolume"))
	
	
	write "{"
	
	set summaryCode="",isFirst=1
	for
	{
		set summaryCode=$o(totalInfo(summaryCode))
		quit:summaryCode=""
		
		if 'isFirst write ","
		write """",summaryCode,""":",totalInfo(summaryCode)
		
		set isFirst=0
	}
	
	write "}"
	quit ""
}

/// w ##class(DHCAN.BLL.AnaestRecord).RemoveBatchData(671)
ClassMethod RemoveBatchData(opsId, paraItemId, startDateTime, endDateTime) As %String
{
	set startDate=$p(startDateTime," ",1)
	set startTime=$p(startDateTime," ",2)
	set endDate=$p(endDateTime," ",1)
	set endTime=$p(endDateTime," ",2)
	
	set startDateH=##class(CIS.AN.COM.DateTime).ConvertToDateH(startDate)
	set startTimeH=##class(CIS.AN.COM.DateTime).ConvertToTimeH(startTime)
	set endDateH=##class(CIS.AN.COM.DateTime).ConvertToDateH(endDate)
	set endTimeH=##class(CIS.AN.COM.DateTime).ConvertToTimeH(endTime)
	
	set anaDataId=""
	for
	{
		set anaDataId=$o(^CIS.AN.AnaDataI("IParaItem",paraItemId,anaDataId))
		quit:anaDataId=""
		
		set anaData=##class(CIS.AN.AnaData).%OpenId(anaDataId)
		continue:anaData.EditFlag="D"
		continue:(anaData.StartDate<startDateH)||((anaData.StartDate=startDateH)&&(anaData.StartTime<startTimeH))
		continue:(anaData.StartDate>endDateH)||((anaData.StartDate=endDateH)&&(anaData.StartTime>endTimeH))
		
		set anaData.EditFlag="D"
		do anaData.%Save()
	}
	
	quit "S^"
}

/// Creator：      	陈长青
/// CreatDate：    	2017-10-11
/// Description： 	查询麻醉记录数据
/// Table：        	DHCAN.RecordData
/// Input:			opsId:手术计划ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.AnaestRecord","FindEventDrugDatas","1202")
Query FindEventDrugDatas(sheetId As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT a.RowId As RowId,
	   ParaItem,
	   %ODBCOUT(StartDate) As StartDate,
	   %ODBCOUT(StartTime) As StartTime,
	   %ODBCOUT(EndDate) As EndDate,
	   %ODBCOUT(EndTime) As EndTime,
	   DataValue,
	   EditFlag,
	   FromData,
	   a.Continuous As Continuous,
	   CreateUserID,
	   %ODBCOUT(CreateDate)_' '_%ODBCOUT(CreateTime) As CreateDT,
	   %ODBCOUT(StartDate)_' '_%ODBCOUT(StartTime) As StartDT,
	   %ODBCOUT(EndDate)_' '_%ODBCOUT(EndTime) As EndDT,
	   ParaItem->CategoryItem As CategoryItem,
	   a.DataItem As DataItem,
	   a.DataItem->Code As DataItemCode,
	   a.DataItem->Description As DataItemDesc,
	   a.DataItem->ItemCategory As ItemCategory,
	   a.UserDefinedItem,
	   a.UserDefinedItem->Description As UserDefinedItemDesc,
	   CIS_AN_COM.String_AlterDesc(a.DataItem->Description,a.UserDefinedItem->Description) As DataItemDesc,
	   CIS_AN_COM.String_AlterDesc(a.DataItem->ItemCategory,a.UserDefinedItem->ItemCategory) As ItemCategory,
	   ParaItem->DataCategory As DataCategory,
	   ParaItem->Description As ParaItemDesc,
	   Source,
	   CIS_AN_COM.String_PatchFloat(DoseQty) As DoseQty,
	   DoseUnit,
	   DoseUnit->Description As DoseUnitDesc,
	   Instruction,
	   CIS_AN_COM.String_GetDescByID("CT.AN.Instruction","Description",Instruction) As InstructionDesc,
	   b.RowId As DrugDataId
	   from CIS_AN.AnaData As a 
	   left join CIS_AN.DrugData As b on a.RowId=b.AnaData
       where ParaItem->RecordSheet=:sheetId
       and (EditFlag in ('N','E'))
       and (a.DataItem->ItemCategory in ('D','E'))
       and CIS_AN_BL.AnaestRecord_ExistInKeyEvents(a.DataItem)="N"
       order by StartDate,StartTime
}

/// w ##class(CIS.AN.BL.AnaestRecord).ExistInKeyEvents(27)
ClassMethod ExistInKeyEvents(dataItemId) As %String [ SqlProc ]
{
	quit:dataItemId="" "N"
	
	set dataCategoryCode="KEYEVENT"
	set dataCategoryId=$o(^CT.AN.DataCategoryI("ICode"," "_dataCategoryCode,""))
	quit:dataCategoryId="" "N"
	
	set existed="N"
	set cateItemId=""
	for
	{
		set cateItemId=$o(^CT.AN.DataCateItemI("IDataCategory",dataCategoryId,cateItemId))
		quit:cateItemId=""
		
		set cateItemDataItemId=$lg(^CT.AN.DataCateItemD(cateItemId),2)
		if cateItemDataItemId=dataItemId set existed="Y" quit
	}
	
	quit existed
}

/// Creator：      	yongyang
/// CreatDate：    	2020-9-18
/// Description： 	生成生命体征数据
/// Table：        	CIS.AN.AnaData
/// Input:			opsId:手术计划ID，data:数据参数，userId:用户ID，moduleId:模块ID
/// Return：       	保存成功返回"S^"，失败返回"E^原因"
/// Debug:			w ##class(CIS.AN.BL.AnaestRecord).GenerateVitalSignData("593",^TMPAN("GenerateVitalSignData","data"),10209)
ClassMethod GenerateVitalSignData(opsId As %String, data As %String, userId As %String) As %String
{
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术计划不存在！"
	quit:(data="") "E^生命体征数据生成参数不能为空！"
	set ^TMPAN("GenerateVitalSignData","data")=data
	set $zt="Error"
	
	set sc=##class(CIS.AN.COM.String).ToArray(data,.array)
	set anaDataIndex=1,saveResult="S^"
	
	set paraItemId=array(1,"ParaItem")
	set dataItemId=array(1,"DataItem")
	set startDT=array(1,"StartDT")
	set endDT=array(1,"EndDT")
	set value=array(1,"Value")
	
	quit:(paraItemId="")||(dataItemId="")||(startDT="")||(endDT="")||(value="") "E^生命体征数据生成参数错误！"
	
	set startDateH=##class(CIS.AN.COM.DateTime).ConvertToDateH($p(startDT," ",1))
	set startTimeH=##class(CIS.AN.COM.DateTime).ConvertToTimeH($p(startDT," ",2))
	set endDateH=##class(CIS.AN.COM.DateTime).ConvertToDateH($p(endDT," ",1))
	set endTimeH=##class(CIS.AN.COM.DateTime).ConvertToTimeH($p(endDT," ",2))
	
	set moduleCode = "AnaestRecord"
	set recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCodeNew(opsId,moduleCode,"")
	do ..GetCollectTimeList(opsId,recordSheetId,.timeList)
	
	set syncInterval=$$GetSyncInterval(dataItemId)
	
	set date="",count=0
	for
	{
		set date=$o(timeList(date))
		quit:date=""
		
		set time=""
		for
		{
			set time=$o(timeList(date,time))
			quit:time=""
			
			set count = count+1
			continue:(count#syncInterval)'=0 //间隔执行同步
			continue:(date<startDateH)||(date>endDateH)
			continue:((date=startDateH)&&(time<startTimeH))||((date=endDateH)&&(time>endTimeH))
			
			set res=##class(CIS.AN.BL.CollectData).AddRecordData(paraItemId,dataItemId, date, time, value)
			//write "res:",res
		}
	}
	
	quit "S^"
	
GetSyncInterval(dataItemId)
	set syncInterval=""
	&sql(SELECT SyncInterval into :syncInterval FROM CT_AN.VitalSign
		WHERE DataItem=:dataItemId)
	quit:syncInterval>1 syncInterval
	quit 1
	
Error
	quit "E^"_$ze
}

/// w ##class(CIS.AN.BL.AnaestRecord).GetRecordItemByTime(2679,"2021-03-09","12:00","2021-03-09","13:00",39,33,80,15)
ClassMethod GetRecordItemByTime(sheetId, StDate, StTime, EndData, EndTime, TmpMaxValue, TmpMinValue, ConMaxValue, ConMinValue)
{
	quit:sheetId="" ""
	set startDateH=##class(CIS.AN.COM.DateTime).ConvertToDateH(StDate)
	set startTimeH=##class(CIS.AN.COM.DateTime).ConvertToTimeH(StTime)
	set endDateH=##class(CIS.AN.COM.DateTime).ConvertToDateH(EndData)
	set endTimeH=##class(CIS.AN.COM.DateTime).ConvertToTimeH(EndTime)
	set paraItemId=""
	set paraItemList=""
	for
	{
		set paraItemId=$O(^CIS.AN.ParaItemI("ISheet",sheetId,paraItemId))
		quit:paraItemId=""
		set ifFind=0
		if (##class(CIS.AN.ParaItem).%ExistsId(paraItemId)'=0)
		{
			set paraItem=##class(CIS.AN.ParaItem).%OpenId(paraItemId)
			continue:paraItem.DataCategory.%Id()'=2   //生命体征区域暂时先写死
			set date=startDateH-1
			for
			{
				set date=$O(^CIS.AN.AnaDataI("IItemTime",paraItemId,date))
				quit:(date="")||(date>endDateH)||(ifFind=1)
				if (startTimeH=0) set Time=""
				else  set Time=startTimeH-1
				for
				{
					set Time=$O(^CIS.AN.AnaDataI("IItemTime",paraItemId,date,Time))
					quit:(Time="")||(Time>endTimeH)||(ifFind=1)
					set anaDataId=$O(^CIS.AN.AnaDataI("IItemTime",paraItemId,date,Time,""))
					set anaData=##class(CIS.AN.AnaData).%OpenId(anaDataId)
					continue:anaData.EditFlag="D"
					set dateValue=anaData.DataValue
					if (paraItem.Description="体温")
					{
						if (dateValue<=TmpMaxValue)&&(dateValue>=TmpMinValue) set ifFind=1
					}
					else
					{
						if (dateValue<=ConMaxValue)&&(dateValue>=ConMinValue) set ifFind=1
					}
				}
			}
			continue:ifFind=0
			set desc=paraItem.Description
			if (paraItemList="") set paraItemList=paraItemId_"^"_desc
			else  set paraItemList=paraItemList_","_paraItemId_"^"_desc
		}
	}
	quit paraItemList
}

/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.AnaestRecord","GetRecordItemByTime",2679,"2021-03-09","12:00","2021-03-09","13:00",39,33,80,15)
Query GetRecordItemByTime(sheetId, StDate, StTime, EndData, EndTime, TmpMaxValue, TmpMinValue, ConMaxValue, ConMinValue) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{

SELECT distinct ParaItem->Description As Description,
	ParaItem,
	DataValue,
	%ODBCOUT(StartDate) As StartDate,
	%ODBCOUT(StartTime) As StartTime,
	%ODBCOUT(EndDate) As EndDate,
	%ODBCOUT(EndTime) As EndTime,
	%ODBCOUT(StartDate)_" "_%ODBCOUT(StartTime) As StartDT,
	%ODBCOUT(EndDate)_" "_%ODBCOUT(EndTime) As EndDT
	from CIS_AN.AnaData WHERE ParaItem->RecordSheet=:sheetId AND ParaItem->DataCategory=2
	AND EditFlag!='D'
	AND %ODBCOUT(StartDate)>=:StDate 
	AND %ODBCOUT(StartTime)>=:StTime AND %ODBCOUT(StartDate)<=:EndData
	AND %ODBCOUT(StartTime)<=:EndTime AND ((ParaItem->Description='体温' AND (DataValue+0)<=:TmpMaxValue AND (DataValue+0)>=:TmpMinValue)
	OR (ParaItem->Description!='体温' AND (DataValue+0)<=:ConMaxValue AND (DataValue+0)>=:ConMinValue))
	GROUP BY ParaItem->Description
}

/// w ##class(DHCAN.BLL.AnaestRecord).RemoveBatchData(671)
ClassMethod RemoveBatchDataNew(opsId, paraItemIdList, startDateTime, endDateTime) As %String
{
	set length=$l(paraItemIdList,"^")
	set i=0
	set ret=""
	for i=1:1:length
	{
		set paraItemId=$P(paraItemIdList,"^",i)
		set ret=..RemoveBatchData(opsId,paraItemId,startDateTime,endDateTime)
	}
	quit ret
}

/// Edit:           wcj
/// CreatDate：    	2021-05-21
/// Description： 	入手术间时间填写以及修改时间功能
/// Table：        	DHCAN.OperSchedule
/// Input:			data:启动监护参数
/// Return：       	启动成功返回"S^"，失败返回"E^原因"
/// Debug:			w ##class(CIS.AN.BL.AnaestRecord).StartRecord("")
ClassMethod StartRecordhs(data As %String) As %String
{
	
	
	
	set opsId="",formerDT="",currentDT="",AnaStartDateTime=""
	set status=##class(CIS.AN.COM.String).ToArray(data,.array)
	merge operSchedule=array(1)
	set opsId=operSchedule("RowId")
	if (opsId="")
	{
		//trollback
		quit "E^无手术安排表ID"	
	}
	set operScheduleObj=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set anaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
	set AnaesthesiaObj=##class(CIS.AN.Anaesthesia).%OpenId(anaId)
	
	
	if ((AnaesthesiaObj.TheatreInDT="")&(AnaesthesiaObj.AnaStartDT=""))
	{
	set saveResult="S^"
	set anaesthesia("ClassName")="CIS.AN.Anaesthesia"
	set anaesthesia("RowId")=anaId
	set anaesthesia("TheatreInDT")=operSchedule("TheatreInDT")	
	set saveResult=##class(CIS.AN.COM.DataService).SaveData(.anaesthesia)
	if ($piece(saveResult,"^",1)'="S")
	{
		quit saveResult		
	}	
		
	}
		
	else
	{
	tstart
	set saveResult="S^"
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
	set anaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
	set AnaesthesiaObj=##class(CIS.AN.Anaesthesia).%OpenId(anaId)
	set formerDT=AnaesthesiaObj.TheatreInDT
	set AnaStartDateTime=AnaesthesiaObj.AnaStartDT
	set currentDT=operSchedule("TheatreInDT")
	//s ^TEMPWCJ("2")=currentDT
	
	set saveResult=##class(CIS.AN.COM.DataService).SaveData(.operSchedule)
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult		
	}
	
	set anaesthesia("ClassName")="CIS.AN.Anaesthesia"
	set anaesthesia("RowId")=anaId
	set anaesthesia("TheatreInDT")=currentDT
	if (AnaStartDateTime'="")
	{
		set timeSpanone=##class(CIS.AN.COM.DateTime).CalculateDurationS(AnaStartDateTime,currentDT,"S")
		if timeSpanone>0 set saveResult= "E^入手术间时间不能晚于麻醉开始时间"
		
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
	set saveResult=##class(CIS.AN.BL.SurgicalProcedure).SaveProcedureByDT(operSchedule("RowId"),"RI",operSchedule("UpdateUser"),currentDT)
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult		
	}
	
	// 回写旧表
	set saveResult=##class(CIS.AN.SRV.OperAppService).StartANRecord(opsId,"")
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult		
	}
	tcommit
	
	do ..AutoCreateParaItem(operSchedule("RowId"))
	do ..AutoCreateDeviceUsage(operSchedule("RowId"),operSchedule("UpdateUser"),operSchedule("TheatreInDT"))
	
	set personalSetting=..GetPersonalSetting("AnaestRecord",operSchedule("UpdateUser"))
		
	if ($get(operSchedule("isStarting"))'="N") //修改开始时间时不调用自动生成的方法
	{
		if (personalSetting.GetValue("AutoCreateEvent")="Y")
		{
			
			do ..AutoCreateDefaultEvents(operSchedule("RowId"),operSchedule("UpdateUser"),operSchedule("TheatreInDT"))
		}
		if (personalSetting.GetValue("AutoApplyTemplate")'="")
		{
			set moduleCode = "AnaestRecord"
			set recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCode(operSchedule("RowId"),moduleCode,"")
			do ..ApplyTemplate(recordSheetId,personalSetting.GetValue("AutoApplyTemplate"),operSchedule("UpdateUser"))
		}
		else
		{
			set moduleCode = "AnaestRecord"
			set recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCode(operSchedule("RowId"),moduleCode,"")
			set publicTemplateId=..GetPublicTemplate(moduleCode)
			if publicTemplateId'="" do ..ApplyTemplate(recordSheetId,publicTemplateId,operSchedule("UpdateUser"))
		}
		
		do ..GenerateDefaultValue(operSchedule("RowId"))
		do ..AutoGenerateUserPreferedData(operSchedule("RowId"),operSchedule("UpdateUser"),operSchedule("TheatreInDT"))
		do ..AutoCreateEvent(operSchedule("RowId"),operSchedule("UpdateUser"),operSchedule("TheatreInDT"),"OperRoomIn")
		do ..CreateinoprooomEvent(operSchedule("RowId"),operSchedule("UpdateUser"),operSchedule("TheatreInDT"),"AnaStart")
		do ..SyncPatInfo(operSchedule("RowId"))
	}
	else
	{

		set timeSpan=##class(CIS.AN.COM.DateTime).CalculateDurationS(formerDT,currentDT,"S")
		//do ..TranslateData(opsId,timeSpan)
		do ..RemoveOutrangedData(opsId,currentDT)
	}
	}
	quit saveResult
}

/// Creator：      	雍阳
/// CreatDate：    	2018-09-17
/// Description： 	启动麻醉监护后自动创建入手术间事件
/// Table：        	CIS.AN.OperSchedule
/// Input:			opsId:手术排班表ID
/// Return：       	启动成功返回"S^"，失败返回"E^原因"
/// Debug:			w ##class(CIS.AN.BL.AnaestRecord).CreateinoprooomEvent("7","274","2018-09-25 09:00","AnaStart")
ClassMethod CreateinoprooomEvent(opsId As %String, userId As %String, dateTime As %String, eventCode As %String = "AnaStart", userDefinedItemId As %String = "") As %String
{
	//set ^TEMPWCJ("20210512")=opsId_"^"_userId_"^"_dateTime_"^"_eventCode
	tstart
	set moduleCode = "AnaestRecord"
	set recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCode(opsId,moduleCode,"")
	set paraItemId=$$GetParaItemId(recordSheetId,"OperationEvent")
	set dataItemId=$$GetDataItemId(eventCode)
	
	if (recordSheetId="")||(paraItemId="") || ((dataItemId="")&&(userDefinedItemId=""))
	{
		trollback
		quit "E^数据错误"		
	}
	
	set dataSource="M",rowId=""
	set:dataItemId'="" rowId=$$GetExistedAnaDataId(paraItemId,dataItemId)
	set:userDefinedItemId'="" rowId=$$GetExistedAnaDataIdNew(paraItemId,userDefinedItemId)
	
	if (rowId'="")&&(dataSource'="A")
	{
		trollback
		quit "E^用户已手工改动的数据不再自动修正 paraItem:"_paraItemId_" rowId:"_rowId_" source:"_dataSource_" DataItem:"_dataItemId_" UserDefItem:"_userDefinedItemId	
	}
	
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
	set data("Source")="A"
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
	
GetExistedAnaDataId(paraItemId,dataItemId)
	set result="",dataSource="M"
	&sql(SELECT RowId,Source into :result,:dataSource FROM CIS_AN.AnaData
		WHERE ParaItem=:paraItemId 
		and (DataItem=:dataItemId and DataItem is not NULL))
		
	quit result
	
GetExistedAnaDataIdNew(paraItemId,userDefinedItemId)
	set result="",dataSource="M"
	&sql(SELECT RowId,Source into :result,:dataSource FROM CIS_AN.AnaData
		WHERE ParaItem=:paraItemId 
		and (UserDefinedItem=:userDefinedItemId and UserDefinedItem is not NULL))
		
	quit result
}

/// 自动生成生命体征显示项目
/// w ##class(CIS.AN.BL.AnaestRecord).AutoDisplayVitalsignItem(1111,4779)
ClassMethod AutoDisplayVitalsignItem(opsId As %String, recordSheetId As %String, moduleCode As %String = "AnaestRecord") As %String
{
	set startDateTime = ##class(CIS.AN.BL.AnaestRecord).GetRecordStartDT(opsId)
	set endDateTime = ##class(CIS.AN.BL.AnaestRecord).GetRecordEndDT(opsId)
	set recordStartDate = ##class(CIS.AN.COM.DateTime).ConvertToDateH($piece(startDateTime," ",1))
	set recordStartTime = ##class(CIS.AN.COM.DateTime).ConvertToTimeH($piece(startDateTime," ",2))
	set recordEndDate = ##class(CIS.AN.COM.DateTime).ConvertToDateH($piece(endDateTime," ",1))
	set recordEndTime = ##class(CIS.AN.COM.DateTime).ConvertToTimeH($piece(endDateTime," ",2))
	
	do ..GetEquipUsage(recordSheetId,.equipUsage)
	set vitalsignItems=##class(%DynamicObject).%New()
	set RowId=""
	for
	{
		set RowId=$o(equipUsage(RowId))
		quit:RowId=""
		
		set equipId=equipUsage(RowId,"Equip")
		set startDate=equipUsage(RowId,"StartDate")
		set startTime=equipUsage(RowId,"StartTime")
		set endDate=equipUsage(RowId,"EndDate")
		set endTime=equipUsage(RowId,"EndTime")
		
		if endDate = "" set endDate = recordEndDate,endTime = recordEndTime
		set collectedVitalsign=##class(CIS.AN.BL.CollectData).GetCollectedVitalsign(equipId, startDate, startTime, endDate, endTime)
		do CombineMatches(collectedVitalsign,vitalsignItems)
	}
	
	//write vitalsignItems.%ToJSON()
	
	set items = ..GetCategoryItems(vitalsignItems)
	do ..GenerateDisplayItems(recordSheetId,items)
	
	quit ""


CombineMatches(objectSource,objectTarget)
	set iter=objectSource.%GetIterator()
	while iter.%GetNext(.key,.value)
	{
		set targetValue=objectTarget.%Get(key)
		if targetValue="" set targetValue=value
		else  set targetValue=targetValue||value
		do objectTarget.%Set(key,targetValue)
	}
	quit
}

/// 通过生命体征项目的代码获取数据项信息
/// s items={}
/// s items.HR=1,items.NSBP=1,items.NDBP=1,items.ASBP=0,items.ADBP=0
/// set categoryItems=##class(CIS.AN.BL.AnaestRecord).GetCategoryItems(items)
ClassMethod GetCategoryItems(items As %DynamicObject) As %DynamicObject
{
	set result=##class(%DynamicObject).%New()
	
	set query=##class(%ResultSet).%New("CIS.AN.BL.CodeQueries:FindCategoryItem")
	set sc=query.Execute("","","")
	while(query.%Next())
	{
		set RowId=query.Get("RowId")
		set ItemCode=query.Get("ItemCode")
		set ItemDesc=query.Get("ItemDesc")
		set DataCategory=query.Get("DataCategory")
		
		set item={}
		do item.%Set("ItemDesc",ItemDesc)
		do item.%Set("DataCategory",DataCategory)
		do item.%Set("ItemCode",ItemCode)
		do item.%Set("CategoryItem",RowId)
		if items.%Get(ItemCode) do result.%Set(ItemCode,item)
	}
	
	//write result.%ToJSON()
	
	quit result
}

/// 生成多项显示项目
/// w ##class(CIS.AN.BL.AnaestRecord).GenerateDisplayItems(4779,categoryItems)
ClassMethod GenerateDisplayItems(recordSheetId As %String, items As %DynamicObject) As %String
{
	set result="",saveResult=""
	kill data
	
	set data("ClassName")="CIS.AN.ParaItem"
	set data("RecordSheet")=recordSheetId
	
	set iter=items.%GetIterator()
	while iter.%GetNext(.key,.value)
	{
		set paraItemId=$$GetParaItemId(recordSheetId,key)
		if (paraItemId="")
		{
			set data("CategoryItem")=value.CategoryItem
			set data("Code")=key
			set data("Description")=value.ItemDesc
			set data("DataCategory")=value.DataCategory
			set data("Seq")=$$GetNextSeq(recordSheetId,value.DataCategory)
			//write "creating:",value.ItemDesc,"   Seq:",data("Seq"),!
			if (data("DataCategory")'="")
			{
				set saveResult=##class(CIS.AN.COM.DataService).SaveData(.data)
			}
		}
	}
	
	quit "S^"
	
GetParaItemId(recordSheetId,code)
	set result=""
	&sql(SELECT RowId into :result FROM CIS_AN.ParaItem 
		WHERE RecordSheet=:recordSheetId and Code=:code)
	quit result

GetNextSeq(recordSheetId,dataCategory)
	set seq=0
	&sql(SELECT top 1 Seq into :seq FROM CIS_AN.ParaItem 
		WHERE RecordSheet=:recordSheetId and DataCategory=:dataCategory order by Seq Desc)
	set seq=+seq+1
	quit seq
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
