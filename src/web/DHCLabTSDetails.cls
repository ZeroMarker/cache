Class web.DHCLabTSDetails Extends %Persistent
{

/// 医嘱明细统计
Parameter BUILD = 60;

ClassMethod QueryTSDetailsStatisticsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryTSDetailsStatisticsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Query的执行方法
/// D ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// D ##class(%ResultSet).RunQuery("web.DHCLabTSDetails","QueryTSDetailsStatistics","A")
ClassMethod QueryTSDetailsStatisticsExecute(ByRef qHandle As %Binary, Code As %String, USERCODE As %String) As %Status
{
  S repid=$I(^CacheTemp)
  I $G(ind)="" S ind=1	
  S CodeName=$G(CodeName),Code=$G(Code)
  S USERCODE=$G(USERCODE)
  //S USERCODE=70251
  S UserDep=""
  I '$L(USERCODE)   Set qHandle=$lb(0,repid,0) Quit $$$OK
  S dep="" F  S dep=$o(^TTAB("UA",USERCODE,4,dep)) Q:dep=""  D
  .S UserDep=UserDep_dep
  S P0=0
  K PLIST
  S PLIST(1)=Code
  S result=$$Department(Code)
  S qHandle=$lb(0,repid,0)
  Q $$$OK
  
  
Department(RowID)
  I '$L(RowID) Q 0
  S num=0 
  S ts="" F  S ts=$O(^TMP($j,"Orders",RowID,ts)) Q:ts=""  D
  .S tsName=$P(^TTAB("TS",ts),"\",1)
  .S tsSum=$P(^TMP($j,"Orders",RowID,ts),"^",1)
  .S tsPrice=$P(^TMP($j,"Orders",RowID,ts),"^",2)
  .S tsPrice=$FN(tsPrice,"",2)
  .S Data=$lb(tsName,tsSum,tsPrice)
  .D Output
  .S num=num+1
  Q num

Output
	Set Data=$lb(tsName,tsSum,tsPrice)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod QueryTSDetailsStatisticsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryTSDetailsStatisticsExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" 
 	{				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      
 	{	// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      Qiuxianfu
/// CreatDate：    20140331
/// Description:： 医嘱明细统计(配合医嘱统计使用)
/// Table：        
/// Input：        Code:代码("70252":按检验科用户查询的是检验科用户代码，"0000027472":按病人查询的是病人登记号，"A":按科室查询的是科室代码)
/// Output：       医嘱名称，医嘱数量，医嘱价格
/// Return：       无
/// Others：
/// D ##class(%ResultSet).RunQuery("web.DHCLabTSDetails","QueryTSDetailsStatistics","SP01")
Query QueryTSDetailsStatistics(Code As %String, USERCODE As %String) As %Query(ROWSPEC = "tsName:%String,tsSum:%String,tsPrice:%String") [ SqlProc ]
{
}

Storage Default
{
<Data name="DHCLabTSDetailsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCLabTSDetailsD</DataLocation>
<DefaultData>DHCLabTSDetailsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCLabTSDetailsD</IdLocation>
<IndexLocation>^web.DHCLabTSDetailsI</IndexLocation>
<StreamLocation>^web.DHCLabTSDetailsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
