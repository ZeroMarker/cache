Import SQLUser

Class web.DHCBL.CARD.UCardINVPRTInfo Extends (DHCDoc.Util.RegisteredObject, %XML.Adaptor, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 195;

/// 写负发票
ClassMethod CardINVCancel(INVRowID As %String, UserDR As %String, sFlag As %String, CurDate As %String, CurTime As %String, HospitalID As %String = "") As %String
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
	.s myNCObj.CIPHospitalDR=HospitalID
	.s myNCObj.CIPHandin="N"
	.d myNCObj.CIPINVPayDRSetObjectId(INVRowID)
	.
	
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
	s PayMode=ExpStr
	s myOldINVObj=##class(User.DHCCardINVPRT).%OpenId(OldINVRowID)
	s myParkINVObj=##class(User.DHCCardINVPRT).%OpenId(ParkINVRowID)
	if ((+myOldINVObj)&&(+myParkINVObj)){
		s myCount=myOldINVObj.ChildDHCCardINVPRTPayMode.Count()
		s myIdx=1
		while ((myIdx<=myCount)&&(+myrtn=0)){
			s myOldPayObj=myOldINVObj.ChildDHCCardINVPRTPayMode.GetAt(myIdx)
			s myPObj=##class(User.DHCCardINVPRTPayMode).%New(ParkINVRowID)
			s myPObj.CPMCIPParRef=myParkINVObj	
			if PayMode'="" {
				s myPObj.CPMPayModeDR = PayMode
			}else{
				s myPObj.CPMPayModeDR = myOldPayObj.CPMPayModeDR
			}
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

/// 更新原来的发票状态 为作废，红冲
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

/// 在换卡时， Copy原发票成为一个新的发票
ClassMethod CopyOriginalINVInfo(INVRowID As %String, UserDR As %String, sFlag As %String, CurDate As %String, CurTime As %String) As %String
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
	.s myNCObj.CIPAmount= myOldObj.CIPAmount
	.s myNCObj.CIPDate=+CurDate
	.s myNCObj.CIPTime=CurTime
	.s myNCObj.CIPPUserDR=UserDR
	.;d myNCObj.CIPINVPayDRSetObjectId(INVRowID)
	.
	
	s sc=myNCObj.%Save()
	If ($System.Status.IsError(sc))
	{
		Do $System.Status.DisplayError(sc)
		Set myrtn =-100
	}
	s myNewINVRowID=myNCObj.%Id()
	
	d myOldObj.%Close()
	
	s myOldPaySub=0
	
	s myOldINVObj=##class(User.DHCCardINVPRT).%OpenId(INVRowID)
	s myNewINVObj=##class(User.DHCCardINVPRT).%OpenId(myNewINVRowID)
	if ((+myOldINVObj)&&(+myNewINVObj)){
		s myCount=myOldINVObj.ChildDHCCardINVPRTPayMode.Count()
		s myIdx=1
		while ((myIdx<=myCount)&&(+myrtn=0)){
			s myOldPayObj=myOldINVObj.ChildDHCCardINVPRTPayMode.GetAt(myIdx)
			s myPObj=##class(User.DHCCardINVPRTPayMode).%New(myNewINVRowID)
			s myPObj.CPMCIPParRef=myNewINVObj		
			s myPObj.CPMPayModeDR = myOldPayObj.CPMPayModeDR
			s myPObj.CPMCMBankDR = myOldPayObj.CPMCMBankDR
			s myPObj.CPMAmt = myOldPayObj.CPMAmt
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
	d myNewINVObj.%Close()
	
	q myrtn_"^"_myNewINVRowID
}

ClassMethod GetCardINVInfo(ReceiptNo As %String) As %String
{
	n (ReceiptNo)
	;返回一个标志和 Xml串
	s myXmlStr=""
	s myrtn=0
	
	;^DHCCARDINVPRTi(0,"INVNO",{CIP_INVNo},{CIP_RowID})
	;^DHCCARDINVPRT({CIP_RowID})
	
	q:(ReceiptNo="") "2602"_$c(1)_""
	
	s myCardNo=""
	s myCardINVRowID=""
	s myCardRowID=""
	s myCardTypeDR=""
	s myPAPMINo=""
	s myHandRepDR=""
	s myPRTUser = ""
	
	s myrtn=2602		; 此发票不存在
	s myRecCount=0
	s myRowID=0
	f  s myRowID=$o(^DHCCARDINVPRTi(0,"INVNO",ReceiptNo,myRowID))  q:(myRowID="")  d
	.s myFlag=$p(^DHCCARDINVPRT(myRowID), "^", 2)
	.i (myFlag'="N") s myrtn=2600			;发票作废
	.q:(myFlag'="N")
	.s myRecCount=+myRecCount+1
	.q:(+myRecCount>1)
	.s myCardINVRowID=myRowID
	.s myPAPMIDR=$p(^DHCCARDINVPRT(myRowID), "^", 1)
	.s myAmount=+$p(^DHCCARDINVPRT(myRowID), "^", 3)
	.s myPAPMIName=""
	.s:myPAPMIDR'="" myPAPMIName=$p(^PAPER(myPAPMIDR, "ALL"),"^", 1)
	.s mySexDR=""
	.s:(myPAPMIDR'="") mySexDR=$p(^PAPER(myPAPMIDR, "ALL"),"^", 7)
	.s myPRTUser=$p(^DHCCARDINVPRT(myRowID), "^", 6)
	.s myHandRepDR=$p(^DHCCARDINVPRT(myRowID), "^", 9)
	.s mySex=""
	.i mySexDR'="" d
	..s mySex=$p(^CT("SEX",mySexDR),"^",2)
	.;^DHCCARDINVPRT({DHC_CardINVPRT.CIP_RowID},"P",{CPM_Sub})
	.s mySub=0
	.f  s mySub=$o(^DHCCARDINVPRT(myRowID,"P",mySub)) q:(mySub="")  d
	..q:($d(^DHCCARDINVPRT(myRowID,"P",mySub))=10)
	..s myPayModeDR=$p(^DHCCARDINVPRT(myRowID,"P",mySub),"^",1)
	..
	.;^DHCCARDi("CF",0,"INVPRT",{CF_CardINVPRT_DR},{CF_RowID})
	.s myCFRowID=0
	.f  s myCFRowID=$o(^DHCCARDi("CF",0,"INVPRT",myRowID, myCFRowID)) q:(myCFRowID="")  d
	..s myCardActiveFlag=$p(^DHCCARD("CF",myCFRowID),"^", 10)
	..b
	..q:(myCardActiveFlag'="N")
	..s myCardRowID=myCFRowID
	..s myCardNo=$p(^DHCCARD("CF",myCFRowID),"^", 2)
	..s myCardTypeDR=$p(^DHCCARD("CF",myCFRowID),"^", 16)
	..s myPAPMINo=$p(^DHCCARD("CF",myCFRowID),"^", 6)
	
	;需要返回有效卡的RowID
	i myRecCount=0 d
	.;无效发票
	e  d
	.s myrtn=0
	.s myCardRP=##class(web.DHCEntity.PCA.CardINVRePrint).%New()
	.s myCardRP.CardFareCost=$fn(myAmount,"",2)
	.s myCardRP.CardNo=myCardNo
	.s myCardRP.CardRowID=myCardRowID
	.s myCardRP.CardTypeDefine=myCardTypeDR
	.s myCardRP.Name=myPAPMIName
	.s myCardRP.PAPMINo=myPAPMINo
	.s myCardRP.PAPMIRowID=myPAPMIDR
	.s myCardRP.PayMode=myPayModeDR
	.s myCardRP.Sex=mySex
	.s myCardRP.CardINVRowID=myCardINVRowID
	.d myCardRP.XMLExportToString(.myXmlStr)
	
	s mySpecInfo=myHandRepDR_"^"_myPRTUser
	
	q myrtn_$c(1)_myXmlStr_$c(1)_mySpecInfo
}

ClassMethod ReadReceiptNOForGroupCharge(itmjs As %Library.String = "", itmjsex As %Library.String = "", UserDR As %String, CardTypeDR As %String, GroupDR As %String) As %String
{
	n (itmjs, itmjsex,UserDR, CardTypeDR, GroupDR)
	
	;专门针对于某个用户的特殊类型的票据
	;w ##class(web.DHCBL.CARD.UCardINVPRTInfo).ReadReceiptNOForCard("","","6",16,"6")
	s myReceiptNo=""
	s rid=""
	s endno=""
	s rtn=108
	q:(UserDR="") 108	;没有发票
	
	;看此卡的配置
	;^DHCCARDTYPEDef(CardTypeDR)
	;s myFareType=$p($g(^DHCCARDTYPEDef(CardTypeDR)),"^",3)		;
	;s myPrtINVFlag=$p($g(^DHCCARDTYPEDef(CardTypeDR)),"^",4)		;
	s myUseINVType=$p($g(^DHCCARDTYPEDef(CardTypeDR)),"^",5)		;
	
	s myFareType="C"
	s myPrtINVFlag="Y"
	
	q:((myFareType'="C")||(myPrtINVFlag'="Y")) 0			;此类卡不需要打发票
	
	s myINVRowID=0
	f  s myINVRowID=$o(^DHCINVOICE(0,"USER",UserDR,myINVRowID)) q:((myINVRowID="")!(rtn=0))  d
	.s myFinFlag=$p(^DHCINVOICE(myINVRowID),"^",7)
	.s myType=$p(^DHCINVOICE(myINVRowID),"^",8)
	.q:((myFinFlag'="Y")!(myType'=myUseINVType))		;条件不等退出
	.s myReceiptNo=$p(^DHCINVOICE(myINVRowID),"^",6)
	.s rid=myINVRowID
	.s endno=$p(^DHCINVOICE(myINVRowID),"^",2)
	.s myBegNo=$p(^DHCINVOICE(myINVRowID),"^",1)
	.q:(+myReceiptNo<+myBegNo)
	.q:(+myReceiptNo>+endno)
	.s rtn=0
	
	;q rtn_"^"_myReceiptNo_"^"_rid_"^"_endno
	
	q:(+rtn) 100
	
	s myINVFlag=0
	s sno=myReceiptNo		;$p(myrtn,"^",2)
	s sid=rid				;$p(myrtn,"^",3)
	s myEndNo=endno			;$p(myrtn,"^",4)
	s myLeftNo=+myEndNo-sno+1
	if (myLeftNo<10) d
	.s myINVFlag=myLeftNo
	
	s str=sno_"^"_myINVFlag_"^"_myLeftNo
	
	s retval=itmjs_"('"_$ZCVT(str,"O","JS")_"');"
	&javascript<#(retval)#>
	
	q rtn
}

ClassMethod ReadReceiptNOForCard(itmjs As %Library.String = "", itmjsex As %Library.String = "", UserDR As %String, CardTypeDR As %String, GroupDR As %String) As %String
{
	n (itmjs, itmjsex,UserDR, CardTypeDR, GroupDR)
	
	;专门针对于某个用户的特殊类型的票据
	;w ##class(web.DHCBL.CARD.UCardINVPRTInfo).ReadReceiptNOForCard("","","6",16,"6")
	s myReceiptNo=""
	s rid=""
	s endno=""
	s rtn=108
	q:(UserDR="") 108	;没有发票
	q:(CardTypeDR="") 108	;没有发票
	
	;看此卡的配置
	;^DHCCARDTYPEDef(CardTypeDR)
	s myFareType=$p($g(^DHCCARDTYPEDef(CardTypeDR)),"^",3)		;
	s myPrtINVFlag=$p($g(^DHCCARDTYPEDef(CardTypeDR)),"^",4)		;
	s myUseINVType=$p($g(^DHCCARDTYPEDef(CardTypeDR)),"^",5)		;
	
	q:((myFareType'="C")||(myPrtINVFlag'="Y")) 0			;此类卡不需要打发票
	
	s myINVRowID=0
	f  s myINVRowID=$o(^DHCINVOICE(0,"USER",UserDR,myINVRowID)) q:((myINVRowID="")!(rtn=0))  d
	.s myFinFlag=$p(^DHCINVOICE(myINVRowID),"^",7)
	.s myType=$p(^DHCINVOICE(myINVRowID),"^",8)
	.q:((myFinFlag'="Y")!(myType'=myUseINVType))		;条件不等退出
	.s myReceiptNo=$p(^DHCINVOICE(myINVRowID),"^",6)
	.s rid=myINVRowID
	.s endno=$p(^DHCINVOICE(myINVRowID),"^",2)
	.s myBegNo=$p(^DHCINVOICE(myINVRowID),"^",1)
	.q:(+myReceiptNo<+myBegNo)
	.q:(+myReceiptNo>+endno)
	.s rtn=0
	
	;q rtn_"^"_myReceiptNo_"^"_rid_"^"_endno
	
	q:(+rtn) 100
	
	s myINVFlag=0
	s sno=myReceiptNo		;$p(myrtn,"^",2)
	s sid=rid				;$p(myrtn,"^",3)
	s myEndNo=endno			;$p(myrtn,"^",4)
	s myLeftNo=+myEndNo-sno+1
	if (myLeftNo<10) d
	.s myINVFlag=myLeftNo
	
	s str=sno_"^"_myINVFlag_"^"_myLeftNo
	
	s retval=itmjs_"('"_$ZCVT(str,"O","JS")_"');"
	&javascript<#(retval)#>
	
	q rtn
}

/// 集团注册收费
ClassMethod GroupRegCharge(ConfigInfo As %String, CardINVInfo As %String, SepcialInfo As %String, GRIRowID As %String, ExpStr As %String) As %String
{
	;w ##class(web.DHCBL.CARD.UCardINVPRTInfo).GroupRegCharge(ConfigInfo, CardINVInfo, SepcialInfo, GRIRowID, ExpStr)
	s myrtn=0
	s ^TMPGROUPREGCHADFDFDF=$lb(ConfigInfo, CardINVInfo, SepcialInfo,GRIRowID, ExpStr)
	
	ts
	
	;s myGroupRegFlag="GR"
	s myCardINVObj=##class(web.DHCEntity.PCA.CardINVPRT).%New()
	d myCardINVObj.XMLNodeDeserialize(.myCardINVObj, "CardINVPRT", CardINVInfo)
	s myCardINVObj.Date = +$h
	s myCardINVObj.Time = ..%SysTime()
	s myCardINVObj.Flag="N"
	
	s myrtn=..SaveCardINVInfo(myCardINVObj,"","GC")
	
	s myINVRtn=+$p(myrtn,"^",1)
	
	d myCardINVObj.%Close()
	
	s myCardINVRowID=$p(myrtn,"^",2)
	
	;修改集团注册 表 的发票 打印信息
	i +myINVRtn=0 d
	.s myINVRtn= ##class(web.DHCBL.CARD.UBatchPersonInfo).SetGroupRegPRTINVSign(GRIRowID, myCardINVRowID)
	
	s myrtn=myINVRtn
	
	b		;;;Tro
	if (+myrtn=0){
		tc
	}else{
		tro
	}
	
	q myrtn_"^"_myCardINVRowID
}

/// 提供一个分配模式 
/// 1. 按照卡类型收费 =PC Or =""
/// 2. 集体收费   ="GC"
ClassMethod SaveCardINVInfo(CardINVObj As web.DHCEntity.PCA.CardINVPRT, CardTypeDR As %String, GroupChargeMode As %String) As %String
{
	s $ZT="ERROR^DHCSSERR"
	
	n (CardINVObj, CardTypeDR, GroupChargeMode)
	
	s GroupChargeMode=$g(GroupChargeMode)
	
	s myrtn=0
	;集团收费模式
	i GroupChargeMode="GC"{
		s myFareCost=$fn(+CardINVObj.CardFareCost,"",2)		;CTD_CardFareCost
		s myFareType="C"		;
		s myPrtINVFlag="Y"		;
		s myUseINVType="R"		; Logon
	}else{
		s myFareCost=$fn(+$p(^DHCCARDTYPEDef(CardTypeDR),"^",6),"",2)		;CTD_CardFareCost
		s myFareType=$p($g(^DHCCARDTYPEDef(CardTypeDR)),"^",3)		;
		s myPrtINVFlag=$p($g(^DHCCARDTYPEDef(CardTypeDR)),"^",4)		;
		s myUseINVType=$p($g(^DHCCARDTYPEDef(CardTypeDR)),"^",5)		;
	}
	b	;;金额1
	;q:($fn(+CardINVObj.CardFareCost,"",2)'=myFareCost) -355		;金额不符
	
	s myrtn=0
	s myCardINVRowID=""
	s ReceipNO=""
	s myINVPreABC=""
	s myINVRowID=""
	s suser=CardINVObj.UserDR
	
	i ((myPrtINVFlag="Y"))  d
	.&sql(select inv_lastnum,inv_rowid,inv_EndInv into:ReceipNO,:myINVRowID,:endno from dhc_invoice 
	     where inv_rowid=(select min(inv_rowid)  from dhc_invoice 
	     where inv_usr= :suser and INV_Finalflag='Y' and INV_type=:myUseINVType))
	.s myrtn=SQLCODE
	
	q:myrtn -10001
	
	i myINVRowID'="" d
	.s myINVPreABC=$p(^DHCINVOICE(myINVRowID),"^",16)
	
	b	;更新发票
	i ((myPrtINVFlag="Y"))  d
	.s ReceipNew=+ReceipNO+1
	.s myrtn=..UpdateReceipNO(suser, ReceipNew, myUseINVType)
	;b	;;UpdateReceiptNo
	q:myrtn myrtn
	
	i myFareType="C"{
		s myObj=##class(User.DHCCardINVPRT).%New()
		s myObj.CIPPAPMIDR=CardINVObj.PAPMIRowID
		s myObj.CIPFlag = CardINVObj.Flag
		s myObj.CIPAmount = CardINVObj.CardFareCost
		
		s myObj.CIPDate = CardINVObj.Date
		s myObj.CIPTime = CardINVObj.Time
		s myObj.CIPPUserDR = CardINVObj.UserDR
		s myObj.CIPINVNo = myINVPreABC_ReceipNO
		s myObj.CIPHospitalDR=CardINVObj.HospitalID
		s myObj.CIPHandin="N"   //代表没有日结
		s sc=myObj.%Save()
		
		If ($System.Status.IsError(sc))
		{
			Do $System.Status.DisplayError(sc)
			Set myrtn = "-100  "_sc
		}
		s myCardINVRowID=myObj.%Id()
		
		q:(+myrtn) myrtn_"^"
		
		s myPObj=##class(User.DHCCardINVPRTPayMode).%New(myCardINVRowID)
		s myPObj.CPMCIPParRef=myObj
		
		s myPObj.CPMPayModeDR = CardINVObj.PayMode
		s myPObj.CPMCMBankDR = CardINVObj.Bank
		s myPObj.CPMAmt = CardINVObj.CardFareCost
		
		s myPObj.CPMCardChequeNo = CardINVObj.CardChequeNo
		s myPObj.CPMCardDR = CardINVObj.BankCardType
		s myPObj.CPMDate = CardINVObj.Date
		s myPObj.CPMTime = CardINVObj.Time
		s myPObj.CPMUnit = CardINVObj.PayCompany
		d myPObj.CPMETPDRSetObjectId(CardINVObj.ETPRowID)   //+2022-09-29 ZhYW 增加第三方支付订单表Id
		s sc=myPObj.%Save()
		
		If ($System.Status.IsError(sc))
		{
			Do $System.Status.DisplayError(sc)
			Set myrtn = "-100  "_sc
		}
	}
	b		;Insert INVPRT
	q myrtn_"^"_myCardINVRowID
}

ClassMethod InsertCardINV(CardINVObj As web.DHCEntity.PCA.CardINVPRT, UseINVType As %String, PrtINVFlag As %String, FareType As %String, ExpStr As %String) As %String
{
	;s myobj=##class(web.DHCBL.CARD.UCardINVPRTInfo).InsertCardINV()
	;对于 CardINVObj对象单独生成一个发票，
	;其他的逻辑判断 放在外边
	n (CardINVObj, UseINVType, PrtINVFlag, FareType, ExpStr)
	
	s myrtn=0
	s myCardINVRowID=""
	s ReceipNO=""
	s myINVPreABC=""
	s myINVRowID=""
	s suser=CardINVObj.UserDR
	
	s myPrtINVFlag=PrtINVFlag
	s myUseINVType=UseINVType
	
	i ((myPrtINVFlag="Y"))  d
	.&sql(select inv_lastnum,inv_rowid,inv_EndInv into:ReceipNO,:myINVRowID,:endno from dhc_invoice 
	     where inv_rowid=(select min(inv_rowid)  from dhc_invoice 
	     where inv_usr= :suser and INV_Finalflag='Y' and INV_type=:UseINVType))
	.s myrtn=SQLCODE
	
	q:myrtn myrtn
	
	i myINVRowID'="" d
	.s myINVPreABC=$p(^DHCINVOICE(myINVRowID),"^",16)
	
	b	;更新发票
	i ((PrtINVFlag="Y"))  d
	.s ReceipNew=+ReceipNO+1
	.s myrtn=..UpdateReceipNO(suser, ReceipNew, myUseINVType)
	;b	;;UpdateReceiptNo
	q:myrtn myrtn
	
	i FareType="C"{
		s myObj=##class(User.DHCCardINVPRT).%New()
		s myObj.CIPPAPMIDR=CardINVObj.PAPMIRowID
		s myObj.CIPFlag = CardINVObj.Flag
		s myObj.CIPAmount = CardINVObj.CardFareCost
		
		s myObj.CIPDate = CardINVObj.Date
		s myObj.CIPTime = CardINVObj.Time
		s myObj.CIPPUserDR = CardINVObj.UserDR
		s myObj.CIPINVNo = myINVPreABC_ReceipNO
		s sc=myObj.%Save()
		
		If ($System.Status.IsError(sc))
		{
			Do $System.Status.DisplayError(sc)
			Set myrtn = "-100  "_sc
		}
		s myCardINVRowID=myObj.%Id()
		
		q:(+myrtn) myrtn_"^"
		
		s myPObj=##class(User.DHCCardINVPRTPayMode).%New(myCardINVRowID)
		s myPObj.CPMCIPParRef=myObj
		
		s myPObj.CPMPayModeDR = CardINVObj.PayMode
		s myPObj.CPMCMBankDR = CardINVObj.Bank
		s myPObj.CPMAmt = CardINVObj.CardFareCost
		
		s myPObj.CPMCardChequeNo = CardINVObj.CardChequeNo
		s myPObj.CPMCardDR = CardINVObj.BankCardType
		s myPObj.CPMDate = CardINVObj.Date
		s myPObj.CPMTime = CardINVObj.Time
		s myPObj.CPMUnit = CardINVObj.PayCompany
		
		s sc=myPObj.%Save()
		
		If ($System.Status.IsError(sc))
		{
			Do $System.Status.DisplayError(sc)
			Set myrtn = "-100  "_sc
		}
	}
	b		;Insert INVPRT
	q myrtn_"^"_myCardINVRowID
}

ClassMethod UpdateReceipNO(suser As %String, rcpno As %String, UseINVType As %String) As %String
{
	///专门为
	n (suser, rcpno, UseINVType)
	
	s endno="",rowid=""
	s myUseINVType=UseINVType
	&sql(select inv_endinv,inv_rowid into :endno,:rowid from DHC_INVOICE 
	     where inv_rowid=(select min(inv_rowid) from dhc_invoice 
	     where inv_usr= :suser and INV_finalflag='Y' and INV_type=:myUseINVType))
	b	;;UpdateReceipNO
	s len=$LENGTH(endno)
	if $LENGTH(rcpno)<len d
	.s prelen=len-$LENGTH(rcpno)
	.for i=1:1:prelen s rcpno="0"_rcpno
	
	i rcpno>endno  d
	.&sql(update DHC_INVOICE set inv_finalflag='N' where inv_rowid= :rowid)
	.s rtn=SQLCODE
	.q:SQLCODE
	.&sql(select count(*) into :num from DHC_INVOICE where (inv_finalflag='' or inv_finalflag is null) and inv_rowid<>'0' and inv_usr=:suser and inv_type=:myUseINVType)
	.s rtn=SQLCODE
	.q:SQLCODE
	.i num'=0  d
	..&sql(select min(inv_rowid) into :rowid1  from DHC_INVOICE where (inv_finalflag='' or inv_finalflag is null) and inv_rowid<>'0' and inv_usr=:suser and inv_type=:myUseINVType)
	..s rtn=SQLCODE
	..q:SQLCODE
	..&sql(update DHC_INVOICE set inv_finalflag='Y' where inv_rowid=:rowid1)
	..s rtn=SQLCODE
	..q:SQLCODE
	e  d
	.&sql(update DHC_INVOICE set inv_lastnum= :rcpno where inv_rowid= :rowid)
	.s rtn=SQLCODE
	.q:SQLCODE
	q rtn
}

ClassMethod SaveTest()
{
	;d ##class(web.DHCBL.CARD.UCardINVPRTInfo).SaveTest()
	;^TMPPatRegInfo=$lb(ConfigInfo, PaPatInfo, CardInfo, AccInfo, DepositInfo, CardINVInfo, ExpStr)
	s ConfigInfo=$LIST($g(^TMPGroupRegCharge),1)
	s CardINVInfo=$LIST($g(^TMPGroupRegCharge),2)
	s SepcialInfo =$LIST($g(^TMPGroupRegCharge),3)
	s GRCRowID=$LIST($g(^TMPGroupRegCharge),4)
	s ExpStr =$LIST($g(^TMPGroupRegCharge),5)
	
	s myrtn=##class(web.DHCBL.CARD.UCardINVPRTInfo).GroupRegCharge(ConfigInfo, CardINVInfo, SepcialInfo,GRCRowID, ExpStr)
	;
	b		;myrtn
}

}
