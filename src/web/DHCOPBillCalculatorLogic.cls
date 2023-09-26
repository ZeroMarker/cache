/// Lid
/// 2010-07-08
/// 门诊计算器业务处理
Class web.DHCOPBillCalculatorLogic Extends %RegisteredObject
{

/// Creator: Lid
/// CreatDate: 2010-07-08
/// Description: 根据当前发票号查询指定发票的支付方式
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCOPBillCalculatorLogic","QryInvPayMDetails","1528","3300")
Query QryInvPayMDetails(Guser As %String, job As %String, langId As %String = "") As websys.Query(ROWSPEC = "TPayMDesc:%String:支付方式,TAmt:%Float:金额")
{
}

ClassMethod QryInvPayMDetailsExecute(ByRef qHandle As %Binary, Guser As %String, job As %String, langId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	if ((Guser="")||(job=""))  quit $$$OK
	
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	set payMDr=0
	while($o(^TMP("OPBILL","CalPayM",Guser,job,payMDr))) {
		set payMDr=$o(^TMP("OPBILL","CalPayM",Guser,job,payMDr))
		set payMDesc=$p($g(^CT("CTPM",payMDr)),"^",2)
		set payMDesc=##class(User.CTPayMode).GetTranByDesc("CTPMDesc", payMDesc, langId)
		set amt=+$g(^TMP("OPBILL","CalPayM",Guser,job,payMDr))
		set amt=$fn(amt,"",2)
		do OutPayMDetails
	}
    
	quit $$$OK
	
OutPayMDetails
	set Data=$lb(payMDesc,amt)
	set ^CacheTemp(repid,ind)=Data
	set ind=ind+1
	quit
}

/// Creator: Lid
/// CreatDate: 2010-07-08
/// Description: 生成数据:
///      1.把支付方式数据保存的临时Global中待用
///      2.返回发票金额信息
/// totalAmt_"^"_shareAmt_"^"_discAmt_"^"_payorAmt_"^"_roundErrAmt_"^"_ybAmt
/// 返回值格式:进程号^总金额^自付金额^折扣金额^记账金额^四舍五入金额^医保金额^现金支付金额
/// Debug: w ##class(web.DHCOPBillCalculatorLogic).GetInvFeeData("1528","","1")
ClassMethod GetInvFeeData(Guser As %String, HospId As %String, CurrentNO As %String = "", InvNum As %String = "") As %String
{
	set job=$j
	kill ^TMP("OPBILL","CalPayM",Guser,job)
	set (totalAmt,shareAmt,discAmt,payorAmt,ybAmt,roundErrAmt,CASHAmt)=0
	set numFlag=1
	set prtRowid=""
	while($o(^DHCINVPRT(0,"User",Guser,prtRowid),-1)) {
		set prtRowid=$o(^DHCINVPRT(0,"User",Guser,prtRowid),-1)
		quit:(numFlag>InvNum)
		set prtData=$g(^DHCINVPRT(prtRowid))
		continue:(prtData="")
		set fairType=$p(prtData,"^",34)             		;发票标志(R:括号发票，F:收费发票)
		continue:(" R F "'[(" "_fairType_" "))              ;过滤"挂号发票"
		set hospDR=$p(prtData,"^",39)
		continue:(hospDR'=HospId)
		//set prtFlag=$p(prtData,"^",3)               		;是否打印发票标志(P:打印完发票,非P:没有打印发票)
		//continue:(prtFlag'="P")                           ;过滤没打印发票的记录
		set status=$p(prtData,"^",8)                		;发票状态
		continue:(status'="N")                        		;过滤"非正常"状态的发票
		set totalAmt=totalAmt+$p(prtData,"^",1)  		    ;总金额
	    set shareAmt=shareAmt+$p(prtData,"^",16) 		    ;自付金额
	    set discAmt=discAmt+$p(prtData,"^",7)    		    ;折扣金额
	    set payorAmt=payorAmt+$p(prtData,"^",18)            ;记账金额
	    set ybAmt=ybAmt+$p(prtData,"^",31)                  ;医保支付金额
	    set roundErrAmt=roundErrAmt+$p(prtData,"^",37)      ;分币误差金额
		do ..GetPayMInfoByPrtRowid(prtRowid, Guser, job)    ;生成支付方式信息
	    set numFlag=$i(numFlag)
	}
    
    ;获取"现金"支付金额
	set payMDr=0
	while($o(^TMP("OPBILL","CalPayM",Guser,job,payMDr))) {
		set payMDr=$o(^TMP("OPBILL","CalPayM",Guser,job,payMDr))
		set payMAmt=$g(^TMP("OPBILL","CalPayM",Guser,job,payMDr))
		set payMCode=$p(^CT("CTPM",payMDr),"^",1)
		if (payMCode["CASH") set CASHAmt=+payMAmt
	}

    ;进程号^总金额^自付金额^折扣金额^记账金额^四舍五入金额^医保金额^现金支付金额
    set rtn=job_"^"_totalAmt_"^"_shareAmt_"^"_discAmt_"^"_payorAmt_"^"_roundErrAmt_"^"_ybAmt_"^"_CASHAmt
    quit rtn
}

/// Creator: Lid
/// CreatDate: 2010-07-08
/// Description: 根据发票Rowid获取支付方式信息
/// Debug: w ##class(web.DHCOPBillCalculatorLogic).GetPayMInfoByPrtRowid("")
ClassMethod GetPayMInfoByPrtRowid(prtRowid As %String, Guser As %String, job As %String) As %String
{
	set IPMSub=0
	while($o(^DHCINVPRT(prtRowid,"P",IPMSub))) {
		set IPMSub=$o(^DHCINVPRT(prtRowid,"P",IPMSub))
		set data=$g(^DHCINVPRT(prtRowid,"P",IPMSub))
		continue:(data="")
		set IPMAmt=+$p(data,"^",3)    ;金额
		set IPMPayMDr=$p(data,"^",1)  ;CT_PayMode.RowId
		set ^TMP("OPBILL","CalPayM",Guser,job,IPMPayMDr)=+$g(^TMP("OPBILL","CalPayM",Guser,job,IPMPayMDr))+IPMAmt
	}
	
	quit
}

/// Creator: Lid
/// CreatDate: 2010-07-08
/// Description: 页面卸载时，清除临时数据
ClassMethod ClearTemporaryData(Guser As %String, job As %String)
{
	quit:((Guser="")||(job="")) 0
	kill ^TMP("OPBILL","CalPayM",Guser,job)
	quit 0
}

}
