Class DHCExternalService.OPAlloc.GetRelate Extends %RegisteredObject
{

/// 根据卡类型代码取卡类型RowID
/// w ##class(DHCExternalService.OPAlloc.GetRelate).GetHisCardTypeID("01")
ClassMethod GetHisCardTypeID(CardTypeCode As %String = "", BankCode As %String = "", Bindflag As %String = "", HospId As %String = "") As %String
{
	if CardTypeCode=""{
		s CardTypeCode=##class(DHCDoc.Interface.Outside.Config).GetDefaultDataNew("CardType",HospId)
	}
	i BankCode'="" {
		if (Bindflag'="")
		{
			q:$G(^DHCCardInterfaceCodeRelate("CardType",BankCode,Bindflag))'="" $G(^DHCCardInterfaceCodeRelate("CardType",BankCode,Bindflag)) 
			q $G(^DHCCardInterfaceCodeRelate("CardType",BankCode))
		}
		else
		{
			s CompareData=##class(web.DHCDocTextDicDataCtl).GetCompareData("CardType",CardTypeCode,"",BankCode)
			s CompareDataID=$p(CompareData,"^",1)
			Q CompareDataID
		}
	}else{
		q:CardTypeCode="" ""
		&sql(Select CTD_RowID into :RowId From SQLUser.DHC_CardTypeDef Where CTD_Code=:CardTypeCode)
		Q $g(RowId)
	}
}

/// 根据外部机构以及对应的外部证件代码得到证件类型
/// 如果需要与第三方对照证件类型 第一个参数传入 "TOHis" 
/// w ##class(DHCExternalService.CardInterface.GetRelate).GetIDCardType("HIS","")
ClassMethod GetIDCardType(BankCode, IDCardType, HospId As %String = "") As %String
{
	i IDCardType=""{
		s IDCardType=##class(DHCDoc.Interface.Outside.Config).GetDefaultDataNew("IDCardType",HospId)
		if IDCardType=""{
			s IDCardType="01"
		}
		s BankCode=""
	}
	q:IDCardType="" ""
	s HisCode=##class(DHCExternalService.RegInterface.GetRelate).GetCompareData("IDCardType",IDCardType,BankCode)
	q HisCode
}

/// 得到默认的人员ID
ClassMethod GetUser(ExtUserID, BankCode As %String = "", HospId As %String = "")
{
	set myrtn=""
	if ExtUserID=""{
		s ExtUserID=##class(DHCDoc.Interface.Outside.Config).GetDefaultDataNew("ExtUserID",HospId) ;$g(^DHCRegInterfaceCodeRelate("Default","ExtUserID"))
	}
	set myExtUserID=ExtUserID
	if (myExtUserID="") quit myrtn
	set myUserId=$order(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(myExtUserID),0))
	if (myUserId'="") quit myUserId
	quit myrtn
}

/// 得到默认的安全组
ClassMethod GetGroup(ExtUserID)
{
	s Group=$p($g(^SSU("SSUSR",ExtUserID)),"^",5) 
	q Group
}

}
