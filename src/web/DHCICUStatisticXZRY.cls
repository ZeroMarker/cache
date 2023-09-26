Class web.DHCICUStatisticXZRY Extends %RegisteredObject
{

/// 通过科室Id获取关联病区Id
/// w ##class(web.DHCICUStatNewUntils).GetWardIdStrByLocIdStr(47)
ClassMethod GetWardIdStrByLocIdStr(locIdStr As %String) As %String
{
	s wardIdStr=""
	f i=1:1:$l(locIdStr,"^")
	{
		s locId=$p(locIdStr,"^",i)
		q:locId=""
		s wardLocId=""
		i '$d(^DHCICUPara(0,"Ctloc",locId)) s wardLocId=$o(^CTLOC(locId,"LINK",0,"Loc",""))
		e  s wardLocId=locId
		q:wardLocId=""
		s wardId=$o(^PAWARD(0,"WARD_LocationDR",wardLocId,0))
		q:wardId=""
		i wardIdStr'="" s wardIdStr=wardIdStr_"^"
		s wardIdStr=wardIdStr_wardId
	}
	q wardIdStr
}

/// ICU压力性损伤统计表
/// d ##class(%ResultSet).RunQuery("web.DHCICUStatisticXZRY","FindSkinCareInfo","2021-11-10","2021-11-11","45")
Query FindSkinCareInfo(startDate As %String, endDate As %String, locIdStr As %String) As %Query(ROWSPEC = "icuaId,patName,patSex,patAge,icuInDateTime,icuOutDateTime,wardDesc,icuBed,ResidentDoctor,ICUGuardDay,icuDiag,papmiMedicare,admNo,ICUALeaveCondition,PFPGICULY,PFPGICUMJ,PFPGICUQK,PFPGICUXGYY,PFPGICUHLCS,PFPGICUZG")
{
}

ClassMethod FindSkinCareInfoExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, locIdStr As %String) As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	set inquiryStDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	set inquiryEndDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	
	if ((locIdStr="")||(inquiryStDate>inquiryEndDate))
	{
		s qHandle=$lb(0,repid,0)
		q $$$OK
	}
	
	s wardIdStr=##class(web.DHCICUStatisticXZRY).GetWardIdStrByLocIdStr(locIdStr)
	
	k ^tmpFindSkinCareInfo("Match")
	f date=inquiryStDate:1:inquiryEndDate d
	.s icuaId=""
	.f  s icuaId=$o(^DHCICUOrder(0,"SttDateTime",date,icuaId)) q:icuaId=""  d		
	..set inDateTime=##class(web.DHCICUCom).GetWardInDateTime("",icuaId,"","","^","D")
	..set inDate=$p(inDateTime,"^"),inTime=$p(inDateTime,"^",2)
	..set outDateTime=##class(web.DHCICUCom).GetWardOutDateTime("",icuaId,"","","^","D")
	..set outDate=$p(outDateTime,"^",1),outTime=$p(outDateTime,"^",2)
	..;q:'##class(web.DHCICUStat).IfInSearch(wardIdStr,icuaId,inquiryStDate,inquiryEndDate,"",date)
	..s icuBedId=$p($g(^DHCICUArrange(+icuaId)),"^",4)
	..q:(wardIdStr'="")&(("^"_wardIdStr_"^")'[("^"_(+icuBedId)_"^"))
	..q:$d(^tmpFindSkinCareInfo("Match",icuaId))
	..s ^tmpFindSkinCareInfo("Match",icuaId)=""
	
	set icuaId="" for  set icuaId=$o(^tmpFindSkinCareInfo("Match",icuaId)) q:icuaId=""  d
	.do OutputStatInfo

	s qHandle=$lb(0,repid,0)
	q $$$OK
	
OutputStatInfo
	set patName=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"patName")
	set patSex=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"patSex")
	set patAge=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"patAge")
	set icuInDateTime=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"icuInDateTime")
	set icuOutDateTime=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"icuOutDateTime")
	set wardDesc=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"wardDesc")
	set icuBed=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"icuBed")
	set wardDiag=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"wardDiag")
	set ResidentDoctor=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"ResidentDoctor")
	set ICUGuardDay=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"ICUGuardDay")
	set icuDiag=..GetMRDesc(icuaId)
	set papmiMedicare=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"papmiMedicare")
	set admNo=$p($g(^DHCICUArrange(+icuaId)),"^",1)
	set ICUALeaveCondition=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"ICUALeaveCondition")
	set inDateTime=##class(web.DHCICUCom).GetWardInDateTime("",icuaId,"","","^","D")
	set inDate=$p(inDateTime,"^"),inTime=$p(inDateTime,"^",2)
	set outDateTime=##class(web.DHCICUCom).GetWardOutDateTime("",icuaId,"","","^","D")
	set outDate=$p(outDateTime,"^",1),outTime=$p(outDateTime,"^",2)
	//来源
	set PFPGICULY=##class(web.DHCICUOrder).GetRecordValue(icuaId,"PFPGICULY",inDate,inTime,outDate,outTime,"First")
	//面积
	set PFPGICUMJ=##class(web.DHCICUOrder).GetRecordValue(icuaId,"PFPGICUMJ",inDate,inTime,outDate,outTime,"First")
	//相关临床表现
	set PFPGICUQK=##class(web.DHCICUOrder).GetRecordValue(icuaId,"PFPGICUQK",inDate,inTime,outDate,outTime,"First")
	//相关护理诊断
	set PFPGICUXGYY=##class(web.DHCICUOrder).GetRecordValue(icuaId,"PFPGICUXGYY",inDate,inTime,outDate,outTime,"First")
	//相关护理措施
	set PFPGICUHLCS=##class(web.DHCICUOrder).GetRecordValue(icuaId,"PFPGICUHLCS",inDate,inTime,outDate,outTime,"First")
	//转归
	set PFPGICUZG=##class(web.DHCICUOrder).GetRecordValue(icuaId,"PFPGICUZG",inDate,inTime,outDate,outTime,"First")
	quit:((PFPGICULY="")&&(PFPGICUMJ="")&&(PFPGICUQK="")&&(PFPGICUXGYY="")&&(PFPGICUHLCS="")&&(PFPGICUZG=""))
	
	do OutputRow
	quit

OutputRow
	s Data=$lb(icuaId,patName,patSex,patAge,icuInDateTime,icuOutDateTime,wardDesc,icuBed,ResidentDoctor,ICUGuardDay,icuDiag,papmiMedicare,admNo,ICUALeaveCondition,PFPGICULY,PFPGICUMJ,PFPGICUQK,PFPGICUXGYY,PFPGICUHLCS,PFPGICUZG)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod FindSkinCareInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSkinCareInfoExecute ]
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

ClassMethod FindSkinCareInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSkinCareInfoExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCICUStatisticXZRY","FindSkinCareStat","2021-11-10","2021-11-11","45")
Query FindSkinCareStat(startDate As %String, endDate As %String, locIdStr As %String) As %Query(ROWSPEC = "yearMonth,InHospitalCount,OutHospitalCount,InLocCount,OutLocCount,total,AllPatientCount,percent")
{
}

ClassMethod FindSkinCareStatExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, locIdStr As %String) As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	set inquiryStDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	set inquiryEndDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	
	if ((locIdStr="")||(inquiryStDate>inquiryEndDate))
	{
		s qHandle=$lb(0,repid,0)
		q $$$OK
	}
	
	s wardIdStr=##class(web.DHCICUStatisticXZRY).GetWardIdStrByLocIdStr(locIdStr)
	
	k ^tmpFindSkinCareStat
	f date=inquiryStDate:1:inquiryEndDate d
	.s icuaId=""
	.f  s icuaId=$o(^DHCICUOrder(0,"SttDateTime",date,icuaId)) q:icuaId=""  d		
	..set inDateTime=##class(web.DHCICUCom).GetWardInDateTime("",icuaId,"","","^","D")
	..set inDate=$p(inDateTime,"^"),inTime=$p(inDateTime,"^",2)
	..set outDateTime=##class(web.DHCICUCom).GetWardOutDateTime("",icuaId,"","","^","D")
	..set outDate=$p(outDateTime,"^",1),outTime=$p(outDateTime,"^",2)
	..s icuBedId=$p($g(^DHCICUArrange(+icuaId)),"^",4)
	..q:(wardIdStr'="")&(("^"_wardIdStr_"^")'[("^"_(+icuBedId)_"^"))
	..set dateT=$zd(date,3)
	..set year=$p(dateT,"-",1)
	..set month=$p(dateT,"-",2)
	..set yearMonth=year_"-"_month
	..quit:$d(^tmpFindSkinCareStat(yearMonth,"AllPatientCount",icuaId))
	..set ^tmpFindSkinCareStat(yearMonth,"AllPatientCount",icuaId)=""
	..set stDate=date,eDate=date
	..set stTime="00:00:00",eTime="23:59:59"
	..//来源
	..set Source=##class(web.DHCICUOrder).GetRecordValue(icuaId,"PFPGICULY",stDate,stTime,eDate,eTime,"First")
	..//面积
	..set Area=##class(web.DHCICUOrder).GetRecordValue(icuaId,"PFPGICUMJ",stDate,stTime,eDate,eTime,"First")
	..//相关临床表现
	..set ClinicalFeature=##class(web.DHCICUOrder).GetRecordValue(icuaId,"PFPGICUQK",stDate,stTime,eDate,eTime,"First")
	..//相关护理诊断
	..set NursingDiagnosis=##class(web.DHCICUOrder).GetRecordValue(icuaId,"PFPGICUXGYY",stDate,stTime,eDate,eTime,"First")
	..//相关护理措施
	..set NursingMeasures=##class(web.DHCICUOrder).GetRecordValue(icuaId,"PFPGICUHLCS",stDate,stTime,eDate,eTime,"First")
	..//转归
	..set TurnOut=##class(web.DHCICUOrder).GetRecordValue(icuaId,"PFPGICUZG",stDate,stTime,eDate,eTime,"First")
	..if ((Source'="")||(Area'="")||(ClinicalFeature'="")||(NursingDiagnosis'="")||(NursingMeasures'="")||(TurnOut'="")) do
	...set ^tmpFindSkinCareStat(yearMonth,"All",icuaId)=""
	...set note=dateT_" 来源:"_Source_" 面积:"_Area_" "_ClinicalFeature_" "_NursingDiagnosis_" "_NursingMeasures
	...if (Source="院内") do
	....set ^tmpFindSkinCareStat(yearMonth,"InHospitalCount",icuaId)=note
	...if (Source="院外") do
	....set ^tmpFindSkinCareStat(yearMonth,"OutHospitalCount",icuaId)=note
	...if (Source="科内") do
	....set ^tmpFindSkinCareStat(yearMonth,"InLocCount",icuaId)=note
	...if (Source="科外") do
	....set ^tmpFindSkinCareStat(yearMonth,"OutLocCount",icuaId)=note
	
	set yearMonth="" for  set yearMonth=$o(^tmpFindSkinCareStat(yearMonth)) q:yearMonth=""  d
	.set InHospitalCount=$$CountIcuaId(yearMonth, "InHospitalCount")
	.set OutHospitalCount=$$CountIcuaId(yearMonth, "OutHospitalCount")
	.set InLocCount=$$CountIcuaId(yearMonth, "InLocCount")
	.set OutLocCount=$$CountIcuaId(yearMonth, "OutLocCount")
	.set total=InHospitalCount+OutHospitalCount+InLocCount+OutLocCount
	.set AllPatientCount=$$CountIcuaId(yearMonth, "AllPatientCount")
	.set percent=0
	.if AllPatientCount>0 set percent=$fn(total/AllPatientCount,"",2)
	.do OutputRow

	s qHandle=$lb(0,repid,0)
	q $$$OK
	
CountIcuaId(yearMonth,code)
	set count=0
	set id="" for  set id=$o(^tmpFindSkinCareStat(yearMonth,code,id)) q:id=""  d
	.set count=count+1
	quit count

OutputRow
	s Data=$lb(yearMonth,InHospitalCount,OutHospitalCount,InLocCount,OutLocCount,total,AllPatientCount,percent)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod FindSkinCareStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSkinCareStatExecute ]
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

ClassMethod FindSkinCareStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSkinCareStatExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCICUStatisticXZRY","FindSkinCareStatPatInfo","2021-08","AllPatientCount")
Query FindSkinCareStatPatInfo(yearMonth As %String, statCode As %String) As %Query(ROWSPEC = "icuaId,patName,patSex,patAge,icuInDateTime,icuOutDateTime,wardDesc,icuBed,ResidentDoctor,ICUGuardDay,icuDiag,papmiMedicare,admNo,ICUALeaveCondition,note")
{
}

ClassMethod FindSkinCareStatPatInfoExecute(ByRef qHandle As %Binary, yearMonth As %String, statCode As %String) As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1

	if ((yearMonth="")||(statCode=""))
	{
		s qHandle=$lb(0,repid,0)
		q $$$OK
	}
	
	set icuaId="" for  set icuaId=$o(^tmpFindSkinCareStat(yearMonth,statCode,icuaId)) q:icuaId=""  d
	.do OutputStatInfo

	s qHandle=$lb(0,repid,0)
	q $$$OK
	
OutputStatInfo
	set patName=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"patName")
	set patSex=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"patSex")
	set patAge=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"patAge")
	set icuInDateTime=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"icuInDateTime")
	set icuOutDateTime=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"icuOutDateTime")
	set wardDesc=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"wardDesc")
	set icuBed=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"icuBed")
	set wardDiag=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"wardDiag")
	set ResidentDoctor=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"ResidentDoctor")
	set ICUGuardDay=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"ICUGuardDay")
	set icuDiag=..GetMRDesc(icuaId)
	set papmiMedicare=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"papmiMedicare")
	set admNo=$p($g(^DHCICUArrange(+icuaId)),"^",1)
	set ICUALeaveCondition=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"ICUALeaveCondition")
	set note=$g(^tmpFindSkinCareStat(yearMonth,statCode,icuaId))	
	
	do OutputRow
	quit

OutputRow
	s Data=$lb(icuaId,patName,patSex,patAge,icuInDateTime,icuOutDateTime,wardDesc,icuBed,ResidentDoctor,ICUGuardDay,icuDiag,papmiMedicare,admNo,ICUALeaveCondition,note)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod FindSkinCareStatPatInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSkinCareStatPatInfoExecute ]
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

ClassMethod FindSkinCareStatPatInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSkinCareStatPatInfoExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCICUStatisticXZRY","FindICUMonitorLogStat","2021-11-01","2021-11-11","45")
Query FindICUMonitorLogStat(startDate As %String, endDate As %String, locIdStr As %String) As %Query(ROWSPEC = "dateT,yearMonth,AllPatientCount,NewInICUCount,UrinaryCatheterCount,NewUrinaryCatheterCount,CVTubeCount,NewCVTubeCount,PeripheralVein,NewPeripheralVein,InvasiveVentilator,BedUp30,DeathCount,Constraint")
{
}

ClassMethod FindICUMonitorLogStatExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, locIdStr As %String) As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	set inquiryStDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	set inquiryEndDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	
	if ((locIdStr="")||(inquiryStDate>inquiryEndDate))
	{
		s qHandle=$lb(0,repid,0)
		q $$$OK
	}
	
	s wardIdStr=##class(web.DHCICUStatisticXZRY).GetWardIdStrByLocIdStr(locIdStr)
	
	k ^tmpFindICUMonitorLogStat
	f date=inquiryStDate:1:inquiryEndDate d
	.s icuaId=""
	.f  s icuaId=$o(^DHCICUOrder(0,"SttDateTime",date,icuaId)) q:icuaId=""  d		
	..set inDateTime=##class(web.DHCICUCom).GetWardInDateTime("",icuaId,"","","^","D")
	..set inDate=$p(inDateTime,"^"),inTime=$p(inDateTime,"^",2)
	..set outDateTime=##class(web.DHCICUCom).GetWardOutDateTime("",icuaId,"","","^","D")
	..set outDate=$p(outDateTime,"^",1),outTime=$p(outDateTime,"^",2)
	..s icuBedId=$p($g(^DHCICUArrange(+icuaId)),"^",4)
	..q:(wardIdStr'="")&(("^"_wardIdStr_"^")'[("^"_(+icuBedId)_"^"))
	..set dateT=$zd(date,3)
	..quit:$d(^tmpFindICUMonitorLogStat(dateT,"AllPatientCount",icuaId))
	..set ^tmpFindICUMonitorLogStat(dateT,"AllPatientCount",icuaId)=""
	..set stDate=date,eDate=date
	..set stTime="00:00:00",eTime="23:59:59"
	..//新入科患者
	..if inDate=date set ^tmpFindICUMonitorLogStat(dateT,"NewInICUCount",icuaId)="患者在"_outDateTime_"入科"
	..//留置尿导管
	..set NIAOSE=##class(web.DHCICUOrder).GetRecordValue(icuaId,"NIAOSE",stDate,stTime,eDate,eTime,"First")         ;尿色
	..set NIAOGUANZK=##class(web.DHCICUOrder).GetRecordValue(icuaId,"NIAOGUANZK",stDate,stTime,eDate,eTime,"First") ;尿管状况
	..set CgDate=##class(web.DHCICUOrder).GetRecordValue(icuaId,"CgDate",stDate,stTime,eDate,eTime,"First")         ;插管日期
	..set BgDate=##class(web.DHCICUOrder).GetRecordValue(icuaId,"BgDate",stDate,stTime,eDate,eTime,"First")         ;拔管日期
	..set xh=##class(web.DHCICUOrder).GetRecordValue(icuaId,"xh",stDate,stTime,eDate,eTime,"First")                 ;型号
	..set ngcxsj=##class(web.DHCICUOrder).GetRecordValue(icuaId,"ngcxsj",stDate,stTime,eDate,eTime,"First")         ;持续时间
	..if ((NIAOSE'="")||(NIAOGUANZK'="")||(CgDate'="")||(BgDate'="")||(xh'="")||(ngcxsj'="")) do
	...set ^tmpFindICUMonitorLogStat(dateT,"UrinaryCatheterCount",icuaId)=dateT_" "_NIAOSE_" "_CgDate_" "_BgDate_" "_xh_" "_ngcxsj
	...if CgDate=dateT do
	....//当日新留置导尿管
	....set ^tmpFindICUMonitorLogStat(dateT,"NewUrinaryCatheterCount",icuaId)=dateT_" 尿色:"_NIAOSE_" 置管日期:"_CgDate_" "_BgDate_" "_xh_" "_ngcxsj
	..//中心静脉置管
	..set CVTubeDate=##class(web.DHCICUOrder).GetRecordValue(icuaId,"CVTubeDate",stDate,stTime,eDate,eTime,"First")           ;置管日期
	..set CVTubeSituation=##class(web.DHCICUOrder).GetRecordValue(icuaId,"CVTubeSituation",stDate,stTime,eDate,eTime,"First") ;置管情况
	..set CVTubeNursing=##class(web.DHCICUOrder).GetRecordValue(icuaId,"CVTubeNursing",stDate,stTime,eDate,eTime,"First")         ;置管护理
	..set CVTubeLoc=##class(web.DHCICUOrder).GetRecordValue(icuaId,"CVTubeLoc",stDate,stTime,eDate,eTime,"First")         ;置管科室
	..set CVTubeinfection=##class(web.DHCICUOrder).GetRecordValue(icuaId,"CVTubeinfection",stDate,stTime,eDate,eTime,"First")                 ;置管部位感染
	..set CVTubeType=##class(web.DHCICUOrder).GetRecordValue(icuaId,"CVTubeType",stDate,stTime,eDate,eTime,"First")         ;置管类型
	..set CVLumenNumber=##class(web.DHCICUOrder).GetRecordValue(icuaId,"CVLumenNumber",stDate,stTime,eDate,eTime,"First")         ;置管腔数
	..set CVTubeDrawDate=##class(web.DHCICUOrder).GetRecordValue(icuaId,"CVTubeDrawDate",stDate,stTime,eDate,eTime,"First")                 ;拔管日期
	..set CVTubeDrawReason=##class(web.DHCICUOrder).GetRecordValue(icuaId,"CVTubeDrawReason",stDate,stTime,eDate,eTime,"First")         ;拔管原因
	..if ((CVTubeDate'="")||(CVTubeSituation'="")||(CVTubeNursing'="")||(CVTubeLoc'="")||(CVTubeinfection'="")||(CVTubeType'="")||(CVLumenNumber'="")||(CVTubeDrawDate'="")) do
	...//中心静脉
	...if ..GetMultValue(icuaId,"CVC1^zsgxjm^CVysgxjm^zjnjm^yjnjm^zgjm^ygjm^UserDefinedzxjm^zjnjm2^yjnjm2^yjzg",stDate,stTime,eDate,eTime)'="" do
	....set ^tmpFindICUMonitorLogStat(dateT,"CVTubeCount",icuaId)=dateT_" 中心静脉置管:"_CVTubeDate_" "_CVTubeSituation_" "_CVTubeNursing
	....if $p(CVTubeDate," ",1)=dateT do
	.....set ^tmpFindICUMonitorLogStat(dateT,"NewCVTubeCount",icuaId)=dateT_" 中心静脉置管:"_CVTubeDate_" "_CVTubeSituation_" "_CVTubeNursing
	...//外周静脉
	...if ..GetMultValue(icuaId,"zqb^yqb^zsb^ysb^zs^ys^zz^yz^UserDefinedwaizhou",stDate,stTime,eDate,eTime)'="" do
	....set ^tmpFindICUMonitorLogStat(dateT,"PeripheralVein",icuaId)=dateT_" 外周静脉置管:"_CVTubeDate_" "_CVTubeSituation_" "_CVTubeNursing
	....if $p(CVTubeDate," ",1)=dateT do
	.....set ^tmpFindICUMonitorLogStat(dateT,"NewPeripheralVein",icuaId)=dateT_" 外周静脉置管:"_CVTubeDate_" "_CVTubeSituation_" "_CVTubeNursing
	..//有创呼吸机数
	..set VentilatorMode=##class(web.DHCICUOrder).GetRecordValue(icuaId,"VentilatorMode",stDate,stTime,eDate,eTime,"First")  //呼吸模式
	..if VentilatorMode'="" do
	...set ^tmpFindICUMonitorLogStat(dateT,"InvasiveVentilator",icuaId)=dateT_" "_VentilatorMode
	..//床旁太高30°
	..set BedUp30=##class(web.DHCICUOrder).GetRecordValue(icuaId,"BedUp30",stDate,stTime,eDate,eTime,"First")  
	..if BedUp30'="" do
	...set ^tmpFindICUMonitorLogStat(dateT,"BedUp30",icuaId)=dateT_" "_BedUp30
	..//死亡人数
	..set ICUALeaveCondition=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"ICUALeaveCondition")
	..if ICUALeaveCondition="死亡" do
	...set ^tmpFindICUMonitorLogStat(dateT,"DeathCount",icuaId)=dateT_" "_ICUALeaveCondition
	..//约束身体
	..set Constraint1=##class(web.DHCICUOrder).GetRecordValue(icuaId,"Constraint1",stDate,stTime,eDate,eTime,"First")  
	..set Constraint2=##class(web.DHCICUOrder).GetRecordValue(icuaId,"Constraint2",stDate,stTime,eDate,eTime,"First")  
	..set Constraint3=##class(web.DHCICUOrder).GetRecordValue(icuaId,"Constraint3",stDate,stTime,eDate,eTime,"First")  
	..if ((Constraint1'="")||(Constraint2'="")||(Constraint3'="")) do
	...set ^tmpFindICUMonitorLogStat(dateT,"Constraint",icuaId)=dateT_" "_Constraint1_" "_Constraint2_" "_Constraint3
	
	set dateT="" for  set dateT=$o(^tmpFindICUMonitorLogStat(dateT)) q:dateT=""  d
	.set year=$piece(dateT,"-",1)
	.set month=$piece(dateT,"-",2)
	.set yearMonth=year_"年"_month_"月"
	.set AllPatientCount=$$CountIcuaId(dateT, "AllPatientCount")
	.set NewInICUCount=$$CountIcuaId(dateT, "NewInICUCount")
	.set UrinaryCatheterCount=$$CountIcuaId(dateT, "UrinaryCatheterCount")
	.set NewUrinaryCatheterCount=$$CountIcuaId(dateT, "NewUrinaryCatheterCount")
	.set CVTubeCount=$$CountIcuaId(dateT, "CVTubeCount")
	.set NewCVTubeCount=$$CountIcuaId(dateT, "NewCVTubeCount")
	.set PeripheralVein=$$CountIcuaId(dateT, "PeripheralVein")
	.set NewPeripheralVein=$$CountIcuaId(dateT, "NewPeripheralVein")
	.set InvasiveVentilator=$$CountIcuaId(dateT, "InvasiveVentilator")
	.set BedUp30=$$CountIcuaId(dateT, "BedUp30")
	.set DeathCount=$$CountIcuaId(dateT, "DeathCount")
	.set Constraint=$$CountIcuaId(dateT, "Constraint")
	.do OutputRow

	s qHandle=$lb(0,repid,0)
	q $$$OK
	
CountIcuaId(dateT,code)
	set count=0
	set id="" for  set id=$o(^tmpFindICUMonitorLogStat(dateT,code,id)) q:id=""  d
	.set count=count+1
	quit count

OutputRow
	s Data=$lb(dateT,yearMonth,AllPatientCount,NewInICUCount,UrinaryCatheterCount,NewUrinaryCatheterCount,CVTubeCount,NewCVTubeCount,PeripheralVein,NewPeripheralVein,InvasiveVentilator,BedUp30,DeathCount,Constraint)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod FindICUMonitorLogStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindICUMonitorLogStatExecute ]
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

ClassMethod GetMultValue(icuaId, codeStr, stDate, stTime, eDate, eTime) As %String
{
	set result=""
	for i=1:1:$l(codeStr,"^") 
	{
		set code=$piece(codeStr,"^",i)
		set value=##class(web.DHCICUOrder).GetRecordValue(icuaId,code,stDate,stTime,eDate,eTime,"First")
		if value'="" 
		{
			set icucriId=##class(web.DHCICUCom).GetIcuriIdByCode(code)
			set recordItemDesc=$p(^DHCICUC("RecordItem",+icucriId),"^",2)
			set result=recordItemDesc
		}
		quit:value'=""
	}
	quit result
}

/// d ##class(%ResultSet).RunQuery("web.DHCICUStatisticXZRY","FindICUMonitorLogStatPatInfo","2021-10-17","AllPatientCount")
Query FindICUMonitorLogStatPatInfo(date As %String, statCode As %String) As %Query(ROWSPEC = "icuaId,patName,patSex,patAge,icuInDateTime,icuOutDateTime,wardDesc,icuBed,ResidentDoctor,ICUGuardDay,icuDiag,papmiMedicare,admNo,ICUALeaveCondition,note")
{
}

ClassMethod FindICUMonitorLogStatPatInfoExecute(ByRef qHandle As %Binary, date As %String, statCode As %String) As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1

	if ((date="")||(statCode=""))
	{
		s qHandle=$lb(0,repid,0)
		q $$$OK
	}
	
	set icuaId="" for  set icuaId=$o(^tmpFindICUMonitorLogStat(date,statCode,icuaId)) q:icuaId=""  d
	.do OutputStatInfo

	s qHandle=$lb(0,repid,0)
	q $$$OK
	
OutputStatInfo
	set patName=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"patName")
	set patSex=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"patSex")
	set patAge=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"patAge")
	set icuInDateTime=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"icuInDateTime")
	set icuOutDateTime=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"icuOutDateTime")
	set wardDesc=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"wardDesc")
	set icuBed=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"icuBed")
	set wardDiag=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"wardDiag")
	set ResidentDoctor=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"ResidentDoctor")
	set ICUGuardDay=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"ICUGuardDay")
	set icuDiag=..GetMRDesc(icuaId)
	set papmiMedicare=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"papmiMedicare")
	set admNo=$p($g(^DHCICUArrange(+icuaId)),"^",1)
	set ICUALeaveCondition=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"ICUALeaveCondition")
	set note=$g(^tmpFindICUMonitorLogStat(date,statCode,icuaId))	
	
	do OutputRow
	quit

OutputRow
	s Data=$lb(icuaId,patName,patSex,patAge,icuInDateTime,icuOutDateTime,wardDesc,icuBed,ResidentDoctor,ICUGuardDay,icuDiag,papmiMedicare,admNo,ICUALeaveCondition,note)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod FindICUMonitorLogStatPatInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindICUMonitorLogStatPatInfoExecute ]
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

ClassMethod FindICUMonitorLogStatPatInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindICUMonitorLogStatPatInfoExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// 统计PICC置管个数、天数、拔管原因
/// d ##class(%ResultSet).RunQuery("web.DHCICUStatisticXZRY","FindPICCTubeInfo","2021-08-01","2021-11-11","45","正常")
Query FindPICCTubeInfo(startDate As %String, endDate As %String, locIdStr As %String, drawReason As %String = "") As %Query(ROWSPEC = "icuaId,patName,patSex,patAge,icuInDateTime,icuOutDateTime,wardDesc,icuBed,ResidentDoctor,ICUGuardDay,icuDiag,papmiMedicare,admNo,ICUALeaveCondition,PICCDesc,IntubeDaysInfo,IntubeDays,CVTubeDrawReason")
{
}

ClassMethod FindPICCTubeInfoExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, locIdStr As %String, drawReason As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	set inquiryStDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	set inquiryEndDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	
	if ((locIdStr="")||(inquiryStDate>inquiryEndDate))
	{
		s qHandle=$lb(0,repid,0)
		q $$$OK
	}
	
	s wardIdStr=##class(web.DHCICUStatisticXZRY).GetWardIdStrByLocIdStr(locIdStr)
	
	k ^tmpFindPICCTubeInfo
	f date=inquiryStDate:1:inquiryEndDate d
	.s icuaId=""
	.f  s icuaId=$o(^DHCICUOrder(0,"SttDateTime",date,icuaId)) q:icuaId=""  d		
	..set inDateTime=##class(web.DHCICUCom).GetWardInDateTime("",icuaId,"","","^","D")
	..set inDate=$p(inDateTime,"^"),inTime=$p(inDateTime,"^",2)
	..set outDateTime=##class(web.DHCICUCom).GetWardOutDateTime("",icuaId,"","","^","D")
	..set outDate=$p(outDateTime,"^",1),outTime=$p(outDateTime,"^",2)
	..;q:'##class(web.DHCICUStat).IfInSearch(wardIdStr,icuaId,inquiryStDate,inquiryEndDate,"",date)
	..s icuBedId=$p($g(^DHCICUArrange(+icuaId)),"^",4)
	..q:(wardIdStr'="")&(("^"_wardIdStr_"^")'[("^"_(+icuBedId)_"^"))
	..quit:$d(^tmpFindPICCTubeInfo("Match",icuaId))
	..s ^tmpFindPICCTubeInfo("Match",icuaId)=""
	..
	..set CVTubeDate=##class(web.DHCICUOrder).GetRecordValue(icuaId,"CVTubeDate",inDate,inTime,outDate,outTime,"First")           ;置管日期
	..set CVTubeSituation=##class(web.DHCICUOrder).GetRecordValue(icuaId,"CVTubeSituation",inDate,inTime,outDate,outTime,"First") ;置管情况
	..set CVTubeNursing=##class(web.DHCICUOrder).GetRecordValue(icuaId,"CVTubeNursing",inDate,inTime,outDate,outTime,"First")         ;置管护理
	..set CVTubeLoc=##class(web.DHCICUOrder).GetRecordValue(icuaId,"CVTubeLoc",inDate,inTime,outDate,outTime,"First")         ;置管科室
	..set CVTubeinfection=##class(web.DHCICUOrder).GetRecordValue(icuaId,"CVTubeinfection",inDate,inTime,outDate,outTime,"First")                 ;置管部位感染
	..set CVTubeType=##class(web.DHCICUOrder).GetRecordValue(icuaId,"CVTubeType",inDate,inTime,outDate,outTime,"First")         ;置管类型
	..set CVLumenNumber=##class(web.DHCICUOrder).GetRecordValue(icuaId,"CVLumenNumber",inDate,inTime,outDate,outTime,"First")         ;置管腔数
	..set CVTubeDrawDate=##class(web.DHCICUOrder).GetRecordValue(icuaId,"CVTubeDrawDate",inDate,inTime,outDate,outTime,"First")                 ;拔管日期
	..set CVTubeDrawReason=##class(web.DHCICUOrder).GetRecordValue(icuaId,"CVTubeDrawReason",inDate,inTime,outDate,outTime,"First")         ;拔管原因
	..if ((CVTubeDate'="")||(CVTubeSituation'="")||(CVTubeNursing'="")||(CVTubeLoc'="")||(CVTubeinfection'="")||(CVTubeType'="")||(CVLumenNumber'="")||(CVTubeDrawDate'="")) do
	...//PICC
	...set PICCDesc=..GetMultValue(icuaId,"zcgy^ycgy^zctjm^yctjm^zzzz^yzzz^picchy",inDate,inTime,outDate,outTime)
	...if PICCDesc'="" do
	....set ^tmpFindPICCTubeInfo("PICC",icuaId)=PICCDesc
	....set ^tmpFindPICCTubeInfo("PICC",icuaId,"IntubeDaysInfo")="插管日期:"_CVTubeDate_"<br/>拔管日期:"_CVTubeDrawDate
	....set CVTubeStartDateH=##class(DHCClinicCom).ConvertToDateH($p(CVTubeDate," ",1))
	....set CVTubeEndDateH=##class(DHCClinicCom).ConvertToDateH($p(CVTubeDrawDate," ",1))
	....set ^tmpFindPICCTubeInfo("PICC",icuaId,"IntubeDays")=(CVTubeEndDateH-CVTubeStartDateH)_"天"
	....set ^tmpFindPICCTubeInfo("PICC",icuaId,"CVTubeDrawReason")=CVTubeDrawReason
	
	set icuaId="" for  set icuaId=$o(^tmpFindPICCTubeInfo("PICC",icuaId)) q:icuaId=""  d
	.do OutputStatInfo

	s qHandle=$lb(0,repid,0)
	q $$$OK
	
OutputStatInfo
	set patName=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"patName")
	set patSex=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"patSex")
	set patAge=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"patAge")
	set icuInDateTime=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"icuInDateTime")
	set icuOutDateTime=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"icuOutDateTime")
	set wardDesc=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"wardDesc")
	set icuBed=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"icuBed")
	set wardDiag=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"wardDiag")
	set ResidentDoctor=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"ResidentDoctor")
	set ICUGuardDay=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"ICUGuardDay")
	set icuDiag=..GetMRDesc(icuaId)
	set papmiMedicare=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"papmiMedicare")
	set admNo=$p($g(^DHCICUArrange(+icuaId)),"^",1)
	set ICUALeaveCondition=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"ICUALeaveCondition")
	set PICCDesc=^tmpFindPICCTubeInfo("PICC",icuaId)
	set IntubeDaysInfo=^tmpFindPICCTubeInfo("PICC",icuaId,"IntubeDaysInfo")
	set IntubeDays=^tmpFindPICCTubeInfo("PICC",icuaId,"IntubeDays")
	set CVTubeDrawReason=^tmpFindPICCTubeInfo("PICC",icuaId,"CVTubeDrawReason")
	quit:((drawReason'="")&&(CVTubeDrawReason'[drawReason))
	
	do OutputRow
	quit

OutputRow
	s Data=$lb(icuaId,patName,patSex,patAge,icuInDateTime,icuOutDateTime,wardDesc,icuBed,ResidentDoctor,ICUGuardDay,icuDiag,papmiMedicare,admNo,ICUALeaveCondition,PICCDesc,IntubeDaysInfo,IntubeDays,CVTubeDrawReason)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod FindPICCTubeInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPICCTubeInfoExecute ]
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

ClassMethod FindPICCTubeInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPICCTubeInfoExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// 统计气管置管个数、天数、拔管原因
/// d ##class(%ResultSet).RunQuery("web.DHCICUStatisticXZRY","FindTracheaTubeInfo","2021-08-01","2021-11-11","45")
Query FindTracheaTubeInfo(startDate As %String, endDate As %String, locIdStr As %String, drawReason As %String = "") As %Query(ROWSPEC = "icuaId,patName,patSex,patAge,icuInDateTime,icuOutDateTime,wardDesc,icuBed,ResidentDoctor,ICUGuardDay,icuDiag,papmiMedicare,admNo,ICUALeaveCondition,TracheaDesc,IntubeDaysInfo,IntubeDays,TubeDrawReason")
{
}

ClassMethod FindTracheaTubeInfoExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, locIdStr As %String, drawReason As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	set inquiryStDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	set inquiryEndDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	
	if ((locIdStr="")||(inquiryStDate>inquiryEndDate))
	{
		s qHandle=$lb(0,repid,0)
		q $$$OK
	}
	
	s wardIdStr=##class(web.DHCICUStatisticXZRY).GetWardIdStrByLocIdStr(locIdStr)
	
	k ^tmpFindTracheaTubeInfo
	f date=inquiryStDate:1:inquiryEndDate d
	.s icuaId=""
	.f  s icuaId=$o(^DHCICUOrder(0,"SttDateTime",date,icuaId)) q:icuaId=""  d		
	..set inDateTime=##class(web.DHCICUCom).GetWardInDateTime("",icuaId,"","","^","D")
	..set inDate=$p(inDateTime,"^"),inTime=$p(inDateTime,"^",2)
	..set outDateTime=##class(web.DHCICUCom).GetWardOutDateTime("",icuaId,"","","^","D")
	..set outDate=$p(outDateTime,"^",1),outTime=$p(outDateTime,"^",2)
	..;q:'##class(web.DHCICUStat).IfInSearch(wardIdStr,icuaId,inquiryStDate,inquiryEndDate,"",date)
	..s icuBedId=$p($g(^DHCICUArrange(+icuaId)),"^",4)
	..q:(wardIdStr'="")&(("^"_wardIdStr_"^")'[("^"_(+icuBedId)_"^"))
	..q:$d(^tmpFindTracheaTubeInfo("Match",icuaId))
	..s ^tmpFindTracheaTubeInfo("Match",icuaId)=""
	..
	..set IntubationDate=##class(web.DHCICUOrder).GetRecordValue(icuaId,"IntubationDate",inDate,inTime,outDate,outTime,"First")           
	..set IntubationDept=##class(web.DHCICUOrder).GetRecordValue(icuaId,"IntubationDept",inDate,inTime,outDate,outTime,"First") 
	..set IntubationPosition=##class(web.DHCICUOrder).GetRecordValue(icuaId,"IntubationPosition",inDate,inTime,outDate,outTime,"First")         
	..set IntubationModel=##class(web.DHCICUOrder).GetRecordValue(icuaId,"IntubationModel",inDate,inTime,outDate,outTime,"First")         
	..set CatheterNursing=##class(web.DHCICUOrder).GetRecordValue(icuaId,"CatheterNursing",inDate,inTime,outDate,outTime,"First")                 
	..set SiteCondition=##class(web.DHCICUOrder).GetRecordValue(icuaId,"SiteCondition",inDate,inTime,outDate,outTime,"First")         
	..set SiteCondition2=##class(web.DHCICUOrder).GetRecordValue(icuaId,"SiteCondition2",inDate,inTime,outDate,outTime,"First")         
	..set jmcgd=##class(web.DHCICUOrder).GetRecordValue(icuaId,"jmcgd",inDate,inTime,outDate,outTime,"First")                 
	..set qnyjc=##class(web.DHCICUOrder).GetRecordValue(icuaId,"qnyjc",inDate,inTime,outDate,outTime,"First") 
	..set zlxd=##class(web.DHCICUOrder).GetRecordValue(icuaId,"zlxd",inDate,inTime,outDate,outTime,"First")   
	..set bgri=##class(web.DHCICUOrder).GetRecordValue(icuaId,"bgri",inDate,inTime,outDate,outTime,"First")   
	..set bgyy=##class(web.DHCICUOrder).GetRecordValue(icuaId,"bgyy",inDate,inTime,outDate,outTime,"All")   
	..set cxsj=##class(web.DHCICUOrder).GetRecordValue(icuaId,"cxsj",inDate,inTime,outDate,outTime,"First")  
	..set OpMethodTraceotomy=##class(web.DHCICUOrder).GetRecordValue(icuaId,"OpMethodTraceotomy",inDate,inTime,outDate,outTime,"First")          
	..if ((IntubationDate'="")||(IntubationDept'="")||(IntubationPosition'="")||(IntubationModel'="")||(CatheterNursing'="")||(SiteCondition'="")||(SiteCondition2'="")||(bgri'="")) do
	...//PICC
	...set TracheaDesc=..GetMultValue(icuaId,"TracheaCannula^TracheotomyTube^UserDefinedTracheotomyTube",inDate,inTime,outDate,outTime)
	...if TracheaDesc'="" do
	....set ^tmpFindTracheaTubeInfo("Trachea",icuaId)=TracheaDesc
	....set ^tmpFindTracheaTubeInfo("Trachea",icuaId,"IntubeDaysInfo")="插管日期:"_IntubationDate_"<br/>拔管日期:"_bgri
	....set TubeStartDateH=##class(DHCClinicCom).ConvertToDateH($p(IntubationDate," ",1))
	....set TubeEndDateH=##class(DHCClinicCom).ConvertToDateH($p(bgri," ",1))
	....set ^tmpFindTracheaTubeInfo("Trachea",icuaId,"IntubeDays")=(TubeEndDateH-TubeStartDateH)_"天"
	....set ^tmpFindTracheaTubeInfo("Trachea",icuaId,"TubeDrawReason")=bgyy  //拔管原因
	
	set icuaId="" for  set icuaId=$o(^tmpFindTracheaTubeInfo("Trachea",icuaId)) q:icuaId=""  d
	.do OutputStatInfo

	s qHandle=$lb(0,repid,0)
	q $$$OK
	
OutputStatInfo
	set patName=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"patName")
	set patSex=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"patSex")
	set patAge=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"patAge")
	set icuInDateTime=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"icuInDateTime")
	set icuOutDateTime=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"icuOutDateTime")
	set wardDesc=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"wardDesc")
	set icuBed=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"icuBed")
	set wardDiag=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"wardDiag")
	set ResidentDoctor=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"ResidentDoctor")
	set ICUGuardDay=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"ICUGuardDay")
	set icuDiag=..GetMRDesc(icuaId)
	set papmiMedicare=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"papmiMedicare")
	set admNo=$p($g(^DHCICUArrange(+icuaId)),"^",1)
	set ICUALeaveCondition=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"ICUALeaveCondition")
	set TracheaDesc=^tmpFindTracheaTubeInfo("Trachea",icuaId)
	set IntubeDaysInfo=^tmpFindTracheaTubeInfo("Trachea",icuaId,"IntubeDaysInfo")
	set IntubeDays=^tmpFindTracheaTubeInfo("Trachea",icuaId,"IntubeDays")
	set TubeDrawReason=^tmpFindTracheaTubeInfo("Trachea",icuaId,"TubeDrawReason")
	quit:((drawReason'="")&&(TubeDrawReason'[drawReason))
	
	do OutputRow
	quit

OutputRow
	s Data=$lb(icuaId,patName,patSex,patAge,icuInDateTime,icuOutDateTime,wardDesc,icuBed,ResidentDoctor,ICUGuardDay,icuDiag,papmiMedicare,admNo,ICUALeaveCondition,TracheaDesc,IntubeDaysInfo,IntubeDays,TubeDrawReason)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod FindTracheaTubeInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTracheaTubeInfoExecute ]
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

ClassMethod FindTracheaTubeInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTracheaTubeInfoExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// 统计胃管置管个数、天数、拔管原因
/// d ##class(%ResultSet).RunQuery("web.DHCICUStatisticXZRY","FindStomachTubeInfo","2021-09-01","2021-11-11","45")
Query FindStomachTubeInfo(startDate As %String, endDate As %String, locIdStr As %String, drawReason As %String = "") As %Query(ROWSPEC = "icuaId,patName,patSex,patAge,icuInDateTime,icuOutDateTime,wardDesc,icuBed,ResidentDoctor,ICUGuardDay,icuDiag,papmiMedicare,admNo,ICUALeaveCondition,TracheaDesc,IntubeDaysInfo,IntubeDays,TubeDrawReason,WGdgzt,WGwyys,WGkcyys,WGdghl,WGzrqs,WGzrsd")
{
}

ClassMethod FindStomachTubeInfoExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, locIdStr As %String, drawReason As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	set inquiryStDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	set inquiryEndDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	
	if ((locIdStr="")||(inquiryStDate>inquiryEndDate))
	{
		s qHandle=$lb(0,repid,0)
		q $$$OK
	}
	
	s wardIdStr=##class(web.DHCICUStatisticXZRY).GetWardIdStrByLocIdStr(locIdStr)
	
	k ^tmpFindStomachTubeInfo
	f date=inquiryStDate:1:inquiryEndDate d
	.s icuaId=""
	.f  s icuaId=$o(^DHCICUOrder(0,"SttDateTime",date,icuaId)) q:icuaId=""  d		
	..set inDateTime=##class(web.DHCICUCom).GetWardInDateTime("",icuaId,"","","^","D")
	..set inDate=$p(inDateTime,"^"),inTime=$p(inDateTime,"^",2)
	..set outDateTime=##class(web.DHCICUCom).GetWardOutDateTime("",icuaId,"","","^","D")
	..set outDate=$p(outDateTime,"^",1),outTime=$p(outDateTime,"^",2)
	..;q:'##class(web.DHCICUStat).IfInSearch(wardIdStr,icuaId,inquiryStDate,inquiryEndDate,"",date)
	..s icuBedId=$p($g(^DHCICUArrange(+icuaId)),"^",4)
	..q:(wardIdStr'="")&(("^"_wardIdStr_"^")'[("^"_(+icuBedId)_"^"))
	..q:$d(^tmpFindStomachTubeInfo("Match",icuaId))
	..s ^tmpFindStomachTubeInfo("Match",icuaId)=""
	..
	..set WGzrqs=##class(web.DHCICUOrder).GetRecordValue(icuaId,"WGzrqs",inDate,inTime,outDate,outTime,"First")           
	..set WGzrsd=##class(web.DHCICUOrder).GetRecordValue(icuaId,"WGzrsd",inDate,inTime,outDate,outTime,"First") 
	..set WGdgzt=##class(web.DHCICUOrder).GetRecordValue(icuaId,"WGdgzt",inDate,inTime,outDate,outTime,"First")         
	..set WGwyys=##class(web.DHCICUOrder).GetRecordValue(icuaId,"WGwyys",inDate,inTime,outDate,outTime,"First")         
	..set WGkcyys=##class(web.DHCICUOrder).GetRecordValue(icuaId,"WGkcyys",inDate,inTime,outDate,outTime,"First")                 
	..set WGdghl=##class(web.DHCICUOrder).GetRecordValue(icuaId,"WGdghl",inDate,inTime,outDate,outTime,"First")         
	..set WGdgztKC=##class(web.DHCICUOrder).GetRecordValue(icuaId,"WGdgztKC",inDate,inTime,outDate,outTime,"First")         
	..set WGShiJian=##class(web.DHCICUOrder).GetRecordValue(icuaId,"WGShiJian",inDate,inTime,outDate,outTime,"First")                 
	..set WGContinueTime=##class(web.DHCICUOrder).GetRecordValue(icuaId,"WGContinueTime",inDate,inTime,outDate,outTime,"First") 
	..set WGDrawDate=##class(web.DHCICUOrder).GetRecordValue(icuaId,"WGDrawDate",inDate,inTime,outDate,outTime,"First")   
	..if ((WGzrqs'="")||(WGzrsd'="")||(WGdgzt'="")||(WGwyys'="")||(WGkcyys'="")||(WGdghl'="")||(WGdgztKC'="")||(WGShiJian'="")) do
	...//StomachTube
	...set StomachTubeDesc=..GetMultValue(icuaId,"ShiftTubeJW^ShiftTubeKCYYG^ShiftTubeKCZL^ShiftTubeSEZCYYG^ShiftTubeWZL^UserDefinedweiguan",inDate,inTime,outDate,outTime)
	...if StomachTubeDesc'="" do
	....set ^tmpFindStomachTubeInfo("StomachTube",icuaId)=StomachTubeDesc
	....set ^tmpFindStomachTubeInfo("StomachTube",icuaId,"IntubeDaysInfo")="插管日期:"_WGShiJian_"<br/>拔管日期:"_WGDrawDate
	....set TubeStartDateH=##class(DHCClinicCom).ConvertToDateH($p(WGShiJian," ",1))
	....set TubeEndDateH=##class(DHCClinicCom).ConvertToDateH($p(WGDrawDate," ",1))
	....set ^tmpFindStomachTubeInfo("StomachTube",icuaId,"IntubeDays")=(TubeEndDateH-TubeStartDateH)_"天"
	....set ^tmpFindStomachTubeInfo("StomachTube",icuaId,"TubeDrawReason")=""  //拔管原因
	....set ^tmpFindStomachTubeInfo("StomachTube",icuaId,"WGdgzt")=WGdgzt  //导管状况
	....set ^tmpFindStomachTubeInfo("StomachTube",icuaId,"WGwyys")=WGwyys  //胃液颜色
	....set ^tmpFindStomachTubeInfo("StomachTube",icuaId,"WGkcyys")=WGkcyys  //空肠液颜色
	....set ^tmpFindStomachTubeInfo("StomachTube",icuaId,"WGdghl")=WGdghl  //导管护理
	....set ^tmpFindStomachTubeInfo("StomachTube",icuaId,"WGzrqs")=WGzrqs  //置入腔数
	....set ^tmpFindStomachTubeInfo("StomachTube",icuaId,"WGzrsd")=WGzrsd  //置入深度(CM)
	
	set icuaId="" for  set icuaId=$o(^tmpFindStomachTubeInfo("StomachTube",icuaId)) q:icuaId=""  d
	.do OutputStatInfo

	s qHandle=$lb(0,repid,0)
	q $$$OK
	
OutputStatInfo
	set patName=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"patName")
	set patSex=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"patSex")
	set patAge=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"patAge")
	set icuInDateTime=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"icuInDateTime")
	set icuOutDateTime=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"icuOutDateTime")
	set wardDesc=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"wardDesc")
	set icuBed=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"icuBed")
	set wardDiag=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"wardDiag")
	set ResidentDoctor=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"ResidentDoctor")
	set ICUGuardDay=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"ICUGuardDay")
	set icuDiag=..GetMRDesc(icuaId)
	set papmiMedicare=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"papmiMedicare")
	set admNo=$p($g(^DHCICUArrange(+icuaId)),"^",1)
	set ICUALeaveCondition=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"ICUALeaveCondition")
	set StomachTubeDesc=^tmpFindStomachTubeInfo("StomachTube",icuaId)
	set IntubeDaysInfo=^tmpFindStomachTubeInfo("StomachTube",icuaId,"IntubeDaysInfo")
	set IntubeDays=^tmpFindStomachTubeInfo("StomachTube",icuaId,"IntubeDays")
	set TubeDrawReason=^tmpFindStomachTubeInfo("StomachTube",icuaId,"TubeDrawReason")
	set WGdgzt=^tmpFindStomachTubeInfo("StomachTube",icuaId,"WGdgzt")
	set WGwyys=^tmpFindStomachTubeInfo("StomachTube",icuaId,"WGwyys")
	set WGkcyys=^tmpFindStomachTubeInfo("StomachTube",icuaId,"WGkcyys")
	set WGdghl=^tmpFindStomachTubeInfo("StomachTube",icuaId,"WGdghl")
	set WGzrqs=^tmpFindStomachTubeInfo("StomachTube",icuaId,"WGzrqs")
	set WGzrsd=^tmpFindStomachTubeInfo("StomachTube",icuaId,"WGzrsd")
	quit:((drawReason'="")&&(TubeDrawReason'[drawReason))
	
	do OutputRow
	quit

OutputRow
	s Data=$lb(icuaId,patName,patSex,patAge,icuInDateTime,icuOutDateTime,wardDesc,icuBed,ResidentDoctor,ICUGuardDay,icuDiag,papmiMedicare,admNo,ICUALeaveCondition,StomachTubeDesc,IntubeDaysInfo,IntubeDays,TubeDrawReason,WGdgzt,WGwyys,WGkcyys,WGdghl,WGzrqs,WGzrsd)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod FindStomachTubeInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindStomachTubeInfoExecute ]
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

ClassMethod FindStomachTubeInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindStomachTubeInfoExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// 统计尿管置管个数、天数、拔管原因
/// d ##class(%ResultSet).RunQuery("web.DHCICUStatisticXZRY","FindUrinaryTubeInfo","2021-10-01","2021-11-11","45")
Query FindUrinaryTubeInfo(startDate As %String, endDate As %String, locIdStr As %String, drawReason As %String = "") As %Query(ROWSPEC = "icuaId,patName,patSex,patAge,icuInDateTime,icuOutDateTime,wardDesc,icuBed,ResidentDoctor,ICUGuardDay,icuDiag,papmiMedicare,admNo,ICUALeaveCondition,UrinaryDesc,IntubeDaysInfo,IntubeDays,TubeDrawReason,NIAOSE,NIAOGUANZK,xh,ngcxsj")
{
}

ClassMethod FindUrinaryTubeInfoExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, locIdStr As %String, drawReason As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	set inquiryStDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	set inquiryEndDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	
	if ((locIdStr="")||(inquiryStDate>inquiryEndDate))
	{
		s qHandle=$lb(0,repid,0)
		q $$$OK
	}
	
	s wardIdStr=##class(web.DHCICUStatisticXZRY).GetWardIdStrByLocIdStr(locIdStr)
	
	k ^tmpFindUrinaryTubeInfo
	f date=inquiryStDate:1:inquiryEndDate d
	.s icuaId=""
	.f  s icuaId=$o(^DHCICUOrder(0,"SttDateTime",date,icuaId)) q:icuaId=""  d		
	..set inDateTime=##class(web.DHCICUCom).GetWardInDateTime("",icuaId,"","","^","D")
	..set inDate=$p(inDateTime,"^"),inTime=$p(inDateTime,"^",2)
	..set outDateTime=##class(web.DHCICUCom).GetWardOutDateTime("",icuaId,"","","^","D")
	..set outDate=$p(outDateTime,"^",1),outTime=$p(outDateTime,"^",2)
	..;q:'##class(web.DHCICUStat).IfInSearch(wardIdStr,icuaId,inquiryStDate,inquiryEndDate,"",date)
	..s icuBedId=$p($g(^DHCICUArrange(+icuaId)),"^",4)
	..q:(wardIdStr'="")&(("^"_wardIdStr_"^")'[("^"_(+icuBedId)_"^"))
	..quit:$d(^tmpFindUrinaryTubeInfo("Match",icuaId))
	..s ^tmpFindUrinaryTubeInfo("Match",icuaId)=""
	..
	..set NIAOSE=##class(web.DHCICUOrder).GetRecordValue(icuaId,"NIAOSE",inDate,inTime,outDate,outTime,"First")           
	..set NIAOGUANZK=##class(web.DHCICUOrder).GetRecordValue(icuaId,"NIAOGUANZK",inDate,inTime,outDate,outTime,"First") 
	..set CgDate=##class(web.DHCICUOrder).GetRecordValue(icuaId,"CgDate",inDate,inTime,outDate,outTime,"First")         
	..set BgDate=##class(web.DHCICUOrder).GetRecordValue(icuaId,"BgDate",inDate,inTime,outDate,outTime,"First")         
	..set xh=##class(web.DHCICUOrder).GetRecordValue(icuaId,"xh",inDate,inTime,outDate,outTime,"First")                 
	..set ngcxsj=##class(web.DHCICUOrder).GetRecordValue(icuaId,"ngcxsj",inDate,inTime,outDate,outTime,"First")         
	..if ((NIAOSE'="")||(NIAOGUANZK'="")||(CgDate'="")||(BgDate'="")||(xh'="")||(ngcxsj'="")) do
	...//PICC
	...set UrinaryDesc=..GetMultValue(icuaId,"NGDNG^NGDNGqqq",inDate,inTime,outDate,outTime)
	...if UrinaryDesc'="" do
	....set ^tmpFindUrinaryTubeInfo("Urinary",icuaId)=UrinaryDesc
	....set ^tmpFindUrinaryTubeInfo("Urinary",icuaId,"IntubeDaysInfo")="插管日期:"_CgDate_"<br/>拔管日期:"_BgDate
	....set TubeStartDateH=##class(DHCClinicCom).ConvertToDateH($p(CgDate," ",1))
	....set TubeEndDateH=##class(DHCClinicCom).ConvertToDateH($p(BgDate," ",1))
	....set ^tmpFindUrinaryTubeInfo("Urinary",icuaId,"IntubeDays")=(TubeEndDateH-TubeStartDateH)_"天"
	....set ^tmpFindUrinaryTubeInfo("Urinary",icuaId,"TubeDrawReason")=""  //拔管原因
	....set ^tmpFindUrinaryTubeInfo("Urinary",icuaId,"NIAOSE")=NIAOSE  //尿色
	....set ^tmpFindUrinaryTubeInfo("Urinary",icuaId,"NIAOGUANZK")=NIAOGUANZK  //尿管状况
	....set ^tmpFindUrinaryTubeInfo("Urinary",icuaId,"xh")=xh  //型号
	....set ^tmpFindUrinaryTubeInfo("Urinary",icuaId,"ngcxsj")=ngcxsj  //持续时间
	
	set icuaId="" for  set icuaId=$o(^tmpFindUrinaryTubeInfo("Urinary",icuaId)) q:icuaId=""  d
	.do OutputStatInfo

	s qHandle=$lb(0,repid,0)
	q $$$OK
	
OutputStatInfo
	set patName=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"patName")
	set patSex=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"patSex")
	set patAge=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"patAge")
	set icuInDateTime=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"icuInDateTime")
	set icuOutDateTime=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"icuOutDateTime")
	set wardDesc=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"wardDesc")
	set icuBed=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"icuBed")
	set wardDiag=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"wardDiag")
	set ResidentDoctor=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"ResidentDoctor")
	set ICUGuardDay=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"ICUGuardDay")
	set icuDiag=..GetMRDesc(icuaId)
	set papmiMedicare=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"papmiMedicare")
	set admNo=$p($g(^DHCICUArrange(+icuaId)),"^",1)
	set ICUALeaveCondition=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"ICUALeaveCondition")
	set UrinaryDesc=^tmpFindUrinaryTubeInfo("Urinary",icuaId)
	set IntubeDaysInfo=^tmpFindUrinaryTubeInfo("Urinary",icuaId,"IntubeDaysInfo")
	set IntubeDays=^tmpFindUrinaryTubeInfo("Urinary",icuaId,"IntubeDays")
	set TubeDrawReason=^tmpFindUrinaryTubeInfo("Urinary",icuaId,"TubeDrawReason")
	set NIAOSE=^tmpFindUrinaryTubeInfo("Urinary",icuaId,"NIAOSE")
	set NIAOGUANZK=^tmpFindUrinaryTubeInfo("Urinary",icuaId,"NIAOGUANZK")
	set xh=^tmpFindUrinaryTubeInfo("Urinary",icuaId,"xh")
	set ngcxsj=^tmpFindUrinaryTubeInfo("Urinary",icuaId,"ngcxsj")
	quit:((drawReason'="")&&(TubeDrawReason'[drawReason))
	
	do OutputRow
	quit

OutputRow
	s Data=$lb(icuaId,patName,patSex,patAge,icuInDateTime,icuOutDateTime,wardDesc,icuBed,ResidentDoctor,ICUGuardDay,icuDiag,papmiMedicare,admNo,ICUALeaveCondition,UrinaryDesc,IntubeDaysInfo,IntubeDays,TubeDrawReason,NIAOSE,NIAOGUANZK,xh,ngcxsj)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod FindUrinaryTubeInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindUrinaryTubeInfoExecute ]
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

ClassMethod FindUrinaryTubeInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindUrinaryTubeInfoExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// 统计呼吸机模式CPAP的病人信息
/// d ##class(%ResultSet).RunQuery("web.DHCICUStatisticXZRY","FindCPAPVentilatorMode","2021-08-01","2021-11-11","45")
Query FindCPAPVentilatorMode(startDate As %String, endDate As %String, locIdStr As %String) As %Query(ROWSPEC = "icuaId,patName,patSex,patAge,icuInDateTime,icuOutDateTime,wardDesc,icuBed,ResidentDoctor,ICUGuardDay,icuDiag,papmiMedicare,admNo,ICUALeaveCondition,VentilatorMode,VentilatorDays")
{
}

ClassMethod FindCPAPVentilatorModeExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, locIdStr As %String) As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	set inquiryStDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	set inquiryEndDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	
	if ((locIdStr="")||(inquiryStDate>inquiryEndDate))
	{
		s qHandle=$lb(0,repid,0)
		q $$$OK
	}
	
	s wardIdStr=##class(web.DHCICUStatisticXZRY).GetWardIdStrByLocIdStr(locIdStr)
	
	k ^tmpFindCPAPVentilatorMode
	f date=inquiryStDate:1:inquiryEndDate d
	.s icuaId=""
	.f  s icuaId=$o(^DHCICUOrder(0,"SttDateTime",date,icuaId)) q:icuaId=""  d		
	..set inDateTime=##class(web.DHCICUCom).GetWardInDateTime("",icuaId,"","","^","D")
	..set inDate=$p(inDateTime,"^"),inTime=$p(inDateTime,"^",2)
	..set outDateTime=##class(web.DHCICUCom).GetWardOutDateTime("",icuaId,"","","^","D")
	..set outDate=$p(outDateTime,"^",1),outTime=$p(outDateTime,"^",2)
	..;q:'##class(web.DHCICUStat).IfInSearch(wardIdStr,icuaId,inquiryStDate,inquiryEndDate,"",date)
	..s icuBedId=$p($g(^DHCICUArrange(+icuaId)),"^",4)
	..q:(wardIdStr'="")&(("^"_wardIdStr_"^")'[("^"_(+icuBedId)_"^"))
	..q:$d(^tmpFindCPAPVentilatorMode("Match",icuaId))
	..s ^tmpFindCPAPVentilatorMode("Match",icuaId)=""
	..
	..set VentilatorMode=##class(web.DHCICUOrder).GetRecordValue(icuaId,"VentilatorMode",inDate,inTime,outDate,outTime,"First")           
	..quit:VentilatorMode'["CPAP"
	..set VentilatorDays=##class(web.DHCICUOrder).GetRecordValue(icuaId,"VentilatorMode",inDate,inTime,outDate,outTime,"DayTimes")           
	..set ^tmpFindCPAPVentilatorMode("VentilatorMode",icuaId)=VentilatorMode
	..set ^tmpFindCPAPVentilatorMode("VentilatorMode",icuaId,"VentilatorDays")=VentilatorDays
	
	set icuaId="" for  set icuaId=$o(^tmpFindCPAPVentilatorMode("VentilatorMode",icuaId)) q:icuaId=""  d
	.do OutputStatInfo

	s qHandle=$lb(0,repid,0)
	q $$$OK
	
OutputStatInfo
	set patName=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"patName")
	set patSex=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"patSex")
	set patAge=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"patAge")
	set icuInDateTime=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"icuInDateTime")
	set icuOutDateTime=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"icuOutDateTime")
	set wardDesc=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"wardDesc")
	set icuBed=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"icuBed")
	set wardDiag=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"wardDiag")
	set ResidentDoctor=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"ResidentDoctor")
	set ICUGuardDay=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"ICUGuardDay")
	set icuDiag=..GetMRDesc(icuaId)
	set papmiMedicare=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"papmiMedicare")
	set admNo=$p($g(^DHCICUArrange(+icuaId)),"^",1)
	set ICUALeaveCondition=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"ICUALeaveCondition")
	set VentilatorMode=^tmpFindCPAPVentilatorMode("VentilatorMode",icuaId)
	set VentilatorDays=^tmpFindCPAPVentilatorMode("VentilatorMode",icuaId,"VentilatorDays")
	
	do OutputRow
	quit

OutputRow
	s Data=$lb(icuaId,patName,patSex,patAge,icuInDateTime,icuOutDateTime,wardDesc,icuBed,ResidentDoctor,ICUGuardDay,icuDiag,papmiMedicare,admNo,ICUALeaveCondition,VentilatorMode,VentilatorDays)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod FindCPAPVentilatorModeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCPAPVentilatorModeExecute ]
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

ClassMethod FindCPAPVentilatorModeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCPAPVentilatorModeExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// 统计NICU的Branden等分数信息
/// d ##class(%ResultSet).RunQuery("web.DHCICUStatisticXZRY","FindNICUBrandenInfo","2021-08-01","2021-11-11","39")
Query FindNICUBrandenInfo(startDate As %String, endDate As %String, locIdStr As %String) As %Query(ROWSPEC = "icuaId,patName,patSex,patAge,icuInDateTime,icuOutDateTime,wardDesc,icuBed,ResidentDoctor,ICUGuardDay,icuDiag,papmiMedicare,admNo,ICUALeaveCondition,BrandenTotalScore,MorseTotalScore,NIPSTotalScore,Apgar1minTotalScore,Apgar5minTotalScore")
{
}

ClassMethod FindNICUBrandenInfoExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, locIdStr As %String) As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	set inquiryStDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	set inquiryEndDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	
	if ((locIdStr="")||(inquiryStDate>inquiryEndDate))
	{
		s qHandle=$lb(0,repid,0)
		q $$$OK
	}
	
	s wardIdStr=##class(web.DHCICUStatisticXZRY).GetWardIdStrByLocIdStr(locIdStr)
	
	k ^tmpFindNICUBrandenInfo
	f date=inquiryStDate:1:inquiryEndDate d
	.s icuaId=""
	.f  s icuaId=$o(^DHCICUOrder(0,"SttDateTime",date,icuaId)) q:icuaId=""  d		
	..set inDateTime=##class(web.DHCICUCom).GetWardInDateTime("",icuaId,"","","^","D")
	..set inDate=$p(inDateTime,"^"),inTime=$p(inDateTime,"^",2)
	..set outDateTime=##class(web.DHCICUCom).GetWardOutDateTime("",icuaId,"","","^","D")
	..set outDate=$p(outDateTime,"^",1),outTime=$p(outDateTime,"^",2)
	..;q:'##class(web.DHCICUStat).IfInSearch(wardIdStr,icuaId,inquiryStDate,inquiryEndDate,"",date)
	..s icuBedId=$p($g(^DHCICUArrange(+icuaId)),"^",4)
	..q:(wardIdStr'="")&(("^"_wardIdStr_"^")'[("^"_(+icuBedId)_"^"))
	..q:$d(^tmpFindNICUBrandenInfo("Match",icuaId))
	..s ^tmpFindNICUBrandenInfo("Match",icuaId)=""
	..
	..set BrandenTotalScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,"BrandenTotalScore",inDate,inTime,outDate,outTime,"All")           
	..set MorseTotalScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,"MorseTotalScore",inDate,inTime,outDate,outTime,"All")           
	..set NIPSTotalScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,"NIPSTotalScore",inDate,inTime,outDate,outTime,"All")           
	..set Apgar1minTotalScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,"Apgar1minTotalScore",inDate,inTime,outDate,outTime,"All")  
	..set Apgar5minTotalScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,"Apgar5minTotalScore",inDate,inTime,outDate,outTime,"All")                    
	..quit:((BrandenTotalScore="")||(MorseTotalScore="")||(NIPSTotalScore="")||(Apgar1minTotalScore="")||(Apgar5minTotalScore=""))
	..set ^tmpFindNICUBrandenInfo("Branden",icuaId,"BrandenTotalScore")=BrandenTotalScore
	..set ^tmpFindNICUBrandenInfo("Branden",icuaId,"MorseTotalScore")=MorseTotalScore
	..set ^tmpFindNICUBrandenInfo("Branden",icuaId,"NIPSTotalScore")=NIPSTotalScore
	..set ^tmpFindNICUBrandenInfo("Branden",icuaId,"Apgar1minTotalScore")=Apgar1minTotalScore
	..set ^tmpFindNICUBrandenInfo("Branden",icuaId,"Apgar5minTotalScore")=Apgar5minTotalScore
	
	set icuaId="" for  set icuaId=$o(^tmpFindNICUBrandenInfo("Branden",icuaId)) q:icuaId=""  d
	.do OutputStatInfo

	s qHandle=$lb(0,repid,0)
	q $$$OK
	
OutputStatInfo
	set patName=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"patName")
	set patSex=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"patSex")
	set patAge=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"patAge")
	set icuInDateTime=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"icuInDateTime")
	set icuOutDateTime=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"icuOutDateTime")
	set wardDesc=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"wardDesc")
	set icuBed=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"icuBed")
	set wardDiag=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"wardDiag")
	set ResidentDoctor=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"ResidentDoctor")
	set ICUGuardDay=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"ICUGuardDay")
	set icuDiag=..GetMRDesc(icuaId)
	set papmiMedicare=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"papmiMedicare")
	set admNo=$p($g(^DHCICUArrange(+icuaId)),"^",1)
	set ICUALeaveCondition=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"ICUALeaveCondition")
	set BrandenTotalScore=^tmpFindNICUBrandenInfo("Branden",icuaId,"BrandenTotalScore")
	set MorseTotalScore=^tmpFindNICUBrandenInfo("Branden",icuaId,"MorseTotalScore")
	set NIPSTotalScore=^tmpFindNICUBrandenInfo("Branden",icuaId,"NIPSTotalScore")
	set Apgar1minTotalScore=^tmpFindNICUBrandenInfo("Branden",icuaId,"Apgar1minTotalScore")
	set Apgar5minTotalScore=^tmpFindNICUBrandenInfo("Branden",icuaId,"Apgar5minTotalScore")
	
	do OutputRow
	quit

OutputRow
	s Data=$lb(icuaId,patName,patSex,patAge,icuInDateTime,icuOutDateTime,wardDesc,icuBed,ResidentDoctor,ICUGuardDay,icuDiag,papmiMedicare,admNo,ICUALeaveCondition,BrandenTotalScore,MorseTotalScore,NIPSTotalScore,Apgar1minTotalScore,Apgar5minTotalScore)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod FindNICUBrandenInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNICUBrandenInfoExecute ]
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

ClassMethod FindNICUBrandenInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNICUBrandenInfoExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCICUStatisticXZRY","FindICU3TubeInfectionStat","2021-11-10","2021-11-11","45")
Query FindICU3TubeInfectionStat(startDate As %String, endDate As %String, locIdStr As %String) As %Query(ROWSPEC = "yearMonth,InHospitalCount,OutHospitalCount,InLocCount,OutLocCount,total,AllPatientCount,percent")
{
}

ClassMethod FindICU3TubeInfectionStatExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, locIdStr As %String) As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	set inquiryStDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	set inquiryEndDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	
	if ((locIdStr="")||(inquiryStDate>inquiryEndDate))
	{
		s qHandle=$lb(0,repid,0)
		q $$$OK
	}
	
	s wardIdStr=##class(web.DHCICUStatisticXZRY).GetWardIdStrByLocIdStr(locIdStr)
	
	k ^tmpFindICU3TubeInfectionStat
	f date=inquiryStDate:1:inquiryEndDate d
	.s icuaId=""
	.f  s icuaId=$o(^DHCICUOrder(0,"SttDateTime",date,icuaId)) q:icuaId=""  d		
	..set inDateTime=##class(web.DHCICUCom).GetWardInDateTime("",icuaId,"","","^","D")
	..set inDate=$p(inDateTime,"^"),inTime=$p(inDateTime,"^",2)
	..set outDateTime=##class(web.DHCICUCom).GetWardOutDateTime("",icuaId,"","","^","D")
	..set outDate=$p(outDateTime,"^",1),outTime=$p(outDateTime,"^",2)
	..s icuBedId=$p($g(^DHCICUArrange(+icuaId)),"^",4)
	..q:(wardIdStr'="")&(("^"_wardIdStr_"^")'[("^"_(+icuBedId)_"^"))
	..set dateT=$zd(date,3)
	..set year=$p(dateT,"-",1)
	..set month=$p(dateT,"-",2)
	..set yearMonth=year_"-"_month
	..quit:$d(^tmpFindICU3TubeInfectionStat(yearMonth,"AllPatientCount",icuaId))
	..set ^tmpFindICU3TubeInfectionStat(yearMonth,"AllPatientCount",icuaId)=""
	..set stDate=date,eDate=date
	..set stTime="00:00:00",eTime="23:59:59"
	..//中心静脉置管
	..set CVTubeDate=##class(web.DHCICUOrder).GetRecordValue(icuaId,"CVTubeDate",stDate,stTime,eDate,eTime,"First")           ;置管日期
	..set CVTubeSituation=##class(web.DHCICUOrder).GetRecordValue(icuaId,"CVTubeSituation",stDate,stTime,eDate,eTime,"First") ;置管情况
	..set CVTubeNursing=##class(web.DHCICUOrder).GetRecordValue(icuaId,"CVTubeNursing",stDate,stTime,eDate,eTime,"First")         ;置管护理
	..set CVTubeLoc=##class(web.DHCICUOrder).GetRecordValue(icuaId,"CVTubeLoc",stDate,stTime,eDate,eTime,"First")         ;置管科室
	..set CVTubeinfection=##class(web.DHCICUOrder).GetRecordValue(icuaId,"CVTubeinfection",stDate,stTime,eDate,eTime,"First")                 ;置管部位感染
	..set CVTubeType=##class(web.DHCICUOrder).GetRecordValue(icuaId,"CVTubeType",stDate,stTime,eDate,eTime,"First")         ;置管类型
	..set CVLumenNumber=##class(web.DHCICUOrder).GetRecordValue(icuaId,"CVLumenNumber",stDate,stTime,eDate,eTime,"First")         ;置管腔数
	..set CVTubeDrawDate=##class(web.DHCICUOrder).GetRecordValue(icuaId,"CVTubeDrawDate",stDate,stTime,eDate,eTime,"First")                 ;拔管日期
	..set CVTubeDrawReason=##class(web.DHCICUOrder).GetRecordValue(icuaId,"CVTubeDrawReason",stDate,stTime,eDate,eTime,"First")         ;拔管原因
	..if ((CVTubeDate'="")||(CVTubeSituation'="")||(CVTubeNursing'="")||(CVTubeLoc'="")||(CVTubeinfection'="")||(CVTubeType'="")||(CVLumenNumber'="")||(CVTubeDrawDate'="")) do
	...//中心静脉
	...if ..GetMultValue(icuaId,"CVC1^zsgxjm^CVysgxjm^zjnjm^yjnjm^zgjm^ygjm^UserDefinedzxjm^zjnjm2^yjnjm2^yjzg",stDate,stTime,eDate,eTime)'="" do
	....set ^tmpFindICU3TubeInfectionStat(yearMonth,"CVTubeCount",icuaId)=dateT_" 中心静脉置管:"_CVTubeDate_" "_CVTubeSituation_" "_CVTubeNursing
	....set CVTubeDateH=##class(DHCClinicCom).ConvertToDateH($p(CVTubeDate," ",1))
	....set CVTubeDrawDateH=##class(DHCClinicCom).ConvertToDateH($p(CVTubeDrawDate," ",1))
	....set ^tmpFindICU3TubeInfectionStat(yearMonth,"CVTubeCount",icuaId,"IntubeDays")=TubeEndDateH-TubeStartDateH
	
	
	set yearMonth="" for  set yearMonth=$o(^tmpFindICU3TubeInfectionStat(yearMonth)) q:yearMonth=""  d
	.set InHospitalCount=$$CountIcuaId(yearMonth, "InHospitalCount")
	.set OutHospitalCount=$$CountIcuaId(yearMonth, "OutHospitalCount")
	.set InLocCount=$$CountIcuaId(yearMonth, "InLocCount")
	.set OutLocCount=$$CountIcuaId(yearMonth, "OutLocCount")
	.set total=InHospitalCount+OutHospitalCount+InLocCount+OutLocCount
	.set AllPatientCount=$$CountIcuaId(yearMonth, "AllPatientCount")
	.set percent=0
	.if AllPatientCount>0 set percent=$fn(total/AllPatientCount,"",2)
	.do OutputRow

	s qHandle=$lb(0,repid,0)
	q $$$OK
	
CountIcuaId(yearMonth,code)
	set count=0
	set id="" for  set id=$o(^tmpFindICU3TubeInfectionStat(yearMonth,code,id)) q:id=""  d
	.set count=count+1
	quit count

OutputRow
	s Data=$lb(yearMonth,InHospitalCount,OutHospitalCount,InLocCount,OutLocCount,total,AllPatientCount,percent)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod FindICU3TubeInfectionStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindICU3TubeInfectionStatExecute ]
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

ClassMethod FindICU3TubeInfectionStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindICU3TubeInfectionStatExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

ClassMethod GetMRDesc(icuaId As %String) As %String
{
	s EpisodeID=$p($g(^DHCICUArrange(+icuaId)),"^",1)
	s mradmId=$P(^PAADM(EpisodeID),"^",61)
	s icuaRelatedDiagDr=$p(^DHCICUArrange(+icuaId),"^",20)
	s mrdiaSub=0,mrcidDesc=""
	f  s mrdiaSub=$O(^MR(mradmId,"DIA",mrdiaSub)) q:(mrdiaSub="")  d
		.s mrcidId=$p(^MR(mradmId,"DIA",mrdiaSub),"^")
		.i mrcidId'="" s curMrcidDesc=$p($g(^MRC("ID",+mrcidId)),"^",2)
		.e  s curMrcidDesc=$g(^MR(mradmId,"DIA",mrdiaSub,"DES",1))
		.q:curMrcidDesc=""
		.s mrcidDesc=$tr(mrcidDesc,$c(13))
		.s mrcidDesc=$tr(mrcidDesc,$c(10))
		.i mrcidDesc'="" s mrcidDesc=mrcidDesc_","
		.s mrcidDesc=mrcidDesc_curMrcidDesc
	quit mrcidDesc
}

}
