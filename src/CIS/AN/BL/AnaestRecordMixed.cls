/// 麻醉记录业务逻辑类, 麻醉记录单上共同显示麻醉恢复数据
/// 重载几个查询方法
Class CIS.AN.BL.AnaestRecordMixed Extends %RegisteredObject
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
Query FindTimeLines(sheetId As %String, opsId As %String = "") As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT *,
	%ODBCOUT(StartDate) As StartDate,
	%ODBCOUT(StartTime) As StartTime,
	%ODBCOUT(EndDate) As EndDate,
	%ODBCOUT(EndTime) As EndTime,
	%ODBCOUT(StartDate)_" "_%ODBCOUT(StartTime) As StartDT,
	%ODBCOUT(EndDate)_" "_%ODBCOUT(EndTime) As EndDT
	from CIS_AN.TimeLine where ((:opsId is null and RecordSheet=:sheetId) or (:opsId is not null and RecordSheet->OperSchedule=:opsId))
}

/// Creator：      	陈长青
/// CreatDate：    	2017-10-11
/// Description： 	查询麻醉记录数据
/// Table：        	DHCAN.RecordData
/// Input:			opsId:手术计划ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.AnaestRecord","FindSheetRecords","1","N")
Query FindAnaDatas(sheetId As %String, editFlag As %String = "", opsId As %String = "") As %SQLQuery(CONTAINID = 1) [ SqlProc ]
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
	   CIS_AN_COM.String_GetDescByID('User.CTCareProv','CTPCPDesc',SignNurse,'Y') As SignNurseDesc,
	   ParaItem->RecordSheet As RecordSheet
	   from CIS_AN.AnaData 
       where ((:opsId is null and ParaItem->RecordSheet=:sheetId) or (:opsId is not null and ParaItem->RecordSheet->OperSchedule=:opsId))
       and (EditFlag=:editFlag or :editFlag is null)
       --and CIS_AN_BL.AnaestRecord_VitalSignVisible(ParaItem->RecordSheet->OperSchedule,ParaItem->RecordSheet,StartDate,StartTime,DataItem->Code)='Y'
       order by StartDate,StartTime
}

/// Creator：      	陈长青
/// CreatDate：    	2017-11-7
/// Description： 	查询麻醉记录数据
/// Table：        	DHCAN.DrugData
/// Input:			opsId:手术计划ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.AnaestRecord","FindDrugDatas","1","N")
Query FindDrugDatas(sheetId As %String, editflag As %String = "", categoryCode As %String = "", opsId As %String = "") As %SQLQuery(CONTAINID = 1) [ SqlProc ]
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
       where ((:opsId is null and AnaData->ParaItem->RecordSheet=:sheetId) or (:opsId is not null and AnaData->ParaItem->RecordSheet->OperSchedule=:opsId))
       and (AnaData->EditFlag=:editflag or :editflag is null)
       and (:categoryCode is null or AnaData->ParaItem->CategoryItem->DataCategory->Code=:categoryCode or AnaData->ParaItem->DataCategory->Code=:categoryCode)
}

/// Creator：      	陈长青
/// CreatDate：    	2017-11-29
/// Description： 	查询麻醉记录事件明细数据
/// Table：        	DHCAN.EventData
/// Input:			opsId:手术计划ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.AnaestRecord","FindEventDatas","1","N")
Query FindEventDatas(sheetId As %String, editFlag As %String = "", opsId As %String = "") As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT *,
	   EventDetailItem->Description As Description,
	   EventDetailItem->Unit As Unit,
	   ChargeDetail->ChargeRecord As ChargeRecord
	   from CIS_AN.EventData 
       where ((:opsId is null and AnaData->ParaItem->RecordSheet=:sheetId) or (:opsId is not null and AnaData->ParaItem->RecordSheet->OperSchedule=:opsId))
       and (AnaData->EditFlag=:editflag or :editflag is null)
}

/// Creator：      	陈长青
/// CreatDate：    	2017-2-15
/// Description： 	查询麻醉记录参数
/// Table：        	DHCAN.RecordPara
/// Input:			opsId:手术明细ID，moduleId:
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.DataQueries","FindParaItems","807")
Query FindParaItems(sheetId As %String, opsId As %String = "") As %SQLQuery(CONTAINID = 1)
{
SELECT a.RowId As RowId,
	   a.RecordSheet As RecordSheet,
	   a.Code As Code,
	   a.Description As Description,
	   a.CategoryItem As CategoryItem,
	   a.CategoryItem->DataItem As DataItem,
	   a.CategoryItem->DataItem->ItemCategory As ItemCategory,
	   a.DataCategory As DataCategory,
	   a.DataCategory->Code As DataCategoryCode,
	   a.DataCategory->MainCategory As MainDataCategory,
	   a.Seq As Seq,
	   a.UserDefinedItem As UserDefinedItem,
	   b.Unit As Unit,
	   b.Unit -> Description As UnitDesc,
	   b.DoseUnitVisible As DoseUnitVisible,
	   b.SpeedUnitVisible As SpeedUnitVisible,
	   b.ConcentrationVisible As ConcentrationVisible,
	   b.BloodType As BloodType,
	   b.SuspendCollect As SuspendCollect,
	   b.AutoGenerate As AutoGenerate,
	   b.DefaultValue As DefaultValue,
	   CIS_AN_COM.String_PatchFloat(b.Concentration) As Concentration,
	   b.ConcentrationUnit As ConcentrationUnit,
	   b.ConcentrationUnit->Description As ConcentrationUnitDesc,
	   b.Continuous As Continuous,
	   b.Note As Note,
	   b.Duration As Duration,
	   b.Instruction As Instruction,
	   b.Instruction->Description As InstructionDesc,
	   b.InstructionVisible As InstructionVisible
	   from CIS_AN.ParaItem As a 
	   left join CIS_AN.ParaItemAttr As b 
	   on b.ParaItem = a.RowId 
	   where (:opsId is null and RecordSheet=:sheetId) or (:opsId is not null and RecordSheet->OperSchedule=:opsId)
	   order by Seq
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
	
	// 回写旧表 CCQ20200402
	set saveResult=##class(CIS.AN.SRV.OperAppService).StartPACURecord(operSchedule("RowId"),"")
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult		
	}
	
	tcommit
	
	do ##class(CIS.AN.BL.PACURecord).CreatePACURecord(operSchedule("RowId"))
	do ##class(CIS.AN.BL.AnaestRecord).AutoCreateParaItem(operSchedule("RowId"))
	do ..AutoCreateDeviceUsage(operSchedule("RowId"),operSchedule("UpdateUser"),operSchedule("PACUInDT"))
	do ##class(CIS.AN.BL.AnaestRecord).AutoCreateEvent(operSchedule("RowId"),operSchedule("UpdateUser"),operSchedule("PACUInDT"),"PACUIn")
	
	quit "S^"
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
	set pacuBed = operSchedule.PACUBed
	quit:pacuBed=""
	
	set moduleCode = "AnaestRecord"
	set recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCode(opsId,moduleCode,"")
	
	;set anDeptId = "116"
	set anDeptId=##class(CIS.AN.BL.DataConfiguration).GetValueByKey("ANDEPT")
	set devices=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.ConfigQueries:FindDeptEquipAN",anDeptId,pacuBed.%Id(),"")
	
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
ClassMethod StopRecord(data As %String) As %String
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
	
	do ##class(CIS.AN.BL.AnaestRecord).StopAllContinuousData(operSchedule("RowId"),operSchedule("PACUOutDT"))
	do ##class(CIS.AN.BL.AnaestRecord).StopAllDeviceUsage(operSchedule("RowId"),operSchedule("PACUOutDT"))
	do ##class(CIS.AN.BL.AnaestRecord).AutoCreateEvent(operSchedule("RowId"),operSchedule("UpdateUser"),operSchedule("PACUOutDT"),"PACUOut")
	do ##class(CIS.AN.BL.AnaestRecord).SubmitRecord(operSchedule("RowId"),operSchedule("UpdateUser"))
	
	quit "S^"
}

}
