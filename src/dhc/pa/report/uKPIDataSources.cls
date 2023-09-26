/// 指标数据源报表
Class dhc.pa.report.uKPIDataSources Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

ClassMethod GetReportExecute(ByRef qHandle As %Binary, Period As %String, UnitDr As %String, expression As %String, periodType As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
	q:Period="" $$$OK
	q:UnitDr="" $$$OK
 	q:expression="" $$$OK
 	q:periodType="" $$$OK
 	;s ^TMPLY(1)=Period_"^"_UnitDr_"^"_expression
 	//s expression=$E(expression,2,$L(expression)-1)
 	s kpistr=..GetKPIStrList(expression)
	;w kpistr,!
	/**
	s m =$L(kpistr,"^")
	f i=1:1:m d
	.s KPIDr=$P(kpistr,"^",i)
	.w KPIDr,!
 	**/
 	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select *  from  dhc_pa_data.JXBaseData"
	
	s whereStr=" WHERE %ID>0  "	
	i Period'="" d  s whereStr=whereStr_" and JXBaseData_period ='"_Period_"'"_"  AND JXBaseData_periodType='"_periodType_"'"
	i UnitDr'="" d  s whereStr=whereStr_" and JXBaseData_parRef ='"_UnitDr_"'"
	i kpistr'="" d  s whereStr=whereStr_" and JXBaseData_KPIDr  in ("_kpistr_")"

	s sqlStr=sqlStr_whereStr
	
	
	;w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()
	/*//将公式转为指标名称的 2016-7-27 add cyl
	* 1、将	expression中的<>号替换掉
	*  2、再将公式中指标id的位置替换为指标名称
	*/
	s expressionStr=$replace($replace(expression,"<",""),">","")
	
	While(result.Next()){
	
		s kpiDr =result.Data("JXBaseData_KPIDr")
		s kpiName=""  s calName=""
		
		i $D(^DHCCJXPAKPIINDEX1(kpiDr)) d
		.i $g(^DHCCJXPAKPIINDEX1(kpiDr))'="" d
		..s kpiName = $P(^DHCCJXPAKPIINDEX1(kpiDr),"^",2)
		..s expressionStr=$replace(expressionStr,kpiDr,kpiName)
		
		i $D(^DHCCJXPAKPIINDEX1(kpiDr)) d
		.i $g(^DHCCJXPAKPIINDEX1(kpiDr))'="" d
		..s calDr = $P(^DHCCJXPAKPIINDEX1(kpiDr),"^",8)
		
		
		i $D(^DHCCJXPACALUNIT(calDr)) d
		.i $g(^DHCCJXPACALUNIT(calDr))'="" d
		..s calName = $P(^DHCCJXPACALUNIT(calDr),"^",2)
	
		s kpiValue = result.Data("JXBaseData_actualValue")
		
		d OutputRowDate
	}
	
	d result.Close()

 	q $$$OK
 	
OutputRowDate
	
 	s Data=$lb(kpiName,calName,kpiValue,kpiDr,expressionStr)
 	
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetReportExecute ]
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

ClassMethod GetReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:刘洋
/// CreatDate:2011-11-04
/// Description:查询报表数据记录
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.pa.report.uKPIDataSources","GetReport","201501","4","<39>/<38>","Q")
Query GetReport(Period As %String, UnitDr As %String, expression As %String, periodType As %String) As %Query(ROWSPEC = "kpiName:%String,calName:%String,kpiValue:%Float,kpiDr:%Integer,expressionStr:%String") [ SqlProc ]
{
}

/// Creator：刘洋
/// CreatDate：2010-9-2
/// Description: 根据给定的字符串和字符位置查询指定字符的位置
/// Table：
/// Input：string-指定字符的位置;num-"<"的占位位置
/// Output：
/// Return：返回指定字符的位置
/// Others:w ##class(dhc.pa.report.uKPIDataSources).GetNextLocation("{[(<21>+<51>)*0.5]/25}",2)
ClassMethod GetNextLocation(string, num) As %String
{
	s flag="false"
	//定义">"位置
	s k=0 

	i $E(string,num+1)=">" d
	.s flag="true"
	.s k=num+1
	.q:flag="true"
	e  d
	.s k=..GetNextLocation(string,num+1)
	
	q k
}

/// Creator：ly
/// CreatDate：2011-12-16
/// Description: 获取特定字符串并装入字符串集合
/// Table：
/// Input：string-需要转换的计算表达式
/// Output：
/// Return：字符串集合
/// Others:w ##class(dhc.pa.report.uKPIDataSources).GetKPIStrList("<21>+<51>")
ClassMethod GetKPIStrList(string) As %String
{
	n (string)
	s StrList=""   s tmp=""
	f i=1:1:$L(string) d
	.i $E(string,i)="<" d
	..s k=..GetNextLocation(string,i)
	..s StrList=$E(string,i+1,k-1)
	
	..i tmp="" d 
	...s tmp=StrList
	..e  d
	...s tmp=tmp_","_StrList

	q tmp
}

Storage Default
{
<StreamLocation>^dhc.pa.report.uKPIDataSourcesS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
