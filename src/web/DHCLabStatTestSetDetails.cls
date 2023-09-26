Class web.DHCLabStatTestSetDetails Extends %Persistent
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
/// D ##class(%ResultSet).RunQuery("web.DHCLabStatTestSetDetails","QueryTSDetailsStatistics","A")
ClassMethod QueryTSDetailsStatisticsExecute(ByRef qHandle As %Binary, Code As %String, USERCODE As %String) As %Status
{
  S repid=$I(^CacheTemp)
  I $G(ind)="" S ind=1	
  S CodeName=$G(CodeName),Code=$G(Code)
  S USERCODE=$G(USERCODE)
  I '$L(USERCODE) S USERCODE="demo"
  //S USERCODE=70251
  S UserDep=""
  I '$L(USERCODE)   Set qHandle=$lb(0,repid,0) Quit $$$OK
  S dep="" F  S dep=$o(^TTAB("UA",USERCODE,4,dep)) Q:dep=""  D
  .S UserDep=UserDep_dep
  S P0=0
  K PLIST
  S PLIST(1)=Code
  S result=$$Department(Code)
  Set qHandle=$lb(0,repid,0)
  Quit $$$OK
  
  
Department(CodeName)
  K plSum,plTestset,PLIST,plFee,plRatio
  S CodeName=$G(CodeName),num=0
  S dindex="" F  S dindex=$O(^DHCStatis($j,CodeName,dindex)) Q:dindex=""  D
  .S TestSet=$P(^DHCStatis($j,CodeName,dindex),"^",1)
  .S TestSetFee=+$P(^DHCStatis($j,CodeName,dindex),"^",2)
  .S dflag=0,num=num+1
  .S tindex="" F  S tindex=$O(plTestset(tindex)) Q:(tindex="")!(dflag=1)  D
  ..I $P(plTestset(tindex),"^",1)=TestSet S dflag=1,cnt=tindex
  .I dflag=0 D
  ..S cnt=$O(plTestset(""),-1)
  ..I cnt="" S cnt=0
  ..S cnt=cnt+1
  ..S plTestset(cnt)=TestSet_"^"_$P(^TTAB("TS",TestSet),"\",1)
  ..S plSum(cnt)=0
  ..S plFee(cnt)=0
  .S plFee(cnt)=plFee(cnt)+TestSetFee
  .S plSum(cnt)=plSum(cnt)+1
  S tsum=$O(plTestset(""),-1)
  S sum=0
  F i=1:1:tsum D
  .I '$D(plFee(i)) D
  ..S sum=sum+1
  ..S TSRatio=$G(^DHCSATISTIC("TS",$P(plTestset(i),"^",1)))
  ..I '$L(TSRatio) s TSRatio=1
  ..S PLIST(sum)=plTestset(i)_"^"_plSum(i)_"^"_"^"_(TSRatio*plSum(i))
  .E  D
  ..S sum=sum+1
  ..S TSRatio=$G(^DHCSATISTIC("TS",$P(plTestset(i),"^",1)))
  ..I '$L(TSRatio) S TSRatio=1
  ..S TSName=plTestset(i)
  ..S TSNumber=plSum(i)
  ..S TSSumPrice=plFee(i)
  ..S Data=$lb(TSName,TSNumber,TSSumPrice)
  ..D Output
  K plTestset,plSum
  S P0=sum
  Q $j  

Output
	set Data=$lb(TSName,TSNumber,TSSumPrice)
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
/// D ##class(%ResultSet).RunQuery("web.DHCLabStatTestSetDetails","QueryTSDetailsStatistics","A")
Query QueryTSDetailsStatistics(Code As %String, USERCODE As %String) As %Query(ROWSPEC = "TSName:%String,TSNumber:%String,TSSumPrice:%String") [ SqlProc ]
{
}

Storage Default
{
<Data name="DHCLabStatTestSetDetailsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCLabStatTestSetDetailsD</DataLocation>
<DefaultData>DHCLabStatTestSetDetailsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCLabStatTestSetDetailsD</IdLocation>
<IndexLocation>^web.DHCLabStatTestSetDetailsI</IndexLocation>
<StreamLocation>^web.DHCLabStatTestSetDetailsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
