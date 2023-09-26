Class DtPortal.NH.NH21NurFallRisk Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Creator：      程鹏
/// CreatDate：    2019-01-24
/// Description:： 查询跌倒压疮趋势图
/// 1 年  NH21.01.01
/// D ##class(%ResultSet).RunQuery("DtPortal.NH.NH21NurFallRisk","NH210101","2018-01-01","2018-12-31",1,"advSkinUlcer")
Query NH210101(StartDate As %String, EndDate As %String, WardId As %String, Type As %String) As DtPortal.Query(ROWSPEC = "dateDesc,dateCode,value1,value2,radio") [ SqlProc ]
{
}

ClassMethod NH210101Execute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, WardId As %String, Type As %String) As %Status
{
	
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	quit:((StartDate="")||(EndDate="")||(WardId="")||(Type="")) $$$OK
	
	//跌倒Type: advFallDownFill
	//压疮Type: advSkinUlcer
	//管路滑脱Type: advPipeOff
	set ID=""
	Set rset = ##class(%ResultSet).%New("web.DHCADVINTERFACE:QueryReportType")
	Do rset.Execute("H",Type)
	While (rset.Next()) {
		
		set ID=rset.Data("parentid")
	}
	
	quit:ID="" $$$OK
	k ^||TMPPortalNH210101
	
	set year=$p(StartDate,"-",1)

	set LocWard=$P(^PAWARD(WardId),"^",5)
	
	Set rset = ##class(%ResultSet).%New("web.DHCADVINTERFACE:QueryReportDetail")
	Do rset.Execute(StartDate,EndDate,LocWard,ID,"","A","","","")
	
	While (rset.Next()) {

		set reportDate=rset.Data("emrdate")
		set EpisodeId= rset.Data("EpisodeId")
		continue:EpisodeId=""
		
		set month=$p(reportDate,"-",2)
		set ^||TMPPortalNH210101(+month,"value1")=+$g(^||TMPPortalNH210101(+month,"value1"))+1
	}
	
	set NowYear=$p($zd(+$h,3),"-",1)
	set NowMonth=$p($zd(+$h,3),"-",2)
	set NowYearMonth=$p($zd(+$h,3),"-",1)_"-"_$p($zd(+$h,3),"-",2)
	
	
	set statDate=$p(StartDate,"-",1)_"-"_$p(StartDate,"-",2)
	set endDate=$p(EndDate,"-",1)_"-"_$p(EndDate,"-",2)
	
	if year=NowYear
	{
		set sDate=NowYearMonth
		set eDate=NowYearMonth
		s dateType="currentMonth"
		
		//取除本月的数据
		s kpiRule="SK0122"
		s filterRule="SK0122:([{WARD} = "_WardId_"])"
		s mode="H"
		s contract=""
		
		s rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",sDate,eDate,dateType,kpiRule,filterRule,mode,contract)
		While rs.Next(.sc) {
			If $$$ISERR(sc) Quit
			set mDate=rs.Data("month")
			set month=$p($p(rs.Data("month"),"年",2),"月",1)
			set value2=rs.Data("kpiValueCol1")
			set ^||TMPPortalNH210101(+month,"value2")=+$g(^||TMPPortalNH210101(+month,"value2"))+value2
			
		}
	}
	if statDate'=NowYearMonth
	{
		
		set last=+NowMonth-1
		set sDate=statDate
		set eDate=$p($zd(+$h,3),"-",1)_"-"_last
		
		s dateType="byMonth"
		s kpiRule="SK0122"
		s filterRule="SK0122:([{WARD} = "_WardId_"])"
		s mode="H"
		s contract=""
		
		s rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",sDate,eDate,dateType,kpiRule,filterRule,mode,contract)
		While rs.Next(.sc) {
			If $$$ISERR(sc) Quit
			set mDate=rs.Data("month")
			set month=$p($p(rs.Data("month"),"年",2),"月",1)
			set value2=rs.Data("kpiValueCol1")
			set ^||TMPPortalNH210101(+month,"value2")=+$g(^||TMPPortalNH210101(+month,"value2"))+value2
			
		}
	}
	b
	for index=1:1:12
	{
		set value1=+$g(^||TMPPortalNH210101(index,"value1"))
		set value2=+$g(^||TMPPortalNH210101(index,"value2"))
		set radio=0
		set:value2'=0 radio=$fn(value1/value2*100,"",2)
		
		set dateDesc=year_"年"_index_"月"
		set dateCode=year_"-"_index
		set Data=$lb(dateDesc,dateCode,value1,value2,radio)
 		set ^||CacheTemp(repid,ind)=Data	
 		set ind=ind+1
		
	}
	
	Quit $$$OK
}

}
