Class DtPortal.OD.OD11VisitingStatistics Extends %RegisteredObject [ ProcedureBlock ]
{

// d ##class(%ResultSet).RunQuery("DtPortal.OD.OD11VisitingStatistics","OD110102","2019-01-01","2019-01-25")

/// Description	:	OD11.01.02 查询就诊时段详情
/// Input		:	StarDate  开始日期(格式:2018-01-01)
/// 			:	EndDate  结束日期(格式:2018-01-31)
/// 			:	LocID  科室ID
Query OD110102(StartDate As %String, EndDate As %String, ifOPEPConf As %String = "") As DtPortal.Query(ROWSPEC = "ind,loc,locDesc,hour7,hour8,hour9,hour10,hour11,hour12,hour13,hour14,hour15,hour16,hour17,hour18") [ SqlProc ]
{
}

ClassMethod OD110102Execute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, ifOPEPConf As %String = "") As %Status
{
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	k ^||TMPPortalOD110102
	
	s dateType="byMonth"
	s kpiRule="DtPortal0002"
	s filterRule=""
	s mode="H"
	s contract=""
	s rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",StartDate,EndDate,dateType,kpiRule,filterRule,mode,contract)

	While rs.Next(.sc) {
		If $$$ISERR(sc) Quit
		set locID=rs.Data("dimIdCol1")
		if ((ifOPEPConf'="")){
			if (ifOPEPConf'["E"){
				set ifEm=##class(DtPortal.Common.PublicService).ifEmDept(locID)
				continue:ifEm=1
			}
			
		}
		set hour=rs.Data("dimIdCol2")
		//w hour,!
		set ^||TMPPortalOD110102(locID)=rs.Data("dimDesCol1")
		set ^||TMPPortalOD110102(locID,hour)=$g(^||TMPPortalOD110102(locID,hour))+rs.Data("kpiValueCol1")
		
	}
	
	set loc=""
	for
	{
		set loc=$o(^||TMPPortalOD110102(loc))
		quit:loc=""
		
		set locDesc=^||TMPPortalOD110102(loc)
		set hour7=0,hour8=0,hour9=0,hour10=0,hour11=0,hour12=0,hour13=0,hour14=0,hour15=0,hour16=0,hour17=0,hour18=0
		
		set hour7=+$g(^||TMPPortalOD110102(loc,"07:00~8:00"))
		set hour8=+$g(^||TMPPortalOD110102(loc,"08:00~9:00"))
		set hour9=+$g(^||TMPPortalOD110102(loc,"09:00~10:00"))
		set hour10=+$g(^||TMPPortalOD110102(loc,"10:00~11:00"))
		set hour11=+$g(^||TMPPortalOD110102(loc,"11:00~12:00"))
		set hour12=+$g(^||TMPPortalOD110102(loc,"12:00~13:00"))
		set hour13=+$g(^||TMPPortalOD110102(loc,"13:00~14:00"))
		set hour14=+$g(^||TMPPortalOD110102(loc,"14:00~15:00"))
		set hour15=+$g(^||TMPPortalOD110102(loc,"15:00~16:00"))
		set hour16=+$g(^||TMPPortalOD110102(loc,"16:00~17:00"))
		set hour17=+$g(^||TMPPortalOD110102(loc,"17:00~18:00"))
		set hour18=+$g(^||TMPPortalOD110102(loc,"18:00~19:00"))
		
		Set Data=$lb(ind,loc,locDesc,hour7,hour8,hour9,hour10,hour11,hour12,hour13,hour14,hour15,hour16,hour17,hour18)
		Set ^||CacheTemp(repid,ind)=Data
		Set ind=ind+1
		
	}
	k ^||TMPPortalOD110102
	Quit $$$OK
}

}
