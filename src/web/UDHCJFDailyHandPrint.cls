Class web.UDHCJFDailyHandPrint Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// ///南通日报打印//////////////////////////////////////////////////////////
ClassMethod GetPrintInfo(Guser, job)
{
	;w ##class(web.UDHCJFDailyHandPrint).GetPrintInfo("10051","295206")
	;1.获取住院大类信息
	s cateFee=^TMP("ZYJF","FLFEE",job) ;在查询中统计

	;2.获取预交金（包括收退押金（贷方）及冲退预交金（借方））
	s depositInfo=..GetDepositInfo(Guser,job)

	;3.发票信息
	s invInfo=..GetInvInfo(Guser,job)
	
	;4.获取支付方式信息
	s payModeInfo=..GetPayModeInfo(Guser,job)
	
	;b ;5.获取合计信息
	s totalInfo=..GetTotalInfo(cateFee,payModeInfo)
		
	;b ;6.结算时间
	;s jkTimeInfo=^TMP("ZYJF","JKDATETIME",Guser,job)  //web.UDHCJFDailyHandPrint.cls

	s rtn=cateFee_$c(2)_depositInfo_$c(2)_invInfo_$c(2)_payModeInfo_$c(2)_totalInfo ;_$c(2)_jkTimeInfo

	q rtn
}

/// Lid 
/// 2010-07-13
/// 获取押金信息
/// 返回值格式:YJJNoinfo_"^"_Trcptno_"^"_hcdepnum_"^"_hcdepsum_"^"_zfdepno_"^"_zfdepnum_"^"_zfdepsum_"^"_$j(ZYpayamoun,3,2)
///            押金号段^红冲号段^红冲张数^红冲金额^作废号段^作废张数^作废金额^住院押金合计
ClassMethod GetDepositInfo(Guser, job)
{
	
	;w ##class(web.UDHCJFDailyHandPrint).GetDepositInfo("10058","3488")
	q:Guser=""
	k ^TMP("IPBILL","PayModeAmount",job)
	s n=1
    s BLpayamoun=0,ZYpayamoun=0,Tdetail="",Trcptno="",zfdepno="",zfdepnum=0,zfdepsum=0,hcdepnum=0,hcdepsum=0
    s username=$p(^SSU("SSUSR",Guser),"^",2)
    s date=$zd(+$h,3)
    s YJJNoinfo="",BLYJNoinfo=""
    s YJJNoinfo=##class(UDHCJFBaseCommon).GetINVNOinfo(Guser,"DepositNo",job)
    s BLYJNoinfo=##class(UDHCJFBaseCommon).GetINVNOinfo(Guser,"BLDepositNo",job)
    s indsub="",depositdr=""
    f  s indsub=$o(^TMP("ZYJF","DeptRpt",Guser,job,indsub)) q:indsub=""  d
    .s refundrcpt1="",rcptno1=""
    .s depositdr=$p(^TMP("ZYJF","DeptRpt",Guser,job,indsub),"^",20)  	;押金类型RowID
    .s payamount=$p(^TMP("ZYJF","DeptRpt",Guser,job,indsub),"^",4)		;金额
    .s paydesc=$p(^TMP("ZYJF","DeptRpt",Guser,job,indsub),"^",5)		;支付方式
    .s prtstatus=$p(^TMP("ZYJF","DeptRpt",Guser,job,indsub),"^",6)		;收据状态
    .s refundrcpt1=$p(^TMP("ZYJF","DeptRpt",Guser,job,indsub),"^",21)	;冲红收据号
    .s rcptno1=$p(^TMP("ZYJF","DeptRpt",Guser,job,indsub),"^",3)		;收据号
    .i depositdr'="" s arctddesc=$p(^ARC("ARCDT",depositdr),"^",2)  	;押金类型
    .i prtstatus="作废" d
    ..s zfdepnum=zfdepnum+1,zfdepsum=zfdepsum+payamount
    ..i zfdepno="" s zfdepno=rcptno1
    ..e  s zfdepno=zfdepno_","_rcptno1
    .q:prtstatus="作废"
    .i refundrcpt1'=""  d
    ..i Tdetail=""  d
    ...s Tdetail=rcptno1_"退"_refundrcpt1
    ..e   d
    ...s Tdetail=Tdetail_" "_rcptno1_"退"_refundrcpt1
    ..s hcdepnum=hcdepnum+1,hcdepsum=hcdepsum+payamount
    ..i Trcptno=""  d
    ...s Trcptno=rcptno1
    ..e  d
    ...s Trcptno=Trcptno_","_rcptno1
    .i arctddesc="病历押金"  d
    ..s BLpayamoun=BLpayamoun+payamount									;病历押金金额
    ..s BLpayamounUP=##class(UDHCJFBaseCommon).RMBDXXZH("","",BLpayamoun)
    .i arctddesc="住院押金"  d
    ..s ZYpayamoun=ZYpayamoun+payamount									;住院押金金额			
    ..s ZYpayamounUP=##class(UDHCJFBaseCommon).RMBDXXZH("","",ZYpayamoun)
    ..i '$d(^TMP("IPBILL","PayModeAmount",job,paydesc)) s ^TMP("IPBILL","PayModeAmount",job,paydesc)=payamount
    ..e  s ^TMP("IPBILL","PayModeAmount",job,paydesc)=^TMP("IPBILL","PayModeAmount",job,paydesc)+payamount
     
  	s depositInfo=YJJNoinfo_"^"_Trcptno_"^"_hcdepnum_"^"_hcdepsum_"^"_zfdepno_"^"_zfdepnum_"^"_zfdepsum_"^"_$j(ZYpayamoun,3,2)  
  	q depositInfo
}

/// Lid
/// 2010-07-13
/// 获取发票信息
/// 返回值格式:username_"^"_allrcptno_"^"_zfrcptno_"^"_zfrcptnum_"^"_zfrcptsum_"^"_hcrcptno_"^"_hcrcptnum_"^"_hcrcptsum_"^"_patfee_"^"_pattdeposit
///           收费员姓名^发票号段^作废号段^作废张数^作废金额^红冲号段^红冲张数^红冲金额^病人费用^冲退预交金
ClassMethod GetInvInfo(Guser, job)
{
    ;w ##class(web.UDHCJFDailyHandPrint).GetInvInfo("10058","3488")
	q:Guser=""
	if (Guser'="")&&($d(^TMP("ZYJF","DailyHand",Guser,job)))   k ^TMP("ZYJF","DailyHandPrint",Guser)
	k ^TMP("ZYJF","PrtCYJSDetail",Guser,job)
	k ^TMP("IPBILL","DepositPayM",Guser,job)
	s id="",zfrcptno="",hcrcptno="",num=0,patfee=0,pattdeposit=0,zryjj="",zfrcptnum=0,zfrcptsum=0,hcrcptnum=0,hcrcptsum=0
	s disjztotalsum=0,disjzamout=0,ybqfsum=0,ybcesum=0,sybxsum=0
	s qfsum=0,ybqfsum=0,ybcesum=0,sybxsum=0,patfee=0,pattdeposit=0,dailyfee=0,disjztotalsum=0
	s username=$p(^SSU("SSUSR",Guser),"^",2)
	f  s id=$o(^TMP("ZYJF","FindInvPrt",Guser,job,id))   q:id=""  d
	.s prtrowid=$p($g(^TMP("ZYJF","FindInvPrt",Guser,job,id)),"^",1)    ;发票表rowid
	.q:prtrowid=""
	.s rcptno=$p($g(^TMP("ZYJF","FindInvPrt",Guser,job,id)),"^",2)		;发票号
	.s prtstat=$p($g(^TMP("ZYJF","FindInvPrt",Guser,job,id)),"^",5)		;发票状态
	.;s patname=$p($g(^TMP("ZYJF","FindInvPrt",Guser,job,id)),"^",2)		
	.s billno=$p($g(^TMP("ZYJF","FindInvPrt",Guser,job,id)),"^",7)		;帐单Rowid
	.s prtcom2=$p($g(^TMP("ZYJF","FindInvPrt",Guser,job,id)),"^",11)	;备用字段
	.i prtstat'="作废"  d
	..s disjzamout=0,pbdisamout=0
	..s dhcinvbilldr=$p(^DHCINVPRTZY(prtrowid),"^",5)
	..s pbtotalamt=$P(^DHCPB(dhcinvbilldr),"^",8)  ;总金额
	..s pbdisamout=$P(^DHCPB(dhcinvbilldr),"^",9)  ;折扣金额
	..s pbjzamout=$P(^DHCPB(dhcinvbilldr),"^",11)  ;记帐金额
	..s pbpatpay=$P(^DHCPB(dhcinvbilldr),"^",12)   ;自负金额
	..s disjzamout=pbdisamout+pbjzamout				;把折扣金额与记帐金额合在一起按记帐算.
	.s disjztotalsum=disjztotalsum+disjzamout		;总记帐金额
	.s patamout=$p($g(^TMP("ZYJF","FindInvPrt",Guser,job,id)),"^",3)  ;病人总费用
	.;根据账单Rowid,获取冲退预交金支付方式
	.i prtstat'="作废" d
	..d ..GetDepositPayM(Guser,billno,job,prtstat)
	..s patfee=patfee+patamout     		
	..s pattdeposit=pattdeposit+$p($g(^TMP("ZYJF","FindInvPrt",Guser,job,id)),"^",10)	;病人冲预交金费用
	.;根据账单Rowid,获取预交金支付方式
	.i (rcptno'="")  d
	..i prtstat="作废"  d
	...s zfrcptnum=zfrcptnum+1, zfrcptsum=zfrcptsum+patamout
	...i zfrcptno=""  s zfrcptno=rcptno
	...e  s zfrcptno=zfrcptno_","_rcptno    			;作废收据号
	..i prtstat="冲红"  d                               ;红冲收据号
	...s hcrcptnum=hcrcptnum+1,hcrcptsum=hcrcptsum+patamout                   			
	...i hcrcptno=""  s hcrcptno=rcptno
	...e  s hcrcptno=hcrcptno_","_rcptno
	.i (rcptno="")&(prtcom2'="")  d
	..s prtsubrowid="0"
	..f  s prtsubrowid=$o(^DHCInvprtzySub(0,"InvprtzyDr",prtrowid,prtsubrowid)) q:prtsubrowid=""  d
	...s subinv=$p(^DHCInvprtzySub(prtsubrowid),"^",1)
	...s subacount=$p(^DHCInvprtzySub(prtsubrowid),"^",7)
	...s subflag=$p(^DHCInvprtzySub(prtsubrowid),"^",9)
	...i subinv'=""  d
	....i (subflag'="A")&(subflag'="S")  d
	.....s num=num+1
	.....s ^TMP("ZYJF","InvNo",Guser,job,num)=subinv
	....i subflag="A"  d
	.....i zfrcptno=""  s zfrcptno=subinv
	.....e  s zfrcptno=zfrcptno_","_subinv
	
	s allrcptno=##class(web.UDHCJFBaseCommon).GetINVNOinfo(Guser,"InvNo",job)      ;收据号
	
	s invInfo=username_"^"_allrcptno_"^"_zfrcptno_"^"_zfrcptnum_"^"_zfrcptsum_"^"_hcrcptno_"^"_hcrcptnum_"^"_hcrcptsum_"^"_patfee_"^"_pattdeposit
	
	q invInfo
}

/// Creator：      Lid
/// CreatDate：    2009-01-05
/// Description:： 根据账单号获取预交金支付方式
/// Table：        dhc_sfprintdetail,CT_PayMode
/// Input：        帐单号
/// Output：        
/// Return：       
/// Others：       ^DHCJFDepositRowID("ZYJF",292)=386!2^387!1^397!4^417!3   ;根据账单号获取预交RowID。
///                ^TMP("IPBILL","DepositPayM",payM);用于累加各种支付方式的总额。
ClassMethod GetDepositPayM(Guser, billNO, job, prtstat)
{
	;w ##class(web.UDHCJFDailyHandPrint).GetDepositPayM("3224","3272") 
	//test
	//s ^DHCJFDepositRowID("ZYJF",3224)="823!1^824!1"
	//test	
   
	q:'$d(^DHCJFDepositRowID("ZYJF",billNO))         ;没有押金则退出。
	s depositInfo=^DHCJFDepositRowID("ZYJF",billNO)
	s count=$L(depositInfo,"^")
	f i=1:1:count d
	.s str=$p(depositInfo,"^",i)
	.s depositDr=$p(str,"!",1)
	.s depositStatus=$p(str,"!",2)
	.q:depositStatus="2"   ;如果押金状态为"作废",则退出 
	.s payMDr=$p(^DHCSFPRINTDETAIL(depositDr),"^",9)  ;prt_paymode->CT_PayMode 
	.s amount=$p(^DHCSFPRINTDETAIL(depositDr),"^",6) 
	.i prtstat="冲红" d
	..s amount=0-amount
	.s payM=$p(^CT("CTPM",payMDr),"^",2)
	.i $d(^TMP("IPBILL","DepositPayM",Guser,job,payM))=0  d
	..s ^TMP("IPBILL","DepositPayM",Guser,job,payM)=amount
	.e  s ^TMP("IPBILL","DepositPayM",Guser,job,payM)=^TMP("IPBILL","DepositPayM",Guser,job,payM)+amount
}

/// Lid
/// 2010-07-14
/// 获取支付方式信息
/// 返回值格式:支付方式描述_^_金额_!_支付方式描述_^_金额_!..._#_支付方式描述_^_冲退预交金金额_^_收预交金金额_!_支付方式描述_^_冲退预交金金额_^_收预交金金额_!_...
ClassMethod GetPayModeInfo(Guser, job)
{
	//支付方式金额
	s paydr="0",paymStr=""
	f  s paydr=$o(^CT("CTPM",paydr)) q:paydr=""  d
	.s paydesc=$p(^CT("CTPM",paydr),"^",2)
	.s tmp1=+$g(^TMP("IPBILL","PayModeAmount",job,paydesc))
	.s tmp2=+$g(^TMP("ZYJF","CYJSPAYMODE",job,"收",paydesc))
	.s tmp3=+$g(^TMP("ZYJF","CYJSPAYMODE",job,"退",paydesc))
	.q:((tmp1+tmp2+tmp3)=0)
	.i paymStr="" d
	..s paymStr=paydesc_"^"_+(tmp1+tmp2+tmp3)
	.e  d
	..s paymStr=paymStr_"!"_paydesc_"^"_+(tmp1+tmp2+tmp3)

	s paydr="0",depStr=""
	f  s paydr=$o(^CT("CTPM",paydr)) q:paydr=""  d
	.s paydesc=$p(^CT("CTPM",paydr),"^",2)
	.s tmp4=+$g(^TMP("IPBILL","DepositPayM",Guser,job,paydesc))
	.s tmp5=+$g(^TMP("IPBILL","PayModeAmount",job,paydesc))
	.q:((tmp4=0)&&(tmp5=0))
	.i depStr="" d
	..s depStr="预交金("_paydesc_")"_"^"_$j(tmp4,3,2)_"^"_$j(tmp5,3,2)
	.e  d
	..s depStr=depStr_"!"_"预交金("_paydesc_")"_"^"_$j(tmp4,3,2)_"^"_$j(tmp5,3,2)
	
	s rtn=paymStr_"#"_depStr
	q rtn
}

/// Lid
/// 2010-07-14
/// 计算合计信息
/// 返回值格式:住院大类医保费用_^_住院大类自费费用_^_贷方金额_^_借方金额
/// 注:借方金额=收取的预交金金额(包括收、退金额)
/// /  贷方金额=冲退的预交金金额+病人结算时收退费用+收取的预交金额
ClassMethod GetTotalInfo(cateFee, payModeInfo)
{
	;统计医保费用和自付费用合计
	s YBCateFeeSum=0,ZFCateFeeSum=0
	f i=2:1:$l(cateFee,"!") d
	.s zfamt=+$p($p(cateFee,"!",i),"^",2)
	.s ybamt=+$p($p(cateFee,"!",i),"^",3)
	.s ZFCateFeeSum=ZFCateFeeSum+zfamt
	.s YBCateFeeSum=YBCateFeeSum+ybamt
    
    ;支付方式
    s payMInfo=$p(payModeInfo,"#",1)
    s depPayMInfo=$p(payModeInfo,"#",2)
    s payMAmt=0
    f i=1:1:$l(payMInfo,"!") d
    .s amt=+$p($p(payMInfo,"!",i),"^",2)
    .s payMAmt=payMAmt+amt
    
    ;预交金支付方式
    s sDepAmt=0,tDepAmt=0
    f i=1:1:$l(depPayMInfo,"!") d
    .s tAmt=+$p($p(depPayMInfo,"!",i),"^",2)
    .s sAmt=+$p($p(depPayMInfo,"!",i),"^",3)
	.s sDepAmt=sDepAmt+sAmt
	.s tDepAmt=tDepAmt+tAmt
	
	s rtn=$j(ZFCateFeeSum,3,2)_"^"_$j(YBCateFeeSum,3,2)_"^"_$j((+payMAmt)+(+tDepAmt),3,2)_"^"_$j(sDepAmt,3,2)
	
	q rtn
}

ClassMethod KillTMP(Guser, job)
{
   q:Guser=""  ;by yys 2010.8.18 解决报错
	i $d(^TMP("ZYJF","FindInvPrt",Guser,job)) k ^TMP("ZYJF","FindInvPrt",Guser,job)
	i $d(^TMP("ZYJF","DeptRpt",Guser,job)) k ^TMP("ZYJF","DeptRpt",Guser,job)
	i $d(^TMP("ZYJF","PrtCYJSDetail",Guser,job)) k ^TMP("ZYJF","PrtCYJSDetail",Guser,job)
	i $d(^TMP("IPBILL","DepositPayM",Guser,job)) k ^TMP("IPBILL","DepositPayM",Guser,job)
	i $d(^TMP("IPBILL","PayModeAmount",job)) k ^TMP("IPBILL","PayModeAmount",job)
	i $d(^TMP("ZYJF","CYJSPAYMODE",job)) k ^TMP("ZYJF","CYJSPAYMODE",job)
	i $d(^TMP("ZYJF","InvNo",Guser,job)) k ^TMP("ZYJF","InvNo",Guser,job)
	i $d(^TMP("ZYJF","DepositNo",Guser,job)) k ^TMP("ZYJF","DepositNo",Guser,job)
}

/// Lid 
/// 2010-07-14 
/// 判断报表是否平
/// 返回值:0:平，-1：不平
ClassMethod ReportIsBalance(Guser, job) As %Library.Integer
{
	s rtn=..GetPrintInfo(Guser, job)
	s totalInfo=$p(rtn,$c(2),5)
	s dAmt=+($p(totalInfo,"^",1)+$p(totalInfo,"^",2)+$p(totalInfo,"^",4))
	s jAmt=+$p(totalInfo,"^",3)
	q:dAmt=jAmt 0
	
	q -1
}

ClassMethod GetDailyPrtInfo111(stDate As %String, endDate As %String, inputUserId As %String) As %String
{
  i stDate=""  Set qHandle=$lb(0,repid,0)  Quit $$$OK
  i endDate="" Set qHandle=$lb(0,repid,0)  Quit $$$OK
  f jkdate=stDate:1:endDate d
  .s jkdr=""
  .f  s jkdr=$o(^DHCJFUSERJK(0,"date",jkdate,jkdr)) q:jkdr=""  d
  ..s sdepamt=0,tdepamt=0,acount=0,patdiscount=0,patpayorshare=0,patsharefee=0
  ..s userid=$p(^DHCJFUSERJK(jkdr),"^",5)
  ..q:(inputUserId'="")&(inputUserId'=userid)
}

//

//d ##class(web.UDHCJFDailyHandPrint).GetDailyPrtInfo("JsFunction","17/11/2010","17/12/2010","","DHCJF_IPCashierReports.xls")

ClassMethod GetDailyPrtInfo(JSFunName, stDate, endDate, inputUserId, excelName, printer) As %String
{
    //17/11/2010^17/12/2010^^DHCJF_IPCashierReports.xls
    
    //取结算汇总信息
	s Guser=$G(%session.Data("LOGON.USERID"))
    s job=$j
    ;s ^tmp("wanghc")=stDate_"^"_endDate_"^"_inputUserId_"^"_excelName_"^"_job
	k ^TMP("UDHCJFDailyHandPrint",job)
	i stDate=""  Set qHandle=$lb(0,repid,0)  Quit $$$OK
	i endDate="" Set qHandle=$lb(0,repid,0)  Quit $$$OK
	S stDate=$zdh(stDate,4)
	s endDate=$zdh(endDate,4)
	f jkdate=stDate:1:endDate d
	.s jkdr="" f  s jkdr=$o(^DHCJFUSERJK(0,"date",jkdate,jkdr)) q:jkdr=""  d
	..s userid=$p(^DHCJFUSERJK(jkdr),"^",5)
	..q:(inputUserId'="")&(inputUserId'=userid)
	..i userid'="" s username=$p(^SSU("SSUSR",userid),"^",2)
	..;---------取预交金信息
	..s prtrowid="" f  s prtrowid=$o(^DHCSFPRINTDETAIL(0,"JKDR",jkdr,prtrowid)) q:prtrowid=""  d 
	...s paymode=$p($p(^DHCSFPRINTDETAIL(prtrowid),"^",9),$c(1))
	...s paydesc=$p(^CT("CTPM",paymode),"^",2)
	...s prtDetailstatus=$p($p(^DHCSFPRINTDETAIL(prtrowid),"^",8),$c(1))
	...s payamount=$p($p(^DHCSFPRINTDETAIL(prtrowid),"^",6),$c(1))
	...;Start   获取预交金信息 ; 1 =正常  2 =作废 3 ="冲红" 4 ="已冲红" 5="打印"
	...q:prtDetailstatus=2   ;作废
	...i prtDetailstatus=3 d
	....s ^TMP("UDHCJFDailyHandPrint",job,userid,paydesc_"退")=$g(^TMP("UDHCJFDailyHandPrint",job,userid,paydesc_"退"))+payamount
	...e  d
	....s ^TMP("UDHCJFDailyHandPrint",job,userid,paydesc_"收")=$g(^TMP("UDHCJFDailyHandPrint",job,userid,paydesc_"收"))+payamount
	...;s ^TMP("UDHCJFDailyHandPrint",job,userid,"自费金额")=payamount+$g(^TMP("UDHCJFDailyHandPrint",job,userid,"自费金额"))
	..;-----取发票信息----
	..s invrowid="" 
	..f  s invrowid=$o(^DHCINVPRTZY(0,"JK",jkdr,invrowid)) q:invrowid=""  d
	...s prtFlag=$p(^DHCINVPRTZY(invrowid),"^",8)
	...s patfee=$p(^DHCINVPRTZY(invrowid),"^",6) ;病人费用
	...q:prtFlag="A"
	...s patdeposit=$p(^DHCINVPRTZY(invrowid),"^",22)
	...s arrcpDr=$p(^DHCINVPRTZY(invrowid),"^",17)
	...s paym="0" f  s paym=$o(^ARRCP(arrcpDr,"PAYM",paym)) q:paym=""  d
	....s ss=^ARRCP(arrcpDr,"PAYM",paym)
	....s mode=$p(ss,"^",1)
	....s:mode="" mode="1"
	....s depositPaydesc=$p(^CT("CTPM",paymode),"^",2)
	....s m2=$p(ss,"^",3)
	....s ^TMP("UDHCJFDailyHandPrint",job,userid,depositPaydesc)=$g(^TMP("UDHCJFDailyHandPrint",job,userid,depositPaydesc))+m2
	...s pattype=$p(^DHCINVPRTZY(invrowid),"^",9) 
	...i pattype=1 d
	....s ^TMP("UDHCJFDailyHandPrint",job,userid,"自费金额")=patfee+$g(^TMP("UDHCJFDailyHandPrint",job,userid,"自费金额"))
	...e  d
	....s ^TMP("UDHCJFDailyHandPrint",job,userid,"医保金额")=$g(^TMP("UDHCJFDailyHandPrint",job,userid,"医保金额"))+patfee

	s printObj=##class(web.UDHCJFDailyHandPrint).%New()
	s excelPath = ##class(web.DHCOPConfig).GetPath()_""_excelName
	d printObj.SetCell(3,2,$zd(stDate,3)_"至"_$zd(endDate,3))
	s printOrderStr="医保金额^自费金额^现金收^现金退^银行卡收^银行卡退^支票收^支票退^现金^银行卡^支票"
	s printOrderStrLen=$l(printOrderStr,"^")
	s userRowid=0,row=6,totalLineStr="总计^0^0^0^0^0^0^0^0^0^0^0"
	f  s userRowid=$o(^TMP("UDHCJFDailyHandPrint",job,userRowid)) q:userRowid=""  d
	.s lineStr=$p(^SSU("SSUSR",userRowid),"^",2)
	.f i=1:1:printOrderStrLen d
	..s desc=$p(printOrderStr,"^",i)
	..s amount=$g(^TMP("UDHCJFDailyHandPrint",job,userRowid,desc))
	..s $p(totalLineStr,"^",i+1)=$p(totalLineStr,"^",i+1)+amount
	..s lineStr=lineStr_"^"_amount
	.d printObj.SetCellList(row,1,lineStr)
	.s row=row+1
	d printObj.SetCellList(row,1,totalLineStr)
	s row=row+1
	d printObj.SetCell(row,1,"制表人:"_Guser)
	d printObj.SetCell(row,7,"制表时间:"_$zd(+$h,3))
	s prtTxtInfo=printObj.GetPrintMsg()
	s prtListInfo=printObj.GetPrintListMsg()
	s rtnval=JSFunName_"('"_$ZCVT($g(prtTxtInfo),"O","JS")_"','"_$ZCVT($g(prtListInfo),"O","JS")_"','"_$ZCVT(excelPath,"O","JS")_"','"_printer_"');"
	&javascript<#(rtnval)#>
}

}
