/// 名称: DtPortal.OD.OD08DepOpenRateTotal
/// 描述: 查询门诊准时开诊率
/// 编写者：程鹏
/// 编写日期:2019-1-23
/// 
Class DtPortal.OD.OD08DepOpenRateTotal Extends %RegisteredObject [ ProcedureBlock ]
{

// OD08.01.01查询各门诊准时开诊率

// 入参:  StartDate      开始日期 (2019-01-01)

// 		  EndDate	     结束日期 (2019-01-01)

//        ScheduleRate   准时开诊率(准时开诊率范围(如95)^大约,小于, 如 95^2  取大于95的 )

// d ##class(%ResultSet).RunQuery("DtPortal.OD.OD08DepOpenRateTotal","OD080101","2019-03-01","2019-03-15","95^1")

Query OD080101(StartDate As %String, EndDate As %String, ScheduleRate As %String, ifOPEPConf As %String = "") As DtPortal.Query(ROWSPEC = "ind,locID,locdesc,OnScheduleNum,ScheduleNum,radio") [ SqlProc ]
{
}

ClassMethod OD080101Execute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, ScheduleRate As %String, ifOPEPConf As %String = "") As %Status
{
	
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)

	set StartDate=$p(StartDate,"-",1)_"-"_$p(StartDate,"-",2)
	set EndDate=$p(EndDate,"-",1)_"-"_$p(EndDate,"-",2)
	
	k ^||TMPPortalOD080101
	
	s kpiRule="DtPortal0013,DtPortal0014"
	s mode="H"
	s dateType="byMonth"
	set filterRule=""
	set contract=""
	
	s ScheduleRate1="",ScheduleRate2=""
	i ScheduleRate'="" s ScheduleRate1=$p(ScheduleRate,"^",1),ScheduleRate2=$p(ScheduleRate,"^",2)	

	s rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",StartDate,EndDate,dateType,kpiRule,filterRule,mode,contract)
	
	While rs.Next(.sc) {
		If $$$ISERR(sc) Quit
		set locid=rs.Data("dimIdCol1") 
		if ((ifOPEPConf'="")){
			if (ifOPEPConf'["E"){
				set ifEm=##class(DtPortal.Common.PublicService).ifEmDept(locid)
				continue:ifEm=1
			}
			
		}
		set locdesc=rs.Data("dimDesCol1")
		
		set ^||TMPPortalOD080101(locid,"desc")=locdesc
		set ^||TMPPortalOD080101(locid,"Schedule")=+$g(^||TMPPortalOD080101(locid,"Schedule"))+rs.Data("kpiValueCol1")
		set ^||TMPPortalOD080101(locid,"NotSchedule")=+$g(^||TMPPortalOD080101(locid,"NotSchedule"))+rs.Data("kpiValueCol2")

	}
	b
	set locID=""
	for
	{
		set locID=$o(^||TMPPortalOD080101(locID))
		quit:locID=""
		
		set ScheduleNum=+$g(^||TMPPortalOD080101(locID,"Schedule"))
		set NotScheduleNum=+$g(^||TMPPortalOD080101(locID,"NotSchedule"))
		set locdesc=$g(^||TMPPortalOD080101(locID,"desc"))
		
		set OnScheduleNum=ScheduleNum-NotScheduleNum
		
		set radio=0
		set:ScheduleNum'=0 radio=$fn(OnScheduleNum/ScheduleNum*100,"",2)
		continue:((ScheduleRate2=1)&&(radio>=ScheduleRate1))
		continue:((ScheduleRate2=2)&&(radio<ScheduleRate1))
		set radio=radio_"%"
		
		set ^||CacheTemp(repid,ind)=$lb(ind,locID,locdesc,OnScheduleNum,ScheduleNum,radio)
 		set ind=ind+1
	}
		
	k ^||TMPPortalOD080101
	Quit $$$OK
}

// OD08.01.02查询医生指标数据的明细信息	

// 入参:  LocID      	 科室id

// 入参:  StartDate      开始日期 (2019-01-01)

// 		  EndDate	     结束日期 (2019-01-01)

// d ##class(%ResultSet).RunQuery("DtPortal.OD.OD08DepOpenRateTotal","OD080102","1","2019-03-01","2019-01-31")

Query OD080102(LocID As %String, StartDate As %String, EndDate As %String) As DtPortal.Query(ROWSPEC = "ind,docid,docdesc,session,sessionType,OnScheduleNum,ScheduleNum,radio") [ SqlProc ]
{
}

ClassMethod OD080102Execute(ByRef qHandle As %Binary, LocID As %String, StartDate As %String, EndDate As %String) As %Status
{
	
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	set StartDate=$p(StartDate,"-",1)_"-"_$p(StartDate,"-",2)
	set EndDate=$p(EndDate,"-",1)_"-"_$p(EndDate,"-",2)
	
	k ^||TMPPortalOD080102
	
	s kpiRule="DtPortal0013,DtPortal0014"
	s mode="H"
	s dateType="byMonth"
	set filterRule="DtPortal0013:([{PatLoc} = "_LocID_"]),DtPortal0014:([{PatLoc} = "_LocID_"])"
	set contract=""

	s rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",StartDate,EndDate,dateType,kpiRule,filterRule,mode,contract)
	
	While rs.Next(.sc) {
		If $$$ISERR(sc) Quit
		set docid=rs.Data("dimIdCol2") 
		set docdesc=rs.Data("dimDesCol2")
		set session=rs.Data("dimIdCol3")

		set sessionType=rs.Data("dimDesCol3")
		
		set ^||TMPPortalOD080102(docid)=docdesc
		set ^||TMPPortalOD080102(docid,session)=sessionType
		
		set ^||TMPPortalOD080102(docid,session,"Schedule")=$g(^||TMPPortalOD080102(docid,session,"Schedule"))+rs.Data("kpiValueCol1")
		set ^||TMPPortalOD080102(docid,session,"NotSchedule")=$g(^||TMPPortalOD080102(docid,session,"NotSchedule"))+rs.Data("kpiValueCol2")

	}
	
	set docid=""
	for
	{
		set docid=$O(^||TMPPortalOD080102(docid))
		quit:docid=""
		
		set docdesc=$g(^||TMPPortalOD080102(docid))
		set session=""
		for
		{
			set session=$o(^||TMPPortalOD080102(docid,session))
			quit:session=""
			
			set sessionType=$g(^||TMPPortalOD080102(docid,session))
			
			set ScheduleNum=+$g(^||TMPPortalOD080102(docid,session,"Schedule"))
			set NotScheduleNum=+$g(^||TMPPortalOD080102(docid,session,"NotSchedule"))

			
			set OnScheduleNum=ScheduleNum-NotScheduleNum
			
			set radio=0
			set:+ScheduleNum'=0 radio=$fn(OnScheduleNum/ScheduleNum*100,"",2)
			
			set radio=radio_"%"
			set ^||CacheTemp(repid,ind)=$lb(ind,docid,docdesc,session,sessionType,OnScheduleNum,ScheduleNum,radio)
 			set ind=ind+1
		}
	}
	
	k ^||TMPPortalOD080102
	Quit $$$OK
}

// OD08.01.03查询指定时间内信息	

// 入参:  LocID      	 科室id

// 入参:  DocID      	 医生id

// 入参:  SessionID      	 出诊级别id

// 入参:  StartDate      开始日期 (2019-01-01)

// 		  EndDate	     结束日期 (2019-01-01)

// d ##class(%ResultSet).RunQuery("DtPortal.OD.OD08DepOpenRateTotal","OD080103","1",175,5,"2019-01-01","2019-01-23")

Query OD080103(IocID As %String, DocID As %String, SessionID As %String, StartDate As %String, EndDate As %String) As DtPortal.Query(ROWSPEC = "ind,date,TimeRangeDesc,lateDesc") [ SqlProc ]
{
}

ClassMethod OD080103Execute(ByRef qHandle As %Binary, IocID As %String, DocID As %String, SessionID As %String, StartDate As %String, EndDate As %String) As %Status
{
	
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	s kpiRule="DtPortal0014"
	s mode="H"
	s dateType="byDay"
	set filterRule="DtPortal0014:([{PatLoc} = "_IocID_"] && [{AdmDoc} = "_DocID_"] && [{SESS} = "_SessionID_"])"
	set contract=""
	
	s rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",StartDate,EndDate,dateType,kpiRule,filterRule,mode,contract)
	
	While rs.Next(.sc) {
		If $$$ISERR(sc) Quit
		set ASTimeRangeDR=rs.Data("dimIdCol4") 
		s TimeRangeDesc=$p(^DHCTimeRange(ASTimeRangeDR),"^",2)
		set date=rs.Data("month")
		
		set lateDesc="未准时开诊"
		set ^||CacheTemp(repid,ind)=$lb(ind,date,TimeRangeDesc,lateDesc)
		set ind=ind+1
	}

 	
	Quit $$$OK
}

}
