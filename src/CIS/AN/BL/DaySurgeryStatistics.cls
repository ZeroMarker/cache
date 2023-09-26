/// 日间手术统计
Class CIS.AN.BL.DaySurgeryStatistics Extends %RegisteredObject
{

/// 代码:"INOPDEPT"住院手术科室,"OUTOPDEPT"门诊手术科室,"EMOPDEPT"急诊手术科室,"AN"麻醉科,"OP"手术室,
/// "OUTAN"门诊麻醉科,"OUTOP"手术室,"EMAN"门诊麻醉科,"EMOP"手术室,"ICU"重症科室
/// Table：CT_Loc
/// Input：desc:手术科室描述
/// Return：返回所查询科室ID:ctlocId,科室名:ctlocDesc,科室代码:ctlocCode,
/// 20230113,多选下拉框可以检索,dyl
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.DaySurgeryStatistics","FindLocList","呼吸内科,nf","INOPDEPT")
Query FindLocList(desc As %String, locListCodeStr As %String = "") As %Query(ROWSPEC = "ctlocId:%String,ctlocDesc:%String,ctlocCode:%String,hospital:%String") [ SqlProc ]
{
}

ClassMethod FindLocListExecute(ByRef qHandle As %Binary, desc As %String, locListCodeStr As %String = "INOPDEPT") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	;转吧，汉字不方便
	s find=0
	s locListCodeStr=..AdjustLocListCode(locListCodeStr,"")
	s ctlocIdList=..GetLocIdByLocListCode(locListCodeStr)
	s dlen=$l(desc,",")
	if dlen>1
	{
		f dnum=1:1:dlen d
		.s sdesc=$p(desc,",",dnum)
		.s descNew=$$ALPHAUP^SSUTIL4(##class(web.DHCClinicCom).GetChinaChar(sdesc))
		.f iloc=1:1:$l(ctlocIdList,"^") d
			..s ctlocId=$p(ctlocIdList,"^",iloc)
			..q:ctlocId=""
			..q:'$d(^CTLOC(ctlocId))
			..s ctlocDesc=$p(^CTLOC(ctlocId),"^",2)
			..s ctlocAlias=$$ALPHAUP^SSUTIL4(##class(web.DHCClinicCom).GetChinaChar(ctlocDesc))
			..q:(descNew'="")&(ctlocAlias'[descNew)
			..s ctlocCode=$p(^CTLOC(ctlocId),"^",1)
			..s find=1
			..Do OutputRow6

	
	}
	else
	{
		s desc=##class(web.DHCClinicCom).GetChinaChar(desc)
		s descNew=$$ALPHAUP^SSUTIL4(desc)
		f iloc=1:1:$l(ctlocIdList,"^") d
			.s ctlocId=$p(ctlocIdList,"^",iloc)
			.q:ctlocId=""
			.q:'$d(^CTLOC(ctlocId))
			.s ctlocDesc=$p(^CTLOC(ctlocId),"^",2)
			.q:(descNew'="")&($$ALPHAUP^SSUTIL4(##class(web.DHCClinicCom).GetChinaChar(ctlocDesc))'[descNew)
			.s ctlocCode=$p(^CTLOC(ctlocId),"^",1)
			.s find=1
			.Do OutputRow6

	}

	i (find=0)!(ctlocIdList="") d
		.s ctlocrowid="" f  s ctlocrowid=$o(^CTLOC(ctlocrowid)) q:ctlocrowid=""  d
			..q:'$d(^CTLOC(ctlocrowid))
			..;b	;in
			..s ctlocDesc=$p(^CTLOC(ctlocrowid),"^",2)
			..;w ##class(web.DHCClinicCom).GetChinaChar(ctlocDesc)_"/"
			..q:(desc'="")&($$ALPHAUP^SSUTIL4(##class(web.DHCClinicCom).GetChinaChar(ctlocDesc))'[desc)
			..s ctlocId=ctlocrowid
			..Do OutputRow6	 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow6
	set Data=$lb(ctlocId,ctlocDesc,ctlocCode,hospital)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod FindLocListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLocListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
	Set AtEnd=1
	Set Row=""
	}
	Else      {				// fetch row
	Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod AdjustLocListCode(locListCodeStr As %String, EpisodeID As %String) As %String
{
	q:EpisodeID="" locListCodeStr
	s admType=$p($g(^PAADM(EpisodeID)),"^",2)
	q:admType="" locListCodeStr
	s admTypeStr=""
	i admType="O" s admTypeStr="OUT"
	i admType="E" s admTypeStr="EM"
	f i=1:1:$l(locListCodeStr,"^") d
		.s locListCode=$p(locListCodeStr,"^",i)
		.i admTypeStr'="",$p(locListCode,admTypeStr)'="" s $p(locListCodeStr,"^",i)=""
		.i (admTypeStr="")&($p(locListCode,"OUT")=""!($p(locListCode,"EM")="")) s $p(locListCodeStr,"^",i)=""
	q locListCodeStr
}

ClassMethod GetLocIdByLocListCode(locListCodeStr As %String) As %String
{
	q:locListCodeStr="" ""
	s ctlocIdList=""
	f i=1:1:$l(locListCodeStr,"^") d
		.s locListCode=$p(locListCodeStr,"^",i)
		.q:locListCode=""
		.s locListId=$o(^CT("LL",0,"Code",locListCode,""))
		.q:locListId=""
		.s locListLocId=0
		.f  s locListLocId=$o(^CT("LL",locListId,"LOC",locListLocId)) q:locListLocId=""  d
			..s ctlocId=$p(^CT("LL",locListId,"LOC",locListLocId),"^")
			..q:ctlocId=""
			..q:'$d(^CTLOC(ctlocId))
			..i ctlocIdList'="" s ctlocIdList=ctlocIdList_"^"
			..s ctlocIdList=ctlocIdList_ctlocId
	q ctlocIdList
}

ClassMethod FindLocListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLocListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetORAnaestID(opsId As %String) As %String
{
	set anaestID=""
	&sql(select ExtAnaestID into :anaestID from CIS_AN.OperSchedule where RowId=:opsId)
	quit anaestID
}

/// w ##Class(CIS.AN.BL.DaySurgeryStatistics).GetChoiceDate("month")
ClassMethod GetChoiceDate(type)
{
	s startDate="",endDate=""
	s dateStr=$zd(+$h,3)
	s dateY=$p(dateStr,"-",1)
	s dateM=$p(dateStr,"-",2)
	i type="year" d
	.s needMDate=$zdh(dateY_"-"_"01"_"-"_"01",3)
	.s startDate=..ConvertToDate(needMDate,"")
	.s endDate=..ConvertToDate(+$h,"")
	i type="season" d
	.s needM=+dateM-3
	.i needM>0 d
	..i needM<10 s needM="0"_needM
	..s needMDate=$zdh(dateY_"-"_needM_"-"_"01",3)
	.e  d
	..s needM=12+needM
	..i needM<10 s needM="0"_needM
	..s dateY=dateY-1,needMDate=$zdh(dateY_"-"_needM_"-"_"01",3)
	.s startDate=..ConvertToDate(needMDate,"")
	.s endDate=..ConvertToDate(+$h,"")
	.
	i type="month" d
	.i +dateM<10 s dateM="0"_dateM
	.s needMDate=$zdh(dateY_"-"_dateM_"-"_"01",3)
	.s startDate=..ConvertToDate(needMDate,"")
	.s endDate=..ConvertToDate(+$h,"")
	i type="day" d
	.s startDate=..ConvertToDate(+$h,"")
	.s endDate=..ConvertToDate(+$h,"")
	q startDate_"^"_endDate
}

// ClassMethod Get

ClassMethod GetHisDateFormat(date As %String = "") As %String
{
   //DMY//YMD
    s DateFormat="YMD"
	set DateFormat=$lg(^websys.ConfigurationD(1),10)   //适应系统配置的时间格式  YuanLin 20210901
	
    q DateFormat
}

/// 获取动态表头
/// w ##class(CIS.AN.BL.DaySurgeryStatistics).GetDeptResultSingle("day","2021-11-22","2021-11-22","Diag")
/// w ##class(CIS.AN.BL.DaySurgeryStatistics).GetDeptResultSingle("month","2021-10","2021-11","Category")
/// w ##class(CIS.AN.BL.DaySurgeryStatistics).GetDeptResultSingle("season","2021-03","2021-04","Category")
ClassMethod GetDeptResultSingle(type, date1, date2, code, sort As %String = "1") As %String
{
	if (type="day")
	{
		s date1=+##class(CIS.AN.COM.DateTime).ConvertToDateH(date1,"")
		s date2=+##class(CIS.AN.COM.DateTime).ConvertToDateH(date2,"")
		q:(date2-date1>31)&(type="day") "列数超出限制,最多可查询30天数据"
		
		s dateNum=date2-date1+1
		s date1Str=$zd(date1,3)
		s date2Str=$zd(date2,3)
		s year1=$p(date1Str,"-",1)
		s year2=$p(date2Str,"-",1)
		s month1=$p(date1Str,"-",2)
		s month2=$p(date2Str,"-",2)
		s yearNum=year2-year1
		s monthNum=month2-month1
	}
	if (type="year")
	{
		q:(date2-date1>3.01)&(type="year") "列数超出限制,最多可查询4年数据"
	}
	if (type="month")
	{
		s year1=$p(date1,"-",1)
		s month1=$p(date1,"-",2)
		s year2=$p(date2,"-",1)
		s month2=$p(date1,"-",2)
		s yearnum=year2-year1
		q:yearnum>1.01 "列数超出限制,最多可查询2年数据"
		s monthnum=yearnum*12+month2-month1
		q:monthnum>24.01 "列数超出限制,最多可查询2年数据"
	}
	if (type="season")
	{
		s year1=$p(date1,"-",1)
		s season1=$p(date1,"-",2)
		s year2=$p(date2,"-",1)
		s season2=$p(date1,"-",2)
		s yearnum=year2-year1
		q:(yearnum>2.01) "列数超出限制,最多可查询3年数据"
		s seasonnum=yearnum*4+season1-season2
		q:(seasonnum>12.01) "列数超出限制,最多可查询3年数据"
	}
	i type="day" d
		.f date=date1:1:date2 d
			..s newdates=$zd(date,3)
			..s yearNew=$p(newdates,"-",1)
			..s monthNew=$p(newdates,"-",2)
			..s dateNew=$p(newdates,"-",3)
			..s datenew=yearNew_"."_monthNew_"."_dateNew
			..set columnArr(date,"field")="Field"_datenew
			..;set columnArr(date,"title")=$zd(date,3)
			..set columnArr(date,"title")=..ConvertToDate(date,"")
			..set columnArr(date,"width")=100
			..i (code="Dept") set columnArr(1,"title")="科室",columnArr(1,"field")="Field1"
			..i (code="Surgeon") set columnArr(1,"title")="主刀",columnArr(1,"field")="Field1"
			..i (code="Oper") set columnArr(1,"title")="手术名称",columnArr(1,"field")="Field1"
			..i (code="Diag") set columnArr(1,"title")="诊断",columnArr(1,"field")="Field1"
			..i code="Category" d
			...set columnArr(1,"title")="科室",columnArr(1,"field")="Field1",columnArr(1,"rowspan")=2
			...set columnArr(2,"title")="手术级别",columnArr(2,"field")="Field2",columnArr(2,"rowspan")=2

	i type="month" d
		.s newDate1=+##class(CIS.AN.COM.DateTime).ConvertToDateH(date1_"-"_"01","")
		.s month=$p(date2,"-",2)
		.s year2=$p(date2,"-",1)
		.s newMonth=month+1
		.i newMonth<10 s newMonth="0"_newMonth
		.i newMonth=13 s newMonth="01",year2=year2+1
		.s newDate2=year2_"-"_newMonth_"-01"
		.s newDate2=+##class(CIS.AN.COM.DateTime).ConvertToDateH(newDate2,"")-1
		.f date=newDate1:1:newDate2 d
			..s dateStr=$zd(date,3)
			..s year=$p(dateStr,"-",1)
			..s month=$p(dateStr,"-",2)
			..i code'="Category" d
				...set columnArr(year_""_month,"field")="Field"_year_"."_month
				...set columnArr(year_""_month,"title")=year_"-"_month
			..i code="Category" d
				...set columnArr(year_""_month,"colspan")=2
				...set columnArr(year_""_month,"title")=year_"-"_month
			..i code="Dept" set columnArr(1,"title")="科室",columnArr(1,"field")="Field1"
			..i code="Surgeon" set columnArr(1,"title")="主刀",columnArr(1,"field")="Field1"
			..i (code="Oper") set columnArr(1,"title")="手术名称",columnArr(1,"field")="Field1"
			..i (code="Diag") set columnArr(1,"title")="诊断",columnArr(1,"field")="Field1"
			..i code="Category" d
				...set columnArr(1,"title")="科室",columnArr(1,"field")="Field1",columnArr(1,"rowspan")=2
				...set columnArr(2,"title")="手术级别",columnArr(2,"field")="Field2",columnArr(2,"rowspan")=2

			
	i type="season" d
		.s YearS=$p(date1,"-",1)
		.s MonthS=$p(date1,"-",2)
		.s YearE=$p(date2,"-",1)
		.s MonthE=$p(date2,"-",2)
		.i MonthS="01" s newDateStr1=YearS_"-"_"01"_"-01"
		.i MonthS="02" s newDateStr1=YearS_"-"_"04"_"-01"
		.i MonthS="03" s newDateStr1=YearS_"-"_"07"_"-01"
		.i MonthS="04" s newDateStr1=YearS_"-"_"10"_"-01"
		.i MonthE="01" s newDateStr2=YearE_"-"_"03"_"-31"
		.i MonthE="02" s newDateStr2=YearE_"-"_"06"_"-30"
		.i MonthE="03" s newDateStr2=YearE_"-"_"09"_"-30"
		.i MonthE="04" s newDateStr2=YearE_"-"_"12"_"-31"
		.s newDateS1=+##class(CIS.AN.COM.DateTime).ConvertToDateH(newDateStr1,"")
		.s newDateS2=+##class(CIS.AN.COM.DateTime).ConvertToDateH(newDateStr2,"")
		.f date=newDateS1:1:newDateS2 d
			..s dateStr=$zd(date,3)
			..s year=$p(dateStr,"-",1)
			..s month=$p(dateStr,"-",2)
			..i +month<4 s season="一季度",seasonCode=1
			..i (+month>3)&(+month<7) s season="二季度",seasonCode=2
			..i (+month>6)&(+month<10) s season="三季度",seasonCode=3
			..i +month>9 s season="四季度",seasonCode=4
			..i code'="Category" d
				...set columnArr(year_""_seasonCode,"field")="Field"_year_"."_seasonCode
				...set columnArr(year_""_seasonCode,"title")=year_""_season
			..i code="Category" d
				...set columnArr(year_""_seasonCode,"colspan")=2
				...set columnArr(year_""_seasonCode,"title")=year_""_season
			..i code="Dept" set columnArr(1,"title")="科室",columnArr(1,"field")="Field1"
			..i code="Surgeon" set columnArr(1,"title")="主刀",columnArr(1,"field")="Field1"
			..i (code="Oper") set columnArr(1,"title")="手术名称",columnArr(1,"field")="Field1"
			..i (code="Diag") set columnArr(1,"title")="诊断",columnArr(1,"field")="Field1"
			..i code="Category" d
				...set columnArr(1,"title")="科室",columnArr(1,"field")="Field1",columnArr(1,"rowspan")=2
				...set columnArr(2,"title")="手术级别",columnArr(2,"field")="Field2",columnArr(2,"rowspan")=2

	
	
	i type="year" d
		.f date=date1:1:(date2) d
			..;set columnArr(date,"field")="Field"_date
			..;set columnArr(date,"title")=date_"年"
			..;set columnArr(date,"width")=100
			..;i code="Category" set columnArr(date,"colspan")=2
			..i (code="Dept") set columnArr(1,"title")="科室",columnArr(1,"field")="Field1"
			..i (code="Surgeon") set columnArr(1,"title")="主刀",columnArr(1,"field")="Field1"
			..i (code="Oper") set columnArr(1,"title")="手术名称",columnArr(1,"field")="Field1"
			..i (code="Diag") set columnArr(1,"title")="诊断",columnArr(1,"field")="Field1"
			..i code="Category" d
				...set columnArr(1,"title")="科室",columnArr(1,"field")="Field1",columnArr(1,"rowspan")=2
				...set columnArr(2,"title")="手术级别",columnArr(2,"field")="Field2",columnArr(2,"rowspan")=2
			..i code'="Category" d
				...set columnArr(date,"field")="Field"_date
				...set columnArr(date,"title")=date_"年"
				...set columnArr(date,"width")=100
			..i code="Category" d
				...set columnArr(date,"colspan")=2
				...set columnArr(date,"title")=date

	set result=##class(CIS.AN.COM.String).ToJson(.columnArr)
	q:code="Category" result
	quit "["_result_"]"
}

/// w ##class(CIS.AN.BL.DaySurgeryStatistics).CheckIfNotDay(971)
/// 是否是退出日间
ClassMethod CheckIfNotDay(opsId)
{
	s DeclineFlag=$d(^CIS.AN.DaySurgeryDeclineI("IOPS",opsId))
	q DeclineFlag
}

/// w ##class(CIS.AN.BL.DaySurgeryStatistics).GetOpsIdListByDate(66066,66065,"Doc")
/// w ##class(CIS.AN.BL.DaySurgeryStatistics).GetOpsIdListByDate(66066,66066,"Loc")
/// 按日统计
ClassMethod GetOpsIdListByDate(sdate, edate, type, note As %String = "", Status As %String = "") As %String
{
	f date=sdate:1:edate d
		.s opsId=0
		.f  s opsId=$order(^CIS.AN.OperScheduleI("DateDaySurgery",date,"Y",opsId)) q:opsId=""  d
			..quit:(opsId="")
			..;q:(..CheckIfNotDay(opsId)>1)	;退出日间不在统计之列
			..
			..set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			..q:(operSchedule.PatDeptID="")&(operSchedule.AppDeptID="")
			..set statusCode=operSchedule.Status.Code
			..s opsDate=operSchedule.OperDate
			..;q:(statusCode="Cancel")!(statusCode="Declinie")
			..s outDay=""
			..s moneyStr=##class(web.DHCBillInterface).IGetAdmInOutDatebyEpisodeID(operSchedule.EpisodeID)
			..i moneyStr'="" s outDay=$p(moneyStr,"^",4)
			..q:(Status'="")&(outDay="")	;没出院的排除出去
			..q:(Status'="")&(("|"_Status_"|")'[("|"_statusCode_"|"))
			..q:(Status'="")&(..CheckIfNotDay(opsId)>1)
			..set PrevDiagnoIdStr=$tr(operSchedule.PrevDiagnosis,$c(4),"")
			..set diagnosisCount=$l(PrevDiagnoIdStr,"&&&")
			..for idnum=1:1:diagnosisCount d
				...set curDiagnosis=$p(PrevDiagnoIdStr,"&&&",idnum)
				...set diagId=$p(curDiagnosis,"###",1)
				...q:(+diagId=0)&(type="Diag")
				...set diagDesc=$p(curDiagnosis,"###",2)
				...i (note="")&(type="Diag") d
					....s colDiagArr(diagId)=diagDesc
					....q:$g(DiagExsit(diagId,opsDate,opsId))="Y"
					....s DiagExsit(diagId,opsDate,opsId)="Y"
					....s SingleDiagArr(diagId,opsDate,opsId_"||"_idnum)=diagDesc
				...e  i (note'="")&(type="Diag") d
				....s lennote=$l(note,",")
				....f dlen=1:1:lennote d
					.....s sinnote=$p(note,",",dlen)
					.....q:sinnote=""
					.....q:(diagDesc'[sinnote)&(note'="")&(type="Diag")
					.....
					.....s colDiagArr(diagId)=diagDesc
					.....q:$g(DiagExsit(diagId,opsDate,opsId))="Y"
					.....s DiagExsit(diagId,opsDate,opsId)="Y"
					.....s SingleDiagArr(diagId,opsDate,opsId_"||"_idnum)=diagDesc
			..set operationNameStr="",surgeonNameList=""
			..s opId=0
			..f  s opId=$o(^CIS.AN.OperListI("IOPS",opsId,opId)) q:opId=""  d
				...s operListObj=##class(CIS.AN.OperList).%OpenId(opId)
				...s surgeonDesc=""
				...s surgeonId=operListObj.Surgeon
				...i surgeonId>0 s surgeonDesc=$p(^CTPCP(surgeonId,1),"^",2)
				...q:+surgeonId=0
				...s userId=$o(^SSU("SSUSR",0,"CTPCP",surgeonId,""),-1)
				...s anaOpSurgeonCode=""
				...i userId'="" s anaOpSurgeonCode=$p($g(^SSU("SSUSR",userId)),"^",1)
				...q:(type="Doc")&(note'="")&((","_$$ALPHAUP^SSUTIL4(note)_",")'[(","_anaOpSurgeonCode_","))
				...s colSurgeonArr(surgeonId)=surgeonDesc
				...s SingleSurgeonArr(surgeonId,opsDate,opsId_"."_opId)=surgeonDesc
				...s surgeonDept=operListObj.SurgeonDeptID
				...i surgeonDept="" s surgeonDept=operSchedule.AppDeptID
				...s surgeonDeptDesc=$p(^CTLOC(surgeonDept),"^",2)
				...q:((","_note_",")'[(","_surgeonDeptDesc_","))&(note'="")&(type="Loc")
				...s colDeptArr(surgeonDept)=surgeonDeptDesc
				...s SingleDeptArr(surgeonDept,opsDate,opsId_"."_opId)=surgeonDeptDesc
				...s operId=operListObj.Operation
				...s operDesc=$p(^ORC("OPER",operId),"^",2)
				...;
				...i (note="")&(type="Oper") d
					....;
					....s colOperArr(operId)=operDesc
					....s SingleOperArr(operId,opsDate,opsId_"."_opId)=operDesc
				...;q:(operDesc'[note)&(note'="")&(type="Oper")
				...e  i (note'="")&(type="Oper") d
					....s lennote=$l(note,",")
					....f dlen=1:1:lennote d
						.....s sinnote=$p(note,",",dlen)
						.....q:sinnote=""
						.....q:(operDesc'[sinnote)&(note'="")&(type="Oper")
						.....s colOperArr(operId)=operDesc
						.....s SingleOperArr(operId,opsDate,opsId_"."_opId)=operDesc

	if (type="Loc") 
	{
		s testLocId=0,jsonStr="",locNum=0	//按科室统计
		f  s testLocId=$o(SingleDeptArr(testLocId)) q:testLocId=""  d
			.s testDate=0
			.s locNum=locNum+1,locDateNum=0
			.f  s testDate=$o(SingleDeptArr(testLocId,testDate)) q:testDate=""  d
				..s testOpsId=0,datenum=""
				..s locDateNum=locDateNum+1
				..f  s testOpsId=$o(SingleDeptArr(testLocId,testDate,testOpsId)) q:testOpsId=""  d
					...s datenum=datenum+1
				..set colLocArr(testLocId,testDate)=datenum
			s locId=0,num=0
			f  s locId=$o(colLocArr(locId)) q:locId=""  d
				.s NewLocArr(locId,"Field1")=colDeptArr(locId)
				.s NewLocArr("总计","Field1")="总计"
				.s showdate=0,totalDateNum=0
				.f  s showdate=$o(colLocArr(locId,showdate)) q:showdate=""  d
					..s value=colLocArr(locId,showdate)
					..s newShow=$zd(showdate,3)
					..s newY=$p(newShow,"-",1)
					..s newM=$p(newShow,"-",2)
					..s newD=$p(newShow,"-",3)
					..s showdateNew=newY_"."_newM_"."_newD
					..s NewLocArr(locId,"Field"_showdateNew)=value
					..s NewDateList(showdate,locId)=value
			s sunDate=0
			f  s sunDate=$o(NewDateList(sunDate)) q:sunDate=""  d
				.s newShow=$zd(sunDate,3)
				.s newY=$p(newShow,"-",1)
				.s newM=$p(newShow,"-",2)
				.s newD=$p(newShow,"-",3)
				.s showdateNew=newY_"."_newM_"."_newD
				.s sumLocId=0,locNum=0
				.f  s sumLocId=$o(NewDateList(sunDate,sumLocId)) q:sumLocId=""  d
					..s locNum=locNum+$g(NewDateList(sunDate,sumLocId))
				.s NewLocArr("总计","Field"_showdateNew)=locNum
			
			set JsonStr=##class(CIS.AN.COM.String).ToJson(.NewLocArr)
	}
	elseif (type="Doc")
	{
		s docId=0,jsonStr="",locNum=0	//主刀
		f  s docId=$o(SingleSurgeonArr(docId)) q:docId=""  d
		.s testDate=0
		.f  s testDate=$o(SingleSurgeonArr(docId,testDate)) q:testDate=""  d
			..s testOpsId=0,datenum=""
			..f  s testOpsId=$o(SingleSurgeonArr(docId,testDate,testOpsId)) q:testOpsId=""  d
				...s datenum=datenum+1
				...;单日手术数据
			..set DocListArr(docId,testDate)=datenum
	s secDocId=0,num=0,locShowNum=0
	f  s secDocId=$o(DocListArr(secDocId)) q:secDocId=""  d
		.s NewDocListArr(secDocId,"Field1")=colSurgeonArr(secDocId)
		.s NewDocListArr("总计","Field1")="总计"
		.s showdate=0
		.f  s showdate=$o(DocListArr(secDocId,showdate)) q:showdate=""  d
			..s value=DocListArr(secDocId,showdate)
			..s newShow=$zd(showdate,3)
			..s newY=$p(newShow,"-",1)
			..s newM=$p(newShow,"-",2)
			..s newD=$p(newShow,"-",3)
			..s showdateNew=newY_"."_newM_"."_newD
			..s NewDocListArr(secDocId,"Field"_showdateNew)=value
			..s NewDateList(showdate,secDocId)=value
		s sunDate=0
			f  s sunDate=$o(NewDateList(sunDate)) q:sunDate=""  d
				.s newShow=$zd(sunDate,3)
				.s newY=$p(newShow,"-",1)
				.s newM=$p(newShow,"-",2)
				.s newD=$p(newShow,"-",3)
				.s showdateNew=newY_"."_newM_"."_newD
				.s sumLocId=0,locNum=0
				.f  s sumLocId=$o(NewDateList(sunDate,sumLocId)) q:sumLocId=""  d
					..s locNum=locNum+$g(NewDateList(sunDate,sumLocId))
				.s NewDocListArr("总计","Field"_showdateNew)=locNum

	set JsonStr=##class(CIS.AN.COM.String).ToJson(.NewDocListArr)
	}
	elseif (type="Oper")
	{
		//colOperArr,SingleOperArr
		s fOperId=0,jsonStr="",locNum=0
		f  s fOperId=$o(SingleOperArr(fOperId)) q:fOperId=""  d
		.s testDate=0
		.s locNum=locNum+1,locDateNum=0
		.f  s testDate=$o(SingleOperArr(fOperId,testDate)) q:testDate=""  d
			..s testOpsId=0,datenum=""
			..s locDateNum=locDateNum+1
			..f  s testOpsId=$o(SingleOperArr(fOperId,testDate,testOpsId)) q:testOpsId=""  d
				...s datenum=datenum+1
				...;s locNum
			..set OperListArr(fOperId,testDate)=datenum
	s secOperId=0,num=0,locShowNum=0
	f  s secOperId=$o(OperListArr(secOperId)) q:secOperId=""  d
		.s NewOperListArr(secOperId,"Field1")=colOperArr(secOperId)	;给手术名称赋值
		.s NewOperListArr("总计","Field1")="总计"
		.s locShowNum=locShowNum+1
		.s showdate=0
		.f  s showdate=$o(OperListArr(secOperId,showdate)) q:showdate=""  d
			..s value=OperListArr(secOperId,showdate)
			..s newShow=$zd(showdate,3)
			..s newY=$p(newShow,"-",1)
			..s newM=$p(newShow,"-",2)
			..s newD=$p(newShow,"-",3)
			..s showdateNew=newY_"."_newM_"."_newD
			..s NewOperListArr(secOperId,"Field"_showdateNew)=value
			..s NewDateList(showdate,secOperId)=value
		s sunDate=0
		f  s sunDate=$o(NewDateList(sunDate)) q:sunDate=""  d
			.s newShow=$zd(sunDate,3)
			.s newY=$p(newShow,"-",1)
			.s newM=$p(newShow,"-",2)
			.s newD=$p(newShow,"-",3)
			.s showdateNew=newY_"."_newM_"."_newD
			.s sumLocId=0,locNum=0
			.f  s sumLocId=$o(NewDateList(sunDate,sumLocId)) q:sumLocId=""  d
				..s locNum=locNum+$g(NewDateList(sunDate,sumLocId))
			.s NewOperListArr("总计","Field"_showdateNew)=locNum

	set JsonStr=##class(CIS.AN.COM.String).ToJson(.NewOperListArr)
	}
	elseif (type="Diag")
	{
		s fOperId=0,jsonStr="",locNum=0
		f  s fOperId=$o(SingleDiagArr(fOperId)) q:fOperId=""  d
		.s testDate=0
		.s locNum=locNum+1,locDateNum=0
		.f  s testDate=$o(SingleDiagArr(fOperId,testDate)) q:testDate=""  d
			..s testOpsId=0,datenum=""
			..s locDateNum=locDateNum+1
			..f  s testOpsId=$o(SingleDiagArr(fOperId,testDate,testOpsId)) q:testOpsId=""  d
				...s datenum=datenum+1
				...;s locNum
			..set OperListArr(fOperId,testDate)=datenum
	s secOperId=0,num=0,locShowNum=0
	f  s secOperId=$o(OperListArr(secOperId)) q:secOperId=""  d
		.s NewOperListArr(secOperId,"Field1")=colDiagArr(secOperId)	;给手术名称赋值
		.s NewOperListArr("总计","Field1")="总计"
		.s locShowNum=locShowNum+1
		.s showdate=0
		.f  s showdate=$o(OperListArr(secOperId,showdate)) q:showdate=""  d
			..s value=OperListArr(secOperId,showdate)
			..s newShow=$zd(showdate,3)
			..s newY=$p(newShow,"-",1)
			..s newM=$p(newShow,"-",2)
			..s newD=$p(newShow,"-",3)
			..s showdateNew=newY_"."_newM_"."_newD
			..s NewOperListArr(secOperId,"Field"_showdateNew)=value
			..s NewDateList(showdate,secOperId)=value
		s sunDate=0
		f  s sunDate=$o(NewDateList(sunDate)) q:sunDate=""  d
			.s newShow=$zd(sunDate,3)
			.s newY=$p(newShow,"-",1)
			.s newM=$p(newShow,"-",2)
			.s newD=$p(newShow,"-",3)
			.s showdateNew=newY_"."_newM_"."_newD
			.s sumLocId=0,locNum=0
			.f  s sumLocId=$o(NewDateList(sunDate,sumLocId)) q:sumLocId=""  d
				..s locNum=locNum+$g(NewDateList(sunDate,sumLocId))
			.s NewOperListArr("总计","Field"_showdateNew)=locNum

	set JsonStr=##class(CIS.AN.COM.String).ToJson(.NewOperListArr)
	}
	
	
	q JsonStr
}

/// 按年统计
ClassMethod GetOpsIdListByYear(sdate, edate, type, note As %String = "", Status As %String = "") As %String
{
	f date=sdate:1:edate d
	.s opsId=0
	.f  s opsId=$order(^CIS.AN.OperScheduleI("DateDaySurgery",date,"Y",opsId)) q:opsId=""  d
		..quit:(opsId="")
		..set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		..q:(operSchedule.PatDeptID="")&(operSchedule.AppDeptID="")
		..set statusCode=operSchedule.Status.Code
		..s outDay=""
		..s moneyStr=##class(web.DHCBillInterface).IGetAdmInOutDatebyEpisodeID(operSchedule.EpisodeID)
		..i moneyStr'="" s outDay=$p(moneyStr,"^",4)
		..q:(Status'="")&(outDay="")	;没出院的排除出去
		..q:(Status'="")&(("|"_Status_"|")'[("|"_statusCode_"|"))
		..q:(Status'="")&(..CheckIfNotDay(opsId)>1)
		..s opsDate=operSchedule.OperDate
		..;q:(statusCode="Cancel")!(statusCode="Declinie")
		..set PrevDiagnoIdStr=$tr(operSchedule.PrevDiagnosis,$c(4),"")
		..set diagnosisCount=$l(PrevDiagnoIdStr,"&&&")
		..for idnum=1:1:diagnosisCount d
			...set curDiagnosis=$p(PrevDiagnoIdStr,"&&&",idnum)
			...set diagId=$p(curDiagnosis,"###",1)
			...q:(+diagId=0)&(type="Diag")
			...set diagDesc=$p(curDiagnosis,"###",2)
			...i (note="")&(type="Diag") d
				....s colDiagArr(diagId)=diagDesc
				....q:$g(DiagExsit(diagId,opsDate,opsId))="Y"
				....s DiagExsit(diagId,opsDate,opsId)="Y"
				....s SingleDiagArr(diagId,opsDate,opsId_"||"_idnum)=diagDesc
			...e  i (note'="")&(type="Diag") d
				....s lennote=$l(note,",")
				....f dlen=1:1:lennote d
					.....s sinnote=$p(note,",",dlen)
					.....q:sinnote=""
					.....q:(diagDesc'[sinnote)&(note'="")&(type="Diag")
					.....
					.....s colDiagArr(diagId)=diagDesc
					.....q:$g(DiagExsit(diagId,opsDate,opsId))="Y"
					.....s DiagExsit(diagId,opsDate,opsId)="Y"
					.....s SingleDiagArr(diagId,opsDate,opsId_"||"_idnum)=diagDesc

			...;q:(diagDesc'[note)&(note'="")&(type="Diag")
			...;s colDiagArr(diagId)=diagDesc
			...;s SingleDiagArr(diagId,opsDate,opsId_"||"_idnum)=diagDesc
		..set operationNameStr="",surgeonNameList=""
		..s opId=0
		..f  s opId=$o(^CIS.AN.OperListI("IOPS",opsId,opId)) q:opId=""  d
			...s operListObj=##class(CIS.AN.OperList).%OpenId(opId)
			...s surgeonId=operListObj.Surgeon
			...;q:+surgeonId=0
			...s surgeonDesc=""
			...i surgeonId>0 s surgeonDesc=$p(^CTPCP(surgeonId,1),"^",2)
			...q:+surgeonId=0
			...s userId=$o(^SSU("SSUSR",0,"CTPCP",surgeonId,""),-1)
			...s anaOpSurgeonCode=""
			...i userId'="" s anaOpSurgeonCode=$p($g(^SSU("SSUSR",userId)),"^",1)
			...q:(type="Doc")&(note'="")&((","_$$ALPHAUP^SSUTIL4(note)_",")'[(","_anaOpSurgeonCode_","))
			...s colSurgeonArr(surgeonId)=surgeonDesc
			...s SingleSurgeonArr(surgeonId,opsDate,opsId_"."_opId)=surgeonDesc

			...s surgeonDept=operListObj.SurgeonDeptID
			...i surgeonDept="" s surgeonDept=operSchedule.AppDeptID
			...s surgeonDeptDesc=$p(^CTLOC(surgeonDept),"^",2)
			...q:((","_note_",")'[(","_surgeonDeptDesc_","))&(note'="")&(type="Loc")
			...s colDeptArr(surgeonDept)=surgeonDeptDesc
			...s SingleDeptArr(surgeonDept,opsDate,opsId_"."_opId)=surgeonDeptDesc
			...s operId=operListObj.Operation
			...s operDesc=$p(^ORC("OPER",operId),"^",2)
			...;s colOperArr(operId)=operDesc
			...;s SingleOperArr(operId,opsDate,opsId_"."_opId)=operDesc
			...;q:(operDesc'[note)&(note'="")&(type="Oper")
			...i (note="")&(type="Oper") d
					....;
					....s colOperArr(operId)=operDesc
					....s SingleOperArr(operId,opsDate,opsId_"."_opId)=operDesc
			...;q:(operDesc'[note)&(note'="")&(type="Oper")
			...e  i (note'="")&(type="Oper") d
				....s lennote=$l(note,",")
				....f dlen=1:1:lennote d
					.....s sinnote=$p(note,",",dlen)
					.....q:sinnote=""
					.....q:(operDesc'[sinnote)&(note'="")&(type="Oper")
					.....s colOperArr(operId)=operDesc
					.....s SingleOperArr(operId,opsDate,opsId_"."_opId)=operDesc

			...s operClassDesc="未填"
			...s operClass=operListObj.OperClass
			...i +operClass>0 s operClassDesc=$p(^ORC("CATEG",operClass),"^",2)
			...e  s operClass=1999
			...s ClassDescArr(operClass)=operClassDesc
			...s SingleClassArr(surgeonDeptDesc_"."_operClass,opsDate,opsId_"."_opId)=surgeonDeptDesc

	if (type="Loc")
	{
		s testLocId=0,jsonStr="",locNum=0
		f  s testLocId=$o(SingleDeptArr(testLocId)) q:testLocId=""  d
			.s testDate=0
			.s locNum=locNum+1,locDateNum=0,yearNum=0
			.f  s testDate=$o(SingleDeptArr(testLocId,testDate)) q:testDate=""  d
				..s newShowDate=$zd(testDate,3)
				..s testOpsId=0,datenum=""
				..s locDateNum=locDateNum+1
				..f  s testOpsId=$o(SingleDeptArr(testLocId,testDate,testOpsId)) q:testOpsId=""  d
					...s datenum=datenum+1
					...
				..set colLocArr(testLocId,$p(newShowDate,"-",1),testDate)=datenum

		s locId=0,num=0,locShowNum=0
		f  s locId=$o(colLocArr(locId)) q:locId=""  d
			.s NewLocArr(locId,"Field1")=colDeptArr(locId)
			.s NewLocArr("总计","Field1")="总计"
			.s locShowNum=locShowNum+1
			.s showYear=0,dateNum=0,YearField="1"
			.f  s showYear=$o(colLocArr(locId,showYear)) q:showYear=""  d
				..s YearNum=0,showYearDate=0
				..f  s showYearDate=$o(colLocArr(locId,showYear,showYearDate)) q:showYearDate=""  d
					...s value=colLocArr(locId,showYear,showYearDate)
					...s YearNum=YearNum+value
				..s NewLocArr(locId,"Field"_showYear)=YearNum
				..s NewDateList(showYear,locId)=YearNum
		s sunDate=0
		f  s sunDate=$o(NewDateList(sunDate)) q:sunDate=""  d
			.s sumLocId=0,locNum=0
			.f  s sumLocId=$o(NewDateList(sunDate,sumLocId)) q:sumLocId=""  d
				..s locNum=locNum+$g(NewDateList(sunDate,sumLocId))
			.s NewLocArr("总计","Field"_sunDate)=locNum

		set JsonStr=##class(CIS.AN.COM.String).ToJson(.NewLocArr)
	}
	elseif (type="Doc")
	{
		s testDocId=0,jsonStr="",locNum=0
		f  s testDocId=$o(SingleSurgeonArr(testDocId)) q:testDocId=""  d
		.s testDate=0
		.s locNum=locNum+1,locDateNum=0,yearNum=0
		.f  s testDate=$o(SingleSurgeonArr(testDocId,testDate)) q:testDate=""  d
			..s newShowDate=$zd(testDate,3)
			..s testOpsId=0,datenum=""
			..s locDateNum=locDateNum+1
			..f  s testOpsId=$o(SingleSurgeonArr(testDocId,testDate,testOpsId)) q:testOpsId=""  d
				...s datenum=datenum+1
				...
			..set colDocArr(testDocId,$p(newShowDate,"-",1),testDate)=datenum

		s docId=0,num=0,locShowNum=0
		f  s docId=$o(colDocArr(docId)) q:docId=""  d
			.s NewDocArr(docId,"Field1")=colSurgeonArr(docId)
			
			.s locShowNum=locShowNum+1
			.s showYear=0,dateNum=0,YearField="1"
			.f  s showYear=$o(colDocArr(docId,showYear)) q:showYear=""  d
				..s YearNum=0,showYearDate=0
				..f  s showYearDate=$o(colDocArr(docId,showYear,showYearDate)) q:showYearDate=""  d
					...s value=colDocArr(docId,showYear,showYearDate)
					...s YearNum=YearNum+value
				..s NewDocArr(docId,"Field"_showYear)=YearNum
				..s NewDateList(showYear,docId)=YearNum
			.s NewDocArr("总计","Field1")="总计"
		s sunDate=0
		f  s sunDate=$o(NewDateList(sunDate)) q:sunDate=""  d
			.s sumLocId=0,locNum=0
			.f  s sumLocId=$o(NewDateList(sunDate,sumLocId)) q:sumLocId=""  d
				..s locNum=locNum+$g(NewDateList(sunDate,sumLocId))
			.s NewDocArr("总计","Field"_sunDate)=locNum
		set JsonStr=##class(CIS.AN.COM.String).ToJson(.NewDocArr)

	}
	elseif (type="Oper")
	{
		//colOperArr,SingleOperArr
		s fOperId=0,jsonStr="",locNum=0
		f  s fOperId=$o(SingleOperArr(fOperId)) q:fOperId=""  d
		.s testDate=0
		.s locNum=locNum+1,locDateNum=0,yearNum=0
		.f  s testDate=$o(SingleOperArr(fOperId,testDate)) q:testDate=""  d
			..s newShowDate=$zd(testDate,3)
			..s testOpsId=0,datenum=""
			..s locDateNum=locDateNum+1
			..f  s testOpsId=$o(SingleOperArr(fOperId,testDate,testOpsId)) q:testOpsId=""  d
				...s datenum=datenum+1
				...
			..set OperArr(fOperId,$p(newShowDate,"-",1),testDate)=datenum

		s secOperId=0,num=0,locShowNum=0
		f  s secOperId=$o(OperArr(secOperId)) q:secOperId=""  d
			.s NewOperArr(secOperId,"Field1")=colOperArr(secOperId)
			.s locShowNum=locShowNum+1
			.s showYear=0,dateNum=0,YearField="1"
			.f  s showYear=$o(OperArr(secOperId,showYear)) q:showYear=""  d
				..s YearNum=0,showYearDate=0
				..f  s showYearDate=$o(OperArr(secOperId,showYear,showYearDate)) q:showYearDate=""  d
					...s value=OperArr(secOperId,showYear,showYearDate)
					...s YearNum=YearNum+value
				..s NewOperArr(secOperId,"Field"_showYear)=YearNum
				..s NewDateList(showYear,secOperId)=YearNum
			.s NewOperArr("总计","Field1")="总计"
		s sunDate=0
		f  s sunDate=$o(NewDateList(sunDate)) q:sunDate=""  d
			.s sumLocId=0,locNum=0
			.f  s sumLocId=$o(NewDateList(sunDate,sumLocId)) q:sumLocId=""  d
				..s locNum=locNum+$g(NewDateList(sunDate,sumLocId))
			.s NewOperArr("总计","Field"_sunDate)=locNum

		set JsonStr=##class(CIS.AN.COM.String).ToJson(.NewOperArr)
	}
	elseif (type="Diag")
	{
		//colDiagArr,SingleDiagArr
		s fOperId=0,jsonStr="",locNum=0
		f  s fOperId=$o(SingleDiagArr(fOperId)) q:fOperId=""  d
		.s testDate=0
		.s locNum=locNum+1,locDateNum=0,yearNum=0
		.f  s testDate=$o(SingleDiagArr(fOperId,testDate)) q:testDate=""  d
			..s newShowDate=$zd(testDate,3)
			..s testOpsId=0,datenum=""
			..s locDateNum=locDateNum+1
			..f  s testOpsId=$o(SingleDiagArr(fOperId,testDate,testOpsId)) q:testOpsId=""  d
				...s datenum=datenum+1
				...
			..set OperArr(fOperId,$p(newShowDate,"-",1),testDate)=datenum

		s secOperId=0,num=0,locShowNum=0
		f  s secOperId=$o(OperArr(secOperId)) q:secOperId=""  d
			.s NewOperArr(secOperId,"Field1")=colDiagArr(secOperId)
			.s locShowNum=locShowNum+1
			.s showYear=0,dateNum=0,YearField="1"
			.f  s showYear=$o(OperArr(secOperId,showYear)) q:showYear=""  d
				..s YearNum=0,showYearDate=0
				..f  s showYearDate=$o(OperArr(secOperId,showYear,showYearDate)) q:showYearDate=""  d
					...s value=OperArr(secOperId,showYear,showYearDate)
					...s YearNum=YearNum+value
				..s NewOperArr(secOperId,"Field"_showYear)=YearNum
				..s NewDateList(showYear,secOperId)=YearNum
			.s NewOperArr("总计","Field1")="总计"
		s sunDate=0
		f  s sunDate=$o(NewDateList(sunDate)) q:sunDate=""  d
			.s sumLocId=0,locNum=0
			.f  s sumLocId=$o(NewDateList(sunDate,sumLocId)) q:sumLocId=""  d
				..s locNum=locNum+$g(NewDateList(sunDate,sumLocId))
			.s NewOperArr("总计","Field"_sunDate)=locNum

		set JsonStr=##class(CIS.AN.COM.String).ToJson(.NewOperArr)
	}
	elseif (type="Category")
	{
		///s ClassDescArr(operClass)=operClassDesc
		///s SingleClassArr(operClass,opsDate,opId)=operClassDesc
		s classDr1=0,jsonStr="",locNum=0
		f  s classDr1=$o(SingleClassArr(classDr1)) q:classDr1=""  d
			.s testDate=0
			.s locNum=locNum+1,locDateNum=0,yearNum=0
			.f  s testDate=$o(SingleClassArr(classDr1,testDate)) q:testDate=""  d
				..s newShowDate=$zd(testDate,3)
				..s testOpsId=0,datenum=""
				..s locDateNum=locDateNum+1
				..f  s testOpsId=$o(SingleClassArr(classDr1,testDate,testOpsId)) q:testOpsId=""  d
					...s datenum=datenum+1
					...s catLocDesc=SingleClassArr(classDr1,testDate,testOpsId)
					...s NewClassArrList(classDr1,"Field1")=catLocDesc
					...s NewClassArrList(classDr1,"Field2")=ClassDescArr($p(classDr1,".",2))
				..;一年的某一天
				..set YearClassArr(classDr1,$p(newShowDate,"-",1),testDate)=datenum
				..set YearOperArr($p(newShowDate,"-",1),classDr1,testDate)=datenum	

	s year1=0 f  s year1=$o(YearOperArr(year1)) q:year1=""  d
			.s yearNum=0
			.s class1=0 f  s class1=$o(YearOperArr(year1,class1)) q:class1=""  d
				..s classNum=0
				..s date1=0 f  s date1=$o(YearOperArr(year1,class1,date1)) q:date1=""  d
					...s singleClassNum=$g(YearOperArr(year1,class1,date1))
					...s classNum=classNum+singleClassNum	
				..s yearNum=yearNum+classNum	//每个季度多少手术
			.
			.s NewYearNumArr(year1)=yearNum


		s classDr2=0
		f  s classDr2=$o(YearClassArr(classDr2)) q:classDr2=""  d
			.
			.s year2=0,classNum=0
			.f  s year2=$o(YearClassArr(classDr2,year2)) q:year2=""  d
				..s YearNum=0,showYearDate=0
				..f  s showYearDate=$o(YearClassArr(classDr2,year2,showYearDate)) q:showYearDate=""  d
					...s value=YearClassArr(classDr2,year2,showYearDate)
					...s YearNum=YearNum+value
				
				..s allClassNum=$g(NewYearNumArr(year2))
				..s NewClassArrList(classDr2,"Field"_year2_".Num")=YearNum
				..s persent=""
				..i allClassNum>0 s persent=$fn((YearNum/allClassNum),"",4)*100_"%"
				..s NewClassArrList(classDr2,"Field"_year2_".Per")=persent

		
		
		set JsonStr=##class(CIS.AN.COM.String).ToJson(.NewClassArrList)
		
	}
	 //w JsonStr
	q JsonStr
}

/// 按月统计
/// 手术级别
ClassMethod GetOpsIdListByMonth(sdate, edate, type, note As %String = "", Status As %String = "") As %String
{
	f date=sdate:1:edate d
		.s opsId=0
		.f  s opsId=$order(^CIS.AN.OperScheduleI("DateDaySurgery",date,"Y",opsId)) q:opsId=""  d
			..quit:(opsId="")
			..set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			..q:(operSchedule.PatDeptID="")&(operSchedule.AppDeptID="")
			..set statusCode=operSchedule.Status.Code
			..s outDay=""
			..s moneyStr=##class(web.DHCBillInterface).IGetAdmInOutDatebyEpisodeID(operSchedule.EpisodeID)
			..i moneyStr'="" s outDay=$p(moneyStr,"^",4)
			..q:(Status'="")&(outDay="")	;没出院的排除出去
			..q:(Status'="")&(("|"_Status_"|")'[("|"_statusCode_"|"))
			..q:(Status'="")&(..CheckIfNotDay(opsId)>1)
			..i opsId=31 b	;1
			..s opsDate=operSchedule.OperDate
			..s dateStr=$zd(opsDate,3)
			..s yearM=$p(dateStr,"-",1)
			..s monthM=$p(dateStr,"-",2)
			..s dateM=$p(dateStr,"-",3)
			..;q:(statusCode="Cancel")!(statusCode="Declinie")
			..set PrevDiagnoIdStr=$tr(operSchedule.PrevDiagnosis,$c(4),"")
			..set diagnosisCount=$l(PrevDiagnoIdStr,"&&&")
			..for idnum=1:1:diagnosisCount d
				...set curDiagnosis=$p(PrevDiagnoIdStr,"&&&",idnum)
				...set diagId=$p(curDiagnosis,"###",1)
				...;b	;??
				...q:(+diagId=0)&(type="Diag")
				...set diagDesc=$p(curDiagnosis,"###",2)
				...i (note="")&(type="Diag") d
					....s colDiagArr(diagId)=diagDesc
					....q:$g(DiagExsit(diagId,opsDate,opsId))="Y"
					....s DiagExsit(diagId,opsDate,opsId)="Y"
					....s SingleDiagArr(diagId,opsDate,opsId_"||"_idnum)=diagDesc
					....s MonthDiagArr(diagId,yearM,monthM,opsDate,opsId_"||"_idnum)=diagDesc
					....;b	;?
				...e  i (note'="")&(type="Diag") d
					....s lennote=$l(note,",")
					....f dlen=1:1:lennote d
					.....s sinnote=$p(note,",",dlen)
					.....q:sinnote=""
					.....q:(diagDesc'[sinnote)&(note'="")&(type="Diag")
					.....
					.....s colDiagArr(diagId)=diagDesc
					.....q:$g(DiagExsit(diagId,opsDate,opsId))="Y"
					.....s DiagExsit(diagId,opsDate,opsId)="Y"
					.....s SingleDiagArr(diagId,opsDate,opsId_"||"_idnum)=diagDesc
					.....s MonthDiagArr(diagId,yearM,monthM,opsDate,opsId_"||"_idnum)=diagDesc
			..set operationNameStr="",surgeonNameList=""
			..s opId=0
			..f  s opId=$o(^CIS.AN.OperListI("IOPS",opsId,opId)) q:opId=""  d
				...s operListObj=##class(CIS.AN.OperList).%OpenId(opId)
				...s surgeonId=operListObj.Surgeon
				...;q:+surgeonId=0
				...s surgeonDesc=""
				...i surgeonId>0 s surgeonDesc=$p(^CTPCP(surgeonId,1),"^",2)
				...q:+surgeonId=0
				...s userId=$o(^SSU("SSUSR",0,"CTPCP",surgeonId,""),-1)
				...s anaOpSurgeonCode=""
				...i userId'="" s anaOpSurgeonCode=$p($g(^SSU("SSUSR",userId)),"^",1)
				...q:(type="Doc")&(note'="")&((","_$$ALPHAUP^SSUTIL4(note)_",")'[(","_anaOpSurgeonCode_","))
				...s colSurgeonArr(surgeonId)=surgeonDesc
				...s SingleSurgeonArr(surgeonId,opsDate,opsId_"."_opId)=surgeonDesc

				...s MonthSurgeonArr(surgeonId,yearM,monthM,opsDate,opsId_"."_opId)=""
				...s surgeonDept=operListObj.SurgeonDeptID
				...i surgeonDept="" s surgeonDept=operSchedule.AppDeptID
				...s surgeonDeptDesc=$p(^CTLOC(surgeonDept),"^",2)
				...;b
				...q:((","_note_",")'[(","_surgeonDeptDesc_","))&(note'="")&(type="Loc")
				...s colDeptArr(surgeonDept)=surgeonDeptDesc
				...s SingleDeptArr(surgeonDept,opsDate,opsId_"."_opId)=surgeonDeptDesc
				...s MonthDeptArr(surgeonDept,yearM,monthM,opsDate,opsId_"."_opId)=""
				...s operId=operListObj.Operation
				...s operDesc=$p(^ORC("OPER",operId),"^",2)
				...;q:(operDesc'[note)&(note'="")&(type="Oper")
				...;s colOperArr(operId)=operDesc
				...;s SingleOperArr(operId,opsDate,opsId_"."_opId)=operDesc
				...;s MonthOperArr(operId,yearM,monthM,opsDate,opsId_"."_opId)=""
				...i (note="")&(type="Oper") d
					....;
					....s colOperArr(operId)=operDesc
					....s SingleOperArr(operId,opsDate,opsId_"."_opId)=operDesc
					....s MonthOperArr(operId,yearM,monthM,opsDate,opsId_"."_opId)=""
				...;q:(operDesc'[note)&(note'="")&(type="Oper")
				...e  i (note'="")&(type="Oper") d
					....s lennote=$l(note,",")
					....f dlen=1:1:lennote d
						.....s sinnote=$p(note,",",dlen)
						.....q:sinnote=""
						.....q:(operDesc'[sinnote)&(note'="")&(type="Oper")
						.....s colOperArr(operId)=operDesc
						.....s SingleOperArr(operId,opsDate,opsId_"."_opId)=operDesc
						.....s MonthOperArr(operId,yearM,monthM,opsDate,opsId_"."_opId)=""
				
				...s operClassDesc="未填"
				...s operClass=operListObj.OperClass
				...i +operClass>0 s operClassDesc=$p(^ORC("CATEG",operClass),"^",2)
				...e  s operClass=1999
				...s newNoteLoc="",newNoteCate=""
				...i (type="Category")&(note'="") d
					....
					....s newNoteLoc=$p(note,"|",1)
					....s newNoteCate=$p(note,"|",2)	
				...q:((","_newNoteLoc_",")'[(","_surgeonDeptDesc_","))&(newNoteLoc'="")&(type="Category")
				...q:((","_newNoteCate_",")'[(","_operClassDesc_","))&(newNoteCate'="")&(type="Category")
				...s ClassDescArr(operClass)=operClassDesc
				...s SingleClassArr(surgeonDeptDesc,operClass,opsDate,opsId_"."_opId)=surgeonDeptDesc
				
				

	if (type="Loc")
	{
	//按科室
	s locId=0,num=0,locShowNum=0
	f  s locId=$o(MonthDeptArr(locId)) q:locId=""  d
		.s NewLocArr(locId,"Field1")=colDeptArr(locId)
		.s showYear=0
		.f  s showYear=$o(MonthDeptArr(locId,showYear)) q:showYear=""  d
			..s showMonth=0
			..f  s showMonth=$o(MonthDeptArr(locId,showYear,showMonth)) q:showMonth=""  d
				...s MonthNum=0,showDate=0
				...f  s showDate=$o(MonthDeptArr(locId,showYear,showMonth,showDate)) q:showDate=""  d
					....s showOpsId=0,dateNum=""
					....f  s showOpsId=$o(MonthDeptArr(locId,showYear,showMonth,showDate,showOpsId)) q:showOpsId=""  d
						.....s dateNum=dateNum+1
					....s MonthNum=MonthNum+dateNum
				...s NewLocArr(locId,"Field"_showYear_"."_showMonth)=MonthNum
				...s NewDateList(showYear_"."_showMonth,locId)=MonthNum
		.s NewLocArr("总计","Field1")="总计"
		s sunDate=0
		f  s sunDate=$o(NewDateList(sunDate)) q:sunDate=""  d
			.s sumLocId=0,locNum=0
			.f  s sumLocId=$o(NewDateList(sunDate,sumLocId)) q:sumLocId=""  d
				..s locNum=locNum+$g(NewDateList(sunDate,sumLocId))
			.s NewLocArr("总计","Field"_sunDate)=locNum

	set JsonStr=##class(CIS.AN.COM.String).ToJson(.NewLocArr)
	}
	elseif (type="Doc")
	{
		//按主刀
		s docId=0,num=0,locShowNum=0
		f  s docId=$o(MonthSurgeonArr(docId)) q:docId=""  d
			.s NewDocArr(docId,"Field1")=colSurgeonArr(docId)
			.s showYear=0
			.f  s showYear=$o(MonthSurgeonArr(docId,showYear)) q:showYear=""  d
				..s showMonth=0
				..f  s showMonth=$o(MonthSurgeonArr(docId,showYear,showMonth)) q:showMonth=""  d
					...s MonthNum=0,showDate=0
					...f  s showDate=$o(MonthSurgeonArr(docId,showYear,showMonth,showDate)) q:showDate=""  d
						....s showopsId=0,datenum=""
						....f  s showopsId=$o(MonthSurgeonArr(docId,showYear,showMonth,showDate,showopsId)) q:showopsId=""  d
							.....s datenum=datenum+1
						....s MonthNum=MonthNum+datenum
					...s NewDocArr(docId,"Field"_showYear_"."_showMonth)=MonthNum
					...s NewDateList(showYear_"."_showMonth,docId)=MonthNum
		.s NewDocArr("总计","Field1")="总计"
		s sunDate=0
		f  s sunDate=$o(NewDateList(sunDate)) q:sunDate=""  d
			.s sumLocId=0,locNum=0
			.f  s sumLocId=$o(NewDateList(sunDate,sumLocId)) q:sumLocId=""  d
				..s locNum=locNum+$g(NewDateList(sunDate,sumLocId))
			.s NewDocArr("总计","Field"_sunDate)=locNum

		set JsonStr=##class(CIS.AN.COM.String).ToJson(.NewDocArr)
	}
	elseif (type="Oper")
	{
		//按手术
		s secOperId=0,num=0,locShowNum=0
		f  s secOperId=$o(MonthOperArr(secOperId)) q:secOperId=""  d
			.s NewOperArr(secOperId,"Field1")=colOperArr(secOperId)
			.s showYear=0
			.f  s showYear=$o(MonthOperArr(secOperId,showYear)) q:showYear=""  d
				..s showMonth=0
				..f  s showMonth=$o(MonthOperArr(secOperId,showYear,showMonth)) q:showMonth=""  d
					...s MonthNum=0,showDate=0
					...f  s showDate=$o(MonthOperArr(secOperId,showYear,showMonth,showDate)) q:showDate=""  d
						....s secOpsId=0,datenum=""
						....f  s secOpsId=$o(MonthOperArr(secOperId,showYear,showMonth,showDate,secOpsId)) q:secOpsId=""  d
							.....s datenum=datenum+1
						....s MonthNum=MonthNum+datenum
					...s NewOperArr(secOperId,"Field"_showYear_"."_showMonth)=MonthNum
					...s NewDateList(showYear_"."_showMonth,secOperId)=MonthNum
			.s NewOperArr("总计","Field1")="总计"
		s sunDate=0
		f  s sunDate=$o(NewDateList(sunDate)) q:sunDate=""  d
			.s sumLocId=0,locNum=0
			.f  s sumLocId=$o(NewDateList(sunDate,sumLocId)) q:sumLocId=""  d
				..s locNum=locNum+$g(NewDateList(sunDate,sumLocId))
			.s NewOperArr("总计","Field"_sunDate)=locNum

		set JsonStr=##class(CIS.AN.COM.String).ToJson(.NewOperArr)
	}
	elseif (type="Diag")
	{
		b
		//按诊断
		s secOperId=0,num=0,locShowNum=0
		f  s secOperId=$o(MonthDiagArr(secOperId)) q:secOperId=""  d
			.s NewOperArr(secOperId,"Field1")=colDiagArr(secOperId)
			.s showYear=0
			.f  s showYear=$o(MonthDiagArr(secOperId,showYear)) q:showYear=""  d
				..s showMonth=0
				..f  s showMonth=$o(MonthDiagArr(secOperId,showYear,showMonth)) q:showMonth=""  d
					...s MonthNum=0,showYearDate=0
					...f  s showYearDate=$o(MonthDiagArr(secOperId,showYear,showMonth,showYearDate)) q:showYearDate=""  d
						....s diaopsId=0,datenum=""
						....f  s diaopsId=$o(MonthDiagArr(secOperId,showYear,showMonth,showYearDate,diaopsId)) q:diaopsId=""  d
							.....s datenum=datenum+1
						....s MonthNum=MonthNum+datenum
					...s NewOperArr(secOperId,"Field"_showYear_"."_showMonth)=MonthNum
					...s NewDateList(showYear_"."_showMonth,secOperId)=MonthNum
			.s NewOperArr("总计","Field1")="总计"
		s sunDate=0
		f  s sunDate=$o(NewDateList(sunDate)) q:sunDate=""  d
			.s sumLocId=0,locNum=0
			.f  s sumLocId=$o(NewDateList(sunDate,sumLocId)) q:sumLocId=""  d
				..s locNum=locNum+$g(NewDateList(sunDate,sumLocId))
			.s NewOperArr("总计","Field"_sunDate)=locNum
	
		set JsonStr=##class(CIS.AN.COM.String).ToJson(.NewOperArr)
	}
	elseif (type="Category")
	{
		///按手术级别
		///s ClassDescArr(operClass)=operClassDesc
		///s SingleClassArr(operClass,opsDate,opId)=operClassDesc
	 s locId5=0,jsonStr="",locNum=0
	 f  s locId5=$o(SingleClassArr(locId5)) q:locId5=""  d
	 .s fClassId=0
	 .f  s fClassId=$o(SingleClassArr(locId5,fClassId)) q:fClassId=""  d
		..s testDate=0
		..s locNum=locNum+1,locDateNum=0,yearNum=0
		..f  s testDate=$o(SingleClassArr(locId5,fClassId,testDate)) q:testDate=""  d
			...s newShowDate=$zd(testDate,3)
			...s testOpsId=0,datenum=""
			...s locDateNum=locDateNum+1
			...f  s testOpsId=$o(SingleClassArr(locId5,fClassId,testDate,testOpsId)) q:testOpsId=""  d
				....s datenum=datenum+1
				....s catLocDesc=SingleClassArr(locId5,fClassId,testDate,testOpsId)
				....s NewClassArr(fClassId,"Field1")=catLocDesc
				....s NewClassArr(fClassId,"Field2")=ClassDescArr(fClassId)
			...set ClassListArr(locId5,fClassId,$p(newShowDate,"-",1),$p(newShowDate,"-",2),testDate)=datenum
			...set MonthListArr($p(newShowDate,"-",1),$p(newShowDate,"-",2),locId5,fClassId,testDate)=datenum
			...;set YearListArr($p(newShowDate,"-",1),$p(newShowDate,"-",2),fClassId,testDate)=datenum
		///先算出一个月有多少
		s year1=0 f  s year1=$o(MonthListArr(year1)) q:year1=""  d
			.s classYearNum=0	//单年多少手术量	
			.s month1=0 f  s month1=$o(MonthListArr(year1,month1)) q:month1=""  d
				..s monthNum=0	//单月总计多少手术量
				..s locId2=0
				..f  s locId2=$o(MonthListArr(year1,month1,locId2)) q:locId2=""  d
					...s locclass1=0 ,classOperNum=0	;每年单个科室所有手术数量
					...f  s locclass1=$o(MonthListArr(year1,month1,locId2,locclass1)) q:locclass1=""  d
						....
						....s singleClassNum=0	;每个月单个级别的数量
						....s showYearDate=0 
						....f  s showYearDate=$o(MonthListArr(year1,month1,locId2,locclass1,showYearDate)) q:showYearDate=""  d
							.....s value=MonthListArr(year1,month1,locId2,locclass1,showYearDate)	//一天的手术量
							.....s singleClassNum=singleClassNum+value	//每个级别每月多少手术
						....s classOperNum=classOperNum+singleClassNum	
					...s monthNum=monthNum+classOperNum	//每个月多少手术
					...s NewNumArr(year1_"."_month1_"."_locId2)=classOperNum
		
		s secLocId=0
		f  s secLocId=$o(ClassListArr(secLocId)) q:secLocId=""  d
		.s classOperNum=0
		.s secClass=0 f  s secClass=$o(ClassListArr(secLocId,secClass)) q:secClass=""  d
			..s yearAllNum=0
			..s secYear=0 f  s secYear=$o(ClassListArr(secLocId,secClass,secYear)) q:secYear=""  d
				...s classYearNum=0,classOperNum=0	;每年单个级别的数量
				...s secMonth=0 f  s secMonth=$o(ClassListArr(secLocId,secClass,secYear,secMonth)) q:secMonth=""  d
					....s singleClassNum=0	;每个月单个级别的数量
					....s showYearDate=0 f  s showYearDate=$o(ClassListArr(secLocId,secClass,secYear,secMonth,showYearDate)) q:showYearDate=""  d
						.....s value=ClassListArr(secLocId,secClass,secYear,secMonth,showYearDate)	//一天的手术量
						.....s singleClassNum=singleClassNum+value	//每个级别每月多少手术
					....s classOperNum=classOperNum+singleClassNum	//每个月多少单个级别手术
					....s locClassNum=$g(NewNumArr(secYear_"."_secMonth_"."_secLocId))
					....s NewClassArr(secClass,"Field"_secYear_"."_secMonth_".Num")=singleClassNum
					....i locClassNum>0 s persent=$fn((singleClassNum/locClassNum),"",4)*100_"%"
			   		....s NewClassArr(secClass,"Field"_secYear_"."_secMonth_".Per")=persent

		set JsonStr=##class(CIS.AN.COM.String).ToJson(.NewClassArr)
	}
	q JsonStr
}

ClassMethod GetOpsIdListBySeason(sdate, edate, type, note As %String = "", Status As %String = "") As %String
{
	f date=sdate:1:edate d
		.s opsId=0
		.f  s opsId=$order(^CIS.AN.OperScheduleI("DateDaySurgery",date,"Y",opsId)) q:opsId=""  d
			..quit:(opsId="")
			..set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			..q:(operSchedule.PatDeptID="")&(operSchedule.AppDeptID="")
			..set statusCode=operSchedule.Status.Code
			..s outDay=""
			..s moneyStr=##class(web.DHCBillInterface).IGetAdmInOutDatebyEpisodeID(operSchedule.EpisodeID)
			..i moneyStr'="" s outDay=$p(moneyStr,"^",4)
			..q:(Status'="")&(outDay="")	;没出院的排除出去
			..s opsDate=operSchedule.OperDate
			..s newShowDate=$zd(opsDate,3)
			..s YearShow=$p(newShowDate,"-",1)
			..s MonthShow=$p(newShowDate,"-",2)
			..i +MonthShow<4 s season="一季度",seasonCode=1
			..i (+MonthShow>3)&(+MonthShow<7) s season="二季度",seasonCode=2
			..i (+MonthShow>6)&(+MonthShow<10) s season="三季度",seasonCode=3
			..i +MonthShow>9 s season="四季度",seasonCode=4
			..;q:(statusCode="Cancel")!(statusCode="Declinie")
			..q:(Status'="")&(("|"_Status_"|")'[("|"_statusCode_"|"))
			..q:(Status'="")&(..CheckIfNotDay(opsId)>1)
			..set PrevDiagnoIdStr=$tr(operSchedule.PrevDiagnosis,$c(4),"")
			..set diagnosisCount=$l(PrevDiagnoIdStr,"&&&")
			..for idnum=1:1:diagnosisCount d
				...set curDiagnosis=$p(PrevDiagnoIdStr,"&&&",idnum)
				...set diagId=$p(curDiagnosis,"###",1)
				...q:(+diagId=0)&(type="Diag")
				...set diagDesc=$p(curDiagnosis,"###",2)
				...i (note="")&(type="Diag") d
					....s colDiagArr(diagId)=diagDesc
					....q:$g(DiagExsit(diagId,opsDate,opsId))="Y"
					....s DiagExsit(diagId,opsDate,opsId)="Y"
					....s SingleDiagArr(diagId,opsDate,opsId_"||"_idnum)=diagDesc
					....s SingleDiagSeasonArr(diagId,YearShow,seasonCode,MonthShow,newShowDate,opsId_"||"_idnum)=diagDesc
				...e  i (note'="")&(type="Diag") d
					....s lennote=$l(note,",")
					....f dlen=1:1:lennote d
						.....s sinnote=$p(note,",",dlen)
						.....q:sinnote=""
						.....q:(diagDesc'[sinnote)&(note'="")&(type="Diag")
						.....
						.....s colDiagArr(diagId)=diagDesc
						.....q:$g(DiagExsit(diagId,opsDate,opsId))="Y"
						.....s DiagExsit(diagId,opsDate,opsId)="Y"
						.....s SingleDiagArr(diagId,opsDate,opsId_"||"_idnum)=diagDesc
						.....s SingleDiagSeasonArr(diagId,YearShow,seasonCode,MonthShow,newShowDate,opsId_"||"_idnum)=diagDesc

				...;q:(diagDesc'[note)&(note'="")&(type="Diag")
				...;q:$g(DiagExsit(diagId,opsDate,opsId))="Y"
				...;s DiagExsit(diagId,opsDate,opsId)="Y"
				...;s colDiagArr(diagId)=diagDesc
				...;s SingleDiagArr(diagId,opsDate,opsId_"||"_idnum)=diagDesc
				...;s SingleDiagSeasonArr(diagId,YearShow,seasonCode,MonthShow,newShowDate,opsId_"||"_idnum)=diagDesc

			..set operationNameStr="",surgeonNameList=""
			..s opId=0
			..f  s opId=$o(^CIS.AN.OperListI("IOPS",opsId,opId)) q:opId=""  d
				...s operListObj=##class(CIS.AN.OperList).%OpenId(opId)
				...s surgeonId=operListObj.Surgeon
				...;q:+surgeonId=0
				...s surgeonDesc=""
				...i surgeonId>0 s surgeonDesc=$p(^CTPCP(surgeonId,1),"^",2)
				...q:+surgeonId=0
				...s userId=$o(^SSU("SSUSR",0,"CTPCP",surgeonId,""),-1)
				...s anaOpSurgeonCode=""
				...i userId'="" s anaOpSurgeonCode=$p($g(^SSU("SSUSR",userId)),"^",1)
				...q:(type="Doc")&(note'="")&((","_$$ALPHAUP^SSUTIL4(note)_",")'[(","_anaOpSurgeonCode_","))
				...s colSurgeonArr(surgeonId)=surgeonDesc
				...s SingleSurgeonArr(surgeonId,opsDate,opsId_"."_opId)=surgeonDesc
				...s surgeonDept=operListObj.SurgeonDeptID
				...i surgeonDept="" s surgeonDept=operSchedule.AppDeptID
				...s surgeonDeptDesc=$p(^CTLOC(surgeonDept),"^",2)
				...q:((","_note_",")'[(","_surgeonDeptDesc_","))&(note'="")&(type="Loc")
				...s colDeptArr(surgeonDept)=surgeonDeptDesc
				...s SingleDeptArr(surgeonDept,opsDate,opsId_"."_opId)=surgeonDeptDesc
				...s operId=operListObj.Operation
				...s operDesc=$p(^ORC("OPER",operId),"^",2)
				...;s colOperArr(operId)=operDesc
				...;s SingleOperArr(operId,opsDate,opsId_"."_opId)=operDesc
				...;q:(operDesc'[note)&(note'="")&(type="Oper")
				...i (note="")&(type="Oper") d
					....;
					....s colOperArr(operId)=operDesc
					....s SingleOperArr(operId,opsDate,opsId_"."_opId)=operDesc
					....s SingleOperSeasonArr(operId,YearShow,seasonCode,MonthShow,newShowDate,opsId_"."_opId)=operDesc
				...;q:(operDesc'[note)&(note'="")&(type="Oper")
				...e  i (note'="")&(type="Oper") d
					....s lennote=$l(note,",")
					....f dlen=1:1:lennote d
						.....s sinnote=$p(note,",",dlen)
						.....q:sinnote=""
						.....q:(operDesc'[sinnote)&(note'="")&(type="Oper")
						.....s colOperArr(operId)=operDesc
						.....s SingleOperArr(operId,opsDate,opsId_"."_opId)=operDesc
						.....s SingleOperSeasonArr(operId,YearShow,seasonCode,MonthShow,newShowDate,opsId_"."_opId)=operDesc

				...s operClassDesc="未填"
				...s operClass=operListObj.OperClass
				...i +operClass>0 s operClassDesc=$p(^ORC("CATEG",operClass),"^",2)
				...e  s operClass=1999
				...s ClassDescArr(operClass)=operClassDesc
				...s SingleClassArr(surgeonDeptDesc_"."_operClass,opsDate,opsId_"."_opId)=surgeonDeptDesc
				...s SingleLocSeasonArr(surgeonDept,YearShow,seasonCode,MonthShow,newShowDate,opsId_"."_opId)=surgeonDeptDesc
				...s SingleDocSeasonArr(surgeonId,YearShow,seasonCode,MonthShow,newShowDate,opsId_"."_opId)=surgeonDesc
				...s SingleClassSeasonArr(operClass,YearShow,seasonCode,MonthShow,newShowDate,opsId_"."_opId)=operClassDesc
				...

	if (type="Loc")
	{
	//按科室
	s locId=0,num=0,locShowNum=0
	f  s locId=$o(SingleLocSeasonArr(locId)) q:locId=""  d
		.s NewLocArr(locId,"Field1")=colDeptArr(locId)
		.s showYear=0
		.f  s showYear=$o(SingleLocSeasonArr(locId,showYear)) q:showYear=""  d
			..s showSeason=0 
			..f  s showSeason=$o(SingleLocSeasonArr(locId,showYear,showSeason)) q:showSeason=""  d
				...s showMonth=0,SeasonNum=0
				...;单季多少
				...f  s showMonth=$o(SingleLocSeasonArr(locId,showYear,showSeason,showMonth)) q:showMonth=""  d
					....s showDate=0,monthNum=""
					....;单月多少
					....f  s showDate=$o(SingleLocSeasonArr(locId,showYear,showSeason,showMonth,showDate)) q:showDate=""  d
						.....s showOpsId=0,dateNum=""
						.....;一天多少
						.....f  s showOpsId=$o(SingleLocSeasonArr(locId,showYear,showSeason,showMonth,showDate,showOpsId)) q:showOpsId=""  d
							......s dateNum=dateNum+1
						.....s monthNum=monthNum+dateNum
					....s SeasonNum=SeasonNum+monthNum
				...s NewLocArr(locId,"Field"_showYear_"."_showSeason)=SeasonNum
				...s NewDateList(showYear_"."_showSeason,locId)=SeasonNum
			.s NewLocArr("总计","Field1")="总计"
		s sunDate=0
		f  s sunDate=$o(NewDateList(sunDate)) q:sunDate=""  d
			.s sumLocId=0,locNum=0
			.f  s sumLocId=$o(NewDateList(sunDate,sumLocId)) q:sumLocId=""  d
				..s locNum=locNum+$g(NewDateList(sunDate,sumLocId))
			.s NewLocArr("总计","Field"_sunDate)=locNum

	set JsonStr=##class(CIS.AN.COM.String).ToJson(.NewLocArr)
	}
	elseif (type="Doc")
	{
		//按医生
		s secDocId=0,num=0,locShowNum=0
		f  s secDocId=$o(SingleDocSeasonArr(secDocId)) q:secDocId=""  d
		.s NewDocArrList(secDocId,"Field1")=colSurgeonArr(secDocId)
		.s showYear=0
		.f  s showYear=$o(SingleDocSeasonArr(secDocId,showYear)) q:showYear=""  d
			..s showSeason=0 
			..f  s showSeason=$o(SingleDocSeasonArr(secDocId,showYear,showSeason)) q:showSeason=""  d
				...s showMonth=0,SeasonNum=0
				...f  s showMonth=$o(SingleDocSeasonArr(secDocId,showYear,showSeason,showMonth)) q:showMonth=""  d
					....s showYearDate=0,monthnum=""
					....f  s showYearDate=$o(SingleDocSeasonArr(secDocId,showYear,showSeason,showMonth,showYearDate)) q:showYearDate=""  d
						.....s showOpsId=0,dateNum=""
						.....;一天多少
						.....f  s showOpsId=$o(SingleDocSeasonArr(secDocId,showYear,showSeason,showMonth,showYearDate,showOpsId)) q:showOpsId=""  d
							......s dateNum=dateNum+1
						.....s monthnum=monthnum+dateNum
					....s SeasonNum=SeasonNum+monthnum
				...s NewDocArrList(secDocId,"Field"_showYear_"."_showSeason)=SeasonNum
				...s NewDateList(showYear_"."_showSeason,secDocId)=SeasonNum
			.s NewDocArrList("总计","Field1")="总计"
		s sunDate=0
		f  s sunDate=$o(NewDateList(sunDate)) q:sunDate=""  d
			.s sumLocId=0,locNum=0
			.f  s sumLocId=$o(NewDateList(sunDate,sumLocId)) q:sumLocId=""  d
				..s locNum=locNum+$g(NewDateList(sunDate,sumLocId))
			.s NewDocArrList("总计","Field"_sunDate)=locNum

	set JsonStr=##class(CIS.AN.COM.String).ToJson(.NewDocArrList)

	}
	elseif (type="Oper")
	{
		//按手术
		s secDocId=0,num=0,locShowNum=0
		f  s secDocId=$o(SingleOperSeasonArr(secDocId)) q:secDocId=""  d
		.s NewDocArrList(secDocId,"Field1")=colOperArr(secDocId)
		.s showYear=0
		.f  s showYear=$o(SingleOperSeasonArr(secDocId,showYear)) q:showYear=""  d
			..s showSeason=0 
			..f  s showSeason=$o(SingleOperSeasonArr(secDocId,showYear,showSeason)) q:showSeason=""  d
				...s showMonth=0,SeasonNum=0
				...f  s showMonth=$o(SingleOperSeasonArr(secDocId,showYear,showSeason,showMonth)) q:showMonth=""  d
					....s showYearDate=0,monthnum=""
					....f  s showYearDate=$o(SingleOperSeasonArr(secDocId,showYear,showSeason,showMonth,showYearDate)) q:showYearDate=""  d
						.....s showOpsId=0,dateNum=""
						.....;一天多少
						.....f  s showOpsId=$o(SingleOperSeasonArr(secDocId,showYear,showSeason,showMonth,showYearDate,showOpsId)) q:showOpsId=""  d
							......s dateNum=dateNum+1
						.....s monthnum=monthnum+dateNum
					....s SeasonNum=SeasonNum+monthnum
				...s NewDocArrList(secDocId,"Field"_showYear_"."_showSeason)=SeasonNum
				...s NewDateList(showYear_"."_showSeason,secDocId)=SeasonNum
			.s NewDocArrList("总计","Field1")="总计"
		s sunDate=0
		f  s sunDate=$o(NewDateList(sunDate)) q:sunDate=""  d
			.s sumLocId=0,locNum=0
			.f  s sumLocId=$o(NewDateList(sunDate,sumLocId)) q:sumLocId=""  d
				..s locNum=locNum+$g(NewDateList(sunDate,sumLocId))
			.s NewDocArrList("总计","Field"_sunDate)=locNum

	set JsonStr=##class(CIS.AN.COM.String).ToJson(.NewDocArrList)

	}
	elseif (type="Diag")
	{
		//按诊断
		s secDocId=0,num=0,locShowNum=0
		f  s secDocId=$o(SingleDiagSeasonArr(secDocId)) q:secDocId=""  d
		.s NewDocArrList(secDocId,"Field1")=colDiagArr(secDocId)
		.s showYear=0
		.f  s showYear=$o(SingleDiagSeasonArr(secDocId,showYear)) q:showYear=""  d
			..s showSeason=0 
			..f  s showSeason=$o(SingleDiagSeasonArr(secDocId,showYear,showSeason)) q:showSeason=""  d
				...s showMonth=0,SeasonNum=0
				...f  s showMonth=$o(SingleDiagSeasonArr(secDocId,showYear,showSeason,showMonth)) q:showMonth=""  d
					....s showYearDate=0,monthnum=""
					....f  s showYearDate=$o(SingleDiagSeasonArr(secDocId,showYear,showSeason,showMonth,showYearDate)) q:showYearDate=""  d
						.....s showOpsId=0,dateNum=""
						.....;一天多少
						.....f  s showOpsId=$o(SingleDiagSeasonArr(secDocId,showYear,showSeason,showMonth,showYearDate,showOpsId)) q:showOpsId=""  d
							......s dateNum=dateNum+1
						.....s monthnum=monthnum+dateNum
					....s SeasonNum=SeasonNum+monthnum
				...s NewDocArrList(secDocId,"Field"_showYear_"."_showSeason)=SeasonNum
				...s NewDateList(showYear_"."_showSeason,secDocId)=SeasonNum
			.s NewDocArrList("总计","Field1")="总计"
		s sunDate=0
		f  s sunDate=$o(NewDateList(sunDate)) q:sunDate=""  d
			.s sumLocId=0,locNum=0
			.f  s sumLocId=$o(NewDateList(sunDate,sumLocId)) q:sumLocId=""  d
				..s locNum=locNum+$g(NewDateList(sunDate,sumLocId))
			.s NewDocArrList("总计","Field"_sunDate)=locNum

	set JsonStr=##class(CIS.AN.COM.String).ToJson(.NewDocArrList)

	}
	elseif (type="Category")
	{
		///按手术级别
		///s ClassDescArr(operClass)=operClassDesc
		///s SingleClassArr(operClass,opsDate,opId)=operClassDesc
		s classDr=0,jsonStr="",locNum=0
		f  s classDr=$o(SingleClassArr(classDr)) q:classDr=""  d
			.s testDate=0
			.s locNum=locNum+1,locDateNum=0,yearNum=0
			.f  s testDate=$o(SingleClassArr(classDr,testDate)) q:testDate=""  d
				..s newShowDate=$zd(testDate,3)
				..s YearShow=$p(newShowDate,"-",1)
				..s MonthShow=$p(newShowDate,"-",2)
				..i +MonthShow<4 s season="一季度",seasonCode=1
				..i (+MonthShow>3)&(+MonthShow<7) s season="二季度",seasonCode=2
				..i (+MonthShow>6)&(+MonthShow<10) s season="三季度",seasonCode=3
				..i +MonthShow>9 s season="四季度",seasonCode=4
				..s testOpsId=0,datenum=""
				..s locDateNum=locDateNum+1
				..f  s testOpsId=$o(SingleClassArr(classDr,testDate,testOpsId)) q:testOpsId=""  d
					...s datenum=datenum+1
					...s catLocDesc=SingleClassArr(classDr,testDate,testOpsId)
					...s NewClassArrList(classDr,"Field1")=catLocDesc
					...s NewClassArrList(classDr,"Field2")=ClassDescArr($p(classDr,".",2))
				..set ClassArrList(classDr,YearShow,seasonCode,MonthShow,testDate)=datenum
				..set SeasonClassList(YearShow,seasonCode,MonthShow,classDr,testDate)=datenum
		
		s year1=0 f  s year1=$o(SeasonClassList(year1)) q:year1=""  d
			.s seasonNum=0
			.s season1=0 f  s season1=$o(SeasonClassList(year1,season1)) q:season1=""  d
				..s seasonNum=0
				..s month1=0 f  s month1=$o(SeasonClassList(year1,season1,month1)) q:month1=""  d
					...s monthNum=0	;每月的手术数量
					...s class1=0 
					...f  s class1=$o(SeasonClassList(year1,season1,month1,class1)) q:class1=""  d
						....s singleClassNum=0	;单个级别的数量
						....s date1=0 
						....f  s date1=$o(SeasonClassList(year1,season1,month1,class1,date1)) q:date1=""  d
							.....s value=SeasonClassList(year1,season1,month1,class1,date1)	//一天的手术量
							.....s singleClassNum=singleClassNum+value	
						....s monthNum=monthNum+singleClassNum	//每月多少手术
					...s seasonNum=seasonNum+monthNum	//每个季度多少手术
				..
				..s NewSeasonNumArr(year1_"."_season1)=seasonNum



		s classDr2=0,allnum=0
		f  s classDr2=$o(ClassArrList(classDr2)) q:classDr2=""  d
			.
			.
			.s year2=0
			.f  s year2=$o(ClassArrList(classDr2,year2)) q:year2=""  d
				..s season2=0 ,yearNum=0
				..f  s season2=$o(ClassArrList(classDr2,year2,season2)) q:season2=""  d
					...s month2=0,seasonNum=0
					...f  s month2=$o(ClassArrList(classDr2,year2,season2,month2)) q:month2=""  d
						....s date2=0,dateNum=0
						....f  s date2=$o(ClassArrList(classDr2,year2,season2,month2,date2)) q:date2=""  d
							.....s value=ClassArrList(classDr2,year2,season2,month2,date2)
							.....s dateNum=dateNum+value
							.....
						....s seasonNum=seasonNum+dateNum	;
					...;dateNum：每个月多少；monthNum:一个季度多少;SeasonNum:
					...s allClassNum=$g(NewSeasonNumArr(year2_"."_season2))
					...s NewClassArrList(classDr2,"Field"_year2_"."_season2_".Num")=seasonNum
					...s persent=""
					...i allClassNum>0 s persent=$fn((seasonNum/allClassNum),"",4)*100_"%"
			   		...s NewClassArrList(classDr2,"Field"_year2_"."_season2_".Per")=persent

	set JsonStr=##class(CIS.AN.COM.String).ToJson(.NewClassArrList)
	}

	 //w JsonStr
	q JsonStr
}

/// 按科室统计日间手术预约例数
/// w ##class(CIS.AN.BL.DaySurgeryStatistics).GetListResult("day","2021-12-30","2021-12-30","头疼","Diag","")
/// w ##class(CIS.AN.BL.DaySurgeryStatistics).GetListResult("year","2021","2021","","Category")
/// w ##class(CIS.AN.BL.DaySurgeryStatistics).GetListResult("month","2021-12","2022-01","","Diag","Finish")
/// w ##class(CIS.AN.BL.DaySurgeryStatistics).GetListResult("season","2021-04","2021-04","","Doc","")
ClassMethod GetListResult(type As %String, date1 As %String = "", date2 As %String = "", note As %String = "", Strategy As %String, Status As %String = "") As %String
{
	s result="",operCount=0
	i type="day" d
		.s sdate=+##class(CIS.AN.COM.DateTime).ConvertToDateH(date1,"")
		.s edate=+##class(CIS.AN.COM.DateTime).ConvertToDateH(date2,"")
		.i (edate-sdate)>31 s result="按日期查询最多可以查询31天"
		.q:result'=""
		.s result=..GetOpsIdListByDate(sdate,edate,Strategy,note,Status)
	i type="year" d
		.s sdate=+##class(CIS.AN.COM.DateTime).ConvertToDateH(date1_"-01-01","")
		.s edate=+##class(CIS.AN.COM.DateTime).ConvertToDateH(date2_"-12-31","")
		.i (date2-date1)>3 s result="按年查询最多可以查询3年数据"
		.q:result'=""
		.s result=..GetOpsIdListByYear(sdate,edate,Strategy,note,Status)
	i type="month" d
		.s sdate=+##class(CIS.AN.COM.DateTime).ConvertToDateH(date1_"-01","")
		.s month=$p(date2,"-",2)
		.s month1=$p(date1,"-",2)
		.s year2=$p(date2,"-",1)
		.s year1=$p(date1,"-",1)
		.s yearnum=year2-year1
		.s monthnum=yearnum*12+month-month1
		.i monthnum>24 s result="按月查询最多可以查询24个月数据"
		.q:result'=""
		.s newMonth=month+1
		.i newMonth<10 s newMonth="0"_newMonth
		.i newMonth=13 s newMonth="01"  s year2=year2+1
		.s newDate2=year2_"-"_newMonth_"-01"
		.s edate=+##class(CIS.AN.COM.DateTime).ConvertToDateH(newDate2,"")-1
		.;b ;s operCount=operCount+1
		.s result=..GetOpsIdListByMonth(sdate,edate,Strategy,note,Status)
	i type="season" d
		.s YearS=$p(date1,"-",1)
		.s MonthS=$p(date1,"-",2)
		.s YearE=$p(date2,"-",1)
		.s MonthE=$p(date2,"-",2)
		.s yearnum=YearE-YearS
		.s seasonnum=yearnum*4+MonthE-MonthS
		.i (seasonnum>12) s result="按季度查询最多可以查询12个季度数据"
		.q:result'=""
		
		.i MonthS="01" s newDateStr1=YearS_"-"_"01"_"-01"
		.i MonthS="02" s newDateStr1=YearS_"-"_"04"_"-01"
		.i MonthS="03" s newDateStr1=YearS_"-"_"07"_"-01"
		.i MonthS="04" s newDateStr1=YearS_"-"_"10"_"-01"
		.i MonthE="01" s newDateStr2=YearE_"-"_"03"_"-31"
		.i MonthE="02" s newDateStr2=YearE_"-"_"06"_"-30"
		.i MonthE="03" s newDateStr2=YearE_"-"_"09"_"-30"
		.i MonthE="04" s newDateStr2=YearE_"-"_"12"_"-31"
		.s sdate=+##class(CIS.AN.COM.DateTime).ConvertToDateH(newDateStr1,"")
		.s edate=+##class(CIS.AN.COM.DateTime).ConvertToDateH(newDateStr2,"")
		.;s operCount=operCount+1
		.s result=..GetOpsIdListBySeason(sdate,edate,Strategy,note,Status)

	
	quit result
}

/// w ##class(CIS.AN.BL.DaySurgeryStatistics).GetFirstTitle("month","2018-04","2022-04","Decline")
/// w ##class(CIS.AN.BL.DaySurgeryStatistics).GetFirstTitle("season","2021-03","2021-04","DeclineReason")
/// w ##class(CIS.AN.BL.DaySurgeryStatistics).GetFirstTitle("year","2018","2022","DeclineReason")
/// 一级标题
ClassMethod GetFirstTitle(type, date1, date2, code, sort As %String = "1") As %String
{
	if (type="year")
	{
		q:(date2-date1>3.01)&(type="year") "列数超出限制，最多可查询4年数据"
	}
	if (type="month")
	{
		s year1=$p(date1,"-",1)
		s month1=$p(date1,"-",2)
		s year2=$p(date2,"-",1)
		s month2=$p(date1,"-",2)
		s yearnum=year2-year1
		q:yearnum>3.01 "列数超出限制，最多可查询3年数据"
		s monthnum=yearnum*12+month2-month1
		q:monthnum>36.01 "列数超出限制，最多可查询3年数据"
	}
	b	;?
	if (type="season")
	{
		s year1=$p(date1,"-",1)
		s season1=$p(date1,"-",2)
		s year2=$p(date2,"-",1)
		s season2=$p(date1,"-",2)
		s yearnum=year2-year1
		q:(yearnum>3.01) "列数超出限制，最多可查询3年数据"
		s seasonnum=yearnum*4+season1-season2
		q:(seasonnum>12.01) "列数超出限制，最多可查询3年数据"
	}

	i type="month" d
		.s newDate1=+##class(CIS.AN.COM.DateTime).ConvertToDateH(date1_"-"_"01","")
		.s month=$p(date2,"-",2)
		.s year2=$p(date2,"-",1)
		.s newMonth=month+1
		.i newMonth<10 s newMonth="0"_newMonth
		.i newMonth=13 s newMonth="01",year2=year2+1
		.s newDate2=year2_"-"_newMonth_"-01"
		.s newDate2=+##class(CIS.AN.COM.DateTime).ConvertToDateH(newDate2,"")-1
		.f date=newDate1:1:newDate2 d
			..s dateStr=$zd(date,3)
			..s year=$p(dateStr,"-",1)
			..s month=$p(dateStr,"-",2)
			..i code="Decline" d
				...set columnArr(year_""_month,"colspan")=2
				...set columnArr(year_""_month,"title")=year_""_month
				...set columnArr(1,"title")="科室",columnArr(1,"field")="Field1",columnArr(1,"rowspan")=2
			..e  i code="DeclineReason" d
				...set columnArr(year_""_month,"colspan")=2
				...set columnArr(year_""_month,"title")=year_""_month
				...set columnArr(1,"title")="退出原因",columnArr(1,"field")="Field1",columnArr(1,"rowspan")=2
			..e  i code="DayDecline" d
				...set columnArr(year_""_month,"colspan")=2
				...set columnArr(year_""_month,"title")=year_""_month
				...set columnArr(1,"title")="科室",columnArr(1,"field")="Field1",columnArr(1,"rowspan")=2
			..e  i code="DelayOut" d
				...set columnArr(year_""_month,"colspan")=2
				...set columnArr(year_""_month,"title")=year_""_month
				...set columnArr(1,"title")="科室",columnArr(1,"field")="Field1",columnArr(1,"rowspan")=2

			..e  d
				...set columnArr(year_""_month,"field")="Field"_year_"."_month
				...set columnArr(year_""_month,"title")=year_"/"_month

			
	i type="season" d
		.s YearS=$p(date1,"-",1)
		.s MonthS=$p(date1,"-",2)
		.s YearE=$p(date2,"-",1)
		.s MonthE=$p(date2,"-",2)
		.i MonthS="01" s newDateStr1=YearS_"-"_"01"_"-01"
		.i MonthS="02" s newDateStr1=YearS_"-"_"04"_"-01"
		.i MonthS="03" s newDateStr1=YearS_"-"_"07"_"-01"
		.i MonthS="04" s newDateStr1=YearS_"-"_"10"_"-01"
		.i MonthE="01" s newDateStr2=YearE_"-"_"03"_"-31"
		.i MonthE="02" s newDateStr2=YearE_"-"_"06"_"-30"
		.i MonthE="03" s newDateStr2=YearE_"-"_"09"_"-30"
		.i MonthE="04" s newDateStr2=YearE_"-"_"12"_"-31"
		.s newDateS1=+##class(CIS.AN.COM.DateTime).ConvertToDateH(newDateStr1,"")
		.s newDateS2=+##class(CIS.AN.COM.DateTime).ConvertToDateH(newDateStr2,"")
		.f date=newDateS1:1:newDateS2 d
			..s dateStr=$zd(date,3)
			..s year=$p(dateStr,"-",1)
			..s month=$p(dateStr,"-",2)
			..i +month<4 s season="一季度",seasonCode=1
			..i (+month>3)&(+month<7) s season="二季度",seasonCode=2
			..i (+month>6)&(+month<10) s season="三季度",seasonCode=3
			..i +month>9 s season="四季度",seasonCode=4
			..i code="Decline" d
				...set columnArr(year_""_seasonCode,"colspan")=2
				...set columnArr(year_""_seasonCode,"title")=year_"/"_season
				...set columnArr(1,"title")="科室",columnArr(1,"field")="Field1",columnArr(1,"rowspan")=2
			..e  i code="DeclineReason" d
				...set columnArr(year_""_seasonCode,"colspan")=2
				...set columnArr(year_""_seasonCode,"title")=year_"/"_season
				...set columnArr(1,"title")="退出原因",columnArr(1,"field")="Field1",columnArr(1,"rowspan")=2
			..e  i code="DayDecline" d
				...set columnArr(year_""_seasonCode,"colspan")=2
				...set columnArr(year_""_seasonCode,"title")=year_"/"_season
				...set columnArr(1,"title")="科室",columnArr(1,"field")="Field1",columnArr(1,"rowspan")=2
			..e  i code="DelayOut" d
				...set columnArr(year_""_seasonCode,"colspan")=2
				...set columnArr(year_""_seasonCode,"title")=year_"/"_season
				...set columnArr(1,"title")="科室",columnArr(1,"field")="Field1",columnArr(1,"rowspan")=2
			
			..e   d
				...set columnArr(year_""_seasonCode,"field")="Field"_year_"/"_seasonCode
				...set columnArr(year_""_seasonCode,"title")=year_""_season

	
	
	i type="year" d
		.f date=date1:1:(date2) d
			..i code="Decline" d
				...set columnArr(1,"title")="科室",columnArr(1,"field")="Field1",columnArr(1,"rowspan")=2
				...set columnArr(date,"colspan")=2
				...set columnArr(date,"title")=date
			..e  i code="DeclineReason" d
				...set columnArr(date,"colspan")=2
				...set columnArr(date,"title")=date
				...set columnArr(1,"title")="退出原因",columnArr(1,"field")="Field1",columnArr(1,"rowspan")=2
			..e  i code="DayDecline" d
				...set columnArr(1,"title")="科室",columnArr(1,"field")="Field1",columnArr(1,"rowspan")=2
				...set columnArr(date,"colspan")=2
				...set columnArr(date,"title")=date
			..e  i code="DelayOut" d
				...set columnArr(1,"title")="科室",columnArr(1,"field")="Field1",columnArr(1,"rowspan")=2
				...set columnArr(date,"colspan")=2
				...set columnArr(date,"title")=date

			..e  d
				...set columnArr(date,"field")="Field"_date
				...set columnArr(date,"title")=date_"年"
				...set columnArr(date,"width")=100

	set result=##class(CIS.AN.COM.String).ToJson(.columnArr)
	q result
}

/// w ##class(CIS.AN.BL.DaySurgeryStatistics).GetSubTitle("month","2021-10","2021-11","Decline")
/// w ##class(CIS.AN.BL.DaySurgeryStatistics).GetSubTitle("season","2021-03","2021-04","DeclineReason")
/// 二级标题
ClassMethod GetSubTitle(type, date1, date2, code) As %String
{
	if (type="year")
	{
		q:(date2-date1>5)&(type="year") "列数超出限制"
	}
	i type="month" d
		.s newDate1=+##class(CIS.AN.COM.DateTime).ConvertToDateH(date1_"-"_"01","")
		.s month=$p(date2,"-",2)
		.s year2=$p(date2,"-",1)
		.s newMonth=month+1
		.i newMonth<10 s newMonth="0"_newMonth
		.i newMonth=13 s newMonth="01",year2=year2+1
		.s newDate2=year2_"-"_newMonth_"-01"
		.s newDate2=+##class(CIS.AN.COM.DateTime).ConvertToDateH(newDate2,"")-1
		.f date=newDate1:1:newDate2 d
			..s dateStr=$zd(date,3)
			..s year=$p(dateStr,"-",1)
			..s month=$p(dateStr,"-",2)
			..i code="Decline" d
			...set columnArr(year_""_month_".1","field")="Field"_year_"."_month_".Num"
			...set columnArr(year_""_month_".1","title")="例数"
			...set columnArr(year_""_month_".2","field")="Field"_year_"."_month_".Per"
			...set columnArr(year_""_month_".2","title")="比例"
			..e  d
			...set columnArr(year_""_month_".1","field")="Field"_year_"."_month_".Num"
			...set columnArr(year_""_month_".1","title")="例数"
			...set columnArr(year_""_month_".2","field")="Field"_year_"."_month_".Per"
			...set columnArr(year_""_month_".2","title")="比例"


	i type="season" d
		.s YearS=$p(date1,"-",1)
		.s MonthS=$p(date1,"-",2)
		.s YearE=$p(date2,"-",1)
		.s MonthE=$p(date2,"-",2)
		.i MonthS="01" s newDateStr1=YearS_"-"_"01"_"-01"
		.i MonthS="02" s newDateStr1=YearS_"-"_"04"_"-01"
		.i MonthS="03" s newDateStr1=YearS_"-"_"07"_"-01"
		.i MonthS="04" s newDateStr1=YearS_"-"_"10"_"-01"
		.i MonthE="01" s newDateStr2=YearE_"-"_"03"_"-31"
		.i MonthE="02" s newDateStr2=YearE_"-"_"06"_"-30"
		.i MonthE="03" s newDateStr2=YearE_"-"_"09"_"-30"
		.i MonthE="04" s newDateStr2=YearE_"-"_"12"_"-31"
		.s newDateS1=+##class(CIS.AN.COM.DateTime).ConvertToDateH(newDateStr1,"")
		.s newDateS2=+##class(CIS.AN.COM.DateTime).ConvertToDateH(newDateStr2,"")
		.f date=newDateS1:1:newDateS2 d
			..s dateStr=$zd(date,3)
			..s year=$p(dateStr,"-",1)
			..s month=$p(dateStr,"-",2)
			..i +month<4 s season="一季度",seasonCode=1
			..i (+month>3)&(+month<7) s season="二季度",seasonCode=2
			..i (+month>6)&(+month<10) s season="三季度",seasonCode=3
			..i +month>9 s season="四季度",seasonCode=4
			..i code="Decline" d
			...set columnArr(year_""_seasonCode_".1","field")="Field"_year_"."_seasonCode_".Num"
			...set columnArr(year_""_seasonCode_".1","title")="例数"
			...set columnArr(year_""_seasonCode_".2","field")="Field"_year_"."_seasonCode_".Per"
			...set columnArr(year_""_seasonCode_".2","title")="比例"
			..e  d
				...set columnArr(year_""_seasonCode_".1","field")="Field"_year_"."_seasonCode_".Num"
				...set columnArr(year_""_seasonCode_".1","title")="例数"
				...set columnArr(year_""_seasonCode_".2","field")="Field"_year_"."_seasonCode_".Per"
				...set columnArr(year_""_seasonCode_".2","title")="比例"

	
	
	i type="year" d
		.f date=date1:1:(date2) d
			..set columnArr(date_".1","field")="Field"_date_".Num"
			..set columnArr(date_".1","title")="例数"
			..set columnArr(date_".2","field")="Field"_date_".Per"
			..set columnArr(date_".2","title")="比例"

	set result=##class(CIS.AN.COM.String).ToJson(.columnArr)
	
	quit result
}

/// daydecline:当日退出率,Decline：退出率
/// w ##class(CIS.AN.BL.DaySurgeryStatistics).GetMultipleResult("year","2021","2022","","Decline")
/// w ##class(CIS.AN.BL.DaySurgeryStatistics).GetMultipleResult("month","2021-12","2021-12","内分泌科","Decline","")
/// w ##class(CIS.AN.BL.DaySurgeryStatistics).GetMultipleResult("season","2021-03","2021-04","","DayDecline")
ClassMethod GetMultipleResult(type As %String, date1 As %String = "", date2 As %String = "", appdept As %String = "", Strategy As %String, Status As %String = "") As %String
{
	s result="",operCount=0
	i type="year" d
		.s sdate=+##class(CIS.AN.COM.DateTime).ConvertToDateH(date1_"-01-01","")
		.s edate=+##class(CIS.AN.COM.DateTime).ConvertToDateH(date2_"-12-31","")
		.;s operCount=operCount+1
		.s result=..GetMultipleResByYear(sdate,edate,Strategy,appdept,Status)
	i type="month" d
		.s sdate=+##class(CIS.AN.COM.DateTime).ConvertToDateH(date1_"-01","")
		.s month=$p(date2,"-",2)
		.s year2=$p(date2,"-",1)
		.s newMonth=month+1
		.i newMonth<10 s newMonth="0"_newMonth
		.i newMonth=13 s newMonth="01"  s year2=year2+1
		.s newDate2=year2_"-"_newMonth_"-01"
		.s edate=+##class(CIS.AN.COM.DateTime).ConvertToDateH(newDate2,"")-1
		.s result=..GetMultipleResByMonth(sdate,edate,Strategy,appdept,Status)
	i type="season" d
		.s YearS=$p(date1,"-",1)
		.s MonthS=$p(date1,"-",2)
		.s YearE=$p(date2,"-",1)
		.s MonthE=$p(date2,"-",2)
		.i MonthS="01" s newDateStr1=YearS_"-"_"01"_"-01"
		.i MonthS="02" s newDateStr1=YearS_"-"_"04"_"-01"
		.i MonthS="03" s newDateStr1=YearS_"-"_"07"_"-01"
		.i MonthS="04" s newDateStr1=YearS_"-"_"10"_"-01"
		.i MonthE="01" s newDateStr2=YearE_"-"_"03"_"-31"
		.i MonthE="02" s newDateStr2=YearE_"-"_"06"_"-30"
		.i MonthE="03" s newDateStr2=YearE_"-"_"09"_"-30"
		.i MonthE="04" s newDateStr2=YearE_"-"_"12"_"-31"
		.s sdate=+##class(CIS.AN.COM.DateTime).ConvertToDateH(newDateStr1,"")
		.s edate=+##class(CIS.AN.COM.DateTime).ConvertToDateH(newDateStr2,"")
		.s result=..GetMultipleResBySeason(sdate,edate,Strategy,appdept,Status)

	
	quit result
}

/// 按年统计，退出日间
/// w ##class(CIS.AN.BL.DaySurgeryStatistics).GetMultipleResByYear("66110","66444","Decline","","")
ClassMethod GetMultipleResByYear(sdate, edate, type, note As %String = "", Status As %String = "") As %String
{
	f date=sdate:1:edate d
	.s opsId=0
	.f  s opsId=$order(^CIS.AN.OperScheduleI("DateDaySurgery",date,"Y",opsId)) q:opsId=""  d
		..quit:(opsId="")
		..set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		..q:(operSchedule.PatDeptID="")&(operSchedule.AppDeptID="")
		..set statusCode=operSchedule.Status.Code
		..s opsDate=operSchedule.OperDate
		..;b
		..set operationNameStr="",surgeonNameList=""
		..s opId=0
		..f  s opId=$o(^CIS.AN.OperListI("IOPS",opsId,opId)) q:opId=""  d
			...s operListObj=##class(CIS.AN.OperList).%OpenId(opId)
			...s surgeonId=operListObj.Surgeon
			...q:+surgeonId=0
			...s surgeonDesc=$p(^CTPCP(surgeonId,1),"^",2)
			...s surgeonDept=operListObj.SurgeonDeptID
			...i surgeonDept="" s surgeonDept=operSchedule.AppDeptID
			...s surgeonDeptDesc=$p(^CTLOC(surgeonDept),"^",2)
			...q:((","_note_",")'[(","_surgeonDeptDesc_","))&(note'="")
			...s colDeptArr(surgeonDept)=surgeonDeptDesc
			...s SingleDeptArr(surgeonDept,opsDate,opsId_"."_opId)=statusCode
			...;通过手术列表的撤销
				...i (statusCode="Decline")!(statusCode="Cancel") d
					....s retDate=..GetCancelDateByOpsId(opsId,"CCL")
					....i retDate=opsDate d
						.....s DayDeclineArr(surgeonDept,opsDate,opsId_"."_opId)="手术列表拒绝"
					....

			...s DeclineFlag=$d(^CIS.AN.DaySurgeryDeclineI("IOPS",opsId))
			...i DeclineFlag>0 d
				....s declineId=$o(^CIS.AN.DaySurgeryDeclineI("IOPS",opsId,""),-1)
				....s declineDate=$lg(^CIS.AN.DaySurgeryDeclineD(declineId),5)
				....i declineDate=opsDate d
					.....s DayDeclineArr(surgeonDept,opsDate,opsId_"."_opId)=$g(^CIS.AN.DaySurgeryDeclineD(declineId))

	if (type="DayDecline")
	{
		//手术日期与退出日期相同的手术例数。
		//退出例数占时间段内各科室预约的日间手术比例。
		//按科室
		s locDr1=0,jsonStr="",locNum=0
		f  s locDr1=$o(SingleDeptArr(locDr1)) q:locDr1=""  d
			.s testDate=0
			.s locNum=locNum+1,locDateNum=0,yearNum=0
			.f  s testDate=$o(SingleDeptArr(locDr1,testDate)) q:testDate=""  d
				..s newShowDate=$zd(testDate,3)
				..s sYear=$p(newShowDate,"-",1)
				..s testOpsId=0,datenum="",nousenum="",sameCancelnum=""
				..f  s testOpsId=$o(SingleDeptArr(locDr1,testDate,testOpsId)) q:testOpsId=""  d
					...s datenum=datenum+1
					...s statcode=SingleDeptArr(locDr1,testDate,testOpsId)
					...s NewClassArrList(locDr1,"Field1")=colDeptArr(locDr1)
					...s dayDecStr=$g(DayDeclineArr(locDr1,testDate,testOpsId))
					...i dayDecStr'="" d
					....s sameCancelnum=sameCancelnum+1
				..;一年的某一天
				..set YearLocArr(locDr1,sYear,testDate)=datenum
				..set CancelYearLocArr(locDr1,sYear,testDate)=sameCancelnum
				..set YearOperArr(sYear,locDr1,testDate)=datenum
				..set CancelYearOperArr(sYear,locDr1,testDate)=sameCancelnum	
	;b	;1
	s year1=0 f  s year1=$o(YearOperArr(year1)) q:year1=""  d
			.s yearNum=0,cancelYearNum=""
			.s locdr2=0 f  s locdr2=$o(YearOperArr(year1,locdr2)) q:locdr2=""  d
				..s classNum=0,cancelnum=""
				..s date1=0 f  s date1=$o(YearOperArr(year1,locdr2,date1)) q:date1=""  d
					...s singleClassNum=$g(YearOperArr(year1,locdr2,date1))
					...s classNum=classNum+singleClassNum	
					...s numcancels=$g(CancelYearOperArr(year1,locdr2,date1))
					...s cancelnum=cancelnum+numcancels
				..s yearNum=yearNum+classNum	//
				..s cancelYearNum=cancelYearNum+cancelnum
				..s NewYearNumArr(locdr2,year1)=classNum	//科室一年多少
				..s NewYearCancelArr(locdr2,year1)=cancelnum
			.s testYearList(year1)=yearNum	//一年多少
			.s testYearCancelList(year1)=cancelYearNum
	;b	;2
		s locDr2=0
		f  s locDr2=$o(YearLocArr(locDr2)) q:locDr2=""  d
			.
			.s year2=0,classNum=0
			.f  s year2=$o(YearLocArr(locDr2,year2)) q:year2=""  d
				..s cancelNum=$g(NewYearCancelArr(locDr2,year2))
				..s allClassNum=$g(NewYearNumArr(locDr2,year2))
				..s persent=""
				..i allClassNum>0 s persent=$fn((cancelNum/allClassNum),"",4)*100_"%"
				..q:persent=""
				..s NewClassArrList(locDr2,"Field"_year2_".Per")=persent
				..s NewClassArrList(locDr2,"Field"_year2_".Num")=cancelNum
   				..s yearCanlNum1=testYearCancelList(year2)
   				..s yearNum1=testYearList(year2)
   				..s NewClassArrList("总计","Field1")="总计"
   				..s NewClassArrList("总计","Field"_year2_".Num")=yearCanlNum1
   				..i yearNum1>0 d
					...s persent=$fn((yearCanlNum1/yearNum1),"",4)*100_"%"
					...i +$fn((yearCanlNum1/yearNum1),"",4)=0 s persent=""
   				..s NewClassArrList("总计","Field"_year2_".Per")=persent

		;b	;3
		
		set JsonStr=##class(CIS.AN.COM.String).ToJson(.NewClassArrList)
		
	}

	elseif (type="Decline")
	{
		b	;?
		s locDr1=0,jsonStr="",locNum=0
		f  s locDr1=$o(SingleDeptArr(locDr1)) q:locDr1=""  d
			.s testDate=0
			.s locNum=locNum+1,locDateNum=0,yearNum=0
			.f  s testDate=$o(SingleDeptArr(locDr1,testDate)) q:testDate=""  d
				..s newShowDate=$zd(testDate,3)
				..s testOpsId=0,datenum="",nousenum=""
				..s locDateNum=locDateNum+1
				..f  s testOpsId=$o(SingleDeptArr(locDr1,testDate,testOpsId)) q:testOpsId=""  d
					...s datenum=datenum+1
					...s statcode=SingleDeptArr(locDr1,testDate,testOpsId)
					...s NewClassArrList(locDr1,"Field1")=colDeptArr(locDr1)
					...s DeclineFlag=$d(^CIS.AN.DaySurgeryDeclineI("IOPS",$p(testOpsId,".",1)))
					...i (statcode="Cancel")!(statcode="Decline")!(DeclineFlag>0) d
						....;b ;撤销或者拒绝的单独存储
						....s nousenum=nousenum+1
				..;一年的某一天
				..set YearLocArr(locDr1,$p(newShowDate,"-",1),testDate)=datenum
				..set CancelYearLocArr(locDr1,$p(newShowDate,"-",1),testDate)=nousenum
				..set YearOperArr($p(newShowDate,"-",1),locDr1,testDate)=datenum
				..set CancelYearOperArr($p(newShowDate,"-",1),locDr1,testDate)=nousenum	

	s year1=0 f  s year1=$o(YearOperArr(year1)) q:year1=""  d
			.s yearNum=0,cancelYearNum=""
			.s locdr2=0 f  s locdr2=$o(YearOperArr(year1,locdr2)) q:locdr2=""  d
				..s classNum=0,cancelnum=""
				..s date1=0 f  s date1=$o(YearOperArr(year1,locdr2,date1)) q:date1=""  d
					...s singleClassNum=$g(YearOperArr(year1,locdr2,date1))
					...s classNum=classNum+singleClassNum	
					...s numcancels=$g(CancelYearOperArr(year1,locdr2,date1))
					...s cancelnum=cancelnum+numcancels
				..s yearNum=yearNum+classNum	//
				..s cancelYearNum=cancelYearNum+cancelnum
				..s NewYearNumArr(locdr2,year1)=classNum	//科室一年多少
				..s NewYearCancelArr(locdr2,year1)=cancelnum
			.s testYearList(year1)=yearNum	//一年多少
			.s testYearCancelList(year1)=cancelYearNum

		s locDr2=0
		f  s locDr2=$o(YearLocArr(locDr2)) q:locDr2=""  d
			.
			.s year2=0,classNum=0
			.f  s year2=$o(YearLocArr(locDr2,year2)) q:year2=""  d
				..s cancelNum=$g(NewYearCancelArr(locDr2,year2))
				..s allClassNum=$g(NewYearNumArr(locDr2,year2))
				..s persent=""
				..i allClassNum>0 s persent=$fn((cancelNum/allClassNum),"",4)*100_"%"
   				..;new
   				..s yearCanlNum1=testYearCancelList(year2)
   				..s yearNum1=testYearList(year2)
   				..q:persent=""
				..s NewClassArrList(locDr2,"Field"_year2_".Num")=cancelNum
				..s NewClassArrList(locDr2,"Field"_year2_".Per")=persent
   				..s NewClassArrList("总计","Field1")="总计"
   				..s NewClassArrList("总计","Field"_year2_".Num")=yearCanlNum1
   				..i yearNum1>0 d
					...s persent=$fn((yearCanlNum1/yearNum1),"",4)*100_"%"
					...i +$fn((yearCanlNum1/yearNum1),"",4)=0 s persent=""
   				..s NewClassArrList("总计","Field"_year2_".Per")=persent

		
		
		set JsonStr=##class(CIS.AN.COM.String).ToJson(.NewClassArrList)
		
	}
	 //w JsonStr
	q JsonStr
}

/// w ##class(CIS.AN.BL.DaySurgeryStatistics).GetCancelDateByOpsId(984,"CCL")
ClassMethod GetCancelDateByOpsId(opsId, dataCode)
{
	s retDate=""
	&sql(select ActionDate into :retDate from CIS_AN.SurgicalProcedure where ProcedureCode=:dataCode)
	q retDate
}

/// 按月统计，退出日间
ClassMethod GetMultipleResByMonth(sdate, edate, type, note As %String = "", Status As %String = "") As %String
{
	k SingleDeptArr
	k DayDeclineArr
	f date=sdate:1:edate d
		.s opsId=0
		.f  s opsId=$order(^CIS.AN.OperScheduleI("DateDaySurgery",date,"Y",opsId)) q:opsId=""  d
			..quit:(opsId="")
			..set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			..q:(operSchedule.PatDeptID="")&(operSchedule.AppDeptID="")
			..set statusCode=operSchedule.Status.Code
			..s opsDate=operSchedule.OperDate
			..s newShowDate=$zd(opsDate,3)
			..s showYear=$p(newShowDate,"-",1)
			..s showMonth=$p(newShowDate,"-",2)
			..set operationNameStr="",surgeonNameList=""
			..s opId=0
			..f  s opId=$o(^CIS.AN.OperListI("IOPS",opsId,opId)) q:opId=""  d
				...s operListObj=##class(CIS.AN.OperList).%OpenId(opId)
				...s surgeonDept=operListObj.SurgeonDeptID
				...i surgeonDept="" s surgeonDept=operSchedule.AppDeptID
				...s surgeonDeptDesc=$p(^CTLOC(surgeonDept),"^",2)
				...q:((","_note_",")'[(","_surgeonDeptDesc_","))&(note'="")
				...;b	;&(type="Loc")
				...s colDeptArr(surgeonDept)=surgeonDeptDesc
				...;科室数组存储手术状态;当日退出
				...s SingleDeptArr(surgeonDept,opsDate,opsId_"."_opId)=statusCode
				...i (statusCode="Decline")!(statusCode="Cancel") d
					....s retDate=..GetCancelDateByOpsId(opsId,"CCL")
					....i retDate=opsDate d
						.....s DayDeclineArr(surgeonDept,opsDate,opsId_"."_opId)="手术列表拒绝"
						....
				...s DeclineFlag=$d(^CIS.AN.DaySurgeryDeclineI("IOPS",opsId))
				...i DeclineFlag>0 d
					....s declineId=$o(^CIS.AN.DaySurgeryDeclineI("IOPS",opsId,""),-1)
					....s declineDate=$lg(^CIS.AN.DaySurgeryDeclineD(declineId),5)
					....i declineDate=opsDate d
						.....s DayDeclineArr(surgeonDept,opsDate,opsId_"."_opId)=$g(^CIS.AN.DaySurgeryDeclineD(declineId))
				...
	if (type="DayDecline")
	{
		//手术日期与退出日期相同的手术例数。
		//退出例数占时间段内各科室预约的日间手术比例。
		//按科室
		s testLocId=0,jsonStr="",locNum=""
		f  s testLocId=$o(SingleDeptArr(testLocId)) q:testLocId=""  d
		.s testDate=0
		.s locNum=locNum+1,locDateNum="",yearNum=""
		.f  s testDate=$o(SingleDeptArr(testLocId,testDate)) q:testDate=""  d
			..s newShowDate=$zd(testDate,3)
			..s year1=$p(newShowDate,"-",1)
			..s month1=$p(newShowDate,"-",2)
			..s testOpsId=0,nousenum=""
			..s datenum=""	//每天多少手术
			..s sameCancelnum=""	//每天拒绝多少
			..f  s testOpsId=$o(SingleDeptArr(testLocId,testDate,testOpsId)) q:testOpsId=""  d
				...s datenum=datenum+1	
				...s dayDecStr=$g(DayDeclineArr(testLocId,testDate,testOpsId))
				...i dayDecStr'="" s sameCancelnum=sameCancelnum+1
			..;每日科室推出量
			..set DailyLocArr(testLocId,year1,month1,testDate)=datenum
			..set MonthListArr(year1,month1,testLocId,testDate)=datenum
			..;撤销或拒绝每天有多少
			..set MonthUnUseListArr(year1,month1,testLocId,testDate)=sameCancelnum
	
		///先算出一个月有多少
		s year1=0 
		f  s year1=$o(MonthListArr(year1)) q:year1=""  d
			.s OneYearNum="",OneCancelYearNum=""	;一年的数量
			.s month1=0 f  s month1=$o(MonthListArr(year1,month1)) q:month1=""  d
				..s oneMonthNum="",cancelNum=""	;每个月所有科室的
				..s loc1=0
				..f  s loc1=$o(MonthListArr(year1,month1,loc1)) q:loc1=""  d
					...s locMonthNum="",locCancelNum=""	;每个月单个科室数量
					...s date1=0 
					...f  s date1=$o(MonthListArr(year1,month1,loc1,date1)) q:date1=""  d
						....s value=MonthListArr(year1,month1,loc1,date1) ;一天的手术量
						....s locMonthNum=locMonthNum+value	//每个科室每月多少手术
						....s value2=MonthUnUseListArr(year1,month1,loc1,date1)
						....s locCancelNum=locCancelNum+value2
					...s oneMonthNum=oneMonthNum+locMonthNum //每个月所有科室多少手术
					...s cancelNum=cancelNum+locCancelNum	//每个月所有科室退出多少手术
					...s NewMonthNumArr(year1_"."_month1_"."_loc1)=locMonthNum	//单个科室退出
					...s NewMonthCancelNumArr(year1_"."_month1_"."_loc1)=locCancelNum
				..s MonthNumArr(year1_"."_month1)=oneMonthNum
				..s MonthCancelNumArr(year1_"."_month1)=cancelNum
				..s OneYearNum=OneYearNum+oneMonthNum
				..s OneCancelYearNum=OneCancelYearNum+cancelNum	
			.s NewYearNumArr(year1)=OneYearNum	//一年的退出量
			.s NewYearCancelNumArr(year1)=OneCancelYearNum
			
	
	s locId=0,num=0,locShowNum=""
	f  s locId=$o(DailyLocArr(locId)) q:locId=""  d
		.s showYear=0
		.f  s showYear=$o(DailyLocArr(locId,showYear)) q:showYear=""  d
			..s showMonth=0,yearOperNum=""
			..f  s showMonth=$o(DailyLocArr(locId,showYear,showMonth)) q:showMonth=""  d
				...;科室一个月多少
				...s locmonth1=NewMonthNumArr(showYear_"."_showMonth_"."_locId)
				...s locCancelmonth1=NewMonthCancelNumArr(showYear_"."_showMonth_"."_locId)
				...;所有科室一个月
				...s month1=MonthNumArr(showYear_"."_showMonth)
				...
				...s monthcancel1=MonthCancelNumArr(showYear_"."_showMonth)
				...s persent=""
				...i +locCancelmonth1=0 s locCancelmonth1="",persent=""
				...i locmonth1>0 d
					....s persent=$fn((locCancelmonth1/locmonth1),"",4)*100_"%"
					....i +$fn((locCancelmonth1/locmonth1),"",4)=0 s persent=""
				...q:+persent=0
				...s NewLocArrShow(locId,"Field1")=colDeptArr(locId)
				...s NewLocArrShow("总计","Field1")="总计"

				...s NewLocArrShow(locId,"Field"_showYear_"."_showMonth_".Num")=locCancelmonth1
   				...s NewLocArrShow(locId,"Field"_showYear_"."_showMonth_".Per")=persent
   				...s NewLocArrShow("总计","Field"_showYear_"."_showMonth_".Num")=monthcancel1
   				...i month1>0 d
					....s persent=$fn((monthcancel1/month1),"",4)*100_"%"
					....i +$fn((monthcancel1/month1),"",4)=0 s persent=""
   				...s NewLocArrShow("总计","Field"_showYear_"."_showMonth_".Per")=persent
	
	set JsonStr=##class(CIS.AN.COM.String).ToJson(.NewLocArrShow)
	}
	elseif (type="Decline")
	{
		//日间退出率：退出例数占时间段内各科室预约的日间手术比例
		//各科退出的例数/各科总申请例数
		//按科室
		s testLocId=0,jsonStr="",locNum=""
		f  s testLocId=$o(SingleDeptArr(testLocId)) q:testLocId=""  d
		.s testDate=0
		.s locNum=locNum+1,locDateNum="",yearNum=""
		.f  s testDate=$o(SingleDeptArr(testLocId,testDate)) q:testDate=""  d
			..s newShowDate=$zd(testDate,3)
			..s testOpsId=0,datenum="",nousenum=""
			..f  s testOpsId=$o(SingleDeptArr(testLocId,testDate,testOpsId)) q:testOpsId=""  d
				...s datenum=datenum+1	;某一日期下有多少
				...s operStat=""
				...s operStat=$g(SingleDeptArr(testLocId,testDate,testOpsId))
				...s DeclineFlag=$d(^CIS.AN.DaySurgeryDeclineI("IOPS",$p(testOpsId,".",1)))
				...i (operStat="Cancel")!(operStat="Decline")!(DeclineFlag>0) d
					....;b ;撤销或者拒绝的单独存储
					....s nousenum=nousenum+1
					....
			..s locDateNum=locDateNum+datenum	;某一科室下有多少
			..;
			..s years=$p(newShowDate,"-",1),months=$p(newShowDate,"-",2)
			..set colLocArr(testLocId,years,months,testDate)=datenum
			..;
			..set MonthListArr(years,months,testLocId,testDate)=datenum
			..;撤销或拒绝每天有多少
			..set MonthUnUseListArr(years,months,testLocId,testDate)=nousenum
	
		///先算出一个月有多少
		s year1=0 f  s year1=$o(MonthListArr(year1)) q:year1=""  d
			.s OneYearNum="",OneCancelYearNum=""	;一年的数量
			.s month1=0 f  s month1=$o(MonthListArr(year1,month1)) q:month1=""  d
				..s oneMonthNum="",cancelNum=""	;每个月所有科室的
				..s loc1=0
				..f  s loc1=$o(MonthListArr(year1,month1,loc1)) q:loc1=""  d
					...s locMonthNum="",locCancelNum=""	;每个月单个科室数量
					...s date1=0 
					...f  s date1=$o(MonthListArr(year1,month1,loc1,date1)) q:date1=""  d
						....s value=MonthListArr(year1,month1,loc1,date1) ;一天的手术量
						....s locMonthNum=locMonthNum+value	//每个科室每月多少手术
						....s value2=MonthUnUseListArr(year1,month1,loc1,date1)
						....s locCancelNum=locCancelNum+value2
					...s oneMonthNum=oneMonthNum+locMonthNum	//每个月所有科室多少手术
					...s cancelNum=cancelNum+locCancelNum
					...s NewMonthNumArr(year1_"."_month1_"."_loc1)=locMonthNum
					...s NewMonthCancelNumArr(year1_"."_month1_"."_loc1)=locCancelNum
				..s MonthNumArr(year1_"."_month1)=oneMonthNum
				..s MonthCancelNumArr(year1_"."_month1)=cancelNum
				..s OneYearNum=OneYearNum+oneMonthNum
				..s OneCancelYearNum=OneCancelYearNum+cancelNum	
			.s NewYearNumArr(year1)=OneYearNum
			.s NewYearCancelNumArr(year1)=OneCancelYearNum
	
	s locId=0,num=0,locShowNum=""
	f  s locId=$o(colLocArr(locId)) q:locId=""  d
		.
		.s showYear=0
		.f  s showYear=$o(colLocArr(locId,showYear)) q:showYear=""  d
			..s showMonth=0,yearOperNum=""
			..f  s showMonth=$o(colLocArr(locId,showYear,showMonth)) q:showMonth=""  d
				...;单个科室一个月多少
				...s locmonth1=NewMonthNumArr(showYear_"."_showMonth_"."_locId)
				...
				...s locCancelmonth1=NewMonthCancelNumArr(showYear_"."_showMonth_"."_locId)
				...;所有科室一个月
				...s month1=MonthNumArr(showYear_"."_showMonth)
				...
				...s monthcancel1=MonthCancelNumArr(showYear_"."_showMonth)
				...b	;?
				...s persent=""
				...i +locCancelmonth1=0 s locCancelmonth1="",persent=""
				...i locmonth1>0 d
					....s persent=$fn((locCancelmonth1/locmonth1),"",4)*100_"%"
					....i +$fn((locCancelmonth1/locmonth1),"",4)=0 s persent=""
				...q:persent=""
				...s NewLocArr(locId,"Field1")=colDeptArr(locId)
				...s NewLocArr(locId,"Field"_showYear_"."_showMonth_".Num")=locCancelmonth1
   				...s NewLocArr(locId,"Field"_showYear_"."_showMonth_".Per")=persent
   				...s NewLocArr("总计","Field1")="总计"
   				...s NewLocArr("总计","Field"_showYear_"."_showMonth_".Num")=monthcancel1
   				...i month1>0 d
					....s persent=$fn((monthcancel1/month1),"",4)*100_"%"
					....i +$fn((monthcancel1/month1),"",4)=0 s persent=""
   				...s NewLocArr("总计","Field"_showYear_"."_showMonth_".Per")=persent

	set JsonStr=##class(CIS.AN.COM.String).ToJson(.NewLocArr)
	}


	q JsonStr
}

/// 多标题
ClassMethod GetMultipleResBySeason(sdate, edate, type, note As %String = "", Status As %String = "") As %String
{
	f date=sdate:1:edate d
		.s opsId=0
		.f  s opsId=$order(^CIS.AN.OperScheduleI("DateDaySurgery",date,"Y",opsId)) q:opsId=""  d
			..quit:(opsId="")
			..set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			..q:(operSchedule.PatDeptID="")&(operSchedule.AppDeptID="")
			..set statusCode=operSchedule.Status.Code
			..s opsDate=operSchedule.OperDate
			..set operationNameStr="",surgeonNameList=""
			..s opId=0
			..f  s opId=$o(^CIS.AN.OperListI("IOPS",opsId,opId)) q:opId=""  d
				...s operListObj=##class(CIS.AN.OperList).%OpenId(opId)
				...s surgeonId=operListObj.Surgeon
				...q:+surgeonId=0
				...s surgeonDept=operListObj.SurgeonDeptID
				...i surgeonDept="" s surgeonDept=operSchedule.AppDeptID
				...s surgeonDeptDesc=$p(^CTLOC(surgeonDept),"^",2)
				...q:(note'[surgeonDeptDesc)&(note'="")
				...s colDeptArr(surgeonDept)=surgeonDeptDesc
				...s SingleDeptArr(surgeonDept,opsDate,opsId_"."_opId)=statusCode
				...;通过手术列表的撤销，当日
				...i (statusCode="Decline")!(statusCode="Cancel") d
					....s retDate=..GetCancelDateByOpsId(opsId,"CCL")
					....i retDate=opsDate d
						.....s DayDeclineArr(surgeonDept,opsDate,opsId_"."_opId)="手术列表拒绝"
					....

				...s DeclineFlag=$d(^CIS.AN.DaySurgeryDeclineI("IOPS",opsId))
				...i DeclineFlag>0 d
					....s declineId=$o(^CIS.AN.DaySurgeryDeclineI("IOPS",opsId,""),-1)
					....s declineDate=$lg(^CIS.AN.DaySurgeryDeclineD(declineId),5)
					....i declineDate=opsDate d
						.....s DayDeclineArr(surgeonDept,opsDate,opsId_"."_opId)=$g(^CIS.AN.DaySurgeryDeclineD(declineId))

	if (type="DayDecline")
	{
		//手术日期与退出日期相同的手术例数。
		//退出例数占时间段内各科室预约的日间手术比例。
		//按科室
		s locdr1=0,jsonStr="",locNum=0
		f  s locdr1=$o(SingleDeptArr(locdr1)) q:locdr1=""  d
			.s testDate=0
			.s locNum=locNum+1,locDateNum=0,yearNum=0
			.f  s testDate=$o(SingleDeptArr(locdr1,testDate)) q:testDate=""  d
				..s newShowDate=$zd(testDate,3)
				..s YearShow=$p(newShowDate,"-",1)
				..s MonthShow=$p(newShowDate,"-",2)
				..i +MonthShow<4 s season="一季度",seasonCode=1
				..i (+MonthShow>3)&(+MonthShow<7) s season="二季度",seasonCode=2
				..i (+MonthShow>6)&(+MonthShow<10) s season="三季度",seasonCode=3
				..i +MonthShow>9 s season="四季度",seasonCode=4
				..s testOpsId=0,datenum="",nousenum="",sameCancelnum=""
				..s locDateNum=locDateNum+1
				..f  s testOpsId=$o(SingleDeptArr(locdr1,testDate,testOpsId)) q:testOpsId=""  d
					...s datenum=datenum+1
					...s operStat=""
					...s dayDecStr=$g(DayDeclineArr(locdr1,testDate,testOpsId))
					...i dayDecStr'="" s sameCancelnum=sameCancelnum+1
					...s NewClassArrList(locdr1,"Field1")=colDeptArr(locdr1)
				..set ClassArrList(locdr1,YearShow,seasonCode,MonthShow,testDate)=datenum
				..set CancelList(locdr1,YearShow,seasonCode,MonthShow,testDate)=sameCancelnum
				..set SeasonClassList(YearShow,seasonCode,locdr1,MonthShow,testDate)=datenum
		
		s year1=0 f  s year1=$o(SeasonClassList(year1)) q:year1=""  d
			.s seasonNum=0
			.s season1=0 f  s season1=$o(SeasonClassList(year1,season1)) q:season1=""  d
				..s seasonNum=0,seasonCancelNum=0
				..s loc1=0 f  s loc1=$o(SeasonClassList(year1,season1,loc1)) q:loc1=""  d
					...s monthNum=0,monthCancelnum=0	;每月的手术数量
					...s month1=0 
					...f  s month1=$o(SeasonClassList(year1,season1,loc1,month1)) q:month1=""  d
						....s singleClassNum=0,cancelnumm=0	;单个级别的数量
						....s date1=0 
						....f  s date1=$o(SeasonClassList(year1,season1,loc1,month1,date1)) q:date1=""  d
							.....s value=SeasonClassList(year1,season1,loc1,month1,date1)	//一天的手术量
							.....s singleClassNum=singleClassNum+value
							.....s cancelValue=CancelList(loc1,year1,season1,month1,date1)
							.....s cancelnumm=cancelnumm+cancelValue
						....s monthNum=monthNum+singleClassNum	//每月多少手术
						....s monthCancelnum=monthCancelnum+cancelnumm
					...s SeasonCancelArr(year1_"."_season1_"."_loc1)=monthCancelnum
					...s NewSeasonNumArr(year1_"."_season1_"."_loc1)=monthNum
					...s seasonNum=seasonNum+monthNum	//每个季度多少手术
					...s seasonCancelNum=seasonCancelNum+monthCancelnum
				..s TotalSeasonNum(year1_"."_season1)=seasonNum
				..s TotalSeasonCancelNum(year1_"."_season1)=seasonCancelNum



		s locDr2=0,allnum=0
		f  s locDr2=$o(ClassArrList(locDr2)) q:locDr2=""  d
			.s year2=0
			.f  s year2=$o(ClassArrList(locDr2,year2)) q:year2=""  d
				..s season2=0 ,yearNum=""
				..f  s season2=$o(ClassArrList(locDr2,year2,season2)) q:season2=""  d
					...;dateNum：每个月多少；monthNum:一个季度多少;SeasonNum:
					...s cancelNum2=SeasonCancelArr(year2_"."_season2_"."_locDr2)
					...s allClassNum=$g(NewSeasonNumArr(year2_"."_season2_"."_locDr2))
					...i +cancelNum2=0 s cancelNum2=""
					...s persent=""
					...i allClassNum>0 d
					....s persent=$fn((cancelNum2/allClassNum),"",4)*100_"%"
			   		....i +$fn((cancelNum2/allClassNum),"",4)=0 s persent=""
					...q:persent=""
					...s NewClassArrList(locDr2,"Field"_year2_"."_season2_".Num")=cancelNum2
			   		...s NewClassArrList(locDr2,"Field"_year2_"."_season2_".Per")=persent
   					...s seasonCancel1=TotalSeasonCancelNum(year2_"."_season2)
   					...s seasonAll1=TotalSeasonNum(year2_"."_season2)
   					...s NewClassArrList("总计","Field1")="总计"
   					...s NewClassArrList("总计","Field"_year2_"."_season2_".Num")=seasonCancel1
   					...i seasonAll1>0 d
						....s persent=$fn((seasonCancel1/seasonAll1),"",4)*100_"%"
						....i +$fn((seasonCancel1/seasonAll1),"",4)=0 s persent=""
   					...s NewClassArrList("总计","Field"_year2_"."_season2_".Per")=persent

	set JsonStr=##class(CIS.AN.COM.String).ToJson(.NewClassArrList)
	}

	elseif (type="Decline")
	{
		//日间退出率：退出例数占时间段内各科室预约的日间手术比例
		//各科退出的例数/各科总申请例数
		//按科室
		s locdr1=0,jsonStr="",locNum=0
		f  s locdr1=$o(SingleDeptArr(locdr1)) q:locdr1=""  d
			.s testDate=0
			.s locNum=locNum+1,locDateNum=0,yearNum=0
			.f  s testDate=$o(SingleDeptArr(locdr1,testDate)) q:testDate=""  d
				..s newShowDate=$zd(testDate,3)
				..s YearShow=$p(newShowDate,"-",1)
				..s MonthShow=$p(newShowDate,"-",2)
				..i +MonthShow<4 s season="一季度",seasonCode=1
				..i (+MonthShow>3)&(+MonthShow<7) s season="二季度",seasonCode=2
				..i (+MonthShow>6)&(+MonthShow<10) s season="三季度",seasonCode=3
				..i +MonthShow>9 s season="四季度",seasonCode=4
				..s testOpsId=0,datenum="",nousenum=""
				..s locDateNum=locDateNum+1
				..f  s testOpsId=$o(SingleDeptArr(locdr1,testDate,testOpsId)) q:testOpsId=""  d
					...s datenum=datenum+1
					...s operStat=""
					...s operStat=$g(SingleDeptArr(locdr1,testDate,testOpsId))
				...s DeclineFlag=$d(^CIS.AN.DaySurgeryDeclineI("IOPS",$p(testOpsId,".",1)))
				...i (operStat="Cancel")!(operStat="Decline")!(DeclineFlag>0) d
						....;b ;撤销或者拒绝的单独存储
						....s nousenum=nousenum+1
						....
					...s NewClassArrList(locdr1,"Field1")=colDeptArr(locdr1)
				..set ClassArrList(locdr1,YearShow,seasonCode,MonthShow,testDate)=datenum
				..set CancelList(locdr1,YearShow,seasonCode,MonthShow,testDate)=nousenum
				..set SeasonClassList(YearShow,seasonCode,locdr1,MonthShow,testDate)=datenum
		s year1=0 f  s year1=$o(SeasonClassList(year1)) q:year1=""  d
			.s seasonNum=0
			.s season1=0 f  s season1=$o(SeasonClassList(year1,season1)) q:season1=""  d
				..s seasonNum=0,seasonCancelNum=0
				..s loc1=0 f  s loc1=$o(SeasonClassList(year1,season1,loc1)) q:loc1=""  d
					...s monthNum=0,monthCancelnum=0	;每月的手术数量
					...s month1=0 
					...f  s month1=$o(SeasonClassList(year1,season1,loc1,month1)) q:month1=""  d
						....s singleClassNum=0,cancelnumm=0	;单个级别的数量
						....s date1=0 
						....f  s date1=$o(SeasonClassList(year1,season1,loc1,month1,date1)) q:date1=""  d
							.....s value=SeasonClassList(year1,season1,loc1,month1,date1)	//一天的手术量
							.....s singleClassNum=singleClassNum+value
							.....s cancelValue=CancelList(loc1,year1,season1,month1,date1)
							.....s cancelnumm=cancelnumm+cancelValue
						....s monthNum=monthNum+singleClassNum	//每月多少手术
						....s monthCancelnum=monthCancelnum+cancelnumm
					...s SeasonCancelArr(year1_"."_season1_"."_loc1)=monthCancelnum
					...s NewSeasonNumArr(year1_"."_season1_"."_loc1)=monthNum
					...s seasonNum=seasonNum+monthNum	//每个季度多少手术
					...s seasonCancelNum=seasonCancelNum+monthCancelnum
				..s TotalSeasonNum(year1_"."_season1)=seasonNum
				..s TotalSeasonCancelNum(year1_"."_season1)=seasonCancelNum



		s locDr2=0,allnum=0
		f  s locDr2=$o(ClassArrList(locDr2)) q:locDr2=""  d
			.s year2=0
			.f  s year2=$o(ClassArrList(locDr2,year2)) q:year2=""  d
				..s season2=0 ,yearNum=""
				..f  s season2=$o(ClassArrList(locDr2,year2,season2)) q:season2=""  d
					...;dateNum：每个月多少；monthNum:一个季度多少;SeasonNum:
					...s cancelNum2=SeasonCancelArr(year2_"."_season2_"."_locDr2)
					...s allClassNum=$g(NewSeasonNumArr(year2_"."_season2_"."_locDr2))
					...i +cancelNum2=0 s cancelNum2=""
					...s persent=""
					...i allClassNum>0 d
						....s persent=$fn((cancelNum2/allClassNum),"",4)*100_"%"
				   		....i +$fn((cancelNum2/allClassNum),"",4)=0 s persent=""
					...q:persent=""
					...s NewClassArrList(locDr2,"Field"_year2_"."_season2_".Num")=cancelNum2
			   		...s NewClassArrList(locDr2,"Field"_year2_"."_season2_".Per")=persent
   				...s seasonCancel1=TotalSeasonCancelNum(year2_"."_season2)
   				...s seasonAll1=TotalSeasonNum(year2_"."_season2)
   				...s NewClassArrList("总计","Field1")="总计"
   				...s NewClassArrList("总计","Field"_year2_"."_season2_".Num")=seasonCancel1
   				...i seasonAll1>0 d
					....s persent=$fn((seasonCancel1/seasonAll1),"",4)*100_"%"
					....i +$fn((seasonCancel1/seasonAll1),"",4)=0 s persent=""
   				...s NewClassArrList("总计","Field"_year2_"."_season2_".Per")=persent



	set JsonStr=##class(CIS.AN.COM.String).ToJson(.NewClassArrList)
	}

	 //w JsonStr
	q JsonStr
}

/// 退出原因统计
/// w ##class(CIS.AN.BL.DaySurgeryStatistics).GetDeclineReasonRes("year","2021","2021","","DeclineReason","")
/// w ##class(CIS.AN.BL.DaySurgeryStatistics).GetDeclineReasonRes("month","2021-12","2021-12","","DeclineReason")
ClassMethod GetDeclineReasonRes(type As %String, date1 As %String = "", date2 As %String = "", appdept As %String = "", Strategy As %String, Status As %String = "") As %String
{
	s result="",operCount=0
	i type="year" d
		.s sdate=+##class(CIS.AN.COM.DateTime).ConvertToDateH(date1_"-01-01","")
		.s edate=+##class(CIS.AN.COM.DateTime).ConvertToDateH(date2_"-12-31","")
		.;s operCount=operCount+1
		.s result=..GetDeclineResByYear(sdate,edate,Strategy,appdept,Status)
	i type="month" d
		.s sdate=+##class(CIS.AN.COM.DateTime).ConvertToDateH(date1_"-01","")
		.s month=$p(date2,"-",2)
		.s year2=$p(date2,"-",1)
		.s newMonth=month+1
		.i newMonth<10 s newMonth="0"_newMonth
		.i newMonth=13 s newMonth="01"  s year2=year2+1
		.s newDate2=year2_"-"_newMonth_"-01"
		.s edate=+##class(CIS.AN.COM.DateTime).ConvertToDateH(newDate2,"")-1
		.s result=..GetDeclineResByMonth(sdate,edate,Strategy,appdept,Status)
	i type="season" d
		.s YearS=$p(date1,"-",1)
		.s MonthS=$p(date1,"-",2)
		.s YearE=$p(date2,"-",1)
		.s MonthE=$p(date2,"-",2)
		.i MonthS="01" s newDateStr1=YearS_"-"_"01"_"-01"
		.i MonthS="02" s newDateStr1=YearS_"-"_"04"_"-01"
		.i MonthS="03" s newDateStr1=YearS_"-"_"07"_"-01"
		.i MonthS="04" s newDateStr1=YearS_"-"_"10"_"-01"
		.i MonthE="01" s newDateStr2=YearE_"-"_"03"_"-31"
		.i MonthE="02" s newDateStr2=YearE_"-"_"06"_"-30"
		.i MonthE="03" s newDateStr2=YearE_"-"_"09"_"-30"
		.i MonthE="04" s newDateStr2=YearE_"-"_"12"_"-31"
		.s sdate=+##class(CIS.AN.COM.DateTime).ConvertToDateH(newDateStr1,"")
		.s edate=+##class(CIS.AN.COM.DateTime).ConvertToDateH(newDateStr2,"")
		.s result=..GetDeclineResBySeason(sdate,edate,Strategy,appdept,Status)

	
	quit result
}

ClassMethod GetDeclineResByYear(sdate, edate, type, note As %String = "", Status As %String = "") As %String
{
	f date=sdate:1:edate d
		.s opsId=0
		.f  s opsId=$order(^CIS.AN.OperScheduleI("DateDaySurgery",date,"Y",opsId)) q:opsId=""  d
			..quit:(opsId="")
			..set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			..q:(operSchedule.PatDeptID="")&(operSchedule.AppDeptID="")
			..set statusCode=operSchedule.Status.Code
			..s opsDate=operSchedule.OperDate
			..s DeclineFlag=$d(^CIS.AN.DaySurgeryDeclineI("IOPS",opsId))
			..i ((statusCode="Decline")!(statusCode="Cancel"))&('DeclineFlag) d
				...s retDate=..GetCancelDateByOpsId(opsId,"CCL")
				...s SingleDeclineArr("手术列表退出",opsDate,opsId_".1")="手术列表退出"
			..i DeclineFlag>0 d
				...s declineId=$o(^CIS.AN.DaySurgeryDeclineI("IOPS",opsId,""),-1)
				...s DeclineReasonStr=$lg(^CIS.AN.DaySurgeryDeclineD(declineId),3)
				...s decLen=$l(DeclineReasonStr,",")
				...f decNum=1:1:decLen d
					....s DeclineReason=$p(DeclineReasonStr,",",decNum)
					....q:DeclineReason=""
					....s SingleDeclineList(DeclineReason,opsDate,opsId_"."_decNum)=DeclineReason
					....

	if (type="DeclineReason")
	{
			///按手术级别
		s reason1=0,jsonStr=""
		f  s reason1=$o(SingleDeclineList(reason1)) q:reason1=""  d
		.s reaNum=0
		.s testDate=0
		.f  s testDate=$o(SingleDeclineList(reason1,testDate)) q:testDate=""  d
			..s newShowDate=$zd(testDate,3)
			..s YearShow=$p(newShowDate,"-",1)
			..s testOpsId=0,datenum="",nousenum=""
			..f  s testOpsId=$o(SingleDeclineList(reason1,testDate,testOpsId)) q:testOpsId=""  d
				...s datenum=datenum+1
			..s ListSeason(reason1,YearShow,testDate)=datenum
			..s ListYear(YearShow,reason1,testDate)=datenum

		s year2=""
		f  s year2=$o(ListYear(year2)) q:year2=""  d
			.s res2=0,cacelNum=0	;
			.;退出原因
			.f  s res2=$o(ListYear(year2,res2)) q:res2=""  d
				..s date2=0,YearNum=""	//单月单个退出原因多少
				..f  s date2=$o(ListYear(year2,res2,date2)) q:date2=""  d
					...s num=ListYear(year2,res2,date2)
					...s YearNum=YearNum+num
				..s cacelNum=cacelNum+YearNum	;每年多少
			.s SeasonResAll(year2)=cacelNum	
		//ListSeason(reason1,YearShow,season,MonthShow,testDate)=reaNum
		s cancel1=""
		f  s cancel1=$o(ListSeason(cancel1)) q:cancel1=""  d
			.s year1=0,cancelNum=""
			.f  s year1=$o(ListSeason(cancel1,year1)) q:year1=""  d
				..s date1=0,yearNum2=""
				..f  s date1=$o(ListSeason(cancel1,year1,date1)) q:date1=""  d
					...s numc=ListSeason(cancel1,year1,date1)
					...s yearNum2=yearNum2+numc
				..s cancelNum=cancelNum+yearNum2	;每个季度多少
				..;一个季度某个原因有多少
				..s ResSeason(cancel1,year1)=yearNum2	;每个季度多少
			.
		s res3=0,allnum=0
		f  s res3=$o(ListSeason(res3)) q:res3=""  d
			.s NewClassArrList(res3,"Field1")=res3
			.s year3=0
			.f  s year3=$o(ListSeason(res3,year3)) q:year3=""  d
				..s sJiNum3=$g(ResSeason(res3,year3))
				..s allNum=$g(SeasonResAll(year3))
				..i +sJiNum3=0 s sJiNum3=""
				..s NewClassArrList(res3,"Field"_year3_".Num")=sJiNum3
				..s persent=""
				..i allNum>0 d
					...s persent=$fn((sJiNum3/allNum),"",4)*100_"%"
			   		...i +$fn((sJiNum3/allNum),"",4)=0 s persent=""
			   	..s NewClassArrList(res3,"Field"_year3_".Per")=persent
			
		
		
		set JsonStr=##class(CIS.AN.COM.String).ToJson(.NewClassArrList)
		
	}
	 //w JsonStr
	q JsonStr
}

/// 退出原因按月统计
/// 
ClassMethod GetDeclineResByMonth(sdate, edate, type, note As %String = "", Status As %String = "") As %String
{
	f date=sdate:1:edate d
		.s opsId=0
		.f  s opsId=$order(^CIS.AN.OperScheduleI("DateDaySurgery",date,"Y",opsId)) q:opsId=""  d
			..quit:(opsId="")
			..set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			..q:(operSchedule.PatDeptID="")&(operSchedule.AppDeptID="")
			..set statusCode=operSchedule.Status.Code
			..q:(Status'="")&(statusCode']Status)
			..s opsDate=operSchedule.OperDate
			..s DeclineFlag=$d(^CIS.AN.DaySurgeryDeclineI("IOPS",opsId))
			..i ((statusCode="Decline")!(statusCode="Cancel"))&('DeclineFlag) d
				...s retDate=..GetCancelDateByOpsId(opsId,"CCL")
				...s SingleDeclineArr(opsDate,opsId)=$lb(opsDate,opsDate,"手术列表退出")
				...b
			...
			..i DeclineFlag>0 d
				...s declineId=$o(^CIS.AN.DaySurgeryDeclineI("IOPS",opsId,""),-1)
				...s SingleDeclineArr(opsDate,opsId)=$g(^CIS.AN.DaySurgeryDeclineD(declineId))
				
	b	;?
	if (type="DeclineReason")
	{
		//算出总计多少退出数
		//算出单个退出原因数
		//按科室
		s testDate=0,jsonStr="",allNum=""	;所有退出总数
		f  s testDate=$o(SingleDeclineArr(testDate)) q:testDate=""  d
			.s newShowDate=$zd(testDate,3)
			.s testOpsId=0,datenum="",nousenum=""
			.f  s testOpsId=$o(SingleDeclineArr(testDate,testOpsId)) q:testOpsId=""  d
				..s DeclineReasonStr=$lg(SingleDeclineArr(testDate,testOpsId),3)
				..s decLen=$l(DeclineReasonStr,",")
				..f decNum=1:1:decLen d
					...s DeclineReason=$p(DeclineReasonStr,",",decNum)
					...q:DeclineReason=""
					...s DeclineReasonList(DeclineReason,testDate,testOpsId_"."_decNum)=DeclineReason
		s reason1=""
		f  s reason1=$o(DeclineReasonList(reason1)) q:reason1=""  d
			.s date1="",reasonSingle1=""	;单个原因多少
			.f  s date1=$o(DeclineReasonList(reason1,date1)) q:date1=""  d
				..s dateStr1=$zd(date1,3)
				..s newDate1=$p(dateStr1,"-",1)
				..s newMonth1=$p(dateStr1,"-",2)
				..s rowId1="",num1=""	;单日下总计多少
				..f  s rowId1=$o(DeclineReasonList(reason1,date1,rowId1)) q:rowId1=""  d
					...s num1=num1+1
				..s reasonSingle1=reasonSingle1+num1
				..;每个月的每一天多少数据
				..set MonthListArr(newDate1,newMonth1,reason1,date1)=num1
				..set ReasonListArr(reason1,newDate1,newMonth1,date1)=num1
	
		///先算出一个月有多少
		s year1=0 f  s year1=$o(MonthListArr(year1)) q:year1=""  d
			.s OneYearNum="",OneCancelYearNum=""	;一年的数量
			.s month1=0 f  s month1=$o(MonthListArr(year1,month1)) q:month1=""  d
				..s oneMonthNum="",cancelNum=""	;每个月所有科室的
				..s res1=0
				..f  s res1=$o(MonthListArr(year1,month1,res1)) q:res1=""  d
					...s resMonthNum="",locCancelNum=""	;每个月单个数量
					...s date1=0 
					...f  s date1=$o(MonthListArr(year1,month1,res1,date1)) q:date1=""  d
						....s value=MonthListArr(year1,month1,res1,date1) ;一天的量
						....s resMonthNum=resMonthNum+value	//每个每月多少手术
					...s oneMonthNum=oneMonthNum+resMonthNum	//每个月所有多少手术
					...s NewMonthNumArr(year1_"."_month1_"."_res1)=resMonthNum
				..s MonthNumArr(year1_"."_month1)=oneMonthNum
				..s OneYearNum=OneYearNum+oneMonthNum
			.s NewYearNumArr(year1)=OneYearNum
			
	
	s reason2=0,num=0,locShowNum=""
	f  s reason2=$o(ReasonListArr(reason2)) q:reason2=""  d
		.s NewMonthArr(reason2,"Field1")=reason2
		.s showYear=0
		.f  s showYear=$o(ReasonListArr(reason2,showYear)) q:showYear=""  d
			..s showMonth=0,yearOperNum=""
			..f  s showMonth=$o(ReasonListArr(reason2,showYear,showMonth)) q:showMonth=""  d
				...;一个月多少
				...s locmonth1=$g(NewMonthNumArr(showYear_"."_showMonth_"."_reason2))
				...;所有一个月
				...s month1=$g(MonthNumArr(showYear_"."_showMonth))
				...s persent=""
				...i +month1=0 s month1="",persent=""
				...s NewMonthArr(reason2,"Field"_showYear_"."_showMonth_".Num")=locmonth1
				...i month1>0 d
					....s persent=$fn((locmonth1/month1),"",4)*100_"%"
					....i +$fn((locmonth1/month1),"",4)=0 s persent=""
   				...s NewMonthArr(reason2,"Field"_showYear_"."_showMonth_".Per")=persent

				
	set JsonStr=##class(CIS.AN.COM.String).ToJson(.NewMonthArr)
	}
	q JsonStr
}

/// 多标题
/// w ##class(CIS.AN.BL.DaySugeryStatistics).GetDeclineResBySeason("2021-12","2021-12")
ClassMethod GetDeclineResBySeason(sdate, edate, type, note As %String = "", Status As %String = "") As %String
{
	f date=sdate:1:edate d
		.s opsId=0
		.f  s opsId=$order(^CIS.AN.OperScheduleI("DateDaySurgery",date,"Y",opsId)) q:opsId=""  d
			..quit:(opsId="")
			..set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			..q:(operSchedule.PatDeptID="")&(operSchedule.AppDeptID="")
			..set statusCode=operSchedule.Status.Code
			..s opsDate=operSchedule.OperDate
			..i (statusCode="Decline")!(statusCode="Cancel") d
				...s retDate=..GetCancelDateByOpsId(opsId,"CCL")
				...s SingleDeclineArr("手术列表退出",opsDate,opsId_".1")="手术列表退出"

			..s DeclineFlag=$d(^CIS.AN.DaySurgeryDeclineI("IOPS",opsId))
			..i DeclineFlag>0 d
				...s declineId=$o(^CIS.AN.DaySurgeryDeclineI("IOPS",opsId,""),-1)
				...s DeclineReasonStr=$lg(^CIS.AN.DaySurgeryDeclineD(declineId),3)
				...s decLen=$l(DeclineReasonStr,",")
				...f decNum=1:1:decLen d
					....s DeclineReason=$p(DeclineReasonStr,",",decNum)
					....q:DeclineReason=""
					....s SingleDeclineList(DeclineReason,opsDate,opsId_"."_decNum)=DeclineReason
					....

	if (type="DeclineReason")
	{
		///按手术级别
		s reason1=0,jsonStr=""
		f  s reason1=$o(SingleDeclineList(reason1)) q:reason1=""  d
		.s reaNum=0
		.s testDate=0
		.f  s testDate=$o(SingleDeclineList(reason1,testDate)) q:testDate=""  d
			..s newShowDate=$zd(testDate,3)
			..s YearShow=$p(newShowDate,"-",1)
			..s MonthShow=$p(newShowDate,"-",2)
			..i +MonthShow<4 s season="一季度",seasonCode=1
			..i (+MonthShow>3)&(+MonthShow<7) s season="二季度",seasonCode=2
			..i (+MonthShow>6)&(+MonthShow<10) s season="三季度",seasonCode=3
			..i +MonthShow>9 s season="四季度",seasonCode=4
			..s testOpsId=0,datenum="",nousenum=""
			..f  s testOpsId=$o(SingleDeclineList(reason1,testDate,testOpsId)) q:testOpsId=""  d
				...s datenum=datenum+1
			..s reaNum=reaNum+datenum
			..s ListSeason(reason1,YearShow,seasonCode,MonthShow,testDate)=datenum
			..s ListYear(YearShow,seasonCode,MonthShow,reason1,testDate)=datenum

		s year2=""
		f  s year2=$o(ListYear(year2)) q:year2=""  d
			.s season2=0,yearNumS=""
			.f  s season2=$o(ListYear(year2,season2)) q:season2=""  d
				..s month2=0,seasonnum2=""
				..f  s month2=$o(ListYear(year2,season2,month2)) q:month2=""  d
					...s res2=0,monnum2=0	;
					...;退出原因
					...f  s res2=$o(ListYear(year2,season2,month2,res2)) q:res2=""  d
						....s date2=0,resonnum2=""	//单月单个退出原因多少
						....f  s date2=$o(ListYear(year2,season2,month2,res2,date2)) q:date2=""  d
							.....s num=ListYear(year2,season2,month2,res2,date2)
							.....s resonnum2=resonnum2+num
						....s monnum2=monnum2+resonnum2	;每月退出多少
					...s seasonnum2=seasonnum2+monnum2	;每个季度多少
					...;一个季度某个原因有多少
				..s SeasonResAll(year2_"."_season2)=seasonnum2	;每个季度多少
		//ListSeason(reason1,YearShow,season,MonthShow,testDate)=reaNum
		s cancel1=""
		f  s cancel1=$o(ListSeason(cancel1)) q:cancel1=""  d
			.s year1=0,yearNumS=""
			.f  s year1=$o(ListSeason(cancel1,year1)) q:year1=""  d
				..s season1=0,yearnum2=""
				..f  s season1=$o(ListSeason(cancel1,year1,season1)) q:season1=""  d
					...s month1=0,Jinum2=0	;
					...;退出原因
					...f  s month1=$o(ListSeason(cancel1,year1,season1,month1)) q:month1=""  d
						....s date1=0,resonnum2=""	//单月单个退出原因多少
						....f  s date1=$o(ListSeason(cancel1,year1,season1,month1,date1)) q:date1=""  d
							.....s numc=ListSeason(cancel1,year1,season1,month1,date1)
							.....s resonnum2=resonnum2+numc
						....s Jinum2=Jinum2+resonnum2	;每月退出多少
					...s yearnum2=yearnum2+Jinum2	;每个季度多少
					...;一个季度某个原因有多少
					...s ResSeason(cancel1,year1_"."_season1)=Jinum2	;每个季度多少
				..
		
		s res3=0,allnum=0
		f  s res3=$o(ListSeason(res3)) q:res3=""  d
			.s NewClassArrList(res3,"Field1")=res3
			.s year3=0
			.f  s year3=$o(ListSeason(res3,year3)) q:year3=""  d
				..s season3=0 ,yearNum=""
				..f  s season3=$o(ListSeason(res3,year3,season3)) q:season3=""  d
					...s sJiNum3=$g(ResSeason(res3,year3_"."_season3))
					...s allNum=$g(SeasonResAll(year3_"."_season3))
					...i +sJiNum3=0 s sJiNum3=""
					...s NewClassArrList(res3,"Field"_year3_"."_season3_".Num")=sJiNum3
					...s persent=""
					...i allNum>0 d
						....s persent=$fn((sJiNum3/allNum),"",4)*100_"%"
			   			....i +$fn((sJiNum3/allNum),"",4)=0 s persent=""
			   		...s NewClassArrList(res3,"Field"_year3_"."_season3_".Per")=persent

	set JsonStr=##class(CIS.AN.COM.String).ToJson(.NewClassArrList)
	}

	 //w JsonStr
	q JsonStr
}

/// w ##class(CIS.AN.BL.DaySurgeryStatistics).GetOperDetails("Field2021.12","内分泌科|四级手术","","Category")
/// w ##class(CIS.AN.BL.DaySurgeryStatistics).GetOperDetails("Field2021.12","头痛病","","Diag")
/// w ##class(CIS.AN.BL.DaySurgeryStatistics).GetOperDetails("Field2021.3","内分泌科","","Loc")
/// w ##class(CIS.AN.BL.DaySurgeryStatistics).GetOperDetails("Field2021.12.08","内分泌科","","Loc")
ClassMethod GetOperDetails(searchDateStr As %String, note As %String = "", Status As %String = "", type As %String)
{
	s start=$p(searchDateStr,"Field",2)
	if (type="Category")
	{
		s start1=$p(searchDateStr,"Field",2)
		s start2=$p(start1,"Num",1)
		s douLen=$l(start2,".")
		
		s newstart=""
		f dnum=1:1:douLen d
		.s singles=$p(start2,".",dnum)
		.q:singles=""
		.i newstart'="" s newstart=newstart_"."_singles
		.e  s newstart=singles
		s start=newstart
	}
	i $l(start,".")=1 d
		.s statDate=start_"-01-01"
		.s endDate=start_"-12-31"
		.s sdate=+##class(CIS.AN.COM.DateTime).ConvertToDateH(statDate,"")
		.s edate=+##class(CIS.AN.COM.DateTime).ConvertToDateH(endDate,"")
	i $l(start,".")=3 d
		.s year1=$p(start,".",1)
		.s month=$p(start,".",2)
		.s date=$p(start,".",3)
		.s newDateStr=year1_"-"_month_"-"_date
		.s sdate=+##class(CIS.AN.COM.DateTime).ConvertToDateH(newDateStr,"")
		.s edate=+##class(CIS.AN.COM.DateTime).ConvertToDateH(newDateStr,"")
	i $l(start,".")=2 d
		.s year1=$p(start,".",1)
		.s month=$p(start,".",2)
		.;b
		.i (month<5)&(month=+month) d
			.. ;季度
			..i +month=1 s statDate=year1_"-"_"01"_"-01",endDate=year1_"-"_"03"_"-31"
			..i +month=2 s statDate=year1_"-"_"04"_"-01",endDate=year1_"-"_"06"_"-30"
			..i +month=3 s statDate=year1_"-"_"07"_"-01",endDate=year1_"-"_"09"_"-30"
			..i +month=4 s statDate=year1_"-"_"10"_"-01",endDate=year1_"-"_"12"_"-31"
			..s sdate=+##class(CIS.AN.COM.DateTime).ConvertToDateH(statDate,"")
			..s edate=+##class(CIS.AN.COM.DateTime).ConvertToDateH(endDate,"")-1
		.e  d
			..;月
			..s newMonth=month+1
			..s year2=year1
			..i newMonth<10 s newMonth="0"_newMonth,year2=year1
			..i newMonth=13 s newMonth="01",year2=year1+1
			..
			..s endDate=year2_"-"_newMonth_"-01"
			..s statDate=year1_"-"_month_"-01"
			..s sdate=+##class(CIS.AN.COM.DateTime).ConvertToDateH(statDate,"")
			..s edate=+##class(CIS.AN.COM.DateTime).ConvertToDateH(endDate,"")-1
	
	s opsIdList=""
	f date=sdate:1:edate d
		.s opsId=0
		.f  s opsId=$order(^CIS.AN.OperScheduleI("DateDaySurgery",date,"Y",opsId)) q:opsId=""  d
			..quit:(opsId="")
			..set operSchedule1=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			..q:(operSchedule1.PatDeptID="")&(operSchedule1.AppDeptID="")
			..set statusCode=operSchedule1.Status.Code
			..s opsDate=operSchedule1.OperDate
			..s outDay=""
			..s moneyStr=##class(web.DHCBillInterface).IGetAdmInOutDatebyEpisodeID(operSchedule1.EpisodeID)
			..i moneyStr'="" s outDay=$p(moneyStr,"^",4)
			..q:(Status'="")&(outDay="")	;没出院的排除出去
			..q:(Status'="")&(("|"_Status_"|")'[("|"_statusCode_"|"))
			..q:(Status'="")&(..CheckIfNotDay(opsId)>1)
			..s opId=0
			..f  s opId=$o(^CIS.AN.OperListI("IOPS",opsId,opId)) q:opId=""  d
				...s operListObj=##class(CIS.AN.OperList).%OpenId(opId)
				...s surgeonDept=operListObj.SurgeonDeptID
				...i surgeonDept="" s surgeonDept=operSchedule1.AppDeptID
				...s surgeonDeptDesc=$p(^CTLOC(surgeonDept),"^",2)
				...q:(note'[surgeonDeptDesc)&(note'="")&(type="Loc")&(note'="总计")
				...s surgeon=""
				...s surgeonId=operListObj.Surgeon
				...i surgeonId>0 s surgeon=$p(^CTPCP(surgeonId,1),"^",2)
				...e  s surgeonId="199999",surgeon="未填"
				...q:(note'[surgeon)&(note'="")&(type="Doc")&(note'="总计")
				...s operClassDesc=""
				...s operClass=operListObj.OperClass
				...q:+operClass=0
				...i +operClass>0 s operClassDesc=$p(^ORC("CATEG",operClass),"^",2)
				...s catLoc="",catDesc=""
				...i type="Category" d
					....s catLoc=$p(note,"|",1)
					....s catDesc=$p(note,"|",2)
				...q:(surgeonDeptDesc'=catLoc)&(note'="")&(type="Category")
				...q:(operClassDesc'=catDesc)&(note'="")&(type="Category")
				...s operId=operListObj.Operation
				...s operDesc=$p($g(^ORC("OPER",operId)),"^",2)
				...q:(note'[operDesc)&(note'="")&(type="Oper")&(note'="总计")
				...set PrevDiagnoIdStr=$tr(operSchedule1.PrevDiagnosis,$c(4),"")
				...set diagnosisCount=$l(PrevDiagnoIdStr,"&&&")
				...set diagStr=""
				...for idnum=1:1:diagnosisCount d
					....q:type'="Diag"
					....set curDiagnosis=$p(PrevDiagnoIdStr,"&&&",idnum)
					....set diagId=$p(curDiagnosis,"###",1)
					....set diagDesc=$p(curDiagnosis,"###",2)
					....q:(diagDesc="")&(diagId="")
					....q:(note'[diagDesc)&(note'="")&(type="Diag")&(note'="总计")	
					....q:$g(DiagExsit(diagId,opsDate,opsId))="Y"
					....s DiagExsit(diagId,opsDate,opsId)="Y"
					....i (opsIdList'="")&((","_opsIdList_",")'[(","_diagId_",")) s opsIdList=opsIdList_"^"_opsId_","_opId_","_idnum
					....e  i (opsIdList="") s opsIdList=opsId_","_opId_","_idnum
				...q:type="Diag"
				...i (opsIdList'="") s opsIdList=opsIdList_"^"_opsId_","_opId_","
				...e  i (opsIdList="") s opsIdList=opsId_","_opId_","
	s retStr=""
	s opsLen=$l(opsIdList,"^")
	f lennum=1:1:opsLen d
	.s opsStr=$p(opsIdList,"^",lennum)
	.q:opsStr=""
	.set ret=..GetOperScheduleNew(opsStr)
	.i retStr'="" s retStr=retStr_","_ret
	.e  s retStr=ret
	q "["_retStr_"]"
}

ClassMethod GetOperScheduleNew(opsIdStr As %String) As %String
{
	s opsId=$p(opsIdStr,",",1)
	s opsSubId=$p(opsIdStr,",",2)
	s opsDSubId=$p($g(opsIdStr),",",3)
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set ops=##class(%DynamicObject).%New()
	set ops.RowId=opsId_"."_opsSubId
	i opsDSubId'="" set ops.RowId=opsId_"."_opsSubId_"."_opsDSubId
	set ops.OPSID=opsId
	set ops.Status=operSchedule.Status.Description
	set anaestObj=##class(CIS.AN.COM.Query).ToObject("CIS.AN.BL.Anaesthesia:FindAnaesthesia",opsId)
	set OperFinishDT=anaestObj.GetValue("OperFinishDT")	
	set TheatreOutDT=anaestObj.GetValue("TheatreOutDT")	
	i OperFinishDT="" set OperFinishDT=TheatreOutDT
	s ops.OperFinishDate=OperFinishDT
	set ops.OpDate=..ConvertToDate(operSchedule.OperDate)
	set opsDate=operSchedule.OperDate
	// 获取患者信息
	set ops.EpisodeID=operSchedule.EpisodeID
    Set PatientID=$P(^PAADM(ops.EpisodeID),"^",1)
    Set ops.PatName=$P(^PAPER(PatientID,"ALL"),"^",1)
	set ops.PatGender=operSchedule.PatGender
	set ops.PatAge=##class(CIS.AN.COM.DateTime).CalAge(operSchedule.PatDOB,+$h)
	set ops.RegNo=operSchedule.RegNo
	;set ops.MedcareNo=##Class(web.DHCWMRService).IGetMrNoByEpisodeID(operSchedule.EpisodeID , .ErrMsg)
	set ops.MedcareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(operSchedule.EpisodeID , .ErrMsg)
	set Loc=$P($g(^PAADM(ops.EpisodeID)),"^",4)
	set AdmDeptDesc=$p(^CTLOC(Loc),"^",2)
	set ops.AdmDeptDesc=AdmDeptDesc
	set AdmBedId=$P($g(^PAADM(ops.EpisodeID)),"^",73)
	s operListObj=##class(CIS.AN.OperList).%OpenId(opsSubId)
	s surgeon=""
	s surgeonId=operListObj.Surgeon
	i surgeonId>0 s surgeon=$p(^CTPCP(surgeonId,1),"^",2)
	set ops.SurgeonDesc=surgeon
	s surgeonDept=operListObj.SurgeonDeptID
	i surgeonDept="" s surgeonDept=operSchedule.AppDeptID
	s surgeonDeptDesc=$p(^CTLOC(surgeonDept),"^",2)
	set ops.SurgeonDeptDesc=surgeonDeptDesc
	set OperationId=operListObj.Operation
	set categId=operListObj.OperClass
	set category=$p($g(^ORC("CATEG",categId)),"^",2)
	set ops.OperCategory=category	//20211227
	set operDesc=$p($g(^ORC("OPER",OperationId)),"^",2)
	set ops.OperDesc=operDesc
	set PrevDiagnoIdStr=$tr(operSchedule.PrevDiagnosis,$c(4),"")
	set diagnosisCount=$l(PrevDiagnoIdStr,"&&&")
	set diagStr=""
	for idnum=1:1:diagnosisCount d
		.set curDiagnosis=$p(PrevDiagnoIdStr,"&&&",idnum)
		.set diagId=$p(curDiagnosis,"###",1)
		.set diagDesc=$p(curDiagnosis,"###",2)
		.i (+diagId=0)&(diagDesc="") s diagDesc=diagId
		.i diagStr'="" s diagStr=diagStr_","_diagDesc
		.e  s diagStr=diagDesc
	set ops.DiagDesc=diagStr
	s DeclineFlag=$d(^CIS.AN.DaySurgeryDeclineI("IOPS",opsId))
	i DeclineFlag>0 d
		.s declineId=$o(^CIS.AN.DaySurgeryDeclineI("IOPS",opsId,""),-1)
		.s declineDate=$lg(^CIS.AN.DaySurgeryDeclineD(declineId),5)
		.i declineDate=opsDate d
			..;s DayDeclineArr(surgeonDept,opsDate,opsId_"."_opsSubId)=$g(^CIS.AN.DaySurgeryDeclineD(declineId))
	
	quit ops.%ToJSON()
}

/// 多标题手术闽西
/// w ##class(CIS.AN.BL.DaySurgeryStatistics).GetOperMulDetails("Field2021.12.Num","内分泌科","","Decline")
/// w ##class(CIS.AN.BL.DaySurgeryStatistics).GetOperMulDetails("Field2021.12.Num","疾病","","DeclineReason")
ClassMethod GetOperMulDetails(searchDateStr As %String, note As %String = "", Status As %String = "", type As %String)
{
	s start1=$p(searchDateStr,"Field",2)
	s start2=$p(start1,"Num",1)
	s douLen=$l(start2,".")
	
	s newstart=""
	f dnum=1:1:douLen d
		.s singles=$p(start2,".",dnum)
		.q:singles=""
		.i newstart'="" s newstart=newstart_"."_singles
		.e  s newstart=singles
	s start=newstart
	;b	;?
	i $l(start,".")=1 d
		.s statDate=start_"-01-01"
		.s endDate=start_"-12-31"
		.s sdate=+##class(CIS.AN.COM.DateTime).ConvertToDateH(statDate,"")
		.s edate=+##class(CIS.AN.COM.DateTime).ConvertToDateH(endDate,"")
	i $l(start,".")=3 d
		.s year1=$p(start,".",1)
		.s month=$p(start,".",2)
		.s date=$p(start,".",3)
		.s newDateStr=year1_"-"_month_"-"_date
		.s sdate=+##class(CIS.AN.COM.DateTime).ConvertToDateH(newDateStr,"")
		.s edate=+##class(CIS.AN.COM.DateTime).ConvertToDateH(newDateStr,"")
	i $l(start,".")=2 d
		.s year1=$p(start,".",1)
		.s month=$p(start,".",2)
		.i (month<5)&(month=+month) d
			.. ;季度
			..i +month=1 s statDate=year1_"-"_"01"_"-01",endDate=year1_"-"_"03"_"-31"
			..i +month=2 s statDate=year1_"-"_"04"_"-01",endDate=year1_"-"_"06"_"-30"
			..i +month=3 s statDate=year1_"-"_"07"_"-01",endDate=year1_"-"_"09"_"-30"
			..i +month=4 s statDate=year1_"-"_"10"_"-01",endDate=year1_"-"_"12"_"-31"
			..s sdate=+##class(CIS.AN.COM.DateTime).ConvertToDateH(statDate,"")
			..s edate=+##class(CIS.AN.COM.DateTime).ConvertToDateH(endDate,"")-1
		.e  d
			..;月
			..s newMonth=month+1
			..s year2=year1
			..i newMonth<10 s newMonth="0"_newMonth,year2=year1
			..i newMonth=13 s newMonth="01",year2=year1+1
			..
			..s endDate=year2_"-"_newMonth_"-01"
			..s statDate=year1_"-"_month_"-01"
			..s sdate=+##class(CIS.AN.COM.DateTime).ConvertToDateH(statDate,"")
			..s edate=+##class(CIS.AN.COM.DateTime).ConvertToDateH(endDate,"")-1
	
	s opsIdList=""
	f date=sdate:1:edate d
		.s opsId=0
		.f  s opsId=$order(^CIS.AN.OperScheduleI("DateDaySurgery",date,"Y",opsId)) q:opsId=""  d
			..quit:(opsId="")
			..set operSchedule1=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			..q:(operSchedule1.PatDeptID="")&(operSchedule1.AppDeptID="")
			..set statusCode=operSchedule1.Status.Code
			..s opsDate=operSchedule1.OperDate
			..s opId=0
			..f  s opId=$o(^CIS.AN.OperListI("IOPS",opsId,opId)) q:opId=""  d
				...s operListObj=##class(CIS.AN.OperList).%OpenId(opId)
				...s surgeonDept=operListObj.SurgeonDeptID
				...i surgeonDept="" s surgeonDept=operSchedule1.AppDeptID
				...s surgeonDeptDesc=$p(^CTLOC(surgeonDept),"^",2)
				...q:((","_note_",")'[(","_surgeonDeptDesc_","))&(note'="")&(type="DayDecline")&(note'="总计")
				...s showFlag=((","_note_",")'[(","_surgeonDeptDesc_","))&(note'="")&(type="Decline")&(note'="总计")
				...q:showFlag
				...;q:((","_note_",")'[(","_surgeonDeptDesc_","))&(note'="")&(type="DayDecline")&(note'="总计")
				...s DeclineFlag=$d(^CIS.AN.DaySurgeryDeclineI("IOPS",opsId))
				...i ((statusCode="Decline")!(statusCode="Cancel"))&('DeclineFlag) d
					....s declineDate=..GetCancelDateByOpsId(opsId,"CCL")
					....q:(declineDate'=opsDate)&(type="DayDecline")
					....s declineReason="手术列表退出"
					....q:(type="DeclineReason")&(declineReason'[note)
					....i (opsIdList'="")&(("^"_opsIdList_"^")'[("^"_opsId_","_opId_","_"^")) s opsIdList=opsIdList_"^"_opsId_","_opId_","
					....e  i (opsIdList="") s opsIdList=opsId_","_opId_","
				...i DeclineFlag>0 d
					....s declineId=$o(^CIS.AN.DaySurgeryDeclineI("IOPS",opsId,""),-1)
					....s declineDate=$lg(^CIS.AN.DaySurgeryDeclineD(declineId),5)
					....s declineReason=$lg(^CIS.AN.DaySurgeryDeclineD(declineId),3)
					....q:(declineDate'=opsDate)&(type="DayDecline")
					....q:(type="DeclineReason")&(declineReason'[note)
					....i (opsIdList'="")&(("^"_opsIdList_"^")'[("^"_opsId_","_opId_",^")) s opsIdList=opsIdList_"^"_opsId_","_opId_","
					....e  i (opsIdList="") s opsIdList=opsId_","_opId_","
				
	s retStr=""
	s opsLen=$l(opsIdList,"^")
	f lennum=1:1:opsLen d
		.s opsStr=$p(opsIdList,"^",lennum)
		.q:opsStr=""
		.;b	;
		.set ret=..GetDeclineInfo(opsStr)
		.i retStr'="" s retStr=retStr_","_ret
		.e  s retStr=ret
	q "["_retStr_"]"
}

ClassMethod GetDeclineInfo(opsIdStr As %String) As %String
{
	s opsId=$p(opsIdStr,",",1)
	s opsSubId=$p(opsIdStr,",",2)
	s opsDSubId=$p($g(opsIdStr),",",3)
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set ops=##class(%DynamicObject).%New()
	set ops.RowId=opsId
	i opsSubId'="" set ops.RowId=opsId_"."_opsSubId
	i opsDSubId'="" set ops.RowId=opsId_"."_opsSubId_"."_opsDSubId
	set ops.OPSID=opsId
	//##class(CIS.AN.COM.DateTime).ConvertToDate(date,"")
	set ops.OpDate=..ConvertToDate(operSchedule.OperDate)
	set opsDate=operSchedule.OperDate
	// 获取患者信息
	set ops.EpisodeID=operSchedule.EpisodeID
    Set PatientID=$P(^PAADM(ops.EpisodeID),"^",1)
    Set ops.PatName=$P(^PAPER(PatientID,"ALL"),"^",1)
	set ops.PatGender=operSchedule.PatGender
	set ops.Status=operSchedule.Status.Description
	set ops.PatAge=##class(CIS.AN.COM.DateTime).CalAge(operSchedule.PatDOB,+$h)
	set ops.RegNo=operSchedule.RegNo
	set ops.MedcareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(operSchedule.EpisodeID , .ErrMsg)
	set Loc=$P($g(^PAADM(ops.EpisodeID)),"^",4)
	set AdmDeptDesc=$p(^CTLOC(Loc),"^",2)
	set ops.AdmDeptDesc=AdmDeptDesc
	set AdmBedId=$P($g(^PAADM(ops.EpisodeID)),"^",73)
	s operListObj=##class(CIS.AN.OperList).%OpenId(opsSubId)
	s surgeon=""
	s surgeonId=operListObj.Surgeon
	i surgeonId>0 s surgeon=$p(^CTPCP(surgeonId,1),"^",2)
	set ops.SurgeonDesc=surgeon
	s surgeonDept=operListObj.SurgeonDeptID
	i surgeonDept="" s surgeonDept=operSchedule.AppDeptID
	s surgeonDeptDesc=$p(^CTLOC(surgeonDept),"^",2)
	set ops.SurgeonDeptDesc=surgeonDeptDesc
	set OperationId=operListObj.Operation
	set operDesc=$p($g(^ORC("OPER",OperationId)),"^",2)
	set ops.OperDesc=operDesc
	//20211227
	set catId=operListObj.OperClass
	set catDesc=$p($g(^ORC("CATEG",catId)),"^",2)
	set ops.OperCategory=catDesc
	set anaestObj=##class(CIS.AN.COM.Query).ToObject("CIS.AN.BL.Anaesthesia:FindAnaesthesia",opsId)
	set OperFinishDT=anaestObj.GetValue("OperFinishDT")			// 手术结束时间
	set ops.OperFinishDate=OperFinishDT
	//end
	set PrevDiagnoIdStr=$tr(operSchedule.PrevDiagnosis,$c(4),"")
	set diagnosisCount=$l(PrevDiagnoIdStr,"&&&")
	set diagStr=""
	for idnum=1:1:diagnosisCount d
		.set curDiagnosis=$p(PrevDiagnoIdStr,"&&&",idnum)
		.set diagId=$p(curDiagnosis,"###",1)
		.set diagDesc=$p(curDiagnosis,"###",2)
		.i diagStr'="" s diagStr=diagStr_","_diagDesc
		.e  s diagStr=diagDesc
	set ops.DiagDesc=diagStr
	s declineReason="",declineDate=""
	s DeclineFlag=$d(^CIS.AN.DaySurgeryDeclineI("IOPS",opsId))
	i DeclineFlag>0 d
		.s declineId=$o(^CIS.AN.DaySurgeryDeclineI("IOPS",opsId,""),-1)
		.s declineDate=$lg(^CIS.AN.DaySurgeryDeclineD(declineId),5)
		.s declineReason=$lg(^CIS.AN.DaySurgeryDeclineD(declineId),3)
	i declineDate="" d
	.s declineDate=..GetCancelDateByOpsId(opsId,"CCL")
	.s declineReason="手术列表退出"
	set ops.DeclineDate=$zd(declineDate,3)
	set ops.DeclineReason=declineReason
	quit ops.%ToJSON()
}

/// 延迟出院率统计
/// w ##class(CIS.AN.BL.DaySurgeryStatistics).GetDelayOutHospRes("month","2022-01","2022-01","","DelayOut","Finish")
/// w ##class(CIS.AN.BL.DaySurgeryStatistics).GetDelayOutHospRes("season","2022-01","2022-01","","DelayOut","Finish")
/// w ##class(CIS.AN.BL.DaySurgeryStatistics).GetDelayOutHospRes("year","2022","2022","","DelayOut","Finish")
ClassMethod GetDelayOutHospRes(type As %String, date1 As %String = "", date2 As %String = "", appdept As %String = "", Strategy As %String, Status As %String = "") As %String
{
	//
	s result="",operCount=0
	i type="year" d
		.s sdate=+##class(CIS.AN.COM.DateTime).ConvertToDateH(date1_"-01-01","")
		.s edate=+##class(CIS.AN.COM.DateTime).ConvertToDateH(date2_"-12-31","")
		.;s operCount=operCount+1
		.s result=..GetDelayOutHosp(sdate,edate,Strategy,appdept,Status,type)
	i type="month" d
		.s sdate=+##class(CIS.AN.COM.DateTime).ConvertToDateH(date1_"-01","")
		.s month=$p(date2,"-",2)
		.s year2=$p(date2,"-",1)
		.s newMonth=month+1
		.i newMonth<10 s newMonth="0"_newMonth
		.i newMonth=13 s newMonth="01"  s year2=year2+1
		.s newDate2=year2_"-"_newMonth_"-01"
		.s edate=+##class(CIS.AN.COM.DateTime).ConvertToDateH(newDate2,"")-1
		.s result=..GetDelayOutHosp(sdate,edate,Strategy,appdept,Status,type)
	i type="season" d
		.s YearS=$p(date1,"-",1)
		.s MonthS=$p(date1,"-",2)
		.s YearE=$p(date2,"-",1)
		.s MonthE=$p(date2,"-",2)
		.i MonthS="01" s newDateStr1=YearS_"-"_"01"_"-01"
		.i MonthS="02" s newDateStr1=YearS_"-"_"04"_"-01"
		.i MonthS="03" s newDateStr1=YearS_"-"_"07"_"-01"
		.i MonthS="04" s newDateStr1=YearS_"-"_"10"_"-01"
		.i MonthE="01" s newDateStr2=YearE_"-"_"03"_"-31"
		.i MonthE="02" s newDateStr2=YearE_"-"_"06"_"-30"
		.i MonthE="03" s newDateStr2=YearE_"-"_"09"_"-30"
		.i MonthE="04" s newDateStr2=YearE_"-"_"12"_"-31"
		.s sdate=+##class(CIS.AN.COM.DateTime).ConvertToDateH(newDateStr1,"")
		.s edate=+##class(CIS.AN.COM.DateTime).ConvertToDateH(newDateStr2,"")
		.s result=..GetDelayOutHosp(sdate,edate,Strategy,appdept,Status,type)

	
	quit result
}

ClassMethod CountContinueDays(sourceDate, sourceTime, targetDate, targetTime, type = "S") As %String
{
	s sourceDate=##class(web.DHCClinicCom).ConvertToDateH(sourceDate)
	s targetDate=##class(web.DHCClinicCom).ConvertToDateH(targetDate)
	i sourceTime="" s sourceTime=-1
	e  s sourceTime=##class(web.DHCClinicCom).ConvertToTimeH(sourceTime)
	i targetTime="" s targetTime=86400
	e  s targetTime=##class(web.DHCClinicCom).ConvertToTimeH(targetTime)
	s durationDay=targetDate-sourceDate
	i targetTime<sourceTime s durationDay=durationDay-1,targetTime=targetTime+86400
	q:type="D" durationDay
	q:type="H" durationDay*24+((targetTime-sourceTime)\3600)
	q:type="M" durationDay*1440+((targetTime-sourceTime)\60)
	q:type="S" durationDay*86400+(targetTime-sourceTime)
	q 0
}

/// 按科室统计
/// w ##class(CIS.AN.BL.DaySurgeryStatistics).GetDelayOutHosp("66110","66141","","","Finish","month")
ClassMethod GetDelayOutHosp(sdate, edate, type, note As %String = "", Status As %String = "", Period As %String = "") As %String
{
	f date=sdate:1:edate d
		.s opsId=0
		.f  s opsId=$order(^CIS.AN.OperScheduleI("DateDaySurgery",date,"Y",opsId)) q:opsId=""  d
			..quit:(opsId="")
			..set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			..q:(operSchedule.PatDeptID="")&(operSchedule.AppDeptID="")
			..set statusCode=operSchedule.Status.Code
			..q:(Status'="")&(..CheckIfNotDay(opsId)>1)
			..q:(Status'="")&(("|"_Status_"|")'[("|"_statusCode_"|"))
			..;b	;?3
			..s opsDate=operSchedule.OperDate
			..s EpisodeID=operSchedule.EpisodeID
			..;入院日期_"^"_入院时间_"^"_住院天数_"^"_出院日期_"^"_出院时间
			..s appDeptId=operSchedule.AppDeptID
			..s appDeptDesc=$p(^CTLOC(appDeptId),"^",2)
			..s opId=0
			..f  s opId=$o(^CIS.AN.OperListI("IOPS",opsId,opId)) q:opId=""  d
				...s operListObj=##class(CIS.AN.OperList).%OpenId(opId)
				...s surgeonDept=operListObj.SurgeonDeptID
				...i surgeonDept="" s surgeonDept=operSchedule1.AppDeptID
				...s surgeonDeptDesc=$p(^CTLOC(surgeonDept),"^",2)
				...s colDeptArr(surgeonDept)=surgeonDeptDesc
				...s SingleDeptArr(surgeonDept,opsDate,opsId_"."_opId)=surgeonDept			
				...s ret=##class(web.DHCBillInterface).IGetAdmInOutDatebyEpisodeID(EpisodeID)
				...s inDate=$p(ret,"^",1)
				...s inTime=$p(ret,"^",2)
				...s outDate=$p(ret,"^",4)
				...s outTime=$p(ret,"^",5)
				...;b
				...i (outDate'="")&(inDate'="") d
					....s counts=..CountContinueDays(inDate,inTime,outDate,outTime,"H")
					....
					....b	;hout
					....i (counts>23)&(counts<48.1) d
						.....b	;?delay
						.....s DelayList(surgeonDept,opsDate,opsId_"."_opId)=opsId	
		//按科室
		s testLocId=0,jsonStr="",locNum=0
		f  s testLocId=$o(SingleDeptArr(testLocId)) q:testLocId=""  d
		.s testDate=0
		.s locNum=locNum+1,locDateNum=0,yearNum=0
		.f  s testDate=$o(SingleDeptArr(testLocId,testDate)) q:testDate=""  d
			..s newShowDate=$zd(testDate,3)
			..s YearShow=$p(newShowDate,"-",1)
			..s MonthShow=$p(newShowDate,"-",2)
			..i +MonthShow<4 s season="一季度",seasonCode=1
			..i (+MonthShow>3)&(+MonthShow<7) s season="二季度",seasonCode=2
			..i (+MonthShow>6)&(+MonthShow<10) s season="三季度",seasonCode=3
			..i +MonthShow>9 s season="四季度",seasonCode=4
			..s testOpsId=0,datenum="",delaynum=""
			..s locDateNum=locDateNum+1
			..f  s testOpsId=$o(SingleDeptArr(testLocId,testDate,testOpsId)) q:testOpsId=""  d
				...s datenum=datenum+1
				...i $d(DelayList(testLocId,testDate,testOpsId)) >0 d
					....s delaynum=delaynum+1
			..;科室，每年，每个月，每天的手术量
			..set colMonthLocArr(YearShow,MonthShow,testLocId,testDate)=datenum
			..set colMonthLocDelayArr(YearShow,MonthShow,testLocId,testDate)=delaynum
			..;科室，每年，每季度，每月，每日的手术量
			..set SeasonLocArr(testLocId,YearShow,seasonCode,MonthShow,testDate)=datenum
			..set SeasonLocDelayArr(testLocId,YearShow,seasonCode,MonthShow,testDate)=delaynum
			..set YearLocArr(testLocId,YearShow,testDate)=datenum
			..set YearLocDelayArr(testLocId,YearShow,testDate)=delaynum

	if (Period="month")
	{
		//一个月的delay数据/一个月的总数
		s year1=0
		f  s year1=$o(colMonthLocArr(year1)) q:year1=""  d
			.s month1=0
			.f  s month1=$o(colMonthLocArr(year1,month1)) q:month1=""  d
				..s loc1=0,monthNum=0,monthDelayNum=0	//单个月所有科室手术数
				..f  s loc1=$o(colMonthLocArr(year1,month1,loc1)) q:loc1=""  d
					...s locMonthNum="",date1=0,locDelayMonthNum=""	//单科月手术数
					...f  s date1=$o(colMonthLocArr(year1,month1,loc1,date1)) q:date1=""  d
						....s value=colMonthLocArr(year1,month1,loc1,date1)
						....s locMonthNum=locMonthNum+value
						....s devalue=$g(colMonthLocDelayArr(year1,month1,loc1,date1))
						....s locDelayMonthNum=locDelayMonthNum+devalue
					...s monthNum=monthNum+locMonthNum
					...s monthDelayNum=monthDelayNum+locDelayMonthNum
					...i +locMonthNum=0 s locMonthNum="",persent=""
					...i +locDelayMonthNum=0 s locDelayMonthNum="",persent=""
					...q:+locDelayMonthNum=0
					...s NewMonthArr(loc1,"Field1")=colDeptArr(loc1)
					...s NewMonthArr(loc1,"Field"_year1_"."_month1_".Num")=locDelayMonthNum
					...i locMonthNum>0 d
						....s persent=$fn((locDelayMonthNum/locMonthNum),"",4)*100_"%"
						....i +$fn((locDelayMonthNum/locMonthNum),"",4)=0 s persent=""
	   				...s NewMonthArr(loc1,"Field"_year1_"."_month1_".Per")=persent	//单科退出率
				..i +monthNum=0 s monthNum="",persent=""
				..i +monthDelayNum=0 s monthDelayNum="",persent=""
				..q:+monthDelayNum=0
		 		..s NewMonthArr("总计","Field1")="总计"	
				..s NewMonthArr("总计","Field"_year1_"."_month1_".Num")=monthDelayNum
				..i locMonthNum>0 d
					...s persent=$fn((monthDelayNum/monthNum),"",4)*100_"%"
					...i +$fn((monthDelayNum/monthNum),"",4)=0 s persent=""
	   			..s NewMonthArr("总计","Field"_year1_"."_month1_".Per")=persent	//单科退出率
	
		 set JsonStr=##class(CIS.AN.COM.String).ToJson(.NewMonthArr)
	}
	elseif (Period="season")
	{
		s locId=0,num=0,locShowNum=0
		f  s locId=$o(SeasonLocArr(locId)) q:locId=""  d
			.s years=0
			.f  s years=$o(SeasonLocArr(locId,years)) q:years=""  d
				..s seasons=0
				..f  s seasons=$o(SeasonLocArr(locId,years,seasons)) q:seasons=""  d
					...s months=0,seasonNum=0,seasonDelayNum=0
					...;seasonNum：科室单个季度
					...f  s months=$o(SeasonLocArr(locId,years,seasons,months)) q:months=""  d
						....s MonthNum=0,showYearDate=0,delayMonthNum=0
						....;MonthNum:科室单月
						.... f  s showYearDate=$o(SeasonLocArr(locId,years,seasons,months,showYearDate)) q:showYearDate=""  d
							.....s value=SeasonLocArr(locId,years,seasons,months,showYearDate)
							.....s MonthNum=MonthNum+value
							.....s devalue=SeasonLocDelayArr(locId,years,seasons,months,showYearDate)
							.....s delayMonthNum=delayMonthNum+devalue
						....s seasonNum=seasonNum+MonthNum	
						....s seasonDelayNum=seasonDelayNum+delayMonthNum
					...i +seasonNum=0 s seasonNum="",persent=""
					...i +seasonDelayNum=0 s seasonDelayNum=""
					...q:+seasonDelayNum=0
					...s NewSeasonShowArr(locId,"Field"_years_"."_seasons_".Num")=seasonDelayNum
					...s NewSeasonShowArr(locId,"Field1")=colDeptArr(locId)
					...i seasonNum>0 d
						....s persent=$fn((seasonDelayNum/seasonNum),"",4)*100_"%"
						....i +$fn((seasonDelayNum/seasonNum),"",4)=0 s persent=""
		   			...s NewSeasonShowArr(locId,"Field"_years_"."_seasons_".Per")=persent
					...//单个科室季度数据
					...set SeasonLocSumArr(years,seasons,locId)=seasonNum
					...set SeasonLocDelaySumArr(years,seasons,locId)=seasonDelayNum
			s year2=0
			f  s year2=$o(SeasonLocSumArr(year2)) q:year2=""  d
		 		.s season2=0
		 		.f  s season2=$o(SeasonLocSumArr(year2,season2)) q:season2=""  d
		 		..s locId2=0,locSeasonNum=0,locSeasonDelayNum=0
		 		..f  s locId2=$o(SeasonLocSumArr(year2,season2,locId2)) q:locId2=""  d
		 			...s locSeasonNum=SeasonLocSumArr(year2,season2,locId2)
		 			...s locSeasonDelayNum=SeasonLocDelaySumArr(year2,season2,locId2)
				..i +locSeasonNum=0 s locSeasonNum="",persent=""
				..i +locSeasonDelayNum=0 s locSeasonDelayNum="",persent=""
				..q:+locSeasonDelayNum=0
		 		..s NewSeasonShowArr("总计","Field1")="总计"	
				..s NewSeasonShowArr("总计","Field"_years_"."_seasons_".Num")=seasonDelayNum
				..i locSeasonNum>0 d
					...s persent=$fn((locSeasonDelayNum/locSeasonNum),"",4)*100_"%"
					...i +$fn((locSeasonDelayNum/locSeasonNum),"",4)=0 s persent=""
	   			..s NewSeasonShowArr("总计","Field"_years_"."_seasons_".Per")=persent	//单科退出率

		 
		 set JsonStr=##class(CIS.AN.COM.String).ToJson(.NewSeasonShowArr)
	}
	else
	{
		///一年延迟多少/一年总共出院多少
		s locId=0,num=0,locShowNum=0
		f  s locId=$o(YearLocArr(locId)) q:locId=""  d
			.s yeary=0
			.s locAllNum="",locDelayAllNum=""
			.;单个科室所有手术,不区分年份
			.f  s yeary=$o(YearLocArr(locId,yeary)) q:yeary=""  d
				..s datey=0,dateNum="",dateDelayNum=""
				..;单个科室一年手术
				..f  s datey=$o(YearLocArr(locId,yeary,datey)) q:datey=""  d
					...s value=YearLocArr(locId,yeary,datey)	;一天多少
					...s dateNum=dateNum+value
					...s devalue=YearLocDelayArr(locId,yeary,datey)
					...s dateDelayNum=dateDelayNum+devalue
				..s locAllNum=locAllNum+dateNum
				..s locDelayAllNum=locDelayAllNum+dateDelayNum
				..i +dateNum=0 s dateNum="",persent=""
				..i +dateDelayNum=0 s dateDelayNum=""
				..q:+dateDelayNum=0
				..s NewYearShowArr(locId,"Field1")=colDeptArr(locId)
				..s NewYearShowArr(locId,"Field"_yeary_".Num")=dateDelayNum
				..i dateNum>0 d
					...s persent=$fn((dateDelayNum/dateNum),"",4)*100_"%"
					...i +$fn((dateDelayNum/dateNum),"",4)=0 s persent=""
			   	..s NewYearShowArr(locId,"Field"_yeary_".Per")=persent
			   	..set YearLocSumArr(yeary,locId)=datenum
				..set YearLocDelaySumArr(yeary,locId)=delaynum

		  s years=0
		  f  s years=$o(YearLocSumArr(years)) q:years=""  d
			   .s locIds=0,yearAllNum=0,yearDelayAllNum=0
			   . f  s locIds=$o(YearLocSumArr(years,locIds)) q:locIds=""  d
				   ..s yearLocNum=YearLocSumArr(years,locIds)
				   ..s yearDelayLocNum=YearLocDelaySumArr(years,locIds)
				   ..s yearAllNum=yearAllNum+yearLocNum
				   ..s yearDelayAllNum=yearDelayAllNum+yearDelayLocNum
			   .
			   . i +yearAllNum=0 s yearAllNum="",persent=""
			   . i +yearDelayAllNum=0 s yearDelayAllNum="",persent=""
			   .q:+yearDelayAllNum=0
			   .s NewYearShowArr("总计","Field1")="总计"	
			   . s NewYearShowArr("总计","Field"_years_".Num")=yearDelayAllNum
			   . i yearAllNum>0 d
					..s persent=$fn((yearDelayAllNum/yearAllNum),"",4)*100_"%"
					..i +$fn((yearDelayAllNum/yearAllNum),"",4)=0 s persent=""
		   	   .s NewYearShowArr("总计","Field"_years_".Per")=persent	//单科退出率

		   	
		   	
		 set JsonStr=##class(CIS.AN.COM.String).ToJson(.NewYearShowArr)

	}

	q JsonStr
}

/// w ##class(CIS.AN.BL.DaySurgeryStatistics).GetDelayOutDetails("Field2022.01.Num","内分泌科","Finish","DelayOut")
ClassMethod GetDelayOutDetails(searchDateStr As %String, note As %String = "", Status As %String = "", type As %String)
{
	s start1=$p(searchDateStr,"Field",2)
	s start2=$p(start1,"Num",1)
	s douLen=$l(start2,".")
	
	s newstart=""
	f dnum=1:1:douLen d
		.s singles=$p(start2,".",dnum)
		.q:singles=""
		.i newstart'="" s newstart=newstart_"."_singles
		.e  s newstart=singles
	s start=newstart
	;b	;?
	i $l(start,".")=1 d
		.s statDate=start_"-01-01"
		.s endDate=start_"-12-31"
		.s sdate=+##class(CIS.AN.COM.DateTime).ConvertToDateH(statDate,"")
		.s edate=+##class(CIS.AN.COM.DateTime).ConvertToDateH(endDate,"")
	i $l(start,".")=3 d
		.s year1=$p(start,".",1)
		.s month=$p(start,".",2)
		.s date=$p(start,".",3)
		.s newDateStr=year1_"-"_month_"-"_date
		.s sdate=+##class(CIS.AN.COM.DateTime).ConvertToDateH(newDateStr,"")
		.s edate=+##class(CIS.AN.COM.DateTime).ConvertToDateH(newDateStr,"")
	i $l(start,".")=2 d
		.s year1=$p(start,".",1)
		.s month=$p(start,".",2)
		.i (month<5)&(month=+month) d
			.. ;季度
			..i +month=1 s statDate=year1_"-"_"01"_"-01",endDate=year1_"-"_"03"_"-31"
			..i +month=2 s statDate=year1_"-"_"04"_"-01",endDate=year1_"-"_"06"_"-30"
			..i +month=3 s statDate=year1_"-"_"07"_"-01",endDate=year1_"-"_"09"_"-30"
			..i +month=4 s statDate=year1_"-"_"10"_"-01",endDate=year1_"-"_"12"_"-31"
			..s sdate=+##class(CIS.AN.COM.DateTime).ConvertToDateH(statDate,"")
			..s edate=+##class(CIS.AN.COM.DateTime).ConvertToDateH(endDate,"")-1
		.e  d
			..;月
			..s newMonth=month+1
			..s year2=year1
			..i newMonth<10 s newMonth="0"_newMonth,year2=year1
			..i newMonth=13 s newMonth="01",year2=year1+1
			..
			..s endDate=year2_"-"_newMonth_"-01"
			..s statDate=year1_"-"_month_"-01"
			..s sdate=+##class(CIS.AN.COM.DateTime).ConvertToDateH(statDate,"")
			..s edate=+##class(CIS.AN.COM.DateTime).ConvertToDateH(endDate,"")-1
	
	s opsIdList=""
	f date=sdate:1:edate d
		.s opsId=0
		.f  s opsId=$order(^CIS.AN.OperScheduleI("DateDaySurgery",date,"Y",opsId)) q:opsId=""  d
			..quit:(opsId="")
			..set operSchedule1=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			..q:(operSchedule1.PatDeptID="")&(operSchedule1.AppDeptID="")
			..set statusCode=operSchedule1.Status.Code
			..s EpisodeID=operSchedule1.EpisodeID
			..s opsDate=operSchedule1.OperDate
			..s opId=0
			..f  s opId=$o(^CIS.AN.OperListI("IOPS",opsId,opId)) q:opId=""  d
				...s operListObj=##class(CIS.AN.OperList).%OpenId(opId)
				...s surgeonDept=operListObj.SurgeonDeptID
				...i surgeonDept="" s surgeonDept=operSchedule1.AppDeptID
				...s surgeonDeptDesc=$p(^CTLOC(surgeonDept),"^",2)
				...//按科室查
				...s showFlag=((","_note_",")'[(","_surgeonDeptDesc_","))&(note'="")&(type="DelayOut")&(note'="总计")
				...q:showFlag
				...s ret=##class(web.DHCBillInterface).IGetAdmInOutDatebyEpisodeID(EpisodeID)
				...s inDate=$p(ret,"^",1)
				...s inTime=$p(ret,"^",2)
				...s outDate=$p(ret,"^",4)
				...s outTime=$p(ret,"^",5)
				...;b
				...i (outDate'="")&(inDate'="") d
					....s counts=..CountContinueDays(inDate,inTime,outDate,outTime,"H")
					....i opsId=987 b
					....;b	;hout
					....i (counts>23)&(counts<48.1) d
						.....b	;?
					.....i (opsIdList'="")&(("^"_opsIdList_"^")'[("^"_opsId_","_opId_",^")) s opsIdList=opsIdList_"^"_opsId_","_opId_","
					.....e  i (opsIdList="") s opsIdList=opsId_","_opId_","
				
	s retStr=""
	s opsLen=$l(opsIdList,"^")
	f lennum=1:1:opsLen d
		.s opsStr=$p(opsIdList,"^",lennum)
		.q:opsStr=""
		.;b	;
		.set ret=..GetDelayOutInfo(opsStr)
		.i retStr'="" s retStr=retStr_","_ret
		.e  s retStr=ret
	q "["_retStr_"]"
}

ClassMethod GetDelayOutInfo(opsIdStr As %String) As %String
{
	s opsId=$p(opsIdStr,",",1)
	s opsSubId=$p(opsIdStr,",",2)
	s opsDSubId=$p($g(opsIdStr),",",3)
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set ops=##class(%DynamicObject).%New()
	set ops.RowId=opsId
	i opsSubId'="" set ops.RowId=opsId_"."_opsSubId
	i opsDSubId'="" set ops.RowId=opsId_"."_opsSubId_"."_opsDSubId
	set ops.OPSID=opsId
	//##class(CIS.AN.COM.DateTime).ConvertToDate(date,"")
	set ops.OpDate=..ConvertToDate(operSchedule.OperDate)
	set opsDate=operSchedule.OperDate
	// 获取患者信息
	set ops.EpisodeID=operSchedule.EpisodeID
    Set PatientID=$P(^PAADM(ops.EpisodeID),"^",1)
    Set ops.PatName=$P(^PAPER(PatientID,"ALL"),"^",1)
	set ops.PatGender=operSchedule.PatGender
	set ops.Status=operSchedule.Status.Description
	set ops.PatAge=##class(CIS.AN.COM.DateTime).CalAge(operSchedule.PatDOB,+$h)
	set ops.RegNo=operSchedule.RegNo
	set ops.MedcareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(operSchedule.EpisodeID , .ErrMsg)
	set Loc=$P($g(^PAADM(ops.EpisodeID)),"^",4)
	set AdmDeptDesc=$p(^CTLOC(Loc),"^",2)
	set ops.AdmDeptDesc=AdmDeptDesc
	set AdmBedId=$P($g(^PAADM(ops.EpisodeID)),"^",73)
	s operListObj=##class(CIS.AN.OperList).%OpenId(opsSubId)
	s surgeon=""
	s surgeonId=operListObj.Surgeon
	i surgeonId>0 s surgeon=$p(^CTPCP(surgeonId,1),"^",2)
	set ops.SurgeonDesc=surgeon
	s surgeonDept=operListObj.SurgeonDeptID
	i surgeonDept="" s surgeonDept=operSchedule.AppDeptID
	s surgeonDeptDesc=$p(^CTLOC(surgeonDept),"^",2)
	set ops.SurgeonDeptDesc=surgeonDeptDesc
	set OperationId=operListObj.Operation
	set operDesc=$p($g(^ORC("OPER",OperationId)),"^",2)
	set ops.OperDesc=operDesc
	//20211227
	set catId=operListObj.OperClass
	set catDesc=$p($g(^ORC("CATEG",catId)),"^",2)
	set ops.OperCategory=catDesc
	set anaestObj=##class(CIS.AN.COM.Query).ToObject("CIS.AN.BL.Anaesthesia:FindAnaesthesia",opsId)
	set OperFinishDT=anaestObj.GetValue("OperFinishDT")			// 手术结束时间
	set ops.OperFinishDate=OperFinishDT
	//end
	set PrevDiagnoIdStr=$tr(operSchedule.PrevDiagnosis,$c(4),"")
	set diagnosisCount=$l(PrevDiagnoIdStr,"&&&")
	set diagStr=""
	for idnum=1:1:diagnosisCount d
		.set curDiagnosis=$p(PrevDiagnoIdStr,"&&&",idnum)
		.set diagId=$p(curDiagnosis,"###",1)
		.set diagDesc=$p(curDiagnosis,"###",2)
		.i diagStr'="" s diagStr=diagStr_","_diagDesc
		.e  s diagStr=diagDesc
	set ops.DiagDesc=diagStr
	s retBill=##class(web.DHCBillInterface).IGetAdmInOutDatebyEpisodeID(ops.EpisodeID)
	s inDate=$p(retBill,"^",1)
	s inTime=$p(retBill,"^",2)
	s outDate=$p(retBill,"^",4)
	s outTime=$p(retBill,"^",5)

	set ops.InDateTime=..ConvertToDate(inDate)_" "_$zt(inTime,2)
	set ops.OutDateTime=..ConvertToDate(outDate)_" "_$zt(outTime,2)
	quit ops.%ToJSON()
}

/// 获取手术级别相关信息
/// w ##class(CIS.AN.BL.DaySurgeryStatistics).GetCatListResult("month","2021-12","2022-01","","","Finish")
ClassMethod GetCatListResult(type As %String, date1 As %String = "", date2 As %String = "", dept As %String = "", cat As %String = "", Status As %String = "")
{
	s note=dept
	s result="",operCount=0
	i type="year" d
		.s sdate=+##class(CIS.AN.COM.DateTime).ConvertToDateH(date1_"-01-01","")
		.s edate=+##class(CIS.AN.COM.DateTime).ConvertToDateH(date2_"-12-31","")
		.i (date2-date1)>3 s result="按年查询最多可以查询3年数据"
		.q:result'=""
		.s result=..GetCatListByYear(sdate,edate,dept,cat,Status)
	i type="month" d
		.s sdate=+##class(CIS.AN.COM.DateTime).ConvertToDateH(date1_"-01","")
		.s month=$p(date2,"-",2)
		.s month1=$p(date1,"-",2)
		.s year2=$p(date2,"-",1)
		.s year1=$p(date1,"-",1)
		.s yearnum=year2-year1
		.s monthnum=yearnum*12+month-month1
		.i monthnum>24 s result="按月查询最多可以查询24个月数据"
		.q:result'=""
		.s newMonth=month+1
		.i newMonth<10 s newMonth="0"_newMonth
		.i newMonth=13 s newMonth="01"  s year2=year2+1
		.s newDate2=year2_"-"_newMonth_"-01"
		.s edate=+##class(CIS.AN.COM.DateTime).ConvertToDateH(newDate2,"")-1
		.;b ;s operCount=operCount+1
		.s result=..GetCatListByMonth(sdate,edate,dept,cat,Status)
	i type="season" d
		.s YearS=$p(date1,"-",1)
		.s MonthS=$p(date1,"-",2)
		.s YearE=$p(date2,"-",1)
		.s MonthE=$p(date2,"-",2)
		.s yearnum=YearE-YearS
		.s seasonnum=yearnum*4+MonthE-MonthS
		.i (seasonnum>12) s result="按月查询最多可以查询12个季度数据"
		.q:result'=""
		.i MonthS="01" s newDateStr1=YearS_"-"_"01"_"-01"
		.i MonthS="02" s newDateStr1=YearS_"-"_"04"_"-01"
		.i MonthS="03" s newDateStr1=YearS_"-"_"07"_"-01"
		.i MonthS="04" s newDateStr1=YearS_"-"_"10"_"-01"
		.i MonthE="01" s newDateStr2=YearE_"-"_"03"_"-31"
		.i MonthE="02" s newDateStr2=YearE_"-"_"06"_"-30"
		.i MonthE="03" s newDateStr2=YearE_"-"_"09"_"-30"
		.i MonthE="04" s newDateStr2=YearE_"-"_"12"_"-31"
		.s sdate=+##class(CIS.AN.COM.DateTime).ConvertToDateH(newDateStr1,"")
		.s edate=+##class(CIS.AN.COM.DateTime).ConvertToDateH(newDateStr2,"")
		.;s operCount=operCount+1
		.s result=..GetCatListBySeason(sdate,edate,dept,cat,Status)

	
	quit result
}

/// 按年统计
ClassMethod GetCatListByYear(sdate, edate, catLoc As %String = "", newNoteCate As %String = "", Status As %String = "") As %String
{
	f date=sdate:1:edate d
	.s opsId=0
	.f  s opsId=$order(^CIS.AN.OperScheduleI("DateDaySurgery",date,"Y",opsId)) q:opsId=""  d
		..quit:(opsId="")
		..set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		..q:(operSchedule.PatDeptID="")&(operSchedule.AppDeptID="")
		..set statusCode=operSchedule.Status.Code
		..s outDay=""
		..s moneyStr=##class(web.DHCBillInterface).IGetAdmInOutDatebyEpisodeID(operSchedule.EpisodeID)
		..i moneyStr'="" s outDay=$p(moneyStr,"^",4)
		..q:(Status'="")&(outDay="")	;没出院的排除出去
		..q:(Status'="")&(("|"_Status_"|")'[("|"_statusCode_"|"))
		..q:(Status'="")&(..CheckIfNotDay(opsId)>1)
		..s opsDate=operSchedule.OperDate
		..s opsDate=operSchedule.OperDate
		..s dateStr=$zd(opsDate,3)
		..s yearM=$p(dateStr,"-",1)
		..s monthM=$p(dateStr,"-",2)
		..s dateM=$p(dateStr,"-",3)

		..;q:(statusCode="Cancel")!(statusCode="Declinie")
		..set operationNameStr="",surgeonNameList=""
		..s opId=0
		..f  s opId=$o(^CIS.AN.OperListI("IOPS",opsId,opId)) q:opId=""  d
			...s operListObj=##class(CIS.AN.OperList).%OpenId(opId)
			...s surgeonId=operListObj.Surgeon
			...q:+surgeonId=0
			...s surgeonDept=operListObj.SurgeonDeptID
			...i surgeonDept="" s surgeonDept=operSchedule.AppDeptID
			...s surgeonDeptDesc=$p(^CTLOC(surgeonDept),"^",2)
			...q:((","_catLoc_",")'[(","_surgeonDeptDesc_","))&(catLoc'="")

			...s operId=operListObj.Operation
			...s operDesc=$p(^ORC("OPER",operId),"^",2)
			...s operClassDesc="未填"
			...s operClass=operListObj.OperClass
			...i +operClass>0 s operClassDesc=$p(^ORC("CATEG",operClass),"^",2)
			...e  s operClass=1999
			...s ClassDescArr(operClass)=operClassDesc
			...;q:((","_newNoteCate_",")'[(","_operClassDesc_","))&(newNoteCate'="")
			...s SingleClassArr(surgeonDept,yearM,operClassDesc,opsDate,opsId_"."_opId)=surgeonDeptDesc
			...q:((","_newNoteCate_",")'[(","_operClassDesc_","))&(newNoteCate'="")
			...s NewClassArrList(operClassDesc_"."_surgeonDept,"Field1")=surgeonDeptDesc
			...s NewClassArrList(operClassDesc_"."_surgeonDept,"Field2")=operClassDesc

	s locDr1=0
	f  s locDr1=$o(SingleClassArr(locDr1)) q:locDr1=""  d
	.s year1=0
	.f  s year1=$o(SingleClassArr(locDr1,year1)) q:year1=""  d
		..s classDr1=0,jsonStr="",yearNum=0
		..f  s classDr1=$o(SingleClassArr(locDr1,year1,classDr1)) q:classDr1=""  d
			...s testDate=0,classNum=0
			...f  s testDate=$o(SingleClassArr(locDr1,year1,classDr1,testDate)) q:testDate=""  d
				....s testOpsId=0,datenum=""
				....f  s testOpsId=$o(SingleClassArr(locDr1,year1, classDr1,testDate,testOpsId)) q:testOpsId=""  d
					.....s datenum=datenum+1	//单条记录多少手术
				....s classNum=classNum+datenum
			...s yearNum=yearNum+classNum
			...;一年的某一天
			...set YearClassArr(locDr1,year1,classDr1)=classNum
		..set YearOperArr(locDr1,year1)=yearNum	

		s locDr2=0
		f  s locDr2=$o(YearClassArr(locDr2)) q:locDr2=""  d
			.s year2=0,classNum=0
			.f  s year2=$o(YearClassArr(locDr2,year2)) q:year2=""  d
				..s YearNum=0,classDr2=0
				..f  s classDr2=$o(YearClassArr(locDr2,year2,classDr2)) q:classDr2=""  d
					...q:((","_newNoteCate_",")'[(","_classDr2_","))&(newNoteCate'="")
					...s YearNum=$g(YearClassArr(locDr2,year2,classDr2))
					...s allClassNum=$g(YearOperArr(locDr2,year2))
					...s NewClassArrList(classDr2_"."_locDr2,"Field"_year2_".Num")=YearNum
					...s persent=""
					...i allClassNum>0 s persent=$fn((YearNum/allClassNum),"",4)*100_"%"
					...s NewClassArrList(classDr2_"."_locDr2,"Field"_year2_".Per")=persent		
		set JsonStr=##class(CIS.AN.COM.String).ToJson(.NewClassArrList)
		
	 //w JsonStr
	q JsonStr
}

/// 按月统计
/// 手术级别
ClassMethod GetCatListByMonth(sdate, edate, catLoc As %String = "", newNoteCate As %String = "", Status As %String = "") As %String
{
	f date=sdate:1:edate d
		.s opsId=0
		.f  s opsId=$order(^CIS.AN.OperScheduleI("DateDaySurgery",date,"Y",opsId)) q:opsId=""  d
			..quit:(opsId="")
			..set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			..q:(operSchedule.PatDeptID="")&(operSchedule.AppDeptID="")
			..set statusCode=operSchedule.Status.Code
			..s outDay=""
			..s moneyStr=##class(web.DHCBillInterface).IGetAdmInOutDatebyEpisodeID(operSchedule.EpisodeID)
			..i moneyStr'="" s outDay=$p(moneyStr,"^",4)
			..q:(Status'="")&(outDay="")	;没出院的排除出去
			..q:(Status'="")&(("|"_Status_"|")'[("|"_statusCode_"|"))
			..q:(Status'="")&(..CheckIfNotDay(opsId)>1)
			..s opsDate=operSchedule.OperDate
			..s dateStr=$zd(opsDate,3)
			..s yearM=$p(dateStr,"-",1)
			..s monthM=$p(dateStr,"-",2)
			..s dateM=$p(dateStr,"-",3)
			..;q:(statusCode="Cancel")!(statusCode="Declinie")
			..set operationNameStr="",surgeonNameList=""
			..s opId=0
			..f  s opId=$o(^CIS.AN.OperListI("IOPS",opsId,opId)) q:opId=""  d
				...s operListObj=##class(CIS.AN.OperList).%OpenId(opId)
				...s surgeonId=operListObj.Surgeon
				...q:+surgeonId=0
				...s surgeonDept=operListObj.SurgeonDeptID
				...i surgeonDept="" s surgeonDept=operSchedule.AppDeptID
				...s surgeonDeptDesc=$p(^CTLOC(surgeonDept),"^",2)
				...q:((","_catLoc_",")'[(","_surgeonDeptDesc_","))&(catLoc'="")
				...s colDeptArr(surgeonDept)=surgeonDeptDesc
				...s SingleDeptArr(surgeonDept,opsDate,opsId_"."_opId)=surgeonDeptDesc
				...s MonthDeptArr(surgeonDept,yearM,monthM,opsDate,opsId_"."_opId)=""
				...s operId=operListObj.Operation
				...s operDesc=$p(^ORC("OPER",operId),"^",2)
				...s operClassDesc="未填"
				...s operClass=operListObj.OperClass
				...i +operClass>0 s operClassDesc=$p(^ORC("CATEG",operClass),"^",2)
				...e  s operClass=1999
				...s newNoteLoc=""
				...s ClassDescArr(operClass)=operClassDesc
				...s SingleClassArr(surgeonDept,yearM,monthM,operClassDesc,opsDate,opsId_"."_opId)=surgeonDeptDesc
				...q:((","_newNoteCate_",")'[(","_operClassDesc_","))&(newNoteCate'="")
				...s NewClassArr(operClassDesc_"."_surgeonDept,"Field1")=surgeonDeptDesc
				...s NewClassArr(operClassDesc_"."_surgeonDept,"Field2")=operClassDesc

		///按手术级别
	 s locId5=0,jsonStr="",locNum=0
	 f  s locId5=$o(SingleClassArr(locId5)) q:locId5=""  d
	 .s year5=0
	 .f  s year5=$o(SingleClassArr(locId5,year5)) q:year5=""  d
	 	..s month5=0,locYearNum=0	
	 	..f  s month5=$o(SingleClassArr(locId5,year5,month5)) q:month5=""  d
	 		...s fClassId=0,locMonthNum=0	;科室单月单分类数
	 		...f  s fClassId=$o(SingleClassArr(locId5,year5,month5,fClassId)) q:fClassId=""  d
	 			....s testDate=0,classNum=0,yearNum=0	;单科单分类一天
	 			....f  s testDate=$o(SingleClassArr(locId5,year5,month5,fClassId,testDate)) q:testDate=""  d
	 				.....s testOpsId=0,opernum=""	
	 				.....f  s testOpsId=$o(SingleClassArr(locId5,year5,month5,fClassId,testDate,testOpsId)) q:testOpsId=""  d
	 					......s opernum=opernum+1	;单个手术记录中有多少条
	 				.....s classNum=classNum+opernum	;单个分类多少
	 			....s locMonthNum=locMonthNum+classNum	;一个月多少
				....set ClassListArr(locId5,fClassId,year5,month5)=classNum
	 		...s locYearNum=locYearNum+locMonthNum	//一年多少
			...	//单月科室总计多少
			...set MonthListArr(year5,month5,locId5)=locMonthNum
	;b
		
		s secLocId=0
		f  s secLocId=$o(ClassListArr(secLocId)) q:secLocId=""  d
			.s classOperNum=0
			.s secClass=0 f  s secClass=$o(ClassListArr(secLocId,secClass)) q:secClass=""  d
				..
				..s yearAllNum=0
				..s secYear=0 
				..f  s secYear=$o(ClassListArr(secLocId,secClass,secYear)) q:secYear=""  d
					...s classYearNum=0,classOperNum=0	;每年单个级别的数量
					...s secMonth=0 
					...f  s secMonth=$o(ClassListArr(secLocId,secClass,secYear,secMonth)) q:secMonth=""  d
						....q:((","_newNoteCate_",")'[(","_secClass_","))&(newNoteCate'="")
						....s classNum=ClassListArr(secLocId,secClass,secYear,secMonth)	//每个月多少单个级别手术
						....s locAllNum=MonthListArr(secYear,secMonth,secLocId)	//
						....s NewClassArr(secClass_"."_secLocId,"Field"_secYear_"."_secMonth_".Num")=classNum
						....i classNum>0 s persent=$fn((classNum/locAllNum),"",4)*100_"%"
				   		....s NewClassArr(secClass_"."_secLocId,"Field"_secYear_"."_secMonth_".Per")=persent
	b
		set JsonStr=##class(CIS.AN.COM.String).ToJson(.NewClassArr)
	q JsonStr
}

ClassMethod GetCatListBySeason(sdate, edate, catLoc As %String = "", newNoteCate As %String = "", Status As %String = "") As %String
{
	k NewClassArrList
	f date=sdate:1:edate d
		.s opsId=0
		.f  s opsId=$order(^CIS.AN.OperScheduleI("DateDaySurgery",date,"Y",opsId)) q:opsId=""  d
			..quit:(opsId="")
			..set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			..q:(operSchedule.PatDeptID="")&(operSchedule.AppDeptID="")
			..set statusCode=operSchedule.Status.Code
			..s outDay=""
			..s moneyStr=##class(web.DHCBillInterface).IGetAdmInOutDatebyEpisodeID(operSchedule.EpisodeID)
			..i moneyStr'="" s outDay=$p(moneyStr,"^",4)
			..q:(Status'="")&(outDay="")	;没出院的排除出去
			..s opsDate=operSchedule.OperDate
			..s newShowDate=$zd(opsDate,3)
			..s YearShow=$p(newShowDate,"-",1)
			..s MonthShow=$p(newShowDate,"-",2)
			..i +MonthShow<4 s season="一季度",seasonCode=1
			..i (+MonthShow>3)&(+MonthShow<7) s season="二季度",seasonCode=2
			..i (+MonthShow>6)&(+MonthShow<10) s season="三季度",seasonCode=3
			..i +MonthShow>9 s season="四季度",seasonCode=4
			..;q:(statusCode="Cancel")!(statusCode="Declinie")
			..q:(Status'="")&(("|"_Status_"|")'[("|"_statusCode_"|"))
			..q:(Status'="")&(..CheckIfNotDay(opsId)>1)
			..set operationNameStr="",surgeonNameList=""
			..s opId=0
			..f  s opId=$o(^CIS.AN.OperListI("IOPS",opsId,opId)) q:opId=""  d
				...s operListObj=##class(CIS.AN.OperList).%OpenId(opId)
				...s surgeonId=operListObj.Surgeon
				...q:+surgeonId=0
				...s surgeonDept=operListObj.SurgeonDeptID
				...i surgeonDept="" s surgeonDept=operSchedule.AppDeptID
				...s surgeonDeptDesc=$p(^CTLOC(surgeonDept),"^",2)
				...q:((","_catLoc_",")'[(","_surgeonDeptDesc_","))&(catLoc'="")

				...s operId=operListObj.Operation
				...s operDesc=$p(^ORC("OPER",operId),"^",2)
				...s operClassDesc="未填"
				...s operClass=operListObj.OperClass
				...i +operClass>0 s operClassDesc=$p(^ORC("CATEG",operClass),"^",2)
				...e  s operClass=1999
				...s ClassDescArr(operClass)=operClassDesc
				...s SingleClassArr(surgeonDeptDesc_"."_operClassDesc,opsDate,opsId_"."_opId)=surgeonDeptDesc
				...s SeasonArrList(surgeonDept,YearShow,seasonCode,operClassDesc,opsId_"."_opId)=operClassDesc
				...q:((","_newNoteCate_",")'[(","_operClassDesc_","))&(newNoteCate'="")
				...s NewClassArrList(operClassDesc_"."_surgeonDept,"Field1")=surgeonDeptDesc
				...s NewClassArrList(operClassDesc_"."_surgeonDept,"Field2")=operClassDesc


		///按手术级别
		s slocId1=0
		f  s slocId1=$o(SeasonArrList(slocId1)) q:slocId1=""  d
			.s year1=0
			.f  s year1=$o(SeasonArrList(slocId1,year1)) q:year1=""  d
				..s season1=0,yearNum=0
				..f  s season1=$o(SeasonArrList(slocId1,year1,season1)) q:season1=""  d
				...s class1=0,seasonNum=0
				...f  s class1=$o(SeasonArrList(slocId1,year1,season1,class1)) q:class1=""  d
					....s opsId1=0,classNum=0
					....f  s opsId1=$o(SeasonArrList(slocId1,year1,season1,class1,opsId1)) q:opsId1=""  d
						.....s classNum=classNum+1
					....s seasonNum=seasonNum+classNum
					....s SingleClassNew(slocId1,year1,season1,class1)=classNum	//一分类多少
				...s SingleSeasonNew(slocId1,year1,season1)=seasonNum	//一季度多少
			

		
		s locId2=0,allnum=0
		f  s locId2=$o(SingleClassNew(locId2)) q:locId2=""  d
			.s year2=0
			.f  s year2=$o(SingleClassNew(locId2,year2)) q:year2=""  d
				..s season2=0 ,yearNum=0
				..f  s season2=$o(SingleClassNew(locId2,year2,season2)) q:season2=""  d
					...s class2=0,levelNum=0
					...f  s class2=$o(SingleClassNew(locId2,year2,season2,class2)) q:class2=""  d
						....q:((","_newNoteCate_",")'[(","_class2_","))&(newNoteCate'="")
						....s levelNum=$g(SingleClassNew(locId2,year2,season2,class2))
						....;dateNum：每个月多少；monthNum:一个季度多少;SeasonNum:
						....s allSeasonNum=$g(SingleSeasonNew(locId2,year2,season2))
						....s NewClassArrList(class2_"."_locId2,"Field"_year2_"."_season2_".Num")=levelNum
						....s persent=""
						....i allSeasonNum>0 s persent=$fn((levelNum/allSeasonNum),"",4)*100_"%"
				   		....s NewClassArrList(class2_"."_locId2,"Field"_year2_"."_season2_".Per")=persent

	set JsonStr=##class(CIS.AN.COM.String).ToJson(.NewClassArrList)

	 //w JsonStr
	q JsonStr
}

ClassMethod ConvertToDate(dateVal As %String, defaultStr As %String = "$H") As %String
{
	s dateformatnum=##class(websys.Conversions).DateFormat()
	q:((+dateVal=0)!(dateVal<0)!(dateVal>2980013))&(defaultStr="") ""
	q:(+dateVal=0)!(dateVal<0)!(dateVal>2980013) $zd($h,dateformatnum)
	q $zd(dateVal,dateformatnum)
}

}
