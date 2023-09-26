Class web.DHCEQ.EM.CTSnapShot Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      zc0038 
/// CreatDate：    2018-10-08
/// Description:   快照LookUp所需Query
/// Input：        vNode:快照生成日期
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.CTSnapShot","GetSnapShot","")
Query GetSnapShot(VNode As %String) As %Query(ROWSPEC = "TDate:%String,TRowID:%String,TCode:%String")
{
}

ClassMethod GetSnapShotExecute(ByRef qHandle As %Binary, VNode As %String) As %Status
{
	new repid, index,rowid
 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	
	s index=1
	s rowid=0
	
	f  s rowid=$o(^DHCEQSnapShot(rowid))  quit:rowid=""  d
	.s node=""
	.f  s node=$o(^DHCEQSnapShot(rowid,node))  quit:node=""  d
	..q:((node="Begin")||(node="End"))
	..q:(node'="Equip")		//Modify DJ 2016-12-02
	..;q:((vNode'="")&&(vNode'=node))
	..s TDate=$g(^DHCEQSnapShot(rowid,node,0,"Begin"))
	..;s TDate=$ZD(TDate,3)
	..// 日期格式统一调整 mwz 2017-3-2
	..s TDate=##class(web.DHCEQCommon).TransValueToPage(TDate,"date")
	..q:((VNode'="")&&(TDate'[VNode))  // Modefied by zc0044 2018-11-22  修改入参名称错误
	..s TRowID=rowid
	..s TNode=node
	..d OutputRowSnapShot
	Quit $$$OK

OutputRowSnapShot
	s Data=$lb(TDate,TRowID,TNode)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetSnapShotFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSnapShotExecute ]
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

ClassMethod GetSnapShotClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSnapShotExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
