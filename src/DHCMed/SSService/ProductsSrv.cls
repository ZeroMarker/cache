/// 描述:		产品维护
/// 创建人:		lyh
/// 创建时间:	2010-03-29
Class DHCMed.SSService.ProductsSrv Extends (%RegisteredObject, DHCMed.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// Creator：     lyh
/// CreatDate：   2010-04-07
/// Description:  通过产品名称、产品代码、是否有效查询产品信息
/// Table：       DHCMed.SS.Products
/// d ##class(%ResultSet).RunQuery("DHCMed.SSService.ProductsSrv","FindProInfo")
Query FindProInfo() As %Query(ROWSPEC = "rowid:%String,ProCode:%String:代码,ProName:%String,ProVersion:%String,IconClass:%String,ShowIndex:%String,ProActive:%String,ProResume:%String")
{
}

ClassMethod FindProInfoExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s rowid=""

	f  s rowid=$o(^DHCMed.SS.ProductsD(rowid)) q:rowid=""  d
	.s obj=##class(DHCMed.SS.Products).%OpenId(rowid)
	.//q:obj.ProActive'=1
	.s $li(data,1)=rowid
	.s $li(data,2)=obj.ProCode
	.s $li(data,3)=obj.ProName
	.s $li(data,4)=obj.ProVersion
	.s $li(data,5)=obj.IconClass
	.s $li(data,6)=obj.ShowIndex
	.//s $li(data,7)=obj.ProActive
	.s $li(data,7)=$s(obj.ProActive=1:"是",1:"否")
	.//e  s $li(data,7)="否"
	.i $li(data,7)="否" d
	..s $li(data,3)=obj.ProName_("(无效)")
	.s $li(data,8)=obj.ProResume
    .s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
    do obj.%Close()
	q $$$OK
}

ClassMethod FindProInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindProInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod FindProInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindProInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// Creator：     lyh
/// CreatDate：   2010-04-07
/// Description:  通过产品名称查询产品名称、Rowid
/// Table：       DHCMed.SS.Products
/// Input：       cProName:产品名称
/// d ##class(%ResultSet).RunQuery("DHCMed.SSService.ProductsSrv","QueryProInfo","")
Query QueryProInfo(cProName As %String) As %Query(ROWSPEC = "rowid:%String,ProName:%String")
{
}

ClassMethod QueryProInfoExecute(ByRef qHandle As %Binary, cProName As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s rowid=""

	f  s rowid=$o(^DHCMed.SS.ProductsD(rowid)) q:rowid=""  d
	.s obj=##class(DHCMed.SS.Products).%OpenId(rowid)
	.q:obj.ProActive'=1
	.s $li(data,1)=rowid
	.s $li(data,2)=obj.ProName
	.q:((cProName'="")&(obj.ProName'[cProName))
    .s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
    do obj.%Close()
	q $$$OK
}

ClassMethod QueryProInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryProInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryProInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryProInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

Storage Default
{
}

}
