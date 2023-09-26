Class DHCCL.BLL.Test Extends %RegisteredObject
{

/// Creator：      	陈长青
/// CreatDate：    	2017-4-27
/// Description： 	查询病人最近的检验数据
/// Table：        	
/// Input:			EpisodeID:病人就诊ID，standardCodeStr：检验标准码(多个标准码以"^"拼接)
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("DHCCL.BLL.Test","FindLastestTestResult","1821771")
Query FindLastestTestResult(EpisodeID As %String) As %Query(ROWSPEC = "DataField,StandardCode,Result,Unit,Range,IsNormal") [ SqlProc ]
{
}

ClassMethod FindLastestTestResultExecute(ByRef qHandle As %Binary, EpisodeID As %String) As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	// 判断是否存在就诊记录
	set existsEpisode=##class(DHCCL.BLL.Admission).ExistsEpisode(EpisodeID)
	if (existsEpisode="N")
	{
		s qHandle=$lb(0,repid,0)
		q $$$OK	
	}
	
	// 获取检验标准码对照项目
	set standardItemQuery=##class(%ResultSet).%New("DHCAN.BLL.DataQuery:FindTestStandardCode")
	set sc=standardItemQuery.Execute()
	while(standardItemQuery.%Next())
	{
		// 过滤未激活的对照项目
		set active=standardItemQuery.Get("Active")
		continue:(active'="Y")
		
		set dataField=standardItemQuery.Get("DataField")
		set standardCode=standardItemQuery.Get("TestCode")		// 检验标准代码
		
		// 开始日期设置为0，确保能获取到检验数据(如果病人做过相应的检验)
		// 结束日期设置为当前日期的后一天，确保获取到最新的检验数据
		set testResult=..GetTestResult(EpisodeID,"","",standardCode,0,0,$h+1,0,1)
		set result=$piece(testResult,"\",1)
		if ($System.SQL.ALPHAUP(standardCode)="ABO")
		{
			set resultDesc=$case(result,
								 "APOS":"A型RH阳性",
								 "BPOS":"B型RH阳性",
								 "ABPOS":"AB型RH阳性",
								 "OPOS":"O型RH阳性",
								 "ANEG":"A型RH阴性",
								 "BNEG":"B型RH阴性",
								 "ABNEG":"AB型RH阴性",
								 "ONEG":"O型RH阴性",
								 "A":"A型",
								 "B":"B型",
								 "AB":"AB型",
								 "O":"O型")
			set result=resultDesc
			
		}
		set unit=$piece(testResult,"\",2)
		set range=$piece(testResult,"\",3)
		set rangeMin=+$piece(range,"-",1)
		set rangeMax=+$piece(range,"-",2)
		set isNormal="Y"
		if (rangeMax>rangeMin)
		{
			set resultQty=+result
			if (resultQty>rangeMax) ! (resultQty<rangeMin)
			{
				set isNormal="N"	
			}	
		}
		if ($System.SQL.ALPHAUP(dataField)="HBSAG")
		{
			if (isNormal="N")
			{
				set result="阳性(+)"	
			}
			else
			{
				set result="阴性(-)"	
			}
			
		}
		do OutputRow	
	}
	
	s qHandle=$lb(0,repid,0)
	q $$$OK

OutputRow
	s Data=$lb(dataField,standardAnaCode,result,unit,range,isNormal)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod FindLastestTestResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLastestTestResultExecute ]
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

ClassMethod FindLastestTestResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLastestTestResultExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// 根据就诊号、登记号或科室的化验项目标准码standardCode，取检验结果,ifSingle=1取最新值
/// 返回值：多个结果以^分割,每个以"\"分割：检验值，单位，检验正常值范围
ClassMethod GetTestResult(needEpisodeID, regNoList, ctlocId, standardCode, startDate, startTime, endDate, endTime, ifSingle = 0) As %String
{
	k labCode
	q:standardCode="" ""
	s testCode="",testCodeStr=""
	f  s testCode=$o(^TTABi("TC","NNL",standardCode,testCode)) q:testCode=""  d
		.i testCodeStr'="" s testCodeStr=testCodeStr_"^"
		.s testCodeStr=testCodeStr_testCode
	;//w testCodeStr,!
	s startDate=+##class(DHCCL.BLL.DateTime).ConvertToDateH(startDate,"")
	s startTime=+##class(DHCCL.BLL.DateTime).ConvertToTimeH(startTime,"")
	s endDate=##class(DHCCL.BLL.DateTime).ConvertToDateH(endDate)
	s endTime=##class(DHCCL.BLL.DateTime).ConvertToTimeH(endTime)
	i needEpisodeID'="" d
		.s papmiId=$p($g(^PAADM(needEpisodeID)),"^",1)
		.s regNoList=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
		.s paadmDate=$p(^PAADM(needEpisodeID),"^",6)
		.i paadmDate'="" d
			..q:(paadmDate<startDate)
			..s paadmTime=$p(^PAADM(needEpisodeID),"^",7)
			..q:(paadmDate=startDate)&(paadmTime<startTime)
			..s startDate=paadmDate,startTime=paadmTime
		.s paadmDischgDate=$p(^PAADM(needEpisodeID),"^",17)
		.i paadmDischgDate>paadmDate d
			..q:(paadmDischgDate>endDate)
			..s paadmDischgTime=$p(^PAADM(needEpisodeID),"^",18)
			..q:(paadmDischgDate=endDate)&(paadmDischgTime>endTime)
			..s endDate=paadmDischgDate,endTime=paadmDischgTime
	//w startDate_","_startTime_","_endDate_","_endTime,!
	i regNoList="" d
		.s EpisodeIDList=##class(DHCCL.BLL.Admission).FindWardPatient("", ctlocId)
		.q:EpisodeIDList=""
		.f i=1:1:$l(EpisodeIDList,"^") d
			..s EpisodeID=+$p(EpisodeIDList,"^",i)
			..s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
			..i regNoList'="" s regNoList=regNoList_"^"
			..s regNoList=regNoList_$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	q:regNoList="" ""
	;//w regNoList,!
	s retStr=""
	f i=1:1:$l(regNoList,"^") d
		.s regNo=$p(regNoList,"^",i)
		.q:regNo=""
		.s testCode="",ifFind=0,count=0
		.f  s testCode=$o(^TDHCOldResult(1,regNo,testCode)) q:(testCode="")!(ifFind)  d
			..q:("^"_testCodeStr_"^")'[("^"_testCode_"^")
			..s date=endDate+11
			..f  s date=$o(^TDHCOldResult(1,regNo,testCode,date),-1) q:(date="")!(date<startDate)!(ifFind)  d
				...s time=""
				...f  s time=$o(^TDHCOldResult(1,regNo,testCode,date,time),-1) q:(time="")!(ifFind)  d
					....q:(date<startDate) //&(time*60<startTime)
					....//q:(date=endDate)&(time*60'<endTime)
					....s labNo=""
					....f  s labNo=$o(^TDHCOldResult(1,regNo,testCode,date,time,labNo)) q:(labNo="")!(ifFind)  d
						.....s testSet=""
						.....f  s testSet=$o(^TDHCOldResult(1,regNo,testCode,date,time,labNo,testSet)) q:testSet=""  d
							......s sub=$o(^TDHCOldResult(1,regNo,testCode,date,time,labNo,testSet,""))
							......s result=$p(^TEPI(labNo,1,testSet,sub,"DATA",testCode),"\",1)
							......s receiveDate=$p(^TEPI(labNo,1,testSet,sub),"\",1)
							......s receiveTime=$p(^TEPI(labNo,1,testSet,sub),"\",2)
							......q:(receiveDate=startDate)&(receiveTime*60<startTime)
							......q:(receiveDate>endDate)!((receiveDate=endDate)&(receiveTime*60>endTime))
							......s range=$g(^TEPI(labNo,1,testSet,sub,"DATA",testCode,"Ranges"))
							......s unit=$g(^TEPI(labNo,1,testSet,sub,"DATA",testCode,"Unit"))
							......//w labNo_"/"_testSet_"/"_date_"/"_time,!
							......//q:$d(labCode(testSet,testCode))
							......//s labCode(testSet,testCode)=""
							......//w regNo_" "_$zd(date,3)_" "_$zt(time,2)_":" 
							......//w testSet_":"_$p(^TTAB("TS",testSet),"\",1)_"/"_testCode_":"_$p(^TTAB("TC",testCode),"\",1)_"/"_result_" "_unit_":"_range,!
							......i retStr'="" s retStr=retStr_"^"
							......s retStr=retStr_result_"\"_unit_"\"_range
							......s count=count+1
							......i ifSingle<count s ifFind=1
	q retStr
}

/// 按范围查找检验数据
ClassMethod GetTestResultByScope(needEpisodeID, regNoList, ctlocId, standardCode, date, time, scope = 20, ifSingle = 0) As %String
{
	// s icuaId=2240
	// s icucriId=5330
	// s date="2014-03-01"
	// s time=22*3600
	// w ##class(web.DHCClinicCom).GetTestResultByScope(needEpisodeID,regNoList,ctlocId,standardCode,date,time,scope,ifSingle)
	s date=##class(DHCCL.BLL.DateTime).ConvertToDateH(date)
	s time=##class(DHCCL.BLL.DateTime).ConvertToTimeH(time)
	
	s scope=scope*60
	s dateSec=3600*24
	s startDateTime=((date*dateSec)+time)-scope
	s endDateTime=((date*dateSec)+time)+scope
	
	s fromDate=startDateTime\dateSec
	s fromTime=startDateTime#dateSec
	s toDate=endDateTime\dateSec
	s toTime=endDateTime#dateSec
	
	// w "From:",$zd(fromDate)," ",$zt(fromTime),!
	// w "To:",$zd(toDate)," ",$zt(toTime),!
	
	s retStr=..GetTestResult(needEpisodeID, regNoList, ctlocId, standardCode, fromDate, fromTime, toDate, toTime, ifSingle)
	q retStr
}

}
