/// 导管数据修改记录处理类
Class web.DHCICUCatheterDetailICU Extends %RegisteredObject
{

/// w ##class(web.DHCICUCatheterDetailICU).TestSaveCatheterRecord()
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
/// w ##class(web.DHCICUCatheterDetailICU).SaveCatheterRecord(8,$p(^TMPCCQ("ICUCatheter"),"###",2),22465)
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
	set saveObj.Position = $s(##class(User.DHCICUCCatheterPos).%ExistsId(savingData.Position):##class(User.DHCICUCCatheterPos).%OpenId(savingData.Position),1:"")
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
	if ('##class(User.DHCICUCatheterRecord).%ExistsId(savingData.RowId))&($isobject(catheter.RecordItem))
	{
		
		do ..CreateParaItemByCatheter(catheterRecordID)
	}
	set catheterRecord=##class(User.DHCICUCatheterRecord).%OpenId(catheterRecordID)
	if (catheterRecord.ParaItem'="")&(catheterRecord.ExtubateDate>=catheterRecord.IntubateDate)&(catheterRecord.ExtubateTime>=catheterRecord.IntubateTime)
	{
		
		do ..StopParaItemByCatheter(catheterRecord.ParaItem,catheterRecord.ExtubateDate,catheterRecord.ExtubateTime)	
	}
	quit result
}

/// 创建导管出量项目和评估项目，并将项目ID保存到导管记录中。
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
			set saveResult=..StartParaItemByCatheter(paraItemId,startDate,startTime)
			quit saveResult
		}
			
	}
	
	quit "S^"
}

/// 保存导管监护项的起始时间
ClassMethod StartParaItemByCatheter(paraItemIDStr As %String, startDate, startTime) As %String
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
		do ..StopParaItemByCatheter(record.ParaItem,+$h,$p($h,",",2))	
	}
	
	quit 0
}

/*
/// w ##class(web.DHCICUCatheterDetailICU).GetCatheterRecordByDate(138,"2021-08-23")
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
		do retArray.%Push(resCatheter)
	}
	&sql(close PrintCatheterCursor)
	quit retArray.%ToJSON()
}
*/
/// d ##class(%ResultSet).RunQuery("web.DHCICUCatheterDetailICU","FindCatheterRecord","8")
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
		Catheter->Description As CatheterDesc,
		%ODBCOUT(IntubateDate)_" "_%ODBCOUT(IntubateTime) As IntubateDT,
		%ODBCOUT(TakeInDate)_" "_%ODBCOUT(TakeInTime) As TakeInDT,
		%ODBCOUT(ExtubateDate)_" "_%ODBCOUT(ExtubateTime) As ExtubateDT,
		%ODBCOUT(CreateDate)_" "_%ODBCOUT(CreateTime) As CreateDT,
		%ODBCOUT(UpdateDate)_" "_%ODBCOUT(UpdateTime) As UpdateDT,
		web.DHCICUCatheterDetailICU_GetDescByID('User.SSUser','SSUSRName',CreateUser) As CreateUserName,
		web.DHCICUCatheterDetailICU_GetDescByID('User.SSUser','SSUSRName',UpdateUser) As UpdateUserName
	 from SQLUser.dhc_icu_catheterrecord
	 where Arrange=:icuaId
	 and ExtubateDate is NULL
	 and EditFlag='Normal'
	 order by IntubateDate,IntubateTime
}

/// d ##class(%ResultSet).RunQuery("web.DHCICUCatheterDetailICU","FindCatheterRecordOver","138")
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
		Catheter->Description As CatheterDesc,
		%ODBCOUT(IntubateDate)_" "_%ODBCOUT(IntubateTime) As IntubateDT,
		%ODBCOUT(TakeInDate)_" "_%ODBCOUT(TakeInTime) As TakeInDT,
		%ODBCOUT(ExtubateDate)_" "_%ODBCOUT(ExtubateTime) As ExtubateDT,
		%ODBCOUT(CreateDate)_" "_%ODBCOUT(CreateTime) As CreateDT,
		%ODBCOUT(UpdateDate)_" "_%ODBCOUT(UpdateTime) As UpdateDT,
		web.DHCICUCatheterDetailICU_GetDescByID('User.SSUser','SSUSRName',CreateUser) As CreateUserName,
		web.DHCICUCatheterDetailICU_GetDescByID('User.SSUser','SSUSRName',UpdateUser) As UpdateUserName
	 from SQLUser.dhc_icu_catheterrecord
	 where Arrange=:icuaId
	 and ((ExtubateDate<=+$h))
	 and EditFlag='Normal'
	 order by IntubateDate,IntubateTime
}

Query FindCatheterChange(icuaId, catheterRecordId = "") As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	select *,
		web.DHCICUCatheterDetailICU_GetDescByID('User.SSUser','SSUSRName',UpdateUser) As UpdateUserName,
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
/// w ##class(web.DHCICUCatheterDetailICU).ImportCatheterFromComOrd("Catheter")
/// w ##class(web.DHCICUCatheterDetailICU).ImportCatheterFromComOrd("Pipe")
/// w ##class(web.DHCICUCatheterDetailICU).ImportCatheterFromComOrd("DaoDGuanGNew")
/// w ##class(web.DHCICUCatheterDetailICU).ImportCatheterFromComOrd("YinYLiuLGuanGNew")
/// w ##class(web.DHCICUCatheterDetailICU).ImportCatheterFromComOrd("DaoDGuanGNICUNew")
/// w ##class(web.DHCICUCatheterDetailICU).ImportCatheterFromComOrd("YinYLiuLGuanGNICUNew")
/// w ##class(web.DHCICUCatheterDetailICU).ImportCatheterFromComOrd("DaoGuanPICU")
/// w ##class(web.DHCICUCatheterDetailICU).ImportCatheterFromComOrd("YinLiuLiangPICU")
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
    select LinkRecord into:pairRecordItemId
    from SQLUser.DHC_ICU_RecordLink
    where SourceRecord=:recordItemId and WardId=:wardId)
    &sql(open itemCursor)
    set paraItemIDStr=""
    For
    {
	    &sql(Fetch itemCursor)
	    quit:SQLCODE'=0
	    set paraItemId=##class(web.DHCICUPara).AddPairItems(paraId,pairRecordItemId)
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

/// w ##class(web.DHCICUCatheterDetailICU).SaveCatheterDetail(22960,"72","2021-08-28","12:00","hehe2^13^^^^^^^^^")
/// 保存导管维护记录New		ICU
ClassMethod SaveCatheterDetail(userId, catheterRecordID, Date, Time, Str) As %String
{
	quit:('##class(User.DHCICUCatheterRecord).%ExistsId(catheterRecordID)) "E^导管ID不能为空"
	quit:((Date="")||(Time="")) "E^记录时间不能为空"	

	quit:('##class(User.SSUser).%ExistsId(userId)) "E^用户不存在"
	set recordDate=##class(web.DHCClinicCom).ConvertToDateH(Date)
	set recordTime=##class(web.DHCClinicCom).ConvertToTimeH(Time)
	quit:(+recordDate=0)!(+recordTime=0) "E^记录时间格式不正确"
	
	
	set catheterDetail=##class(User.DHCICUCatheterDetailICU).%New()	
	set catheterDetail.CreateUser=userId
	set catheterDetail.CreateDate=+$h
	set catheterDetail.CreateTime=$p($h,",",1)
	
	set catheterDetail.RecordDate=recordDate
	set catheterDetail.RecordTime=recordTime
	
	set catheterDetail.CatheterRecord=##class(User.DHCICUCatheterRecord).%OpenId(catheterRecordID)
	set catheterDetail.ZhiGuanName=$p(Str,"^",1)
	set catheterDetail.ZhiGuanKeDu=$p(Str,"^",2)
	set catheterDetail.DaoGuanType=$p(Str,"^",3)
	
	set catheterDetail.ShuiZhuYaCha=$p(Str,"^",4)
	set catheterDetail.ShuiZhuBoDong=$p(Str,"^",5)
	set catheterDetail.FuYaXiYin=$p(Str,"^",6)
	set catheterDetail.QiPaoYiChu=$p(Str,"^",7)
	set catheterDetail.Note=$p(Str,"^",8)
	
	s YLCGQModifyD="",YLCGQModifyT=""
	if (($p(Str,"^",9)'="")&&($p(Str,"^",10)'=""))  d
	.b ;压力传感器
	.s YLCGQModifyD=##class(web.DHCClinicCom).ConvertToDateH($p(Str,"^",9))
	.s YLCGQModifyT=##class(web.DHCClinicCom).ConvertToTimeH($p(Str,"^",10))
	.q:(+YLCGQModifyD=0)!(+YLCGQModifyT=0)
	.set catheterDetail.YLCGQModifyDate=YLCGQModifyD
	.set catheterDetail.YLCGQModifyTime=YLCGQModifyT
	
	s ModifyFuLiaoD=""
	if ($p(Str,"^",11)'="")  d
	.s ModifyFuLiaoD=##class(web.DHCClinicCom).ConvertToDateH($p(Str,"^",11))
	.q:(+ModifyFuLiaoD=0)  
	.set catheterDetail.ModifyFuLiaoDate=ModifyFuLiaoD
	
	;set catheterDetail.UpdateUser=userId
	;set catheterDetail.UpdateDate=+$h
	;set catheterDetail.UpdateTime=$p($h,",",2)
	set catheterDetail.EditFlag="N"
	set sc=catheterDetail.%Save()
	quit "S^"_catheterDetail.%Id()
}

/// w ##class(web.DHCICUCatheterDetailICU).UpdateCatheterDetail(1,22960,"2021-08-28","12:00","hehe2^13^^^^^^^^^")
/// 保存导管维护记录New		ICU
ClassMethod UpdateCatheterDetail(rowId, userId, catheterRecordID, Date, Time, Str) As %String
{
	quit:((Date="")||(Time="")) "E^记录时间不能为空"	

	quit:('##class(User.SSUser).%ExistsId(userId)) "E^用户不存在"
	set recordDate=##class(web.DHCClinicCom).ConvertToDateH(Date)
	set recordTime=##class(web.DHCClinicCom).ConvertToTimeH(Time)
	quit:(+recordDate=0)!(+recordTime=0) "E^记录时间格式不正确"
	
	q:('##class(User.DHCICUCatheterDetailICU).%ExistsId(rowId)) "E^记录布裙在"
	
	set catheterDetail=##class(User.DHCICUCatheterDetailICU).%OpenId(rowId)

	;set catheterDetail.CreateUser=userId
	set catheterDetail.CreateDate=+$h
	set catheterDetail.CreateTime=$p($h,",",1)
	
	set catheterDetail.RecordDate=recordDate
	set catheterDetail.RecordTime=recordTime
	
	set catheterDetail.ZhiGuanName=$p(Str,"^",1)
	set catheterDetail.ZhiGuanKeDu=$p(Str,"^",2)
	set catheterDetail.DaoGuanType=$p(Str,"^",3)
	
	set catheterDetail.ShuiZhuYaCha=$p(Str,"^",4)
	set catheterDetail.ShuiZhuBoDong=$p(Str,"^",5)
	set catheterDetail.FuYaXiYin=$p(Str,"^",6)
	set catheterDetail.QiPaoYiChu=$p(Str,"^",7)
	set catheterDetail.Note=$p(Str,"^",8)
	
	s YLCGQModifyD="",YLCGQModifyT=""
	if (($p(Str,"^",9)'="")&&($p(Str,"^",10)'=""))  d
	.s YLCGQModifyD=##class(web.DHCClinicCom).ConvertToDateH($p(Str,"^",9))
	.s YLCGQModifyT=##class(web.DHCClinicCom).ConvertToTimeH($p(Str,"^",10))
	.q:(+YLCGQModifyD=0)!(+YLCGQModifyT=0)
	.set catheterDetail.YLCGQModifyDate=YLCGQModifyD
	.set catheterDetail.YLCGQModifyTime=YLCGQModifyT
	
	s ModifyFuLiaoD=""
	if ($p(Str,"^",11)'="")  d
	.s ModifyFuLiaoD=##class(web.DHCClinicCom).ConvertToDateH($p(Str,"^",11))
	.q:(+ModifyFuLiaoD=0)  
	.set catheterDetail.ModifyFuLiaoDate=ModifyFuLiaoD
	
	set catheterDetail.UpdateUser=userId
	set catheterDetail.UpdateDate=+$h
	set catheterDetail.UpdateTime=$p($h,",",2)
	set catheterDetail.EditFlag="N"
	set sc=catheterDetail.%Save()
	quit "S^"_catheterDetail.%Id()
}

/// d ##class(%ResultSet).RunQuery("web.DHCICUCatheterDetailICU","FindCatheterDetail","4")
Query FindCatheterDetailOld(catheterRecordID As %String) As %Query(ROWSPEC = "tRowId,tCatheterRecordID,tzhiGuan,tkeDu,tdGType,tshuiZhuYaCha,tshuiZhuBoDong,tfuYaXY,tqiPaoYC,ttextNote,tYaLiCGQDate,tYaLiCGQTime,tGengHuanFLDate,tRecordDate,tRecordTime,tCreatorUserDesc") [ SqlProc ]
{
}

ClassMethod FindCatheterDetailOldExecute(ByRef qHandle As %Binary, catheterRecordID As %String) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	
 	s RowId="" f  s RowId=$o(^User.DHCICUCatheterDetailICUI("ICatheterRecord",catheterRecordID,RowId)) q:RowId=""  d
 	.q:$d(^User.DHCICUCatheterDetailICUD(RowId))<1
 	.
 	.s zhiGuan="",keDu="",dGType="",shuiZhuYaCha="",shuiZhuBoDong=""
 	.s fuYaXY="",qiPaoYC="",textNote="",YaLiCGQDate="",YaLiCGQTime=""
    .s GengHuanFLDate=""
    .s RecordDate="",RecordTime=""
    .s CreatorUserId="",CreatorUserDesc=""
    .s EditFlag=$li(^User.DHCICUCatheterDetailICUD(RowId),21)
    .q:EditFlag'="N"
    .
    .s RecordDate=$li(^User.DHCICUCatheterDetailICUD(RowId),2)
    .i RecordDate'="" s RecordDate=##Class(web.DHCANOPCom).ConvertToDateH(RecordDate)
    .s RecordTime=$li(^User.DHCICUCatheterDetailICUD(RowId),3)
    .i RecordTime'="" s RecordTime=##Class(web.DHCANOPCom).ConvertToTimeH(RecordTime)
    .
    .s zhiGuan=$li(^User.DHCICUCatheterDetailICUD(RowId),4)
    .s keDu=$li(^User.DHCICUCatheterDetailICUD(RowId),5)
    .s dGType=$li(^User.DHCICUCatheterDetailICUD(RowId),6)
    .
    .s YaLiCGQDate=$li(^User.DHCICUCatheterDetailICUD(RowId),7)
    .i YaLiCGQDate'="" s YaLiCGQDate=##Class(web.DHCANOPCom).ConvertToDateH(YaLiCGQDate)
    .s YaLiCGQTime=$li(^User.DHCICUCatheterDetailICUD(RowId),8)
	.i YaLiCGQTime'="" s YaLiCGQTime=##Class(web.DHCANOPCom).ConvertToTimeH(YaLiCGQTime)
	.
    .s GengHuanFLDate=$li(^User.DHCICUCatheterDetailICUD(RowId),9)
    .i GengHuanFLDate'="" s GengHuanFLDate=##Class(web.DHCANOPCom).ConvertToDateH(GengHuanFLDate)
    .
    .s shuiZhuYaCha=$li(^User.DHCICUCatheterDetailICUD(RowId),10)
    .s shuiZhuBoDong=$li(^User.DHCICUCatheterDetailICUD(RowId),11)
    .s fuYaXY=$li(^User.DHCICUCatheterDetailICUD(RowId),12)
    .s qiPaoYC=$li(^User.DHCICUCatheterDetailICUD(RowId),13)
	.
	.s textNote=$li(^User.DHCICUCatheterDetailICUD(RowId),14)
	.s CreatorUserId=$li(^User.DHCICUCatheterDetailICUD(RowId),15)
	.i CreatorUserId'="" s CreatorUserDesc=$p(^SSU("SSUSR",CreatorUserId),"^",2) 
    .d OutputRowPatOld
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRowPatOld
	s Data=$lb(RowId,catheterRecordID,zhiGuan,keDu,dGType,shuiZhuYaCha,shuiZhuBoDong,fuYaXY,qiPaoYC,textNote,YaLiCGQDate,YaLiCGQTime,GengHuanFLDate,RecordDate,RecordTime,CreatorUserDesc)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindCatheterDetailOldFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCatheterDetailOldExecute ]
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

ClassMethod FindCatheterDetailOldClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCatheterDetailOldExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCICUCatheterDetailICU","FindCatheterDetail","72")
Query FindCatheterDetail(catheterRecordID As %String) As %Query(ROWSPEC = "tRowId,tCatheterRecordID,tzhiGuan,tkeDu,tdGType,tshuiZhuYaCha,tshuiZhuBoDong,tfuYaXY,tqiPaoYC,ttextNote,tYaLiCGQDate,tYaLiCGQTime,tGengHuanFLDate,tRecordDate,tRecordTime,tCreatorUserDesc") [ SqlProc ]
{
}

ClassMethod FindCatheterDetailExecute(ByRef qHandle As %Binary, catheterRecordID As %String) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	s cRecordRowID="" f  s cRecordRowID=$o(^User.DHCICUCatheterDetailICUI("ICatheterRecord",cRecordRowID)) q:cRecordRowID=""  d
 	.q:(catheterRecordID'=cRecordRowID)
 	.s RowId="" f  s RowId=$o(^User.DHCICUCatheterDetailICUI("ICatheterRecord",cRecordRowID,RowId)) q:RowId=""  d
 	..q:$d(^User.DHCICUCatheterDetailICUD(RowId))<1
 	..b ;1
 	..s zhiGuan="",keDu="",dGType="",shuiZhuYaCha="",shuiZhuBoDong=""
 	..s fuYaXY="",qiPaoYC="",textNote="",YaLiCGQDate="",YaLiCGQTime=""
    ..s GengHuanFLDate=""
    ..s RecordDate="",RecordTime=""
    ..s CreatorUserId="",CreatorUserDesc=""
    ..s EditFlag=$li(^User.DHCICUCatheterDetailICUD(RowId),21)
    ..q:EditFlag'="N"
    ..b ;11
    ..s RecordDate=$li(^User.DHCICUCatheterDetailICUD(RowId),2)
    ..i RecordDate'="" s RecordDate=##Class(web.DHCANOPCom).ConvertToDate(RecordDate)
    ..s RecordTime=$li(^User.DHCICUCatheterDetailICUD(RowId),3)
    ..i RecordTime'="" s RecordTime=##Class(web.DHCANOPCom).ConvertToTime(RecordTime)
    ..
    ..s zhiGuan=$li(^User.DHCICUCatheterDetailICUD(RowId),4)
    ..s keDu=$li(^User.DHCICUCatheterDetailICUD(RowId),5)
    ..s dGType=$li(^User.DHCICUCatheterDetailICUD(RowId),6)
    ..
    ..s YaLiCGQDate=$li(^User.DHCICUCatheterDetailICUD(RowId),7)
    ..i YaLiCGQDate'="" s YaLiCGQDate=##Class(web.DHCANOPCom).ConvertToDate(YaLiCGQDate)
    ..s YaLiCGQTime=$li(^User.DHCICUCatheterDetailICUD(RowId),8)
	..i YaLiCGQTime'="" s YaLiCGQTime=##Class(web.DHCANOPCom).ConvertToTime(YaLiCGQTime)
	..
    ..s GengHuanFLDate=$li(^User.DHCICUCatheterDetailICUD(RowId),9)
    ..i GengHuanFLDate'="" s GengHuanFLDate=##Class(web.DHCANOPCom).ConvertToDate(GengHuanFLDate)
    ..
    ..s shuiZhuYaCha=$li(^User.DHCICUCatheterDetailICUD(RowId),10)
    ..s shuiZhuBoDong=$li(^User.DHCICUCatheterDetailICUD(RowId),11)
    ..s fuYaXY=$li(^User.DHCICUCatheterDetailICUD(RowId),12)
    ..s qiPaoYC=$li(^User.DHCICUCatheterDetailICUD(RowId),13)
	..
	..s textNote=$li(^User.DHCICUCatheterDetailICUD(RowId),14)
	..s CreatorUserId=$li(^User.DHCICUCatheterDetailICUD(RowId),15)
	..i CreatorUserId'="" s CreatorUserDesc=$p($g(^SSU("SSUSR",CreatorUserId)),"^",2) 
	..b ;2
    ..d OutputRowPat
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRowPat
	s Data=$lb(RowId,cRecordRowID,zhiGuan,keDu,dGType,shuiZhuYaCha,shuiZhuBoDong,fuYaXY,qiPaoYC,textNote,YaLiCGQDate,YaLiCGQTime,GengHuanFLDate,RecordDate,RecordTime,CreatorUserDesc)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindCatheterDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCatheterDetailExecute ]
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

ClassMethod FindCatheterDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCatheterDetailExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// w ##class(web.DHCICUCatheterDetailICU).GetCellClickDetail(2)
/// 反选数据
ClassMethod GetCellClickDetail(RowId) As %String
{
	s zhiGuan="",keDu="",dGType="",shuiZhuYaCha="",shuiZhuBoDong="",fuYaXY="",qiPaoYC="",textNote="",YaLiCGQDate="",YaLiCGQTime=""
    s GengHuanFLDate="",RecordDate="",RecordTime="",CreatorUserId="",CreatorUserDesc=""
    s str=zhiGuan_"^"_keDu_"^"_dGType_"^"_shuiZhuYaCha_"^"_shuiZhuBoDong_"^"_fuYaXY_"^"_qiPaoYC_"^"_textNote_"^"_YaLiCGQDate_"^"_YaLiCGQTime
    	_"^"_GengHuanFLDate_"^"_RecordDate_"^"_RecordTime_"^"_CreatorUserDesc
    q:RowId="" str
    q:$d(^User.DHCICUCatheterDetailICUD(RowId))<1
    
	s RecordDate=$li(^User.DHCICUCatheterDetailICUD(RowId),2)
	i RecordDate'="" s RecordDate=##Class(web.DHCANOPCom).ConvertToDate(RecordDate)
	s RecordTime=$li(^User.DHCICUCatheterDetailICUD(RowId),3)
	i RecordTime'="" s RecordTime=##Class(web.DHCANOPCom).ConvertToTime(RecordTime)

	s zhiGuan=$li(^User.DHCICUCatheterDetailICUD(RowId),4)
	s keDu=$li(^User.DHCICUCatheterDetailICUD(RowId),5)
	s dGType=$li(^User.DHCICUCatheterDetailICUD(RowId),6)

	s YaLiCGQDate=$li(^User.DHCICUCatheterDetailICUD(RowId),7)
	i YaLiCGQDate'="" s YaLiCGQDate=##Class(web.DHCANOPCom).ConvertToDate(YaLiCGQDate)
	s YaLiCGQTime=$li(^User.DHCICUCatheterDetailICUD(RowId),8)
	i YaLiCGQTime'="" s YaLiCGQTime=##Class(web.DHCANOPCom).ConvertToTime(YaLiCGQTime)

	s GengHuanFLDate=$li(^User.DHCICUCatheterDetailICUD(RowId),9)
	i GengHuanFLDate'="" s GengHuanFLDate=##Class(web.DHCANOPCom).ConvertToDate(GengHuanFLDate)

	s shuiZhuYaCha=$li(^User.DHCICUCatheterDetailICUD(RowId),10)
	s shuiZhuBoDong=$li(^User.DHCICUCatheterDetailICUD(RowId),11)
	s fuYaXY=$li(^User.DHCICUCatheterDetailICUD(RowId),12)
	s qiPaoYC=$li(^User.DHCICUCatheterDetailICUD(RowId),13)

	s textNote=$li(^User.DHCICUCatheterDetailICUD(RowId),14)
	s CreatorUserId=$li(^User.DHCICUCatheterDetailICUD(RowId),15)
	i CreatorUserId'="" s CreatorUserDesc=$p($g(^SSU("SSUSR",CreatorUserId)),"^",2) 
	s str=zhiGuan_"^"_keDu_"^"_dGType_"^"_shuiZhuYaCha_"^"_shuiZhuBoDong
		_"^"_fuYaXY_"^"_qiPaoYC_"^"_textNote_"^"_YaLiCGQDate_"^"_YaLiCGQTime
		_"^"_GengHuanFLDate_"^"_RecordDate_"^"_RecordTime_"^"_CreatorUserDesc
    q str
}

ClassMethod RemoveCatheterDetail(RowId, userId) As %String
{
	quit:('##class(User.SSUser).%ExistsId(userId)) "E^用户ID不存在"
	quit:('##class(User.DHCICUCatheterDetailICU).%ExistsId(RowId)) "E^记录明细不存在"
	set catheterDetail=##class(User.DHCICUCatheterDetailICU).%OpenId(RowId)
	set catheterDetail.EditFlag="D"
	set catheterDetail.UpdateDate=+$h
	set catheterDetail.UpdateTime=$p($h,",",2)
	set catheterDetail.UpdateUser=userId
	set sc=catheterDetail.%Save()
	quit "S^"
}

/// 导管提醒
ClassMethod AlertCatheterDetail(icuaId As %String) As %String
{
	set retNGGJ=0,retNGRJ=0,retDMZG=0
	q:icuaId="" retNGGJ_"^"_retNGRJ_"^"_retDMZG
	s rowid="" f  s rowid=$o(^User.DHCICUCatheterRecordI("Arr",icuaId,rowid)) q:rowid=""  d
	.q:$d(^User.DHCICUCatheterRecordD(rowid))<1
	.s extuDate=$li(^User.DHCICUCatheterRecordD(rowid),13)
	.q:extuDate<=+$h
	.s intuDate=$li(^User.DHCICUCatheterRecordD(rowid),9)
	.s catheterRecordId=$li(^User.DHCICUCatheterRecordD(rowid),3)
	.i catheterRecordId=463  d
	..
	.
	quit retNGGJ_"^"_retNGRJ_"^"_retDMZG
}

/// w ##class(web.DHCICUCatheterDetailICU).GetCatheterRecordByDate(138,"2021-08-28")
/// w ##class(web.DHCICUCatheterDetailICU).GetCatheterRecordByDate(12,"2021-08-27","08:00")
/// w ##class(web.DHCICUCatheterDetailICU).GetCatheterRecordByDate(294,"2021-09-03","07:00")
ClassMethod GetCatheterRecordByDate(icuaId, printDate, baseTime As %String = "7:00", ctLoc = "") As %String
{
	quit:('##class(User.DHCICUArrange).%ExistsId(icuaId)) "E^重症监护记录ID不存在"
	quit:(printDate="") "E^打印日期不能为空"
	quit:(baseTime="") "E^每天第一个班次的开始时间不能为空"
	set ret=""
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
	//set retArray=##class(%DynamicArray).%New()
	set i=0
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
		set tbDate=catheterRecord.ExtubateDate,tbTime=catheterRecord.ExtubateTime
		continue:(tbDate>0)&(tbTime>0)&((printStartDateH>tbDate)||((printStartDateH=tbDate)&(tbTime<28800)))	///拔管之后过滤

		set i=i+1
		if (catheterRecord.CatheterDesc'=""){	///导管自定义项目名字存在CatheterDesc字段中，判断该字段是否为空进行获取 20211109ly
			set thisCatheter=i_"."_catheterRecord.CatheterDesc
		}
		else{
			set thisCatheter=i_"."_catheterRecord.Catheter.Description
		}
		if ((ctLoc=210)||(ctLoc=234)||(ctLoc=278)||(ctLoc=1220))	////icu科室只需要置管日期和拔管日期，不需要具体时间	20211109ly
		{
			set:(catheterRecord.IntubateDate>0)&(catheterRecord.IntubateTime>0) thisCatheter=thisCatheter_$c(3)_"置管时间:"_##class(web.DHCClinicCom).ConvertToDate(catheterRecord.IntubateDate)
		}
		else
		{
			set:(catheterRecord.IntubateDate>0)&(catheterRecord.IntubateTime>0) thisCatheter=thisCatheter_$c(3)_"置管时间:"_##class(web.DHCClinicCom).ConvertToDateTime(catheterRecord.IntubateDate,catheterRecord.IntubateTime,"")
		}
		set:(catheterRecord.TakeInDate>0)&(catheterRecord.TakeInTime>0) thisCatheter=thisCatheter_$c(3)_"带入时间:"_##class(web.DHCClinicCom).ConvertToDateTime(catheterRecord.TakeInDate,catheterRecord.TakeInTime,"")
		
		
		if (tbDate>0)&(tbTime>0)&(((printStartDateH=tbDate)&(tbTime>=28800))||((printStartDateH=tbDate-1)&(tbTime<28800)))	///根据拔管时间控制打印
		{
			if ((ctLoc=210)||(ctLoc=234)||(ctLoc=278)||(ctLoc=1220))	////icu科室只需要置管日期和拔管日期，不需要具体时间	20211109ly
			{
				 set thisCatheter=thisCatheter_$c(3)_"拔管时间:"_##class(web.DHCClinicCom).ConvertToDate(tbDate)
			}
			else
			{
				 set thisCatheter=thisCatheter_$c(3)_"拔管时间:"_##class(web.DHCClinicCom).ConvertToDateTime(tbDate,tbTime,"")
			}
		}

		;if (catheterRecord.Type'="") set thisCatheter=thisCatheter_$c(3)_"导管型号:"_catheterRecord.Type
		;if (catheterRecord.TotalLength'="") set thisCatheter=thisCatheter_$c(3)_"置管长度:"_catheterRecord.TotalLength_"cm"
		;if (catheterRecord.ExposedLenth'="") set thisCatheter=thisCatheter_$c(3)_"外露长度:"_catheterRecord.ExposedLenth_"cm"
		;if (catheterRecord.ExposedScale'="") set thisCatheter=thisCatheter_$c(3)_"外露刻度:"_catheterRecord.ExposedScale_"cm"
		;if (catheterRecord.MarkOnSkin'="") set thisCatheter=thisCatheter_$c(3)_"体表标志:"_catheterRecord.MarkOnSkin_"cm"
		;if (catheterRecord.TailPos'="") set thisCatheter=thisCatheter_$c(3)_"末端位置:"_catheterRecord.TailPos
		if (catheterRecord.AdjustDateTime'="") set thisCatheter=thisCatheter_$c(3)_"调整时间:"_catheterRecord.AdjustDateTime
		;if (catheterRecord.Note'="") set thisCatheter=thisCatheter_$c(3)_"备注:"_catheterRecord.Note
		if (catheterRecord.Position'="") set thisCatheter=thisCatheter_$c(3)_"置入位置:"_catheterRecord.Position
		
		;s catheterRecordDetail=..GetCathRecDetailByDateNew(RowId,printDate, baseTime,"")
		s catheterRecordDetail=..GetCathRecDetailByDate0915(RowId,printDate, baseTime,"")
		
		
		if (catheterRecordDetail'="") set thisCatheter=thisCatheter_$c(3)_catheterRecordDetail
		;if (catheterRecordDetail'="") set thisCatheter=thisCatheter_catheterRecordDetail
        if (ret="") set ret=thisCatheter
        else  set ret=ret_$c(3)_thisCatheter
		
	}
	&sql(close PrintCatheterCursor)
	
	quit ret
}

/// w ##class(web.DHCICUCatheterDetailICU).GetCatheterRecordDetailByDate(72,"2021-08-30","07:00","")
ClassMethod GetCatheterRecordDetailByDate(catheterRecordId, printDate, baseTime As %String = "7:00", ctLoc = "") As %String
{
	set printStartDateH=##class(web.DHCClinicCom).ConvertToDateH(printDate,"")
	set printStartTimeH=##class(web.DHCClinicCom).ConvertToTimeH(baseTime,"")
	s str=""
	s cRecordId="" f  s cRecordId=$o(^User.DHCICUCatheterDetailICUI("ICatheterRecord",cRecordId)) q:cRecordId=""  d
	.q:(cRecordId'=catheterRecordId)
	.s rowId="" f  s rowId=$o(^User.DHCICUCatheterDetailICUI("ICatheterRecord",cRecordId,rowId)) q:rowId=""  d
	..q:$d(^User.DHCICUCatheterDetailICUD(rowId))<1
	..s editFlag=$li(^User.DHCICUCatheterDetailICUD(rowId),21)
	..q:(editFlag'="N")
	..
	..s RecordDate=$li(^User.DHCICUCatheterDetailICUD(rowId),2)
	..s RecordTime=$li(^User.DHCICUCatheterDetailICUD(rowId),3)
	..;b ;01
	..q:((RecordDate>(printStartDateH+1))||((RecordDate=(printStartDateH+1))&&(RecordTime>=printStartTimeH)))
	..
	..s ZhiGuanName=$li(^User.DHCICUCatheterDetailICUD(rowId),4)
	..s ZhiGuanKeDu=$li(^User.DHCICUCatheterDetailICUD(rowId),5)
	..s str=ZhiGuanName_""_ZhiGuanKeDu
	q str
}

/// w ##class(web.DHCICUCatheterDetailICU).GetCathRecDetailByDate0915(72,"2021-08-28","07:00","")
/// w ##class(web.DHCICUCatheterDetailICU).GetCathRecDetailByDate0915(294,"2021-09-03","07:00","")
/// w ##class(web.DHCICUCatheterDetailICU).GetCathRecDetailByDate0915(547,"2021-09-15","07:00","")
ClassMethod GetCathRecDetailByDate0915(catheterRecordId, printDate, baseTime As %String = "7:00", ctLoc = "") As %String
{
	set printStartDateH=##class(web.DHCClinicCom).ConvertToDateH(printDate,"")
	set printStartTimeH=##class(web.DHCClinicCom).ConvertToTimeH(baseTime,"")
	s str=""
	s ZhiGuanType="",YLCGQModifyDate="",YLCGQModifyTime="",ModifyFuLiaoDate="",ShuiZhuYaCha=""
	s ShuiZhuBoDong="",FuYaXiYin="",QiPaoYiChu="",Note=""
	s Date="" f  s Date=$o(^User.DHCICUCatheterDetailICUI("IRecordDateTime",Date)) q:Date=""  d
	.s Time="" f  s Time=$o(^User.DHCICUCatheterDetailICUI("IRecordDateTime",Date,Time)) q:Time=""  d
	..
	..q:((Date>(printStartDateH+1))||((Date=(printStartDateH+1))&&(Time>=printStartTimeH)))
	..
	..s rowId="" f  s rowId=$o(^User.DHCICUCatheterDetailICUI("IRecordDateTime",Date,Time,rowId)) q:rowId=""  d
	...q:$d(^User.DHCICUCatheterDetailICUD(rowId))<1
	...s cRecordId=$li(^User.DHCICUCatheterDetailICUD(rowId),1)
	...q:(cRecordId'=catheterRecordId)
	...s editFlag=$li(^User.DHCICUCatheterDetailICUD(rowId),21)
	...q:(editFlag'="N")
	...
	...s RecordDate=$li(^User.DHCICUCatheterDetailICUD(rowId),2)
	...s RecordTime=$li(^User.DHCICUCatheterDetailICUD(rowId),3)
	...;q:((Date>(printStartDateH+1))||((Date=(printStartDateH+1))&&(Time>=printStartTimeH)))
	...;s str=$zd(Date,3)_" "_$zt(Time,2)
	...s ZhiGuanName=$li(^User.DHCICUCatheterDetailICUD(rowId),4)
	...s ZhiGuanKeDu=$li(^User.DHCICUCatheterDetailICUD(rowId),5)
	...if ((ZhiGuanName'="")&&(ZhiGuanKeDu'="")) s str=ZhiGuanName_""_ZhiGuanKeDu_"cm"
	...;s str=$zd(Date,3)_" "_$zt(Time,2)_" "_ZhiGuanName_""_ZhiGuanKeDu
	...s ZhiGuanType=$li(^User.DHCICUCatheterDetailICUD(rowId),6)
	...;i ZhiGuanType'=""  s str=str_$c(3)_"导管型号:"_ZhiGuanType
	...
	...s YLCGQModifyDate=$li(^User.DHCICUCatheterDetailICUD(rowId),7)
	...s YLCGQModifyTime=$li(^User.DHCICUCatheterDetailICUD(rowId),8)
	...;i ((YLCGQModifyDate'="")&&(YLCGQModifyTime'=""))  s str=str_$c(3)_"压力传感器更换时间:"_$zd(YLCGQModifyDate,3)_" "_$zt(YLCGQModifyTime,2)
	...;i ((YLCGQModifyDate'="")&&(YLCGQModifyTime'=""))  s str=str_$c(3)_"压力传感器更换时间:"_$zd(YLCGQModifyDate,3)
	...s ModifyFuLiaoDate=$li(^User.DHCICUCatheterDetailICUD(rowId),9)
	...;i ModifyFuLiaoDate'=""  s str=str_$c(3)_"更换敷料时间:"_$zd(ModifyFuLiaoDate,3)
	...s ShuiZhuYaCha=$li(^User.DHCICUCatheterDetailICUD(rowId),10)
	...;i ShuiZhuYaCha'=""  s str=str_$c(3)_"水柱压差:"_ShuiZhuYaCha
	...s ShuiZhuBoDong=$li(^User.DHCICUCatheterDetailICUD(rowId),11)
	...;i ShuiZhuBoDong'=""  s str=str_$c(3)_"水柱波动:"_ShuiZhuBoDong
	...s FuYaXiYin=$li(^User.DHCICUCatheterDetailICUD(rowId),12)
	...;i FuYaXiYin'=""  s str=str_$c(3)_"负压吸引:"_FuYaXiYin
	...s QiPaoYiChu=$li(^User.DHCICUCatheterDetailICUD(rowId),13)
	...;i QiPaoYiChu'=""  s str=str_$c(3)_"气泡逸出:"_QiPaoYiChu
	...s Note=$li(^User.DHCICUCatheterDetailICUD(rowId),14)
	...;i Note'=""  s str=str_$c(3)_"备注:"_Note
	
	i ZhiGuanType'=""  s str=str_$c(3)_"导管型号:"_ZhiGuanType
	i ((YLCGQModifyDate'="")&&(YLCGQModifyTime'=""))  s str=str_$c(3)_"压力传感器更换时间:"_$zd(YLCGQModifyDate,3)
	i ModifyFuLiaoDate'=""  s str=str_$c(3)_"更换敷料时间:"_$zd(ModifyFuLiaoDate,3)
	i ShuiZhuYaCha'=""  s str=str_$c(3)_"水柱压差:"_ShuiZhuYaCha
	i ShuiZhuBoDong'=""  s str=str_$c(3)_"水柱波动:"_ShuiZhuBoDong
	i FuYaXiYin'=""  s str=str_$c(3)_"负压吸引:"_FuYaXiYin
	i QiPaoYiChu'=""  s str=str_$c(3)_"气泡逸出:"_QiPaoYiChu
	i Note'=""  s str=str_$c(3)_"备注:"_Note
	
	q str
}

/// w ##class(web.DHCICUCatheterDetailICU).GetCathRecDetailByDateNew(72,"2021-08-28","07:00","")
/// w ##class(web.DHCICUCatheterDetailICU).GetCathRecDetailByDateNew(294,"2021-09-03","07:00","")
/// w ##class(web.DHCICUCatheterDetailICU).GetCathRecDetailByDateNew(547,"2021-09-15","07:00","")
ClassMethod GetCathRecDetailByDateNew(catheterRecordId, printDate, baseTime As %String = "7:00", ctLoc = "") As %String
{
	set printStartDateH=##class(web.DHCClinicCom).ConvertToDateH(printDate,"")
	set printStartTimeH=##class(web.DHCClinicCom).ConvertToTimeH(baseTime,"")
	s str=""
	
	s Date="" f  s Date=$o(^User.DHCICUCatheterDetailICUI("IRecordDateTime",Date)) q:Date=""  d
	.s Time="" f  s Time=$o(^User.DHCICUCatheterDetailICUI("IRecordDateTime",Date,Time)) q:Time=""  d
	..
	..q:((Date>(printStartDateH+1))||((Date=(printStartDateH+1))&&(Time>=printStartTimeH)))
	..
	..s rowId="" f  s rowId=$o(^User.DHCICUCatheterDetailICUI("IRecordDateTime",Date,Time,rowId)) q:rowId=""  d
	...q:$d(^User.DHCICUCatheterDetailICUD(rowId))<1
	...s cRecordId=$li(^User.DHCICUCatheterDetailICUD(rowId),1)
	...q:(cRecordId'=catheterRecordId)
	...s editFlag=$li(^User.DHCICUCatheterDetailICUD(rowId),21)
	...q:(editFlag'="N")
	...
	...s RecordDate=$li(^User.DHCICUCatheterDetailICUD(rowId),2)
	...s RecordTime=$li(^User.DHCICUCatheterDetailICUD(rowId),3)
	...;q:((Date>(printStartDateH+1))||((Date=(printStartDateH+1))&&(Time>=printStartTimeH)))
	...;s str=$zd(Date,3)_" "_$zt(Time,2)
	...s ZhiGuanName=$li(^User.DHCICUCatheterDetailICUD(rowId),4)
	...s ZhiGuanKeDu=$li(^User.DHCICUCatheterDetailICUD(rowId),5)
	...if ((ZhiGuanName'="")&&(ZhiGuanKeDu'="")) s str=ZhiGuanName_""_ZhiGuanKeDu_"cm"
	...;s str=$zd(Date,3)_" "_$zt(Time,2)_" "_ZhiGuanName_""_ZhiGuanKeDu
	...s ZhiGuanType=$li(^User.DHCICUCatheterDetailICUD(rowId),6)
	...i ZhiGuanType'=""  s str=str_$c(3)_"导管型号:"_ZhiGuanType
	...
	...s YLCGQModifyDate=$li(^User.DHCICUCatheterDetailICUD(rowId),7)
	...s YLCGQModifyTime=$li(^User.DHCICUCatheterDetailICUD(rowId),8)
	...;i ((YLCGQModifyDate'="")&&(YLCGQModifyTime'=""))  s str=str_$c(3)_"压力传感器更换时间:"_$zd(YLCGQModifyDate,3)_" "_$zt(YLCGQModifyTime,2)
	...i ((YLCGQModifyDate'="")&&(YLCGQModifyTime'=""))  s str=str_$c(3)_"压力传感器更换时间:"_$zd(YLCGQModifyDate,3)
	...s ModifyFuLiaoDate=$li(^User.DHCICUCatheterDetailICUD(rowId),9)
	...i ModifyFuLiaoDate'=""  s str=str_$c(3)_"更换敷料时间:"_$zd(ModifyFuLiaoDate,3)
	...s ShuiZhuYaCha=$li(^User.DHCICUCatheterDetailICUD(rowId),10)
	...i ShuiZhuYaCha'=""  s str=str_$c(3)_"水柱压差:"_ShuiZhuYaCha
	...s ShuiZhuBoDong=$li(^User.DHCICUCatheterDetailICUD(rowId),11)
	...i ShuiZhuBoDong'=""  s str=str_$c(3)_"水柱波动:"_ShuiZhuBoDong
	...s FuYaXiYin=$li(^User.DHCICUCatheterDetailICUD(rowId),12)
	...i FuYaXiYin'=""  s str=str_$c(3)_"负压吸引:"_FuYaXiYin
	...s QiPaoYiChu=$li(^User.DHCICUCatheterDetailICUD(rowId),13)
	...i QiPaoYiChu'=""  s str=str_$c(3)_"气泡逸出:"_QiPaoYiChu
	...s Note=$li(^User.DHCICUCatheterDetailICUD(rowId),14)
	...i Note'=""  s str=str_$c(3)_"备注:"_Note
	q str
}

/// w ##class(web.DHCICUCatheterDetailICU).GetCathRecDetailByDateNew2(72,"2021-08-30","07:00","")
ClassMethod GetCathRecDetailByDateNew2(catheterRecordId, printDate, baseTime As %String = "7:00", ctLoc = "") As %String
{
	set printStartDateH=##class(web.DHCClinicCom).ConvertToDateH(printDate,"")
	set printStartTimeH=##class(web.DHCClinicCom).ConvertToTimeH(baseTime,"")
	s str=""
	
	s Date="" f  s Date=$o(^User.DHCICUCatheterDetailICUI("IRecordDateTime",Date)) q:Date=""  d
	.s Time="" f  s Time=$o(^User.DHCICUCatheterDetailICUI("IRecordDateTime",Date,Time)) q:Time=""  d
	..
	..q:((Date>(printStartDateH+1))||((Date=(printStartDateH+1))&&(Time>=printStartTimeH)))
	..if (((Date=printStartDateH)&&(Time>=printStartTimeH))||((Date=(printStartDateH+1))&&(Time<printStartTimeH)))  d
	...;b ;1
	...s rowId="" f  s rowId=$o(^User.DHCICUCatheterDetailICUI("IRecordDateTime",Date,Time,rowId)) q:rowId=""  d
	....q:$d(^User.DHCICUCatheterDetailICUD(rowId))<1
	....s cRecordId=$li(^User.DHCICUCatheterDetailICUD(rowId),1)
	....q:(cRecordId'=catheterRecordId)
	....s editFlag=$li(^User.DHCICUCatheterDetailICUD(rowId),21)
	....q:(editFlag'="N")
	....
	....s RecordDate=$li(^User.DHCICUCatheterDetailICUD(rowId),2)
	....s RecordTime=$li(^User.DHCICUCatheterDetailICUD(rowId),3)
	....;q:((Date>(printStartDateH+1))||((Date=(printStartDateH+1))&&(Time>=printStartTimeH)))
	....
	....s ZhiGuanName=$li(^User.DHCICUCatheterDetailICUD(rowId),4)
	....s ZhiGuanKeDu=$li(^User.DHCICUCatheterDetailICUD(rowId),5)
	....i str="" s str=$zd(Date,3)_" "_$zt(Time,2)_" "_ZhiGuanName_""_ZhiGuanKeDu
	....else  s str=str_$C(3)_$zd(Date,3)_" "_$zt(Time,2)_" "_ZhiGuanName_""_ZhiGuanKeDu
	..
	..else  d
	...;b ;2
	...s rowId="" f  s rowId=$o(^User.DHCICUCatheterDetailICUI("IRecordDateTime",Date,Time,rowId)) q:rowId=""  d
	....q:$d(^User.DHCICUCatheterDetailICUD(rowId))<1
	....s cRecordId=$li(^User.DHCICUCatheterDetailICUD(rowId),1)
	....q:(cRecordId'=catheterRecordId)
	....s editFlag=$li(^User.DHCICUCatheterDetailICUD(rowId),21)
	....q:(editFlag'="N")
	....
	....s RecordDate=$li(^User.DHCICUCatheterDetailICUD(rowId),2)
	....s RecordTime=$li(^User.DHCICUCatheterDetailICUD(rowId),3)
	....;q:((Date>(printStartDateH+1))||((Date=(printStartDateH+1))&&(Time>=printStartTimeH)))
	....
	....s ZhiGuanName=$li(^User.DHCICUCatheterDetailICUD(rowId),4)
	....s ZhiGuanKeDu=$li(^User.DHCICUCatheterDetailICUD(rowId),5)
	....if ((ZhiGuanName'="")&&(ZhiGuanKeDu'="")) s str=$zd(Date,3)_" "_$zt(Time,2)_" "_ZhiGuanName_""_ZhiGuanKeDu
	....;s str=$zd(Date,3)_" "_$zt(Time,2)_" "_ZhiGuanName_""_ZhiGuanKeDu
	....s ZhiGuanType=$li(^User.DHCICUCatheterDetailICUD(rowId),6)
	....i ZhiGuanType'=""  s str=str_" "_"类型:"_ZhiGuanType
	....
	....s YLCGQModifyDate=$li(^User.DHCICUCatheterDetailICUD(rowId),7)
	....s YLCGQModifyTime=$li(^User.DHCICUCatheterDetailICUD(rowId),8)
	....i ((YLCGQModifyDate'="")&&(YLCGQModifyTime'=""))  s str=str_" "_"压力传感器更换时间:"_$zd(YLCGQModifyDate,3)_" "_$zt(YLCGQModifyTime,2)
	q str
}

/// w ##class(web.DHCICUCatheterDetailICU).test()
ClassMethod test() As %String
{
	;k ^User.DHCICUCatheterDetailICUI
	;k ^User.DHCICUCatheterDetailICUD
	q "test"
}

/// w ##class(web.DHCICUCatheterDetailICU).test1()
ClassMethod test1(Num As %String) As %String
{
	if +Num
	{
		w "IF:"_Num,!
		b ;1
	}
	else
	{
		w "ELSE:"_Num,!
		b ;2
	}
	q "test"
}

}
