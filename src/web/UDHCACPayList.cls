Import SQLUser

Class web.UDHCACPayList Extends BILL.COM.Abstract
{

/// Debug: w ##class(web.UDHCACPayList).INSPayInfo()
ClassMethod INSPayInfo(AccParRef As %String, myPayInfo As %String) As %String
{
	set $zt="ERROR"
	
	set myParRef=$p(myPayInfo,"^",1)
	set PAPMIDR=$p(myPayInfo,"^",2)
	set InvPrtDR=$p(myPayInfo,"^",3)
	set PAPMI=$p(myPayInfo,"^",4)
	set BusiType=$p(myPayInfo,"^",5)              //业务类型
	set UserDR=$p(myPayInfo,"^",6)
	set PayDate=$p(myPayInfo,"^",7)
	set PayTime=$p(myPayInfo,"^",8)
	set PayNum=$p(myPayInfo,"^",9) 
	set RecLocDR=$p(myPayInfo,"^",10)		      //登陆科室
	set InsType=$p(myPayInfo,"^",11)              //费别
	set HospDR=$p(myPayInfo,"^",13)               //PRT_Hospital_DR

	quit:(AccParRef="")||('$d(^DHCACD("AccM",AccParRef))) 107_"^"_"账户不存在"   //账户数据不存在
	
	set accMStatus=$p($g(^DHCACD("AccM",AccParRef)),"^",13)   //AccM_AccStatus
	quit:(accMStatus'="N") -1_"^"_"账户"_$case(accMStatus,"F":"已结算","S":"已挂失",:accMStatus)_"，不能支付/退款"
	
	//验证账户平衡关系
	set rtnValue=..CheckAcctBal(AccParRef)
	set rtn=$p(rtnValue,"^",1)
	quit:(+rtn) rtnValue

	lock +^DHCACD("AccM",AccParRef):0  else  quit "-110^账户被锁定（账户Id："_AccParRef_")"
	
	//更新账户余额
	set rtnValue=##class(web.DHCACPayList).UpdateAM(AccParRef, -PayNum, InsType)
	set rtn=$p(rtnValue,"^",1)
	if (+rtn) {
		lock -^DHCACD("AccM",AccParRef)
		quit rtnValue
	}
	set myLeft=$p(rtnValue,"^",2)
	
	set BillNo=..SetBillNo(AccParRef, UserDR)

	&SQL(
		INSERT INTO DHC_AccPayList (
			AccPL_ParRef, AccPL_PAPMI_DR, AccPL_InvPrt_DR, AccPL_PAPMINo, AccPL_BillNo,
			AccPL_User_DR, AccPL_PayDate, AccPL_PayTime, AccPL_PayNum, AccPL_Left,
			AccPL_PayRecLoc_DR, AccPL_BusiType, AccPL_Hospital_DR
		)
		VALUES (
			:AccParRef, :PAPMIDR, :InvPrtDR, :PAPMI, :BillNo,
			:UserDR, CONVERT(DATE, NOW()), CONVERT(TIME, NOW()), :PayNum, :myLeft,
			:RecLocDR, :BusiType, :HospDR
		)
	)
	set rtn=SQLCODE
	lock -^DHCACD("AccM",AccParRef)
	if (+rtn) quit rtn_"^"_$g(%msg)

	set myPLRowID=$g(%ROWID)
	
	quit rtn_"^"_myPLRowID_"^"_myLeft

ERROR
	quit ..AppException()
}

/// 查询某个账户下支付流水帐
/// Debug: do ##class(%ResultSet).RunQuery("web.UDHCACPayList","ReadAccPayList","1612","2")
Query ReadAccPayList(AccRowID As %String, SessionStr As %String) As websys.Query(ROWSPEC = "LNO:%String,OBillNo:%String,OPAName:%String,OPAPMINo:%String,OSSUDesc:%String,OPayDate:%String,OPayTime:%String,OPayNum:%String,OPayLeft:%String,OLocDesc:%String,OPAPMIDR:%String,OPLRowID:%String,OPRTRowID:%String,OSSUsrDR:%String,OInvType:%String")
{
}

ClassMethod ReadAccPayListExecute(ByRef qHandle As %Binary, AccRowID As %String, SessionStr As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	set ^TMP("ReadAccPayList")=$lb(AccRowID, SessionStr)
	if (AccRowID="") quit $$$OK
	
	set HospId=$p(SessionStr,"^",4)
	set LangId=$p(SessionStr,"^",5)
	
	set mysub=""
	while($o(^DHCACD("AccM",AccRowID,"AccPL",mysub),-1)) {
		set mysub=$o(^DHCACD("AccM",AccRowID,"AccPL",mysub),-1)
		set myAccPLData=$g(^DHCACD("AccM",AccRowID,"AccPL",mysub))
		continue:(myAccPLData="")
		set myHospDR=$p(myAccPLData,"^",16)
		continue:(myHospDR'=HospId)
		set myBillNo=$p(myAccPLData,"^",4)
		set myPAPMIDR=$p(myAccPLData,"^",1)
		set myPAName=$p(^PAPER(myPAPMIDR,"ALL"),"^",1)
		set myPAPMINo=$p(myAccPLData,"^",3)
		set mySSUsrDR=$p(myAccPLData,"^",5)
		set mySSUDesc=$p(^SSU("SSUSR",mySSUsrDR),"^",2)
		set mySSUDesc=##class(User.SSUser).GetTranByDesc("SSUSRName", mySSUDesc, LangId)
		set mySSUInitials=$p(^SSU("SSUSR",mySSUsrDR),"^",1)
		set myPayDate=$p(myAccPLData,"^",6)
		set myPayDate=##class(websys.Conversions).DateLogicalToHtml(myPayDate)
		set myPayTime=$p(myAccPLData,"^",7)
		set myPayTime=##class(websys.Conversions).TimeLogicalToHtml(myPayTime, 1)
		set myPayNum=$p(myAccPLData,"^",8)
		set myPayNum=$fn(+myPayNum,"",2)
		set myPayLeft=$p(myAccPLData,"^",9)
		set myPayLeft=$fn(+myPayLeft,"",2)
		set myPayLocDR=$p(myAccPLData,"^",10)
		set myLocDesc=$s((+myPayLocDR'=0):$p(^CTLOC(myPayLocDR),"^",2),1:"")
		set myLocDesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", myLocDesc, LangId)
		set myPRTRowID=$p(myAccPLData,"^",2)
		continue:(myPRTRowID="")
		set myBusiType=$p(myAccPLData,"^",11)
		set myInvType=$case(myBusiType,"CARD":"CARD","PE":"PE",:"PRT")
		set myPLRowID=AccRowID_"||"_mysub
		do OutputPL
	}
	
	quit $$$OK
	
OutputPL
	set Data=$lb(ind,myBillNo,myPAName,myPAPMINo,mySSUDesc,myPayDate,myPayTime,myPayNum,myPayLeft,myLocDesc,myPAPMIDR,myPLRowID,myPRTRowID,mySSUsrDR,myInvType)
	set ^CacheTemp(repid,ind)=Data
	set ind=ind+1	
	quit
}

/// Description: 增加支付小票的号码
/// Input: AccMRowID:DHC_AccManger.RowId
/// Debug: w ##class(web.UDHCACPayList).SetBillNo("273","1")
ClassMethod SetBillNo(accRowId As %String, userId As %String) As %String [ Private ]
{
	set forAccM=##class(BILL.Util.Tools).FormatNO(accRowId, 10)
	set mySub=$o(^DHCACD("AccM",accRowId,"AccPL",""),-1)
	set forSub=##class(BILL.Util.Tools).FormatNO($i(mySub), 5)
	set userCode=$s((userId'=""):$p($g(^SSU("SSUSR",userId)),"^",1),1:"")  //操作员代码
	set myBillNo=userCode_forAccM_forSub
	
	quit myBillNo
}

/// Description: 获取一个账户的支付额度
/// Debug: w ##class(web.UDHCACPayList).ReadPatAccPaySum("3")
ClassMethod ReadPatAccPaySum(accRowId As %String) As %String
{
	quit:(accRowId="") 0
	
	set paySum=0
	set sub=0
	while($o(^DHCACD("AccM",accRowId,"AccPL",sub))) {
		set sub=$o(^DHCACD("AccM",accRowId,"AccPL",sub))
		set data=$g(^DHCACD("AccM",accRowId,"AccPL",sub))
		continue:(data="")
		set payAmt=$p(data,"^",8)
		set paySum=$i(paySum, payAmt)
	}
	
	set paySum=$fn(paySum,"",2)
	
	quit paySum
}

/// Creator: ZhYW
/// CreatDate: 2020-07-29
/// Description: 获取账户预交金金额
/// Input: accRowId:DHC_AccManager.RowId
/// Return: preSum:账户预交金金额
/// Debug: w ##class(web.UDHCACPayList).ReadPatAccPreSum("3")
ClassMethod ReadPatAccPreSum(accRowId As %String) As %String
{
	quit:(accRowId="") 0
	
	set depTypeId=##class(web.UDHCAccAddDeposit).GetAccPreDepTypeId()
	
	set preSum=0
	set sub=0
	while($o(^DHCACD("AccM",accRowId,"AccPD",sub))) {
		set sub=$o(^DHCACD("AccM",accRowId,"AccPD",sub))
		set data=$g(^DHCACD("AccM",accRowId,"AccPD",sub))
		continue:(data="")
		set depTypeDR=$p(data,"^",10)
		continue:(depTypeId'=depTypeDR)
		set preAmt=$p(data,"^",2)
		set preSum=$i(preSum, preAmt)
	}
	
	set preSum=$fn(preSum,"",2)
	
	quit preSum
}

/// 把患者的支付设置为一个^TMP
/// w ##class(web.UDHCACPayList).SetPatAccPayList("112")
ClassMethod SetPatAccPayList(AccRowID As %String, langId As %String = "") As %String
{
	quit:(AccRowID="") 0
	
	set index=0
	
	set myPLSub=0
	while($o(^DHCACD("AccM",AccRowID,"AccPL",myPLSub))) {
		set myPLSub=$o(^DHCACD("AccM",AccRowID,"AccPL",myPLSub))
		set myPLData=$g(^DHCACD("AccM",AccRowID,"AccPL",myPLSub))
		continue:(myPLData="")
		set myPLRowID=AccRowID_"||"_myPLSub
		set myPLDate=$p(myPLData,"^",6)
		set myPLTime=$p(myPLData,"^",7)
		set myTMPPLDate=##class(websys.Conversions).DateLogicalToHtml(myPLDate)
		set myTMPPLTime=##class(websys.Conversions).TimeLogicalToHtml(myPLTime,1)
		set myDate=myTMPPLDate_" "_myTMPPLTime
		set myPLPayNum=$p(myPLData,"^",8)
		set myPLTypeDesc=$s((+myPLPayNum>=0):"卡支付",1:"卡支付退费")
		set myPLTypeDesc=##class(websys.Translation).Get("UDHCACPatQ.AccPListQuery", myPLTypeDesc)
		set myUserDR=$p(myPLData,"^",5)
		set myUserDesc=$s((myUserDR'=""):$p(^SSU("SSUSR",myUserDR),"^",2),1:"")
		set myUserDesc=##class(User.SSUser).GetTranByDesc("SSUSRName", myUserDesc, langId)
		set myBillNo=$p(myPLData,"^",4)
		set myPLLeft=$p(myPLData,"^",9)
		set myBusiType=$p(myPLData,"^",11)
		set myPRTRowID=$p(myPLData,"^",2)		//AccPL_InvPrt_DR
		continue:(myPRTRowID="")
		set myINVNo=""
		if (myBusiType="OP") {
			set myPRTINVFlag=$p(^DHCINVPRT(myPRTRowID),"^",3)	//PRT_INVPrintFlag
			if (myPRTINVFlag="P") {
				set myINVNo=$p(^DHCINVPRT(myPRTRowID),"^",14)
				if (myINVNo="") {
					set myAccINVDR=$p(^DHCINVPRT(myPRTRowID),"^",4)
					set myINVNo=$s((+myAccINVDR'=0):$p($g(^DHCINVPRTAP(myAccINVDR)),"^",6),1:"")
				}
			}
		}elseif (myBusiType="PE") {
			set myINVNo=$p(^DHCPEINVPRT(myPRTRowID),"^",1)
		}
		set ^TMPAccPat("Acc",$j,myPLDate,myPLTime,$i(index))=myDate_"^"_myPLTypeDesc_"^"_myPLPayNum_"^"_myUserDesc_"^"_myBillNo_"^"_myPLLeft_"^"_"PL"_"^"_myPRTRowID_"^"_myINVNo_"^"_myBusiType
	}

	quit 0
}

/// Creator: zhl
/// Description: 检查账户收支明细与账户余额是否一致
/// Input: DHC_AccManager.RowId
/// Return: 0:是, <>0:否
/// Debug: w ##class(web.UDHCACPayList).CheckAcctBal(299)
ClassMethod CheckAcctBal(accRowId As %String) As %String
{
	quit:(accRowId="") -1_"^"_"参数错误"
	
	set myAccBal=$p($g(^DHCACD("AccM",accRowId)),"^",8)
	set myAccBal=$fn(myAccBal,"",2)

	set myPDSum=..ReadPatAccPreSum(accRowId)
	set myPLSum=..ReadPatAccPaySum(accRowId)
    set myAccLeft=$fn((myPDSum-myPLSum),"",2)
    
	if (+myAccLeft'=+myAccBal) {
		quit -1_"^"_"院内账户余额不平，账户余额："_myAccBal_"，收支计算余额："_myAccLeft
	}
	
	quit 0
}

}
