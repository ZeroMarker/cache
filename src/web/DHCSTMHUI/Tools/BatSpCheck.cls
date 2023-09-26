Import sqluser

/// 批次售价模式下数据检查
Class web.DHCSTMHUI.Tools.BatSpCheck Extends (%RegisteredObject, web.DHCSTMHUI.StkTypeM) [ Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.Tools.BatSpCheck","QueryInciWithWOStock")
/// CALL web_DHCSTMHUI_Tools.BatSpCheck_QueryInciWithWOStock()
/// Description:查询有医嘱项但是勾选无库存医嘱标志的数据
Query QueryInciWithWOStock() As websys.Query(ROWSPEC = "InciCode,InciDesc,Spec,ScgDesc") [ SqlProc ]
{
}

ClassMethod QueryInciWithWOStockExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	s MType=..sssCode()
	
	s InciId=0
	f  s InciId=$o(^INCI(InciId)) q:InciId=""  d
	.q:+InciId=0
	.s scgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(InciId)
	.s stkType=$p(scgInfo,"^",3)
	.s ScgDesc=$p(scgInfo,"^",2)
	.q:stkType'=MType
	.s Arcim=$p(^INCI(InciId,1),"^",3)	
	.q:+Arcim=0
	.s WOStock=$p(^ARCIM(+Arcim,$p(Arcim,"||",2),8),"^",11)
	.q:WOStock'="Y"
	.s InciCode=$p(^INCI(InciId,1),"^",1)
	.s InciDesc=$p(^INCI(InciId,1),"^",2)
	.s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",InciId)
	.d OutPutRowInciWithWOStock
	Quit $$$OK
OutPutRowInciWithWOStock
	s Data=$lb(InciCode,InciDesc,Spec,ScgDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.Tools.BatSpCheck","QueryLocInciNoStock","372")
/// CALL web_DHCSTMHUI_Tools.BatSpCheck_QueryLocInciNoStock("392,11")
/// Input: 科室id(若多个科室,使用逗号隔开)
/// Description:查询某科室下有医嘱项且没有库存记录的物资数据，这些物资在医嘱接收科室是此科室时不能开医嘱(批次售价模式下)
Query QueryLocInciNoStock(LocList As %String) As websys.Query(ROWSPEC = "LocDesc,InciCode,InciDesc,Spec,ScgDesc") [ SqlProc ]
{
}

ClassMethod QueryLocInciNoStockExecute(ByRef qHandle As %Binary, LocList As %String) As %Status
{
	n (qHandle,LocList)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:LocList="" $$$OK

	s MType=..sssCode()
	s LocId=0
	f  s LocId=$o(^CTLOC(LocId)) q:LocId=""  d
	.q:+LocId=0
	.q:(","_LocList_",")'[(","_LocId_",")
	.s LocDesc=$p(^CTLOC(LocId),"^",2)
	.s InciId=0
	.f  s InciId=$o(^INCI(InciId)) q:InciId=""  d
	..q:+InciId=0
	..s scgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(InciId)
	..s stkType=$p(scgInfo,"^",3)
	..s ScgDesc=$p(scgInfo,"^",2)
	..q:stkType'=MType
	..s Arcim=$p(^INCI(InciId,1),"^",3)	
	..q:+Arcim=0
	..q:$D(^INCI("IL_LOC",LocId,InciId))
	..s InciCode=$p(^INCI(InciId,1),"^",1)
	..s InciDesc=$p(^INCI(InciId,1),"^",2)
	..s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",InciId)
	..d OutPutRowLocInciNoStock
	Quit $$$OK
OutPutRowLocInciNoStock
	s Data=$lb(LocDesc,InciCode,InciDesc,Spec,ScgDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
