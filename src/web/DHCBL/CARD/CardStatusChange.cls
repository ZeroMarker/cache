Class web.DHCBL.CARD.CardStatusChange Extends (DHCDoc.Util.RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// 新增卡
ClassMethod InsertCard(CardStatusInfo As web.DHCEntity.PCA.CardStatusChange) As %String
{
	TStart
	set oldCard=##class(User.DHCCardRef).%OpenId(CardStatusInfo.CardID)
	set card=##class(User.DHCCardRef).%New()
	
	set card.CFAccNoDR=oldCard.CFAccNoDR
	set card.CFCardNo=CardStatusInfo.ExchangeCardNo
	set Acc=""
	if (oldCard.CFAccNoDR'=""){
		set Acc=##class(User.DHCAccManager).%OpenId(oldCard.CFAccNoDR.%Id())
		set Acc.AccMCardNo=CardStatusInfo.ExchangeCardNo
	}
	//set card.CFSecurityNO=CardStatusInfo.CFAccNoDR

	s mySecrityNoFlag=$g(^DHCCARDTYPEDef(CardStatusInfo.CardTypeDefine))
	if mySecrityNoFlag'=""
	{
		if ($p(mySecrityNoFlag,"^",18)="Y")
		{
			if (CardStatusInfo.SecrityNo'="")
			{
				s card.CFSecurityNO=##class(web.UDHCAccEnrypt).Encrypt(CardStatusInfo.SecrityNo)
			}
			else
			{
				s card.CFSecurityNO=""
				;set mySecurityNO=##class(web.UDHCAccCardManage).GetCardCheckNo(oldCard.CFPAPMIDR)
				;set card.CFSecurityNO=##class(web.UDHCAccEnrypt).Encrypt(mySecurityNO)
			}
		}
	}	
	set card.CFPAPMIDR=oldCard.CFPAPMIDR
	set card.CFIDCardNo=oldCard.CFIDCardNo
	set card.CFPAPMINo=oldCard.CFPAPMINo
	set card.CFDate=..%SysDate()
	set card.CFTime=..%SysTime()
	set card.CFUserDR=CardStatusInfo.UserDR
	set card.CFActiveFlag=CardStatusInfo.ActiveFlag
	set card.CFDateFrom=..%SysDate()
	set card.CFCardTypeDR=oldCard.CFCardTypeDR
	set card.CFCardINVPRTDR=oldCard.CFCardINVPRTDR
	set card.CFFareType=oldCard.CFFareType
	set card.CFIsTemporaryCard=oldCard.CFIsTemporaryCard
	if (Acc'=""){
		set CODE=Acc.%Save()
		If $$$ISERR(CODE) {
			Do $System.Status.DisplayError()
			Trollback
			set ErrCode=  -104
		}
	}
	set sc=card.%Save()
	If $$$ISERR(sc) {
		Do $System.Status.DisplayError()
		Trollback
		set ErrCode=  -104
	}
	else
	{
		TCommit
		set ErrCode= 0
	}
	quit ErrCode_"^"_card.%Id()
}

ClassMethod UpdateCardStatus(CardStatusInfo As web.DHCEntity.PCA.CardStatusChange) As %String
{
	TStart
	set card=##class(User.DHCCardRef).%OpenId(CardStatusInfo.CardID)
	//set card.CFSecurityNO=CardStatusInfo.CFAccNoDR
	set card.CFCancleUserDR=CardStatusInfo.UserDR
	set card.CFActiveFlag=CardStatusInfo.ActiveFlag
	set card.CFCancleDate=..%SysDate()
	set card.CFCancleTime=..%SysTime()
	
	set sc=card.%Save()
	If $$$ISERR(sc) {
		Do $System.Status.DisplayError()
		Trollback
		set ErrCode= -105
	}
	else
	{
		TCommit
		set ErrCode= 0
	}
	quit ErrCode_"^"_card.%Id()
}

ClassMethod Insert(CardStatusInfo As web.DHCEntity.PCA.CardStatusChange) As %String
{
	TStart
	//set CardRef=##class(User.DHCCardRef).%OpenId(CardStatusInfo.CardID)
	set StatusInfo=##class(User.DHCCardStatusChange).%New(CardStatusInfo.CardID)
	//set StatusInfo.CSCCFParRef=CardRef
	do StatusInfo.CSCCFParRefSetObjectId(CardStatusInfo.CardID)
	set StatusInfo.CSCCurStatus=CardStatusInfo.ActiveFlag
	set StatusInfo.CSCUserDR=CardStatusInfo.UserDR
	set StatusInfo.CSCComputerIP=CardStatusInfo.ComputerIP
	//if (CardStatusInfo.ActiveFlag'="N")
	//{
		set StatusInfo.CSCRLName=CardStatusInfo.RLName
		set StatusInfo.CSCRLCredNo=CardStatusInfo.RLCredNo
		set StatusInfo.CSCRLAddress=CardStatusInfo.RLAddress
		set StatusInfo.CSCRLPhoneNo=CardStatusInfo.RLPhoneNo
		set StatusInfo.CSCRLProof=CardStatusInfo.RLProof
		set StatusInfo.CSCRLRemark=CardStatusInfo.RLRemark
		do StatusInfo.CSCCredTypeSetObjectId(CardStatusInfo.RLCredTypeID)
	//}
	set StatusInfo.CSCDate=..%SysDate()
	set StatusInfo.CSCTime=..%SysTime()
	If (CardStatusInfo.LogonHospDR '= ""){
		d StatusInfo.CSCHospDRSetObjectId(CardStatusInfo.LogonHospDR)
	}

	set sc=StatusInfo.%Save()
	If $$$ISERR(sc) {
		Do $System.Status.DisplayError()
		Trollback
		set ErrCode= -104
	}
	else
	{
		set ErrCode= 0
		TCommit
	}
	quit ErrCode_"^"_StatusInfo.%Id()
}

}
