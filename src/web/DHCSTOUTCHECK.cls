Import SQLUser

Class web.DHCSTOUTCHECK Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:zdm
/// CreatDate:2009-3-26
/// Description:处理一张转移单的出库审核
/// Table:
/// Input:转移单号,审核人id，审核状态
/// OutPut:
/// Return:0(成功)；错误信息
ClassMethod TransOutCheck(trno As %String, userid As %String, state As %String) As %String
{
 n (trno,userid,state)
 s ret=..CheckDataValid(trno)			;执行转出审核之前验证数据有效性
 q:ret'=0 ret
 tstart
 //s $ZT="Error^DHCSTERROR"
 s trno=$$ALPHAUP^SSUTIL4(trno)
 s trid=$o(^DHCINIT(0,"No",trno,""))
 ;
 s ret=##class(web.DHCSTMVBSTTR).UpdateChkByNo(trno,userid,state)		;更新dhc_InIsTrf
 i ret'=0 trollback
 q:ret'=0 ret
 s floc=$p(^DHCINIT(trid),"^",5)
 q:floc="" -1
 S HospID=$P(^CTLOC(floc),"^",22)	//Ct_Hospital ID 20090825 Zhouyg
 s ret=0
 s chl=""
 //b
 f  s chl=$o(^DHCINIT(trid,"ITI",chl)) q:(chl="")!(ret'=0)  d
 .s substate=$p(^DHCINIT(trid,"ITI",chl),"^",23)
 .q:(substate'="")&(substate'=11)					;不是待审核状态的话不作处理
 .
 .tstart
 .s ret=..UpdateDhcInIsTrfItm(trid,chl,state)
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
 .s baseqty=-qty*factor
 .s qty=-qty							
 .s ret=##class(web.DHCSTLOCDTOTAL).UpdateMainByID(inci,baseqty,floc)
 .//b
 .i ret="" trollback  q
 .s ret=##class(web.DHCSTLOCBTDTOTAL).UpdateDayBT(inclb,baseqty,+ret)
 .//b
 .i ret="" trollback  q
 .s lstdata="T"_"^"_trno_"^"_inclb_"^"_qty_"^"_uomdesc_"^"_incicode_"^"_ucost_"^"_userid_"^"_trid_"||"_chl
 .s ret=##class(web.DHCSTINTRANS).IntoTrans(lstdata)
 .//b
 .i ret="" trollback  q
 .s ret=##class(web.DHCSTLOCDTOTAL).MakeUpStk(inclb,baseqty)
 .//b
 .i ret'=0 trollback  q
 .//i adjsp=1  d
 .//.s datastr=inclb_"^"_""_"^"_""_"^"_userid_"^"_""_"^"_""_"^"_""_"^"_HospID
 .//.s ret=$$InsertAsp^DHCSTLGSTR(datastr)				;出库审核时调价
 .//i ret'=0 trollback  q
 .
 .s ret=..UpInclbResQty(inclb,baseqty)		;减少占用数量
 .//b
 .//w "------",!
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

ClassMethod UpInclbResQty(inclb, qty) As %String
{
 ;Set Qty of inclb that Tranfered but not Outchecked 
 q:inclb="" -1
 q:qty="" -1
 n inci,ilsub,lbsub,dqty,eqty
 s inci="",ilsub="",lbsub="",dqty=0
 s inci=$p(inclb,"||",1) q:inci="" -2
 s ilsub=$p(inclb,"||",2) q:ilsub="" -2
 s lbsub=$p(inclb,"||",3) q:lbsub="" -2
 q:'$d(^INCI(inci,"IL",ilsub,"LB",lbsub)) -3
 l +^INCI(inci,"IL",ilsub,"LB",lbsub):10 E  Q -4 ;Lock
 s dqty=+$p(^INCI(inci,"IL",ilsub,"LB",lbsub),"^",3)
 s eqty=dqty+qty
 i eqty<0  d   ;2006-07-27 add
 .s eqty=0
 s eqty=+eqty
 s $p(^INCI(inci,"IL",ilsub,"LB",lbsub),"^",3)=eqty
 l -^INCI(inci,"IL",ilsub,"LB",lbsub)
 ;&sql(Update INC_ItmLcBt set INCLB_DirtyQty=:eqty)
 q 0
}

/// Creator:zdm
/// CreatDate:2009-3-27
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
 q:state'=11 "该转移单已经审核或审核没通过"
 s floc=$p(^DHCINIT(trid),"^",5)
 q:floc="" "转出科室不能为空" 
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
 .//s fac=$$CheckUomFactor^DHCSTCOMMONSRV(uomdr,buomdr)
 .
 .s fac=##class(web.DHCSTCOMMONSRV).CheckUomFactor(uomdr,buomdr)
 .s:fac=0 ret="单位"_uomdr_"和"_buomdr_"不存在转换关系"
 .
 q ret
}

/// Creator:zdm
/// CreatDate:2009-3-27
/// Description:更新子表的转移状态
/// Table:DHC_InIsTrfItm
/// Input:rowid
/// OutPut:
/// Return:SQLCODE
/// Others:转出确认，转出审核，转入审核均调用该方法
ClassMethod UpdateDhcInIsTrfItm(parf As %String, chl As %String, state As %String) As %String
{
 n (parf,chl,state) 
 &sql(Update DHC_INIsTrfItm set DHCITI_State=:state
                          where INITI_INIT_ParRef=:parf and INITI_ChildSub=:chl)
 i SQLCODE'=0  d
 .//s ret=$$SqlErrorRecord^DHCSTERROR("UpdateDhcInIsTrfItm",parf_"||"_chl,SQLCODE)
 q SQLCODE
}

/// Creator:zdm
/// CreatDate:2009-3-27
/// Description:转移单确认完成
/// Table:DHC_InIsTrf,DHC_InIsTrfItm
/// Input:转移单号，备注
/// OutPut:
/// Return:0,成功；错误代码
ClassMethod TransOutComplete(trno, remark)
{
 n (trno,remark)
 q:$g(trno)="" 1
 s trno=$$ALPHAUP^SSUTIL4(trno)
 q:'$d(^DHCINIT(0,"No",trno)) 1
 tstart
 //set $ZT="Error^DHCSTERROR"
 s UserComplete="Y"				;完成标志
 s State=11						;转移单状态，待审核
 //s ret=$$UpdateCpByNo^DHCSTMVBSTTR(UserComplete,trno,remark)
 s ret=##class(web.DHCSTMVBSTTR).UpdateCpByNo(UserComplete,trno,remark)
 i ret'=0 trollback  
 q:ret'=0 ret
 s trid=$o(^DHCINIT(0,"No",trno,""))
 s ret=0
 s chl=""
 f  s chl=$o(^DHCINIT(trid,"ITI",chl))  q:(chl="")!(ret'=0)  d
 .s ret=..UpdateDhcInIsTrfItm(trid,chl,State)
 .i ret'=0 trollback  q
 .
 q:ret'=0 ret
 tcommit
 q 0
}

/// Creator:zdm
/// CreatDate:2009-4-09
/// Description:转移单审核不通过
/// Table:DHC_InIsTrf,DHC_InIsTrfItm
/// Input:转移单号，用户id，状态，
/// OutPut:
/// Return:0,成功；错误代码
ClassMethod OutCheckDeclined(trno As %String, userid As %String, state As %String) As %String
{
 n (trno,userid,state)
 q:$g(trno)="" 1
 s trno=$$ALPHAUP^SSUTIL4(trno)
 q:'$d(^DHCINIT(0,"No",trno)) 1
 tstart
 //set $ZT="Error^DHCSTERROR"
 s ret=##class(web.DHCSTMVBSTTR).UpdateChkByNo(trno,userid,state)
 i ret'=0 trollback  
 q:ret'=0 ret
 s trid=$o(^DHCINIT(0,"No",trno,""))
 s ret=0
 s chl=""
 f  s chl=$o(^DHCINIT(trid,"ITI",chl))  q:(chl="")!(ret'=0)  d
 .s ret=..UpdateDhcInIsTrfItm(trid,chl,state)
 .i ret'=0 trollback  q
 .
 q:ret'=0 ret
 tcommit
 q 0
}

}
