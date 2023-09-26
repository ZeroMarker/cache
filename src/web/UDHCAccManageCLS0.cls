Class web.UDHCAccManageCLS0 Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 107;

ClassMethod AccCallBack(AccRowID As %String, UserDR As %String, CardInfo As %String, CompIP As %String, ExpStr As %String) As %String
{
	;原则：账户的复原
	;AccRowID  :原账户RowID
	;CardInfo  ：新发卡的信息
	;CompIP    ：计算机名称
	;ExpStr    ：
	;w ##class(web.UDHCAccManageCLS0).AccCallBack(AccRowID, UserDR, CardInfo, CompIP, ExpStr)
	;1.结算账户复原，使账户能够重新使用
	;2.重新发卡，因为原来的卡已经回收；
	;2.1 如果卡被收回这个逻辑是对的
	;退完费用后，操作员重新
	n (AccRowID, UserDR, CardInfo, CompIP, ExpStr)
	
	tstart
	
	;更新账户状态，使账户信息Foot状态-->正常状态
	s myExpStr=""
	s rtn=##class(web.UDHCAccManageCLS).AccCallBack(AccRowID, UserDR, myExpStr)
	
	;写入账户日志
	;(accid As %String, oldstatus As %String, newstatus As %String, userid As %String, IP As %String, RLinfo As %String)
	i +rtn=0 d
	.s rtn=##class(web.UDHCAccManageCLS).AccountStatusRecord(AccRowID,"结算","正常",UserDR,CompIP,"")
	
	i +rtn=0 d
	.;需要原账户新卡的信息
	.s rtn=##Class(web.UDHCAccCardManage0).grantcardNEW(CardInfo)
	.s ren=$p(rtn,"^",1),securityno=$p(rtn,"^",2)
	.s myCardRowID=$p(rtn,"^",3)

	;CardUpdate
	i +rtn=0 d
	.s rtn=##class(web.UDHCAccManageCLS).CardUpdate(myCardRowID, AccRowID)
	
	b	;;;Tro
	i +rtn=0 d
	.tc
	e  d
	.trollback
	
	q rtn_$c(2)_""
}

ClassMethod GetAccInfoByPAPMI111(CardNO As %String, PAPMINO As %String, AdmStr As %String) As %String
{
	;w ##class(web.UDHCAccManageCLS0).GetAccInfoByPAPMI("004350","00002001","")
	;得到帐户信息，通过卡号，登记号，还有AdmStr
	;此处的前提是卡已经有效，此处不在判断卡是否有效
	n (CardNO, PAPMINO, AdmStr)
	;^DHCACDi("AccM",0,"PAPMI",{AccM_PAPMI_DR},{AccM_RowID})
	
	s myrtn=0
	
	;^PAPERi("PAPMI_PatNo",$$ALPHAUP({PAPMI_No}),{PAPMI_RowId})
	q:((CardNO="")!(PAPMINO="")) "0^^^^^^^^^^^^^^^^^"
	
	;账户无效，返回-201
	s myrtn=-201
	s myAccType=""
	s myAccTypeDesc=""
	s myAccUsePrice=0			;账户的可用款
	;账户的余额
	;账户的限额
	
	s myPAPMIDR=$o(^PAPERi("PAPMI_PatNo",PAPMINO,0))
	s myAccRowID=0
	f  s myAccRowID=$o(^DHCACDi("AccM",0,"PAPMI",myPAPMIDR,myAccRowID)) q:((myAccRowID=""))  d
	.;^DHCACD("AccM",{AccM_RowID})
	.q:($d(^DHCACD("AccM",myAccRowID))=10)
	.s myAccStatus=$p(^DHCACD("AccM",myAccRowID),"^",13)		;AccM_AccStatus
	.s myCardNo=$p(^DHCACD("AccM",myAccRowID),"^",4)			;AccM_CardNo
	.b
	.q:(myAccStatus'="N")
	.s myCFRowID=0
	.s myFNCardFlag=0
	.f  s myCFRowID=$o(^DHCCARDi("CF",0,"AccNoDR",myAccRowID, myCFRowID)) q:((myCFRowID="")!(+myFNCardFlag=1))  d
	..s myCardNo=$p(^DHCCARD("CF",myCFRowID),"^",2)
	..s myCardActF=$p(^DHCCARD("CF",myCFRowID),"^",10)
	..i (myCardNo=CardNO)&(myCardActF="N") d
	...s myFNCardFlag=1
	.;q:(myCardNo'=CardNO)
	.q:(+myFNCardFlag=0)
	.;q:(myCardNo'=CardNO)
	.s myrtn=0
	.s Balance=$p(^DHCACD("AccM",myAccRowID),"^",8)
	.s DepPrice=##class(web.UDHCAccManageCLSIF).GetAccMDepPrice(myAccRowID, AdmStr,"")
	.s left=Balance-DepPrice
	.s myAccUsePrice=left
	.s myAccType=$p(^DHCACD("AccM",myAccRowID),"^",16)
	.i +DepPrice<0 d
	..s myAccType="S"		;处于担保状态
	.;s AccType=$p(^DHCACD("AccM",cfrowid),"^",16)
	.
	
	s myAccUsePrice=$fn(myAccUsePrice,"",2)
	i myAccType="P" {
		s myAccTypeDesc="账户"
	}elseif(myAccType="S"){
		s myAccTypeDesc="担保"
	}else{
		s myAccTypeDesc="集体"
	}
	
	s myAccInfo=myrtn_"^"_myAccUsePrice_"^"_myAccTypeDesc_"^"_myAccType
	
	q myAccInfo
}

ClassMethod GetAccInfoByPAPMI(CardNO As %String, PAPMINO As %String, AdmStr As %String) As %String
{
	;w ##class(web.UDHCAccManageCLS0).GetAccInfoByPAPMI("004350","00002001","")
	;得到帐户信息，通过卡号，登记号，还有AdmStr
	;此处的前提是卡已经有效，此处不在判断卡是否有效
	n (CardNO, PAPMINO, AdmStr)
	;^DHCACDi("AccM",0,"PAPMI",{AccM_PAPMI_DR},{AccM_RowID})
	s ^tmpgetaccinfo=CardNO_"^"_PAPMINO_"^"_AdmStr_"*"_"OOO"
	s myrtn=0
	
	;^PAPERi("PAPMI_PatNo",$$ALPHAUP({PAPMI_No}),{PAPMI_RowId})
	q:((CardNO="")!(PAPMINO="")) "0^^^^^^^^^^^^^^^^^"
	
	;账户无效，返回-201
	s myrtn=-201
	s myAccType=""
	s myAccTypeDesc=""
	s myAccUsePrice=0			;账户的可用款
	;账户的余额
	;账户的限额
	
	s myPAPMIDR=$o(^PAPERi("PAPMI_PatNo",PAPMINO,0))
	s myAccRowID=0
	f  s myAccRowID=$o(^DHCACDi("AccM",0,"PAPMI",myPAPMIDR,myAccRowID)) q:((myAccRowID=""))  d
	.;^DHCACD("AccM",{AccM_RowID})
	.q:($d(^DHCACD("AccM",myAccRowID))=10)
	.s myAccStatus=$p(^DHCACD("AccM",myAccRowID),"^",13)		;AccM_AccStatus
	.s myCardNo=$p(^DHCACD("AccM",myAccRowID),"^",4)			;AccM_CardNo
	.b
	.q:(myAccStatus'="N")
	.s myCFRowID=0
	.s myFNCardFlag=0
	.f  s myCFRowID=$o(^DHCCARDi("CF",0,"AccNoDR",myAccRowID, myCFRowID)) q:((myCFRowID="")!(+myFNCardFlag=1))  d
	..s myCardNo=$p(^DHCCARD("CF",myCFRowID),"^",2)
	..s myCardActF=$p(^DHCCARD("CF",myCFRowID),"^",10)
	..i (myCardNo=CardNO)&(myCardActF="N") d
	...s myFNCardFlag=1
	.;q:(myCardNo'=CardNO)
	.q:(+myFNCardFlag=0)
	.;q:(myCardNo'=CardNO)
	.s myrtn=0
	.s Balance=$p(^DHCACD("AccM",myAccRowID),"^",8)
	.s DepPrice=##class(web.UDHCAccManageCLSIF).GetAccMDepPrice(myAccRowID, AdmStr,"")
	.s left=Balance-DepPrice
	.s myAccUsePrice=left
	.s myAccType=$p(^DHCACD("AccM",myAccRowID),"^",16)
	.i +DepPrice<0 d
	..s myAccType="S"		;处于担保状态
	.;s AccType=$p(^DHCACD("AccM",cfrowid),"^",16)
	.
	
	s myAccUsePrice=$fn(myAccUsePrice,"",2)
	i myAccType="P" {
		s myAccTypeDesc="账户"
	}elseif(myAccType="S"){
		s myAccTypeDesc="担保"
	}else{
		s myAccTypeDesc="集体"
	}
	s myAccInfo=$g(myrtn)_"^"_$g(myAccUsePrice)_"^"_$g(myAccTypeDesc)_"^"_$g(myAccType)
	b ;yyx 2010-07-05
	s myGAInfo=..GetGroupAccInfoByCardNo(myPAPMIDR, "", "")
	
	/*	if (+$p(myGAInfo,"^",1)=0){
			if ($p(myGAInfo,"^",5)="G"){
			   s $p(myAccInfo,"^",1)=$p(myGAInfo,"^",1)
			   s $p(myAccInfo,"^",2)=$p(myGAInfo,"^",2)
			   s $p(myAccInfo,"^",3)=$p(myGAInfo,"^",3)
			   s $p(myAccInfo,"^",4)=$p(myGAInfo,"^",4)
			}
		}
	*/
	
	q myAccInfo_"^"_myGAInfo
}

ClassMethod GetAccMDepPrice(AccRowID As %String, AdmStrInfo As %String) As %String
{
	n (AccRowID, AdmStrInfo)
	;w ##class(web.UDHCAccManageCLS0).GetAccMDepPrice("25","")
	
	;AdmStrInfo=Adm1^Adm2^adm3^adm4
	
	s myDPrice=0
	s myNBelong=0
	
	q:(AccRowID="") 0
	
	;^DHCACD("AccM",{AccM_RowID})
	q:('$d(^DHCACD("AccM",AccRowID))) 0
	
	s myARRBDate=$p($g(^DHCACD("AccM",AccRowID)),"^",19)
	s myARREDate=$p($g(^DHCACD("AccM",AccRowID)),"^",20)
	i (+$h>=+myARRBDate) d
	.q:(+$h>+myARREDate)&(myARREDate'="")
	.s myDPrice=$p($g(^DHCACD("AccM",AccRowID)),"^",14)
	
	;判断就诊科室是否授权
	s mylen=$l(AdmStrInfo,"^")
	f i=1:1:mylen  d
	.s myAdmRowID=$p(AdmStrInfo,"^",i)
	.q:(myAdmRowID="")
	.i '$d(^DHCWARRANT(0,"ADM",myAdmRowID)) d
	..s myNBelong=1
	
	i (+myNBelong=1) d
	.s myDPrice=0
	
	;对于透支采取上面的限制，而限支使用下面的
	i (+myNBelong=1) d
	.s mytmpprice=$p($g(^DHCACD("AccM",AccRowID)),"^",14)
	.i +mytmpprice>0 d
	..s myDPrice=+mytmpprice
	
	q myDPrice
}

ClassMethod ReadFootAccByINVNo(INVNo As %String, UserDR As %String) As %String
{
	n (INVNo, UserDR)
	
	s $ZT="ERROR^DHCSSERR"
	
	q:(INVNo="") "2602^^^^^^^^^^^^^^^^^^"
	s rtn=0
	s Refundflag=0
	s DHCINVPRTRDR=""
	
	;^DHCINVPRTAPi(0,"INVNo",{API_INVNo},{API_RowID})
	;^DHCINVPRTAP({API_RowID})
	s myBtnFlag=""
	s myAPIRowID=0
	s myAPIRowID=$o(^DHCINVPRTAPi(0,"INVNo",INVNo,myAPIRowID))
	q:(myAPIRowID="") "2602^^^^^^^^^^^^^^^^^^"
	
	s myAmount=+$p($g(^DHCINVPRTAP(myAPIRowID)),"^",1)
	s myAmount=$fn(myAmount,"",2)
	s flag=$p($g(^DHCINVPRTAP(myAPIRowID)),"^",2)
	s PRTAcount=$p($g(^DHCINVPRTAP(myAPIRowID)),"^",1)
	;s PRTPatPay=$p($g(^DHCINVPRTAP(myAPIRowID)),"^",16)
	s PRTUsr=$p($g(^DHCINVPRTAP(myAPIRowID)),"^",5)
	s UserNo=$p($g(^SSU("SSUSR",PRTUsr)),"^",1)
	s PrtPapmiDR=$p($g(^DHCINVPRTAP(myAPIRowID)),"^",11)
	s PapmiNo=$P($G(^PAPER(PrtPapmiDR,"PAT",1)),"^",2)
	s PapmiName=$P($G(^PAPER(PrtPapmiDR,"ALL")),"^",1)
	s PapmiSex=$P($G(^PAPER(PrtPapmiDR,"ALL")),"^",7)
	s PaSex=$p(^CT("SEX",PapmiSex),"^",2)
	s CheckUserDR=$p($g(^DHCINVPRTAP(myAPIRowID)),"^",9)
	s myCUserCode=""
	i (CheckUserDR'="") d
	.s myCUserCode=$p($g(^SSU("SSUSR",PRTUsr)),"^",1)

	s myConAppFlag=$p($g(^DHCSOPFCON(1)),"^",14)			;OPFC_AppFlag
	
	;判断退费方式
	i ((UserDR=PRTUsr)&&(CheckUserDR="")) d
	.;作废
	.s myBtnFlag="P"					;Park
	e  d
	.;判断红冲,循环查看是否有小票审批过
	.;^DHCINVPRTCAPi(0,"APINVDR",{ACP_APINV_DR},{ACP_RowID})
	.s myACPRowID=""
	.s myARFlag=""
	.f  s myACPRowID=$o(^DHCINVPRTCAPi(0,"APINVDR",myAPIRowID,myACPRowID)) q:((myACPRowID="")||(myARFlag="Y"))  d
	..s myPRTRowID=$p($g(^DHCINVPRTCAP(myACPRowID)),"^",1)
	..s myARFlag=$p($g(^DHCINVPRT(myPRTRowID)),"^",22)
	..s myrtn=##class(web.UDHCPRTOEAuthIF).ReadINVAuthFlag(myPRTRowID,"")
	..s myARFlag=$p(myrtn,"^",1)
	..i (myARFlag="Y") d
	...s myBtnFlag="S"					;Strike
	
	s myAccStatus="F"							;账户状态
	s myAccNo=""
	s myAccLeft=0
	s myAccDr=$p($g(^DHCINVPRTAP(myAPIRowID)),"^",12)
	i (myAccDr'="") d
	.s myAccStatus=$p(^DHCACD("AccM",myAccDr),"^",13)		;AccM_AccStatus
	.s myAccNo=$p(^DHCACD("AccM",myAccDr),"^",1)		;AccM_AccountNo
	.s myAccLeft=$p(^DHCACD("AccM",myAccDr),"^",8)		;AccM_Balance
	
	i (myAccStatus="N") d
	.s myAccSDesc="正常"

	i (myAccStatus="F") d
	.s myAccSDesc="结算"
	
	i (myAccStatus="S") d
	.s myAccSDesc="挂起"
	
	;增加一个账户标志
	;账户已经结算不能办理退费，只有办理完账户再退费
	s myASFlag=0
	i ((myAccStatus'="N")&(+rtn=0)) d
	.s rtn=-209
	
	;下面判断帐户的支付模式，找关联表
	s myINVPayMDR=$o(^CT("CTPM",0,"Code","CPP",0))
	s myCashPMDR=$o(^CT("CTPM",0,"Code","CASH",0))
	i (myAccStatus'="N") d
	.s myINVPayMDR=myCashPMDR
	
	s myPatSelfPay=$p($g(^DHCINVPRTAP(myAPIRowID)),"^",16)		;API_SelfPatPay
	s myYBPaySum=$p($g(^DHCINVPRTAP(myAPIRowID)),"^",17)		;API_SelfYBPay
	s myRefundSum=$p($g(^DHCINVPRTAP(myAPIRowID)),"^",18)		;API_RefundSum
	
	;发票状态，
	s myINVFlag=$p($g(^DHCINVPRTAP(myAPIRowID)),"^",2)			;API_Flag
	i (myINVFlag'="N") d
	.s myBtnFlag=""
	
	s myInsDivDR=$p($g(^DHCINVPRTAP(myAPIRowID)),"^",19)			;API_InsDiv_DR
	
	;暂时使用
	s myBtnFlag="P"
	
	s myINVInfo=INVNo_"^"_PapmiNo_"^"_PapmiName_"^"_PaSex_"^"_myAmount_"^"_myBtnFlag_"^"_myAccNo
	s myINVInfo=myINVInfo_"^"_myAccLeft_"^"_myAccDr_"^"_myAccStatus_"^"_myINVPayMDR
	s myINVInfo=myINVInfo_"^"_myYBPaySum_"^"_myAccSDesc_"^"_myAPIRowID
	s myINVInfo=myINVInfo_"^"_myINVFlag
	s myINVInfo=myINVInfo_"^"_myPatSelfPay
	s myINVInfo=myINVInfo_"^"_myInsDivDR
	
	q rtn_"^"_myINVInfo
}

ClassMethod getaccinfofromcardno(cardno As %Library.String, securityno As %Library.String, AdmStr As %String) As %Library.String
{
	n (cardno, securityno, AdmStr)
	q:cardno="" "-200^^^^^^^^"		;;无效卡标志
	
	s rtn=0
	
	s AccID="",AccNo="",left=0,Balance=0,DepPrice=0
	s Papmi=""
	s Pass=""
	s PAPMINo=""
	s myCardRowID=""
	s myACFlag=-200		;无效卡
	;个人账户
	;个人担保账户
	;集体账户
	s myAccType="P"		;账户类型，默认是个人的正常账户
	
	;逻辑：找到有效卡后，不应该在循环了
	;s dd=##class(web.UDHCCardInfoResume).AutoRepairSec(cardno,securityno)
	
	s mySecNoEncrypt=##class(web.UDHCAccEnrypt).Encrypt(securityno)
	s cardid="0"
	f  s cardid=$o(^DHCCARDi("CF",0,"CardNo",cardno,cardid)) q:((cardid="")!(myACFlag=0))  d
	.s ActiveFlag=$p(^DHCCARD("CF",cardid),"^",10)
	.q:ActiveFlag'="N"
	.;s CardID=cardid
	.s SecurityNO=$p(^DHCCARD("CF",cardid),"^",3)
	.q:SecurityNO'=mySecNoEncrypt			;securityno
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
	.s DepPrice=##class(web.UDHCAccManageCLSIF).GetAccMDepPrice(cfrowid, AdmStr,"")
	.s left=Balance-DepPrice
	.s myAccType=$p(^DHCACD("AccM",cfrowid),"^",16)
	.i +DepPrice<0 d
	..s myAccType="S"		;处于担保状态
	.;s AccType=$p(^DHCACD("AccM",cfrowid),"^",16)
	
	s rtn=myACFlag
	;卡有效，而账户无效返回-201
	i ((myACFlag=0)&&(AccID="")) d
	.s rtn=-201
	
	s str=rtn_"^"_AccID_"^"_AccNo_"^"_left_"^"_Balance_"^"_DepPrice_"^"_Pass
	s str=str_"^"_Papmi_"^"_PAPMINo_"^"_myCardRowID_"^"_myAccType
	
	q str
}

/// 根据卡号获取对应的集体账户信息
/// 根据PAPMI获取集体账户信息
ClassMethod GetGroupAccInfoByCardNo(PAPMIDR As %Library.String, AdmStr As %String, CheckSecurityFlag As %String) As %String
{
	n (PAPMIDR, AdmStr, CheckSecurityFlag, ExpStr)
	
	s myrtn="-220"
	s myGroupInfo=""
	
	;集体账户结算后，还可以办理账户
	
	s myAAccRowID=""
	s myAAccAccNo=""
	s myAAccleft=""
	s myAAccBalance=""
	s myAAccDepPrice=""
	s myAAccPass=""
	s myAAccType="C"
	
	;^DHCACDi("AccM",0,"GA","PAPMI",{AGA_PAPMI_DR},{DHC_AccManager.AccM_RowID},"A",{AGA_Sub})
	q:(PAPMIDR="") myGroupInfo
	s myGARowID=0
	f  s myGARowID=$o(^DHCACDi("AccM",0,"GA","PAPMI",PAPMIDR,myGARowID)) q:((myGARowID="")!(myAAccRowID'=""))  d
	.;^DHCACD("AccM",{AccM_RowID})
	.s AccStatus=$p(^DHCACD("AccM",myGARowID),"^",13)
	.q:(AccStatus'="N")
	.s myAAccRowID=myGARowID
	.s myAAccAccNo=$p(^DHCACD("AccM",myGARowID),"^",1)
	.s myAAccBalance=$p(^DHCACD("AccM",myGARowID),"^",8)
	.s myAAccPass=$p(^DHCACD("AccM",myGARowID),"^",12)
	.s myAAccDepPrice=$p(^DHCACD("AccM",myGARowID),"^",14)
	.s myAAccDepPrice=##class(web.UDHCAccManageCLSIF).GetAccMDepPrice(myGARowID, "","")
	.s myAAccleft=myAAccBalance-myAAccDepPrice
	.s myAAccType=$p(^DHCACD("AccM",myGARowID),"^",16)
	q:(myAAccRowID="") myrtn_"^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
	
	s mysub=$o(^DHCACDi("AccM",0,"GA","PAPMI",PAPMIDR,myAAccRowID,"A",0))
	
	s myrtn="-221"
	
	s myFlag=$p(^DHCACD("AccM",myAAccRowID,"A",mysub),"^",1)
	s myBeginDate=$p(^DHCACD("AccM",myAAccRowID,"A",mysub),"^",2)
	s myBeginTime=$p(^DHCACD("AccM",myAAccRowID,"A",mysub),"^",3)
	s myEndDate=$p(^DHCACD("AccM",myAAccRowID,"A",mysub),"^",4)
	s myEndTime=$p(^DHCACD("AccM",myAAccRowID,"A",mysub),"^",5)
	s myCurrentLimit=$p(^DHCACD("AccM",myAAccRowID,"A",mysub),"^",8)		;本次限额
	s myPrior=$p(^DHCACD("AccM",myAAccRowID,"A",mysub),"^",7)  ; 优先级

	if (myFlag="Y"){
		if ((myBeginDate="")!((myBeginDate'="")&&(myBeginDate<=+$h))){
			if ((myEndDate="")!((myEndDate'="")&&(+myEndDate>=+$h))){
				s myrtn=0
				if (+myCurrentLimit>0){
					s myAAccleft=+myCurrentLimit
				}
			}
		}
	}
	s myAccTypeDesc="集体"
    s myGroupInfo=$g(myrtn)_"^"_$g(myAAccleft)_"^"_$g(myAccTypeDesc)_"^"_$g(myAAccType)_"^"_$g(myPrior)
	;s myGroupInfo=myrtn_"^"_myAAccleft_"^"_myAAccAccNo_"^"_myAAccleft_"^"_myAAccBalance
	;s myGroupInfo=myGroupInfo_"^"_myAAccDepPrice_"^"_myAAccPass_"^^^^"_myAAccType_"^^^^^^^^^^^^^^^"
	
	q myGroupInfo
}

}
