Class web.UDHCAccPayINVEdit Extends BILL.COM.Abstract
{

/// Decription：根据发票号码获取账户支付的集中打印的发票
/// 新增标志：
///  增加一个查询重复账户标志，
///  如果当前发票的账户被结算，检测该患者是否存在有效账户为激活原来账户服务；
///  此处验证是否有对应的卡，
///   1. 如果卡没有收回，继续使用
///   2. 如果卡收回
/// Debug: w ##class(web.UDHCAccPayINVEdit).ReadAccINVByNo("0012928","5","2")
ClassMethod ReadAccINVByNo(INVNo As %String = "", UserDR As %String, HospId As %String) As %String
{
	s ^TMP("ReadAccINVByNo")=$lb(INVNo, UserDR, HospId)
	q:(INVNo="") "2602^^^^^^^^^^^^^^^^^^^^^^^"
	s rtn=0
	s myActCardFlag="N"
	
	s myBtnFlag=""
	s myAPIRowID=""
	s myPrtRowId=0
	f  s myPrtRowId=$o(^DHCINVPRTAPi(0,"INVNo",INVNo,myPrtRowId))  q:((myPrtRowId="")||(myAPIRowID'=""))  d
	.s myHospDR=$p($g(^DHCINVPRTAP(myPrtRowId)),"^",30)
	.q:(myHospDR'=HospId)
	.s myAPIRowID=myPrtRowId
	s myrtn=0
	i (myAPIRowID="") s myrtn=..ReadAccINVByNo1(INVNo, UserDR, HospId)
	q:((myAPIRowID="")&&(myrtn'=0)) myrtn
	;q:(myAPIRowID="") "2602^^^^^^^^^^^^^^^^^^^^^^^^"
	
	s InsTypeId=""
	s myACPRowID=0
	f  s myACPRowID=$o(^DHCINVPRTCAPi(0,"APINVDR",myAPIRowID,myACPRowID)) q:((myACPRowID="")||(InsTypeId'=""))  d
	.s myPRTRowID=$p($g(^DHCINVPRTCAP(myACPRowID)),"^",1)
	.s InsTypeId=$p($g(^DHCINVPRT(myPRTRowID)),"^",9)
	s Admsource=$s((+InsTypeId'=0):$p($g(^PAC("ADMREA",InsTypeId)),"^",9),1:"")

	s PRTAcount=+$p($g(^DHCINVPRTAP(myAPIRowID)),"^",1)
	s PRTAcount=$fn(PRTAcount,"",2)
	s myAmount=+$p($g(^DHCINVPRTAP(myAPIRowID)),"^",13)  //API_PatientShare
	s myAmount=$fn(myAmount,"",2)
	s flag=$p($g(^DHCINVPRTAP(myAPIRowID)),"^",2)
	s PRTAcount=$p($g(^DHCINVPRTAP(myAPIRowID)),"^",1)
	//s PRTPatPay=$p($g(^DHCINVPRTAP(myAPIRowID)),"^",16)
	s AutoFlag=+$p($g(^DHCINVPRTAP(myAPIRowID)),"^",25)   //API_AutoYBFlag
	s PRTUsr=$p($g(^DHCINVPRTAP(myAPIRowID)),"^",5)
	s UserNo=$p($g(^SSU("SSUSR",PRTUsr)),"^",1)
	s PapmiDR=$p($g(^DHCINVPRTAP(myAPIRowID)),"^",11)
	s PapmiNo=$p($g(^PAPER(PapmiDR,"PAT",1)),"^",2)
	s PapmiName=$p($g(^PAPER(PapmiDR,"ALL")),"^",1)
	s SexDR=$p($g(^PAPER(PapmiDR,"ALL")),"^",7)
	s Sex=$p(^CT("SEX",SexDR),"^",2)
	s INVRepDR=$p($g(^DHCINVPRTAP(myAPIRowID)),"^",20)
	
	s SOPFConfig=##class(web.DHCOPConfig).GetOPBaseConfig(HospId)
	s myConAppFlag=$p(SOPFConfig,"^",12)			;OPFC_AppFlag
	
	;判断退费方式
	i ((UserDR=PRTUsr)&&(INVRepDR="")) d
	.;作废
	.s myBtnFlag="P"
	e  d
	.;判断红冲,循环查看是否有小票审批过
	.s myACPRowID=""
	.s myARFlag=""
	.f  s myACPRowID=$o(^DHCINVPRTCAPi(0,"APINVDR",myAPIRowID,myACPRowID)) q:((myACPRowID="")||(myARFlag="Y"))  d
	..s myPRTRowID=$p($g(^DHCINVPRTCAP(myACPRowID)),"^",1)
	..s myARFlag=$p($g(^DHCINVPRT(myPRTRowID)),"^",22)
	..s myBtnFlag="S"
	
	s myAccStatus="N"							;账户状态
	s myAccNo=""
	s myAccLeft=0
	s myAccDr=$p($g(^DHCINVPRTAP(myAPIRowID)),"^",12)
	i (myAccDr="")  d
	.s myACPRowID=$o(^DHCINVPRTCAPi(0,"APINVDR",myAPIRowID,""))
	.q:(+myACPRowID=0)
	.s myPRTRowID=$p($g(^DHCINVPRTCAP(myACPRowID)),"^",1)
	.q:(+myPRTRowID=0)
	.s paysub=$o(^DHCINVPRT(myPRTRowID,"P",0))
	.q:(+paysub=0)
	.s myAccDr=+$p(^DHCINVPRT(myPRTRowID,"P",paysub),"^",8)
	
	i (myAccDr'=0) d
	.s myAccStatus=$p(^DHCACD("AccM",myAccDr),"^",13)	   ;AccM_AccStatus
	.s myAccNo=$p(^DHCACD("AccM",myAccDr),"^",1)		   ;AccM_AccountNo
	.s myAccLeft=$p(^DHCACD("AccM",myAccDr),"^",8)		   ;AccM_Balance
	s myAccLeft=$fn(myAccLeft,"",2)
	
	i (myAccStatus="N") d
	.s myAccSDesc="正常"

	i (myAccStatus="F") d
	.s myAccSDesc="结算"
	
	i (myAccStatus="S") d
	.s myAccSDesc="挂起"
	
	;增加一个账户标志
	;账户已经结算不能办理退费，只有办理完账户再退费
	
	;下面判断帐户的支付模式，找关联表
	s myINVPayMDR=$o(^CT("CTPM",0,"Code","CPP",0))
	s myCashPMDR=$o(^CT("CTPM",0,"Code","CASH",0))
	i (myAccStatus'="N") d
	.s myINVPayMDR=myCashPMDR
	
	s myPatSelfPay=$p($g(^DHCINVPRTAP(myAPIRowID)),"^",16)		;API_SelfPatPay
	s myPatSelfPay=$fn(myPatSelfPay,"",2)
	s myYBPaySum=$p($g(^DHCINVPRTAP(myAPIRowID)),"^",17)		;API_SelfYBPay
	s myYBPaySum=$fn(myYBPaySum,"",2)
	s myRefundSum=$p($g(^DHCINVPRTAP(myAPIRowID)),"^",18)		;API_RefundSum
	s myRefundSum=$fn(myRefundSum,"",2)

	;暂时使用
	;s myBtnFlag="P"
	
	;发票状态
	s myINVFlag=$p($g(^DHCINVPRTAP(myAPIRowID)),"^",2)			;API_Flag
	i (myINVFlag'="N") d
	.s myBtnFlag=""
	
	s myInsDivDR=$p($g(^DHCINVPRTAP(myAPIRowID)),"^",19)			;API_InsDiv_DR
	
	;如果当前的账户无效,查看是否存在其他有效的账户不数值传出
	
	s myNFAccStatus=""
	i (myAccStatus="F")&&(PapmiDR'="") d
	.;^DHCACDi("AccM",0,"PAPMI",{AccM_PAPMI_DR},{AccM_RowID})
	.s myNAccRowID=0
	.f  s myNAccRowID=$o(^DHCACDi("AccM",0,"PAPMI",PapmiDR, myNAccRowID))  q:((myNAccRowID="")||(myNFAccStatus="N"))  d
	..s myNFAccStatus=$p(^DHCACD("AccM",myNAccRowID),"^",13)	;

	s CardRowID=""
	s myCardNo=""
	s myCardTypeDR=""
	s myActCardFlag="N"
	i (myAccDr'=0)  d
	.s myOldCardRowID=0
	.f  s myOldCardRowID=$o(^DHCCARDi("CF",0,"AccNoDR",myAccDr,myOldCardRowID)) q:(myOldCardRowID="")!(myActCardFlag="Y")  d
	..s myActCardFlag=$p(^DHCCARD("CF",myOldCardRowID),"^",10)		;CF_ActiveFlag
	..q:(myActCardFlag'="N")
	..s myCardTypeDR=$p(^DHCCARD("CF",myOldCardRowID),"^",16)
	..s CardRowID=myOldCardRowID
	..s myCardNo=$p(^DHCCARD("CF",myOldCardRowID),"^",2)
	..s myActCardFlag="Y"
	
	;按照卡类型检索
	i (myActCardFlag'="Y") {
		s myAllCardTypeDR=0
		f  s myAllCardTypeDR=$o(^DHCCARDTYPEDef(myAllCardTypeDR))  q:((myAllCardTypeDR="")!(myActCardFlag="Y"))  d
		.s myCardAccRelation=$p(^DHCCARDTYPEDef(myAllCardTypeDR),"^",24)
		.q:(myCardAccRelation="N")
		.s myOldCardRowID=0
		.f  s myOldCardRowID=$o(^DHCCARDi("CF",0, "PAPMICTDR",PapmiDR,myAllCardTypeDR,myOldCardRowID))  q:((myOldCardRowID="")!(myActCardFlag="Y"))  d
		..s myActCardFlag=$p(^DHCCARD("CF",myOldCardRowID),"^",10)		;CF_ActiveFlag
		..q:(myActCardFlag'="N")
		..s myCardTypeDR=$p(^DHCCARD("CF",myOldCardRowID),"^",16)
		..s CardRowID=myOldCardRowID
		..s myCardNo=$p(^DHCCARD("CF",myOldCardRowID),"^",2)
		..s myActCardFlag="Y"
		
	}
	//判断集中打印发票退费是否需要先撤销集中打印发票  add zhli  17.12.9
	s APIFlag=##class(web.udhcOPQUERYExp).CheckWriteOffAPI(myAPIRowID)
		
	s myINVInfo=INVNo_"^"_PapmiNo_"^"_PapmiName_"^"_Sex_"^"_myAmount_"^"_myBtnFlag_"^"_myAccNo
	s myINVInfo=myINVInfo_"^"_myAccLeft_"^"_myAccDr_"^"_myAccStatus_"^"_myINVPayMDR
	s myINVInfo=myINVInfo_"^"_myYBPaySum_"^"_myAccSDesc_"^"_myAPIRowID
	s myINVInfo=myINVInfo_"^"_myINVFlag
	s myINVInfo=myINVInfo_"^"_myPatSelfPay
	s myINVInfo=myINVInfo_"^"_myInsDivDR
	;增加一个查询重复账户标志
	s myINVInfo=myINVInfo_"^"_myNFAccStatus
	s myINVInfo=myINVInfo_"^"_PapmiDR
	;患者是否有有效卡,支持账户
	s myINVInfo=myINVInfo_"^"_myActCardFlag		;有效卡标志=Y  否则 =N  20
	s myINVInfo=myINVInfo_"^"_myCardTypeDR		;卡类型    21
	s myINVInfo=myINVInfo_"^"_CardRowID			;卡RowID   22
	s myINVInfo=myINVInfo_"^"_myCardNo			;卡号      23
	s myINVInfo=myINVInfo_"^"_InsTypeId			;收费类别  24
	;add hujunbin 14.12.5 
	s myINVInfo=myINVInfo_"^"_Admsource      ;25
    s myINVInfo=myINVInfo_"^"_AutoFlag			 ;26
    s myINVInfo=myINVInfo_"^"_APIFlag			 ;27
	q rtn_"^"_myINVInfo
}

/// 根据发票号码获取账户支付的在收费处直接打印的发票
/// 新增标志：
/// 增加一个查询重复账户标志，
/// 如果当前发票的账户被结算，检测该患者是否存在有效账户为激活原来账户服务；
/// 此处验证是否有对应的卡，
///  1. 如果卡没有收回，继续使用
///  2. 如果卡收回
/// Debug: w ##class(web.UDHCAccPayINVEdit).ReadAccINVByNo1("211847","17275","2")
ClassMethod ReadAccINVByNo1(INVNo As %String, UserId As %String, HospId As %String) As %String
{
	set ^TMP("ReadAccINVByNo1")=$lb(INVNo, UserId, HospId)
	set myrtn="2602^^^^^^^^^^^^^^^^^^^^^^^"
	quit:(INVNo="") myrtn
	set rtn=0
	set myBtnFlag=""
	
	set myInvRowID=""
	set myPrtRowId=0
	while($o(^DHCINVPRT(0,"INV",INVNo,myPrtRowId))) {
		set myPrtRowId=$o(^DHCINVPRT(0,"INV",INVNo,myPrtRowId))
		set myHospDR=$p($g(^DHCINVPRT(myPrtRowId)),"^",39)
		continue:(myHospDR'=HospId)
		set myInvRowID=myPrtRowId
		quit
	}
	quit:(myInvRowID="") myrtn
	
	set PRTAcount=$p($g(^DHCINVPRT(myInvRowID)),"^",1)
	set PRTAcount=$fn(PRTAcount,"",2)
	set myAmount=+$p($g(^DHCINVPRT(myInvRowID)),"^",16)     //PRT_PatientShare
	set myAmount=$fn(myAmount,"",2)
	set flag=$p($g(^DHCINVPRT(myInvRowID)),"^",8)
	
	set InsTypeId=$p($g(^DHCINVPRT(myInvRowID)),"^",9)
	set PRTUsr=$p($g(^DHCINVPRT(myInvRowID)),"^",21)
	set UserNo=$p($g(^SSU("SSUSR",PRTUsr)),"^",1)
	set PapmiDR=$p($g(^DHCINVPRT(myInvRowID)),"^",15)
	set PapmiNo=$p($g(^PAPER(PapmiDR,"PAT",1)),"^",2)
	set PapmiName=$p($g(^PAPER(PapmiDR,"ALL")),"^",1)
	set SexDR=$p($g(^PAPER(PapmiDR,"ALL")),"^",7)
	set Sex=$p(^CT("SEX",SexDR),"^",2)
	set INVRepDR=$p($g(^DHCINVPRT(myInvRowID)),"^",6)
	
	set SOPFConfig=##class(web.DHCOPConfig).GetOPBaseConfig(HospId)
	set myConAppFlag=$p(SOPFConfig,"^",12)			//OPFC_AppFlag
	//判断退费方式
	if ((UserId=PRTUsr)&&(INVRepDR="")) {
		//作废
		set myBtnFlag="P"
	}else {
		set myBtnFlag="S"
	}
	//发票状态
	set myINVFlag=$p($g(^DHCINVPRT(myInvRowID)),"^",8)
	if (myINVFlag'="N") {
		set myBtnFlag=""
	}
	
	set myAccStatus="F"				//账户状态
	set myAccNo=""
	set myAccLeft=0
	set myAccDr=$o(^DHCACDi("AccM",0,"InvPrtDR","OP",myInvRowID,0))
	if (myAccDr'="") {
		set myAccStatus=$p(^DHCACD("AccM",myAccDr),"^",13)		;AccM_AccStatus
		set myAccNo=$p(^DHCACD("AccM",myAccDr),"^",1)		    ;AccM_AccountNo
		set myAccLeft=$p(^DHCACD("AccM",myAccDr),"^",8)		    ;AccM_Balance
	}
	set myAccLeft=$fn(myAccLeft,"",2)
	
	//账户已经结算不能办理退费，只有办理完账户再退费
	if (myAccStatus="N") {
		set myAccSDesc="正常"
	}
	if (myAccStatus="F") {
		set myAccSDesc="结算"
	}
	if (myAccStatus="S") {
		set myAccSDesc="挂起"
	}
	
	//下面判断账户的支付模式，找关联表
	set myINVPayMDR=$o(^CT("CTPM",0,"Code","CPP",0))
	set myCashPMDR=$o(^CT("CTPM",0,"Code","CASH",0))
	if (myAccStatus'="N") {
		set myINVPayMDR=myCashPMDR
	}
	set myYBPaySum=$p($g(^DHCINVPRT(myInvRowID)),"^",31)		;PRT_YBPaySum
	set myYBPaySum=$fn(myYBPaySum,"",2)
	set myPatSelfPay=$fn((myAmount-myYBPaySum),"",2)
	set myRefundSum=0                                         ;API_RefundSum
	set myRefundSum=$fn(myRefundSum,"",2)
		
	set myInsDivDR=$p($g(^DHCINVPRT(myInvRowID)),"^",30)			;API_InsDiv_DR
	
	//如果当前的账户无效，查看是否存在其他有效的账户不数值传出
	set myNFAccStatus=myAccStatus
	
	set CardRowID=""
	set myCardNo=""
	set myCardTypeDR=""
	set myActCardFlag="N"
	if (myAccDr'="") {
		set myOldCardRowID=0
		while($o(^DHCCARDi("CF",0,"AccNoDR",myAccDr,myOldCardRowID))) {
			set myOldCardRowID=$o(^DHCCARDi("CF",0,"AccNoDR",myAccDr,myOldCardRowID))
			set myActCardFlag=$p(^DHCCARD("CF",myOldCardRowID),"^",10)		//CF_ActiveFlag
			continue:(myActCardFlag'="N")
			set myCardTypeDR=$p(^DHCCARD("CF",myOldCardRowID),"^",16)
			set CardRowID=myOldCardRowID
			set myCardNo=$p(^DHCCARD("CF",myOldCardRowID),"^",2)
			set myActCardFlag="Y"
			quit
		}
	}

	//按照卡类型检索
	if (myActCardFlag'="Y") {
		set myAllCardTypeDR=0
		while($o(^DHCCARDTYPEDef(myAllCardTypeDR))&&(myActCardFlag'="Y")) {
			set myAllCardTypeDR=$o(^DHCCARDTYPEDef(myAllCardTypeDR))
			set myCardAccRelation=$p(^DHCCARDTYPEDef(myAllCardTypeDR),"^",24)
			continue:(myCardAccRelation="N")
			set myOldCardRowID=0
			while($o(^DHCCARDi("CF",0,"PAPMICTDR",PapmiDR,myAllCardTypeDR,myOldCardRowID))) {
				set myOldCardRowID=$o(^DHCCARDi("CF",0,"PAPMICTDR",PapmiDR,myAllCardTypeDR,myOldCardRowID))
				set myActCardFlag=$p(^DHCCARD("CF",myOldCardRowID),"^",10)		//CF_ActiveFlag
				continue:(myActCardFlag'="N")
				set myCardTypeDR=$p(^DHCCARD("CF",myOldCardRowID),"^",16)
				set CardRowID=myOldCardRowID
				set myCardNo=$p(^DHCCARD("CF",myOldCardRowID),"^",2)
				set myActCardFlag="Y"
				quit
			}
		}
	}

	set myINVInfo=INVNo_"^"_PapmiNo_"^"_PapmiName_"^"_Sex_"^"_myAmount_"^"_myBtnFlag_"^"_myAccNo
	set myINVInfo=myINVInfo_"^"_myAccLeft_"^"_myAccDr_"^"_myAccStatus_"^"_myINVPayMDR
	set myINVInfo=myINVInfo_"^"_myYBPaySum_"^"_myAccSDesc_"^"_myInvRowID
	set myINVInfo=myINVInfo_"^"_myINVFlag
	set myINVInfo=myINVInfo_"^"_myPatSelfPay
	set myINVInfo=myINVInfo_"^"_myInsDivDR
	;增加一个查询重复账户标志
	set myINVInfo=myINVInfo_"^"_myNFAccStatus
	set myINVInfo=myINVInfo_"^"_PapmiDR
	;患者是否有有效卡,支持账户
	set myINVInfo=myINVInfo_"^"_myActCardFlag		;有效卡标志=Y  否则 =N  20
	set myINVInfo=myINVInfo_"^"_myCardTypeDR		;卡类型    21
	set myINVInfo=myINVInfo_"^"_CardRowID			;卡RowID   22
	set myINVInfo=myINVInfo_"^"_myCardNo			;卡号      23
	set myINVInfo=myINVInfo_"^"_InsTypeId			;收费类别  24
	
	quit rtn_"^"_myINVInfo
}

/// Creator: ZhYW
/// CreatDate: 2017-06-07
/// Description: 通过集中打印发票号查询发票信息
/// Input: INVNo: DHC_AccPayINV.API_INVNo, UserDR:SS_User.RowID, HospId:CT_Hospital.RowID
/// Return: 
/// Debug: w ##class(web.UDHCAccPayINVEdit).ReadAccPayINVByNo("ZY100001045","5","2")
ClassMethod ReadAccPayINVByNo(INVNo As %String, UserDR As %String, HospId As %String, LangId As %String = "") As %String
{
	set ^TMP("ReadAccPayINVByNo")=$lb(INVNo, UserDR, HospId, LangId)
	
	if (LangId="")&&($d(%session)) {
	    set LangId=%session.Get("LOGON.LANGID")
	}
	
	quit:(INVNo="") "2602^^^^^^^^^^^^^^^^^^^^^^^"
	
	set rtn=0
	set myActCardFlag="N"
	
	set myBtnFlag=""
	set myAPIRowID=""
	set myPrtRowId=0
	while($o(^DHCINVPRTAPi(0,"INVNo",INVNo,myPrtRowId))&&(myAPIRowID="")) {
		set myPrtRowId=$o(^DHCINVPRTAPi(0,"INVNo",INVNo,myPrtRowId))
		set myHospDR=$p($g(^DHCINVPRTAP(myPrtRowId)),"^",30)
		continue:(myHospDR'=HospId)
		set myAPIRowID=myPrtRowId
	}
	quit:(+myAPIRowID=0) "2602^^^^^^^^^^^^^^^^^^^^^^^^"
	
	set InsTypeId=$p($g(^DHCINVPRTAP(myAPIRowID)),"^",31)	
	set myAdmSource=$s((+InsTypeId'=0):$p($g(^PAC("ADMREA",InsTypeId)),"^",9),1:"")
	set PRTAcount=$p($g(^DHCINVPRTAP(myAPIRowID)),"^",1)
	set PRTAcount=$fn(PRTAcount,"",2)
	//set myAmount=+$p($g(^DHCINVPRTAP(myAPIRowID)),"^",1)
	set myAmount=+$p($g(^DHCINVPRTAP(myAPIRowID)),"^",13)   //API_PatientShare
	set myAmount=$fn(myAmount,"",2)
	set PRTUsr=$p($g(^DHCINVPRTAP(myAPIRowID)),"^",5)
	set UserNo=$p($g(^SSU("SSUSR",PRTUsr)),"^",1)
	set myAccDr=$p($g(^DHCINVPRTAP(myAPIRowID)),"^",12)
	set myAutoFlag=+$p($g(^DHCINVPRTAP(myAPIRowID)),"^",25)     //API_AutoYBFlag
	set PapmiDR=$p($g(^DHCINVPRTAP(myAPIRowID)),"^",11)
	set PapmiNo=$p($g(^PAPER(PapmiDR,"PAT",1)),"^",2)
	set PapmiName=$p($g(^PAPER(PapmiDR,"ALL")),"^",1)
	set SexDR=$p($g(^PAPER(PapmiDR,"ALL")),"^",7)
	set Sex=$p(^CT("SEX",SexDR),"^",2)
	set Sex=##class(User.CTSex).GetTranByDesc("CTSEXDesc", Sex, LangId)
	set INVRepDR=$p($g(^DHCINVPRTAP(myAPIRowID)),"^",20)
	//判断退费方式
	set myInsDivDR=$p($g(^DHCINVPRTAP(myAPIRowID)),"^",19)			//API_InsDiv_DR
	if ((UserDR=PRTUsr)&&(INVRepDR="")) {
		set myBtnFlag="P"
	}else {
		set myBtnFlag="S"
	}
	//集中打印发票时医保分解的, 需要验证医嘱审核状态
	if ((+myInsDivDR'=0)&&(myAutoFlag'=1)) {
		set count=0
		set rset=##class(%ResultSet).%New("web.DHCOPBillRefund:FindOrdItm")
		set rs=rset.Execute(myAPIRowID_":"_"API")
		while (rset.Next()&&(count=0)) {
			set disabled=rset.Data("disabled")
			set auditFlag=rset.Data("auditFlag")
			if (auditFlag="Y") {
				set count=$i(count)
			}
		}
		if (+count=0) {
			set myBtnFlag=""
		}
	}
	//下面判断帐户的支付模式,找关联表
	set myINVPayMDR=$o(^CT("CTPM",0,"Code","CASH",0))
	set myAccPayMSub=0
	while($o(^DHCINVPRTAP(myAPIRowID,"P",myAccPayMSub))) {
		set myAccPayMSub=$o(^DHCINVPRTAP(myAPIRowID,"P",myAccPayMSub))
		set paymode=$p(^DHCINVPRTAP(myAPIRowID,"P",myAccPayMSub),"^",1)
		set paymCode=$p(^CT("CTPM",paymode),"^",1)
		continue:((paymCode["YB")||(paymCode["INSU"))
		set myINVPayMDR=paymode
	}
	
	set myINVPayMCode=$p(^CT("CTPM",myINVPayMDR),"^",1)
	set myAccStatus=""
	//CPP 支付需要验证账户状态
	if (myINVPayMCode="CPP") {
		set myAccStatus="F"							//账户状态
	}
	set myAccNo=""
	set myAccLeft=0
	if (myAccDr'="") {
		set myAccStatus=$p(^DHCACD("AccM",myAccDr),"^",13)	   //AccM_AccStatus
		set myAccNo=$p(^DHCACD("AccM",myAccDr),"^",1)		   //AccM_AccountNo
		set myAccLeft=$p(^DHCACD("AccM",myAccDr),"^",8)		   //AccM_Balance
	}
	set myAccLeft=$fn(myAccLeft,"",2)
	
	set myAccSDesc=""
	if (myAccStatus="N") {
		set myAccSDesc="正常"
	}
	if (myAccStatus="F") {
		set myAccSDesc="结算"
	}
	if (myAccStatus="S") {
		set myAccSDesc="挂起"
	}
	set myAccSDesc=##class(websys.Translation).Get("", myAccSDesc, LangId)
	
	set myPatSelfPay=$p($g(^DHCINVPRTAP(myAPIRowID)),"^",16)	//API_SelfPatPay
	set myPatSelfPay=$fn(myPatSelfPay,"",2)
	set myYBPaySum=$p($g(^DHCINVPRTAP(myAPIRowID)),"^",17)		//API_SelfYBPay
	set myYBPaySum=$fn(myYBPaySum,"",2)
	set myRefundSum=$p($g(^DHCINVPRTAP(myAPIRowID)),"^",18)		//API_RefundSum
	set myRefundSum=$fn(myRefundSum,"",2)
	//发票状态
	set myINVFlag=$p($g(^DHCINVPRTAP(myAPIRowID)),"^",2)		    //API_Flag
	if (myINVFlag'="N") {
		set myBtnFlag=""
	}
	
	set myINVInfo=INVNo_"^"_PapmiNo_"^"_PapmiName_"^"_Sex_"^"_myAmount_"^"_myBtnFlag_"^"_myAccNo
	set myINVInfo=myINVInfo_"^"_myAccLeft_"^"_myAccDr_"^"_myAccStatus_"^"_myINVPayMDR
	set myINVInfo=myINVInfo_"^"_myYBPaySum_"^"_myAccSDesc_"^"_myAPIRowID
	set myINVInfo=myINVInfo_"^"_myINVFlag
	set myINVInfo=myINVInfo_"^"_myPatSelfPay
	set myINVInfo=myINVInfo_"^"_myInsDivDR
	set myINVInfo=myINVInfo_"^"_PapmiDR
	set myINVInfo=myINVInfo_"^"_InsTypeId
	set myINVInfo=myINVInfo_"^"_myAdmSource
	quit rtn_"^"_myINVInfo
}

}
