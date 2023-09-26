/// 检验数据业务类
Class CIS.AN.BL.LabData Extends %RegisteredObject
{

ClassMethod GetLabData(EpisodeID As %String, standardCode As %String) As CIS.AN.LabData
{
	set labDataID=0,result=""
	set medcareNo=##class(CIS.AN.COM.Admission).GetMedicareNo("",EpisodeID)
	for
	{
		set labDataID=$order(^CIS.AN.LabDataI("MedCode"," "_medcareNo," "_$System.SQL.UPPER(standardCode),labDataID))
		quit:(labDataID="")
		set result=##class(CIS.AN.LabData).%OpenId(labDataID)
	}
	if (result="")
	{
		for
		{
			set labDataID=$order(^CIS.AN.LabDataI("MedDesc"," "_medcareNo," "_$System.SQL.UPPER(standardCode),labDataID))
			quit:(labDataID="")
			set result=##class(CIS.AN.LabData).%OpenId(labDataID)
		}	
	}
	quit result
}

ClassMethod GetTestResult(EpisodeID As %String, standardCode As %String, operDate As %String, queryDays As %String) As CIS.AN.LabData
{
	set result=..GetLabData(EpisodeID,standardCode)
	set medcareNo=##class(CIS.AN.COM.Admission).GetMedicareNo("",EpisodeID)
	// 如果获取的检验结果为空，则从接口获取
	if (result="")
	{
		set today=+operDate
		set subDays=+queryDays
		set startDT=##class(CIS.AN.COM.DateTime).ConvertToDate(today-subDays)_" 00:00:00"
		set endDT=##class(CIS.AN.COM.DateTime).ConvertToDate(today)_" 00:00:00"
		do ##class(web.DHCANImportDataNew).GetLabList(medcareNo,startDT,endDT)	
		set result=..GetLabData(EpisodeID,standardCode)
	}
	if (result="")&(+queryDays<=30)
	{
		// 如果还没有检验结果，则扩大日期查询范围递归获取
		set result=..GetTestResult(EpisodeID,standardCode,operDate,queryDays+10)	
	}	
	quit result
}

ClassMethod ImportLabData(startDate As %String, endDate As %String) As %String
{
	set rset=##class(%ResultSet).%New("CIS.AN.BL.OperSchedule:FindOperScheduleList")
	set operDeptID="29"
	set sc=rset.Execute(startDate,endDate,operDeptID)
	while(rset.%Next())
	{
		set opsId=rset.Get("RowId")
		//do ..GetInfectiousResult(opsId)
		set medcareNo=rset.Get("MedcareNo")
		set lstartDate=##class(CIS.AN.COM.DateTime).ConvertToDate(+$h-730),lendDate=##class(CIS.AN.COM.DateTime).ConvertToDate(+$h)
		do ##class(web.DHCANImportDataNew).GetLabList(medcareNo,lstartDate,lendDate)
	}	
	quit ""
}

/// Creator：      	陈长青
/// CreatDate：    	2018-07-14
/// Description： 	获取传染病检验数据
/// Table：        	CIS.AN.LabData
/// Input：        	EpisodeID:患者就诊ID,codePara:检验代码串，多个以"^"拼接
/// Return：       	[{"Code":"HBsAg","Description":"乙肝表面抗原","Result":"阴性(-) 0.370"},{...}]
/// Debug:			w ##class(CIS.AN.BL.LabData).GetInfectiousResult("1415")
ClassMethod GetInfectiousResult(opsId As %String) As %String
{
	set descPara="HBsAg^HBsAb^HBeAg^HBeAb^HBcAb^PreS1-Ag^HAV-IgM^HCV_IgG^HEV-IgM^TP-Ab^初筛抗HIV"
	set codePara="HBsAg^HBsAb^HBeAg^HBeAb^HBcAb^PreS1Ag^HAVIgM^HCVIgG^HEVIgM^TPAb^HIV"
	set codeCount=$length(descPara,"^")
	set result=""
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set EpisodeID=operSchedule.EpisodeID
	set medicareNo=##class(CIS.AN.COM.Admission).GetMedicareNo("",EpisodeID)
	set operDate=operSchedule.OperDate
	set testResultList=##class(%ListOfObjects).%New()
	for i=1:1:codeCount
	{
		set standardCode=$p(descPara,"^",i)
		set testResult=..GetTestResult(EpisodeID,standardCode,operDate,30)
		continue:(testResult="")
		set testResult.TestCode=$p(codePara,"^",i)
		do testResultList.Insert(testResult)	
	}
	set infection="阴性(-)"
	for i=1:1:testResultList.Size
	{
		set testResult=testResultList.GetAt(i)
		if (testResult.TestCode'="HBsAb")&(testResult.TestCodeDesc [ "阳性")
		{
			set infection="阳性(+)"	
		}
		set:(result'="") result=result_","
		set result=result_"{""code"":"""_testResult.TestCode_""",""description"":"""_testResult.TestCodeDesc_""",""result"":"""_testResult.TestResult_"""}"
	}
	set result="{""success"":""S"",""result"":["_result_"],""infection"":"""_infection_"""}"
	quit result
}

/// Creator：      	陈长青
/// CreatDate：    	2018-07-14
/// Description： 	获取传染病检验数据
/// Table：        	CIS.AN.LabData
/// Input：        	EpisodeID:患者就诊ID,codePara:检验代码串，多个以"^"拼接
/// Return：       	[{"Code":"HBsAg","Description":"乙肝表面抗原","Result":"阴性(-) 0.370"},{...}]
/// Debug:			w ##class(CIS.AN.BL.LabData).GetInfectiousResult("1415")
ClassMethod GetInfectiousData(opsId As %String) As %String
{
	set descPara="HBsAg^HBsAb^HBeAg^HBeAb^HBcAb^PreS1-Ag^HAV-IgM^HCV_IgG^HEV-IgM^TP-Ab^初筛抗HIV"
	set codePara="HBsAg^HBsAb^HBeAg^HBeAb^HBcAb^PreS1Ag^HAVIgM^HCVIgG^HEVIgM^TPAb^HIV"
	set codeCount=$length(descPara,"^")
	set result=""
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set EpisodeID=operSchedule.EpisodeID
	set operDate=operSchedule.OperDate
	set testResultList=##class(%ListOfObjects).%New()
	for i=1:1:codeCount
	{
		set standardCode=$p(descPara,"^",i)
		set testResult=..GetLabData(EpisodeID,standardCode)
		continue:(testResult="")
		set testResult.TestCode=$p(codePara,"^",i)
		do testResultList.Insert(testResult)	
	}
	set infection="阴性(-)"
	for i=1:1:testResultList.Size
	{
		set testResult=testResultList.GetAt(i)
		if (testResult.TestCode'="HBsAb")&&(testResult.TestCode'="HBcAb")&&(testResult.TestResult [ "阳性")
		{
			set infection="阳性(+)"	
		}
		set:(result'="") result=result_"#"
		set result=result_testResult.TestCodeDesc_":"_testResult.TestResult
	}
	set result=infection_"^"_result
	quit result
}

/// Creator：      	陈长青
/// CreatDate：    	2018-07-14
/// Description： 	获取病人血型检验数据
/// Table：        	CIS.AN.LabData
/// Input：        	EpisodeID:患者就诊ID,codePara:检验代码串，多个以"^"拼接
/// Return：       	[{"Code":"HBsAg","Description":"乙肝表面抗原","Result":"阴性(-) 0.370"},{...}]
/// Debug:			w ##class(CIS.AN.BL.LabData).GetBloodType("1415")
ClassMethod GetBloodType(opsId As %String) As %String
{
	set descPara="ABO血型鉴定^Rh(D)抗原"
	set codePara="ABO^RH"
	set codeCount=$length(descPara,"^")
	set result=""
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set EpisodeID=operSchedule.EpisodeID
	set operDate=operSchedule.OperDate
	set testResultList=##class(%ListOfObjects).%New()
	for i=1:1:codeCount
	{
		set standardCode=$p(descPara,"^",i)
		set testResult=..GetLabData(EpisodeID,standardCode)
		continue:(testResult="")
		set testResult.TestCode=$p(codePara,"^",i)
		do testResultList.Insert(testResult)	
	}

	for i=1:1:testResultList.Size
	{
		set testResult=testResultList.GetAt(i)
		set:(result'="") result=result_"^"
		set result=result_testResult.TestResult
	}
	quit result
}

}
