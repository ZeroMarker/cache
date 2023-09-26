Import sqluser

Class web.DHCSTMService.HvNewVersion.HvDataSync Extends (%RegisteredObject, %XML.Adaptor, web.DHCSTMHUI.StkTypeM, web.DHCSTMHUI.RtnObj) [ Not ProcedureBlock ]
{

/// Description:老系统调用新系统生成调整单
/// w ##class(web.DHCSTMService.HvNewVersion.HvDataSync).CreateInfoHvForNew("GZ202008140011","1","Adj")
ClassMethod CreateInfoHvForNew(MainInfo As %String, ListData As %String, Type As %String = "") As %Library.String
{
	n (MainInfo,ListData,Type)
	;s ^zx(666)=$lb(MainInfo,ListData,Type)
	;q -999
	s Err=0
	i Type="Adj" d
	.s Err=..CreateAdjByLable(MainInfo,ListData)
	q Err
}

/// Description:生成调整单
/// Other:数量-1调少，条码状态改为InAdj，数量1调多，条码状态改为Enable
/// Creater:	
/// CreateDate:	20200618
/// w ##class(web.DHCSTMService.HvNewVersion.HvDataSync).CreateAdjByLable("MGZ20210816001","-1")
ClassMethod CreateAdjByLable(HVBarCode As %String, ListData As %String) As %Library.String
{
	n (HVBarCode,ListData)
	;s ^zx("88新")=$lb(HVBarCode,ListData)
	;q -999
	q:HVBarCode="" -1
	s Qty=$p(ListData,"^",1)
	s dhcit=$o(^DHCIT(0,"LABEL",HVBarCode,0))
	q:dhcit="" -2
	
	s Inci=$p(^DHCIT(dhcit),"^",1)
	s InciCode=$p(^INCI(Inci,1),"^",1)
	s InciDesc=$p(^INCI(Inci,1),"^",2)
	s status=$p(^DHCIT(dhcit),"^",5)
	q:((status'="InAdj")&&(Qty=1)) -3
	q:((status'="Enable")&&(Qty=-1)) -3
	s Inclb=$p(^DHCIT(dhcit),"^",12)
	q:Inclb="" -4
	s LocId="",LocDesc=""
	i Inclb'="" d
	.s il=$p(Inclb,"||",2)
	.s LocId=$p(^INCI(+Inclb,"IL",il),"^",1)
	.s LocDesc=$p($g(^CTLOC(LocId)),"^",2)
	q:LocId="" -5
	s Ret=0
	ts
	s UserId="",AdjReason="",ScgId="",StkType="M",Remark="老系统开医嘱同步",RowId=""
	s ScgList=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
	s ScgId=$p(ScgList,"^",5)
	s TmpMainData=RowId_"^"_LocId_"^"_UserId_"^"_AdjReason_"^"_ScgId_"^"_Remark
	s TmpMainTitle="RowId^AdjLoc^gUserId^ForAdjustReasonId^ScgStk^Remark"
	s MainData=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(TmpMainData,TmpMainTitle)
	
	s BuomId=$p(^INCI(Inci,1),"^",10)
	s UomId=BuomId
	s HospId=$p(^CTLOC(LocId),"^",22)
	s Sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(Inclb,+$h,BuomId,HospId)
	s Rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(Inclb,BuomId,HospId)
	s RpAmt=Qty*Rp
	s SpAmt=Qty*Sp
	s AdjItm=""
	s TmpListData=AdjItm_"^"_Inclb_"^"_Qty_"^"_BuomId_"^"_Rp_"^"_Sp_"^"_HVBarCode
	s TmpListTitle="RowId^Inclb^Qty^UomId^Rp^Sp^HvBarCode"
	s ListData=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(TmpListData,TmpListTitle)
	
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s RtnObj=##class(web.DHCSTMHUI.DHCINAdj).Update(MainData)
	i RtnObj.success'=0 s Ret=-6
	i Ret<0 tro  q Ret

	s Adj=RtnObj.rowid
	s RtnObj=##class(web.DHCSTMHUI.DHCINAdjItm).Update(Adj,ListData)
	i RtnObj.success'=0 s Ret=-7
	i Ret<0 tro  q Ret
	q:Ret<0 Ret
	
	s TmpCompData=UserId
	s TmpCompTitle="gUserId"
	s TmpCompData=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(TmpCompData,TmpCompTitle)
	s RtnObj=##class(web.DHCSTMHUI.DHCINAdj).SetComplete(Adj,TmpCompData)
	i RtnObj.success'=0 s Ret=-8
	i Ret<0 tro
	q:Ret<0 Ret
	
	s TmpAuditData=UserId
	s TmpAuditTitle="gUserId"
	s AuditData=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(TmpAuditData,TmpAuditTitle)
	s RtnObj=##class(web.DHCSTMHUI.DHCINAdj).Audit(Adj,AuditData)
	i RtnObj.success'=0 s Ret=-9
	i Ret<0 tro
	q:Ret<0 Ret

	s OldStatus=$p(^DHCIT(dhcit),"^",5)
	i ((Qty="1")&&(OldStatus="InAdj")) d
	.s newStatus="Enable"
	.&sql(update DHC_ItmTrack set DHCIT_Status=:newStatus where %id=:dhcit)
	.i SQLCODE'=0 s ret=-11	

	i Ret<0 tro
	q:Ret<0 Ret	
	tc
	q Ret
}

}
