Class CIS.AN.BL.OperCareData Extends %RegisteredObject
{

/// w ##class(CIS.AN.BL.OperCareData).FindCareDataList(2962)
ClassMethod FindCareDataList(recordSheetId As %String) As %String
{
  &sql(declare CareDataCursor cursor for select %ID
		into :RowId from CIS_AN.OperCareData 
		where RecordSheet=:recordSheetId and EditFlag<>'D')
	&sql(open CareDataCursor)
  set jsonDataList = ##class(%DynamicArray).%New()
  for
  {
    &sql(fetch CareDataCursor)
    quit:(SQLCODE'=0)
    set careData = ##class(CIS.AN.OperCareData).%OpenId(RowId)
    set jsonData = ##class(%DynamicObject).%New()
    set jsonData.RowId = RowId
    set jsonData.RecordSheet = recordSheetId
    set jsonData.HR = careData.HR
    set jsonData.Resp = careData.Resp
    set jsonData.NBP = careData.NBP
    //set jsonData.NBPD = careData.NBPD
    set jsonData.ABP = careData.ABP
    //set jsonData.ABPD = careData.ABPD
    set jsonData.SPO2 = careData.SPO2
    set jsonData.Medication = careData.Medication
    set jsonData.Illness = careData.Illness  
    set jsonData.StartDT = ##class(CIS.AN.COM.DateTime).ConvertToDateTime(careData.StartDate,careData.StartTime,"")
    set jsonData.StartTime = $zt(careData.StartTime,2)
    set jsonData.EndDT = ##class(CIS.AN.COM.DateTime).ConvertToDateTime(careData.EndDate,careData.EndTime,"")
    set jsonData.EditFlag = careData.EditFlag
    set jsonData.UpdateUser = careData.UpdateUser
    set jsonData.UpdateUserDesc = ##class(CIS.AN.COM.String).GetDescByID("User.SSUser","SSUSRName",careData.UpdateUser)
    do jsonDataList.%Push(jsonData)
  }
  quit jsonDataList.%ToJSON()
}

/// w ##class(CIS.AN.BL.OperCareData).SaveCareData(^TMPYGB("SaveCareData"))
ClassMethod SaveCareData(careDataStr As %String) As %String
{
  set ^TMPYGB("SaveCareData")=careDataStr
  set sc=##class(CIS.AN.COM.String).ToArray(careDataStr,.array)
  m firstData=array(1)
	set:$get(firstData("RecordSheet"))'="" recordSheetId=firstData("RecordSheet")
	if (##class(CIS.AN.RecordSheet).%ExistsId(recordSheetId)=0)
	{
		trollback
		quit "E^"_recordSheetId	
	}
	set recordSheet=##class(CIS.AN.RecordSheet).%OpenId(recordSheetId)
	set opsId=recordSheet.OperSchedule.%Id()
	
	set dataIndex=0,saveResult="",packNo=""
	for
	{
		set dataIndex=$order(array(dataIndex))
		quit:(dataIndex="")
		m careData=array(dataIndex)
		set careData("RecordSheet")=recordSheetId
		set saveResult=##class(CIS.AN.COM.DataService).SaveData(.careData)
		quit:($piece(saveResult,"^",1)'="S")
	}
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult	
	}
	quit saveResult	
  /*
  set jsonData = ##class(%DynamicObject).%FromJSON(careDataStr)
  set careData = ""
  if (##class(CIS.AN.OperCareData).%ExistsId(jsonData.RowId))
  {
    set careData = ##class(CIS.AN.OperCareData).%OpenId(jsonData.RowId)
  }
  else
  {
    set careData = ##class(CIS.AN.OperCareData).%New()
  }
  set careData.RecordSheet = ##class(CIS.AN.RecordSheet).%OpenId(jsonData.RecordSheet)
  set careData.HR = jsonData.HR
  set careData.Resp = jsonData.Resp
  set careData.NBP = jsonData.NBP
  //set careData.NBPD = jsonData.NBPD
  set careData.ABP = jsonData.ABP
  //set careData.ABPD = jsonData.ABPD
  set careData.SPO2 = jsonData.SPO2
  set careData.Medication = jsonData.Medication
  set careData.Illness = jsonData.Illness
  set careData.StartDate = ##class(CIS.AN.COM.DateTime).ConvertToDateH(jsonData.StartDate,"")
  set careData.StartTime = ##class(CIS.AN.COM.DateTime).ConvertToTimeH(jsonData.StartTime,"")
  set careData.EndDate = ##class(CIS.AN.COM.DateTime).ConvertToDateH(jsonData.EndDate,"")
  set careData.EndTime = ##class(CIS.AN.COM.DateTime).ConvertToTimeH(jsonData.EndTime,"")
  set careData.UpdateUser = jsonData.UpdateUser
  set careData.UpdateDate = +$h
  set careData.UpdateTime = $p($h,",",2)
  set careData.EditFlag = "N"
  set sc = careData.%Save()
  quit:($System.Status.IsError(sc)) "E^"_$System.Status.GetErrorText(sc)
  quit "S^"_careData.%Id()*/
}

ClassMethod DelCareData(careDataId As %String) As %String
{
  quit:(##class(CIS.AN.OperCareData).%ExistsId(careDataId)=0) "E^不存在ID为"_careDataId_"的术中护理数据。"
  set sc = ##class(CIS.AN.OperCareData).%DeleteId(careDataId)
  quit:($SYSTEM.Status.IsError(sc)) "E^"_$SYSTEM.Status.GetErrorText(sc)
  quit "S^"
}

/// w ##class(CIS.AN.BL.OperCareData).SyncCollectData(2962,1,"2020-06-05 16:01","2020-06-05 17:01",15)
ClassMethod SyncCollectData(RecordsheetId As %String, operRoomId As %String, SynSTDT As %String, SynEndDT As %String, Interval As %String = "15") As %String
{
  set StartDate = ##class(CIS.AN.COM.DateTime).ConvertToDateH($P(SynSTDT," ",1))
  set StartTime = ##class(CIS.AN.COM.DateTime).ConvertToTimeH($P(SynSTDT," ",2))
  set EndDate = ##class(CIS.AN.COM.DateTime).ConvertToDateH($P(SynEndDT," ",1))
  set EndTime = ##class(CIS.AN.COM.DateTime).ConvertToTimeH($P(SynEndDT," ",2))
  quit:(StartDate>EndDate)||((StartDate=EndDate)&&(StartTime>=EndTime)) "结束时间不能大于开始时间"
  set date=StartDate
  set time=StartTime
  q:(##class(CIS.AN.RecordSheet).%ExistsId(RecordsheetId)=0) "表单不存在"
  set recordSheet=##class(CIS.AN.RecordSheet).%OpenId(RecordsheetId)
  for
  {
	  set time=time+(Interval*60)
	  if (time>86399) 
	  {
		  set date=date+1
		  set time=time-86399
	  }
	  quit:(time>EndTime)&&(date=EndDate)
	  set equipId=""
      set careDataId=..JudgeIfInData(RecordsheetId,date,time)
	  continue:careDataId'=""
	  set NDBP="",NSBP="",ADBP="",ASBP=""
	  set HR="",SPO2="",Resp=""
	  for
	  {
		set equipId=$O(^CF.AN.DeptEquipI("ILoc",operRoomId,equipId))
		quit:equipId=""
		set value=##class(CIS.AN.BL.CollectData).GetProximateValue(equipId,"HR",date,time)
		if (value'="") set HR=value
		set value=##class(CIS.AN.BL.CollectData).GetProximateValue(equipId,"SpO2",date,time)
		if (value'="") set SPO2=value
		set value=##class(CIS.AN.BL.CollectData).GetProximateValue(equipId,"RR",date,time)
		if (value'="") set Resp=value
		set value=##class(CIS.AN.BL.CollectData).GetProximateValue(equipId,"N_DIA",date,time)
		if (value'="") set NDBP=value
		set value=##class(CIS.AN.BL.CollectData).GetProximateValue(equipId,"N_SYS",date,time)
		if (value'="") set NSBP=value
		set value=##class(CIS.AN.BL.CollectData).GetProximateValue(equipId,"A_DIA",date,time)
		if (value'="") set ADBP=value
		set value=##class(CIS.AN.BL.CollectData).GetProximateValue(equipId,"A_SYS",date,time)
		if (value'="") set ASBP=value
		//if ((HR'="")||(SPO2'="")||(Resp'="")||(NDBP'="")||(NSBP'="")||(ADBP'="")||(ASBP'="")) b ;0082
	  }
	  continue:(HR="")&&(SPO2="")&&(Resp="")&&(NDBP="")&&(NSBP="")&&(ADBP="")&&(ASBP="")
	  b ;0087
	  set careData = ##class(CIS.AN.OperCareData).%New()
	  set careData.RecordSheet=recordSheet
	  set careData.HR=HR
	  set careData.Resp=Resp
	  set careData.SPO2=SPO2
	  set careData.StartDate=date
	  set careData.StartTime=time
	  if (NDBP'="")&&(NSBP'="") set careData.NBP=NDBP_"/"_NSBP
	  if (ADBP'="")&&(ASBP'="") set careData.ABP=ADBP_"/"_ASBP
	  set careData.UpdateDate = +$h
  	  set careData.UpdateTime = $p($h,",",2)
  	  set careData.EditFlag = "N"
  	  set sc = careData.%Save()
  	  continue:($System.Status.IsError(sc))
  }
  quit "S^"
}

ClassMethod JudgeIfInData(recordSheetId, date, time)
{
	set RowId=""
	&sql(select %ID into :RowId from CIS_AN.OperCareData 
		where RecordSheet=:recordSheetId and EditFlag<>'D' and StartDate=:date and StartTime=:time)
	quit RowId
}

}
