Class DtPortal.NH.NH16Transfer Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator： bmz
/// CreatDate： 2019-01-18
/// Description: 查询出入转相关指标数据
/// 期初留院、期末留院、出院、入院、转入、转出、床位使用率
/// Input:wardId、startDate、endDate
/// Return：按月返回指标相关数据
/// Debug：d ##class(%ResultSet).RunQuery("DtPortal.NH.NH16Transfer","NH160101","1","2018-11-01","2019-01-31")
/// 服务代码：NH16.01.01
Query NH160101(wardId As %String = "", startDate As %String, endDate As %String) As DtPortal.Query(ROWSPEC = "monthChina,yearMonth,QCLYRS,QMLYRS,XYRS,CYRS,RYRS,ZRRS,ZCRS,CWS,CWSYL") [ SqlProc ]
{
}

ClassMethod NH160101Execute(ByRef qHandle As %Binary, wardId As %String = "", startDate As %String, endDate As %String) As %Status
{
	Set repid1=$I(^||CacheTemp)
	Set ind1=1
	Set qHandle=$lb(0,repid1,0)
	set mode="H"
	
	q:(wardId="")||(startDate="")||(endDate="") $$$OK
	
	
	//SK0122:WARD-现有人数（病区）  1、期初留院人数-该月第一天的数据   2、期末留院-该月最后一天数据（当月的取昨天的数据） 3、床日数-该月该指标数据的累加
	//SK0120:WARD-出院人数   出入转表相关口径
	//SK0117:WARD-入院人数  SK0118:WARD-转入人数  SK0119:WARD-转出人数   出入转表相关口径
	//SK0122:WARD-现有人数/SK0123:WARD-实有床位数
	
	q:($l(startDate,"-")'=2)&&($l(startDate,"-")'=3) $$$OK
	q:($l(endDate,"-")'=2)&&($l(endDate,"-")'=3) $$$OK
	
	//开始年月、结束年月查询月数据
	i $l(startDate,"-")=2 s startYearMonth=startDate
	e  i $l(startDate,"-")=3 s startYearMonth=$p(startDate,"-")_"-"_$p(startDate,"-",2)
	i $l(endDate,"-")=2 s endYearMonth=endDate
	e  i $l(endDate,"-")=3 s endYearMonth=$p(endDate,"-")_"-"_$p(endDate,"-",2)
	
	set currDate=$zd(+$h,3)
	s yesDate=$zd(+$h-1,3)
	set currYearMonth=$p(currDate,"-")_"-"_$p(currDate,"-",2)
	
	
	
	//如果查询日期大于当前日期，结束日期改为当前月
	if ($zdh(endYearMonth_"-01",3)>+$h){
		s endYearMonth=currYearMonth
	}
	
	//如果是结束日期是当前月，而且当前日期是1号，结束月份取上个月
	if ((endYearMonth=currYearMonth)&&($p(currDate,"-",3)="01")){
		
		s endYearMonth=$p(yesDate,"-")_"-"_$p(yesDate,"-",2)
	}
	
	
	
	//开始大于结束，返回空
	q:$zdh(startYearMonth_"-01",3)>$zdh(endYearMonth_"-01",3) $$$OK
	
	set kpiRule="SK0122:WARD,SK0120:WARD,SK0117:WARD,SK0118:WARD,SK0119:WARD,SK0123:WARD"
	set dateType="byMonth"
	set filterRule="SK0122:({WARD}="_wardId_"),"_"SK0120:({WARD}="_wardId_"),"_"SK0117:({WARD}="_wardId_"),"_"SK0118:({WARD}="_wardId_"),"_"SK0119:({WARD}="_wardId_"),"_"SK0123:({WARD}="_wardId_")"
	k ^||TMPPortalNHKPI01
	
	
	
	
	set rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",startYearMonth,endYearMonth,dateType,kpiRule,filterRule,mode,"")
	While rs.Next(.sc) {
		If $$$ISERR(sc) Quit
		s date=rs.Data("month")
		
		if (date=($p(currDate,"-")_"年"_$p(currDate,"-",2)_"月")){
			//当前月不查询，在下面单独累加
			continue
		} 
		
		s ^||TMPPortalNHKPI01(date,"XYRS")=$g(^||TMPPortalNHKPI01(date,"XYRS"))+$g(rs.Data("kpiValueCol1"))   //现有人数（总床日数）
		s ^||TMPPortalNHKPI01(date,"CYRS")=$g(^||TMPPortalNHKPI01(date,"CYRS"))+$g(rs.Data("kpiValueCol2"))  //出院人数
		s ^||TMPPortalNHKPI01(date,"RYRS")=$g(^||TMPPortalNHKPI01(date,"RYRS"))+$g(rs.Data("kpiValueCol3"))  //入院人数
		s ^||TMPPortalNHKPI01(date,"ZRRS")=$g(^||TMPPortalNHKPI01(date,"ZRRS"))+$g(rs.Data("kpiValueCol4"))  //转入人数
		s ^||TMPPortalNHKPI01(date,"ZCRS")=$g(^||TMPPortalNHKPI01(date,"ZCRS"))+$g(rs.Data("kpiValueCol5"))  //转出人数
		s ^||TMPPortalNHKPI01(date,"CWS")=$g(^||TMPPortalNHKPI01(date,"CWS"))+$g(rs.Data("kpiValueCol6"))  //实有床位数
		
	}
	
	//b ;998
	//日期范围包含当月，就获取当月的数据累加
	if ($zdh(currYearMonth_"-01",3)<=$zdh(endYearMonth_"-01",3))&&($zdh(currYearMonth_"-01",3)>=$zdh(startYearMonth_"-01",3)) {
		set kpiRule="SK0122:WARD,SK0120:WARD,SK0117:WARD,SK0118:WARD,SK0119:WARD,SK0123:WARD"
		set dateType=""
		set startDateDay=##Class(DtPortal.Common.PublicService).getFirstDayOfMonth(currYearMonth,1)
		set endDateDay=##Class(DtPortal.Common.PublicService).getLastDayOfMonth(currYearMonth,1)
		set filterRule="SK0122:({WARD}="_wardId_"),"_"SK0120:({WARD}="_wardId_"),"_"SK0117:({WARD}="_wardId_"),"_"SK0118:({WARD}="_wardId_"),"_"SK0119:({WARD}="_wardId_"),"_"SK0123:({WARD}="_wardId_")"
		set rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",startDateDay,endDateDay,dateType,kpiRule,filterRule,mode,"")
		While rs.Next(.sc) {
			If $$$ISERR(sc) Quit
			s date=rs.Data("month")
			s date=$p(date,"月")_"月"
			s ^||TMPPortalNHKPI01(date,"XYRS")=$g(^||TMPPortalNHKPI01(date,"XYRS"))+$g(rs.Data("kpiValueCol1"))   //现有人数（总床日数）
			s ^||TMPPortalNHKPI01(date,"CYRS")=$g(^||TMPPortalNHKPI01(date,"CYRS"))+$g(rs.Data("kpiValueCol2"))  //出院人数
			s ^||TMPPortalNHKPI01(date,"RYRS")=$g(^||TMPPortalNHKPI01(date,"RYRS"))+$g(rs.Data("kpiValueCol3"))  //入院人数
			s ^||TMPPortalNHKPI01(date,"ZRRS")=$g(^||TMPPortalNHKPI01(date,"ZRRS"))+$g(rs.Data("kpiValueCol4"))  //转入人数
			s ^||TMPPortalNHKPI01(date,"ZCRS")=$g(^||TMPPortalNHKPI01(date,"ZCRS"))+$g(rs.Data("kpiValueCol5"))  //转出人数
			s ^||TMPPortalNHKPI01(date,"CWS")=$g(^||TMPPortalNHKPI01(date,"CWS"))+$g(rs.Data("kpiValueCol6"))  //实有床位数
			
			
		}
	}
	
	
	
	set kpiRule="SK0122:WARD"
	set dateType=""
	set filterRule="SK0122:({WARD}="_wardId_")"
	
	set startDateDay=##Class(DtPortal.Common.PublicService).getFirstDayOfMonth(startYearMonth,1)
	set endDateDay=##Class(DtPortal.Common.PublicService).getLastDayOfMonth(endYearMonth,1)
	
	//期初取上个月最后一天
	set startDateDay=$zd($zdh(startDateDay,3)-1,3)
	set rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",startDateDay,endDateDay,dateType,kpiRule,filterRule,mode,"")
	While rs.Next(.sc) {
		If $$$ISERR(sc) Quit
		s date=rs.Data("month")
		s dateMonth=$p(date,"月")_"月"
		s dayValue=$p(date,"月",2)
		
		/*
		if (dayValue="01日"){
			s ^||TMPPortalNHKPI01(dateMonth,"QCLYRS")=$g(^||TMPPortalNHKPI01(dateMonth,"QCLYRS"))+$g(rs.Data("kpiValueCol1"))   //期初留院人数
		}
		*/
		
		
		s dateMonthParam=$tr(dateMonth,"年","-")
		s dateMonthParam=$tr(dateMonthParam,"月","")
		s lastDate=##Class(DtPortal.Common.PublicService).getLastDayOfMonth(dateMonthParam,1)
		s lastDateChina=$p(lastDate,"-")_"年"_$p(lastDate,"-",2)_"月"_$p(lastDate,"-",3)_"日"
		if (lastDateChina=date){
			
			
			s QCMonthTemp=$tr(date,"年","-")
			s QCMonthTemp=$tr(QCMonthTemp,"月","-")
			s QCMonthTemp=$tr(QCMonthTemp,"日","")
			s QCMonthTemp=$zd($zdh(QCMonthTemp,3)+1,3)
			
			s QCYearMonth=$p(QCMonthTemp,"-",1)_"年"_$p(QCMonthTemp,"-",2)_"月"
			
			s firstQMMonthTemp=$p(startDateDay,"-",1)_"年"_$p(startDateDay,"-",2)_"月"
			if (firstQMMonthTemp'=dateMonth){
				s ^||TMPPortalNHKPI01(dateMonth,"QMLYRS")=$g(^||TMPPortalNHKPI01(dateMonth,"QMLYRS"))+$g(rs.Data("kpiValueCol1"))   //期末留院人数（第一个期末不获取）
			}
			
			s endQMMonthTemp=$p(endDateDay,"-",1)_"年"_$p(endDateDay,"-",2)_"月"
			if (endQMMonthTemp'=dateMonth){
				s ^||TMPPortalNHKPI01(QCYearMonth,"QCLYRS")=$g(^||TMPPortalNHKPI01(QCYearMonth,"QCLYRS"))+$g(rs.Data("kpiValueCol1"))  //期初是期末的下一个期初（最后一个期末不获取期初）
			}
			
			//w !,"期末="_dateMonth_$g(^||TMPPortalNHKPI01(dateMonth,"QMLYRS"))
			//w !,"期初="_QCYearMonth_$g(^||TMPPortalNHKPI01(QCYearMonth,"QCLYRS"))
			//b ;02
		}
		
		
		
		
	}
	//b
	s monthChina=""
	for {
		set monthChina=$o(^||TMPPortalNHKPI01(monthChina))
		q:monthChina=""
		set XYRS=+$g(^||TMPPortalNHKPI01(monthChina,"XYRS")) //现有人数（总床日数）
		set CYRS=+$g(^||TMPPortalNHKPI01(monthChina,"CYRS"))  //出院人数
		set RYRS=+$g(^||TMPPortalNHKPI01(monthChina,"RYRS"))  //入院人数
		set ZRRS=+$g(^||TMPPortalNHKPI01(monthChina,"ZRRS"))  //转入人数
		set ZCRS=+$g(^||TMPPortalNHKPI01(monthChina,"ZCRS"))  //转出人数
		set CWS=+$g(^||TMPPortalNHKPI01(monthChina,"CWS"))  //床位数
		set QCLYRS=+$g(^||TMPPortalNHKPI01(monthChina,"QCLYRS"))  //期初留院人数
		set QMLYRS=+$g(^||TMPPortalNHKPI01(monthChina,"QMLYRS"))  //期末留院人数
		set CWSYL=""   //床位使用率
		if (CWS'=0){
			set CWSYL=$fn(XYRS*100/CWS,"",2)
		}
		set yearMonth=$tr(monthChina,"年","-")
		set yearMonth=$tr(yearMonth,"月","")
		s ^||CacheTemp(repid1,ind1)=$lb(monthChina,yearMonth,QCLYRS,QMLYRS,XYRS,CYRS,RYRS,ZRRS,ZCRS,CWS,CWSYL)
 		s ind1=ind1+1	
	}
	
	
	
	Quit $$$OK
}

}
