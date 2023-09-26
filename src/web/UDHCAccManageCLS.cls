Import SQLUser

Class web.UDHCAccManageCLS Extends BILL.COM.Abstract
{

/// Debug: w ##class(web.UDHCAccManageCLS).AccFootMan("8","7","0.00","79645.21^7^账户结算退款^^F^^2","1^^^^^^^79645.21","8^119^1^3^2^10.200.0.126")
ClassMethod AccFootMan(AccRowID As %String, UserDR As %String, BadPrice As %String, PDInfo As %String, PDPMInfo As %String, ExpStr As %String) As %String
{
	set ^TMP("AccFootMan")=$lb(AccRowID, UserDR, BadPrice, PDInfo, PDPMInfo, ExpStr)
	
	set $zt="ERROR"
	
	set myCardRowID=$p(ExpStr,"^",1)
	set myGroupDR=$p(ExpStr,"^",2)
	set myCardRtnFlag=$p(ExpStr,"^",3)
	set myCTLocDR=$p(ExpStr,"^",4)
	set myHospDR=$p(ExpStr,"^",5)
	set myClientIPAddress=$p(ExpStr,"^",6)
	if (+myHospDR=0) set myHospDR=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(myCTLocDR)
	
	set rtn=0
	
	//+2023-04-10 ZhYW
	set AccMData=$g(^DHCACD("AccM",AccRowID))
	set AccCreatMode=$p(AccMData,"^",23)
	quit:(AccCreatMode="P") -1_"^"_"该账户为按患者主索引建的账户，不能结算"
	 	
	ts
	
	//打印发票
	set TMPGID=$i(^TMPACCColPRT)
	set myAccExpStr=myCTLocDR_"^"_myGroupDR
	set rtnValue=##class(web.UDHCAccPrtPayFoot).BuildAccINVPay(AccRowID, UserDR, TMPGID, myAccExpStr)
	set rtn=$p(rtnValue,"^",1)
	if (+rtn) tro  quit rtnValue
	set myAPINVInfo=""
	set mylen=$l(rtnValue,"^")
	for i=2:1:mylen {
		set accPInvRowId=$p(rtnValue,"^",i)
		continue:(accPInvRowId="")
		set myAPINVInfo=myAPINVInfo_accPInvRowId_"^"
	}
	
	set myPDRowID=""
	if ($p(PDInfo,"^",1)>0) {		//添加判断账户余额大于0  ShangXuehao
		set rtnValue=##class(web.UDHCAccAddDeposit).AddDeposit(AccRowID, PDInfo, PDPMInfo)
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) tro  quit rtnValue
		set myPDRowID=$p(rtnValue,"^",2)
	}
	
	//回收原卡
	set myBaseConfig=##class(web.DHCACBaseConfig).GetAccPara()
	set myReFlag=$p(myBaseConfig,"^",14)
	//=1   表示回收，   =0  表示表示不回收
	set myReFlag=myCardRtnFlag
	if (+myReFlag=1) {
		//回收卡
		set myCardStatus="R"
		set rtnValue=##class(web.UDHCAccCardManage).CardStatusChange(myCardRowID, myCardStatus, UserDR, myClientIPAddress, "", myHospDR)
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) tro  quit rtnValue
		//+2017-07-19 ZhYW 回收原卡时,调用医生站方法将门诊卡发放中的数据追加回来
		set rtnValue=##class(web.DHCCardPurchaseManage).UpdateCardPurchaseAllot(myCardRowID)
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) tro  quit rtnValue
	}
	
	set parkCardInvRowID=""
	set cardINVRowID=$p(^DHCCARD("CF",myCardRowID),"^",17)
	if ((cardINVRowID'="")&&(+myCardRtnFlag=1)) {
		set sFlag="S"
		set myCurDate=+$h, myCurTime=$p($h,",",2)
		
		//作废原发票zhaocz
		set rtnValue=##class(web.DHCBL.CARD.UCardINVPRTInfo).CardINVPark(cardINVRowID, UserDR, sFlag)
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) tro  quit rtnValue
		
		//产生负票
		set rtnValue=##class(web.DHCBL.CARD.UCardINVPRTInfo).CardINVCancel(cardINVRowID, UserDR, sFlag, myCurDate, myCurTime, myHospDR)
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) tro  quit rtnValue
		set parkCardInvRowID=$p(rtnValue,"^",2)
		
		//写负支付模式
		set PayMode=$p(PDPMInfo,"^",1)
		set myExpStr=PayMode
		set rtnValue=##class(web.DHCBL.CARD.UCardINVPRTInfo).CardINVCancelPayMode(cardINVRowID, parkCardInvRowID, myCurDate, myCurTime, myExpStr)
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) tro  quit rtnValue
	}

	//结算账户信息
	set rtnValue=..UpAccFoot(AccRowID, UserDR, BadPrice)
	set rtn=$p(rtnValue,"^",1)
	if (+rtn) tro  quit rtnValue
	
	//增加预交金回收机制数据
	set myExpStr=""
	set myRefSum=-$p(PDInfo,"^",1)   //这里需为负数
	set rtnValue=..UpAccFootInfo(AccRowID, UserDR, myRefSum, myExpStr)
	set rtn=$p(rtnValue,"^",1)
	if (+rtn) tro  quit rtnValue
	
	if ($tl>0) tc
	
	quit +rtn_$c(2)_myAPINVInfo_$c(2)_myPDRowID_$c(2)_parkCardInvRowID_$c(2)_cardINVRowID

ERROR
	quit ..AppException()
}

/// Description: 获得有效的卡标志和DHC_CardRef表的RowID
/// Debug: w ##class(web.UDHCAccManageCLS).getActiveCard("0000009901","24","")
ClassMethod getActiveCard(cardno As %String, securityno As %String) As %String
{
	set rtn=-200    //无效卡
	set myACRowID=""
	quit:(cardno="") rtn_"^"_myACRowID
		
	set mySecNoEncrypt=##class(web.UDHCAccEnrypt).Encrypt(securityno)
	set cardid=0
	while($o(^DHCCARDi("CF",0,"CardNo",cardno,cardid))) {
		set cardid=$o(^DHCCARDi("CF",0,"CardNo",cardno,cardid))
		set cardData=$g(^DHCCARD("CF",cardid))
		set ActiveFlag=$p(cardData,"^",10)
		continue:(ActiveFlag'="N")
		set SecurityNo=$p(cardData,"^",3)
		continue:(SecurityNo'=mySecNoEncrypt)	  //securityno
		set myACRowID=cardid
		set rtn=0
		quit
	}
 	quit rtn_"^"_myACRowID
}

/// Debug: w ##class(web.UDHCAccManageCLS).getaccinfofromcardno("0000000137","")
ClassMethod getaccinfofromcardno(cardno As %String, securityno As %String) As %String
{
	quit:(cardno="") -200_"^"_"卡号为空"
	
	set rtn=0
	
	set AccID="", AccNo="", left=0, Balance=0, DepPrice=0
	set Papmi=""
	set Pass=""
	set PAPMINo=""
	set CardRowID=""
	
	set myAccType="P"
	
	set rtnValue=..getActiveCard(cardno, securityno)
	set rtn=$p(rtnValue,"^",1)
	set CardRowID=$p(rtnValue,"^",2)
	if (rtn=0) {
		set cardData=$g(^DHCCARD("CF",CardRowID))
		set Papmi=$p(cardData,"^",4)
		set PAPMINo=$p($g(^PAPER(Papmi,"PAT",1)),"^",1)
		set accrowid=$p(cardData,"^",1)
		set accMData=$s((+accrowid'=0):$g(^DHCACD("AccM",accrowid)),1:"")
		set AccStatus=$p(accMData,"^",13)
		if (AccStatus="N") {
			set AccID=accrowid
			set AccNo=$p(accMData,"^",1)
			set Balance=$p(accMData,"^",8)
			set Pass=$p(accMData,"^",12)
			set DepPrice=$p(accMData,"^",14)
			set left=Balance-DepPrice
			set myAccType=$p(accMData,"^",16)
		}
	}
	//卡有效，而账户无效返回-201
	if ((rtn=0)&&(AccID="")) {
		set rtn=-201
	}
	
	set str=rtn_"^"_AccID_"^"_AccNo_"^"_left_"^"_Balance_"^"_DepPrice_"^"_Pass
	set str=str_"^"_Papmi_"^"_PAPMINo_"^"_CardRowID_"^"_myAccType
	
	quit str
}

/// 利用卡来查
/// Debug: w ##class(web.UDHCAccManageCLS).ReadPatAccInfo("0000009901","24","","2","")
ClassMethod ReadPatAccInfo(CardNo As %String, CardTypeId As %String, SecurityNo As %String, HospId As %String = "", LangId As %String = "") As %String
{
	set ^TMP("ReadPatAccInfo")=$lb(CardNo, CardTypeId, SecurityNo, HospId, LangId)
	if (HospId="")&&($d(%session)) {
		set HospId=%session.Get("LOGON.HOSPID")
	}
	if (LangId="")&&($d(%session)) {
		set LangId=%session.Get("LOGON.LANGID")
	}
	set rtn=0
	
	set AdmStr=""
	set CheckSecurityFlag=""
	set ExpStr=AdmStr_$c(2)_CardTypeId_$c(2)_CheckSecurityFlag_$c(2)_HospId
	set rtnValue=##class(web.UDHCAccManageCLSIF).getaccinfofromcardno(CardNo, SecurityNo, ExpStr)
	set rtn=$p(rtnValue,"^",1)
	quit:(+rtn) rtnValue
	set myAccRowID=$p(rtnValue,"^",2)
	set myPAPMIDR=$p(rtnValue,"^",8)
	set myCardRowID=$p(rtnValue,"^",10)
	
	set AccMJsonStr=##class(BILL.OP.COM.AccManager).GetAccMInfo(myAccRowID)
	set AccMJson=##class(%DynamicObject).%FromJSON(AccMJsonStr)
	set myCardInvDR=$s((+myCardRowID'=0):$p(^DHCCARD("CF",myCardRowID),"^",17),1:"")     //CF_CardINVPRT_DR
	set myCardAmount=$s((+myCardInvDR'=0):$p(^DHCCARDINVPRT(myCardInvDR),"^",3),1:"")    //CIP_Amount
	set myCardAmount=$fn(myCardAmount,"",2)
	set myPatType=$p(^PAPER(myPAPMIDR,"PER",1),"^",10)
	set myPatJsonStr=##class(BILL.COM.PAPatMas).GetPatientInfo(myPAPMIDR, HospId)
	set myPatJson=##class(%DynamicObject).%FromJSON(myPatJsonStr)
	set mySex=##class(User.CTSex).GetTranByDesc("CTSEXDesc", myPatJson.Sex, LangId)
	set myCredDesc=##class(User.DHCCredType).GetTranByDesc("CRTDesc", AccMJson.CredType, LangId)
	set myASDesc=##class(websys.Translation).Get("", "正常", LangId)
	set myCDT=AccMJson.CreatDate_" "_AccMJson.CreatTime
	set myPDSum=##class(web.UDHCAccAddDeposit).ReadPreDepositSum(myAccRowID)
	set myPLSum=##class(web.UDHCACPayList).ReadPatAccPaySum(myAccRowID)
	set myRegFlag=..getAccRegFlag(myAccRowID)
	
	set myPAInfo=myPatJson.PatientNo_"^"_myPatJson.PatName_"^"_mySex_"^"_myPatJson.BirthDate
	set myPAInfo=myPAInfo_"^"_myCredDesc_"^"_AccMJson.CredNo_"^"_AccMJson.LeftAmt
	set myPAInfo=myPAInfo_"^"_myASDesc_"^"_AccMJson.AccountNo_"^"_myCDT_"^"_AccMJson.BadPrice_"^"_AccMJson.DepPrice
	set myPAInfo=myPAInfo_"^"_myAccRowID
	set myPAInfo=myPAInfo_"^"_myPDSum_"^"_myPLSum_"^"_myPatType
	set myPAInfo=myPAInfo_"^"_myCardRowID_"^"_myRegFlag_"^"_myPAPMIDR_"^"_myPatJson.MobPhone
	set myPAInfo=myPAInfo_"^"_myCardInvDR_"^"_myCardAmount
	
	quit rtn_"^"_myPAInfo
}

/// Debug: w ##class(UDHCAccManageCLS).getAccRegFlag
ClassMethod getAccRegFlag(AccRowID As %String) As %String
{
	s rtn="N"
	q:(+AccRowID=0) rtn
	s rtn="Y"
	s myRegSum=0
	s mysub=0
	f  s mysub=$o(^DHCACD("AccM",AccRowID,"AccPL",mysub)) q:((mysub="")||(rtn="N"))  d
	.s myPLData=$g(^DHCACD("AccM",AccRowID,"AccPL",mysub))
	.s myINVID=$p(myPLData,"^",2)
	.q:(myINVID="")
	.s myFairType=$p($g(^DHCINVPRT(myINVID)),"^",34)
	.s myAmt=+$p(myPLData,"^",8)
	.i (myFairType="R") s myRegSum=myRegSum+myAmt
	.q:(myFairType="R")
	.s rtn="N"
	i (rtn="Y")&&(myRegSum=0) s rtn="N"
	q rtn
}

/// 密码次数设定,默认值3次
ClassMethod getPWDCount() As %String
{
	q:'$d(^DHCACDP("ParaSet","PWDCount")) "3"
	q:+^DHCACDP("ParaSet","PWDCount")=0 "3"
	q ^DHCACDP("ParaSet","PWDCount")
}

/// 挂失与补卡的日期差,默认值3天
ClassMethod getSDateDiff() As %String
{
	q:'$d(^DHCACDP("ParaSet","SDateDiff")) "3"
	q +(^DHCACDP("ParaSet","SDateDiff"))
}

/// 密码遗忘日期差,默认值3天
ClassMethod getPWDDateDiff() As %String
{
	q:'$d(^DHCACDP("ParaSet","PWDDateDiff")) "3"
	q +(^DHCACDP("ParaSet","PWDDateDiff"))
}

/// 有效证件不能为空设置.1--不能为空,0--可以为空.默认值0
ClassMethod getEffectPaper() As %String
{
	q:'$d(^DHCACDP("ParaSet","EffectPaper")) "0"
	q:+^DHCACDP("ParaSet","EffectPaper")=0 "0"
	q (^DHCACDP("ParaSet","EffectPaper"))
}

/// 补卡不需要挂失.1--不需要,0--需要.默认值0
ClassMethod getCardReqSuspend() As %String
{
	q:'$d(^DHCACDP("ParaSet","CardReqSuspend")) "0"
	q:+^DHCACDP("ParaSet","CardReqSuspend")=0 "0"
	q ^DHCACDP("ParaSet","CardReqSuspend")
}

/// 密码遗忘修改不需要申请.1--不需要,0--需要.默认值0
ClassMethod getPWDEditReq() As %String
{
	q:'$d(^DHCACDP("ParaSet","PWDEditReq")) "0"
	q:+^DHCACDP("ParaSet","PWDEditReq")=0 "0"
	q ^DHCACDP("ParaSet","PWDEditReq")
}

ClassMethod getAccBalance(Accid As %String) As %String
{
	q:(+Accid=0) ""
	s Balance=$p($g(^DHCACD("AccM",Accid)),"^",8)
	q $fn(Balance,"",2)
}

/// Debug: w ##class(web.UDHCAccManageCLS).getpatinfo("setAccMInfo","","0000002084","","","","","","2")
ClassMethod getpatinfo(itmjs As %String = "", itmjsex As %String = "", regno As %String = "", patientid As %String = "", cardno As %String = "", securityno As %String = "", idno As %String = "", cardTypeDR As %String = "", hospId As %String = "")
{
	set ^TMP("getpatinfo")=$lb(itmjs, itmjsex, regno, patientid, cardno, securityno, idno, cardTypeDR, hospId)
 	set PatientNo="", Papmi="", PatName="", CredNo="", CardNo=""
 	set AccNo="", Balance="", DepPrice="", AccType="", CredTypeID="", CardID="", AccID=""
 	set AccStatus="", AccTypeName="", AccStatusName=""
 	set CardTypeID="", IDNo="", MobPhone=""
	set ErrCode=0    //错误代码
	
 	if ((hospId="")&&($d(%session))) {
		set hospId=%session.Get("LOGON.HOSPID")
	}
	
	set cardno=$p(cardno,$c(0))
 	set securityno=$p(securityno,$c(0))
 	
 	set SecNoEncrypt=$s((securityno'=""):##class(web.UDHCAccEnrypt).Encrypt(securityno),1:"")
 	
	set AccMCreatMode=$s((+cardTypeDR'=0):$p($g(^DHCCARDTYPEDef(cardTypeDR)),"^",45),1:"")   //+2023-04-07 ZhYW 获取卡类型配置的账户创建模式

 	if (patientid'="") {
	 	set PAPMI=patientid
	 	set myCardId=0
	 	while($o(^DHCCARDi("CF",0,"PAPMIDR",PAPMI,myCardId))) {
		 	set myCardId=$o(^DHCCARDi("CF",0,"PAPMIDR",PAPMI,myCardId))
		 	set cardData=$g(^DHCCARD("CF",myCardId))
		 	set myCardTypeDR=$p(cardData,"^",16)
		 	continue:((cardTypeDR'="")&&(cardTypeDR'=myCardTypeDR))
		 	set ActiveFlag=$p(cardData,"^",10)
		 	continue:(ActiveFlag'="N")
		 	set CardNo=$p(cardData,"^",2)
		 	set SecurityNo=$p(cardData,"^",3)
		 	set CardID=myCardId
			set CardTypeID=myCardTypeDR
		 	quit
		}
 	}
 	
	if (regno'="") {
	 	set PatientNo=##class(web.UDHCJFBaseCommon).regnocon(regno)
	 	set PAPMI=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(PatientNo),0))
	 	if (+PAPMI'=0) {
			set myCardId=0
			while($o(^DHCCARDi("CF",0,"PAPMIDR",PAPMI,myCardId))) {
				set myCardId=$o(^DHCCARDi("CF",0,"PAPMIDR",PAPMI,myCardId))
				set cardData=$g(^DHCCARD("CF",myCardId))
			 	set myCardTypeDR=$p(cardData,"^",16)
			 	continue:((cardTypeDR'="")&&(cardTypeDR'=myCardTypeDR))
			 	set ActiveFlag=$p(cardData,"^",10)
			 	continue:(ActiveFlag'="N")
			 	set CardNo=$p(cardData,"^",2)
			 	set SecurityNo=$p(cardData,"^",3)
			 	set CardID=myCardId
			 	set CardTypeID=myCardTypeDR
			 	quit
			}
		}
	}
	
 	if (cardno'="") {
	 	set myCardId=0
	 	while($o(^DHCCARDi("CF",0,"CardNo",cardno,myCardId))) {
		 	set myCardId=$o(^DHCCARDi("CF",0,"CardNo",cardno,myCardId))
		 	set cardData=$g(^DHCCARD("CF",myCardId))
		 	set myCardTypeDR=$p(cardData,"^",16)
		 	continue:((cardTypeDR'="")&&(cardTypeDR'=myCardTypeDR))
		 	set ActiveFlag=$p(cardData,"^",10)
		 	continue:(ActiveFlag'="N")
		 	set SecurityNo=$p(cardData,"^",3)
		 	if (SecurityNo'=SecNoEncrypt) {
		 		set ErrCode=-200				//无效卡代码
		 	}else {
		 		set ErrCode=0
		 	}
		 	continue:(SecurityNo'=SecNoEncrypt)
			set PAPMI=$p(cardData,"^",4)
			set CardTypeID=myCardTypeDR
		 	quit
		}
 	}
 	
	if (+PAPMI'=0) {
		set PatJsonStr=##class(BILL.COM.PAPatMas).GetPatientInfo(PAPMI, hospId)
		set PatJson=##class(%DynamicObject).%FromJSON(PatJsonStr)
		set PatientNo=PatJson.PatientNo
		set PatName=PatJson.PatName
	 	set MobPhone=PatJson.MobPhone             //联系电话
	 	set IDNo=PatJson.ID                       //身份证号
	}
	
	//获取预交金账户
	if (AccMCreatMode="C") {
		set AccID=..GetAccMRowIDByCard(PAPMI, CardNo, CardTypeID, hospId)  //根据卡号获取账户ID
	}else {
		set AccID=..GetAccMRowIDByPAPMI(PAPMI, hospId)    //根据患者主索引获取账户信息ID
	}
	if (+AccID'=0) {
		set AccMData=$g(^DHCACD("AccM",AccID))
		set AccStatus=$p(AccMData,"^",13)
	 	set AccNo=$p(AccMData,"^",1)
	 	set CardNo=$p(AccMData,"^",4)
	 	set Balance=$p(AccMData,"^",8)
	 	set DepPrice=$p(AccMData,"^",14)
	 	set AccType=$p(AccMData,"^",16)
	 	set CredTypeID=$p(AccMData,"^",17)
	 	set CredNo=$p(AccMData,"^",18)
	}
		 	
 	set AccTypeName=$case(AccType,"C":"集体账户","F":"家庭账户",:"个人账户")
 	set AccStatusName=$case(AccStatus,"N":"正常","S":"挂起","F":"结算",:"")
 	
	set CredType=$s((CredTypeID'=""):$p($g(^PAC("CARD",CredTypeID)),"^",1),1:"")      //tangzf 2019-08-23 证件类型Code
 	set CardType=$s((+CardTypeID'=0):$p($g(^DHCCARDTYPEDef(CardTypeID)),"^",2),1:"")  //卡类型
 	
 	set str=PatientNo_"^"_PAPMI_"^"_PatName_"^"_AccStatus_"^"_CardNo_"^"_AccNo_"^"_Balance		;0--6
	set str=str_"^"_DepPrice_"^"_AccType_"^"_CredTypeID_"^"_CredType_"^"_CredNo		;7--11
 	set str=str_"^"_securityno_"^"_CardID_"^"_AccID_"^"_AccTypeName_"^"_AccStatusName	;12--16
	set str=str_"^"_ErrCode_"^"_MobPhone_"^"_IDNo_"^"_CardTypeID_"^"_CardType	;17-21
 	
	set retval=itmjs_"('"_$zcvt(str,"O","JS")_"');"
 	if (itmjsex'="""") set retval=retval_itmjsex_"('"_$zcvt(str,"O","JS")_"');"
 	&javascript<#(retval)#>
 	quit 1
}

/// Debug: w ##class(web.UDHCAccManageCLS).getAccountNo("0011")
ClassMethod getAccountNo(AccountNo As %String) As %String
{
	set tmpNo=""
	
	set len=8
	set PATCFid=$o(^CF("PATCF",""))
	if (PATCFid'="") set len=$p($g(^CF("PATCF",PATCFid,3)),"^",5)
	
	//判断节点是否存在
	if $d(^DHCACDi("AccM",0,"AccountNo")) {
		if '$d(^DHCACDi("AccM",0,"AccountNo",AccountNo_"0001")) {
			set AccountNo=AccountNo_"0001"
		}else {
			set tmpNo=AccountNo_"0000",AccountNo1=AccountNo
			for  set tmpNo=$o(^DHCACDi("AccM",0,"AccountNo",tmpNo)) quit:((tmpNo="")||(AccountNo1'=$e(tmpNo,1,len)))  do
			.set AccountNo=tmpNo
			set tmpNo=$e(AccountNo,len+1,len+4)+1
			set tmpNo=$e("0000",1,4-$l(tmpNo))_tmpNo
			set AccountNo=$e(AccountNo,1,len)_tmpNo
		}
	}else {
		set AccountNo=AccountNo_"0001"
	}
	
	quit AccountNo
}

ClassMethod NewAccount(itmjs As %String = "", itmjsex As %String = "", str1 As %String = "", str2 As %String = "") As %String
{
	set rtn=0
	set $zt="ERROR"
	ts
	
 	set rtnValue=..NewAccountAdd(str1)
 	set rtn=$p(rtnValue,"^",1)
 	if (+rtn) tro  quit rtnValue
 	
 	set accMId=$p(rtnValue,"^",2)
 	set $p(str2,"^",1)=accMId
	if ($p(str2,"^",2)'="") {
		set rtnValue=##class(web.UDHCAccAddDeposit).AddDeposit(str2)
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) tro  quit rtnValue
	}
	
	if ($tl>0) tc
	
	//调用平台组接口
	do ##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDADDACCMANAGERINFO", accMId)

	quit rtn
ERROR
	quit ..AppException()
}

/// Debug: w ##class(web.UDHCAccManageCLS).NewAccountAdd("")
ClassMethod NewAccountAdd(str As %String) As %String
{
 	//str=AccountNo_"^"_papmi_"^"_RegNo_"^"_CardNo_"^"_user_"^"_Password_"^"_Depprice_"^"_AccountType_"^"_CredType_"^"_CredNo_"^"_CardID
 	set rtn=0
 	set PatientId=$p(str,"^",2)
 	set PatientNo=$p(str,"^",3)
 	set CardNo=$p(str,"^",4)
 	set UserId=$p(str,"^",5)
 	set Password=$p(str,"^",6)
 	//set Password=##class(web.UDHCAccEnrypt).Encrypt(Password)
 	set DepPrice=+$p(str,"^",7)
 	set AccountType=$p(str,"^",8)
 	set CredTypeId=$p(str,"^",9)
 	set CredNo=$p(str,"^",10)
	set CardId=$p(str,"^",11)
	
 	set AccountNo=..getAccountNo(PatientNo)
 	quit:$d(^DHCACDi("AccM",0,"AccountNo",AccountNo)) 1_"^^^"
 	
 	set AccMRowId=..GetAccByPapmi(PatientId)
 	quit:(+AccMRowId'=0) 1_"^^^"
 	
	&SQL(
		INSERT INTO DHC_AccManager (
			AccM_AccountNo, AccM_PAPMI_DR, AccM_PAPMINo, AccM_CardNo, AccM_OCDate,
			AccM_OCTime, AccM_CUser_DR, AccM_PassWord, AccM_AccStatus, AccM_DepPrice,
			AccM_Type, AccM_CredType_DR, AccM_CredNo
		)
		VALUES (
			:AccountNo, :PatientId, :PatientNo, :CardNo, CONVERT(DATE, NOW()),
			CONVERT(TIME, NOW()), :UserId, :Password, 'N', :DepPrice,
			:AccountType, :CredTypeId, :CredNo
		)
	)
	set rtn=SQLCODE
	if (+rtn) quit rtn_"^"_$g(%msg)
	
	set AccMRowId=$g(%ROWID)
	if (CardId'="") {
		set rtn=..CardUpdate(CardId, AccMRowId)
		if (+rtn) quit rtn
	}
	
	quit rtn_"^"_AccMRowId_"^"_AccountNo_"^N"
}

ClassMethod GetAccByPapmi(papmi As %String) As %String
{
	set accMRowId=""
	quit:(papmi="") accMRowId
	
	set cardId=0
	while($o(^DHCACDi("AccM",0,"PAPMI",papmi,cardId))) {
		set cardId=$o(^DHCACDi("AccM",0,"PAPMI",papmi,cardId))
		set ActiveFlag=$p(^DHCACD("AccM",cardId),"^",13)
	 	continue:(" N S "'[(" "_ActiveFlag_" "))
	 	set accMRowId=cardId
	}
	quit accMRowId
}

ClassMethod AccountWriteoff(AccountID As %String, user As %String, IP As %String) As %String
{
	set $zt="ERROR"
	set oldStatus=$p($g(^DHCACD("AccM",AccountID)),"^",13)
	
	ts
	
	&SQL(
		UPDATE DHC_AccManager
		SET AccM_WoffDate = CONVERT(DATE, NOW()), AccM_WoffTime = CONVERT(TIME, NOW()), AccM_DUser_DR = :user,
			AccM_AccStatus = 'F'
		WHERE %ID = :AccountID
	)
	set rtn=SQLCODE
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
 	
	set rtn=..AccountStatusRecord(AccountID, oldStatus, "F", user, IP, "")
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	
	if ($tl>0) tc
	
 	quit rtn
ERROR
	quit ..AppException()
}

ClassMethod CardUpdate(cardId As %String, accMRowId As %String) As %String
{
	&SQL(
		UPDATE DHC_CardRef
		SET CF_AccNo_DR = :accMRowId
		WHERE %ID = :cardId
	)
	set rtn=SQLCODE
	if (+rtn) quit rtn_"^"_$g(%msg)
	quit rtn
}

Query AccountTypelookup() As websys.Query(ROWSPEC = "acctype:%String,acctype1:%String")
{
}

ClassMethod AccountTypelookupExecute(ByRef qHandle As %Binary) As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
 	set acctype="P", acctype1="个人账户"
 	do OutputAccountType
 	set acctype="C", acctype1="集体账户"
 	do OutputAccountType
 	
	quit $$$OK
    
OutputAccountType
	set Data=$lb(acctype1,acctype)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

ClassMethod AccountStatusChange(accMId As %String, oldStatus As %String, newStatus As %String, userId As %String, IP As %String, RLinfo As %String) As %String
{
	&SQL(
		UPDATE DHC_AccManager
		SET AccM_AccStatus = :newStatus
		WHERE %ID= :accMId
	)
	set rtn=SQLCODE
	if (+rtn) quit rtn_"^"_$g(%msg)
	
	set rtn=..AccountStatusRecord(accMId, oldStatus, newStatus, userId, IP, RLinfo)
 	quit rtn
}

ClassMethod AccountStatusRecord(accMId As %String, oldStatus As %String, newStatus As %String, userId As %String, IP As %String, RLinfo As %String) As %String
{
	
	set RLName=$p(RLinfo,"^",1)
	set RLCredNo=$p(RLinfo,"^",2)
	set RLAddress=$p(RLinfo,"^",3)
	set RLPhoneNo=$p(RLinfo,"^",4)
	set RLProof=$p(RLinfo,"^",5)
	set RLRemark=$p(RLinfo,"^",6)
	set RLCredType=$p(RLinfo,"^",7)
		
	&SQL(
		INSERT INTO DHC_AccStatusChange (
			AccSC_ParRef, AccSC_OValue, AccSC_NValue, AccSC_OperDate, AccSC_OperTime,
			AccSC_User_DR, AccSC_Note, AccSC_RLName, AccSC_RLCredNo, AccSC_RLAddress,
			AccSC_RLPhoneNo, AccSC_RLProof, AccSC_RLRemark, AccSC_CredType
		)
		VALUES (
			:accMId, :oldStatus, :newStatus, CONVERT(DATE, NOW()), CONVERT(TIME, NOW()),
			:userId, :IP, :RLName, :RLCredNo, :RLAddress,
			:RLPhoneNo, :RLProof, :RLRemark, :RLCredType
		)
	)
	set rtn=SQLCODE
	if (+rtn) quit rtn_"^"_$g(%msg)
	quit rtn
}

ClassMethod getAccPW(accMId As %String, cardid As %String) As %String
{
	quit:(accMId="") -1_"^^"
	quit:(cardid="") -2_"^^"
	quit:'$d(^DHCACD("AccM",accMId)) -3_"^^"
	quit:'$d(^DHCCARD("CF",cardid)) -4_"^^"
	set accstatus=$p(^DHCACD("AccM",accMId),"^",13)
	quit:(accstatus'="N") -5_"^^"
	set accpassword=$p(^DHCACD("AccM",accMId),"^",12)
	set cardstatus=$p(^DHCCARD("CF",cardid),"^",10)
	quit:(cardstatus'="N") -6_"^^"
	set cardsecurityno=$p(^DHCCARD("CF",cardid),"^",3)
	if (cardsecurityno'="") set cardsecurityno=##class(web.UDHCAccEnrypt).Decrypt(cardsecurityno)
	quit 0_"^"_accpassword_"^"_cardsecurityno
}

ClassMethod ChgAccPW(accMId As %String, pwd As %String, userId As %String, IP As %String, RLinfo As %String) As %String
{
	set $zt="ERROR"
	set oldPwd=$p($g(^DHCACD("AccM",accMId)),"^",12)
	
	ts
	
	&SQL(
		UPDATE DHC_AccManager
		SET AccM_PassWord = :pwd
		WHERE %ID= :accMId
	)
	set rtn=SQLCODE
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	
	set rtn=..AccountStatusRecord(accMId, oldPwd, pwd, userId, IP, RLinfo)
	if (+rtn) tro  quit rtn
	
 	if ($tl>0)  tc
 	
 	quit rtn
 	
ERROR
	quit ..AppException()
}

/// Description: 根据登记号的RowID显示患者的帐户信息返回值：rtn_"^"_Desc
/// Debug: w ##class(web.UDHCAccManageCLS).GetAccInfoByPAPMI("5810","2000","")
ClassMethod GetAccInfoByPAPMI(PAPMI As %String, TolSum As %String, ExpStr As %String) As %String
{
	;返回值：0表示正常或没有正常的资金帐户
	;1	资金帐户余额不足，返回差额提示操作员
	
	s rtn=0
	s myDesc=""
	
	q:(PAPMI="") 0_"^"_"没有账户"
	;^DHCACDi("AccM",0,"PAPMI",{AccM_PAPMI_DR},{AccM_RowID})
	s myAccRowID=$o(^DHCACDi("AccM",0,"PAPMI",PAPMI,""),-1)
	q:(myAccRowID="") 0_"^"_"没有账户"
	
	;^DHCACD("AccM",{AccM_RowID})
	s myAccData=$g(^DHCACD("AccM",myAccRowID))
	s myAccStatus=$p(myAccData,"^",13)
	q:(myAccStatus'="N") 0_"^"_"没有账户"
	
	s myBalance=+$p(myAccData,"^",8)
	s myDepPrice=+$p(myAccData,"^",14)
	
	s myAccLeft=+myBalance-myDepPrice
	
	s myDesc="账户正常"
	
	i (+TolSum>+myAccLeft) {
		s rtn=1
		s myDesc=+myAccLeft-TolSum
	}
	
	q rtn_"^"_myDesc
}

ClassMethod ResetPWApply(accMId As %String, userId As %String, IP As %String, RLinfo As %String) As %String
{
	set $zt="ERROR"
	set accstatus=$p(^DHCACD("AccM",accMId),"^",13)
 	quit:(accstatus'="N") -313
	ts
	set rtn=..AccountStatusChange(accMId, "N", "S", userId, IP, RLinfo)
	if (+rtn) tro  quit rtn
 	if ($tl>0)  tc
 	quit rtn
ERROR
	quit ..AppException()
}

ClassMethod ResetAccPW(accMId As %String, pwd As %String, userId As %String, IP As %String, RLinfo As %String) As %String [ ProcedureBlock = 0 ]
{
	new (accMId, pwd, userId, IP, RLinfo)
	set rtn=##class(web.UDHCAccManager).SELECT(accMId)
	quit:(+rtn) rtn_"^"
	set applyday=0
	set daydiff=..getPWDDateDiff()
	set accstatus=$p(^DHCACD("AccM",accMId),"^",13)
	
	if (accstatus="S") do
	.set cssub=$o(^DHCACD("AccM",3,"SC",""),-1)
	.quit:(+cssub=0)
	.set applyday=$p(^DHCACD("AccM",3,"SC",cssub),"^",4)
	
	set today=+$h
	set rday=daydiff+applyday-today
	quit:(rday>0) -315_"^"_rday
	set oldPwd=PLIST(13)
	
	kill PLIST
	set PLIST(13)=pwd
	if (accstatus="S")  set PLIST(14)="N"
	set $zt="ERROR^DHCSSERR"
	
	ts
 	set rtn=##class(web.UDHCAccManager).UPDATE(accMId)
 	if (+rtn) tro  quit rtn
 	
	set rtn=..AccountStatusRecord(accMId, oldPwd, pwd, userId, IP, RLinfo)
	if (+rtn) tro  quit rtn
	
 	if (accstatus="S")  set rtn=..AccountStatusRecord(accMId, "S", "N", userId, IP, RLinfo)
 	if (+rtn) tro  quit rtn
 	
 	if ($tl>0)  tc
 	
 	quit rtn_"^"
}

/// 账户查询
/// Debug: do ##class(%ResultSet).RunQuery("web.UDHCAccManageCLS","ReadAccMList","","","","000000000998","","","","","","","")
Query ReadAccMList(AccNo As %String, PAPMINo As %String, CUserId As %String, CardNo As %String, AccStatus As %String, AccType As %String, StDate As %String, EndDate As %String, PatName As %String, LangId As %String = "", HospId As %String = "") As websys.Query(ROWSPEC = "PAPMINo:%String:登记号,PatName:%String:患者姓名,Sex:%String:性别,CardNo:%String:卡号,AccountNo:%String:账户号,PreSum:%Float:预交金缴款,RefPreSum:%Float:预交金退款,AccPaySum:%Float:卡消费额,AccLeftSum:%Float:账户余额,AccStatusName:%String:账户状态,CUserName:%String:开户人员,CDate:%String:开户日期,CTime:%String:开户时间,WUserName:%String:销户人员,WDate:%String:销户日期,WTime:%String:销户时间,CredName:%String:证件类型,AccRowID:%String:账户ID")
{
}

ClassMethod ReadAccMListExecute(ByRef qHandle As %Binary, AccNo As %String, PAPMINo As %String, CUserId As %String, CardNo As %String, AccStatus As %String, AccType As %String, StDate As %String, EndDate As %String, PatName As %String, LangId As %String = "", HospId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	if ((StDate="")||(EndDate=""))  quit $$$OK
	
	if (LangId="")&&($d(%session)) {
		set LangId=%session.Get("LOGON.LANGID")
	}
	
	set StDate=##class(websys.Conversions).DateHtmlToLogical(StDate)
	set EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	
	set (myPreTSum, myRefPreTSum, myAccPayTSum, myAccLeftTSum)=""
	
	if (PAPMINo'="") {
		set PAPMINo=##class(web.UDHCJFBaseCommon).regnocon(PAPMINo)
	}
	set DepTypeId=##class(web.UDHCAccAddDeposit).GetAccPreDepTypeId()
	
	do ValidateData
	
	for myDate=StDate:1:EndDate {
		set myAccRowID=0
		while($o(^DHCACDi("AccM",0,"OCDate",myDate,myAccRowID))) {
			set myAccRowID=$o(^DHCACDi("AccM",0,"OCDate",myDate,myAccRowID))
			set myAccMData=$g(^DHCACD("AccM",myAccRowID))
			set hospId=$p(myAccMData,"^",24)					//AccM_Hosp_DR
			continue:((HospId'="")&&(hospId'=HospId))
			set myAccountNo=$p(myAccMData,"^",1)				//AccM_AccountNo
			continue:((AccNo'="")&&(myAccountNo'=AccNo))
			set myPAPMIDR=$p(myAccMData,"^",2)				    //AccM_PAPMI_DR
			set myPatName=$p($g(^PAPER(myPAPMIDR,"ALL")),"^", 1)
			continue:((PatName'="")&&(PatName'=myPatName))
			set myDOB=$p($g(^PAPER(myPAPMIDR,"ALL")),"^",6)
			set mySexDR=$p($g(^PAPER(myPAPMIDR,"ALL")),"^",7)
			set mySex=$s((+mySexDR'=0):$p($g(^CT("SEX",mySexDR)),"^",2),1:"")
			set mySex=##class(User.CTSex).GetTranByDesc("CTSEXDesc", mySex, LangId)
			set myPAPMINo=$p(myAccMData,"^",3)				//AccM_PAPMINo
			continue:((PAPMINo'="")&&(PAPMINo'=myPAPMINo))
			set myCardNo=$p(myAccMData,"^",4)				//AccM_CardNo
			continue:((CardNo'="")&&(CardNo'=myCardNo))
			set myCDate=$p(myAccMData,"^",5)				//AccM_OCDate
			set myCTime=$p(myAccMData,"^",6)	//AccM_OCTime
			set myCDate=##class(websys.Conversions).DateLogicalToHtml(myCDate)
			set myCTime=##class(websys.Conversions).TimeLogicalToHtml(myCTime, 1)
			set myCUserDR=$p(myAccMData,"^",7)	//AccM_CUser_DR
			continue:((CUserId'="")&&(CUserId'=myCUserDR))
			set myCUserName=$s((myCUserDR'=""):$p($g(^SSU("SSUSR",myCUserDR)),"^",2),1:"")
			set myCUserName=##class(User.SSUser).GetTranByDesc("SSUSRName", myCUserName, LangId)
			set myAccType=$p(myAccMData,"^",16)	  //AccM_Type
			continue:((AccType'="")&&(AccType'=myAccType))
			set myAccStatus=$p(myAccMData,"^",13)	//AccM_AccStatus
			continue:((AccStatus'="")&&(AccStatus'=myAccStatus))
			set myAccStatusDesc=$case(myAccStatus,"N":"正常","S":"挂起","F":"结算",:"")
			set myAccStatusDesc=##class(websys.Translation).Get("", myAccStatusDesc, LangId)
			set myAccLeftSum=$p(myAccMData,"^",8)	//AccM_Balance
			set myAccLeftSum=$fn(myAccLeftSum,"",2)
			set myWDate=$p(myAccMData,"^",9)	   //AccM_WoffDate
			set myWDate=##class(websys.Conversions).DateLogicalToHtml(myWDate)
			set myWTime=$p(myAccMData,"^",10)	   //AccM_WoffTime
			set myWTime=##class(websys.Conversions).TimeLogicalToHtml(myWTime, 1)
			set myWUserDR=$p(myAccMData,"^",11)	  //AccM_DUser_DR
			set myWUserName=$s((myWUserDR'=""):$p($g(^SSU("SSUSR",myWUserDR)),"^",2),1:"")
			set myWUserName=##class(User.SSUser).GetTranByDesc("SSUSRName", myWUserName, LangId)
			if (myAccStatus="N") {
				set myWUserName=""
				set myWDate=""    //正常状态的数据不显示销户人员和销户日期
				set myWTime=""
			}
			set myCredTDR=$p(myAccMData,"^",17)	  //AccM_CredType_DR 证件类型
			set myCredName=$s((myCredTDR'=""):$p($g(^PAC("CARD",myCredTDR)),"^",2),1:"")   //证件类型
			set myCredName=##class(User.DHCCredType).GetTranByDesc("CRTDesc", myCredName, LangId)
			//预交金
			set myPreSum=0
			set myRefPreSum=0
			set mySub=0
			while($o(^DHCACD("AccM",myAccRowID,"AccPD",mySub))) {
				set mySub=$o(^DHCACD("AccM",myAccRowID,"AccPD",mySub))
				set myPDData=$g(^DHCACD("AccM",myAccRowID,"AccPD",mySub))
				continue:(myPDData="")
				set myPDDepType=$p(myPDData,"^",10)
				continue:(myPDDepType'=DepTypeId)   //非门诊预交金过滤
				set myPDAmt=$p(myPDData,"^",2)
				if (+myPDAmt>0) {
					set myPreSum=$i(myPreSum, myPDAmt)
				}else {
					set myRefPreSum=$i(myRefPreSum, myPDAmt)
				}
			}
			set myPreSum=$fn(myPreSum,"",2)
			set myRefPreSum=$fn(myRefPreSum,"",2)
			//卡支付
			set myAccPaySum=0
			set mySub=0
			while($o(^DHCACD("AccM",myAccRowID,"AccPL",mySub))) {
				set mySub=$o(^DHCACD("AccM",myAccRowID,"AccPL",mySub))
				set myPLData=$g(^DHCACD("AccM",myAccRowID,"AccPL",mySub))
				continue:(myPLData="")
				set myPLAmt=$p(myPLData,"^",8)
				set myAccPaySum=$i(myAccPaySum, myPLAmt)
			}
			set myAccPaySum=$fn(myAccPaySum,"",2)
			set myPreTSum=$i(myPreTSum, myPreSum)
			set myRefPreTSum=$i(myRefPreTSum, myRefPreSum)
			set myAccPayTSum=$i(myAccPayTSum, myAccPaySum)
			set myAccLeftTSum=$i(myAccLeftTSum, myAccLeftSum)
			do OutputAccMList
		}
	}
	
	do ValidateData
	if (ind>1) {
		set myPAPMINo=##class(websys.Translation).Get("", "合计", LangId)
		set myPreSum=$fn(+myPreTSum,"",2)
		set myRefPreSum=$fn(+myRefPreTSum,"",2)
		set myAccPaySum=$fn(+myAccPayTSum,"",2)
		set myAccLeftSum=$fn(+myAccLeftTSum,"",2)
		do OutputAccMList
	}
	
	quit $$$OK
OutputAccMList
	set Data=$lb(myPAPMINo,myPatName,mySex,myCardNo,myAccountNo,myPreSum,myRefPreSum,myAccPaySum,myAccLeftSum,myAccStatusDesc,myCUserName,myCDate,myCTime,myWUserName,myWDate,myWTime,myCredName,myAccRowID)
	set ^CacheTemp(repid,ind)=Data
	set ind=$i(ind)
	quit
ValidateData
	set (myPAPMINo,myPatName,mySex,myCardNo,myAccountNo,myPreSum,myRefPreSum,myAccPaySum,myAccLeftSum,myAccStatusDesc,myCUserName,myCDate,myCTime,myWUserName,myWDate,myWTime,myCredName,myAccRowID)=""
	quit
}

/// 查询每个账户的账目变化情况, 可以给患者提供清单
/// 同时，可以利用触摸屏来查询
/// Debug: do ##class(%ResultSet).RunQuery("web.UDHCAccManageCLS","ReadPatAccList","18")
Query ReadPatAccList(AccRowID As %String, LangId As %String = "") As websys.Query(ROWSPEC = "APDate:%String:交易时间,APType:%String:交易类型,AccSum:%Float:金额,AccUser:%String:操作员,ABillNo:%String:单据号,ALeft:%Float:余额,Flag:%String,PRowID:%String,INVNo:%String:发票号,InvType:%String,APDepType:%String:押金类型")
{
}

ClassMethod ReadPatAccListExecute(ByRef qHandle As %Binary, AccRowID As %String, LangId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	set ^TMP("ReadPatAccList")=$lb(AccRowID)
	
	if (LangId="")&&($d(%session)) {
		set LangId=%session.Get("LOGON.LANGID")
	}
	
	kill ^TMPAccPat("Acc",$j)
	do ##class(web.UDHCACPayList).SetPatAccPayList(AccRowID, LangId)
	do ##class(web.UDHCAccAddDeposit).SetPreDepositList(AccRowID, LangId)
	
	set myADate=""
	while($o(^TMPAccPat("Acc",$j,myADate),-1)) {
		set myADate=$o(^TMPAccPat("Acc",$j,myADate),-1)
		set myATime=""
		while($o(^TMPAccPat("Acc",$j,myADate,myATime),-1)) {
			set myATime=$o(^TMPAccPat("Acc",$j,myADate,myATime),-1)
			set mySub=""
			while($o(^TMPAccPat("Acc",$j,myADate,myATime,mySub),-1)) {
				set mySub=$o(^TMPAccPat("Acc",$j,myADate,myATime,mySub),-1)
				set accData=$g(^TMPAccPat("Acc",$j,myADate,myATime,mySub))
				set APDate=$p(accData,"^",1)
				set APType=$p(accData,"^",2)
				set AccSum=$p(accData,"^",3)
				set AccSum=$fn(AccSum,"",2)
				set AccUser=$p(accData,"^",4)
				set ABillNo=$p(accData,"^",5)
				set ALeft=$p(accData,"^",6)
				set ALeft=$fn(ALeft,"",2)
				set myFlag=$p(accData,"^",7)
				set myPRowID=$p(accData,"^",8)
				set myAPDepType=""
				set myINVNo=""
				set myInvType=""
				if (myFlag="PD") {
					set myAPDepType=$p(accData,"^",9)
				}else {
					set myINVNo=$p(accData,"^",9)
					set myBusiType=$p(accData,"^",10)
					set myInvType=$case(myBusiType,"CARD":"CARD","PE":"PE",:"PRT")
				}
				do OutputAccList
			}
		}
	}
	
	kill ^TMPAccPat("Acc",$j)
	
	quit $$$OK
OutputAccList
	set Data=$lb(APDate,APType,AccSum,AccUser,ABillNo,ALeft,myFlag,myPRowID,myINVNo,myInvType,myAPDepType)
	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

ClassMethod UpAccFoot(AccRowID As %String, UserDR As %String, BadPrice As %String) As %String
{
	set rtn=0
	
	set AccMLeft=$p($g(^DHCACD("AccM",AccRowID)),"^",8)
	quit:(+AccMLeft'=0) -207_"^"_"账户余额不为0，不能结算账户"
	
	&SQL(
		UPDATE DHC_AccManager
		SET AccM_WoffDate = CONVERT(DATE, NOW()), AccM_WoffTime = CONVERT(TIME, NOW()), AccM_DUser_DR = :UserDR,
			AccM_AccStatus = 'F', AccM_DepPrice = 0, AccM_BadPrice = :BadPrice
		WHERE %ID = :AccRowID
	)
	set rtn=SQLCODE
	quit:(+rtn) rtn_"^"_$g(%msg)
	quit rtn
}

ClassMethod AccCallBack(AccRowID As %String, UserDR As %String, ExpStr As %String) As %String
{
	set rtn=0
	
	set accMLeft=$p(^DHCACD("AccM",AccRowID),"^",8)
	quit:(+accMLeft'=0) -207
	
	&SQL(
		UPDATE DHC_AccManager
		SET AccM_WoffDate = NULL, AccM_WoffTime = NULL, AccM_DUser_DR = NULL,
			AccM_AccStatus = 'N'
		WHERE %ID = :AccRowID
	)
	set rtn=SQLCODE
	quit:(+rtn) rtn_"^"_$g(%msg)
	quit rtn
}

/// Debug: w ##class(web.UDHCAccManageCLS).UpAccFootInfo("", "", "", "")
ClassMethod UpAccFootInfo(AccRowID As %String, UserDR As %String, myRefSum As %String, ExpStr As %String) As %String
{
	set $zt="ERROR"
	
	set rtn=0
	set myPAPMIDR=$p(^DHCACD("AccM",AccRowID),"^",2)
	
	//收入的预交金总额
	set myPreSum=0
	set mySub=0
	while($o(^DHCACD("AccM",AccRowID,"AccPD",mySub))) {
		set mySub=$o(^DHCACD("AccM",AccRowID,"AccPD",mySub))
		set mySubData=$g(^DHCACD("AccM",AccRowID,"AccPD",mySub))
		continue:(mySubData="")
		set myAccFIDR=$p(mySubData,"^",14)		//AccPD_AccFI_DR
		continue:(myAccFIDR'="")
		set myPreType=$p(mySubData,"^",1)		//AccPD_Type
		continue:(myPreType="F")
		set mySum=$p(mySubData,"^",2)	   //AccPD_PreSum
		set myPreSum=$i(myPreSum, mySum)
	}
	
	//打印的发票金额汇总
	set myPaySum=0
	set myAPIRowID=0
	while($o(^DHCINVPRTAPi(0,"APIM",AccRowID,myAPIRowID))) {
		set myAPIRowID=$o(^DHCINVPRTAPi(0,"APIM",AccRowID,myAPIRowID))
		set myAPIData=$g(^DHCINVPRTAP(myAPIRowID))
		set myAccFIDR=$p(myAPIData,"^",24)		//API_AccFI_DR
		continue:(myAccFIDR'="")
		set mySum=$p(myAPIData,"^",16)			//API_SelfPatPay
		set myPaySum=$i(myPaySum, mySum)
	}
			
	//>0  收款
	set myType=$s((myRefSum>0):"P",1:"R")
		
	&SQL(
		INSERT INTO DHC_AccFootInfo (
			AccFI_ParRef, AccFI_PAPMI_DR, AccFI_PreSum, AccFI_Type, AccFI_RefPreSum,
			AccFI_Date, AccFI_Time, AccFI_User_DR, AccFI_PaySum
		)
		VALUES (
			:AccRowID, :myPAPMIDR, :myPreSum, :myType, :myRefSum,
			CONVERT(DATE, NOW()), CONVERT(TIME, NOW()), :UserDR, :myPaySum
		)
	)
	set rtn=SQLCODE
	if (+rtn) quit rtn_"^"_$g(%msg)
	
	set myAccFIRowID=$g(%ROWID)
	
	//Update
	set mySub=0
	while($o(^DHCACD("AccM",AccRowID,"AccPD",mySub))) {
		set mySub=$o(^DHCACD("AccM",AccRowID,"AccPD",mySub))
		set myAccPreRowID=AccRowID_"||"_mySub
		set mySubData=$g(^DHCACD("AccM",AccRowID,"AccPD",mySub))
		continue:(mySubData="")
		set myAccFIDR=$p(mySubData,"^",14)		//AccPD_AccFI_DR
		continue:(myAccFIDR'="")
		set myPreType=$p(mySubData,"^",1)		//AccPD_Type
		continue:(myPreType="F")
		&SQL(
			UPDATE DHC_AccPreDeposit
			SET AccPD_AccFI_DR = :myAccFIRowID
			WHERE %ID = :myAccPreRowID
		)
		set rtn=SQLCODE
		if (+rtn) {
			set rtn=rtn_"^"_$g(%msg)
			quit
		}
	}
	if (+rtn) quit rtn
	
	set myAPIRowID=0
	while($o(^DHCINVPRTAPi(0,"APIM",AccRowID,myAPIRowID))) {
		set myAPIRowID=$o(^DHCINVPRTAPi(0,"APIM",AccRowID,myAPIRowID))
		set myAPIData=$g(^DHCINVPRTAP(myAPIRowID))
		set myAccFIDR=$p(myAPIData,"^",24)		//API_AccFI_DR
		continue:(myAccFIDR'="")
		&SQL(
			UPDATE DHC_AccPayINV
			SET API_AccFI_DR = :myAccFIRowID
			WHERE %ID = :myAPIRowID
		)
		set rtn=SQLCODE
		if (+rtn) {
			set rtn=rtn_"^"_$g(%msg)
			quit
		}
	}
	if (+rtn) quit rtn
	
	quit rtn
ERROR
	quit ..AppException()
}

Query CredTypelookup() As %SQLQuery(ROWSPEC = "Credtype:%String,Credtypeid:%String")
{
	SELECT CRT_code,CRT_rowid FROM DHC_CredType WHERE crt_active = 'Y'
}

/// Debug: w ##class(web.UDHCAccManageCLS).FootTest()
ClassMethod FootTest() As %String
{
	
	;s ^TMPAccFoot($j,1)=AccRowID_","_UserDR_","_BadPrice
	;s ^TMPAccFoot($j,"PDInfo")=PDInfo
	;s ^TMPAccFoot($j,"PDPMInfo")=PDPMInfo
	;s ^TMPAccFoot($j,"ExpStr")=ExpStr
	s myS="1180"
	s AccRowID=$p($g(^TMPAccFoot(myS,1)),",",1)
	s UserDR=$p($g(^TMPAccFoot(myS,1)),",",2)
	s BadPrice=$p($g(^TMPAccFoot(myS,1)),",",3)
	s PDInfo=$g(^TMPAccFoot(myS,"PDInfo"))
	s PDPMInfo=$g(^TMPAccFoot(myS,"PDPMInfo"))
	s ExpStr=$g(^TMPAccFoot(myS,"ExpStr"))
	
	w ##class(web.UDHCAccManageCLS).AccFootMan(AccRowID, UserDR, BadPrice, PDInfo, PDPMInfo, ExpStr)
	
	q 0
}

/// Creator: ZhYW
/// CreatDate: 2020-11-19
/// Description: 根据账户获取除门诊预交金之外的押金信息
/// Input: accM: DHC_AccManager.RowId
/// Return: 
/// Debug: w ##class(web.UDHCAccManageCLS).GetOtherPreDepInfo()
ClassMethod GetOtherPreDepInfo(accM As %String, langId As %String = "") As %String
{
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	set rtn=""
	quit:(+accM=0) rtn
	
	kill depAry
	set depTypeId=##class(web.UDHCAccAddDeposit).GetAccPreDepTypeId()
	
	set sub=0
	while($o(^DHCACD("AccM",accM,"AccPD",sub))) {
		set sub=$o(^DHCACD("AccM",accM,"AccPD",sub))
		set subData=$g(^DHCACD("AccM",accM,"AccPD",sub))
		continue:(subData="")
		set depTypeDR=$p(subData,"^",10)
		continue:(depTypeId=depTypeDR)
		set payAmt=$p(subData,"^",2)
		continue:(+payAmt=0)
		set depAry(depTypeDR)=$g(depAry(depTypeDR))+payAmt
	}
	
	set depTypeDR=0
	while($o(depAry(depTypeDR))) {
		set depTypeDR=$o(depAry(depTypeDR))
		set depSum=$fn(depAry(depTypeDR),"",2)
		continue:(+depSum=0)
		set depTypeDesc=$p($g(^ARC("ARCDT",depTypeDR)),"^",2)
		set depTypeDesc=##class(User.ARCDepType).GetTranByDesc("ARCDTDesc", depTypeDesc, langId)
		set str=depTypeDesc_"："_depSum_##class(websys.Translation).Get("", "元", langId)
		set rtn=$s((rtn=""):str,1:(rtn_"，"_str))
	}
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2023-04-07
/// Description: 根据患者获取账户信息ID  --  创建账户模式为"P"(按患者主索引建账户)时使用
/// Input: PatientId:PA_PatMas.RowId, HospId:CT_Hospital.RowId
/// Return: DHC_AccManager.RowId
/// Debug: w ##class(web.UDHCAccManageCLS).GetAccMRowIDByPAPMI(136, 2)
ClassMethod GetAccMRowIDByPAPMI(PatientId As %String, HospId As %String) As %String
{
	set AccMRowID=""
	quit:(PatientId="") AccMRowID
	
	set DefHospId=..GetAccMDefHospId(HospId)  //根据表结构登记的"门诊预交金账户管理"获取院区组ID

	set AccId=0
	while($o(^DHCACDi("AccM",0,"PAPMI",PatientId,AccId))) {
		set AccId=$o(^DHCACDi("AccM",0,"PAPMI",PatientId,AccId))
		set AccData=$g(^DHCACD("AccM",AccId))
	 	set ActiveFlag=$p(AccData,"^",13)
	 	continue:(ActiveFlag'="N")
	 	set HospDR=$p(AccData,"^",24)     //AccM_Hosp_DR
	 	continue:(HospDR'=DefHospId)
	 	set AccCreatMode=$p(AccData,"^",23)
	 	continue:(AccCreatMode'="P")      //过滤不是按患者主索引建的账户
	 	set AccMRowID=AccId
	 	quit
	}
	
	quit AccMRowID
}

/// Creator: ZhYW
/// CreatDate: 2022-12-05
/// Description: 根据卡获取账户ID -- 创建账户模式为"C"(按卡建账户)时使用
/// Input: PatientId:PA_PatMas.RowId, CardNo:卡号, CardTypeId:DHC_CardTypeDef.RowId, HospId:CT_Hospital.RowId
/// Return: DHC_AccManager.RowId
/// Debug: w ##class(web.UDHCAccManageCLS).GetAccMRowIDByCard(136, "000000001", 2, 2)
ClassMethod GetAccMRowIDByCard(PatientId As %String, CardNo As %String, CardTypeId As %String, HospId As %String) As %String
{
	set AccMRowID=""
	quit:(PatientId="") AccMRowID
	
	set DefHospId=..GetAccMDefHospId(HospId)  //根据表结构登记的"门诊预交金账户管理"获取院区组ID
	
	set AccId=0
	while($o(^DHCACDi("AccM",0,"PAPMI",PatientId,AccId))) {
		set AccId=$o(^DHCACDi("AccM",0,"PAPMI",PatientId,AccId))
		set AccData=$g(^DHCACD("AccM",AccId))
	 	set ActiveFlag=$p(AccData,"^",13)
	 	continue:(ActiveFlag'="N")
	 	set HospDR=$p(AccData,"^",24)          //AccM_Hosp_DR
	 	continue:(HospDR'=DefHospId)
	 	set AccCreatMode=$p(AccData,"^",23)
	 	continue:(AccCreatMode'="C")           //过滤不是按卡建的账户
	 	set AccCardNo=$p(AccData,"^",4)        //AccM_CardNo
	 	continue:(AccCardNo'=CardNo)
	 	set AccCardTypeDR=$p(AccData,"^",22)   //AccM_CardTypeDR
	 	continue:(AccCardTypeDR'=CardTypeId)   //按卡类型过滤
	 	set AccMRowID=AccId
	 	quit
	}
	
	quit AccMRowID
}

/// Creator: ZhYW
/// CreatDate: 2023-04-07
/// Description: 根据表结构登记的"门诊预交金账户管理"获取院区组ID
/// Input: HospId:CT_Hospital.RowId
/// Return: CT_Hospital.RowId
/// Debug: w ##class(web.UDHCAccManageCLS).GetAccMDefHospId(2)
ClassMethod GetAccMDefHospId(HospId As %String) As %String
{
	quit ##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("Bill_OP_AccManager", HospId)  //根据表结构登记的"门诊预交金账户管理"获取院区组ID
}

/// Creator: ZhYW
/// CreatDate: 2023-04-07
/// Description: 获取门诊预交金账户ID
/// Input: cardNo:卡号, cardTypeId:DHC_CardTypeDef.RowId, patientId:PA_PatMas.RowId, hospId:CT_Hospital.RowId
/// Return: DHC_AccManager.RowId
/// Debug: w ##class(web.UDHCAccManageCLS).GetPatAccMRowID(2)
ClassMethod GetPatAccMRowID(cardNo As %String, cardTypeId As %String, patientId As %String, hospId As %String) As %String
{
	set accMRowId=""
	set accMCreatMode=$s((+cardTypeId'=0):$p($g(^DHCCARDTYPEDef(cardTypeId)),"^",45),1:"")   //获取卡类型配置的账户创建模式
	if (accMCreatMode="C") {
		set accMRowId=..GetAccMRowIDByCard(patientId, cardNo, cardTypeId, hospId)  //根据卡号获取账户ID
	}else {
		set accMRowId=..GetAccMRowIDByPAPMI(patientId, hospId)    //根据患者主索引获取账户信息ID
	}
	quit accMRowId
}

}
