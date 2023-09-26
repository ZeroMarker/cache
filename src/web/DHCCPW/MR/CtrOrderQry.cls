/// 创建日期：2011-01-26
/// 创建者：李阳
/// 功能：查询每日医嘱
Class web.DHCCPW.MR.CtrOrderQry Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// 按日期查询医嘱
/// d ##class(%Library.ResultSet).RunQuery("web.DHCCPW.MR.CtrOrderQry","QueryOrderItemByDate",1,61817,61817)
Query QueryOrderItemByDate(PathWayID As %String, FromDate As %String, ToDate As %String) As %Query(ROWSPEC = "OrderItemID:%String,ArcimID:%String,OrderType:%String:医嘱类别,ArcimDesc:%String:医嘱名称,Number:%String:数量,Unit:%String:单位,OrderStatus:%String:状态,ExecDate:%String:执行日期,ExecTime:%String:执行时间")
{
}

ClassMethod QueryOrderItemByDateExecute(ByRef qHandle As %Binary, PathWayID As %String, FromDate As %String, ToDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	s:FromDate["-" FromDate=$zdh(FromDate,3)
	s:FromDate["/" FromDate=$zdh(FromDate,4)
	s:ToDate["-" FromDate=$zdh(ToDate,3)
	s:ToDate["/" FromDate=$zdh(ToDate,4)	
	s objPath=##class(User.DHCMRClinicalPathWay).%OpenId(PathWayID)
	q:objPath="" ""
	d objPath.%Close()
	s objMRAdm=##class(web.DHCCPW.Base.MRAdm).GetObjById(objPath.CPWMRADMDR)
	d objMRAdm.%Close()
	s paadm=objMRAdm.AdmDr
	s OrderID="" f  s OrderID=$o(^OEORD(0,"Adm",paadm,OrderID)) q:OrderID=""  d
	.f tmpDate=FromDate:1:ToDate  d
	..s childSub="" f  s childSub=$o(^OEORDi(0,"ItemDate",tmpDate,OrderID,childSub)) q:childSub=""  d
	...s OrderItemID=OrderID_"||"_childSub
	...s objOdrItm=##class(web.DHCCPW.Base.OrdItem).GetObjById(OrderItemID)
	...s ^CacheTemp(repid,ind)=$$BuildQueryOrderItemByDateExecute(objOdrItm)
	...s ind=ind+1
	Quit $$$OK
BuildQueryOrderItemByDateExecute(objItem)
	n (objItem)
	s execDate=$$GetExecDateTime(objItem.OEORIRowId)
	s data=$lb("")
	s $li(data,1)=objItem.OEORIRowId
	s $li(data,2)=objItem.OEORIItmMastDR
	s $li(data,3)=objItem.OECPRDesc
	s $li(data,4)=objItem.ARCIMDesc
	s $li(data,5)=objItem.OEORIDoseQty
	s $li(data,6)=objItem.CTUOMDesc
	s $li(data,7)=objItem.OSTATDesc
	s $li(data,8)=$p(execDate,",",1)
	s $li(data,9)=$zt($p(execDate,",",2))	//	Add by zhaoyu 2012-12-03 查询统计-临床路径监控-【医嘱信息】页签，除药品医嘱外，【数量】、【单位】、【执行时间】数据为空 220
	q data
GetExecDateTime(OrderItemID)
	n (OrderItemID)
	s OrderID=$p(OrderItemID,"||",1)
	s itmChild=$p(OrderItemID,"||",2)
	s execChild="" f  s execChild=$o(^OEORD(OrderID,"I",itmChild,"X",execChild)) q:execChild=""  d
	.s execData=$g(^OEORD(OrderID,"I",itmChild,"X",execChild))	
	.s Date=$p(execData,"^",1)
	.s Time=$p(execData,"^",2)
	q $g(Date)_","_$g(Time)
}

ClassMethod QueryOrderItemByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryOrderItemByDateExecute ]
{
	Set repid=$LIST($g(qHandle),2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

ClassMethod QueryOrderItemByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryOrderItemByDateExecute ]
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

}
