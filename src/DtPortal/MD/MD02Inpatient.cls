/// 名称: DHCWL.MKPIService.MKPIQuery
/// 描述: 指标区间数据的查询
/// 编写者：mgl
/// 编写日期:2014-10-11
/// 
Class DtPortal.MD.MD02Inpatient Extends %RegisteredObject [ Not ProcedureBlock ]
{

// MD02.02.01查询指定时间内出入转病人数	

// d ##class(%ResultSet).RunQuery("DtPortal.MD.MD02Inpatient","MainData","2018","2018","byMonth","","","",)

Query MainData(startDate As %String, endDate As %String, dateType As %String = "", kpiRule As %Text, filterRule As %Text = "", mode = "H", contract = "", hospitalId As %String = "") As DtPortal.Query(ROWSPEC = "SDate:%String,CYRS:%Float,CWSYL1:%Float") [ SqlProc ]
{
}

ClassMethod MainDataExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, dateType As %String = "", kpiRule As %Text, filterRule As %Text = "", mode = "H", contract = "", hospitalId As %String = "") As %Status
{
	n (qHandle,startDate,endDate,dateType,kpiRule,filterRule,mode,contract, hospitalId)
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	k ^TEMPDHCWL($j)
	s dateType="byMonth"
	s currDate=$zd(+$h,3)
	s currYear=$p(currDate,"-",1)
	set currMonth=$p(currDate,"-",1)_"年"_$p(currDate,"-",2)_"月"
	//实有床位（SK0143:PatLoc），现有人数（SK0142:PatLoc),入院人数（SK0137:PatLoc），
	//转入人数（SK0138:PatLoc）,转出人数（SK0139:PatLoc）,出院人数（SK0140:PatLoc）
	//
	s kpiRule="SK0143:PatLoc,SK0142:PatLoc,SK0140:PatLoc"
	i hospitalId'="" S filterRule="SK0143:({PatLoc.HospIdByLoc}="_hospitalId_")"
	s endDate=startDate
	s ^TEMPDHCWL($j,startDate_"年01月","CYRS")=0,^TEMPDHCWL($j,startDate_"年01月","XYRS")=0,^TEMPDHCWL($j,startDate_"年01月","CWS")=0
	s ^TEMPDHCWL($j,startDate_"年02月","CYRS")=0,^TEMPDHCWL($j,startDate_"年02月","XYRS")=0,^TEMPDHCWL($j,startDate_"年02月","CWS")=0
	s ^TEMPDHCWL($j,startDate_"年03月","CYRS")=0,^TEMPDHCWL($j,startDate_"年03月","XYRS")=0,^TEMPDHCWL($j,startDate_"年03月","CWS")=0
	s ^TEMPDHCWL($j,startDate_"年04月","CYRS")=0,^TEMPDHCWL($j,startDate_"年04月","XYRS")=0,^TEMPDHCWL($j,startDate_"年04月","CWS")=0
	s ^TEMPDHCWL($j,startDate_"年05月","CYRS")=0,^TEMPDHCWL($j,startDate_"年05月","XYRS")=0,^TEMPDHCWL($j,startDate_"年05月","CWS")=0
	s ^TEMPDHCWL($j,startDate_"年06月","CYRS")=0,^TEMPDHCWL($j,startDate_"年06月","XYRS")=0,^TEMPDHCWL($j,startDate_"年06月","CWS")=0
	s ^TEMPDHCWL($j,startDate_"年07月","CYRS")=0,^TEMPDHCWL($j,startDate_"年07月","XYRS")=0,^TEMPDHCWL($j,startDate_"年07月","CWS")=0
	s ^TEMPDHCWL($j,startDate_"年08月","CYRS")=0,^TEMPDHCWL($j,startDate_"年08月","XYRS")=0,^TEMPDHCWL($j,startDate_"年08月","CWS")=0
	s ^TEMPDHCWL($j,startDate_"年09月","CYRS")=0,^TEMPDHCWL($j,startDate_"年09月","XYRS")=0,^TEMPDHCWL($j,startDate_"年09月","CWS")=0
	s ^TEMPDHCWL($j,startDate_"年10月","CYRS")=0,^TEMPDHCWL($j,startDate_"年10月","XYRS")=0,^TEMPDHCWL($j,startDate_"年10月","CWS")=0
	s ^TEMPDHCWL($j,startDate_"年11月","CYRS")=0,^TEMPDHCWL($j,startDate_"年11月","XYRS")=0,^TEMPDHCWL($j,startDate_"年11月","CWS")=0
	s ^TEMPDHCWL($j,startDate_"年12月","CYRS")=0,^TEMPDHCWL($j,startDate_"年12月","XYRS")=0,^TEMPDHCWL($j,startDate_"年12月","CWS")=0
	
	s startDateTemp=startDate
	s startDate=startDate_"-01"
	s endDate=endDate_"-12"
	
	s rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",startDate,endDate,dateType,kpiRule,filterRule,mode,contract)

	While rs.Next(.sc) {
		If $$$ISERR(sc) Quit
		s date=rs.Data("month")
		if (month=currMonth){
			continue
		} 
		s ^TEMPDHCWL($j,date,"CYRS")=$g(^TEMPDHCWL($j,date,"CYRS"))+rs.Data("kpiValueCol3")
		s ^TEMPDHCWL($j,date,"XYRS")=$g(^TEMPDHCWL($j,date,"XYRS"))+rs.Data("kpiValueCol2")
		s ^TEMPDHCWL($j,date,"CWS")=$g(^TEMPDHCWL($j,date,"CWS"))+rs.Data("kpiValueCol1")

	}
	
	
	
	if (startDateTemp=currYear){
		s dateType="currentMonth"
		s rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",startDate,endDate,dateType,kpiRule,filterRule,mode,contract)

		While rs.Next(.sc) {
			If $$$ISERR(sc) Quit
			s date=rs.Data("month")
			s monthDate=$p(date,"月",1)_"月"

			s ^TEMPDHCWL($j,monthDate,"CYRS")=$g(^TEMPDHCWL($j,monthDate,"CYRS"))+rs.Data("kpiValueCol3")
			s ^TEMPDHCWL($j,monthDate,"XYRS")=$g(^TEMPDHCWL($j,monthDate,"XYRS"))+rs.Data("kpiValueCol2")
		
			s ^TEMPDHCWL($j,monthDate,"CWS")=$g(^TEMPDHCWL($j,monthDate,"CWS"))+rs.Data("kpiValueCol1")
		
			

		}
	}
	b ;09
	s SDate="" f  s SDate=$o(^TEMPDHCWL($j,SDate)) q:SDate=""  d
	.s lastmonth=$p($p(SDate,"年",2),"月",1)
	.s nowmonth=$p($zd($p($h,",",1),3),"-",2)
	.s lastyear=$p(SDate,"年",1)
	.s nowyear=$p($zd($p($h,",",1),3),"-",1)
	.i lastyear=nowyear q:lastmonth>nowmonth
	.s CYRS=$g(^TEMPDHCWL($j,SDate,"CYRS"))
	.s XYRS=$g(^TEMPDHCWL($j,SDate,"XYRS"))
	.s CWS=$g(^TEMPDHCWL($j,SDate,"CWS"))
	.i CWS'=0 s CWSYL=$fn(XYRS/CWS*100,"",2)
	.else  s CWSYL=0
	.s ^||CacheTemp(repid,ind)=$lb(SDate,CYRS,CWSYL)
	.s ind=ind+1
	k ^TEMPDHCWL($j)
	Quit $$$OK
}

// MD02.02.02查询指定时间内出入转病人科室分布	

// d ##class(%ResultSet).RunQuery("DtPortal.MD.MD02Inpatient","MainDataMx","2015-05","2015-05","byMonth","","","",)

Query MainDataMx(startDate As %String, endDate As %String, dateType As %String = "", kpiRule As %Text, filterRule As %Text = "", mode = "H", contract = "", hospitalId As %String = "") As DtPortal.Query(ROWSPEC = "dep:%String,RYRS:%Float,CYRS:%Float,ZRRS:%Float,ZCRS:%Float,CWSYL:%Float") [ SqlProc ]
{
}

ClassMethod MainDataMxExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, dateType As %String = "", kpiRule As %Text, filterRule As %Text = "", mode = "H", contract = "", hospitalId As %String = "") As %Status
{
	n (qHandle,startDate,endDate,dateType,kpiRule,filterRule,mode,contract, hospitalId)
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	k ^TEMPDHCWL($j)
	
	s dateType="byMonth"
	////实有床位（SK0143:PatLoc），现有人数（SK0142:PatLoc),入院人数（SK0137:PatLoc），
	//转入人数（SK0138:PatLoc）,转出人数（SK0139:PatLoc）,出院人数（SK0140:PatLoc）
	s kpiRule="SK0143:PatLoc,SK0142:PatLoc,SK0137:PatLoc,SK0138:PatLoc,SK0139:PatLoc,SK0140:PatLoc"
	i hospitalId'="" S filterRule="SK0143:({PatLoc.HospIdByLoc}="_hospitalId_")"
	;s mode="R"

	s rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",startDate,endDate,dateType,kpiRule,filterRule,mode,contract)
	While rs.Next(.sc) {
		If $$$ISERR(sc) Quit
		s depdesc=rs.Data("dimDesCol1")
		s ^TEMPDHCWL($j,depdesc,"RYRS")=rs.Data("kpiValueCol3")
		s ^TEMPDHCWL($j,depdesc,"CYRS")=rs.Data("kpiValueCol6")
		s ^TEMPDHCWL($j,depdesc,"ZRRS")=rs.Data("kpiValueCol4")
		s ^TEMPDHCWL($j,depdesc,"ZCRS")=rs.Data("kpiValueCol5")
		s ^TEMPDHCWL($j,depdesc,"XYRS")=rs.Data("kpiValueCol2")
		s ^TEMPDHCWL($j,depdesc,"CWS")=rs.Data("kpiValueCol1")
	
	}
	s dep="" f  s dep=$o(^TEMPDHCWL($j,dep)) q:dep=""  d
	.s RYRS=$g(^TEMPDHCWL($j,dep,"RYRS"))
	.i RYRS="" s RYRS=0
	.s CYRS=$g(^TEMPDHCWL($j,dep,"CYRS"))
	.i CYRS="" s CYRS=0
	.s ZRRS=$g(^TEMPDHCWL($j,dep,"ZRRS"))
	.i ZRRS="" s ZRRS=0
	.s ZCRS=$g(^TEMPDHCWL($j,dep,"ZCRS"))
	.i ZCRS="" s ZCRS=0
	.s XYRS=$g(^TEMPDHCWL($j,dep,"XYRS"))
	.i XYRS="" s XYRS=0
	.s CWS=$g(^TEMPDHCWL($j,dep,"CWS"))
	.i (CWS'="")&&(CWS'=0) s CWSYL=$fn(XYRS/CWS*100,"",2)_"%"
	.e  s CWSYL="0.00%"
	.s ^||CacheTemp(repid,ind)=$lb(dep,RYRS,CYRS,ZRRS,ZCRS,CWSYL)
	.s ind=ind+1
	k ^TEMPDHCWL($j)
	Quit $$$OK
}

}
