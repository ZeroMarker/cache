Import sqluser

Class web.DHCOPBillReturnAbortCard Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

ClassMethod getaccinfofromcardnoforDT(cardno As %Library.String, securityno As %Library.String, ExpStr As %String) As %Library.String
{
	;AdmStr  患者的就诊 Adm号码
	;此处要区别对待一个索引问题
	;1. 按照卡号索引为主 检索患者信息和患者帐户信息
	;2. 以卡类型索引为主 检索患者的信息和账户信息
	
	;CheckSecurityFlag    验证校验码标志
	;=  "PatInfo"		只获取患者信息不获取账户信息
	;=  "ALL"			表示要求有验证
	;n (cardno, securityno, CardTypeDR, AdmStr, CheckSecurityFlag, ExpStr)
	s AdmStr=$p(ExpStr,$c(2),1)
	s CardTypeDR=$p(ExpStr,$c(2),2)
	s CheckSecurityFlag=$p(ExpStr,$c(2),3)
	s ExpStr=""
	q:((cardno="")) "-200^^^^^^^^"		;;无效卡标志
	;||(CardTypeDR="")
	s rtn=0
	d ..KillTMP()
	s AccID="",AccNo="",left=0,Balance=0,DepPrice=0
	s Papmi=""
	s Pass=""
	s PAPMINo=""
	s myCardRowID=""
	s myRtnCardTypeDR = ""
	s myACFlag=-200		;无效卡
	s mySelectCardTypeTip=""		;选择卡类型提示
	s PatName=""
	s ActiveFlag=""
	s myAccType="P"
	s mySecNoEncrypt=##class(web.UDHCAccEnrypt).Encrypt(securityno)
	i CardTypeDR="" d
	.s mySCMode="PC"
	e  d
	.s mySCMode=$p(^DHCCARDTYPEDef(CardTypeDR),"^",28)		;SearchCardNoMode

	i mySCMode="PC" d
	.;优先 卡号
	.;在不指定卡类型的情况下的优先级别
	.;如果数据有多条， 需要验证卡类型的RowID
	.s mycardid=0
	.f  s mycardid=$o(^DHCCARDi("CF",0,"CardNo",cardno,mycardid)) q:((mycardid=""))  d
	..s ActiveFlag=$p(^DHCCARD("CF",mycardid),"^",10)
	..i ActiveFlag="S"  s myACFlag="-1"  ;挂失
	..i ActiveFlag="R"  s myACFlag="-2"  ;回收
	..i ActiveFlag="N"  s myACFlag="-3"  ;正常
	..i ActiveFlag="D"  d 
	...s SecurityNO=$p(^DHCCARD("CF",mycardid),"^",3)
	...i SecurityNO=$c(0) s SecurityNO=""
	...q:((SecurityNO'=mySecNoEncrypt)&&(CheckSecurityFlag'="PatInfo"))			;securityno
	...s ^TMPAccCardIdx($j)=+$g(^TMPAccCardIdx($j))+1
	...s ^TMPAccCardIdx($j,"CardRowID",mycardid)=""
	e  d
	.; 默认方式
	.; 指定卡号和卡类型
	.; 此时要求必须唯一才成， 
	.s mycardid=0
	.f  s mycardid=$o(^DHCCARDi("CF",0,"CardTypeNo",CardTypeDR, cardno, mycardid)) q:(mycardid="")  d
	..s ActiveFlag=$p(^DHCCARD("CF",mycardid),"^",10)
	..i ActiveFlag="S"  s myACFlag="-1"  ;挂失
	..i ActiveFlag="R"  s myACFlag="-2"  ;回收
	..i ActiveFlag="N"  s myACFlag="-3"  ;正常
	..i ActiveFlag="D"  d
	...s SecurityNO=$p(^DHCCARD("CF",mycardid),"^",3)
	...i SecurityNO=$c(0) s SecurityNO=""
	...q:((SecurityNO'=mySecNoEncrypt)&&(CheckSecurityFlag'="PatInfo"))			;securityno
	...s ^TMPAccCardIdx($j)=+$g(^TMPAccCardIdx($j))+1
	...s ^TMPAccCardIdx($j,"CardRowID",mycardid)=""

	;以下都是作废卡记录
	s cardid=0
	f  s cardid=$o(^TMPAccCardIdx($j,"CardRowID",cardid)) q:((cardid="")!(myACFlag=0))  d
	.s ActiveFlag=$p(^DHCCARD("CF",cardid),"^",10)
	.i ActiveFlag="S"  s myACFlag="-1"  ;挂失
	.i ActiveFlag="R"  s myACFlag="-2"  ;回收
	.i ActiveFlag="N"  s myACFlag="-3"  ;正常
	.i ActiveFlag="D"  d  ;q:ActiveFlag'="N"
	..s SecurityNO=$p(^DHCCARD("CF",cardid),"^",3)
	..i SecurityNO=$c(0) s SecurityNO=""
	..q:((SecurityNO'=mySecNoEncrypt)&&(CheckSecurityFlag'="PatInfo"))			;securityno
	..s myRtnCardTypeDR=$p(^DHCCARD("CF",cardid),"^", 16)		;CF_CardType_DR
	..q:(mySCMode'="PC")&&(+$g(^TMPAccCardIdx($j))>1)	;如果卡类型与卡号同时比较 而出现两张卡,一定无效
	..;如果 卡号优先 同时只检索一个卡号 , 这个卡号一定有效
	..;如果 卡号优先 但是检索多个卡号  ,需要对比当前的卡类型,如果不一致就退出, 
	..q:((mySCMode="PC")&&(+$g(^TMPAccCardIdx($j))>1)&&(myRtnCardTypeDR'=CardTypeDR))
	..;判断作废卡标志
	..s myACFlag=0		;此卡作废
	..s Papmi=$p(^DHCCARD("CF",cardid),"^",4)
	..s myCardRowID=cardid
	..s PAPMINo=##Class(web.PAPatMas).GetRegistration(Papmi)
	..s PatName=$p($g(^PAPER(Papmi,"ALL")),"^",1)
	..;前面是患者基本信息
	..q:(CheckSecurityFlag="PatInfo")			;如果强调 只获取患者信息， 而不要账户信息
	s rtn=myACFlag
	i ((mySCMode="PC")&&(+$g(^TMPAccCardIdx($j))>1)&&(+rtn'=0)) d
	.s mySelectCardTypeTip="请选择卡类型!"
	.s myRtnCardTypeDR=""
	i ActiveFlag="D"  s ActiveFlag="作废"
	s str=rtn_"^"_AccID_"^"_AccNo_"^"_PatName_"^"_Balance_"^"_DepPrice_"^"_Pass
	s str=str_"^"_Papmi_"^"_PAPMINo_"^"_myCardRowID_"^"_mySCMode_"^"_myRtnCardTypeDR_"^"_myCardRowID_"^"_ActiveFlag
	d ..KillTMP()
	q str
}

ClassMethod KillTMP() As %String
{
	k ^TMPAccCardIdx($j)
}

ClassMethod ReturnAbortCard(AccCardRowid As %String, UserDR As %String, sFlag As %String) As %Library.String
{
	
	s myrtn=-1
	//根据AccCardRowid取CardINVRowID
	q:AccCardRowid=""
	s CardINVRowID=""
	s CardINVRowID=$p($g(^DHCCARD("CF",AccCardRowid)),"^",17)
	q:CardINVRowID=""
	;看配置是否允许收回
	s myCardRegConfig=##class(web.DHCBL.CARD.CardPATRegConfig).GetCardPatRegConfig()
	s myCardRefFlag=$p(myCardRegConfig, "^", 5)
	s myAccManageFLag= $p(myCardRegConfig, "^", 6)
	s $ZT="ERROR^DHCSSERR"  d ..tb()
	i myCardRefFlag="Y"  d
	.s CardStatusInfo="R"
	.s CardCancleDate=$p($h,",",1)
	.s CardCancleTime=$p($h,",",2)
	.;将作废卡状态置成回收 
	.&sql(update SQLUSER.dhc_cardref set CF_ActiveFlag=:CardStatusInfo,CF_CancleUser_DR=:UserDR,CF_CancleDate=:CardCancleDate,CF_CancleTime=:CardCancleTime where CF_RowID=:AccCardRowid)
	.s myrtn=SQLCODE
	.s myrtn=+myrtn
	.i myrtn'=0  d
  	..Trollback
	.e  d
	..;作废原发票   
	..s myrtn=##class(web.DHCOPBillReturnAbortCard).CardINVPark(CardINVRowID, UserDR, sFlag)
	..s myrtn=+myrtn
	..i myrtn'=0  d
  	...Trollback
	..i (+myrtn=0)&&(CardINVRowID'="") d
	...;产生负票
	...s myval=##class(web.DHCOPBillReturnAbortCard).CardINVCancel(CardINVRowID, UserDR,sFlag,CardCancleDate,CardCancleDate)
	...s myrtn=+$p(myval,"^",1)
	...s myParkRowID=$p(myval,"^",2)
	...;写负支付模式
	...i myrtn'=0  d
  	....Trollback
	...i (+myrtn=0)&&(CardINVRowID'="") d
	....s myExpStr=""
	....s myrtn=##class(web.DHCOPBillReturnAbortCard).CardINVCancelPayMode(CardINVRowID, myParkRowID, CardCancleDate, CardCancleDate, myExpStr)
	....i +myrtn'=0  d
  	.....Trollback
	d ..tc()
	q myrtn
}

ClassMethod CardINVPark(INVRowID As %String, UserDR As %String, sFlag As %String) As %String
{
	s $ZT="ERROR^DHCSSERR" 
	s myrtn=0
	
	s myparkinv=##class(User.DHCCardINVPRT).%OpenId(INVRowID)
	s myparkinv.CIPFlag=sFlag
	s sc=myparkinv.%Save()
	
	If ($System.Status.IsError(sc))
	{
		Do $System.Status.DisplayError(sc)
		Set myrtn =-100
	}
	d myparkinv.%Close()
	
	q myrtn
}

/// 写负发票
ClassMethod CardINVCancel(INVRowID As %String, UserDR As %String, sFlag As %String, CurDate As %String, CurTime As %String) As %String
{
	s $ZT="ERROR^DHCSSERR" 
	
	;INVRowID
	q:(INVRowID="") 
	s myrtn=0
	s myParkRowID=""
	s myOldObj=##class(User.DHCCardINVPRT).%OpenId(INVRowID)
	i +myOldObj d
	.s myNCObj=##class(User.DHCCardINVPRT).%New()
	.s myNCObj.CIPPAPMIDR=myOldObj.CIPPAPMIDR
	.s myNCObj.CIPFlag=sFlag
	.s myNCObj.CIPAmount= -myOldObj.CIPAmount
	.s myNCObj.CIPDate=+CurDate
	.s myNCObj.CIPTime=CurTime
	.s myNCObj.CIPPUserDR=UserDR
	.d myNCObj.CIPINVPayDRSetObjectId(INVRowID)
	s sc=myNCObj.%Save()
	If ($System.Status.IsError(sc))
	{
		Do $System.Status.DisplayError(sc)
		Set myrtn =-100
	}
	s myParkRowID=myNCObj.%Id()
	d myOldObj.%Close()
	q myrtn_"^"_myParkRowID
}

ClassMethod CardINVCancelPayMode(OldINVRowID As %String, ParkINVRowID As %String, CurDate As %String, CurTime As %String, ExpStr As %String) As %String
{
	;对应的负票生成负的支付方式
	;OldINVRowID		原废单号码
	;ParkINVRowID		负单号码
	s $ZT="ERROR^DHCSSERR" 
	s myrtn=0
	s myOldPaySub=0
	s myOldINVObj=##class(User.DHCCardINVPRT).%OpenId(OldINVRowID)
	s myParkINVObj=##class(User.DHCCardINVPRT).%OpenId(ParkINVRowID)
	if ((+myOldINVObj)&&(+myParkINVObj)){
		s myCount=myOldINVObj.ChildDHCCardINVPRTPayMode.Count()
		s myIdx=1
		while ((myIdx<=myCount)&&(+myrtn=0)){
			s myOldPayObj=myOldINVObj.ChildDHCCardINVPRTPayMode.GetAt(myIdx)
			s myPObj=##class(User.DHCCardINVPRTPayMode).%New(ParkINVRowID)
			s myPObj.CPMCIPParRef=myParkINVObj		
			s myPObj.CPMPayModeDR = myOldPayObj.CPMPayModeDR
			s myPObj.CPMCMBankDR = myOldPayObj.CPMCMBankDR
			s myPObj.CPMAmt = -myOldPayObj.CPMAmt
			
			s myPObj.CPMCardChequeNo = myOldPayObj.CPMCardChequeNo
			s myPObj.CPMCardDR = myOldPayObj.CPMCardDR
			s myPObj.CPMDate = CurDate
			s myPObj.CPMTime = CurTime
			s myPObj.CPMUnit = myOldPayObj.CPMUnit
			s myIdx=+myIdx+1
			s sc=myPObj.%Save()
			If ($System.Status.IsError(sc))
			{
				Do $System.Status.DisplayError(sc)
				Set myrtn = -100
			}
			d myPObj.%Close()
			d myOldPayObj.%Close()
		}
	}
	d myOldINVObj.%Close()
	d myParkINVObj.%Close()
	q myrtn
}

ClassMethod tb()
{
 	n SQLCODE
 	TSTART  
 	q
}

ClassMethod tc()
{
    n SQLCODE
    TCOMMIT  
	q
}

ClassMethod GetCurrValue()
{
    s CurDate=$zd(+$h,3)_","_$zt($p($h,",",2),1)
    s Amount=-10
    s AmountUP=""
    s AmountUP=##class(web.UDHCJFBaseCommon).RMBDXXZH(Amount)
    s str=""
	s str=CurDate_"^"_Amount_"^"_AmountUP
	q str
}

}
