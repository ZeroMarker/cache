Class DHCWL.YZCXData.YzcxHosConBhosQuery Extends %RegisteredObject [ ProcedureBlock ]
{

/// 院长查询专用
/// Creator：xss
/// Desc:用户若无配置信息则默认直接获取医院id、及描述会话变量；否则按用户得到相应院区配置，获取医院id和描述
/// CreateDate:2015-02-13
/// Table:CT_Hospital
/// Input:      
/// Output:医院id，医院描述，医院code  
///  USERID,HOSPID从报表传递回话变量
/// d ##class(%ResultSet).RunQuery("DHCWL.YZCXData.YzcxHosConBhosQuery","GetHospDetailQuery","","") 
Query GetHospDetailQuery(USERID As %String, HOSPID As %String) As %Query(ROWSPEC = "hospId:%String,hosCode:%String,hosDesc:%String") [ SqlProc ]
{
}

ClassMethod GetHospDetailQueryExecute(ByRef qHandle As %Binary, USERID As %String, HOSPID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	Set qHandle=$lb(0,repid,0)
	q:USERID="" $$$OK
	q:HOSPID="" $$$OK	

	s hiddenFlag="Y" ;是否隐藏，Y隐藏


    s hospId=HOSPID 
    s hosCode=$p($g(^CT("HOSP",hospId)),"^",1)
	s hosDesc=$p($g(^CT("HOSP",hospId)),"^",2)

	i '$d(^DHCWL.YZCX.HosConI("User",USERID)) d  
    .d OuputRow          ;默认登录
    e  d
	.s hosConId=0 f  s hosConId=$o(^DHCWL.YZCX.HosConI("User",USERID,hosConId)) q:hosConId=""  d
	..i '$d(^DHCWL.YZCX.UserHosRelI("User",hosConId)) d
	...d OuputRow       ;配置用户，没配置分院，默认登录
	..e  d
	...s uhrId=0 f  s uhrId=$o(^DHCWL.YZCX.UserHosRelI("User",hosConId,uhrId)) q:uhrId=""  d
	....s hospId=$list(^DHCWL.YZCX.UserHosRelD(uhrId),3)
	....s hosCode=$p($g(^CT("HOSP",hospId)),"^",1)
	....s hosDesc=$p($g(^CT("HOSP",hospId)),"^",2)
	....s hiddenFlag="N"
	....d OuputRow      ;取配置表明细
	Quit $$$OK
	
OuputRow
	s Data=$lb(hospId,hosCode,hosDesc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetHospDetailQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetHospDetailQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetHospDetailQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetHospDetailQueryExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 	Set AtEnd=1
 	Set Row=""
 	}
 	Else      {				// fetch row
 	Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// ---------
/// 院长查询专用
/// Creator：xss
/// Desc:用户若无配置信息则默认直接获取医院id、及描述会话变量；否则按用户得到相应院区配置，获取医院id和描述
/// CreateDate:2015-02-13
/// Table:CT_Hospital
/// Input:      
/// Output:医院id，医院描述，医院code  
///  USERID,HOSPID从报表传递回话变量
/// d ##class(%ResultSet).RunQuery("DHCWL.YZCXData.YzcxHosConBhosQuery","GetHospStrQuery","","") 
Query GetHospStrQuery(USERID As %String, HOSPID As %String) As %Query(ROWSPEC = "hospIdStr:%String") [ SqlProc ]
{
}

ClassMethod GetHospStrQueryExecute(ByRef qHandle As %Binary, USERID As %String, HOSPID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	Set qHandle=$lb(0,repid,0)
	q:USERID="" $$$OK
	q:HOSPID="" $$$OK	

    s hospId=HOSPID 
	s hospIdStr=hospId
	
	i '$d(^DHCWL.YZCX.HosConI("User",USERID)) d  
    .d OuputRow          ;默认登录
    e  d
	.s hosConId=0 f  s hosConId=$o(^DHCWL.YZCX.HosConI("User",USERID,hosConId)) q:hosConId=""  d
	..i '$d(^DHCWL.YZCX.UserHosRelI("User",hosConId)) d
	...d OuputRow       ;配置用户，没配置分院，默认登录
	..e  d
	...s hospIdStr=""
	...s uhrId=0 f  s uhrId=$o(^DHCWL.YZCX.UserHosRelI("User",hosConId,uhrId)) q:uhrId=""  d
	....s hospId=$list(^DHCWL.YZCX.UserHosRelD(uhrId),3)
	....i hospIdStr="" s hospIdStr=hospId
	....e  s hospIdStr=hospIdStr_","_hospId  
	...d OuputRow      ;取配置表明细
	
	Quit $$$OK
	
OuputRow
	s Data=$lb(hospIdStr)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetHospStrQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetHospDetailQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetHospStrQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetHospDetailQueryExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 	Set AtEnd=1
 	Set Row=""
 	}
 	Else      {				// fetch row
 	Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
