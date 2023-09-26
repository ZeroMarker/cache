Import sqluser

/// Descript:库存调整统计
Class web.DHCSTMHUI.AdjustStat Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	库存调整统计
/// Creator:	lxt
/// CreateDate:	2018-09-11
/// Table:		DHC_intrans
/// Input:		排序，查询条件
/// Return：	库存调整统计
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.AdjustStat","AdjustStat","{""Loc"":""153"",""gUserId"":""873"",""gLocId"":""153"",""gGroupId"":""98"",""gHospId"":""2"",""StartDate"":""21/09/2018"",""EndDate"":""21/09/2018"",""StkScg"":"""",""AdjustReason"":"""",""Inci"":"""",""InciDesc"":""""}")
Query AdjustStat(Params As %Text) As Query(ROWSPEC = "Inci,InciCode,InciDesc,AdjUom,AdjQty:%Float,bUomDesc,bAdjQty:%Float,Sp:%Float,Rp:%Float,SpAmt:%Float,RpAmt:%Float,Manf,Spec") [ SqlProc ]
{
}

ClassMethod AdjustStatExecute(ByRef qHandle As %Binary, Params As %Text) As %Status
{
 	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s Loc=PJObj.%Get("Loc")
	s StartDate=PJObj.%Get("StartDate")
	s EndDate=PJObj.%Get("EndDate")
	s StkGrpType=PJObj.%Get("StkScg")
	s ReasonDr=PJObj.%Get("AdjustReason")
	s ItmDr=PJObj.%Get("Inci")
	s ItmDesc=PJObj.%Get("InciDesc")
	s gHospId=PJObj.%Get("gHospId")
	;q:Loc="" $$$OK
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	s:StartDate'="" StartDate=..DH2L(StartDate)
	s:EndDate'="" EndDate=..DH2L(EndDate)
 	S Pid=..NewPid()
 	k ^TMPDHCSTINADJ("INADJ",Pid)
 	s pHospId=gHospId
 	S:Loc'="" pHospId=$p(^CTLOC(Loc),"^",22)
 	s StkGrpType=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr("",..sssCode(),"",StkGrpType,pHospId)
 	F Date=StartDate:1:EndDate  d
 	.S INTR=""
 	.F  S INTR=$o(^DHCINTR(0,"TypeDate","A",Date,INTR))  Q:INTR=""  D
 	..S TrPointer=$p(^DHCINTR(INTR),"^",9)
 	..S InadDr=+TrPointer
 	..S AdjreasonID=$p(^DHCINAD(InadDr),"^",6)
 	..Q:(ReasonDr'="")&(AdjreasonID'=ReasonDr)
 	..S Type=$p(^DHCINAD(InadDr),"^",15)
 	..Q:Type'=..sssCode()
 	..S LocDr=$p(^DHCINAD(InadDr),"^",16)
 	..Q:(Loc'="")&&(LocDr'=Loc)
 	..S InadSub=$P(TrPointer,"||",2)
 	..S INCI=$p(^DHCINTR(INTR),"^",15)
 	..q:(ItmDr'="")&&(INCI'=ItmDr)
 	..s stkgrpinfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(INCI) //类组
 	..s grpid=$p(stkgrpinfo,"^",5)
 	..q:(StkGrpType'="")&&(("^"_StkGrpType_"^")'[("^"_grpid_"^"))
 	..S INCLB=$p(^DHCINTR(INTR),"^",7) 
 	..S ILSub=$p(INCLB,"||",2)
 	..Q:'$d(^INCI(INCI))
 	..S LocDr=$p(^INCI(INCI,"IL",ILSub),"^",1)
 	..Q:(Loc'="")&&(LocDr'=Loc)
 	..S InciCode=$p(^INCI(INCI,1),"^",1)
 	..S InciDesc=$p(^INCI(INCI,1),"^",2)
 	..Q:(ItmDesc'="")&(InciDesc'[ItmDesc)
 	..S mdata=^DHCINAD(InadDr,"ADI",InadSub)
 	..S Qty=$p(mdata,"^",2)	//调整单位数量
 	..S Sp=$p(mdata,"^",4)		//调整单位售价
 	..S Uomdr=$p(mdata,"^",5)	//调整单位
 	..S bQty=$p(mdata,"^",7)	//基本单位数量
 	..S SpAmt=$p(mdata,"^",8)	//售价金额
 	..S Rp=$p(mdata,"^",9)		//进价
 	..S RpAmt=$p(mdata,"^",10)	//进价金额
 	..s bUom=$p(^INCI(INCI,1),"^",10)
 	..s fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(Uomdr,bUom)
 	..S bSp=Sp/fac
 	..S bRp=Rp/fac
 	..S ManfStr=##Class(web.DHCSTMHUI.Common.DrugInfoCommon).GetManf(INCI)
 	..S ManfDesc=$P(ManfStr,"^",3)
 	..S Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec(InciCode,INCI)
 	..S UomDesc=$P($G(^CT("UOM",Uomdr)),"^",2)
 	..S bUomDesc=$P($G(^CT("UOM",bUom)),"^",2)
 	..S Index=INCI_"^"_ManfDesc_"^"_bSp_"^"_bRp
 	..If $d(^TMPDHCSTINADJ("INADJ",Pid,Index)) D
 	...S $P(^TMPDHCSTINADJ("INADJ",Pid,Index),"^",5)=$P(^TMPDHCSTINADJ("INADJ",Pid,Index),"^",5)+Qty
 	...S $P(^TMPDHCSTINADJ("INADJ",Pid,Index),"^",7)=$P(^TMPDHCSTINADJ("INADJ",Pid,Index),"^",7)+bQty
 	...S $P(^TMPDHCSTINADJ("INADJ",Pid,Index),"^",9)=$P(^TMPDHCSTINADJ("INADJ",Pid,Index),"^",9)+SpAmt
 	...S $P(^TMPDHCSTINADJ("INADJ",Pid,Index),"^",11)=$P(^TMPDHCSTINADJ("INADJ",Pid,Index),"^",11)+RpAmt
 	..Else  D
 	...S ^TMPDHCSTINADJ("INADJ",Pid,Index)=INCI_"^"_InciCode_"^"_InciDesc_"^"_UomDesc_"^"_Qty_"^"_bUomDesc_"^"_bQty_"^"_Sp_"^"_SpAmt_"^"_Rp_"^"_RpAmt_"^"_ManfDesc_"^"_Spec
 	S Sub=""
 	F  S Sub=$o(^TMPDHCSTINADJ("INADJ",Pid,Sub)) Q:Sub=""  D
 	.S Sdata=$g(^TMPDHCSTINADJ("INADJ",Pid,Sub))
 	.S Inci=$P(Sdata,"^",1)
 	.S InciCode=$P(Sdata,"^",2)
 	.S InciDesc=$P(Sdata,"^",3)
 	.S UomDesc=$P(Sdata,"^",4)
 	.S AdjQty=$P(Sdata,"^",5)
 	.S bUomDesc=$P(Sdata,"^",6)
 	.S bAdjQty=$P(Sdata,"^",7)
 	.S Sp=$P(Sdata,"^",8)
 	.S Rp=$P(Sdata,"^",10)
 	.S SpAmt=$P(Sdata,"^",9)
 	.S RpAmt=$P(Sdata,"^",11)
 	.S Manf=$P(Sdata,"^",12)
 	.S Spec=$P(Sdata,"^",13)
 	.S Data=$lb(Inci,InciCode,InciDesc,UomDesc,AdjQty,bUomDesc,bAdjQty,Sp,Rp,SpAmt,RpAmt,Manf,Spec)   
 	.S ^CacheTemp(repid,ind)=Data
 	.S ind=ind+1
 	k ^TMPDHCSTINADJ("INADJ",Pid)
 	Quit $$$OK
}

}
