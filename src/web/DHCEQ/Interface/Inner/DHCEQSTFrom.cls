Class web.DHCEQ.Interface.Inner.DHCEQSTFrom Extends %RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// add by zy 2014-09-15  ZY0117
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Interface.Inner.DHCEQSTFrom","GetIncItmList","AB")
Query GetIncItmList(Code As %String = "") As %Query(ROWSPEC = "TDesc:%String,TCode:%String,hidden:%String,TUnit:%String,TPrice:%String,hidden:%String,TExID:%String,hidden:%String")
{
}

ClassMethod GetIncItmListExecute(ByRef qHandle As %Binary, Code As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0) 	
 	Set Code=$ZCONVERT(Code,"U")
 	i Code="" Quit $$$OK
	s index=1
	//^INCALIAS(0,"INCI",{INCA_INCI_DR},{INCA_ROWID})
	s IncId=0
	f  s IncId=$o(^INCALIAS(0,"INCI",IncId))  quit:IncId=""  d
	.s Alias=0
	.s FindFlag=0
	.f  s Alias=$o(^INCALIAS(0,"INCI",IncId,Alias))  quit:Alias=""  d
	..q:$p($g(^INCALIAS(Alias)),"^",4)'[Code
	..s FindFlag=1
	.q:FindFlag=0
	.d ResetVariablesGetIncItmList
	.s ConsumableItemInfo=..GetConsumableItemInfo(IncId)
	.s TDesc=$p(ConsumableItemInfo,"^",2)
	.s TCode=$p(ConsumableItemInfo,"^",1)
	.s TUnitDR=$p(ConsumableItemInfo,"^",3)
	.i TUnitDR'=""  s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	.s TPrice=$p(ConsumableItemInfo,"^",4)
	.s TExType="DHC-ST"
	.s TExID=IncId
	.s TExDesc=$p(ConsumableItemInfo,"^",2)
	.d OutputRowGetIncItmList
	Quit $$$OK
OutputRowGetIncItmList
	s Data=$lb(TDesc,TCode,TUnitDR,TUnit,TPrice,TExType,TExID,TExDesc)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetIncItmList
	s (TDesc,TCode,TUnitDR,TUnit,TPrice,TExType,TExID,TExDesc)=""
	quit
}

ClassMethod GetIncItmListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetIncItmListExecute ]
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

ClassMethod GetIncItmListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetIncItmListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// add by zy 2014-09-15  ZY0117
/// 从材料库中取材料最新进价
/// w ##Class(web.DHCEQCConsumableItem).GetConsumableItemInfo(8179)
ClassMethod GetConsumableItemInfo(incid)
{
	//s Loc=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
	n (incid)
	s Loc=1
	i Loc="" q ""
	;s Hospital=$p($g(^CTLOC(Loc)),"^",22)    modify by jyp 2019-10-18 CTLOC调整
	s Hospital=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(Loc)    //modify by jyp 2019-10-18 CTLOC调整
	s IncCode=$p($g(^INCI(incid,1)),"^",1) //材料code
	s IncDesc=$p($g(^INCI(incid,1)),"^",2) //材料desc
	//s UomId=$p($g(^INCI(incid,1)),"^",10) //基本单位
	s UomId=$p($g(^INCI(incid,3)),"^",6) //入库单位
	
	s Price=""
	s Price=##Class(web.DHCST.Common.PriceCommon).GetInciBasicRp(incid,+$h,UomId,Hospital,"M")
	
	//s Price=##Class(web.DHCSTM.Common.PriceCommon).GetInciBasicRp(incid,+$h,UomId,Hospital,"M")
	//s prprice=##class(web.DHCSTPRICE).GetInciLRp(inci,puomdr) //入库单位进价(最后入库)  C/S版本的材料
	q IncCode_"^"_IncDesc_"^"_UomId_"^"_Price
}

/// Add By DJ 2016-11-11
/// 描述:获取物资库存项(新版)
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Interface.Inner.DHCEQSTFrom","GetIncItmListNew","AB")
Query GetIncItmListNew(Code As %String = "") As %Query(ROWSPEC = "TDesc:%String:描述,TCode:%String:编码,hidden:%String,TUnit:%String:单位,TPrice:%String:单价,hidden:%String,hidden:%String,hidden:%String")
{
}

ClassMethod GetIncItmListNewExecute(ByRef qHandle As %Binary, Code As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0) 	
 	Set Code=$ZCONVERT(Code,"U")
 	i Code="" Quit $$$OK
 	s Hospital=$p($g(^CTLOC(1)),"^",22)
	s index=1
	s IncId=0
	f  s IncId=$o(^DHCITMINFO(0,"INCI",IncId))  quit:IncId=""  d
	.d ResetVariablesGetIncItmListNew
	.s TDesc=$p($g(^INCI(IncId,1)),"^",2)		//库存项名称
	.s TCode=$p($g(^INCI(IncId,1)),"^",1)		//库存项代码
	.q:(TDesc'[Code)&&(TCode'[Code)
	.;s TmpGrpInfo=##class(web.DHCSTM.Common.DrugInfoCommon).GetIncStkCatGrp(IncId)
	.s TmpGrpInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(IncId)	//czf 2021-01-30 1747240
	.s TmpGrpType=$p(TmpGrpInfo,"^",3)
	.q:TmpGrpType'="M"							//M:表示材料
	.s TDesc=$p($g(^INCI(IncId,1)),"^",2)		//库存项名称
	.s TCode=$p($g(^INCI(IncId,1)),"^",1)		//库存项代码
	.s PurUomId=$p($g(^INCI(IncId,3)),"^",6)
	.s TUnitDR=$p($g(^INCI(IncId,1)),"^",10)	//基本单位
	.i TUnitDR'=""  s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	.;s TPrice=##class(web.DHCSTM.Common.PriceCommon).GetPriceElse(IncId,+$h,PurUomId,Hospital)		//售价
	.;s TPrice=##class(web.DHCSTM.Common.PriceCommon).GetInciLRp(IncId,PurUomId,Hospital)		//当前进价  czf 2021-01-30 1747240
	.s TPrice=##class(web.DHCSTMHUI.Common.PriceCommon).GetInciLRp(IncId,PurUomId,Hospital)
	.s TExType="DHC-ST"
	.s TExID=IncId
	.s TExDesc=$p($g(^INCI(IncId,1)),"^",2)
	.d OutputRowGetIncItmListNew
	Quit $$$OK
OutputRowGetIncItmListNew
	s Data=$lb(TDesc,TCode,TUnitDR,TUnit,TPrice,TExType,TExID,TExDesc)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetIncItmListNew
	s (TDesc,TCode,TUnitDR,TUnit,TPrice,TExType,TExID,TExDesc)=""
	quit
}

ClassMethod GetIncItmListNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetIncItmListNewExecute ]
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

ClassMethod GetIncItmListNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetIncItmListNewExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
