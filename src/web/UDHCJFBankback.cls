Import SQLUser

Class web.UDHCJFBankback Extends BILL.COM.Abstract
{

/// Debug: do ##class(%ResultSet).RunQuery("web.UDHCJFBankback","MoneyDetail","2023-03-01","2023-03-27","123","","","2")
Query MoneyDetail(stdate As %String, enddate As %String, cardno As %String, paymode As %String, payflag As %String, hospId As %String, langId As %String = "", patientId = "") As websys.Query(ROWSPEC = "Tregno:%String:登记号,Tname:%String:患者姓名,Trcptno:%String:收据号,Tcreatdate:%String:交款日期,Tcreattime:%String:交款时间,TpaymId:%String:支付方式ID,TpaymDesc:%String:支付方式,Tsum:%Float:金额,Tstatus:%String:状态,TchequeNo:%String:支票号,TChequeDate:%String:支票日期,TaccNo:%String:账户号,TbankDR:%String:银行ID,Tbank:%String:银行,Tcompany:%String:单位,Tmoneyuser:%String:收款员,Tuser:%String:操作员,Tdate:%String:操作日期,Ttime:%String:操作时间,Tupddate:%String:修改日期,Tupdatetime:%String:修改时间,Tupdateuser:%String:修改人,Tnote:%String:备注,TdepId:%String,Tbankbrowid:%String,TFlagId:%String:到账标识")
{
}

ClassMethod MoneyDetailExecute(ByRef qHandle As %Binary, stdate As %String, enddate As %String, cardno As %String, paymode As %String, payflag As %String, hospId As %String, langId As %String = "", patientId = "") As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	set ^TMP("MoneyDetail")=$lb(stdate, enddate, cardno, paymode, payflag, hospId, langId,patientId)

	if (stdate="")||(enddate="")  quit $$$OK
	
	set stdate=##class(websys.Conversions).DateHtmlToLogical(stdate)
	set enddate=##class(websys.Conversions).DateHtmlToLogical(enddate)
	
	set paymIdStr=##class(web.UDHCJFBankback).GetPayModeIDStr()  //+2022-09-27 ZhYW
	
	if (cardno'="") {
		set depId=0
		while($o(^DHCSFPRINTDETAIL(0,"CardNo",cardno,depId))) {
			set depId=$o(^DHCSFPRINTDETAIL(0,"CardNo",cardno,depId))
			do GetDetail(depId)
		}
		quit $$$OK
	}

	//+2023-3-30 tanfb
	if (patientId'="") {
		set depId=0
		while($ORDER(^DHCSFPRINTDETAIL(0,"PAPMI",patientId,depId))) {
			set depId=$ORDER(^DHCSFPRINTDETAIL(0,"PAPMI",patientId,depId))
			do GetDetail(depId)
		}
		quit $$$OK
	}
	
	for date=stdate:1:enddate {
		set depId=0
		while($o(^DHCSFPRINTDETAIL(0,"PrtDate",date,depId))) {
			set depId=$o(^DHCSFPRINTDETAIL(0,"PrtDate",date,depId))
			do GetDetail(depId)
		}
	}
	
	quit $$$OK
  
GetDetail(depId)
	set depData=$g(^DHCSFPRINTDETAIL(depId))
	set hospDR=$p(depData,"^",44)
	quit:(hospDR'=hospId)
	set creatdate=$p(depData,"^",2)
	quit:((creatdate<stdate)||(creatdate>enddate))
	set creatdate=##class(websys.Conversions).DateLogicalToHtml(creatdate)
	set creattime=$p(depData,"^",3)
	set creattime=##class(websys.Conversions).TimeLogicalToHtml(creattime)
	set depPMSub=$o(^DHCSFPRINTDETAIL(depId,"P",0))
	set depPMData=$g(^DHCSFPRINTDETAIL(depId,"P",+depPMSub))
	set paymDR=$p(depPMData,"^",1)
	quit:(paymDR="")
	quit:(("^"_paymIdStr_"^")'[("^"_paymDR_"^"))
	quit:((paymode'="")&&(paymDR'=paymode))
	set paymDesc=$p($g(^CT("CTPM",paymDR)),"^",2)
	set paymDesc=##class(User.CTPayMode).GetTranByDesc("CTPMDesc", paymDesc, langId)
	set sum=$p(depData,"^",6)
	set sum=$fn(sum,"",2)
	set status=$p(depData,"^",8)
	set status=$case(status,1:"正常",2:"作废",3:"冲红",4:"已冲红",:status)
	set status=##class(websys.Translation).Get("", status, langId)
	set chequeNo=$p(depPMData,"^",4)
	set accNo=$p(depPMData,"^",6)
	set chequeDate=$p(depPMData,"^",7)   //dpm_chequedate
	set chequeDate=##class(websys.Conversions).DateLogicalToHtml(chequeDate)
	set bankDR=$p(depPMData,"^",2)
	set bank=$s((+bankDR'=0):$p($g(^CMC("CMCBM",bankDR)),"^",2),1:"")
	set bank=##class(User.CMCBankMas).GetTranByDesc("CMCBMDesc", bank, langId)
	set unitDR=$p(depPMData,"^",8)
	set company=$s((+unitDR'=0):$p($g(^CT("HCP",unitDR)),"^",2),1:"")
	set company=##class(User.CTHealthCareProvider).GetTranByDesc("HCPDesc", company, langId)
	set moneyuserDR=$p(depData,"^",14)   //prt_adduser_dr
	set moneyuser=$s((moneyuserDR'=""):$p($g(^SSU("SSUSR",moneyuserDR)),"^",2),1:"")
	set moneyuser=##class(User.SSUser).GetTranByDesc("SSUSRName", moneyuser, langId)
	set rcptno=$p(depData,"^",1)
	set adm=$p(depData,"^",4)
	set papmi=$p(depData,"^",7)
	set patname=$p($g(^PAPER(papmi,"ALL")),"^",1)
	set regno=$p($g(^PAPER(papmi,"PAT",1)),"^",1)
	set bbackid=$o(^DHCJFBankBack(0,"Yjrowid",depId,0))
	quit:((payflag=0)&&(bbackid=""))
	do getbback(bbackid)
	quit
getbback(rowid)
	set bankbrowid=rowid, myBackFlagId="", buser="", bdate="", btime=""
	set upddate="", updatetime="", updateuser="", note=""
	set myBackFlagId=""
    if (+rowid'=0) {
	    set backData=$g(^DHCJFBankBack(rowid))
	    set myBackFlagId=$p(backData,"^",4)
	    quit:((payflag'="")&&(myBackFlagId'=payflag))
	    set buserDR=$p(backData,"^",5)
	    set buser=$s((+buserDR'=0):$p($g(^SSU("SSUSR",buserDR)),"^",2),1:"")
	    set buser=##class(User.SSUser).GetTranByDesc("SSUSRName", buser, langId)
	    set bdate=$p(backData,"^",6)
		set bdate=##class(websys.Conversions).DateLogicalToHtml(bdate)
		set btime=$p(backData,"^",7)
		set btime=##class(websys.Conversions).TimeLogicalToHtml(btime)
		set upddate=$p(backData,"^",10)
		set upddate=##class(websys.Conversions).DateLogicalToHtml(upddate)
		set updatetime=$p(backData,"^",11)
		set updatetime=##class(websys.Conversions).TimeLogicalToHtml(updatetime)
		set updateuserDR=$p(backData,"^",12)
		set updateuser=$s((+updateuserDR'=0):$p($g(^SSU("SSUSR",updateuserDR)),"^",2),1:"")
		set updateuser=##class(User.SSUser).GetTranByDesc("SSUSRName", updateuser, langId)
		set note=$p(backData,"^",9)
	}
	do outputbback
	
    quit
outputbback
	set Data=$lb(regno,patname,rcptno,creatdate,creattime,paymDR,paymDesc,sum,status,chequeNo,chequeDate,accNo,bankDR,bank,company,moneyuser,buser,bdate,btime,upddate,updatetime,updateuser,note,depId,bankbrowid,myBackFlagId)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// Debug: w ##class(web.UDHCJFBankback).insertbankb(str)
ClassMethod insertbankb(str As %String)
{
	set depRowId=$p(str,"^",1)
	set invRowId=$p(str,"^",2)
	quit:((+depRowId=0)&&(+invRowId=0)) -1_"^"_"参数错误"
	set bizType=$s((+invRowId'=0):"fp",1:"yj")
	set backFlag=$p(str,"^",3)
 	set userDR=$p(str,"^",4)
	set remark=$p(str,"^",5)
	
	ts

 	&SQL(
 		INSERT INTO DHC_JFBankBack (
 			bback_yjdetail_dr, bback_invprtzy_dr, bback_flag, bback_backflag, bback_user,
 			bback_backdate, bback_backtime, bback_remain
 		)
 		VALUES (
 			:depRowId, :invRowId, :bizType, :backFlag, :userDR,
 			CONVERT(DATE, NOW()), CONVERT(TIME, NOW()), :remark
 		)
 	)
 	set rtn=SQLCODE
 	if (+rtn) tro  quit rtn_"^"_$g(%msg)
 	
 	if ($tl>0) tc
 	
 	quit rtn
}

/// Debug: w ##class(web.UDHCJFBankback).updatebankb("","","")
ClassMethod updatebankb(str As %String)
{
	set rowid=$p(str,"^",1)
	set flag=$p(str,"^",2)
	set upduser=$p(str,"^",3)
	set note=$p(str,"^",4)
  	
	ts
	
	&SQL(
		UPDATE DHC_JFBankBack
		SET bback_backflag = :flag, bback_updateuser = :upduser, bback_updatedate = CONVERT(DATE, NOW()),
			bback_updatetime = CONVERT(TIME, NOW()), bback_remain = :note
		WHERE %ID = :rowid
	)
	set rtn=SQLCODE
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
 	
 	if ($tl>0) tc
	
 	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2022-09-27
/// Description: 查询支票到账业务的支付方式
/// Table: CT_PayMode
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.UDHCJFBankback","QryPayMode")
Query QryPayMode(langId As %String = "") As websys.Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod QryPayModeExecute(ByRef qHandle As %Binary, langId As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	set paymCodeStr=$lb("ZP", "YHK", "HP")    //支票、银行卡、汇票
	for i=1:1:$ll(paymCodeStr) {
		set paymCode=$lg(paymCodeStr,i)
		continue:(paymCode="")
		set id=$o(^CT("CTPM",0,"Code",$$ALPHAUP^SSUTIL4(paymCode),0))
		continue:(id="")
		set data=$g(^CT("CTPM",id))
		set dateFrom=$p(data,"^",5)
		set dateTo=$p(data,"^",6)
		continue:((dateFrom'="")&&(dateFrom>+$h))
		continue:((dateTo'="")&&(dateTo<+$h))
		set text=$p(data,"^",2)
		set text=##class(User.CTPayMode).GetTranByDesc("CTPMDesc",text,langId)
		do OutputPayMode
	}
 	
	quit $$$OK
    
OutputPayMode
	set Data=$lb(id,text)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2022-09-27
/// Description: 获取支票到账业务的支付方式Id串
/// Table: CT_PayMode
/// Input: 
/// Return: 支票到账业务的支付方式Id
/// Debug: w ##class(web.UDHCJFBankback).GetPayModeIDStr()
ClassMethod GetPayModeIDStr()
{
	set paymIdStr=""
	set rset=##class(%ResultSet).%New("web.UDHCJFBankback:QryPayMode")
	do rset.Execute()
	while (rset.Next()) {
		set id=rset.Get("id")
		set paymIdStr=$s((paymIdStr=""):id,1:(paymIdStr_"^"_id))
	}
	quit paymIdStr
}

/// Creator: tanfb
/// CreatDate: 2023-03-30
/// Description: 更新押金支票信息
/// Table: dhc_sfprintdetailpaymode
/// Input: depId 表dhc_sfprintdetail的rowid 必填
/// Return: 
/// Debug: w ##class(web.UDHCJFBankback).UpdtDepChequeInfo()
ClassMethod UpdtDepChequeInfo(depStr, sessionStr)
{
	set userId=$p(sessionStr,"^",1)
	set hospId=$p(sessionStr,"^",4)
	
	set depJson=##class(%DynamicObject).%FromJSON(depStr)
	set chequeNo=depJson.chequeNo      //dpm_cardchequeno 支票号
	set chequeDate=depJson.chequeDate  //dpm_chequedate 支票日期
	quit:(chequeDate="") -1_"^"_"支票日期不能为空"
	set bankId=depJson.bankId    // dpm_bank_dr 银行
	set accNo=depJson.accNo     // dpm_payaccno 账户号
	set chequeDate=##class(websys.Conversions).DateHtmlToLogical(chequeDate)
	ts
 	&SQL(
 		UPDATE dhc_sfprintdetailpaymode
 		SET  dpm_bank_dr = :bankId, dpm_cardchequeno = :chequeNo, dpm_chequedate = :chequeDate, dpm_payaccno = :accNo
		WHERE dpm_prt_parref = :depJson.Id
	)
	set rtn=SQLCODE
	if (+rtn) tro
 	else  tc
	//保存日志
	set obj=##class(%ArrayOfDataTypes).%New()
	set userCode=$p($g(^SSU("SSUSR",userId)),"^",1)
	set userName=$p($g(^SSU("SSUSR",userId)),"^",2)
	do obj.SetAt(userCode, "INMSGUserCode")                       //收费员工号
    do obj.SetAt(+$h, "INMSGDate")
    do obj.SetAt($p($h,",",2), "INMSGTime")
    do obj.SetAt("UpdtDepChequeInfo", "INMSGYWLX")
    do obj.SetAt(userName, "INMSGC1iName")
	if rtn=0 d
	.do obj.SetAt("修改信息,支票号，支票日期，银行，修改为:"_depStr_",修改结果:成功","INMSGMsg")
	else  d
    .do obj.SetAt("修改信息,支票号，支票日期，银行，修改为:"_depStr_",修改结果:"_$g(%msg),"INMSGMsg")
    do obj.SetAt("IP-02", "INMSGProductLine")              //产品线
    do obj.SetAt(hospId, "INMSGHospDr")                    //院区
    do obj.SetAt(depJson.Id, "INMSGBusinessId")            //业务ID
	do ##class(INSU.COM.Tools).Log(obj, "array")
 	quit rtn_"^"_$g(%msg)
}

}
