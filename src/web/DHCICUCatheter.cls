/// 导管数据处理类
Class web.DHCICUCatheter Extends %RegisteredObject
{

/// w ##class(web.DHCICUCatheter).TestSaveCatheterRecord()
ClassMethod TestSaveCatheterRecord()
{
	set param=^TMPCCQ("ICUCatheter")
	set icuaId=$p(param,"###",1)
	set data=$p(param,"###",2)
	set userId=$p(param,"###",3)	
	set result=..SaveCatheterRecord(icuaId,data,userId)
	quit result
}

/// 保存导管数据
/// 如果有变更则存入变更数据表
/// w ##class(web.DHCICUCatheter).SaveCatheterRecord(8,$p(^TMPCCQ("ICUCatheter"),"###",2),22465)
ClassMethod SaveCatheterRecord(icuaId, data As %String, userId As %String) As %String
{
	s ^TMPCCQ("ICUCatheter")=icuaId_"###"_data_"###"_userId
	quit:'##class(User.DHCICUArrange).%ExistsId(icuaId) "E^重症记录ID错误"
	quit:data="" "E^导管使用数据不能为空"
	
	set originalData = {}
	set savingData = ..ConvertParamToJson(data)
	if +savingData.RowId 
	{
		set saveObj=##class(User.DHCICUCatheterRecord).%OpenId(savingData.RowId)
		set originalData = ..ConvertDataToJson(saveObj)
	}
	else
	{
		set saveObj=##class(User.DHCICUCatheterRecord).%New()
		set saveObj.CreateUser = userId
	}
	
	set saveObj.Arrange = ##class(User.DHCICUArrange).%OpenId(icuaId)
	set catheter=##class(User.DHCICUCCatheter).%OpenId(savingData.Catheter)
	set saveObj.Catheter = catheter
	set saveObj.Type = savingData.Type
	;set saveObj.Position = $s(##class(User.DHCICUCCatheterPos).%ExistsId(savingData.Position):##class(User.DHCICUCCatheterPos).%OpenId(savingData.Position),1:"")
	set saveObj.Position = savingData.Position	///部位存储描述
	set saveObj.Source = savingData.Source
	
	
	set saveObj.IntubateDate = ##class(web.DHCClinicCom).ConvertToDateH($p(savingData.IntubateDateTime," ",1),"")
	set saveObj.IntubateTime = ##class(web.DHCClinicCom).ConvertToTimeH($p(savingData.IntubateDateTime," ",2),"")
	set saveObj.TakeInDate = ##class(web.DHCClinicCom).ConvertToDateH($p(savingData.TakeInDateTime," ",1),"")
	set saveObj.TakeInTime = ##class(web.DHCClinicCom).ConvertToTimeH($p(savingData.TakeInDateTime," ",2),"")
	set saveObj.ExtubateDate = ##class(web.DHCClinicCom).ConvertToDateH($p(savingData.ExtubateDateTime," ",1),"")
	set saveObj.ExtubateTime = ##class(web.DHCClinicCom).ConvertToTimeH($p(savingData.ExtubateDateTime," ",2),"")
	set saveObj.Status = "Using"
	set:(saveObj.ExtubateDate'="") saveObj.Status = "Extubated"
	set saveObj.EditFlag = savingData.EditFlag
	set saveObj.TotalLength = savingData.TotalLength
	set saveObj.ExposedLenth = savingData.ExposedLenth
	set saveObj.ExposedScale = savingData.ExposedScale
	set saveObj.MarkOnSkin = savingData.MarkOnSkin
	set saveObj.TailPos = savingData.TailPos
	set saveObj.AdjustDateTime = savingData.AdjustDateTime
	set saveObj.AlertDate = ##class(web.DHCClinicCom).ConvertToDateH(savingData.AlertDate,"")
	set saveObj.DressingReplaceTime = savingData.DressingReplaceTime
	set saveObj.PSensorsReplaceDate=##class(web.DHCClinicCom).ConvertToDateH(savingData.PSensorsReplaceDate,"")
	set saveObj.Note = savingData.Note
	
	set saveObj.UpdateUser = userId
	set saveObj.UpdateDate = +$h
	set saveObj.UpdateTime = +$p($h,",",2)
	
	set saveObj.CatheterDesc=savingData.CatheterDesc

	set sc=saveObj.%Save()
	
	set result=""
	if $$$ISOK(sc)
	{
		set DataRowId=saveObj.%Id()
		set result="S^"_DataRowId
		
		if originalData.RowId'="" do ..SaveCatheterChange(icuaId,originalData,savingData,userId)
	}
	else
	{
		set result="E^"_$System.Status.GetErrorText(sc)
	}
	
	set catheterRecordID=saveObj.%Id()
	set catheterRecord=##class(User.DHCICUCatheterRecord).%OpenId(catheterRecordID)
	// 引流管如果没有生成关联的项目，那么重新保存也可以再次生成 by ccq 20211109
	if (catheterRecord.ParaItem="")&&($isobject(catheter.RecordItem)) 
	{
		do ..CreateParaItemByCatheter(catheterRecordID)
	}
	
	// 更新导管信息，同时更新关联的模板项(比如自定义导管的名称发生变化，那么要同时更新模板项的名称，两者保持一致) by ccq 20211109
	if (catheterRecord.ParaItem'="")
	{
		//do ..UpdateParaItemByCatheter(catheterRecord.ParaItem,catheterRecord.CatheterDesc)	
	}
	
	if (catheterRecord.ParaItem'="")&&(catheterRecord.ExtubateDate>=catheterRecord.IntubateDate)
	{
		do ..StopParaItemByCatheter(catheterRecord.ParaItem,catheterRecord.ExtubateDate,catheterRecord.ExtubateTime)	
	}
	quit result
}

/// 创建导管出量项目和评估项目，并将项目ID保存到导管记录中。
/// w ##class(web.DHCICUCatheter).CreateParaItemByCatheter(2259)
ClassMethod CreateParaItemByCatheter(catheterRecordID As %String) As %String
{
	quit:('##class(User.DHCICUCatheterRecord).%ExistsId(catheterRecordID)) "E^导管记录不存在"
	set catheterRecord=##class(User.DHCICUCatheterRecord).%OpenId(catheterRecordID)
	
	if ($isobject(catheterRecord.Catheter))&($isobject(catheterRecord.Catheter.RecordItem))
	{
		set paraItemId=..InsertLinkRecordItem(catheterRecord.Arrange.%Id(),catheterRecord.Catheter.RecordItem.%Id())
		
		if (paraItemId'="")
		{
			set catheterRecord.ParaItem=paraItemId
			set sc=catheterRecord.%Save()	
			quit:($$$ISERR(sc)) "E^保存护理记录项ID失败，原因："_$System.Status.GetErrorText(sc)
			set startDate=catheterRecord.IntubateDate
			set startTime=catheterRecord.IntubateTime
			set:(startDate="") startDate=catheterRecord.TakeInDate
			set:(startTime="") startTime=catheterRecord.TakeInTime
			set:(startDate="") startDate=+$h
			set:(startTime="") startTime=$p($h,",",2)
			set codeStr=$System.Util.CreateGUID()
			set saveResult=..StartParaItemByCatheter(paraItemId,startDate,startTime,catheterRecord.CatheterDesc,codeStr)
			quit saveResult
		}
			
	}
	
	quit "S^"
}

/// 保存导管监护项的起始时间
ClassMethod StartParaItemByCatheter(paraItemIDStr As %String, startDate, startTime, userDefineDesc = "", userDefineCode = "") As %String
{
	set saveResult="S^"
	try
	{
		for i=1:1:$l(paraItemIDStr,"###")
		{
			set paraItemID=$p(paraItemIDStr,"###",i)
			continue:('##class(User.DHCICUParaItem).%ExistsId(paraItemID))
			set paraItem=##class(User.DHCICUParaItem).%OpenId(paraItemID)
			set paraItem.ICUPIStartDate=startDate
			set paraItem.ICUPIStartTime=startTime
			set:(userDefineDesc'="") paraItem.ICUPIDesc=userDefineDesc	// 自定义项目的名称 by ccq 20211109
			set:(userDefineCode'="") paraItem.ICUPICode=paraItem.ICUPICode_userDefineCode	// 自定义项目的代码 by ccq 20211109 
			set sc=paraItem.%Save()
			set:($$$ISERR(sc)) saveResult="E^护理记录项保存失败，原因："_$System.Status.GetErrorText(sc)
			quit:($p(saveResult,"^",1)'="S")
		}	
		return saveResult
	}
	catch exp
	{
		return "E^"_$ze	
	}
	
	return saveResult
}

/// 导管名称更新后，同步更新模板项目的名称
ClassMethod UpdateParaItemByCatheter(paraItemIDStr As %String, catheterDesc As %String) As %String
{
	set saveResult="S^"
	try
	{
		for i=1:1:$l(paraItemIDStr,"###")
		{
			set paraItemID=$p(paraItemIDStr,"###",i)
			continue:('##class(User.DHCICUParaItem).%ExistsId(paraItemID))
			set paraItem=##class(User.DHCICUParaItem).%OpenId(paraItemID)
			;continue:(paraItem.ICUPIEndDate>0)&(paraItem.ICUPIEndTime>0)
			set paraItem.ICUPIDesc=catheterDesc	
			set sc=paraItem.%Save()
			set:($$$ISERR(sc)) saveResult="E^护理记录项的名称保存失败，原因："_$System.Status.GetErrorText(sc)
			quit:($p(saveResult,"^",1)'="S")
		}	
		return saveResult
	}
	catch exp
	{
		return "E^"_$ze	
	}
	
	return "S^"
}

/// 导管拔管后，停止导管出量项目和导管
ClassMethod StopParaItemByCatheter(paraItemIDStr As %String, stopDate, stopTime) As %String
{
	set saveResult="S^"
	try
	{
		for i=1:1:$l(paraItemIDStr,"###")
		{
			set paraItemID=$p(paraItemIDStr,"###",i)
			continue:('##class(User.DHCICUParaItem).%ExistsId(paraItemID))
			set paraItem=##class(User.DHCICUParaItem).%OpenId(paraItemID)
			;continue:(paraItem.ICUPIEndDate>0)&(paraItem.ICUPIEndTime>0)
			set paraItem.ICUPIEndDate=stopDate
			set paraItem.ICUPIEndTime=stopTime	
			set sc=paraItem.%Save()
			set:($$$ISERR(sc)) saveResult="E^护理记录项的结束时间保存失败，原因："_$System.Status.GetErrorText(sc)
			quit:($p(saveResult,"^",1)'="S")
		}	
		return saveResult
	}
	catch exp
	{
		return "E^"_$ze	
	}
	
	return "S^"
}

ClassMethod RemoveParaItemByCatheter(paraItemIDStr As %String, stopDate, stopTime) As %String
{
	set saveResult="S^"
	try
	{
		for i=1:1:$l(paraItemIDStr,"###")
		{
			set paraItemID=$p(paraItemIDStr,"###",i)
			continue:('##class(User.DHCICUParaItem).%ExistsId(paraItemID))
			//set sc=##class(User.DHCICUParaItem).%DeleteId(paraItemID)
			set paraItem=##class(User.DHCICUParaItem).%OpenId(paraItemID)
			set paraItem.ICUPIEndDate=stopDate
			set paraItem.ICUPIEndTime=stopTime	
			set paraItem.ICUPIIsActive="N"
			set sc=paraItem.%Save()
			set:($$$ISERR(sc)) saveResult="E^护理记录项的结束时间保存失败，原因："_$System.Status.GetErrorText(sc)
			quit:($p(saveResult,"^",1)'="S")
		}	
		return saveResult
	}
	catch exp
	{
		return "E^"_$ze	
	}
	
	return "S^"
}

/// 字段对应描述的json对象
ClassMethod GetFieldObject() As %DynamicObject
{
	set result = ##class(%DynamicObject).%New()
	set result.Catheter = "导管"
	set result.Type = "导管型号"
	set result.Position = "置入位置"
	set result.Source = "来源"
	set result.Status = "状态"
	set result.EditFlag = "数据编辑状态"
	set result.IntubateDateTime = "置管日期时间"
	set result.TakeInDateTime = "带入日期时间"
	set result.ExtubateDateTime = "拔管日期时间"
	set result.TotalLength = "置管长度"
	set result.ExposedLenth = "外露长度"
	set result.ExposedScale = "外露刻度"
	set result.MarkOnSkin = "体表标志"
	set result.TailPos = "末端位置"
	set result.AdjustDateTime = "调整时间"
	set result.AlertDate = "提醒更换日期"
	set result.DressingReplaceTime = "更换辅料时间"
	set result.Note = "备注"
	set result.PSensorsReplaceDate="压力传感器更换日期"
	set result.CatheterDesc="导管类型"
	
	quit result
}

/// 转换数据字符串为json对象
ClassMethod ConvertParamToJson(data As %String) As %DynamicObject
{
	set result = ##class(%DynamicObject).%New()
	set result.RowId = $p(data,$c(3),1)
	set result.Catheter = $p(data,$c(3),2)
	set result.Type = $p(data,$c(3),3)
	set result.Position = $p(data,$c(3),4)
	set result.Source = $p(data,$c(3),5)
	set result.Status = $p(data,$c(3),6)
	set result.EditFlag = $p(data,$c(3),7)
	set result.IntubateDateTime = $p(data,$c(3),8)
	set result.TakeInDateTime = $p(data,$c(3),9)
	set result.ExtubateDateTime = $p(data,$c(3),10)
	set result.TotalLength = $p(data,$c(3),11)
	set result.ExposedLenth = $p(data,$c(3),12)
	set result.ExposedScale = $p(data,$c(3),13)
	set result.MarkOnSkin = $p(data,$c(3),14)
	set result.TailPos = $p(data,$c(3),15)
	set result.AdjustDateTime = $p(data,$c(3),16)
	set result.AlertDate = $p(data,$c(3),17)
	set result.DressingReplaceTime = $p(data,$c(3),18)
	set result.Note = $p(data,$c(3),19)
	set result.PSensorsReplaceDate=$p(data,$c(3),20)
	set result.CatheterDesc=$p(data,$c(3),21)
	
	quit result
}

/// 转换数据为json对象
ClassMethod ConvertDataToJson(data As User.DHCICUCatheterRecord) As %DynamicObject
{
	set result = ##class(%DynamicObject).%New()
	set result.RowId = data.%Id()
	set result.Catheter = data.Catheter.%Id()
	set result.Type = data.Type
	set result.Position = $s($IsObject(data.Position):data.Position.%Id(),1:"")
	set result.Source = data.Source
	set result.Status = data.Status
	set result.EditFlag = data.EditFlag
	set result.IntubateDateTime = ##class(web.DHCClinicCom).ConvertToDateTime(data.IntubateDate,data.IntubateTime,"")
	set result.TakeInDateTime = ##class(web.DHCClinicCom).ConvertToDateTime(data.TakeInDate,data.TakeInTime,"")
	set result.ExtubateDateTime = ##class(web.DHCClinicCom).ConvertToDateTime(data.ExtubateDate,data.ExtubateTime,"")
	set result.TotalLength = data.TotalLength
	set result.ExposedLenth = data.ExposedLenth
	set result.ExposedScale = data.ExposedScale
	set result.MarkOnSkin = data.MarkOnSkin
	set result.TailPos = data.TailPos
	set result.AdjustDateTime = data.AdjustDateTime
	set result.AlertDate = ##class(web.DHCClinicCom).ConvertToDate(data.AlertDate,"")
	set result.DressingReplaceTime = data.DressingReplaceTime
	set result.Note = data.Note
	set result.PSensorsReplaceDate=data.PSensorsReplaceDate
	set result.CatheterDesc=data.CatheterDesc
	
	quit result
}

/// 保存导管数据变更
ClassMethod SaveCatheterChange(icuaId As %String, originalData As %DynamicObject, currentData As %DynamicObject, userId) As %String
{
	set rowId = originalData.RowId
	set createArgs = ##class(%DynamicObject).%New()
	set createArgs.Arrange = icuaId
	set createArgs.CatheterRecord = rowId
	set createArgs.UpdateUser = userId
	
	set fields = ..GetFieldObject()
	set iter = originalData.%GetIterator()
	while(iter.%GetNext(.key,.value))
	{
		if key'="RowId"
		{
			set createArgs.ChangeField = key
			set createArgs.ChangeFieldName = fields.%Get(key)
			set createArgs.OriginalValue = value
			set createArgs.Value = currentData.%Get(key)
			do ..CreateCatheterChange(createArgs)
		}
	}
	
	quit "S^"
}

/// 创建导管数据变更
ClassMethod CreateCatheterChange(args As %DynamicObject) As %String
{
	set saveObj=##class(User.DHCICUCatheterChange).%New()
	set saveObj.Arrange = ##class(User.DHCICUArrange).%OpenId(args.Arrange)
	set saveObj.CatheterRecord = ##class(User.DHCICUCatheterRecord).%OpenId(args.CatheterRecord)
	set saveObj.UpdateUser = args.UpdateUser
	
	set saveObj.ChangeField = args.ChangeField
	set saveObj.ChangeFieldName = args.ChangeFieldName
	set saveObj.OriginalValue = args.OriginalValue
	set saveObj.Value = args.Value
	
	set sc=saveObj.%Save()
	
	set result=""
	if $$$ISOK(sc)
	{
		set result="S^"_saveObj.%Id()
	}
	else
	{
		set result="E^"_$System.Status.GetErrorText(sc)
	}
	
	quit "S^"
}

ClassMethod RemoveCatheterRecord(rowId As %String, userId As %String) As %String
{
	quit:('##class(User.DHCICUCatheterRecord).%ExistsId(rowId)) "数据不存在"
	set record=##class(User.DHCICUCatheterRecord).%OpenId(rowId)
	set record.EditFlag="Deleted"
	set record.UpdateUser=userId
	set record.UpdateDate=+$h
	set record.UpdateTime=$p($h,",",2)
	set sc=record.%Save()
	quit:($$$ISERR(sc)) $System.Status.GetErrorText(sc)
	
	// 删除导管记录，同时停止导管记录关联的导管出量项目和导管评估项目
	if (record.ParaItem'="")&(record.ExtubateDate="")
	{
		//do ..StopParaItemByCatheter(record.ParaItem,+$h,$p($h,",",2))	
		do ..RemoveParaItemByCatheter(record.ParaItem,+$h,$p($h,",",2))	
	}
	
	quit 0
}

/// w ##class(web.DHCICUCatheter).GetCatheterRecordByDate(138,"2021-08-23")
ClassMethod GetCatheterRecordByDate(icuaId, printDate, baseTime As %String = "7:00") As %String
{
	quit:('##class(User.DHCICUArrange).%ExistsId(icuaId)) "E^重症监护记录ID不存在"
	quit:(printDate="") "E^打印日期不能为空"
	quit:(baseTime="") "E^每天第一个班次的开始时间不能为空"
	set printStartDateH=##class(web.DHCClinicCom).ConvertToDateH(printDate,"")
	set printStartTimeH=##class(web.DHCClinicCom).ConvertToTimeH(baseTime,"")
	set printStartDTH=printStartDateH+(printStartTimeH/100000)
	set printEndDateH=printStartDateH+1
	set printEndTimeH=printStartTimeH-1
	set printEndDTH=printEndDateH+(printEndTimeH/100000)
	&sql(declare PrintCatheterCursor cursor for select RowId into :RowId
		 from SQLUser.DHC_ICU_CatheterRecord
		 where Arrange=:icuaId
		 and EditFlag='Normal'
		 and (IntubateDate<=:printEndDateH or TakeInDate<=:printEndDateH)
		 and (ExtubateDate>=:printStartDateH or ExtubateDate is null))
	&sql(open PrintCatheterCursor)
	set retArray=##class(%DynamicArray).%New()
	for
	{
		&sql(fetch PrintCatheterCursor)	
		quit:(SQLCODE'=0)
		//b //ccq2
		set catheterRecord=##class(User.DHCICUCatheterRecord).%OpenId(RowId)
		set intubeDTH=0
		if (catheterRecord.IntubateDate>0)&(catheterRecord.IntubateTime>0)
		{
			set intubeDTH=catheterRecord.IntubateDate+(catheterRecord.IntubateTime/100000)	
		}
		elseif (catheterRecord.TakeInDate>0)&(catheterRecord.TakeInTime>0)
		{
			set intubeDTH=catheterRecord.TakeInDate+(catheterRecord.TakeInTime/100000)	
		}
		continue:(intubeDTH=0)
		continue:(intubeDTH>printEndDTH)
		if (catheterRecord.ExtubateDate>0)&(catheterRecord.ExtubateTime>0)
		{
			set extubeDTH=catheterRecord.ExtubateDate+(catheterRecord.ExtubateTime/100000)
			//b //ccq
			continue:(extubeDTH<printStartDateH)	
		}
		set resCatheter=##class(%DynamicObject).%New()
		set resCatheter.CatheterDesc=catheterRecord.Catheter.Description
		set resCatheter.IntubeDT=""
		set:(catheterRecord.IntubateDate>0)&(catheterRecord.IntubateTime>0) resCatheter.IntubeDT=##class(web.DHCClinicCom).ConvertToDateTime(catheterRecord.IntubateDate,catheterRecord.IntubateTime,"")
		set resCatheter.TakeInDT=""
		set:(catheterRecord.TakeInDate>0)&(catheterRecord.TakeInTime>0) resCatheter.TakeInDT=##class(web.DHCClinicCom).ConvertToDateTime(catheterRecord.TakeInDate,catheterRecord.TakeInTime,"")
		set resCatheter.ExtubeDT=""
		set:(catheterRecord.ExtubateDate>0)&(catheterRecord.ExtubateTime>0) resCatheter.ExtubeDT=##class(web.DHCClinicCom).ConvertToDateTime(catheterRecord.ExtubateDate,catheterRecord.ExtubateTime,"")
		set resCatheter.Type=catheterRecord.Type
		set resCatheter.TotalLength=catheterRecord.TotalLength
		set resCatheter.ExposedLenth=catheterRecord.ExposedLenth
		set resCatheter.ExposedScale=catheterRecord.ExposedScale
		set resCatheter.MarkOnSkin=catheterRecord.MarkOnSkin
		set resCatheter.TailPos=catheterRecord.TailPos
		set resCatheter.AdjustDateTime=catheterRecord.AdjustDateTime
		set resCatheter.Note=catheterRecord.Note
		set resCatheter.PositionDesc=""
		set:($isobject(catheterRecord.Position)) resCatheter.PositionDesc=catheterRecord.Position.Description
		set:(catheterRecord.CatheterDesc'="") resCatheter.CatheterDesc=catheterRecord.CatheterDesc
		do retArray.%Push(resCatheter)
	}
	&sql(close PrintCatheterCursor)
	quit retArray.%ToJSON()
}

/// d ##class(%ResultSet).RunQuery("web.DHCICUCatheter","FindCatheterRecord","138")
/// d ##class(%ResultSet).RunQuery("web.DHCICUCatheter","FindCatheterRecord","1198")
Query FindCatheterRecord(icuaId) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	select RowId,Arrange,Catheter,Type,Position,Source,Status,EditFlag,TotalLength,ExposedLenth,ExposedScale,MarkOnSkin,TailPos,
		AdjustDateTime,DressingReplaceTime,Note,CreateUser,UpdateUser,
		IntubateDate,
		IntubateTime,
		TakeInDate,
		TakeInTime,
		ExtubateDate,
		ExtubateTime,
		AlertDate,
		PSensorsReplaceDate,
		CreateDate,
		CreateTime,
		UpdateDate,
		UpdateTime,
		web.DHCICUCatheter_GetCatheterDesc(RowId) As CatheterDesc,
		%ODBCOUT(IntubateDate)_" "_%ODBCOUT(IntubateTime) As IntubateDT,
		%ODBCOUT(TakeInDate)_" "_%ODBCOUT(TakeInTime) As TakeInDT,
		%ODBCOUT(ExtubateDate)_" "_%ODBCOUT(ExtubateTime) As ExtubateDT,
		%ODBCOUT(CreateDate)_" "_%ODBCOUT(CreateTime) As CreateDT,
		%ODBCOUT(UpdateDate)_" "_%ODBCOUT(UpdateTime) As UpdateDT,
		web.DHCICUCatheter_GetDescByID('User.SSUser','SSUSRName',CreateUser) As CreateUserName,
		web.DHCICUCatheter_GetDescByID('User.SSUser','SSUSRName',UpdateUser) As UpdateUserName
	 from SQLUser.dhc_icu_catheterrecord
	 where Arrange=:icuaId
	 and EditFlag='Normal'
	 order by ExtubateDate,ExtubateTime,IntubateDate,IntubateTime
}

/// d ##class(%ResultSet).RunQuery("web.DHCICUCatheter","FindCatheterRecordOver","138")
Query FindCatheterRecordOver(icuaId As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	select RowId,Arrange,Catheter,Type,Position,Source,Status,EditFlag,TotalLength,ExposedLenth,ExposedScale,MarkOnSkin,TailPos,
		AdjustDateTime,DressingReplaceTime,Note,CreateUser,UpdateUser,
		IntubateDate,
		IntubateTime,
		TakeInDate,
		TakeInTime,
		ExtubateDate,
		ExtubateTime,
		AlertDate,
		PSensorsReplaceDate,
		CreateDate,
		CreateTime,
		UpdateDate,
		UpdateTime,
		web.DHCICUCatheter_GetCatheterDesc(RowId) As CatheterDesc,
		%ODBCOUT(IntubateDate)_" "_%ODBCOUT(IntubateTime) As IntubateDT,
		%ODBCOUT(TakeInDate)_" "_%ODBCOUT(TakeInTime) As TakeInDT,
		%ODBCOUT(ExtubateDate)_" "_%ODBCOUT(ExtubateTime) As ExtubateDT,
		%ODBCOUT(CreateDate)_" "_%ODBCOUT(CreateTime) As CreateDT,
		%ODBCOUT(UpdateDate)_" "_%ODBCOUT(UpdateTime) As UpdateDT,
		web.DHCICUCatheter_GetDescByID('User.SSUser','SSUSRName',CreateUser) As CreateUserName,
		web.DHCICUCatheter_GetDescByID('User.SSUser','SSUSRName',UpdateUser) As UpdateUserName
	 from SQLUser.dhc_icu_catheterrecord
	 where Arrange=:icuaId
	 and ((ExtubateDate<=+$h))
	 and EditFlag='Normal'
	 order by IntubateDate,IntubateTime
}

ClassMethod GetCatheterDesc(catheterRecordId As %String) As %String [ SqlProc ]
{
	set catheterRecord=##class(User.DHCICUCatheterRecord).%OpenId(catheterRecordId)
	if (catheterRecord'="")
	{
		quit:(catheterRecord.CatheterDesc'="") catheterRecord.CatheterDesc
		quit catheterRecord.Catheter.Description	
	}	
	quit ""
}

Query FindCatheterChange(icuaId, catheterRecordId = "") As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	select *,
		web.DHCICUCatheter_GetDescByID('User.SSUser','SSUSRName',UpdateUser) As UpdateUserName,
		%ODBCOUT(UpdateDate)_" "_%ODBCOUT(UpdateTime) As UpdateDT
	 from SQLUser.dhc_icu_catheterchange
	 where Arrange=:icuaId
	 and ((:catheterRecordId is null) or (CatheterRecord=:catheterRecordId))
}

/// Creator：      	陈长青
/// CreatDate：    	2016-12-29
/// Description： 	根据ID获取名称
/// Table：        	
/// Input:			className:实体类名称，descProperty:名称(描述)字段名，rowId:对象ID
/// Return：       	ResultSet
/// w ##class(DHCAN.DataService).GetDescByID("User.SSGroup","SSGRPDesc","1")
ClassMethod GetDescByID(className As %String, descProperty As %String, rowId As %Integer, original As %String = "N", defaultValue As %String = "") As %String [ SqlProc ]
{
	Set $ZTRAP="Error",result=""
	If (##class(%ClassDefinition).%ExistsId(className))
	{
		If ($CLASSMETHOD(className,"%ExistsId",rowId))
		{
			Set instance=$CLASSMETHOD(className,"%OpenId",rowId)
			Set result=$PROPERTY(instance,descProperty)	
		}	
	}
	Quit:(original="Y")&(result="") rowId
	Quit:(original="N")&(result="") defaultValue
	Quit result
Error
	Set $ZTRAP=""
	Quit "E^"_$ZERROR
}

/// 同步常用医嘱的导管项目到导管码表
/// w ##class(web.DHCICUCatheter).ImportCatheterFromComOrd("Catheter")
/// w ##class(web.DHCICUCatheter).ImportCatheterFromComOrd("Pipe")
/// w ##class(web.DHCICUCatheter).ImportCatheterFromComOrd("DaoDGuanGNew")
/// w ##class(web.DHCICUCatheter).ImportCatheterFromComOrd("YinYLiuLGuanGNew")
/// w ##class(web.DHCICUCatheter).ImportCatheterFromComOrd("DaoDGuanGNICUNew")
/// w ##class(web.DHCICUCatheter).ImportCatheterFromComOrd("YinYLiuLGuanGNICUNew")
/// w ##class(web.DHCICUCatheter).ImportCatheterFromComOrd("DaoGuanPICU")
/// w ##class(web.DHCICUCatheter).ImportCatheterFromComOrd("YinLiuLiangPICU")
ClassMethod ImportCatheterFromComOrd(viewCatCode As %String) As %String
{
	set viewCatId="",viewCatDesc=""
	&sql(select ICUCVC_RowId,ICUCVC_Desc into :viewCatId,:viewCatDesc from SQLUser.DHC_ICUC_ViewCat where ICUCVC_Code=:viewCatCode)
	quit:('##class(User.DHCICUCViewCat).%ExistsId(viewCatId)) "E^未找到显示分类ID"
	set viewCatIdStr="^"_viewCatId_"^"
	
	set catheterCatID=""
	&sql(select RowId into :catheterCatID from SQLUser.DHC_ICUC_CatheterCategory where Code=:viewCatCode)
	if ('##class(User.DHCICUCCatheterCategory).%ExistsId(catheterCatID))
	{
		// 如果没有导管分类，那么根据显示分类插入一个新的导管分类
		&sql(insert into SQLUser.DHC_ICUC_CatheterCategory values (:viewCatCode,:viewCatDesc))
		set catheterCatID=%ROWID	
	}
	
	&sql(declare RecordItemCursor cursor for select 
		 ICUCRI_Code,
		 ICUCRI_Desc,
		 ICUCRI_RowId
		 into :recordItemCode,:recordItemDesc,:recordItemID
		 from SQLUser.DHC_ICUC_RecordItem
		 where ICUCRI_IcuApply='Y'
		 and  STRING('^',ICUCRI_ViewCat_Dr,'^') [ :viewCatIdStr
		 and ICUCRI_MainICUCRI_Dr is null)
	&sql(open RecordItemCursor)
	for
	{
		&sql(fetch RecordItemCursor)
		quit:(SQLCODE'=0)
		set catheterID=$o(^User.DHCICUCCatheterI("IRecordItem",recordItemID,0))
		if (##class(User.DHCICUCCatheter).%ExistsId(catheterID))
		{
			set catheter=##class(User.DHCICUCCatheter).%OpenId(catheterID)	
		}	
		else
		{
			set catheter=##class(User.DHCICUCCatheter).%New()	
		}
		set catheter.Code=recordItemCode
		set catheter.Description=recordItemDesc
		set catheter.Category=##class(User.DHCICUCCatheterCategory).%OpenId(catheterCatID)
		set catheter.RecordItem=##class(User.DHCICUCRecordItem).%OpenId(recordItemID)
		set sc=catheter.%Save()
		w:($$$ISOK(sc)) !,"导管同步成功，代码："_recordItemCode_" 名称："_recordItemDesc_" 数据项ID："_recordItemID_" 导管ID："_catheter.%Id()
		w:($$$ISERR(sc)) !,"导管同步失败，代码："_recordItemCode_" 名称："_recordItemDesc_" 数据项ID："_recordItemID_" 原因："_$System.Status.GetErrorText(sc)
	}
	&sql(close RecordItemCursor)
	quit "S^"
}

/// w ##class(web.DHCICUCatheter).InsertLinkRecordItem(8,8199)
ClassMethod InsertLinkRecordItem(icuaId As %String, recordItemId As %String) As %String
{
	s ^TMPCCQ("InsertLinkRecordItem")=icuaId_"###"_recordItemId
	quit:('##class(User.DHCICUArrange).%ExistsId(icuaId)) "E^参数icuaId的值不正确"
	quit:('##class(User.DHCICUCRecordItem).%ExistsId(recordItemId)) "E^参数recordItemId的值不正确"
	set paraId=$o(^DHCICUPara(0,"ICUA",icuaId,0))
	quit:('##class(User.DHCICUPara).%ExistsId(paraId)) "E^未找到参数主表ID，可能病人还未开始监护"
	set icuArrange=##class(User.DHCICUArrange).%OpenId(icuaId)
	set wardId=icuArrange.ICUAPatWardDR
	quit:('##class(User.PACWard).%ExistsId(wardId)) "E^未找到病区ID"
	
	&sql(Declare itemCursor cursor for
    select LinkRecord into :pairRecordItemId
    from SQLUser.DHC_ICU_RecordLink
    where SourceRecord=:recordItemId and WardId=:wardId)
    &sql(open itemCursor)
    b //ccq
    set paraItemIDStr=""
    For
    {
	    &sql(Fetch itemCursor)
	    quit:SQLCODE'=0
	    set paraItemId=##class(web.DHCICUPara).AddPairItems(paraId,pairRecordItemId,"Y")
	    b //ccq2
	    set:(paraItemId'="")&(paraItemIDStr'="") paraItemIDStr=paraItemIDStr_"###"
	    set paraItemIDStr=paraItemIDStr_paraItemId
	}
	&sql(close itemCursor)
	quit paraItemIDStr
}

/// 批量保存导管维护记录
ClassMethod SaveCatheterDetails(paraStr As %String, userId As %String) As %String
{
	try
	{
		set saveResult="S^"
		tstart
		for i=1:1:$l(paraStr,$c(2))
		{
			set paraItemStr=$p(paraStr,$c(2),i)
			set rowId=$p(paraItemStr,$c(3),1)
			set catheterRecordID=$p(paraItemStr,$c(3),2)
			set itemName=$p(paraItemStr,$c(3),3)
			set itemValue=$p(paraItemStr,$c(3),4)
			set recordDT=$p(paraItemStr,$c(3),5)
			set saveResult=..SaveCatheterDetail(rowId,catheterRecordID,itemName,itemValue,recordDT,userId)
			quit:($p(saveResult,"^",1)'="S")
		}
		
		if ($p(saveResult,"^",1)'="S")
		{
			trollback
			return "E^导管维护记录保存失败，原因："_$p(saveResult,"^",2)	
		}
		
		tcommit
		return "S^"
	}
	catch exp
	{
		trollback
		return "E^导管维护记录保存失败，原因："_$ze	
	}
}

/// 保存导管维护记录
ClassMethod SaveCatheterDetail(rowId, catheterRecordID, itemName, itemValue, recordDT, userId) As %String
{
	quit:('##class(User.DHCICUCatheterRecord).%ExistsId(catheterRecordID)) "E^导管ID不能为空"
	quit:(itemName="") "E^记录项目不能为空"	
	quit:(itemValue="") "E^记录值不能为空"
	quit:(recordDT="") "E^记录时间不能为空"
	quit:('##class(User.SSUser).%ExistsId(userId)) "E^用户不存在"
	set recordDate=##class(web.DHCClinicCom).ConvertToDateH($p(recordDT," ",1),"")
	set recordTime=##class(web.DHCClinicCom).ConvertToTimeH($p(recordDT," ",2),"")
	quit:(+recordDate=0)!(+recordTime=0) "E^记录时间格式不正确"
	if (##class(User.DHCICUCatheterDetail).%ExistsId(rowId))
	{
		set catheterDetail=##class(User.DHCICUCatheterDetail).%OpenId(rowId)
	}
	else
	{
		set catheterDetail=##class(User.DHCICUCatheterDetail).%New()	
		set catheterDetail.CreateUser=userId
		set catheterDetail.CreateDate=+$h
		set catheterDetail.CreateTime=$p($h,",",1)
	}
	set catheterDetail.CatheterRecord=##class(User.DHCICUCatheterRecord).%OpenId(catheterRecordID)
	set catheterDetail.ItemName=itemName
	set catheterDetail.ItemValue=itemValue
	
	set catheterDetail.RecordDate=recordDate
	set catheterDetail.RecordTime=recordTime
	set catheterDetail.UpdateUser=userId
	set catheterDetail.UpdateDate=+$h
	set catheterDetail.UpdateTime=$p($h,",",2)
	set catheterDetail.EditFlag="N"
	set sc=catheterDetail.%Save()
	quit:($$$ISERR(sc)) "E^导管维护记录保存失败，原因："_$System.Status.GetErrorText(sc)
	quit "S^"_catheterDetail.%Id()
}

Query FindCatheterDetail(catheterRecordID) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	select RowId,
		   CatheterRecord As CatheterRecordID,
		   %ODBCOUT(RecordDate)_" "_%ODBCOUT(RecordTime) As RecordDT,
		   ItemName,
		   ItemValue,
		   CreateUser,
		   web.DHCICUCatheter_GetDescByID('User.SSUser','SSUSRName',CreateUser) As CreateUserDesc,
		   UpdateUser,
		   web.DHCICUCatheter_GetDescByID('User.SSUser','SSUSRName',UpdateUser) As UpdateUserDesc
		   from SQLUser.DHC_ICU_CatheterDetail
		   where CatheterRecord=:catheterRecordID
		   and EditFlag='N'
}

ClassMethod RemoveCatheterDetail(catheterDetailID, userId) As %String
{
	quit:('##class(User.DHCICUCatheterDetail).%ExistsId(catheterDetailID)) "E^导管维护记录ID不存在"
	quit:('##class(User.SSUser).%ExistsId(userId)) "E^用户ID不存在"
	set catheterDetail=##class(User.DHCICUCatheterDetail).%OpenId(catheterDetailID)
	set catheterDetail.EditFlag="D"
	set catheterDetail.UpdateDate=+$h
	set catheterDetail.UpdateTime=$p($h,",",2)
	set catheterDetail.UpdateUser=userId
	set sc=catheterDetail.%Save()
	quit:($$$ISERR(sc)) "E^导管维护记录删除失败，原因："_$System.Status.GetErrorText(sc)
	quit "S^"
}

ClassMethod RemoveCatheterParaItem(paraItemIdStr As %String) As %String
{
	set result="S^"
	for i=1:1:$l(paraItemIdStr,"###")
	{
		set paraItemId=$p(paraItemIdStr,"###",i)
		set paraItem=##class(User.DHCICUParaItem).%OpenId(paraItemId)
		set paraItem.ICUPIIsActive="N"
		set sc=paraItem.%Save()	
		set:($$$ISERR(sc)) result="E^删除导管关联项目【"_paraItem.ICUPIDesc_"】失败，原因："_$System.Status.GetErrorText(sc)
		quit:($p(result,"^",1)'="S")
	}	
	quit result
}

}
