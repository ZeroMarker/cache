/// Creator: wang ying
/// CreatDate: 2015-5-25
/// Description: jxbasedata表的数据进行根据自由选择期间的汇总
Class dhc.pa.udata.uJXBaseDataReport Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

Query getJXBaseData(startPerion As %String, endPeriod As %String, periodType As %String) As %Query(ROWSPEC = "JXUnitDr:%Integer,JXUnitName:%String,KPIDr:%Integer,KPINname:%String,value:%Float") [ SqlProc ]
{
}

/// Creator：wang ying
/// CreatDate：2015-5-25
/// Description: jxbasedata表的数据进行根据自由选择期间的汇总
/// Table：dhc_pa_data.JXBaseData
/// Input：startPerion-开始日期,endPeriod-结束日期,periodType-期间类型
/// Output：
/// Return：
/// Others：d ##class(%ResultSet).RunQuery("dhc.pa.udata.uJXBaseDataReport","getJXBaseData","201401","201405")
ClassMethod getJXBaseDataExecute(ByRef qHandle As %Binary, startPerion As %String, endPeriod As %String, periodType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	;s ^TMPWY(1)=startPerion_"^"_endPeriod_"^"_periodType
	S periodType="M"
	q:startPerion="" $$$OK
	q:endPeriod="" $$$OK
	q:periodType="" $$$OK   
	
	s startPerion=$p(startPerion,"-",1)_$p(startPerion,"-",2)
	s endPeriod=$p(endPeriod,"-",1)_$p(endPeriod,"-",2)

	s sqlStr="SELECT JXBaseData_parRef,JXBaseData_parRef->JXUnit_name, JXBaseData_KPIDr,"
              _"JXBaseData_KPIDr->KPIIndex1_name, JXBaseData_KPIDr, sum(JXBaseData_actualValue) AS actualValue FROM dhc_pa_data.JXBaseData "
	
	i startPerion'="" s sqlStr=sqlStr_" where  JXBaseData_period>='"_startPerion_"'"
	i endPeriod'="" s sqlStr=sqlStr_" and JXBaseData_period<='"_endPeriod_"'"
	i periodType'="" s sqlStr=sqlStr_" and JXBaseData_periodType ='"_periodType_"'"
	s sqlStr=sqlStr_" AND JXBaseData_dataState=1"
	s sqlStr=sqlStr_"GROUP BY JXBaseData_parRef, JXBaseData_KPIDr"

	;w sqlStr,!
	s result = ##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s schemStr=""
	
	While(result.Next()){

		s value=0,calUnitName=""
		s JXUnitDr=result.Data("JXBaseData_parRef")
		s JXUnitName = result.Data("JXUnit_name")
		s KPIDr= result.Data("JXBaseData_KPIDr")
		s KPIName=result.Data("KPIIndex1_name")
		s value=result.Data("actualValue")
		i $d(^DHCCJXPAKPIINDEX1(KPIDr)) d
		.s caunit=$p($g(^DHCCJXPAKPIINDEX1(KPIDr)),"^",8)
		.i caunit'="" d
		..q:'$d(^DHCCJXPACALUNIT(caunit))
		..s calUnitName=$p($g(^DHCCJXPACALUNIT(caunit)),"^",2)
		..i calUnitName="百分比" d
		...&sql(SELECT count(JXBaseData_period) into :periodNum FROM dhc_pa_data.JXBaseData WHERE JXBaseData_period>=:startPerion AND JXBaseData_period<=:endPeriod AND JXBaseData_periodType='M' AND JXBaseData_KPIDr=:KPIDr AND JXBaseData_parRef=:JXUnitDr)
		...s value=value/periodNum
		i value="" s value=0
		d OutputRow
	}
	d result.Close()
 
 	q $$$OK
OutputRow

 	s Data=$lb(JXUnitDr,JXUnitName,KPIDr,KPIName,value)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod getJXBaseDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = getJXBaseDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod getJXBaseDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = getJXBaseDataExecute ]
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

Storage Default
{
<StreamLocation>^dhc.pa.udata.uJXBaseData506DS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
