Import SQLUser

/// Creator:Lid
/// CreatDate:2014-07-08
/// Desc:支付宝、微信支付医保分解业务
Class web.DHCOPBillInvPrtInsu Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCOPBillInvPrtInsu","ReadPayList",80294,"N","N","",71066)
Query ReadPayList(AccRowID As %String, INVPrtFlag As %String, INVFlag As %String, FUserDR As %String, PAPMIRowID As %String = "", StDate As %String, EndDate As %String, hospId As %String) As websys.Query(ROWSPEC = "LNO:%String,OBillNo:%String,OPAName:%String, OPAPMINo:%String, OSSUDesc:%String, OPayDate:%String,OPayTime:%String, OPayNum:%String, OPayLeft:%String,OLocDesc:%String, OINVFlagDesc:%String, OINVPrtFlagDesc:%String, OPAPMIDR:%String, OPLRowID:%String, OPRTRowID:%String, OSSUsrDR:%String,TFairType:%String,TInsTypeDR:%String,TInsType:%String,TAdmSource:%String")
{
}

ClassMethod ReadPayListExecute(ByRef qHandle As %Binary, AccRowID As %String, INVPrtFlag As %String, INVFlag As %String, FUserDR As %String, PAPMIRowID As %String = "", StDate As %String, EndDate As %String, hospId As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	set:(hospId="")&&($g(%session)'="") hospId=$g(%session.Data("LOGON.HOSPID"))
	
	set:(StDate'="") StDate=##class(websys.Conversions).DateHtmlToLogical(StDate)
	set:(EndDate'="") EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	if (StDate="") set StDate=+$h-365
	if (EndDate="") set EndDate=+$h

	d ResetVariablesPL
	s myPAPMIDR=""
	i (AccRowID'="") d
	.s myPAPMIDR=$p(^DHCACD("AccM",AccRowID),"^",2)
	i (myPAPMIDR'=PAPMIRowID)&&(myPAPMIDR'="")&&(PAPMIRowID'="") Set qHandle=$lb(0,repid,0) 	Quit $$$OK
	
	
	;小条号码，患者姓名，患者的登记号码，结算人员，支付日期，支付时间，支付金额，账户余额，支付位置，
	;对应的发票状态，打印发票状态,患者RowID，PLRowID, INVPRTRowID,结算人员RowID
	;查询消费明细表
	if (AccRowID'="")&&($d(^DHCACD("AccM",AccRowID))) d
	.s mysub=""
	.f  s mysub=$o(^DHCACD("AccM",AccRowID,"AccPL",mysub),-1) q:(mysub="")  d
	..q:(mysub=0)		;=0  保存节点索引
	..s myBillNo=$p(^DHCACD("AccM",AccRowID,"AccPL",mysub),"^",4)
	..s myPAPMIDR=$p(^DHCACD("AccM",AccRowID,"AccPL",mysub),"^",1)	;DHC_AccManager->
	..s myPAName=$p(^PAPER(myPAPMIDR,"ALL"),"^",1)		;PA_PatMas->Name
	..s myPAPMINo=$p(^DHCACD("AccM",AccRowID,"AccPL",mysub),"^",3)
	..s mySSUsrDR=$p(^DHCACD("AccM",AccRowID,"AccPL",mysub),"^",5)
	..q:((FUserDR'="")&&(mySSUsrDR'=FUserDR))			;按照操作员查询支付明细
	..s:(mySSUsrDR'="") mySSUDesc=$p(^SSU("SSUSR",mySSUsrDR),"^",2)
	..s mySSUInitials=$p(^SSU("SSUSR",mySSUsrDR),"^",1)		;操作员代码
	..s myPayDate=$p(^DHCACD("AccM",AccRowID,"AccPL",mysub),"^",6)
	..s myPayDate=##class(websys.Conversions).DateLogicalToHtml(myPayDate)
	..s myPayTime=$p(^DHCACD("AccM",AccRowID,"AccPL",mysub),"^",7)
	..s myPayTime=##class(websys.Conversions).TimeLogicalToHtml(myPayTime,1)
	..s myPayNum=$p(^DHCACD("AccM",AccRowID,"AccPL",mysub),"^",8)
	..s myPayNum=$fn(+myPayNum,"",2)
	..s myPayLeft=$p(^DHCACD("AccM",AccRowID,"AccPL",mysub),"^",9)
	..s myPayLeft=$fn(+myPayLeft,"",2)
	..s myPayLocDR=$p(^DHCACD("AccM",AccRowID,"AccPL",mysub),"^",10)
	..s:(myPayLocDR'="") myLocDesc=$p(^CTLOC(myPayLocDR),"^",2)
	..s myPRTRowID=$p(^DHCACD("AccM",AccRowID,"AccPL",mysub),"^",2)
	..q:('$d(^DHCINVPRT(myPRTRowID)))
	..s myHospId=$p(^DHCINVPRT(myPRTRowID),"^",39)
	..q:(myHospId'=hospId)
	..s myINVFlag=$p(^DHCINVPRT(myPRTRowID),"^",8)		;发票的状态N , S 
	..s myFairType=$p(^DHCINVPRT(myPRTRowID),"^",34)	;PRT_FairType
	..s myInsTypeDR=$p(^DHCINVPRT(myPRTRowID),"^",9)
	..s myInsType=$p(^PAC("ADMREA",myInsTypeDR),"^",2)
	..s myAdmSource=$p(^PAC("ADMREA",myInsTypeDR),"^",9)
	..q:myFairType'="F"	;过滤自助机挂号记录
	..q:((INVFlag'="")&&(myINVFlag'=INVFlag))
	..i (myINVFlag="N") s myINVFlagDesc="正常"
	..i (myINVFlag="A") s myINVFlagDesc="作废"
	..i (myINVFlag="A") s myINVFlagDesc="红冲"
	..s myINVPrtFlag=$p(^DHCINVPRT(myPRTRowID),"^",3)		;发票的打印标志
	..q:((INVPrtFlag'="")&&(myINVPrtFlag'=INVPrtFlag))
	..i (myINVPrtFlag="N") s myINVPrtFlagDesc="未打印"
	..i (myINVPrtFlag="P") s myINVPrtFlagDesc="已打印"
	..s PayMInfo=##class(DHCAliPay.ChargeInterface.AliPayLogic).CheckPayMByPrtRowID(myPRTRowID,"")
	..s PayMFlag=$p(PayMInfo,"^",1)	;3：微信支付宝支付 4:预约
	..q:(+PayMFlag'=2)&&(+PayMFlag'=3)
	..s myPLRowID=AccRowID_"||"_mysub
	..d OutputPL
	e  i PAPMIRowID'="" d ;查询发票表	
	.d ResetVariablesPL
	.s myPAPMIDR=PAPMIRowID
	.s myPANo=$p(^PAPER(myPAPMIDR,"PAT",1),"^",1)	
	.s myPAName=$p(^PAPER(myPAPMIDR,"ALL"),"^",1)
	.f date=StDate:1:EndDate d
	..s myPRTRowID=""
	..f  s myPRTRowID=$o(^DHCINVPRT(0,"DatePAPMI",date,myPAPMIDR,myPRTRowID)) q:(myPRTRowID="")  d
	...q:$d(TMPReadAccPayList(myPRTRowID))
	...s myHospId=$p(^DHCINVPRT(myPRTRowID),"^",39)
	...q:(myHospId'=hospId)
	...s myPLRowID=myPRTRowID
	...s myFairType=$p(^DHCINVPRT(myPRTRowID),"^",34)	;PRT_FairType
	...s myInsTypeDR=$p(^DHCINVPRT(myPRTRowID),"^",9)
	...s myInsType=$p(^PAC("ADMREA",myInsTypeDR),"^",2)
	...s myAdmSource=$p(^PAC("ADMREA",myInsTypeDR),"^",9)
	...q:(myFairType'="F")	;过滤自助机挂号记录
	...s myprtprintflag=$p(^DHCINVPRT(myPRTRowID),"^",3)
	...;q:(myprtprintflag="P")
	...s myPrtFlag=$p(^DHCINVPRT(myPRTRowID),"^",8)
	...q:(myPrtFlag'="N")
	...s PayMInfo=##class(DHCAliPay.ChargeInterface.AliPayLogic).CheckPayMByPrtRowID(myPRTRowID,"")
	...s PayMFlag=$p(PayMInfo,"^",1)	;3：微信支付宝支付 4:预约
	...;q:(+PayMFlag'=2)&&(+PayMFlag'=3)
	...q:(+PayMFlag=0)  ;非微信支付宝的不显示 tangzf 2019-8-22
	...s mySSUsrDR=$p(^DHCINVPRT(myPRTRowID),"^",21)
	...s mySSUDesc=$p(^SSU("SSUSR",mySSUsrDR),"^",2)
	...s myPayDate=##class(websys.Conversions).DateLogicalToHtml($p(^DHCINVPRT(myPRTRowID),"^",5))
	...s myPayTime=##class(websys.Conversions).TimeLogicalToHtml($p(^DHCINVPRT(myPRTRowID),"^",20),1)
	...s myPayNum=$fn($p(^DHCINVPRT(myPRTRowID),"^",1),"",2)
	...s myPayLeft=""	
	...s myLocDr=""		;自助机，多次就诊一起结算时，如何取“科室”？？？？
	...s myLocDesc=""
	...d OutputPL
	k TMPReadAccPayList
	
	quit $$$OK
ResetVariablesPL
	set (myBillNo,myPAName, myPAPMINo, mySSUDesc, myPayDate,myPayTime,myPayNum,myPayLeft,myLocDesc)=""
	set (myINVFlagDesc,myINVPrtFlagDesc,myPAPMIDR, myPLRowID, myPRTRowID,mySSUsrDR,myFairType,myInsTypeDR,myInsType,myAdmSource)=""
	quit
OutputPL
	set Data=$lb(ind,myBillNo,myPAName,myPAPMINo,mySSUDesc,myPayDate,myPayTime,myPayNum,myPayLeft,myLocDesc,myINVFlagDesc,myINVPrtFlagDesc,myPAPMIDR,myPLRowID,myPRTRowID,mySSUsrDR,myFairType,myInsTypeDR,myInsType,myAdmSource)
	set ^CacheTemp(repid,ind)=Data
	set ind=ind+1	
	quit
}

/// 可以通过PAPMINo来查
/// 或利用卡来查
/// w ##class(web.UDHCAccManageCLS).ReadPatAccInfo(74167547,74167547,"")
ClassMethod ReadPatAccInfo(PAPMINO As %String, CardNo As %String, SecurityNo As %String) As %String
{
	n (PAPMINO, CardNo, SecurityNo)
	
	q:((PAPMINO="")&&(CardNo="")) "-299^^^^^^"
	
	s rtn=0
	
	;可以利用登记号来查询卡号与验证码
	i (CardNo="")&&(SecurityNo="") d
	.;利用登记号来查询有效的账户号码，这个只为了结帐使用；
	.;为了操作简单化
	.
	
	s (myPAPMINO,myPatName,mySexDesc,myPatBD)=""
	s (myCredDesc, myCredNo, myLeft)=""
	s (myASDesc,myAccNo, myCDT, BadPrice, DepPrice)=""
	s myCardRowID=""
	s myAccRowID=""
	s myPDSum=""
	s myPLSum=""
	s myPatType=""
	s myRegFlag="N"
	s rtn=0
	if (CardNo'="") d  
	.;&&(SecurityNo'="") d
	.s myrtn=..getaccinfofromcardno(CardNo, SecurityNo)
	.s rtn=$p(myrtn,"^",1)
	.;q:rtn
	.s myPAPMINO=$p(myrtn,"^",9)
	.s myPAPMIDR=$p(myrtn,"^",8)
	.q:(+myPAPMIDR=0)
	.s myPatType=$p(^PAPER(myPAPMIDR,"PER", 1),"^",10)
	.s myPatName=$p(^PAPER(myPAPMIDR,"ALL"),"^",1)
	.s mySexDR=$p(^PAPER(myPAPMIDR,"ALL"),"^",7)
	.s mySexDesc=$s((+mySexDR'=0):$p(^CT("SEX",mySexDR),"^",2),1:"")
	.s myPatBD=$p(^PAPER(myPAPMIDR,"ALL"),"^",6)
	.s myPatBD=##class(websys.Conversions).DateLogicalToHtml(myPatBD)
	.s myCredDR=$p($g(^PAPER(myPAPMIDR,"PAT",3)),"^",7)
	.s myCredNo=$p($g(^PAPER(myPAPMIDR,"PAT",3)),"^",6)
	.s myCredDesc=$s((+myCredDR'=0):$p($g(^PAC("CARD",myCredDR)),"^",2),1:"") // 证件类型描述
	.s myAccRowID=$p(myrtn,"^",2)
	.q:(+myAccRowID=0)
	.s myCardRowID=$p(myrtn,"^",10)
	.s myLeft=$p(myrtn,"^",4)
	.s myAccStatus=$p(^DHCACD("AccM",myAccRowID),"^",13)	;AccM_CredNo
	.i myAccStatus="N" s myASDesc="正常"
	.s:(myAccStatus'="N") rtn=-201
	.q:(myAccStatus'="N")
	.s myAccNo=$p(^DHCACD("AccM",myAccRowID),"^",1)	;AccM_AccountNo
	.s myCDate=$p(^DHCACD("AccM",myAccRowID),"^",5)	;Date
	.s myCTime=$p(^DHCACD("AccM",myAccRowID),"^",6)	;Date
	.s myCDT=##class(websys.Conversions).DateLogicalToHtml(myCDate)_" "_##class(websys.Conversions).TimeLogicalToHtml(myCTime,1)
	.s myLeft=$p(^DHCACD("AccM",myAccRowID),"^",8)	;
	.s DepPrice=$p(^DHCACD("AccM",myAccRowID),"^",14)
	.s BadPrice=$p(^DHCACD("AccM",myAccRowID),"^",15)
	.s myPDSum=##class(web.UDHCAccAddDeposit).ReadPreDepositSum(myAccRowID)
	.s myPLSum=##class(web.UDHCACPayList).ReadPatAccPaySum(myAccRowID)
	.s myRegFlag=..getAccRegFlag(myAccRowID)
	
	s myLeft=$fn(+myLeft,"",2)
	s BadPrice=$fn(+BadPrice,"",2)
	s DepPrice=$fn(+DepPrice,"",2)
	s myPDSum=$fn(+myPDSum,"",2)
	s myPLSum=$fn(+myPLSum, "",2)
	s myPAInfo=myPAPMINO_"^"_myPatName_"^"_mySexDesc_"^"_myPatBD
	s myPAInfo=myPAInfo_"^"_myCredDesc_"^"_myCredNo_"^"_myLeft
	s myPAInfo=myPAInfo_"^"_myASDesc_"^"_myAccNo_"^"_myCDT_"^"_BadPrice_"^"_DepPrice
	s myPAInfo=myPAInfo_"^"_myAccRowID
	s myPAInfo=myPAInfo_"^"_myPDSum_"^"_myPLSum_"^"_myPatType
	s myPAInfo=myPAInfo_"^"_myCardRowID_"^"_myRegFlag
	
	q rtn_"^"_myPAInfo
}

/// w ##class(web.DHCOPBillInvPrtInsu).getaccinfofromcardno("04215212","")
ClassMethod getaccinfofromcardno(cardno As %Library.String, securityno As %Library.String) As %Library.String
{
	n (cardno, securityno)
	
	q:cardno="" "-200^^^^^^^^"		;;无效卡标志
	
	s rtn=0
	
	s AccID="",AccNo="",left=0,Balance=0,DepPrice=0
	s Papmi=""
	s Pass=""
	s PAPMINo=""
	s myCardRowID=""
	s myACFlag=-200		;无效卡
	
	s myAccType="P"
	
	;逻辑：找到有效卡后，不应该在循环了
	s dd=##class(web.UDHCCardInfoResume).AutoRepairSec(cardno,securityno)
	
	s mySecNoEncrypt=##class(web.UDHCAccEnrypt).Encrypt(securityno)
	s cardid="0"
	f  s cardid=$o(^DHCCARDi("CF",0,"CardNo",cardno,cardid)) q:((cardid="")!(myACFlag=0))  d
	.s ActiveFlag=$p(^DHCCARD("CF",cardid),"^",10)
	.q:ActiveFlag'="N"
	.;s CardID=cardid
	.s SecurityNO=$p(^DHCCARD("CF",cardid),"^",3)
	.b
	.;q:SecurityNO'=mySecNoEncrypt			;securityno
	.;判断有效卡标志
	.s myACFlag=0		;此卡有效
	.s Papmi=$p(^DHCCARD("CF",cardid),"^",4)
	.s Papmi=$p(^DHCCARD("CF",cardid),"^",4)
	.s myCardRowID=cardid
	.s PAPMINo=##Class(web.PAPatMas).GetRegistration(Papmi)
	.s cfrowid=$p(^DHCCARD("CF",cardid),"^",1)
	.q:cfrowid=""
	.s AccStatus=$p(^DHCACD("AccM",cfrowid),"^",13)
	.q:AccStatus'="N"
	.s AccID=cfrowid
	.s AccNo=$p(^DHCACD("AccM",cfrowid),"^",1)
	.;s RegNo=$p(^DHCACD("AccM",cfrowid),"^",3)
	.;s CardNo=$p(^DHCACD("AccM",cfrowid),"^",4)
	.s Balance=$p(^DHCACD("AccM",cfrowid),"^",8)
	.s Pass=$p(^DHCACD("AccM",cfrowid),"^",12)
	.s DepPrice=$p(^DHCACD("AccM",cfrowid),"^",14)
	.s left=Balance-DepPrice
	.s myAccType=$p(^DHCACD("AccM",cfrowid),"^",16)
	.;s AccType= $p(^DHCACD("AccM",cfrowid),"^",16)
	.;s CredTypeID=$p(^DHCACD("AccM",cfrowid),"^",17)
	.;s IDCardNo=$p(^DHCACD("AccM",cfrowid),"^",18)
	
	s rtn=myACFlag
	;卡有效，而账户无效返回-201
	i ((myACFlag=0)&&(AccID="")) d
	.s rtn=-201
	
	s str=rtn_"^"_AccID_"^"_AccNo_"^"_left_"^"_Balance_"^"_DepPrice_"^"_Pass
	s str=str_"^"_Papmi_"^"_PAPMINo_"^"_myCardRowID_"^"_myAccType
	
	q str
}

ClassMethod getAccRegFlag(AccRowID As %String) As %String
{
	s myrtn="N"
	q:$g(AccRowID)="" myrtn
	s myrtn="Y"
	s myRegSum=0
	s mysub="0"
	f  s mysub=$o(^DHCACD("AccM",AccRowID,"AccPL",mysub)) q:(mysub="")||(myrtn="N")  d
	.s myINVID=$p(^DHCACD("AccM",AccRowID,"AccPL",mysub),"^",2)
	.q:myINVID=""
	.s myFairType=$p($g(^DHCINVPRT(myINVID)),"^",34)
	.s myamt=+$p(^DHCACD("AccM",AccRowID,"AccPL",mysub),"^",8)
	.i myFairType="R" s myRegSum=myRegSum+myamt
	.q:myFairType="R" 
	.s myrtn="N"
	i (myrtn="Y")&&(myRegSum=0) s myrtn="N"
	q myrtn
}

/// w ##class(web.UDHCAccManageCLS).ReadPatInfo("","","")
ClassMethod ReadPatInfo(PAPMINO As %String, CardNo As %String, SecurityNo As %String) As %String
{
	;可以通过PAPMINo来查
	;或利用卡来查；
	n (PAPMINO, CardNo, SecurityNo)
	
	q:((PAPMINO="")&&(CardNo="")) "-299^^^^^^"
	
	s rtn=0
	
	;可以利用登记号来查询卡号与验证码
	i (CardNo="")&&(SecurityNo="") d
	.;利用登记号来查询有效的账户号码，这个只为了结帐使用；
	.;为了操作简单化
	.
	
	s (myPAPMINO,myPatName,mySexDesc,myPatBD)=""
	s (myCredDesc, myCredNo, myLeft)=""
	s (myASDesc, myAccNo, myCDT, BadPrice, DepPrice)=""
	s myCardRowID=""
	s myAccRowID=""
	s myPDSum=""
	s myPLSum=""
	s myPatType=""
	s myRegFlag="N"
	s rtn=0
	i (PAPMINO'="") d
	.s PAPMINO=##class(web.UDHCJFBaseCommon).regnocon(PAPMINO)
	.s myPAPMIDR=$o(^PAPERi("PAPMI_PatNo",PAPMINO,""),-1)
	.q:(+myPAPMIDR=0) // tangzf 2019-8-22
	.s myPAPMINO=$p($g(^PAPER(myPAPMIDR,"PAT",1)),"^",1)
	.s myPatType=$p($g(^PAPER(myPAPMIDR,"PER",1)),"^",10)
	.s myPatName=$p($g(^PAPER(myPAPMIDR,"ALL")),"^",1)
	.s mySexDR=$p($g(^PAPER(myPAPMIDR,"ALL")),"^",7)
	.s mySexDesc=$s((mySexDR'=""):$p(^CT("SEX",mySexDR),"^",2),1:"")
	.s myPatBD=$p($g(^PAPER(myPAPMIDR,"ALL")),"^",6)
	.s myPatBD=##class(websys.Conversions).DateLogicalToHtml(myPatBD)
	.s myAccRowID=""
	.s myCardRowID=""
	.s myCredDR=$p($g(^PAPER(myPAPMIDR,"PAT",3)),"^",7)
	.s myCredDesc=$s((myCredDR'=""):$p($g(^PAC("CARD",myCredDR)),"^",2),1:"")  // tangzf 2019-8-23 证件类型
	.s myCredNo=$p($g(^PAPER(myPAPMIDR,"PAT",3)),"^",6)	  //AccM_CredNo
	.s myLeft=""
	.s myAccStatus=""
	.s myASDesc="正常"
	.s myAccNo=""
	.s myCDate=""
	.s myCTime=""
	.s myCDT=""
	.s myLeft=""
	.s DepPrice=""
	.s BadPrice=""
	.s myPDSum=""
	.s myPLSum="" 
	.s myRegFlag=""
	
	s myLeft=$fn(+myLeft,"",2)
	s BadPrice=$fn(+BadPrice,"",2)
	s DepPrice=$fn(+DepPrice,"",2)
	s myPDSum=$fn(+myPDSum,"",2)
	s myPLSum=$fn(+myPLSum, "",2)
	s myPAInfo=myPAPMINO_"^"_myPatName_"^"_mySexDesc_"^"_myPatBD
	s myPAInfo=myPAInfo_"^"_myCredDesc_"^"_myCredNo_"^"_myLeft
	s myPAInfo=myPAInfo_"^"_myASDesc_"^"_myAccNo_"^"_myCDT_"^"_BadPrice_"^"_DepPrice
	s myPAInfo=myPAInfo_"^"_myAccRowID
	s myPAInfo=myPAInfo_"^"_myPDSum_"^"_myPLSum_"^"_myPatType
	s myPAInfo=myPAInfo_"^"_myCardRowID_"^"_myRegFlag_"^"_myPAPMIDR
	
	q rtn_"^"_myPAInfo
}

/// Lid
/// 2015-12-03
/// 判断小条是否医保分解
/// w ##class(web.DHCOPBillInvPrtInsu).IsInsuCharge()
ClassMethod IsInsuCharge(prtRowid)
{
	new (prtRowid)
	set flag=0
	set insDivDr=$p($p(##class(web.DHCINSUPort).GetDivideByInvPrtDr(prtRowid),"!",2),"^",2) ;tangzf 2019-6-17
	//set insDivDr=##class(web.UDHCJFBaseCommon).GetInsDivDRByPrtRowID(prtRowid,"") ;wangjian 2015-12-07
	//$p(^DHCINVPRT(prtRowid),"^",30) ;此处是调用医保组接口判断还是根据发票表指针判断,?????
	set:(insDivDr'="") flag=1
	quit flag_"^"_insDivDr
}

/// wangjian
/// 2016-01-07
/// 判断收费的就诊挂号是否已经医保分解
/// N 未分解 Y 已分解
/// w ##class(web.DHCOPBillInvPrtInsu).CheckRegInsu(3581194)
ClassMethod CheckRegInsu(PrtRowid)
{
	n (PrtRowid)
	s Rtn="N"
	s Condr=$o(^DHCBCI(0,"INV",PrtRowid,"0"))
    s AdmRowid=$p($g(^DHCBCI(Condr)),"^",3)
	s InsuAdmDr=""
  	&sql(select RegfeeInsuAdmDr into :InsuAdmDr from DHCRegistrationFee where RegfeeAdmDr=:AdmRowid)
  	i (+InsuAdmDr'=0) s Rtn="Y"
  	
  	q Rtn
}

/// wangjian
/// 2015-09-28
/// 异常处理
/// -1 当日撤销失败，-2 当日退货失败，-3 隔日退货失败
/// w ##class(DHCWeChatPay.ChargeInterface.WeChatPayLogic).GetPRTForYCCL(19027892)  --000000235
/// w ##class(DHCWeChatPay.ChargeInterface.WeChatPayLogic).GetPRTForYCCL(15126038)  --000000236
/// w ##class(DHCWeChatPay.ChargeInterface.WeChatPayLogic).GetPRTForYCCL(20392489)
ClassMethod GetPRTForYCCL(PrtRowid)
{
	n (PrtRowid)
	q:((PrtRowid="")||('$d(^DHCINVPRT(PrtRowid)))) "0^此发票不存在!"_$c(2)
	s PrtFlag=0, RetStr=""
	s StrikeRowid=$o(^DHCINVPRT(0,"InitInvDR",PrtRowid,""))
	s NormalRowid=$o(^DHCINVPRT(0,"OldINV",PrtRowid,""))
	s DayFlag=##class(web.DHCBillBankLogic).JudgePrtDate(PrtRowid)
	i (StrikeRowid'="") d
	.i (DayFlag=0) d
	..s TBPRowid=$o(^DHCINVALITPi(0,"S","IPDR",StrikeRowid,""))
	..i TBPRowid="" d
	...i NormalRowid="" d
	....s PrtFlag=-1
	....s RetStr=PrtFlag_"^"_StrikeRowid_$c(2)
	...e  d
	....s PrtFlag=-2
	....s RetStr=PrtFlag_"^"_NormalRowid_"^"_StrikeRowid_$c(2)
	.e  d
	..s TBPRowid=$o(^DHCINVALITPi(0,"S","IPDR",StrikeRowid,""))
	..i TBPRowid="" d
	...s PrtFlag=-3
	...s RetStr=PrtFlag_"^"_NormalRowid_"^"_StrikeRowid_$c(2)
	e  d
	.s RetStr=PrtFlag_"^"_"此发票未做退费!"_$c(2)
	
	i RetStr="" s RetStr=PrtFlag_"^"_"此发票已经成功退费,无需补交易!"_$c(2)
	
	q RetStr
}

}
