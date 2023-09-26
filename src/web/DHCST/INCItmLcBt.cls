Import sqluser

/// creator:yunhiabao
/// createdate:21051202
/// description:查询科室批次库存信息以及维护
Class web.DHCST.INCItmLcBt Extends (%RegisteredObject, %XML.Adaptor, StkTypeG) [ Not ProcedureBlock ]
{

/// creator:liangjiaquan
/// modified by yunhaibao,21051202
/// description:查询科室批次库存信息
/// w ##class(web.DHCST.INCItmLcBt).jsDHCSTLocItmBatch("0","0","","","1^^^0^^0","1")
ClassMethod jsDHCSTLocItmBatch(Start As %String, Limit As %String, Sort As %String, Dir As %String, StrPar As %String, User As %String = "") As %String
{
	i Limit=0 d
	.w ##class(web.DHCSTEXTCOMMON).GetNoJson()
	q:Limit=0 ""
	s loc=$p(StrPar,"^",1)
	q:loc="" -1
	s inci=$p(StrPar,"^",2)
	s stkgrpid=$p(StrPar,"^",3)
	s batchlockflag=$p(StrPar,"^",4)
	s stockflag=$p(StrPar,"^",5)
	s stocklockflag=$p(StrPar,"^",6)
	S HospID=$P(^CTLOC(loc),"^",22)
	
	s Title="inclb^code^desc^spec^manf^batchNo^batchExp^bUomDesc^pUomDesc^stkQty^avaQty^Rp^Sp^lockFlag^stkFlag"
    s count=0
    s stpage=Start+1
    s endpage=Start+Limit
    s InciId=""
    w "{rows:["
    f  s InciId=$o(^INCI("IL_LOC",loc,InciId)) q:InciId=""  d
    .q:(inci'="")&(inci'=InciId)        //药品过滤
    .s StkGrpInfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(InciId)
    .s TmpSktGrp=$p(StkGrpInfo,"^",5)
    .q:(stkgrpid'="")&(stkgrpid'=TmpSktGrp)   //类组过滤
    .s incicode=$p(^INCI(InciId,1),"^",1)
    .s incidesc=$p(^INCI(InciId,1),"^",2)
    .s PurUomId=$p(^INCI(InciId,3),"^",6)
    .s BUomId=$p(^INCI(InciId,1),"^",10)
    .s buomdesc=$p(^CT("UOM",BUomId),"^",2)
    .s puomdesc=$p(^CT("UOM",PurUomId),"^",2)
    .s spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",InciId)
    .s il=0
    .f  s il=$o(^INCI("IL_LOC",loc,InciId,il)) q:il=""  d
    ..s lb=0
    ..f  s lb=$o(^INCI(InciId,"IL",il,"LB",lb)) q:lb=""  d
    ...s inclb=InciId_"||"_il_"||"_lb
    ...s Incib=$P(^INCI(InciId,"IL",il,"LB",lb),"^",1)
    ...s Chl=$p(Incib,"||",2)
    ...s IncQty=##CLASS(web.DHCST.Common.DrugStkCommon).QtyINCLB(inclb,+$h)
    ...i (IncQty<1)&&($p(IncQty,".",1)="") s IncQty=0_IncQty
    ...q:(stockflag=-1)&(IncQty'<0)
    ...q:(stockflag=0)&(IncQty'=0)
    ...q:(stockflag=1)&(IncQty'>0)
    ...s QtyUom=##class(web.DHCST.Common.DrugStkCommon).QtyWithUom(InciId,IncQty)
    ...s AvaQty=##class(web.DHCST.Common.DrugStkCommon).CurInclbAvaQty(inclb,BUomId)
    ...i (AvaQty<1)&&($p(AvaQty,".",1)="") s AvaQty=0_AvaQty
	...s AvaQtyUom=##class(web.DHCST.Common.DrugStkCommon).QtyWithUom(InciId,AvaQty)
    ...s BatNo=$p(^INCI(InciId,"IB",Chl),"^",1)
 	...s ExpDate=+$p(^INCI(InciId,"IB",Chl),"^",2)
 	...i ExpDate'=0  d
 	....s ExpDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ExpDate,"ST")
 	...e  d
 	....s ExpDate=""
 	...s BRp=##class(web.DHCST.Common.PriceCommon).GetClbRp(inclb,BUomId,HospID,"G",+$h,"")
	...s PRp=##class(web.DHCST.Common.PriceCommon).GetClbRp(inclb,PurUomId,HospID,"G",+$h,"")
	...i (PRp<1)&&($p(PRp,".",1)="") s PRp=0_PRp
	...s BSp=##Class(web.DHCSTPRICE).GetSp(inclb,+$h,BUomId,HospID,"")
	...s PSp=##Class(web.DHCSTPRICE).GetSp(inclb,+$h,PurUomId,HospID,"")
	...i (PSp<1)&&($p(PSp,".",1)="") s PSp=0_PSp
    ...s VendManf=##class(web.DHCST.Common.DrugStkCommon).VendManfByIncIb(Incib) //查找批次供应商及厂家
	...s PVenDesc=$p(VendManf,"^",2)
	...s PManf=$p(VendManf,"^",4)
	...s active="",stkactive=""
	...s dhcinclb=$o(^DHCINCLB(0,"LB",inclb,""))
	...i dhcinclb'="" d
	....s active=$p(^DHCINCLB(dhcinclb),"^",2)
	....s stkactive=$p(^DHCINCLB(dhcinclb),"^",4)
	...i active="Y" s notuseflag="N"
	...e  s notuseflag="Y"
	...q:(batchlockflag=1)&&(notuseflag'="Y")
	...q:(batchlockflag=2)&&(notuseflag="Y")
	...i stkactive="Y" s stknotuseflag="N"
	...e  s stknotuseflag="Y" 
	...q:(stocklockflag=1)&&(stknotuseflag'="Y")
	...q:(stocklockflag=2)&&(stknotuseflag="Y")
    ...s Data=inclb_"^"_incicode_"^"_incidesc_"^"_spec_"^"_PManf_"^"_BatNo_"^"_ExpDate_"^"_buomdesc_"^"_puomdesc_"^"_QtyUom_"^"_AvaQtyUom_"^"_PRp_"^"_PSp_"^"_notuseflag_"^"_stknotuseflag
    ...s count=count+1
    ...
    ...q:count<stpage
    ...q:count>endpage
    ...
    ...i count=stpage d
    ....w ##class(web.DHCST.Common.UtilCommon).GetJsonStr(Data,Title)
    ...e  d
    ....w ","_##class(web.DHCST.Common.UtilCommon).GetJsonStr(Data,Title)
    ...
    w "],results:"_count_"}"
}

/// 批量更新科室库存项目信息
///   0 : 成功
///   -1:没有要保存的数据
///   -2: - 失败
///   w ##class(web.DHCST.INCItmLcBt).SaveBatch("1||7||1^N^Y")
ClassMethod SaveBatch(ListData As %String) As %String
{
	n (ListData)
	q:ListData="" -1
	s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
	s Len=$l(ListData,rowDelim)
	s Err=""
	f i=1:1:Len   d
	.s Detail=$p(ListData,rowDelim,i)
	.s inclb=$p(Detail,"^",1)
	.q:inclb=""
	.s IncDesc=$p(^INCI(+inclb,1),"^",1)
	.s BatchLockFlag=$p(Detail,"^",2)
	.s BatchStockFlag=$p(Detail,"^",3)
	.s dhcinclb=$o(^DHCINCLB(0,"LB",inclb,""))
	.//q:dhcinclb=""
	.//注释上面上面一行，如果没有科室批次库存表数据，则插入一条  2020-02-26 yangsj
	.i dhcinclb=""  d
	..s locdr=$P(^INCI(+inclb,"IL",$P(inclb,"||",2)),"^",1)
	..&sql(insert into dhc_incitmlcbt(INCLB_LB_DR, INCLB_Active, INCLB_CTLOC_DR, INCLB_STKActive) values(:inclb,:BatchLockFlag,:locdr,:BatchStockFlag)) 
	..i SQLCODE'=0  d
	...i Err="" d
	....s Err=IncDesc
	...e  d
	....s Err=Err_","_IncDesc
	.e  d
	..s OldBatchLockFlag=$p(^DHCINCLB(dhcinclb),"^",2)
	..s OldBatchStockFlag=$p(^DHCINCLB(dhcinclb),"^",4)
	..q:(BatchLockFlag=OldBatchLockFlag)&&(BatchStockFlag=OldBatchStockFlag)
	..&sql(update dhc_incitmlcbt set INCLB_Active=:BatchLockFlag,INCLB_STKActive=:BatchStockFlag where INCLB_RowId=:dhcinclb)
	..
	..i SQLCODE'=0  d
	...i Err="" d
	....s Err=IncDesc
	...e  d
	....s Err=Err_","_IncDesc
	...
	.
	.

	q:Err="" 0
	q -2_":"_Err
}

}
