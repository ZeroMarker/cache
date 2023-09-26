/// wangjian
/// 2014-07-10
/// 支付宝业务异常查询类
Class DHCAliPay.ChargeInterface.DHCAliPayFindErr Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod GetNormalInvRefound(StDate, EndDate)
{
	
	n (StDate, EndDate)
	f Date=StDate:1:EndDate d
    .s PrtRowid=""
    .f  s PrtRowid=$o(^DHCINVPRT(0,"Date",Date,PrtRowid)) q:PrtRowid=""  d
    ..s PrtFlag=$p(^DHCINVPRT(PrtRowid),"^",8)
    ..;作废重打要考虑
	..s PapmiDr=$p(^DHCINVPRT(PrtRowid),"^",15)
    ..s PrtPapmino=$p(^PAPER(PapmiDr,"PAT",1),"^",1)
    ..s PrtPapminame=$p(^PAPER(PapmiDr,"ALL"),"^",1)
    ..s PaymSub="",Flag=0
    ..f  s PaymSub=$o(^DHCINVPRT(PrtRowid,"P",PaymSub)) q:(PaymSub="")!(Flag=1)  d
    ...q:PaymSub=0
    ...s PaymDr=$p(^DHCINVPRT(PrtRowid,"P",PaymSub),"^",1)
    ...s PaymAmt=$p(^DHCINVPRT(PrtRowid,"P",PaymSub),"^",3)
    ...s payMCode=$p(^CT("CTPM",PaymDr),"^",1)
    ...s HandDr=##class(DHCAliPay.ChargeInterface.AliPayLogic).GetPayModeHardComm("OP",payMCode)
    ...i HandDr'="" d
    ....i +$g(PaymAmt)'=0 s Flag=1
    ..q:Flag=0
    ..i $d(^DHCINVALITPi(0,"S","IPDR",PrtRowid))'=0 d
    ..s Rowid=""
    ...f  s Rowid=$o(^DHCINVALITPi(0,"S","IPDR",PrtRowid,Rowid)) q:Rowid=""  d
    ....s Rc=$p(^DHCINVALITP(Rowid),"^",1)
	....q:((Rc'="0000")&&(Rc'="00"))
	....s TradeChannel=$p(^DHCINVALITP(Rowid),"^",31)
	....s RefoundFlag=0
	....s RefoundFlag=..CheckRefound(Rowid)
	....i (+RefoundFlag=1)&&(PrtFlag="N") d
	.....w !,"登记号:"_PrtPapmino_"姓名"_PrtPapminame_"发票id"_PrtRowid_"His缴费成功,费用被退掉"
	..e  d
	...w !,"登记号:"_PrtPapmino_"姓名"_PrtPapminame_"发票id"_PrtRowid_"不存在交易记录"
	q
}

ClassMethod CheckRefound(IAPRowid)
{
	n (IBPRowid)
	s Rtn=0
	s ReIAPRowid=""
	f  s ReIAPRowid=$o(^DHCINVALITPi(0,"POTN",IBPRowid,ReIAPRowid)) q:(ReIAPRowid="")!(Rtn=1)  d
	.q:ReIAPRowid=0
	.s ReRc=$p(^DHCINVALITP(ReIAPRowid),"^",1)
	.q:((ReRc'="0000")&&(ReRc'="00"))
	.s Rtn=1
	
	q Rtn
}

}
