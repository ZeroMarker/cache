Class web.UDHCJFDepositSearch Extends BILL.COM.Abstract
{

/// Description: 预交金汇总
/// Debug: do ##class(%ResultSet).RunQuery("web.UDHCJFDepositSearch","FindUserDepList","2022-09-23","2022-09-23","","0","","2","")
Query FindUserDepList(stDate As %String, endDate As %String, userId As %String, flag As %String, paymId As %String, hospId As %String, langId As %String = "") As websys.Query(ROWSPEC = "Tpatname:%String:患者姓名,Tregno:%String:登记号,Trcptno:%String:收据号,Tpayamt:%Float:金额,Tpaymode:%String:支付方式,Tstatus:%String:收据状态,Tprtdate:%String:收费日期,Tprttime:%String:收费时间,Thanddate:%String:交账日期,Tuser:%String:收费员,Trowid:%String,Tadmloc:%String:科室,Tchequeno:%String:支票号")
{
}

ClassMethod FindUserDepListExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, userId As %String, flag As %String, paymId As %String, hospId As %String, langId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	set ^TMP("FindUserDepList")=$lb(stDate, endDate, userId, flag, paymId, hospId, langId)
	if ((stDate="")||(endDate="")) quit $$$OK
	
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
	
  	kill ^||TMP($j)

	set prtnum=0
	
  	for date=stDate:1:endDate {
		set depId=0
		while($o(^DHCSFPRINTDETAIL(0,"PrtDate",date,depId))) {
			set depId=$o(^DHCSFPRINTDETAIL(0,"PrtDate",date,depId))
			set depData=$g(^DHCSFPRINTDETAIL(depId))
			set hospDR=$p(depData,"^",44)
			continue:(hospDR'=hospId)
			set userDR=$p(depData,"^",14)
			continue:((userId'="")&&(userDR'=userId))
			set depPMSub=$o(^DHCSFPRINTDETAIL(depId,"P",0))
			set depPMData=$g(^DHCSFPRINTDETAIL(depId,"P",+depPMSub))
			set paymDR=$p(depPMData,"^",1)
			continue:((paymId'="")&&(paymId'=paymDR))
			set prtInitDR=$p(depData,"^",43)
			continue:((flag=1)&&(+prtInitDR=0))
			set ^||TMP($j,userDR,paymDR,depId)=""
		}
  	}
  	
	set totalSum=0
	set userdr=0
	while($o(^||TMP($j,userdr))) {
		set userdr=$o(^||TMP($j,userdr))
		set userSum=0
		set paymDR=0
		while($o(^||TMP($j,userdr,paymDR))) {
			set paymDR=$o(^||TMP($j,userdr,paymDR))
			set paymSum=0
			set depId=0
			while($o(^||TMP($j,userdr,paymDR,depId))) {
				set depId=$o(^||TMP($j,userdr,paymDR,depId))
				set depData=$g(^DHCSFPRINTDETAIL(depId))
				set deposittypedr=$p(depData,"^",13)
				set deposittype=$s((+deposittypedr'=0):$p($g(^ARC("ARCDT",deposittypedr)),"^",2),1:"")
				set deposittype=##class(User.ARCDepType).GetTranByDesc("ARCDTDesc", deposittype, langId)
				set adm=$p(depData,"^",4)
				set papmi=$p(depData,"^",7)
				set papno=$p(^PAPER(papmi,"PAT",1),"^",1)
				set papname=$p(^PAPER(papmi,"ALL"),"^",1)
				set locdr=$p(depData,"^",37)
				set admloc=$s((+locdr'=0):$p($g(^CTLOC(locdr)),"^",2),1:"")
				set admloc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", admloc, langId)
				set rcptno=$p(depData,"^",1)
				set payAmt=$p(depData,"^",6)
				set payAmt=$fn(payAmt,"",2)
				set paymDesc=$p($g(^CT("CTPM",paymDR)),"^",2)
				set paymDesc=##class(User.CTPayMode).GetTranByDesc("CTPMDesc", paymDesc, langId)
				set status=$p(depData,"^",8)
				set prtstatus=$case(+status,1:"正常",2:"作废",3:"红冲",4:"正常",:"")
				set prtstatus=##class(websys.Translation).Get("", prtstatus, langId)
				if (status'=2) {
					set paymSum=$i(paymSum, payAmt)
					set userSum=$i(userSum, payAmt)
					set totalSum=$i(totalSum, payAmt)
				}
				set printdate=$p(depData,"^",2)
				set printdate=##class(websys.Conversions).DateLogicalToHtml(printdate)
				set printtime=$p(depData,"^",3)
				set printtime=##class(websys.Conversions).TimeLogicalToHtml(printtime)
				set handdate=$p(depData,"^",21)
				set handdate=##class(websys.Conversions).DateLogicalToHtml(handdate)
				set userdr=$p(depData,"^",14)
				set username=$s((+userdr'=0):$p($g(^SSU("SSUSR",userdr)),"^",2),1:"") 
		  		set username=##class(User.SSUser).GetTranByDesc("SSUSRName", username, langId)
		  		set depPMSub=$o(^DHCSFPRINTDETAIL(depId,"P",0))
				set depPMData=$g(^DHCSFPRINTDETAIL(depId,"P",+depPMSub))
				set chequeno=$p(depPMData,"^",4)
				do OutputDepList
			}
			do InitOutputDepList
			set papname=##class(websys.Translation).Get("", "支付方式小计", langId)
			set payAmt=$fn(paymSum,"",2)
			do OutputDepList
		}
		do InitOutputDepList
		set papname=##class(websys.Translation).Get("", "收款员小计", langId)
		set payAmt=$fn(userSum,"",2)
		do OutputDepList
	}
	do InitOutputDepList
	set papname=##class(websys.Translation).Get("", "合计", langId)
	set payAmt=$fn(totalSum,"",2)
	do OutputDepList

	kill ^||TMP($j)
	quit $$$OK
InitOutputDepList
	set papname="",papno="",rcptno="",payAmt="",paymDesc="",prtstatus="",printdate="",printtime=""
	set handdate="",username="",depId="",admloc="",chequeno=""
	quit
OutputDepList
	set Data=$lb(papname,papno,rcptno,payAmt,paymDesc,prtstatus,printdate,printtime,handdate,username,depId,admloc,chequeno)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Description: 查询住院患者冲退预交金记录
/// Debug: do ##class(%ResultSet).RunQuery("web.UDHCJFDepositSearch","FindDepositByStrike","2022-07-31","2022-09-26","","0","2","")
Query FindDepositByStrike(StDate As %String, EndDate As %String, Guser As %String, flag As %String, HospId As %String, LangId As %String = "") As websys.Query(ROWSPEC = "TInvNo:%String:发票号,TMedicareNo:%String:病案号,TPatName:%String:患者姓名,TRcptNo:%String:收据号,TLocDesc:%String:就诊科室,TPrintDate:%String:收费日期,TPrintTime:%String:收费时间,TPayAmt:%Float:金额,TPayModeDesc:%String:支付方式,TPrtStatus:%String:状态,TUserName:%String:操作员,TInvPrtDate:%String:冲账日期,TInvPrtTime:%String:冲账时间,TInvUserName:%String:结算操作员") [ SqlProc ]
{
}

ClassMethod FindDepositByStrikeExecute(ByRef qHandle As %Binary, StDate As %String, EndDate As %String, Guser As %String, flag As %String, HospId As %String, LangId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	set ^TMP("FindDepositByStrike")=$lb(StDate, EndDate, Guser, flag, HospId, LangId)
	if ((StDate="")||(EndDate="")) quit $$$OK

	if ((LangId="")&&($d(%session))) {
		set LangId=%session.Get("LOGON.LANGID")
	}
	
	set StDate=##class(websys.Conversions).DateHtmlToLogical(StDate)
	set EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)

	set AllStrikSum=0

	if (flag=1) {
		for Date=StDate:1:EndDate {
			set ReportsDR=0
			while($o(^DHCJFUSERJK(0,"date",Date,ReportsDR))) {
				set ReportsDR=$o(^DHCJFUSERJK(0,"date",Date,ReportsDR))
				set HospDR=$p($g(^DHCJFUSERJK(ReportsDR)),"^",27)
				continue:(HospDR'=HospId)
				set PrtRowId=0
				while($o(^DHCINVPRTZY(0,"JK",ReportsDR,PrtRowId))) {
					set PrtRowId=$o(^DHCINVPRTZY(0,"JK",ReportsDR,PrtRowId))
					do GetStrikeDept(PrtRowId)
				}
			}
		}
		set (InvNo,MrNo,RegNo,PatName,RcptNo,Dept,PrintDate,PrintTime,PayAmt,PayModeDesc,prtstatus,UserName,PrtDate,InvUserName)=""
		set PayAmt=AllStrikSum
		set PayAmt=$fn(PayAmt,"",2)
		set InvNo=##class(websys.Translation).Get("", "合计", LangId)
		do OutputStrikeDept
	}else {
		for Date=StDate:1:EndDate {
			set PrtRowId=0
			while($o(^DHCINVPRTZY(0,"DATE",Date,PrtRowId))) {
				set PrtRowId=$o(^DHCINVPRTZY(0,"DATE",Date,PrtRowId))
				set HospDR=$p($g(^DHCINVPRTZY(PrtRowId)),"^",35)
				continue:(HospDR'=HospId)
				do GetStrikeDept
			}
		}
		set (InvNo,MrNo,RegNo,PatName,RcptNo,Dept,PrintDate,PrintTime,PayAmt,PayModeDesc,PrtStatus,UserName,InvPrtDate,InvPrtTime,InvUserName)=""
		set PayAmt=AllStrikSum
		set PayAmt=$fn(PayAmt,"",2)
		set InvNo=##class(websys.Translation).Get("", "合计", LangId)
		do OutputStrikeDept
	}

	quit $$$OK

GetStrikeDept
	set PrtInvData=$g(^DHCINVPRTZY(PrtRowId))
	set PrtFlag=$p(PrtInvData,"^",8)
	quit:(PrtFlag="A")
	set UserDR=$p(PrtInvData,"^",7)
	quit:((UserDR'=Guser)&&(Guser'=""))
	set InvUserName=$p(^SSU("SSUSR",UserDR),"^",2)
	set InvUserName=##class(User.SSUser).GetTranByDesc("SSUSRName", InvUserName, LangId)
	set InvPrtDate=$p(PrtInvData,"^",2)
	set InvPrtDate=##class(websys.Conversions).DateLogicalToHtml(InvPrtDate)
	set InvPrtTime=$p(PrtInvData,"^",3)
	set InvPrtTime=##class(websys.Conversions).TimeLogicalToHtml(InvPrtTime)
	set InvNo=$p(PrtInvData,"^",1)
	set adm=$p(PrtInvData,"^",4)
	set DeptDR=$p(^PAADM(adm),"^",4)
	set Dept=$s((+DeptDR'=0):$p($g(^CTLOC(DeptDR)),"^",2),1:"")
	set Dept=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", Dept, LangId)
	set InitInvDR=$p(PrtInvData,"^",13)
	set conId=0
	while($o(^DHCINVPRTZYCONDEPi(0,"Inv",PrtRowId,conId))) {
		set conId=$o(^DHCINVPRTZYCONDEPi(0,"Inv",PrtRowId,conId))
		set conData=$g(^DHCINVPRTZYCONDEP(conId))
		continue:(conData="")
		set DepRowID=$p(conData,"^",3)
		continue:(DepRowID="")
		do GetDepositDetail
	}
	
	quit
GetDepositDetail
	set DepData=$g(^DHCSFPRINTDETAIL(DepRowID))
	set UserDR=$p(DepData,"^",14)
	set UserName=$p(^SSU("SSUSR",UserDR),"^",2)
	set UserName=##class(User.SSUser).GetTranByDesc("SSUSRName", UserName, LangId)
	set Adm=$p(DepData,"^",4)
	set DeptDR=$p(DepData,"^",37)
	set Dept=$s((+DeptDR'=0):$p(^CTLOC(DeptDR),"^",2),1:"")
	set Dept=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", Dept, LangId)
	set DepStatus=$p(DepData,"^",8)
	set PrtStatus=$case(+DepStatus,1:"正常",2:"作废",3:"红冲",4:"正常",:"")
	set PrtStatus=##class(websys.Translation).Get("", PrtStatus, LangId)
	set Papmi=$p(DepData,"^",7)
	set RegNo=$p(^PAPER(Papmi,"PAT",1),"^",1)
	set PatName=$p(^PAPER(Papmi,"ALL"),"^",1)
	set MrNo=##class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(Adm, "I", "")
	set DepPMSub=$o(^DHCSFPRINTDETAIL(DepRowID,"P",0))
	set DepPMData=$g(^DHCSFPRINTDETAIL(DepRowID,"P",+DepPMSub))
	set PayModeDR=$p(DepPMData,"^",1)
	set PayModeDesc=$s((+PayModeDR'=0):$p($g(^CT("CTPM",PayModeDR)),"^",2),1:"")
	set PayModeDesc=##class(User.CTPayMode).GetTranByDesc("CTPMDesc", PayModeDesc, LangId)
	set RcptNo=$p(DepData,"^",1)
	set PrintDate=$p(DepData,"^",2)
	set PrintDate=##class(websys.Conversions).DateLogicalToHtml(PrintDate)
	set PrintTime=$p(DepData,"^",3)
	set PrintTime=##class(websys.Conversions).TimeLogicalToHtml(PrintTime)
	set PayAmt=$p(DepData,"^",6)
	set PayAmt=$fn(PayAmt,"",2)
	if (+InitInvDR'=0) set PayAmt=0-PayAmt
	set AllStrikSum=AllStrikSum+PayAmt
	do OutputStrikeDept
	quit
OutputStrikeDept
    set Data=$lb(InvNo,MrNo,PatName,RcptNo,Dept,PrintDate,PrintTime,PayAmt,PayModeDesc,PrtStatus,UserName,InvPrtDate,InvPrtTime,InvUserName)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: yyx
/// CreateDate: 2010-11-21
/// Description: 查询全院未结算押金明细
Query FindUnPaidDeposit(hospId As %String, wardId As %String, langId As %String = "") As websys.Query(ROWSPEC = "Tpatname:%String:患者姓名,Tregno:%String:登记号,Trcptno:%String:收据号,Tpayamt:%Float:金额,Tpaymode:%String:支付方式,Tstatus:%String:收据状态,Tprtdate:%String:打印日期,Tprttime:%String:打印时间,Tuser:%String:收款员,Trowid:%String,Tadmloc:%String:就诊科室,Tchequeno:%String:支票号,TDepositType:%String:押金类型") [ SqlProc ]
{
}

ClassMethod FindUnPaidDepositExecute(ByRef qHandle As %Binary, hospId As %String, wardId As %String, langId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	set PaySum=0
	
	set PrtRowID=0
	while($o(^DHCSFPRINTDETAIL(0,"PaidFlag","N",PrtRowID))) {
		set PrtRowID=$o(^DHCSFPRINTDETAIL(0,"PaidFlag","N",PrtRowID))
		set PrtData=$g(^DHCSFPRINTDETAIL(PrtRowID))
		set HospDR=$p(PrtData,"^",44)
		continue:(HospDR'=hospId)
		set DepositTypeDR=$p(PrtData,"^",13)
		set DepositType=$s((+DepositTypeDR'=0):$p($g(^ARC("ARCDT",DepositTypeDR)),"^",2),1:"")
		set DepositType=##class(User.ARCDepType).GetTranByDesc("ARCDTDesc", DepositType, langId)
		set WardDR=$p(PrtData,"^",36)
		continue:((wardId'="")&&(wardId'=WardDR))
		set WardDesc=$p(^PAWARD(WardDR),"^",2)
		set WardDesc=##class(User.PACWard).GetTranByDesc("WARDDesc", WardDesc, langId)
		set AdmDR=$p(PrtData,"^",4)
		set PAPMI=$p(PrtData,"^",7)
		set RegNo=$p(^PAPER(PAPMI,"PAT",1),"^",1)
		set PatName=$p(^PAPER(PAPMI,"ALL"),"^",1)
		set LocDR=$p(PrtData,"^",37)
		set Dept=$s((+LocDR'=0):$p($g(^CTLOC(LocDR)),"^",2),1:"")
		set Dept=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", Dept, langId)
		set PrtInvNo=$p(PrtData,"^",1)
		set PayAmt=$p(PrtData,"^",6)
		set PayAmt=$fn(PayAmt,"",2)
		set DepPMSub=$o(^DHCSFPRINTDETAIL(PrtRowID,"P",0))
		set DepPMData=$g(^DHCSFPRINTDETAIL(PrtRowID,"P",+DepPMSub))
		set PayModeDR=$p(DepPMData,"^",1)
		set PayModeDesc=$s((+PayModeDR'=0):$p($g(^CT("CTPM",PayModeDR)),"^",2),1:"")
		set PayModeDesc=##class(User.CTPayMode).GetTranByDesc("CTPMDesc", PayModeDesc, langId)
		set ChequeNo=$p(DepPMData,"^",4)
		set PrtStatus=$p(PrtData,"^",8)
		set PrtStatus=$case(+PrtStatus,1:"正常",2:"作废",3:"红冲",4:"正常",:"")
		set PrtStatus=##class(websys.Translation).Get("", PrtStatus, langId)
		set PrtDate=$p(PrtData,"^",2)
		set PrtTime=$p(PrtData,"^",3)
		set PrtDate=##class(websys.Conversions).DateLogicalToHtml(PrtDate)
		set PrtTime=##class(websys.Conversions).TimeLogicalToHtml(PrtTime)
		set UserDR=$p(PrtData,"^",14)
		set UserName=$p(^SSU("SSUSR",UserDR),"^",2)
		set UserName=##class(User.SSUser).GetTranByDesc("SSUSRName", UserName, langId)
		set PaySum=$i(PaySum, PayAmt)
		do OutputUnPaidDepList
	}

	set (PatName,RegNo,PrtInvNo,PayAmt,PayModeDesc,PrtStatus,PrtDate,PrtTime,UserName,PrtRowID,Dept,ChequeNo,DepositType)=""
	set PatName=##class(websys.Translation).Get("", "合计", langId)
	set PayAmt=$fn(PaySum,"",2)
	do OutputUnPaidDepList

	quit $$$OK

OutputUnPaidDepList  
	set Data=$lb(PatName,RegNo,PrtInvNo,PayAmt,PayModeDesc,PrtStatus,PrtDate,PrtTime,UserName,PrtRowID,Dept,ChequeNo,DepositType)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

}
