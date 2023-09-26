Import SQLUser

Class web.DHCOPQFPat Extends BILL.COM.Abstract
{

/// w ##class(web.DHCOPQFPat).CheckWarBal("141^","97.72","0")
ClassMethod CheckWarBal(admStr As %String, payAmt As %String, sFlag As %String) As %String
{
	set rtn=0
	quit:(+sFlag'=0) rtn
	
    set warrSum=0    //担保金额
    set oweSum=0
    for i=1:1:$l(admStr,"^") {
	    set adm=$p(admStr,"^",i)
	    continue:(+adm=0)
	    set warrAmt=##class(web.DHCOPBillWarrant).GetWarrAmt(adm)
	    set warrSum=$i(warrSum, warrAmt)
	    set oweDR=0
	    while($o(^DHCOPQFPatInfo(0,"Adm",adm,oweDR))) {
		    set oweDR=$o(^DHCOPQFPatInfo(0,"Adm",adm,oweDR))
			set oweData=$g(^DHCOPQFPatInfo(oweDR))
		   	continue:(oweData="")
		    set flag=$p(oweData,"^",7)
		    continue:(flag="Restore")
		    set status=$p(oweData,"^",8)
		    continue:(status'="N")
		    continue:($d(^DHCOPQFPatInfo(0,"LinkTo",oweDR)))
		    set oweAmt=$p(oweData,"^",2)
		    set oweSum=$i(oweSum, oweAmt)
		}
    }
    quit:(+warrSum'>0) -1_"^"_"没有有效的担保信息，不能欠费结算"
    
    set balance=warrSum-oweSum
    if ((+$zabs(payAmt)>+$zabs(balance))||(balance<0)) {
    	set rtn=-2_"^"_"担保金额不足，不能欠费结算"
    }
    
    quit rtn
}

/// Description: 获取患者门急诊欠费费用
/// Input: Papmi:PA_PatMas.RowId, HospId:CT_Hospital
/// Return: 欠费费用
/// Debug: w ##class(web.DHCOPQFPat).GetQFTotal(25, 2)
ClassMethod GetQFTotal(Papmi As %String, HospId As %String)
{
    set OweSum=0
    quit:(+Papmi=0) OweSum
    
    set date=0
    while($o(^DHCOPQFPatInfo(0,"Papmi",+Papmi,date))) {
	    set date=$o(^DHCOPQFPatInfo(0,"Papmi",+Papmi,date))
	 	set OweDR=0
	    while($o(^DHCOPQFPatInfo(0,"Papmi",+Papmi,date,OweDR))) {
		    set OweDR=$o(^DHCOPQFPatInfo(0,"Papmi",+Papmi,date,OweDR))
			set data=$g(^DHCOPQFPatInfo(OweDR))
		    continue:(data="")
			set hospDR=$p(data,"^",13)
		    continue:(hospDR'=HospId)
		    set stat=$p(data,"^",8)
		    continue:(stat'="N")
		    set amt=$p(data,"^",2)
			set flag=$p(data,"^",7)
		    if (flag="Restore") {
			    set amt=-amt
			}
		    set OweSum=$i(OweSum, amt)
		}   
	}

	set OweSum=$fn(OweSum,"",2)
	
    quit OweSum
}

/// w ##class(web.DHCOPQFPat).INSERTOPQFPat()
ClassMethod INSERTOPQFPat(QFInfoStr As %String) As %String
{
	set adm=$p(QFInfoStr,"^",1)
	set papmi=$p(QFInfoStr,"^",2)
	set creatDate=$p(QFInfoStr,"^",3)
	set creatTime=$p(QFInfoStr,"^",4)
	set amount=$p(QFInfoStr,"^",5)
	set userDR=$p(QFInfoStr,"^",6)
	set prtInvDR=$p(QFInfoStr,"^",7)
	set hospDR=$p(QFInfoStr,"^",8)
	&SQL(
		INSERT INTO DHC_OPQFPatTotal (
			QF_Adm, QF_Papmi_Dr, QF_Date, QF_Time, QF_Amount,
			QF_Flag, QF_AddUser, QF_Status, QF_Prt_dr, QF_Hosp_DR
		)
		VALUES (
			:adm, :papmi, :creatDate, :creatTime, :amount,
			'Owe', :userDR, 'N', :prtInvDR, :hospDR
		)
	)
	set rtn=SQLCODE
	if (+rtn) quit rtn_"^"_$g(%msg)
	quit rtn
}

/// Debug: do ##class(%ResultSet).RunQuery("web.DHCOPQFPat","PatQFDetail","","","2022-03-01","2022-06-08","17275^239^3^2^20")
Query PatQFDetail(PatientNo As %String, PatientId As %String, StDate As %String, EndDate As %String, SessionStr As %String) As websys.Query(ROWSPEC = "PatientId:%String:患者ID,PatientNo:%String:登记号,PatName:%String:患者姓名,QFRowID:%String:欠费ID,PrtRowId:%String:结算ID,PrtDate:%String:结算日期,PrtTime:%String:结算时间,PrtUser:%String:收费员,Acount:%Float:金额,InsTypeDR:%String:结算费别ID,InsType:%String:结算费别,AdmSource:%String,InsuDivDR:%String:医保结算ID")
{
}

ClassMethod PatQFDetailExecute(ByRef qHandle As %Binary, PatientNo As %String, PatientId As %String, StDate As %String, EndDate As %String, SessionStr As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	set ^TMP("PatQFDetail")=$lb(PatientNo, PatientId, StDate, EndDate, SessionStr)
	
	set StDate=##class(websys.Conversions).DateHtmlToLogical(StDate)
	set EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	
	set HospId=$p(SessionStr,"^",4)
	set LangId=$p(SessionStr,"^",5)
	
	if ((PatientId="")&&(PatientNo'="")) {
		set PatientNo=##class(web.UDHCJFBaseCommon).regnocon(PatientNo)
		set PatientId=$o(^PAPERi("PAPMI_PatNo",PatientNo,""))
	}
	if (PatientId'="") {
		set Date=""
		while($o(^DHCOPQFPatInfo(0,"Papmi",PatientId,Date))) {
			set Date=$o(^DHCOPQFPatInfo(0,"Papmi",PatientId,Date))
			/*
			continue:((StDate'="")&&(Date<StDate))
			continue:((EndDate'="")&&(Date>EndDate))
			*/
			set QFRowID=0
			while($o(^DHCOPQFPatInfo(0,"Papmi",PatientId,Date,QFRowID))) {
				set QFRowID=$o(^DHCOPQFPatInfo(0,"Papmi",PatientId,Date,QFRowID))
				do GetQFInfo
			}
		}
		quit $$$OK
	}
	
	for myDate=StDate:1:EndDate {
		set QFRowID=0
		while($o(^DHCOPQFPatInfo(0,"Date",myDate,QFRowID))) {
			set QFRowID=$o(^DHCOPQFPatInfo(0,"Date",myDate,QFRowID))
			do GetQFInfo
		}
	}
	
	quit $$$OK
GetQFInfo
	set QFData=$g(^DHCOPQFPatInfo(QFRowID))
	set HospDR=$p(QFData,"^",13)
	quit:(HospDR'=HospId)
	set flag=$p(QFData,"^",7)
	quit:(flag="Restore")
 	set stat=$p(QFData,"^",8)
  	quit:(stat'="N")
	set PrtInvDR=$p(QFData,"^",12)
	set newPrtDR=$o(^DHCINVPRT(0,"OldINV",PrtInvDR,""))
	if (newPrtDR'="") {
		set newOweDR=$o(^DHCOPQFPatInfo(0,"InvPrt",newPrtDR,""))
		if (newOweDR'="") {
			set resFlag=$p(^DHCOPQFPatInfo(newOweDR),"^",7)
			quit:(resFlag="Restore")
		}
	}
	set PrtFlag=$p($g(^DHCINVPRT(PrtInvDR)),"^",8)
	quit:(PrtFlag'="N")     //过滤作废发票记录
	set InsTypeDR=$p($g(^DHCINVPRT(PrtInvDR)),"^",9)
	set InsType=$s((+InsTypeDR'=0):$p(^PAC("ADMREA",InsTypeDR),"^",2),1:"")
	set InsType=##class(User.PACAdmReason).GetTranByDesc("READesc", InsType, LangId)
  	set AdmSource=$p(^PAC("ADMREA",InsTypeDR),"^",9)
  	set InsuDivDR=$p($g(^DHCINVPRT(PrtInvDR)),"^",30)
   	set PrtDate=$p(QFData,"^",5)
  	set PrtDate=##class(websys.Conversions).DateLogicalToHtml(PrtDate)
  	set PrtTime=$p(QFData,"^",6)
	set PrtTime=##class(websys.Conversions).TimeLogicalToHtml(PrtTime)
	set UserDR=$p(QFData,"^",4)
	set UserName=$s((UserDR'=""):$p(^SSU("SSUSR",UserDR),"^",2),1:"")
	set UserName=##class(User.SSUser).GetTranByDesc("SSUSRName", UserName, LangId)
	set Acount=$p(QFData,"^",2)
	set Acount=$fn(Acount,"",2)
	set PAPMI=$p(QFData,"^",1)
	set RegNo=$p(^PAPER(PAPMI,"PAT",1),"^",1)
	set PatName=$p(^PAPER(PAPMI,"ALL"),"^",1)
	do OutputPatQFList
	quit
OutputPatQFList
	set Data=$lb(PAPMI,RegNo,PatName,QFRowID,PrtInvDR,PrtDate,PrtTime,UserName,Acount,InsTypeDR,InsType,AdmSource,InsuDivDR)
	set ^CacheTemp(repid,ind)=Data
	set ind=ind+1
	quit
}

/// 欠费补回
/// Debug: w ##class(web.DHCOPQFPat).Restoring("12072","0.52","5","1","49^122^2")
ClassMethod Restoring(PrtRowId As %String, RestoreAmt As %String, NewInsType As %String, SessionStr As %String)
{
	set $zt="ERROR"
	set ^TMP("Restoring")=$lb(PrtRowId, RestoreAmt, NewInsType, SessionStr)
	
	set UserId=$p(SessionStr,"^",1)
	set GroupId=$p(SessionStr,"^",2)
	set CTLocId=$p(SessionStr,"^",3)
	set HospId=$p(SessionStr,"^",4)
	
	quit:(+PrtRowId=0) -1_"^"_"参数错误"
	
    set PrtFlag=$p($g(^DHCINVPRT(PrtRowId)),"^",8)
	quit:(PrtFlag'="N") -1_"^"_"发票状态为"_PrtFlag_"，不能补回"
	
	set QFPaySum=0
	set paymSub=0
	while($o(^DHCINVPRT(PrtRowId,"P",paymSub))) {
		set paymSub=$o(^DHCINVPRT(PrtRowId,"P",paymSub))
		set paymData=$g(^DHCINVPRT(PrtRowId,"P",paymSub))
		continue:(paymData="")
		set paymDR=$p(paymData,"^",1)
		set paymAmt=$p(paymData,"^",3)
		set PaymCode=$p(^CT("CTPM",paymDR),"^",1)
		continue:(PaymCode'="QF")
		set QFPaySum=$i(QFPaySum, paymAmt)
	}
    quit:(+QFPaySum'=+RestoreAmt) -1_"^"_"欠费金额和补回金额不符"
    
	set InitQFRowId=$o(^DHCOPQFPatInfo(0,"InvPrt",PrtRowId,0))
	quit:(+InitQFRowId=0) -1_"^"_"欠费记录不存在"

	set rtn=0

	ts
	
	set PrtData=$g(^DHCINVPRT(PrtRowId))
	set InvPrintFlag=$p(PrtData,"^",3)   //PRT_INVPrintFlag
	set InvRequireFlag=$case(InvPrintFlag,"P":"Y",:"N")
	set ReportsDR=$p(PrtData,"^",6)
	set PrtUserDR=$p(PrtData,"^",21)
	set SFlag=$s(((+ReportsDR=0)&&(PrtUserDR=UserId)):"A",1:"S")
	//set InvAcount=$p(PrtData,"^",1)
	set InvPatShare=$p(PrtData,"^",16)   //+2017-06-16 ZhYW
	set MulityPayMFlag=""
	set ExpStr=MulityPayMFlag_"^"_InvRequireFlag

	set rtnValue=##class(web.udhcOPRefEditIF).RefundReceipt(PrtRowId, UserId, SFlag, "", InvPatShare, GroupId, 1, CTLocId, "", NewInsType, ExpStr)
	set rtn=$p(rtnValue,"^",1)
	if (+rtn) tro  quit rtnValue
	
	set newInvRowId=$p(rtnValue,"^",2)
	set strikeInvRowId=$p(rtnValue,"^",3)
	
	set myQFObj=##class(User.DHCOPQFPatTotal).%OpenId(InitQFRowId, 0)
	set myQFObj.QFStatus="N"
	set sc=myQFObj.%Save()
	do myQFObj.%Close()
	if $$$ISERR(sc) {
		tro
		quit $system.Status.GetErrorCodes(sc)_"^"_$system.Status.GetErrorText(sc)
	}
	set myNewQFObj=##class(User.DHCOPQFPatTotal).%New()
	set myNewQFObj=myQFObj.%ConstructClone(-1)
	set myNewQFObj.QFDate=+$h
	set myNewQFObj.QFTime=$p($h,",",2)
	set myNewQFObj.QFFlag="Restore"
	do myNewQFObj.QFAddUserSetObjectId(UserId)
	do myNewQFObj.QFPrtdrSetObjectId(newInvRowId)
	do myNewQFObj.QFInitDRSetObjectId(InitQFRowId)
	set sc=myNewQFObj.%Save()
	do myNewQFObj.%Close()
	if $$$ISERR(sc) {
		tro
		quit $system.Status.GetErrorCodes(sc)_"^"_$system.Status.GetErrorText(sc)
	}
	
	if ($tl>0) tc

	quit rtn_"^"_newInvRowId_"^"_strikeInvRowId

ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2017-06-01
/// Description: 更新挂号表发票关联
/// Input: prtRowIDStr:结算记录RowID串
/// Return: 0 成功 (发票不包含挂号费诊察费不用更新或包含同时更新成功); 非0:(包含挂号费诊察费但是更新不成功)
/// Debug: w ##class(web.DHCOPQFPat).UpdateRegistionFeeInv("^213206^")
ClassMethod UpdateRegistionFeeInv(prtRowIDStr As %String) As %String
{
	set rtn=0
	for i=1:1:$l(prtRowIDStr,"^") {
		set prtRowId=$p(prtRowIDStr,"^",i)
		continue:(+prtRowId=0)
		set prtData=$g(^DHCINVPRT(prtRowId))
		set fairType=$p(prtData,"^",34)
		continue:(fairType'="R")
		set rtn=##class(web.DHCBillInterface).IUpdateRegistionFeeInv(prtRowId)
		quit:(+rtn)
	}
	
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2023-01-12
/// Description: 判断结算记录是否欠费补回
/// Input: prtRowId:DHC_INVPRT.RowId
/// Return: 0:否, 1:是
/// Debug: w ##class(web.DHCOPQFPat).IsQFRestorePrtInvId("7807")
ClassMethod IsQFRestorePrtInvId(prtRowId As %String) As %String
{
	set rtn=0
	quit:(+prtRowId=0) rtn
	set oweDR=$o(^DHCOPQFPatInfo(0,"InvPrt",prtRowId,0))
	quit:(+oweDR=0) rtn
	set oweFlag=$p($g(^DHCOPQFPatInfo(oweDR)),"^",7)
	set rtn=(oweFlag="Restore")
	quit rtn
}

}
