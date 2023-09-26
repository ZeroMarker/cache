/// 科室指标年度平均值报表
/// 
Class dhc.pa.report.uUnitKpiYearReport Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:     初雅莉	
/// CreateDate:  2016-04-18
/// Description: 科室指标年度目标值平均值  
/// Input:       year（年度）frequency(报表中暂时写入Q)
/// Return:     
/// Others:  d ##class(%ResultSet).RunQuery("dhc.pa.report.uUnitKpiYearReport","GetAvgActValue","2015","Q")
Query GetAvgActValue(year As %String, frequency As %String) As %Query(ROWSPEC = "deptdr:%String,dept:%String,kpiDr:%String,kpi:%String,avgValue:%String,kpiCode:%String,level:%Integer,isEnd:%String") [ SqlProc ]
{
}

ClassMethod GetAvgActValueExecute(ByRef qHandle As %Binary, year As %String, frequency As %String) As %Status
{
	
	n (qHandle,year,frequency)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
    q:year="" $$$OK
	k ^depKPIStrTemp
	k ^depKPISumTemp
	k ^deptKPICount
	/*
	1、根据年度，期间类型，获得科室，指标
	2、根据科室，指标，期间类型，年度获得平均值
	*/
	s startQ="",endQ="",lenQ=""
	i frequency="M" s startQ=year_"01",endQ=year_"12"
	i frequency="Q" s startQ=year_"01",endQ=year_"04"
	i frequency="H" s startQ=year_"01",endQ=year_"02"
	i frequency="Y" s startQ=year_"00",endQ=year_"00"
 
	s deptKPIStr="SELECT DISTINCT UnitResultDetail_KPIDr,UnitResultDetail_actValue, "
				_"UnitResultDetail_KPIDr->KPIIndex1_name as kpi , "
				_"UnitResultDetail_KPIDr->KPIIndex1_level as kpilevel, UnitResultDetail_KPIDr->KPIIndex1_code as kpiCode, "
				_"UnitResultDetail_parRef->UnitResult_jxUnitDr as deptDr, "
				_"UnitResultDetail_parRef->UnitResult_jxUnitDr->JXUnit_name as dept  "
				_",UnitResultDetail_KPIDr->KPIIndex1_isEnd AS isEnd " ;2016-05-05 cyl add
				_"FROM dhc_pa_data.UnitResultDetail "
				_"WHERE UnitResultDetail_parRef->UnitResult_period BETWEEN '"_startQ_"' AND '"_endQ_"' "
				_"AND UnitResultDetail_parRef->UnitResult_schemDr->Schem_frequency='"_frequency_"'"
				_" AND UnitResultDetail_actValue IS NOT NULL" ;2016-05-05 cyl add
    s deptKPIresult=##class(%Library.ResultSet).%New()
	d deptKPIresult.Prepare(deptKPIStr)

	d deptKPIresult.Execute()
	s deptKpiList=##class(%Library.ListOfDataTypes).%New()	
	s count=0
    While(deptKPIresult.Next()){
	  s deptdr=deptKPIresult.Data("deptDr")
	  s dept=deptKPIresult.Data("dept")
	  s kpiDr=deptKPIresult.Data("UnitResultDetail_KPIDr")
	  s kpi=deptKPIresult.Data("kpi")
	  s kpiCode=deptKPIresult.Data("kpiCode")
	  s level=deptKPIresult.Data("kpilevel")
	  s isEnd=deptKPIresult.Data("isEnd") ;2016-05-05 cyl add
	  s actValue=deptKPIresult.Data("UnitResultDetail_actValue")
	  i actValue="" s actValue=0
	  //将科室和指标id放在一个list中，用作后面取global的值
	  s deptKpiStr=deptdr_"#"_kpiDr
	  i count=0  d
	  .d deptKpiList.Insert(deptKpiStr)
	  e  d
	  .s findStr=deptKpiList.Find(deptKpiStr)
	  .if findStr="" d
	  ..d deptKpiList.Insert(deptKpiStr)
	  //用来存放actvalue的和的global
	  i $d(^depKPISumTemp(deptdr,kpiDr))=0  d
	  .s ^deptKPICount(deptdr,kpiDr)=1 ;用来统计该科室该指标的记录数 2016-05-05 cyl add
	  .s ^depKPISumTemp(deptdr,kpiDr)=actValue
	  e  d
	  .s ^deptKPICount(deptdr,kpiDr)=$Get(^deptKPICount(deptdr,kpiDr))+1 ;2016-05-05 cyl add
	  .s ^depKPISumTemp(deptdr,kpiDr)=$Get(^depKPISumTemp(deptdr,kpiDr))+actValue
	  //存放deptKpi基本信息
	  i $d(^depKPIStrTemp(deptdr,kpiDr))=0 d 
	  .s ^depKPIStrTemp(deptdr,kpiDr)=deptdr_"^"_dept_"^"_kpiDr_"^"_kpi_"^"_kpiCode_"^"_level_"^"_isEnd ;2016-05-05 cyl edit
	  s count=count+1
	 	  
	}
 	//循环list 取值并计算
 	s listCount=deptKpiList.Count()
 	for k=1:1:listCount d
	.s listStr=deptKpiList.Data(k)
	.s depp=$p(listStr,"#",1)
	.s kpii=$p(listStr,"#",2)
	.s depKPIStrGet=$Get(^depKPIStrTemp(depp,kpii))
	.s deptdr=$p(depKPIStrGet,"^",1)
	.s dept=$p(depKPIStrGet,"^",2)
	.s kpiDr=$p(depKPIStrGet,"^",3)
	.s kpi=$p(depKPIStrGet,"^",4)
	.s deptKPICount=$Get(^deptKPICount(deptdr,kpiDr)) ;2016-05-05 cyl add
	.s avgValue=$Get(^depKPISumTemp(depp,kpii))/deptKPICount  ;2016-05-05 cyl edit
	.s kpiCode=$p(depKPIStrGet,"^",5)
	.s level=$p(depKPIStrGet,"^",6) 
	.s isEnd=$p(depKPIStrGet,"^",7) ;2016-05-05 cyl add
	.d a
	
	k ^depKPIStrTemp
	k ^depKPISumTemp
	k ^deptKPICount
  	q $$$OK
a
    s Data=$lb(deptdr,dept,kpiDr,kpi,$fn(avgValue,"",2),kpiCode,level,isEnd) ;2016-05-05 cyl edit
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetAvgActValueFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAvgActValueExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetAvgActValueClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAvgActValueExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:     初雅莉	
/// CreateDate:  2016-04-18
/// Description: 科室指标年度实际值平均值  
/// Input:       year（年度）frequency(报表中暂时写入Q)
/// Return:     
/// Others:  d ##class(%ResultSet).RunQuery("dhc.pa.report.uUnitKpiYearReport","GetAvgActValue","2015","Q")
Query GetAvgTValue(year As %String, frequency As %String) As %Query(ROWSPEC = "deptdr:%String,dept:%String,kpiDr:%String,kpi:%String,avgValue:%String,kpiCode:%String,level:%Integer,isEnd:%String") [ SqlProc ]
{
}

ClassMethod GetAvgTValueExecute(ByRef qHandle As %Binary, year As %String, frequency As %String) As %Status
{
	
	n (qHandle,year,frequency)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
    q:year="" $$$OK
	k ^depKPIStrTemp
	k ^depKPISumTemp
	k ^deptKPICount
	/*
	1、根据年度，期间类型，获得科室，指标
	2、根据科室，指标，期间类型，年度获得平均值
	*/
	s startQ="",endQ="",lenQ=""
	i frequency="M" s startQ=year_"01",endQ=year_"12"
	i frequency="Q" s startQ=year_"01",endQ=year_"04"
	i frequency="H" s startQ=year_"01",endQ=year_"02"
	i frequency="Y" s startQ=year_"00",endQ=year_"00"
 
	s deptKPIStr="SELECT DISTINCT UnitResultDetail_KPIDr,UnitResultDetail_tValue, "
				_"UnitResultDetail_KPIDr->KPIIndex1_name as kpi , "
				_"UnitResultDetail_KPIDr->KPIIndex1_level as kpilevel, UnitResultDetail_KPIDr->KPIIndex1_code as kpiCode, "
				_"UnitResultDetail_parRef->UnitResult_jxUnitDr as deptDr, "
				_"UnitResultDetail_parRef->UnitResult_jxUnitDr->JXUnit_name as dept  "
				_",UnitResultDetail_KPIDr->KPIIndex1_isEnd AS isEnd " ;2016-05-05 cyl add
				_"FROM dhc_pa_data.UnitResultDetail "
				_"WHERE UnitResultDetail_parRef->UnitResult_period BETWEEN '"_startQ_"' AND '"_endQ_"' "
				_"AND UnitResultDetail_parRef->UnitResult_schemDr->Schem_frequency='"_frequency_"'"
				_" AND UnitResultDetail_tValue IS NOT NULL" ;2016-05-05 cyl add

    s deptKPIresult=##class(%Library.ResultSet).%New()
	d deptKPIresult.Prepare(deptKPIStr)
	d deptKPIresult.Execute()
	s deptKpiList=##class(%Library.ListOfDataTypes).%New()	
	s count=0
    While(deptKPIresult.Next()){
	  s deptdr=deptKPIresult.Data("deptDr")
	  s dept=deptKPIresult.Data("dept")
	  s kpiDr=deptKPIresult.Data("UnitResultDetail_KPIDr")
	  s kpi=deptKPIresult.Data("kpi")
	  s kpiCode=deptKPIresult.Data("kpiCode")
	  s level=deptKPIresult.Data("kpilevel")
	  s isEnd=deptKPIresult.Data("isEnd") ;2016-05-05 cyl add
	  s tValue=deptKPIresult.Data("UnitResultDetail_tValue")
	  i tValue="" s tValue=0
	  //将科室和指标id放在一个list中，用作后面取global的值
	  s deptKpiStr=deptdr_"#"_kpiDr
	  i count=0  d
	  .d deptKpiList.Insert(deptKpiStr)
	  e  d
	  .s findStr=deptKpiList.Find(deptKpiStr)
	  .if findStr="" d
	  ..d deptKpiList.Insert(deptKpiStr)
	  //用来存放actvalue的和的global
	  i $d(^depKPISumTemp(deptdr,kpiDr))=0  d
	  .s ^deptKPICount(deptdr,kpiDr)=1 ;用来统计该科室该指标的记录数 2016-05-05 cyl add
	  .s ^depKPISumTemp(deptdr,kpiDr)=tValue
	  e  d
	  .s ^deptKPICount(deptdr,kpiDr)=$Get(^deptKPICount(deptdr,kpiDr))+1 ;2016-05-05 cyl add
	  .s ^depKPISumTemp(deptdr,kpiDr)=$Get(^depKPISumTemp(deptdr,kpiDr))+tValue
	  //存放deptKpi基本信息
	  i $d(^depKPIStrTemp(deptdr,kpiDr))=0 d
	  .s ^depKPIStrTemp(deptdr,kpiDr)=deptdr_"^"_dept_"^"_kpiDr_"^"_kpi_"^"_kpiCode_"^"_level_"^"_isEnd ;2016-05-05 cyl edit
	  s count=count+1
	
	 	  
	}
 	//循环list 取值并计算
 	s listCount=deptKpiList.Count()
 	for k=1:1:listCount d
	.s listStr=deptKpiList.Data(k)
	.s depp=$p(listStr,"#",1)
	.s kpii=$p(listStr,"#",2)
	.s depKPIStrGet=$Get(^depKPIStrTemp(depp,kpii))
	.s deptdr=$p(depKPIStrGet,"^",1)
	.s dept=$p(depKPIStrGet,"^",2)
	.s kpiDr=$p(depKPIStrGet,"^",3)
	.s kpi=$p(depKPIStrGet,"^",4)
	.s deptKPICount=$Get(^deptKPICount(deptdr,kpiDr)) ;2016-05-05 cyl add
	.s avgValue=$Get(^depKPISumTemp(depp,kpii))/deptKPICount  ;2016-05-05 cyl edit
	.s kpiCode=$p(depKPIStrGet,"^",5)
	.s level=$p(depKPIStrGet,"^",6)
	.s isEnd=$p(depKPIStrGet,"^",7) ;2016-05-05 cyl add
	.d aa
	
	k ^depKPIStrTemp
	k ^depKPISumTemp
	k ^deptKPICount
  	q $$$OK
aa
    s Data=$lb(deptdr,dept,kpiDr,kpi,$fn(avgValue,"",2),kpiCode,level,isEnd) ;2016-05-05 cyl edit
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetAvgTValueFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAvgTValueExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetAvgTValueClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAvgTValueExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Storage Default
{
<Data name="uUnitKpiYearReportDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^dhc.pa.report.uUnitKpiYeaD6BFD</DataLocation>
<DefaultData>uUnitKpiYearReportDefaultData</DefaultData>
<IdLocation>^dhc.pa.report.uUnitKpiYeaD6BFD</IdLocation>
<IndexLocation>^dhc.pa.report.uUnitKpiYeaD6BFI</IndexLocation>
<StreamLocation>^dhc.pa.report.uUnitKpiYeaD6BFS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
