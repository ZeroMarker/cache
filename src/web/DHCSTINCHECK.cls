Import SQLUser

Class web.DHCSTINCHECK Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:zdm
/// CreatDate:2009-4-9
/// Description:处理一张转移单的入库审核
/// Table:
/// Input:转移单号,审核人id，审核状态
/// OutPut:
/// Return:0(成功)；错误信息
ClassMethod TransInCheck(trno As %String, userid As %String, state As %String) As %String
{
 n (trno,userid,state)
 i state="" s state="31"  //zhwh 2010-12-26
 s ret=..CheckDataValid(trno)			;执行转入审核之前验证数据有效性
 q:ret'=0 ret
 tstart
 //s $ZT="Error^DHCSTERROR"
 s trno=$$ALPHAUP^SSUTIL4(trno)
 s trid=$o(^DHCINIT(0,"No",trno,""))
 ;
 s ret=##class(web.DHCSTMVBSTTR).UpdateInChkByNo(trno,userid,state,"")		;更新dhc_InIsTrf
 i ret'=0 trollback
 q:ret'=0 ret
 s toloc=$p(^DHCINIT(trid),"^",6)
 s locdesc=$p(^CTLOC(toloc),"^",2)
 s ret=0
 s chl=""
 f  s chl=$o(^DHCINIT(trid,"ITI",chl)) q:(chl="")!(ret'=0)  d
 .s substate=$p(^DHCINIT(trid,"ITI",chl),"^",23)
 .q:substate'=21					;不是等待接收状态的话不作处理
 .
 .tstart
 .s ret=##class(web.DHCSTOUTCHECK).UpdateDhcInIsTrfItm(trid,chl,state)
 .i ret'=0 trollback
 .q:ret'=0
 .s inclb=$p(^DHCINIT(trid,"ITI",chl),"^",3)
 .s qty=$p(^DHCINIT(trid,"ITI",chl),"^",1)
 .s uomdr=$p(^DHCINIT(trid,"ITI",chl),"^",7)
 .s uomdesc=$p(^CT("UOM",uomdr),"^",2)
 .s ucost=$p(^DHCINIT(trid,"ITI",chl),"^",4)
 .s adjsp=$p(^DHCINIT(trid,"ITI",chl),"^",20)
 .s inci=+inclb
 .s incicode=$p(^INCI(inci,1),"^",1)
 .s buomdr=##class(web.DHCSTITMDESC).GetBaseUoByCode(incicode)
 .s factor=##class(web.DHCSTCOMMONSRV).UOMFac(uomdr,buomdr)
 .s baseqty=qty*factor
 .s ret=..InsRequInclb(inclb,locdesc)			;返回请求科室的批次或-1(出错)
 .i ret=-1 trollback  q
 .s rinclb=ret
 .s ret=0
 .s ret=##class(web.DHCSTLOCDTOTAL).UpdateMainByID(inci,baseqty,toloc)
 .i ret="" trollback  q
 .s ret=##class(web.DHCSTLOCBTDTOTAL).UpdateDayBT(rinclb,baseqty,+ret)
 .i ret="" trollback  q
 .s lstdata="K"_"^"_trno_"^"_rinclb_"^"_qty_"^"_uomdesc_"^"_incicode_"^"_ucost_"^"_userid_"^"_trid_"||"_chl
 .s ret=##class(web.DHCSTINTRANS).IntoTrans(lstdata)
 .i ret="" trollback  q
 .s ret=##class(web.DHCSTLOCDTOTAL).MakeUpStk(rinclb,baseqty)
 .i ret'=0 trollback  q
 .
 .tcommit
 .;l -^INCI(inci)#"I"
 .;l -^DHCINIT(trid)#"I"
 .;l -^DHCBTLOCTOT#"I"
 i ret'=0 trollback
 q:ret'=0 ret 
 tcommit 
 q ret
}

/// Creator:zdm
/// CreatDate:2009-4-9
/// Description:验证数据有效性
/// Table:
/// Input:trno,转移单号
/// OutPut:
/// Return:0(有效)；无效的数据信息
ClassMethod CheckDataValid(trno As %String) As %String
{
 n (trno)
 q:trno="" "转移单号不能为空"
 s trno=$$ALPHAUP^SSUTIL4(trno)
 q:'$d(^DHCINIT(0,"No",trno)) "该转移单不存在"
 s trid=$o(^DHCINIT(0,"No",trno,""))
 q:trid="" "该转移单不存在"
 s state=$p(^DHCINIT(trid),"^",14)
 q:state'=21 "该转移单已经接收或回退"		
 s toloc=$p(^DHCINIT(trid),"^",6)
 q:toloc="" "转入科室不能为空" 
 s locdesc=$p(^CTLOC(toloc),"^",2)
 q:locdesc="" "转入科室不存在"
 s ret=0
 s chl=""
 f  s chl=$o(^DHCINIT(trid,"ITI",chl)) q:(chl="")!(ret'=0)  d
 .s inclb=$p(^DHCINIT(trid,"ITI",chl),"^",3)
 .s qty=$p(^DHCINIT(trid,"ITI",chl),"^",1)
 .s:qty="" ret="转移数量不能为空"_trid_")"
 .s uomdr=$p(^DHCINIT(trid,"ITI",chl),"^",7)
 .s:uomdr="" ret="该转移单存在单位为空的记录("_trid_")"
 .q:uomdr=""
 .s:inclb="" ret="该转移单存在批次库存为空的记录"_trid_")"
 .q:inclb=""
 .s inci=+inclb
 .s incicode=$p(^INCI(inci,1),"^",1)
 .s buomdr=##class(web.DHCSTITMDESC).GetBaseUoByCode(incicode)
 .s:buomdr="" ret="库存项"_incicode_"基本单位为空"
 .q:buomdr=""
 .s fac=##class(web.DHCSTCOMMONSRV).CheckUomFactor(uomdr,buomdr)
 .s:fac=0 ret="单位"_uomdr_"和"_buomdr_"不存在转换关系"
 .
 q ret
}

/// Creator:zdm
/// CreatDate:2009-4-9
/// Description:转入审核不通过
/// Table:
/// Input:转移单号,审核人id，审核状态
/// OutPut:
/// Return:0(成功)；错误信息
ClassMethod InCheckDeclined(trno As %String, userid As %String, state As %String) As %String
{
 n (trno,userid,state)
 tstart
 //s $ZT="Error^DHCSTERROR"
 s trno=$$ALPHAUP^SSUTIL4(trno)
 s trid=$o(^DHCINIT(0,"No",trno,""))
 ;
 s ret=##class(web.DHCSTMVBSTTR).UpdateInChkByNo(trno,userid,state,"")		;更新dhc_InIsTrf
 i ret'=0 trollback
 q:ret'=0 ret
 s toloc=$p(^DHCINIT(trid),"^",6)
 s ret=0
 s chl=""
 f  s chl=$o(^DHCINIT(trid,"ITI",chl)) q:(chl="")!(ret'=0)  d
 .s substate=$p(^DHCINIT(trid,"ITI",chl),"^",23)
 .q:substate'=21					;不是等待接收状态的话不作处理
 .tstart
 .s inclb=$p(^DHCINIT(trid,"ITI",chl),"^",3)
 .s qty=$p(^DHCINIT(trid,"ITI",chl),"^",1)
 .s uomdr=$p(^DHCINIT(trid,"ITI",chl),"^",7)
 .s inci=+inclb
 .s incicode=$p(^INCI(inci,1),"^",1)
 .s buomdr=##class(web.DHCSTITMDESC).GetBaseUoByCode(incicode)
 .s factor=##class(web.DHCSTCOMMONSRV).UOMFac(uomdr,buomdr)
 .s baseqty=qty*factor
 .s ret=##class(web.DHCSTOUTCHECK).UpdateDhcInIsTrfItm(trid,chl,state)
 .i ret'=0 trollback  q
 .s ret=##class(web.DHCSTLOCDTOTAL).DelIntrs("T",trid_"||"_chl)
 .i ret'=0 trollback  q
 .s ret=##class(web.DHCSTOUTCHECK).UpInclbResQty(inclb,baseqty)		;增加占用数量
 .i ret'=0 trollback  q
 .tcommit
 .;l -^INCI(inci)#"I"
 .;l -^DHCINIT(trid)#"I"
 .;l -^DHCBTLOCTOT#"I"
 i ret'=0 trollback
 q:ret'=0 ret 
 tcommit 
 q ret
}

ClassMethod InsRequInclb(ProvLocInclb As %String, RequLoc As %String) As %String
{
 n (ProvLocInclb,RequLoc)
 q:ProvLocInclb="" -1
 q:RequLoc="" -1
 s inci="",incilsub="",inclbsub="",incib=""
 s requlocdr="",ibsub="",batno="",expdate="",inclb=""
 s inci=$p(ProvLocInclb,"||",1)  q:inci="" -1
 s incilsub=$p(ProvLocInclb,"||",2) q:incilsub="" -1
 s inclbsub=$p(ProvLocInclb,"||",3) q:inclbsub="" -1
 q:'$d(^INCI(inci,"IL",incilsub,"LB",inclbsub)) -1
 s incib=$p(^INCI(inci,"IL",incilsub,"LB",inclbsub),"^",1) q:incib="" -1
 s requlocdr=##class(web.DHCSTCOMMONSRV).LocToRowID(RequLoc) q:requlocdr="" -1
 s ibsub=$p(incib,"||",2) q:ibsub="" -1
 q:($d(^INCI(inci,"IB",ibsub))=0)!($d(^INCI(inci,"IB",ibsub))=10) -1
 s batno=$p(^INCI(inci,"IB",ibsub),"^",1) ;q:batno="" -1
 s expdate=$p(^INCI(inci,"IB",ibsub),"^",2) ;q:expdate="" -1
 s inclb=$$CHKIMLB^ST01(inci,requlocdr,batno,expdate)
 i inclb="" s inclb=$$INSIMLB^ST01(inci,requlocdr,batno,expdate)
 q inclb
}

}
