Import sqluser

/// Descript:	根据发放台帐记录,生成专业组分配单
/// Creater:    wangjiabin
/// CreateDate: 2014-02-14
Class web.DHCSTMHUI.SubLocGrpAllotAuxDsi Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:根据选择的请求记录生成采购计划单
/// Creater:    ZhangDongmei
/// CreateDate: 2012-06-20
/// Table:IN_Purplan,IN_PurplanItm
/// Input:科室Id^专业组id^操作人id^完成标志^类组^分配单月份,
/// 		发放明细rowidStr(,隔开)^请求明细rowid^....,
/// 		人员id^分配权重_$c(1)_人员id^分配权重_$c(1)_...
/// Output:     
/// Return：分配单id：成功，
/// -1:科室或人员为空
/// -99	;加锁失败
/// -3	;生成分配主表失败
/// -4	;生成分配子表itm失败
/// -5	;生成dsiitm孙表失败
/// -6	;生成scale子表失败
ClassMethod CreateAllotByDsi(MainData As %String, ListDsiId As %String, ListScaleStr As %String) As %Library.String
{
    n (MainData, ListDsiId, ListScaleStr)
    s Pid=..NewPid()
    d CollectData(Pid,ListDsiId)
    tstart
    s $ZT=..sssError()                        ;增加错误处理
    s AllotId=##class(web.DHCSTMHUI.SubLocGrpAllot).Insert(MainData)     ;保存分配单主表
    i +AllotId<=0 trollback
    q:+AllotId<=0 -3
    ;
    s Err=0
    s Sub=""
    f  s Sub=$o(^TMPGRPALLOT(Pid,"GrpAllot",Sub))  q:(Sub="")!(Err'=0)  d
    .s IncId=$p(^TMPGRPALLOT(Pid,"GrpAllot",Sub),"^",1)
    .s BQty=$p(^TMPGRPALLOT(Pid,"GrpAllot",Sub),"^",2)
    .s BUomId=$p(^TMPGRPALLOT(Pid,"GrpAllot",Sub),"^",3)
    .s RpAmt=$p(^TMPGRPALLOT(Pid,"GrpAllot",Sub),"^",4)
    .s SpAmt=$p(^TMPGRPALLOT(Pid,"GrpAllot",Sub),"^",5)
    .s ListDsiId=$p(^TMPGRPALLOT(Pid,"GrpAllot",Sub),"^",6)
    .s Detail=IncId_"^"_BQty_"^"_BUomId_"^"_RpAmt_"^"_SpAmt
    .;b ;1
    .s Ret=##class(web.DHCSTMHUI.SubLocGrpAllotItm).Insert(AllotId,Detail)
    .;b ;2
    .s:+Ret<=0 Err=-4
    .q:Err'=0
    .s AllotItmId=Ret
    .s Ret=..Insert(AllotItmId,ListDsiId)
    .s:Ret'=0 Err=-5
    .q:Err'=0
    .
    i Err'=0 trollback
    q:Err'=0 Err
    ;处理Scale子表数据(分配权重)
    s Ret=##class(web.DHCSTMHUI.SubLocGrpAllotItm).SaveScale(AllotId,ListScaleStr)
    s:Ret'=0 Err=-6
    i Err'=0 trollback
    q:Err'=0 Err
    tcommit
    k ^TMPGRPALLOT(Pid,"GrpAllot")
    q AllotId
CollectData(Pid,ListDsiId)
	n (Pid,ListDsiId)
    s Len=$l(ListDsiId,"^")
    f i=1:1:Len d
    .s indsi=$p(ListDsiId,"^",i)
    .q:indsi=""
    .s inds=+indsi
    .s ch=$p(indsi,"||",2)
    .s inclb=$p(^DHCINDS(inds,"DSI",ch),"^",3)
    .s inci=+inclb
    .q:inci=""
    .s Qty=$p(^DHCINDS(inds,"DSI",ch),"^",1)
    .s Rp=$p(^DHCINDS(inds,"DSI",ch),"^",2)
    .s UomId=$p(^DHCINDS(inds,"DSI",ch),"^",4)
    .s Sp=$p(^DHCINDS(inds,"DSI",ch),"^",10)
    .s BUomId=$p(^INCI(inci,1),"^",10)
    .s PurUomId=$p(^INCI(inci,3),"^",6)
    .s ConFac1=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(UomId,BUomId)
    .s ConFac2=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PurUomId,BUomId)
    .s BQty=Qty*ConFac1		;使用基本单位
    .s rpAmt=Rp*Qty
    .s spAmt=Sp*Qty
	.
    .i '$d(^TMPGRPALLOT(Pid,"GrpAllot",inci))  d
    ..s ^TMPGRPALLOT(Pid,"GrpAllot",inci)=inci_"^"_BQty_"^"_BUomId_"^"_rpAmt_"^"_spAmt_"^"_indsi
    .e  d
    ..s $p(^TMPGRPALLOT(Pid,"GrpAllot",inci),"^",2)=BQty+$p(^TMPGRPALLOT(Pid,"GrpAllot",inci),"^",2)
    ..s $p(^TMPGRPALLOT(Pid,"GrpAllot",inci),"^",4)=rpAmt+$p(^TMPGRPALLOT(Pid,"GrpAllot",inci),"^",4)
    ..s $p(^TMPGRPALLOT(Pid,"GrpAllot",inci),"^",5)=spAmt+$p(^TMPGRPALLOT(Pid,"GrpAllot",inci),"^",5)
    ..s $p(^TMPGRPALLOT(Pid,"GrpAllot",inci),"^",6)=$p(^TMPGRPALLOT(Pid,"GrpAllot",inci),"^",6)_","_indsi
    ..
    .
    q
}

/// Descript:   插入分配明细和科室内发放明细关联
/// Creater:    wangjiabin
/// CreateDate: 2014-02-18
/// Table:		DHC_SLGAInDsiItm
/// Input:代码,描述
/// Output:     
/// Return：成功:0
/// -1:信息为空
/// -3   ;保存失败
ClassMethod Insert(Parref As %String, ListDsiId As %String) As %Library.String
{
    n (Parref,ListDsiId)
    q:Parref="" -1
    q:ListDsiId="" -1
    ;
    s Len=$l(ListDsiId,",")
    s Err=0
    tstart
    f i=1:1:Len  q:Err'=0  d
    .s DsiId=$p(ListDsiId,",",i)
    .q:DsiId=""
    .s Chl=1+$o(^DHCSLGA(+Parref,"I",$p(Parref,"||",2),"SUB",""),-1)
    .&sql(insert into DHC_SLGAInDsiItm(SLGAIDSI_SLGAI_Parref,SLGAIDSI_Childsub,SLGAIDSI_Indsi_DR ) 
    values (:Parref,:Chl,:DsiId))
    .i SQLCODE'=0  d
    ..s Err=-3
    .
    i Err'=0 trollback
    q:Err'=0 Err    ;保存失败
    tcommit
    ;
    q 0
}

}
