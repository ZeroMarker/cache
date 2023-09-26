/// 手术麻醉通用数据业务处理类
Class CIS.AN.BL.OperData Extends %RegisteredObject
{

/// Creator：      	陈长青
/// CreatDate：    	2018-1-11
/// Description： 	保存手术记录数据
/// Table：        	DHCAN.OperData  DHCAN.RecordSheet
/// Input:			opsId:手术ID，moduleCode:模块代码，userId:用户ID，dataPara:数据
/// Return：       	保存成功返回"S^"，失败返回"E^原因"
/// Debug:			w ##class(CIS.AN.BL.OperData).SaveOperDatas("^tangxiao20180912")
/// Debug:			w ##class(CIS.AN.BL.OperData).SaveOperDatas(^TMPCCQ("SaveOperDatas","DataPara"),^TMPCCQ("SaveOperDatas","ExtDataPara"))
ClassMethod SaveOperDatas(dataPara As %String, extDataPara As %String = "") As %String
{
	s ^TMPCCQ("SaveOperDatas","DataPara")=dataPara
	s ^TMPCCQ("SaveOperDatas","ExtDataPara")=extDataPara
	set $zt="Error"
	set sc=##class(CIS.AN.COM.String).ToArray(dataPara,.array)
	m firstData=array(1)
	set moduleCode=$g(firstData("ModuleCode"))
	;m ^tangxiao20180912=array
	set moduleQuery=##class(%ResultSet).%New("CIS.AN.BL.CodeQueries:FindDataModule")
	set sc=moduleQuery.Execute("","",$get(firstData("ModuleCode")))
	set moduleId="",moduleDesc=""
	while(moduleQuery.Next())
	{
		set moduleId=moduleQuery.Get("RowId")	
		set moduleDesc=moduleQuery.Get("Description")
	}
	tstart
	b ;1
	set:$get(firstData("RecordSheet"))'="" recordSheetId=firstData("RecordSheet")
	b ;2
	set:$get(firstData("RecordSheet"))="" recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetId($get(firstData("OPSID")),moduleId,$get(firstData("UpdateUserID")))
	b ;3
	set:'##class(CIS.AN.RecordSheet).%ExistsId(firstData("RecordSheet")) recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetId($get(firstData("OPSID")),moduleId,$get(firstData("UpdateUserID")))
	
	if (##class(CIS.AN.RecordSheet).%ExistsId(recordSheetId)=0)
	{
		trollback
		quit "E^"_recordSheetId	
	}
	set recordSheet=##class(CIS.AN.RecordSheet).%OpenId(recordSheetId)
	set opsId=recordSheet.OperSchedule.%Id()
	
	set dataIndex=0,saveResult=""
	for
	{
		set dataIndex=$order(array(dataIndex))
		quit:(dataIndex="")
		m operData=array(dataIndex)
		set operData("RecordSheet")=recordSheetId
		set operDataID=..GetOperDataID(recordSheetId,operData("DataItem"))
		if (##class(CIS.AN.OperData).%ExistsId(operDataID))
		{
			set operData("RowId")=operDataID	
		}
		set saveResult=##class(CIS.AN.COM.DataService).SaveData(.operData)
		quit:($piece(saveResult,"^",1)'="S")
	}
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult	
	}
	
	// 离病区时间写入手术过程表
	set moduleCode=recordSheet.DataModule.Code
	if (moduleCode=##class(CIS.AN.BL.Constant).#PatTransRecord)
	{
		set saveResult=##class(CIS.AN.BL.SurgicalProcedure).SaveWardOutProcedure(opsId)	
		if ($piece(saveResult,"^",1)'="S")
		{
			trollback
			quit saveResult	
		}
	}
	
	/// 额外的数据，非OperData数据
	if (extDataPara'="")
	{
		set sc=##class(CIS.AN.COM.String).ToArray(extDataPara,.extArray)
		set dataIndex=0
		for
		{
			set dataIndex=$o(extArray(dataIndex))
			quit:(dataIndex="")
			k extData
			m extData=extArray(dataIndex)
			set saveResult=##class(CIS.AN.COM.DataService).SaveData(.extData)
			quit:($piece(saveResult,"^",1)'="S")	
		}	
		if ($piece(saveResult,"^",1)'="S")
		{
			trollback
			quit saveResult	
		}
	}
	
	tcommit
	quit "S^"
Error
	set $zt=""
	quit "E^"_$ze
}

ClassMethod GetOperDataID(recordSheetId As %String, dataItem As %String) As %String
{
	set operDataID=""
	&sql(select RowId into :operDataID from CIS_AN.OperData where RecordSheet=:recordSheetId and DataItem=:dataItem)
	quit operDataID
}

/// Creator：      	陈长青
/// CreatDate：    	2018-1-11
/// Description： 	保存手术记录数据
/// Table：        	DHCAN.OperData  DHCAN.RecordSheet
/// Input:			opsId:手术ID，moduleCode:模块代码，userId:用户ID，dataPara:数据
/// Return：       	保存成功返回"S^"，失败返回"E^原因"
/// Debug:			w ##class(CIS.AN.BL.OperData).SaveSignedDatas(^TMPYGB("SaveSignedDatas"))
ClassMethod SaveSignedDatas(dataPara As %String) As %String
{
	set $zt="Error"
	set ^TMPYGB("SaveSignedDatas")=dataPara
	set sc=##class(CIS.AN.COM.String).ToArray(dataPara,.array)
	tstart
	m signedData=array(1)
	set signUser=signedData("SignUser")
	if (signUser="")&(signedData("UserCertID")'="")
	{
		set userQuery=##class(%ResultSet).%New("CIS.AN.COM.ConfigQueries","FindUserByCert")
		set sc=userQuery.Execute(signedData("UserCertID"))
		while(userQuery.%Next())
		{
			set signedData("SignUser")=userQuery.Get("RowId")	
		}	
	}
	set signedData("SignDate")=+$h
	set signedData("SignTime")=$p($h,",",2)	
	set signCode=$get(signedData("SignCode"))
	set signSheetId=$get(signedData("RecordSheet"))
	set signId=##class(CIS.AN.BL.Signature).GetSignId(signSheetId,signCode)
	set:(##class(CIS.AN.Signature).%ExistsId(signId))&(##class(CIS.AN.Signature).%ExistsId($g(signedData("RowId")))=0) signedData("RowId")=signId
	set saveResult=##class(CIS.AN.COM.DataService).SaveData(.signedData)
	
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult	
	}
	set dataIndex=1,saveResult="S^"
	for
	{
		set dataIndex=$order(array(dataIndex))
		quit:(dataIndex="")
		m operData=array(dataIndex)
		
		if (operData("ClassName")="CIS.AN.OperData")
		{
			set recordSheetId=operData("RecordSheet")
			set operDataID=..GetOperDataID(recordSheetId,operData("DataItem"))	
			if (##class(CIS.AN.OperData).%ExistsId(operDataID))
			{
				set operData("RowId")=operDataID	
			}
		}
		else
		{
			set saveResult="S^"
		}
		set saveResult=##class(CIS.AN.COM.DataService).SaveData(.operData)
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

/// Creator：      	陈长青
/// CreatDate：    	2017-2-7
/// Description： 	查询数据
/// Table：        	DHCAN.OperData
/// Input:			opsId:手术ID,moduleCode:模块代码
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("DHCAN.DataQuery","FindOperData","","")
Query FindOperData(opsId As %String, moduleCode As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT RowId,
	   RecordSheet,
	   DataItem,
	   DataValue,
	   %ODBCOUT(ExecDate) As ExecDate,
	   %ODBCOUT(ExecTime) As ExecTime,
	   %ODBCOUT(ExecDate)+' '+%ODBCOUT(ExecTime) As ExecDT,
	   UpdateUserID,
	   CIS_AN_COM.String_GetDescByID('User.SSUser','SSUSRName',UpdateUserID) As UpdateUserDesc,
	   DataScore,
	   DataNote
	   from CIS_AN.OperData 
	   where RecordSheet->OperSchedule=:opsId
	   and RecordSheet->DataModule->Code=:moduleCode
}

/// Creator：      	陈长青
/// CreatDate：    	2017-2-7
/// Description： 	查询数据
/// Table：        	DHCAN.OperData
/// Input:			opsId:手术ID,moduleCode:模块代码
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AB.BL.OperData","FindOperDataBySheet","65")
Query FindOperDataBySheet(recordSheetId As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT RowId,
	   RecordSheet,
	   DataItem,
	   DataValue,
	   %ODBCOUT(ExecDate) As ExecDate,
	   %ODBCOUT(ExecTime) As ExecTime,
	   %ODBCOUT(ExecDate)+' '+%ODBCOUT(ExecTime) As ExecDT,
	   UpdateUserID,
	   CIS_AN_COM.String_GetDescByID('User.SSUser','SSUSRName',UpdateUserID) As UpdateUserDesc,
	   DataScore,
	   DataNote
	   from CIS_AN.OperData 
	   where RecordSheet=:recordSheetId
}

/// Creator：      	陈长青
/// CreatDate：    	2018-7-29
/// Description： 	获取手术数据
/// Table：        	DHCAN.OperData  DHCAN.RecordSheet
/// Input:			opsId:手术ID，moduleCode:模块代码，operDataCode:数据代码
/// Return：       	保存成功返回"S^"，失败返回"E^原因"
/// Debug:			w ##class(CIS.AN.BL.OperData).GetOperDataByCode("111","PatientHandOver","PreAntibioticQty")
ClassMethod GetOperDataByCode(opsId As %String, dataModuleCode As %String, operDataCode As %String) As %String
{
	// PreAntibioticQty
	set ret=""
	set recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCode(opsId,dataModuleCode,"","N")
	if (##class(CIS.AN.RecordSheet).%ExistsId(recordSheetId)=1)
	{
		set dataCode=$System.SQL.UPPER(operDataCode)
		set operDataId=$order(^CIS.AN.OperDataI("ICode",recordSheetId," "_dataCode,0))
		if (##class(CIS.AN.OperData).%ExistsId(operDataId)=1)
		{
			set operData=##class(CIS.AN.OperData).%OpenId(operDataId)	
			set ret=operData.DataValue	
		}
		
	}	
	quit ret
}

/// Creator：      	陈长青
/// CreatDate：    	2018-7-29
/// Description： 	获取手术数据
/// Table：        	DHCAN.OperData  DHCAN.RecordSheet
/// Input:			opsId:手术ID，moduleCode:模块代码，operDataCode:数据代码
/// Return：       	保存成功返回"S^"，失败返回"E^原因"
/// Debug:			w ##class(CIS.AN.BL.OperData).GetOperDataByCode("111","PatientHandOver","PreAntibioticQty")
ClassMethod GetOperDataIDByCode(opsId As %String, dataModuleCode As %String, operDataCode As %String) As %String
{
	// PreAntibioticQty
	set ret=""
	set recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCode(opsId,dataModuleCode,"","N")
	if (##class(CIS.AN.RecordSheet).%ExistsId(recordSheetId)=1)
	{
		set dataCode=$System.SQL.UPPER(operDataCode)
		set operDataId=$order(^CIS.AN.OperDataI("ICode",recordSheetId," "_dataCode,0))
		if (##class(CIS.AN.OperData).%ExistsId(operDataId)=1)
		{
			set ret=operDataId	
		}
		
	}	
	quit ret
}

/// Creator：      	雍阳
/// CreatDate：    	2018-9-21
/// Description： 	获取手术数据对象
/// Table：        	DHCAN.OperData  DHCAN.RecordSheet
/// Input:			opsId:手术ID，moduleCode:模块代码，operDataCode:数据代码
/// Return：       	返回对象
/// Debug:			w ##class(CIS.AN.BL.OperData).GetOperDataByCode("111","PatientHandOver","PreAntibioticQty")
ClassMethod GetOperDataObjectByCode(opsId As %String, dataModuleCode As %String, operDataCode As %String) As CIS.AN.COM.DataObject
{
	set result=##class(CIS.AN.COM.DataObject).%New()
	
	set recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCode(opsId,dataModuleCode,"")
	if (##class(CIS.AN.RecordSheet).%ExistsId(recordSheetId)=1)
	{
		set dataCode=$System.SQL.UPPER(operDataCode)
		set operDataId=$order(^CIS.AN.OperDataI("ICode",recordSheetId," "_dataCode,0))
		if (##class(CIS.AN.OperData).%ExistsId(operDataId)=1)
		{
			set operData=##class(CIS.AN.OperData).%OpenId(operDataId)
				
			set keyValuePair=##class(CIS.AN.COM.KeyValuePair).%New()
			set keyValuePair.Key="RowId"
			set keyValuePair.Value=operData.%Id()
			do result.KeyValuePairs.Insert(keyValuePair)
			
			set keyValuePair=##class(CIS.AN.COM.KeyValuePair).%New()
			set keyValuePair.Key="DataValue"
			set keyValuePair.Value=operData.DataValue
			do result.KeyValuePairs.Insert(keyValuePair)
			
			set keyValuePair=##class(CIS.AN.COM.KeyValuePair).%New()
			set keyValuePair.Key="UpdateDate"
			set keyValuePair.Value=operData.UpdateDate
			do result.KeyValuePairs.Insert(keyValuePair)
			
			set keyValuePair=##class(CIS.AN.COM.KeyValuePair).%New()
			set keyValuePair.Key="UpdateTime"
			set keyValuePair.Value=operData.UpdateTime
			do result.KeyValuePairs.Insert(keyValuePair)

			set keyValuePair=##class(CIS.AN.COM.KeyValuePair).%New()
			set keyValuePair.Key="ExecDT"
			set keyValuePair.Value=##class(CIS.AN.COM.DateTime).ConvertToDateTime(operData.ExecDate,operData.ExecTime,"")
			do result.KeyValuePairs.Insert(keyValuePair)

			set keyValuePair=##class(CIS.AN.COM.KeyValuePair).%New()
			set keyValuePair.Key="UpdateUser"
			set keyValuePair.Value=""
			set:($IsObject(operData.UpdateUserID)) keyValuePair.Value=operData.UpdateUserID.FullName
			do result.KeyValuePairs.Insert(keyValuePair)
		}
	}	
	
	quit result
}

/// Creator：      	陈长青
/// CreatDate：    	2018-7-29
/// Description： 	获取手术数据
/// Table：        	DHCAN.OperData  DHCAN.RecordSheet
/// Input:			recordSheetId:麻醉记录表单ID，operDataCode:数据代码
/// Return：       	保存成功返回"S^"，失败返回"E^原因"
/// Debug:			w ##class(CIS.AN.BL.OperData).GetOperDataByCodeNew("111","PreAntibioticQty")
ClassMethod GetOperDataByCodeNew(recordSheetId As %String, operDataCode As %String) As %String
{
	set ret=""
	if (##class(CIS.AN.RecordSheet).%ExistsId(recordSheetId)=1)
	{
		set dataCode=$System.SQL.UPPER(operDataCode)
		set operDataId=$order(^CIS.AN.OperDataI("ICode",recordSheetId," "_dataCode,0))
		if (##class(CIS.AN.OperData).%ExistsId(operDataId)=1)
		{
			set operData=##class(CIS.AN.OperData).%OpenId(operDataId)	
			set ret=operData.DataValue	
		}
		
	}
	quit ret
}

ClassMethod GetOperDataByOPS(opsId As %String, moduleCode As %String, operDataCode As %String) As %String
{
	set ret="",recordSheetId=""
	&sql(select RowId into :recordSheetId from CIS_AN.recordsheet where OperSchedule=:opsId and DataModule->Code=:moduleCode)
	set ret=..GetOperDataByCodeNew(recordSheetId,operDataCode)
	quit ret
}

ClassMethod GetLastTemperatureData(EpisodeID As %String) As %String
{
	// 体温单项目代码：脉搏^呼吸^体位^收缩压^舒张压^体重^身高^心率^血氧饱和度
	set itemCodeStr="pulse^breath^temperature^sysPressure^diaPressure^weight^height^heartbeat^degrBlood"
	k dataArr
	set dataArr(1,"Pulse")=##class(Nur.CommonInterface.Temperature).getLastItemValue(EpisodeID,"pulse")
	set dataArr(1,"RespRate")=##class(Nur.CommonInterface.Temperature).getLastItemValue(EpisodeID,"breath")
	set dataArr(1,"Temperature")=##class(Nur.CommonInterface.Temperature).getLastItemValue(EpisodeID,"temperature")
	set dataArr(1,"SysPressure")=##class(Nur.CommonInterface.Temperature).getLastItemValue(EpisodeID,"sysPressure")
	set dataArr(1,"DiaPressure")=##class(Nur.CommonInterface.Temperature).getLastItemValue(EpisodeID,"diaPressure")
	set dataArr(1,"BloodPressure")=""
	if (dataArr(1,"SysPressure")'="")&(dataArr(1,"DiaPressure")'="")
	{
		set dataArr(1,"BloodPressure")=	dataArr(1,"SysPressure")_"/"_dataArr(1,"DiaPressure")
	}
	set patWeight=##class(Nur.CommonInterface.Temperature).getLastItemValue(EpisodeID,"weight")
	set patHeight=##class(Nur.CommonInterface.Temperature).getLastItemValue(EpisodeID,"height")
	set dataArr(1,"Weight")=patWeight
	set dataArr(1,"Height")=patHeight
	set dataArr(1,"BMI")=""
	if (+patWeight>0)&(+patHeight>0){
		set height=patHeight/100
		set dataArr(1,"BMI")=patWeight/(height*height)
	}
	set dataArr(1,"HR")=##class(Nur.CommonInterface.Temperature).getLastItemValue(EpisodeID,"heartbeat")
	set dataArr(1,"SPO2")=##class(Nur.CommonInterface.Temperature).getLastItemValue(EpisodeID,"degrBlood")
	set ret=##class(CIS.AN.COM.String).ToJson(.dataArr)
	quit ret
}

/// w ##class(CIS.AN.BL.OperData).GetLastLabData(31)
ClassMethod GetLastLabData(EpisodeID As %String) As %String
{
	set standardCodeStr="WBC^HGB^HCT^PLT^PT^APTT^GLU^K^NA^Cl^ABO^RH"
	set standardItemStr="WBC^HGB^HCT^PLT^PT^APTT^GLU^K^NA^Cl^ABO^RH"
	
	//k dataArr
	//set splitChar=$c(4),valueSplitChar=$c(2)
	//set testResult=##class(web.DHCClinicCom).GetLatestTestResult(EpisodeID,standardCodeStr)
	//set dataArr(1,"WBC")=$p($p(testResult,splitChar,1),valueSplitChar,1)
	//set dataArr(1,"HGB")=$p($p(testResult,splitChar,2),valueSplitChar,1)
	//set dataArr(1,"HCT")=$p($p(testResult,splitChar,3),valueSplitChar,1)
	//set dataArr(1,"PLT")=$p($p(testResult,splitChar,4),valueSplitChar,1)
	//set dataArr(1,"PT")=$p($p(testResult,splitChar,5),valueSplitChar,1)
	//set dataArr(1,"APTT")=$p($p(testResult,splitChar,6),valueSplitChar,1)
	//set dataArr(1,"GLU")=$p($p(testResult,splitChar,7),valueSplitChar,1)
	//set dataArr(1,"K")=$p($p(testResult,splitChar,8),valueSplitChar,1)
	//set dataArr(1,"NA")=$p($p(testResult,splitChar,9),valueSplitChar,1)
	//set dataArr(1,"Cl")=$p($p(testResult,splitChar,10),valueSplitChar,1)
	//set dataArr(1,"ABO")=$p($p(testResult,splitChar,11),valueSplitChar,1)
	//set dataArr(1,"RH")=$p($p(testResult,splitChar,12),valueSplitChar,1)
	//b //ccq2

	for i=1:1:$l(standardCodeStr,"^")
	{
		set standardCode=""
		set standardItem=$p(standardItemStr,"^",i)
		&sql(select Code into :standardCode from CT_AN.Dictionary where Description=:standardItem)
		if (standardCode="") set standardCode=$p(standardCodeStr,"^",i)
		set testResult=##class(web.DHCClinicCom).GetTestResult(EpisodeID,"","",standardCode,0,0,$h+1,0,1)
		set testValue=$p(testResult,$c(2),1),valueRange=$p(testResult,$c(2),3),rangeMin=$p(valueRange,"-",1),rangeMax=$p(valueRange,"-",2)
		set dataArr(1,standardItem)=testValue
	}
	
	set ret=##class(CIS.AN.COM.String).ToJson(.dataArr)
	quit ret
}

/// w ##class(CIS.AN.BL.OperData).GetLastLabDataRange(31)
ClassMethod GetLastLabDataRange(EpisodeID As %String) As %String
{
	set standardCodeStr="WBC^HGB^HCT^PLT^PT^APTT^GLU^K^NA^Cl^ABO^RH"
	set standardItemStr="WBC^HGB^HCT^PLT^PT^APTT^GLU^K^NA^Cl^ABO^RH"
	for i=1:1:$l(standardCodeStr,"^")
	{
		set standardCode=""
		set standardItem=$p(standardItemStr,"^",i)
		&sql(select Code into :standardCode from CT_AN.Dictionary where Description=:standardItem)
		if (standardCode="") set standardCode=$p(standardCodeStr,"^",i)
		set testResult=##class(web.DHCClinicCom).GetTestResult(EpisodeID,"","",standardCode,0,0,$h+1,0,1)
		set testValue=$p(testResult,$c(2),1),valueRange=$p(testResult,$c(2),3),rangeMin=$p(valueRange,"-",1),rangeMax=$p(valueRange,"-",2)
		set dataArr(1,standardItem)=rangeMin_"^"_rangeMax
	}
	
	set ret=##class(CIS.AN.COM.String).ToJson(.dataArr)
	quit ret
}

/// w ##class(CIS.AN.BL.OperData).GetEMRData(70)
ClassMethod GetEMRData(EpisodeID As %String) As %String
{
	set EMRCatCode="HDSD00.13.01"
	set arr=##class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossary(EpisodeID,EMRCatCode)
	set EMRItemCode="HDSD00.13.065"		// 手术史
	set dataArr(1,"OperHistory")=arr.GetAt(EMRItemCode)
	set EMRItemCode="HDSD00.13.037"		// 过敏史
	set dataArr(1,"AllergyHistory")=arr.GetAt(EMRItemCode)
	set EMRItemCode="HDSD00.13.028"		// 传染病史
	set dataArr(1,"InfectionHistory")=arr.GetAt(EMRItemCode)
	set EMRItemCode="HDSD00.13.042"		// 既往史
	set pastHistory=arr.GetAt(EMRItemCode)
	set dataArr(1,"PastHistory")=arr.GetAt(EMRItemCode)
	;set dataArr(1,"OperHistory")=$p($p(pastHistory,"手术史：",2),"。",1)
	;set dataArr(1,"AllergyHistory")=$p($p(pastHistory,"过敏史：",2),"。",1)
	;set dataArr(1,"InfectionHistory")=$p($p(pastHistory,"传染病史：",2),"。",1)
	;set dataArr(1,"PastHistory")=$p($p(pastHistory,"既往疾病：",2),"。",1)
	set ret=##class(CIS.AN.COM.String).ToJson(.dataArr)
	quit ret
}

ClassMethod GetPressureSoreData(opsId As %String) As %String
{
	k dataArr
	set operScheduleObj=##class(CIS.AN.COM.Query).ToObject("CIS.AN.BL.OperSchedule:FindOperScheduleList","","","",opsId)	
	
	// 获取年龄
	set DOB=##class(CIS.AN.COM.DateTime).ConvertToDateH(operScheduleObj.GetValue("PatDOB"),"")
	set ageNum=##class(CIS.AN.COM.DateTime).CalAgeNum(DOB,+$h,0,"Y")
	set dataArr(1,"AgeNum")=ageNum
	
	// 获取BMI指数
	set EpisodeID=operScheduleObj.GetValue("EpisodeID")
	set patWeight=##class(Nur.CommonInterface.Temperature).getLastItemValue(EpisodeID,"weight")
	set patHeight=##class(Nur.CommonInterface.Temperature).getLastItemValue(EpisodeID,"height")
	set dataArr(1,"Weight")=patWeight
	set dataArr(1,"Height")=patHeight
	set dataArr(1,"BMI")=""
	if (+patWeight>0)&(+patHeight>0){
		set height=patHeight/100
		set dataArr(1,"BMI")=patWeight/(height*height)
	}
	
	// 获取手术时长
	set dataArr(1,"OperDuration")=..GetOperDataByOPS(opsId,"OperRiskAssessment","OpDurationTimes")
	
	// 获取ASA分级
	set dataArr(1,"ASAClass")=..GetOperDataByOPS(opsId,"OperRiskAssessment","ASAClass")
	
	// 手术体位
	set dataArr(1,"OperPos")=operScheduleObj.GetValue("OperPosDesc")
	
	// 失血量
	set bleedingVolume=##class(CIS.AN.COM.Query).ToObject("CIS.AN.BL.AnaData:FindOutputDatas",opsId,"BleedingVolume")
	set dataArr(1,"BleedingVolume")=bleedingVolume.GetValue("SumQty")
	
	// 围手术期时长
	set theatreInDT=operScheduleObj.GetValue("TheatreInDT")
	set theatreOutDT=operScheduleObj.GetValue("TheatreOutDT")
	if (theatreInDT'="")&(theatreOutDT'="")
	{
		set theatreInDate=##class(CIS.AN.COM.DateTime).ConvertToDateH($p(theatreInDT," ",1))	
		set theatreInTime=##class(CIS.AN.COM.DateTime).ConvertToTimeH($p(theatreInDT," ",2))
		set theatreOutDate=##class(CIS.AN.COM.DateTime).ConvertToDateH($p(theatreOutDT," ",1))	
		set theatreOutTime=##class(CIS.AN.COM.DateTime).ConvertToTimeH($p(theatreOutDT," ",2))
		set dataArr(1,"OperDurationHours")=##class(CIS.AN.COM.DateTime).CalculateDuration(theatreInDate,theatreInTime,theatreOutDate,theatreOutTime,"H")
	}
	
	set ret=##class(CIS.AN.COM.String).ToJson(.dataArr)
	quit ret
}

/// w ##class(CIS.AN.BL.OperData).GetKeyValues(1384)
ClassMethod GetKeyValues(recordSheetId) As %String
{
	quit:'##class(CIS.AN.RecordSheet).%ExistsId(recordSheetId) ""
	
	kill keyValueDic
	set keyValueDic(1,"0")="0"
	&sql(declare c cursor for select %ID into :rowId from cis_an.operdata
		where RecordSheet=:recordSheetId)
	&sql(open c)
	for
	{
		&sql(fetch c)
		quit:(SQLCODE'=0)
		
		set operData=^CIS.AN.OperDataD(rowId)
		set code=$lg(operData,2)
		set value=$lg(operData,3)
		set:code'="" keyValueDic(1,code)=value
	}
	&sql(close c)
	
	set ret=##class(CIS.AN.COM.String).ToJson(.keyValueDic)
	quit ret
}

/// w ##class(CIS.AN.BL.OperData).SaveKeyValue(1384,"Respiration","17","10209")
ClassMethod SaveKeyValue(recordSheetId, code, value, userId) As %String
{
	quit:'##class(CIS.AN.RecordSheet).%ExistsId(recordSheetId) "E^表单ID不存在"
	quit:code="" "E^数据项代码为空"
	
	set rowId=$O(^CIS.AN.OperDataI("ICode",recordSheetId," "_$ZCVT(code,"U"),""))
	
	kill savingData
	set savingData("ClassName")="CIS.AN.OperData"
	set savingData("RowId")=rowId
	set savingData("RecordSheet")=recordSheetId
	set savingData("DataItem")=code
	set savingData("DataValue")=value
	set savingData("ExecDate")=+$h
	set savingData("ExecTime")=$p($h,",",2)
	set savingData("UpdateUserID")=userId
	set savingData("UpdateDate")=+$h
	set savingData("UpdateTime")=$p($h,",",2)
	
	set saveResult=##class(CIS.AN.COM.DataService).SaveData(.savingData)
	quit saveResult
}

}
