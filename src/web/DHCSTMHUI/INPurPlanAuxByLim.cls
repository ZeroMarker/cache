Import sqluser

/// Descript:	采购计划制单
/// Creator:	lxt
/// CreateDate:	2018-09-25
Class web.DHCSTMHUI.INPurPlanAuxByLim Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	依据库存上下限生成采购计划单
/// Creator:	lxt
/// CreateDate:	2018-09-25
/// Table:		IN_PurPlan
/// Input:		排序，查询条件
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.INPurPlanAuxByLim","QueryLocItmForPurch",)
Query QueryLocItmForPurch(Params As %String) As Query(ROWSPEC = "InciId,InciCode,InciDesc,PUomId,PUomDesc,PurQty,ManfId,ManfDesc,VendorId,VendorDesc,CarrierId,CarrierDesc,Spec,StkQty,Rp,MaxQty,MinQty,RepQty,LevelQty,BUomId,ConFac,RepLev,ApcWarn,Qty,UomId,UomDesc") [ SqlProc ]
{
}

ClassMethod QueryLocItmForPurchExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s PurLocId=PJObj.%Get("PurLoc")
	s StkGrpId=PJObj.%Get("StkScg")
	s IntFac=PJObj.%Get("RepLevFac")
	s UserId=PJObj.%Get("gUserId")
	s gHospId=PJObj.%Get("gHospId")
	q:PurLocId="" $$$OK
	s pHopsId=..sssHospId(PurLocId)
	s:pHopsId="" pHopsId=gHospId
	s StkGrpId=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(UserId,..sssCode(),PurLocId,StkGrpId,pHopsId)  //若类组为空，则传递User类组串
	s HospID=$P(^CTLOC(PurLocId),"^",22)
	
	s InciId=0
	f  s InciId=$O(^INCI("IL_LOC",PurLocId,InciId)) q:InciId=""  d
	.s NotUseFlag=$p(^INCI(InciId,2),"^",9)	;不可用标志
	.q:NotUseFlag="Y"
	.s StkGrpInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(InciId)
	.s TmpSktGrp=$p(StkGrpInfo,"^",5)
	.q:(StkGrpId'="")&(("^"_StkGrpId_"^")'[("^"_TmpSktGrp_"^"))
	.s ch=$O(^INCI("IL_LOC",PurLocId,InciId,"")) 
	.q:ch=""
	.s Incil=InciId_"||"_ch
	.s Incilid=""
	.s RepLev=0
	.s MaxQty=$p(^INCI(InciId,"IL",ch),"^",7) 
	.s MinQty=$p(^INCI(InciId,"IL",ch),"^",4) 
	.q:MaxQty=""
	.q:MinQty=""
	.s RepQty=$p(^INCI(InciId,"IL",ch),"^",6)     ;标准库存
	.q:+RepQty'>0
	.s Incilid=$o(^DHCINCIL(0,"INCIL",Incil,""))
	.s:Incilid'="" RepLev=$p(^DHCINCIL(Incilid),"^",22)    ;采购基数 
	.s LevelQty=MinQty+((MaxQty-MinQty)/2)  //参照标准数(上限和下限的中间值)
	.s CurQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).IL(InciId,PurLocId,+$h)  ; present qty 
	.q:CurQty>LevelQty   //没必要补货
	.s BPurQty=+RepQty-CurQty
	.q:BPurQty'>0
	.
	.s InciCode=$p(^INCI(InciId,1),"^",1)
	.s InciDesc=$p(^INCI(InciId,1),"^",2)
	.s BUomId=$P(^INCI(InciId,1),"^",10)
	.s uomdesc=$P($G(^CT("UOM",BUomId)),"^",2)
	.s PUomId=$P(^INCI(InciId,3),"^",6)
	.s PUomDesc=$P($G(^CT("UOM",PUomId)),"^",2)
	.s ConFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PUomId,BUomId)
	.s UomId=PUomId
	.s UomDesc=PUomDesc
	.
	.s PurQty=+BPurQty/ConFac
	.s Incsb=$p(^INCI(InciId,"IL",ch),"^",2)
	.i Incsb'=""  s sbDesc=$p($G(^INC("SB",Incsb)),"^",2)
	.s Sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(InciId,+$h,PUomId,HospID)
	.
	.i IntFac'=""  d
	..s PurQty=##class(web.DHCSTMHUI.DHCINIsTrfAuxByLim).GetFinalQty(InciId,PurLocId,BPurQty,IntFac)
	..s BPurQty=PurQty
	..s PurQty=PurQty/ConFac
	.q:(IntFac'="")&(+PurQty<1)
	.q:(IntFac="")&(+PurQty'>0)
	.
	.s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",InciId)
	.s CurQty=CurQty/ConFac    
	.s RepQty=RepQty/ConFac
	.s LevelQty=LevelQty/ConFac
	.s MaxQty=MaxQty/ConFac
	.s MinQty=MinQty/ConFac
	.s RepLev=RepLev/ConFac
	.s ItmInfo=##class(web.DHCSTMHUI.INPurPlan).GetItmStr(InciId,Params)
	.s VendorId=$p(ItmInfo,"^",1)
	.s VendorDesc=$p(ItmInfo,"^",2)
	.s ManfId=$p(ItmInfo,"^",3)
	.s ManfDesc=$p(ItmInfo,"^",4)
	.s CarrierId=$p(ItmInfo,"^",5)
	.s CarrierDesc=$p(ItmInfo,"^",6)
	.s Rp=+$p(ItmInfo,"^",9)
	.
	.s CheckCertParam={}.%Set("Inci",InciId).%Set("Manf",ManfId).%Set("Vendor",VendorId).%Set("gHospId",pHopsId).%ToJSON()
	.s CheckCertObj=##class(web.DHCSTMHUI.DHCCertDetail).Check(CheckCertParam)
	.s ApcWarn={}.%FromJSON(CheckCertObj).%Get("Warn") 
	.
	.s Qty=PurQty
	.d OutPutRow
	Quit $$$OK
	
OutPutRow
	S Data=$lb(InciId,InciCode,InciDesc,PUomId,PUomDesc,PurQty,ManfId,ManfDesc,VendorId,VendorDesc,CarrierId,CarrierDesc,Spec,CurQty,Rp,MaxQty,MinQty,RepQty,LevelQty,BUomId,ConFac,RepLev,ApcWarn,Qty,UomId,UomDesc)   
	S ^CacheTemp(repid,ind)=Data
	s ind=ind+1
}

}
