Import SQLUser

Class web.DHCACPayList Extends BILL.COM.Abstract
{

/// 用来更新账户的
/// Input: AccRowID: 账户RowID
///        PNum: 需要更新的钱数
/// Debug: w ##class(web.DHCACPayList).UpdateAM()
ClassMethod UpdateAM(AccRowID As %String, PNum As %String, InsType As %String = "") As %String
{
	set $zt="ERROR"
	
	set AccMLeft=$p(^DHCACD("AccM",AccRowID),"^",8)
	set DepNum=##class(web.UDHCAccManageCLSIF).GetAccMDepPrice(AccRowID, "", "")
	set CNum=AccMLeft-DepNum	        //减去下限
	
	set AdmSource=$s((InsType'=""):$p($g(^PAC("ADMREA",InsType)),"^",9),1:"")
	//quit:((PNum<0)&&($zabs(PNum)>CNum)&&(+AdmSource=0)) 125_"^"_"账户余额不足"
	quit:((PNum<0)&&($zabs(PNum)>CNum)) 125_"^"_"账户余额不足"
	
	set AccMLeft=$i(AccMLeft,PNum)
	&SQL(
		UPDATE DHC_AccManager
		SET AccM_Balance = :AccMLeft
		WHERE %ID = :AccRowID
	)
	set rtn=SQLCODE
	if (+rtn) quit rtn_"^"_$g(%msg)
	
	quit rtn_"^"_AccMLeft
	
ERROR
	quit ..AppException()
}

/// 查询某个账户下支付流水帐
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCACPayList","ReadAccPayList","4","","","","")
Query ReadAccPayList(AccRowID As %String, INVPrtFlag As %String, INVFlag As %String, FootFlag As %String, FUserDR As %String) As websys.Query(ROWSPEC = "LNO:%String,OBillNo:%String,OPAName:%String, OPAPMINo:%String, OSSUDesc:%String, OPayDate:%String,OPayTime:%String, OPayNum:%String, OPayLeft:%String,OLocDesc:%String, OINVFlagDesc:%String, OINVPrtFlagDesc:%String, OPAPMIDR:%String, OPLRowID:%String, OPRTRowID:%String, OSSUsrDR:%String")
{
}

ClassMethod ReadAccPayListExecute(ByRef qHandle As %Binary, AccRowID As %String, INVPrtFlag As %String, INVFlag As %String, FootFlag As %String, FUserDR As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	if (AccRowID="") quit $$$OK
	
	set mysub=0
	while($o(^DHCACD("AccM",AccRowID,"AccPL",mysub))) {
		set mysub=$o(^DHCACD("AccM",AccRowID,"AccPL",mysub))
		set myAccPLData=$g(^DHCACD("AccM",AccRowID,"AccPL",mysub))
		set myBillNo=$p(myAccPLData,"^",4)
		set myPAPMIDR=$p(myAccPLData,"^",1)
		set myPAName=$p(^PAPER(myPAPMIDR,"ALL"),"^",1)
		set myPAPMINo=$p(myAccPLData,"^",3)
		set mySSUsrDR=$p(myAccPLData,"^",5)
		continue:((FUserDR'="")&&(mySSUsrDR'=FUserDR))			//按照操作员查询支付明细
		set mySSUCode=$s((+mySSUsrDR'=0):$p(^SSU("SSUSR",mySSUsrDR),"^",1),1:"")		//操作员代码
		set mySSUDesc=$s((+mySSUsrDR'=0):$p(^SSU("SSUSR",mySSUsrDR),"^",2),1:"")
		set myPayDate=$p(myAccPLData,"^",6)
		set myPayDate=$zd(myPayDate,3)
		set myPayTime=$p(myAccPLData,"^",7)
		set myPayTime=$zt(myPayTime,1)
		set myPayNum=$p(myAccPLData,"^",8)
		set myPayLeft=$p(myAccPLData,"^",9)
		set myPayLocDR=$p(myAccPLData,"^",10)
		set myLocDesc=$s((+myPayLocDR'=0):$p($g(^CTLOC(myPayLocDR)),"^",2),1:"")
		set myPRTRowID=$p(myAccPLData,"^",2)
		set myINVFlag=$p(^DHCINVPRT(myPRTRowID),"^",8)		//发票的状态N , S 
		continue:((INVFlag'="")&&(myINVFlag'=INVFlag))
		set myINVFlagDesc=$case(myINVFlag,"N":"正常","A":"作废","S":"红冲",:"")
		set myINVPrtFlag=$p(^DHCINVPRT(myPRTRowID),"^",3)		//发票的打印标志
		continue:((INVPrtFlag'="")&&(myINVPrtFlag'=INVPrtFlag))
		set myINVPrtFlagDesc=$case(myINVPrtFlag,"P":"已打印",:"未打印")
		set myPLRowID=AccRowID_"||"_mysub
		do OutputAccPayList
	}
	
	quit $$$OK
OutputAccPayList
	set Data=$lb(ind,myBillNo,myPAName,myPAPMINo,mySSUDesc,myPayDate,myPayTime,myPayNum,myPayLeft,myLocDesc,myINVFlagDesc,myINVPrtFlagDesc,myPAPMIDR,myPLRowID,myPRTRowID,mySSUsrDR)
	set ^CacheTemp(repid,ind)=Data
	set ind=$i(ind)	
	quit
}

/// Creator: ZhYW
/// CreatDate: 2019-08-30
/// Description: 查询患者未打印发票的小条记录
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCACPayList","FindPatPayList","56","","","N","N","N","9")
Query FindPatPayList(patientId As %String, stDate As %String, endDate As %String, isRegInv As %String, isInsuDiv As %String, isStayInv As %String, hospId As %String, langId As %String = "") As websys.Query(ROWSPEC = "prtRowId:%String,acount:%String,discAmt:%String,payorAmt:%String,patAmt:%String,date:%String,time:%String,usrName:%String,accPLRowId:%String,paymStr:%String,accPayNo:%String,accPayAmt:%String,accPayLeft:%String")
{
}

ClassMethod FindPatPayListExecute(ByRef qHandle As %Binary, patientId As %String, stDate As %String, endDate As %String, isRegInv As %String, isInsuDiv As %String, isStayInv As %String, hospId As %String, langId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	set ^TMP("FindPatPayList")=$lb(patientId, stDate, endDate, isRegInv, isInsuDiv, isStayInv, hospId)
	if (+patientId=0) quit $$$OK
	
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
	
	set prtRowId=0
	while($o(^DHCINVPRT(0,"PAPMI",patientId,prtRowId))) {
		set prtRowId=$o(^DHCINVPRT(0,"PAPMI",patientId,prtRowId))
		set invData=$g(^DHCINVPRT(prtRowId))
		set hospDR=$p(invData,"^",39)
		continue:(hospDR'=hospId)
		set myQFRowID=$o(^DHCOPQFPatInfo(0,"InvPrt",prtRowId,""))
		set myQFFlag=$s((+myQFRowID'=0):$p($g(^DHCOPQFPatInfo(myQFRowID)),"^",7),1:"")
		continue:(myQFFlag="Owe")     //过滤欠费结算记录
		set invPrtFlag=$p(invData,"^",3)
		continue:(invPrtFlag="P")
		set prtFlag=$p(invData,"^",8)
		continue:(prtFlag'="N")
		set prtAcount=$p(invData,"^",1)
		set prtAcount=$fn(prtAcount,"",2)
		set prtDiscAmt=$p(invData,"^",7)
		set prtDiscAmt=$fn(prtDiscAmt,"",2)
		set prtPatAmt=$p(invData,"^",16)
		set prtPatAmt=$fn(prtPatAmt,"",2)
		set prtPayorAmt=$p(invData,"^",18)
		set prtPayorAmt=$fn(prtPayorAmt,"",2)
		set fairType=$p(invData,"^",34)
		continue:((" R F ")'[(" "_fairType_" "))
		continue:((isRegInv="N")&&(fairType="R"))
		continue:((isRegInv="Y")&&(fairType'="R"))
		set insuDivDR=$p(invData,"^",30)
		continue:((isInsuDiv="N")&&(+insuDivDR'=0))
		continue:((isInsuDiv="Y")&&(+insuDivDR=0))
		set prtStayFlag=$p(invData,"^",44)
		continue:((isStayInv="N")&&(prtStayFlag="Y"))
		continue:((isStayInv="Y")&&(prtStayFlag'="Y"))
		set prtDate=$p(invData,"^",5)
		continue:((stDate'="")&&(stDate>prtDate))
		continue:((endDate'="")&&(endDate<prtDate))
		set prtDate=##class(websys.Conversions).DateLogicalToHtml(prtDate)
		set prtTime=$p(invData,"^",20)
		set prtTime=##class(websys.Conversions).TimeLogicalToHtml(prtTime, 1)
		set prtUsrDR=$p(invData,"^",21)
		set prtUsrName=$s((+prtUsrDR'=0):$p(^SSU("SSUSR",prtUsrDR),"^",2),1:"")
		set prtUsrName=$s((prtUsrName'=""):##class(User.SSUser).GetTranByDesc("SSUSRName",prtUsrName,langId),1:"")
		set accPLRowId=""
		set paymStr=""
		set paymSub=0
		while($o(^DHCINVPRT(prtRowId,"P",paymSub))) {
			set paymSub=$o(^DHCINVPRT(prtRowId,"P",paymSub))
			set paymData=$g(^DHCINVPRT(prtRowId,"P",paymSub))
			continue:(paymData="")
			set paymDR=$p(paymData,"^",1)
			continue:(+paymDR=0)
			set paymDesc=$p($g(^CT("CTPM",paymDR)),"^",2)
			set paymDesc=##class(User.CTPayMode).GetTranByDesc("CTPMDesc", paymDesc, langId)
			set accPLDR=$p(paymData,"^",8)
			if (accPLDR'="") {
				set accPLRowId=accPLDR
			}
			set paymAmt=$p(paymData,"^",3)
			set paymAmt=$fn(paymAmt,"",2)
			set paymStr=$s((paymStr=""):(paymDesc_"："_paymAmt),1:(paymStr_" "_paymDesc_"："_paymAmt))
		}
		set accPayNo="", accPayAmt="", accPayLeft=""
		if (accPLRowId'="") {
			set accM=$p(accPLRowId,"||",1)
			set accPLSub=$p(accPLRowId,"||",2)
			set accPLData=$g(^DHCACD("AccM",accM,"AccPL",accPLSub))
			set accPayNo=$p(accPLData,"^",4)
			set accPayAmt=$p(accPLData,"^",8)
			set accPayLeft=$p(accPLData,"^",9)
			set accPayLeft=$fn(accPayLeft,"",2)
		}
		do OutputPayList
	}

	quit $$$OK
	
OutputPayList
	set Data=$lb(prtRowId,prtAcount,prtDiscAmt,prtPayorAmt,prtPatAmt,prtDate,prtTime,prtUsrName,accPLRowId,paymStr,accPayNo,accPayAmt,accPayLeft)
	set ^CacheTemp(repid,ind)=Data
	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2019-08-30
/// Description: 查询患者未打印发票的小条记录
/// Input: 
/// Return: 
/// Debug: w ##class(web.DHCACPayList).GetNoPrintNum(2349, "2")
ClassMethod GetNoPrintNum(patientId As %String, expStr As %String) As %String
{
	set num=0
	quit:(+patientId=0) num
	
	set hospId=$p(expStr,"^",1)
	
	set prtRowId=0
	while($o(^DHCINVPRT(0,"PAPMI",patientId,prtRowId))) {
		set prtRowId=$o(^DHCINVPRT(0,"PAPMI",patientId,prtRowId))
		set invData=$g(^DHCINVPRT(prtRowId))
		continue:(invData="")
		set hospDR=$p(invData,"^",39)
		continue:(hospDR'=hospId)
		set myQFRowID=$o(^DHCOPQFPatInfo(0,"InvPrt",prtRowId,""))
		set myQFFlag=$s((+myQFRowID'=0):$p($g(^DHCOPQFPatInfo(myQFRowID)),"^",7),1:"")
		continue:(myQFFlag="Owe")     //过滤欠费结算记录
		set fairType=$p(invData,"^",34)
		continue:((" R F ")'[(" "_fairType_" "))
		set invPrtFlag=$p(invData,"^",3)
		continue:(invPrtFlag="P")
		set prtFlag=$p(invData,"^",8)
		continue:(prtFlag'="N")
		set num=$i(num)
	}

	quit num
}

/// Creator: ZhYW
/// CreatDate: 2019-08-30
/// Description: 查询患者小条分类费用(门诊收费大类)
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCACPayList","FindCateList","234241",2)
Query FindCateList(prtRowIdStr As %String, hospId As %String, langId As %String = "") As websys.Query(ROWSPEC = "cateDesc:%String,cateAmt:%Float")
{
}

ClassMethod FindCateListExecute(ByRef qHandle As %Binary, prtRowIdStr As %String, hospId As %String, langId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	set ^TMP("FindCateList")=$lb(prtRowIdStr, hospId)
	
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	kill itmCateAry
	
	set count=$l(prtRowIdStr,"^")
	for i=1:1:count {
		set prtRowId=$p(prtRowIdStr,"^",i)
		continue:(+prtRowId=0)
		set billConInv=0
		while($o(^DHCBCI(0,"INV",prtRowId,billConInv))) {
			set billConInv=$o(^DHCBCI(0,"INV",prtRowId,billConInv))
			set pb=$p(^DHCBCI(billConInv),"^",2)
			set pbo=0
			while($o(^DHCPB(pb,"O",pbo))) {
				set pbo=$o(^DHCPB(pb,"O",pbo))
				set pbd=0
				while($o(^DHCPB(pb,"O",pbo,"D",pbd))) {
					set pbd=$o(^DHCPB(pb,"O",pbo,"D",pbd))
					set pbdData=$g(^DHCPB(pb,"O",pbo,"D",pbd))
					continue:(pbdData="")
					set tarItmDR=$p(pbdData,"^",3)
					set amt=$p(pbdData,"^",7)
					set itmSubCate=$p(^DHCTARI(tarItmDR),"^",15)
					set itmCate=$p(^DHCTarC("OC",itmSubCate),"^",3)
					set itmCateAry(itmCate)=$i(itmCateAry(itmCate), amt)
				}
			}
		}
	}
	
	set cate=0
	while($o(^DHCTarC("TOC",cate))) {
		set cate=$o(^DHCTarC("TOC",cate))
		set cateData=$g(^DHCTarC("TOC",cate))
		continue:(cateData="")
		set showDataFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_TarOC", cate, hospId)
		continue:(showDataFlag="N")
		set cateDesc=$p(cateData,"^",2)
		set cateDesc=##class(User.DHCTarOC).GetTranByDesc("TARTOCDesc", cateDesc, langId)
		set cateAmt=$g(itmCateAry(cate))
		set cateAmt=$fn(cateAmt,"",2)
		do OutputCateList
	}
	
	quit $$$OK
	
OutputCateList
	set Data=$lb(cateDesc,cateAmt)
	set ^CacheTemp(repid,ind)=Data
	set ind=$i(ind)
	quit
}

}
