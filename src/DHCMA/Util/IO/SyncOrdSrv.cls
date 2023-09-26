/// 名称: DHCMA.Util.IO.SyncOrdSrv
/// 描述: 医嘱 提供接口服务
/// 编写者：zhufei
/// 编写日期: 2019-01-17
Class DHCMA.Util.IO.SyncOrdSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      zhufei
/// CreatDate：    2019-01-17
/// Description:   查询医嘱项字典
/// Table：        ARC_ItmMast
/// Input：        无
/// Output：       代码：Code、名称：Desc
/// d ##class(%ResultSet).RunQuery("DHCMA.Util.IO.SyncOrdSrv","GetOrdMastDic","")
Query GetOrdMastDic(aID As %String) As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,OrdCatDesc:%String,OrdType:%String,IsActive:%String")
{
}

ClassMethod GetOrdMastDicExecute(ByRef qHandle As %Binary, aID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	
 	If aID'="" {
	 	Do BuildOrdDicData(aID)
	} Else {
		Set xOrdID=0
		For {
			Set xOrdID=$o(^ARCIM(xOrdID))
			Quit:xOrdID=""
			Set xSub=0
			For {
				Set xSub=$o(^ARCIM(xOrdID,xSub))
				Quit:xSub=""
				
				Do BuildOrdDicData(xOrdID_"||"_xSub)
			}
		}
	}
	Quit $$$OK
 	
BuildOrdDicData(xID)
	Set OrdID=$p(xID,"||",1)
	Set SubID=$p(xID,"||",2)
	Quit:(OrdID="")||(SubID="")
	Set Code=$p($g(^ARCIM(OrdID,SubID,1)),"^",1)
	Set Desc=$p($g(^ARCIM(OrdID,SubID,1)),"^",2)
	Set SubCatDr=$p($g(^ARCIM(OrdID,SubID,1)),"^",10)
	Set CatDesc="",SubCatDesc="",OrdType=""
	If SubCatDr'="" {
		Set SubCatDesc=$p($g(^ARC("IC",SubCatDr)),"^",2)
		Set OrdType=$p($g(^ARC("IC",SubCatDr)),"^",7)
		Set CatDr=$p($g(^ARC("IC",SubCatDr)),"^",8)
		Set CatDesc=$p($g(^OEC("ORCAT",+CatDr)),"^",2)
	}
	Set OrdCatDesc=CatDesc_"."_SubCatDesc
	
	Set IsActive=1
	Set effDateFrom=$p($g(^ARCIM(OrdID,SubID,1)),"^",13)
	Set:effDateFrom'="" effDateFrom=$p(effDateFrom,"Z",1)
	Set effDateTo=$p($g(^ARCIM(OrdID,SubID,7)),"^",1)
	Set:((effDateFrom'="")&&(effDateFrom>+$h)) IsActive=0
	Set:((effDateTo'="")&&(effDateTo<+$h)) IsActive=0
	
	set Data=$lb(xID,Code,Desc,OrdCatDesc,OrdType,IsActive)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod GetOrdMastDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOrdMastDicExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetOrdMastDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOrdMastDicExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

}
