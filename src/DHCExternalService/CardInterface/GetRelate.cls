Class DHCExternalService.CardInterface.GetRelate Extends %RegisteredObject [ ClassType = "" ]
{

/// 需要的对照关系(外部与当前HIS)如下:
/// 1.证件代码+证件类型			
/// 2.卡类型						
/// 3.性别						
/// 4.病人类型					
/// 5.婚姻状况					
/// 6.民族						
/// 7.职业						
/// 8.邮编省份市					
/// 9.联系人关系					
/// 10.国籍						
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

/// 根据卡类型得到外部机构代码
/// w ##class(DHCExternalService.CardInterface.GetRelate).GetBankCodeByCardType("1")
ClassMethod GetBankCodeByCardType(CardType)
{
	q $G(^DHCCardInterfaceCodeRelate("CardTypeHis",CardType))
}

/// 根据外部机构以及对应的外部性别代码得到性别类型
/// w ##class(DHCExternalService.CardInterface.GetRelate).GetSex("01","M")
/// w ##class(DHCExternalService.CardInterface.GetRelate).GetSex("HIS","M")
ClassMethod GetSex(BankCode, Sex) As %String
{
	s HisCode=##class(DHCExternalService.RegInterface.GetRelate).GetCompareData("Sex",Sex,BankCode)
	q HisCode
}

/// 根据外部机构以及对应的外部病人类型代码得到病人类型
/// w ##class(DHCExternalService.CardInterface.GetRelate).GetPatType("1","01")
ClassMethod GetPatType(BankCode, PatType)
{
	s HisCode=##class(DHCExternalService.RegInterface.GetRelate).GetCompareData("PatType",PatType,BankCode)
	q HisCode
}

/// 根据外部机构以及对应的外部婚姻状况代码得到婚姻状况
/// w ##class(DHCExternalService.CardInterface.GetRelate).GetMarital("01","1")
ClassMethod GetMarital(BankCode, Marital)
{
	s HisCode=##class(DHCExternalService.RegInterface.GetRelate).GetCompareData("Marital",Marital,BankCode)
	q HisCode
}

/// 根据外部机构以及对应的外部民族代码得到民族
/// w ##class(DHCExternalService.CardInterface.GetRelate).GetNation("01","01")
ClassMethod GetNation(BankCode, Nation)
{
	s HisCode=##class(DHCExternalService.RegInterface.GetRelate).GetCompareData("Nation",Nation,BankCode)
	q HisCode
}

/// 根据外部机构以及对应的外部职业代码得到职业
/// w ##class(DHCExternalService.CardInterface.GetRelate).GetOccupation("01","01")
ClassMethod GetOccupation(BankCode, Occupation)
{
	s HisCode=##class(DHCExternalService.RegInterface.GetRelate).GetCompareData("Occupation",Occupation,BankCode)
	q HisCode
}

/// 根据外部机构邮编得到邮编省份市
/// w ##class(DHCExternalService.CardInterface.GetRelate).GetZip("252400")
ClassMethod GetZip(Zip)
{
	q:Zip="" ""
	s ZipDr=$O(^CT("ZIP",0,"Code",Zip,0))
	q:ZipDr="" ""
	s Province=$P(^CT("ZIP",ZipDr),"^",4)
	s City=$P(^CT("ZIP",ZipDr),"^",6)
	q ZipDr_"^"_Province_"^"_City
}

/// 根据外部机构以及外部关系代码得到关系
/// w ##class(DHCExternalService.CardInterface.GetRelate).GetGetRelation("01","252400")
ClassMethod GetRelation(BankCode, Relation)
{
	s HisCode=##class(DHCExternalService.RegInterface.GetRelate).GetCompareData("Relation",Relation,BankCode)
	q HisCode
}

/// 根据外部机构以及外部国籍代码得到国籍
/// w ##class(DHCExternalService.CardInterface.GetRelate).GetNationality("01","252400")
ClassMethod GetNationality(BankCode, Nationality)
{
	s CountryLookupID=##class(DHCExternalService.RegInterface.GetRelate).GetCompareData("Nationality",Nationality,BankCode)
	if CountryLookupID=""{
		s CountryLookupID=$o(^CT("COU",0))	
	}
	Q CountryLookupID
}

/// 得到默认的人员ID
ClassMethod GetUser()
{
	q 1
}

/// 根据卡类型代码得到病人ID优先级
ClassMethod GetIDLevelFromCardTypeCode(CardTypeCode As %String) As %String
{
	set MaxLevel=4
	quit:CardTypeCode="" MaxLevel
	set IDLevel=$get(^DHCCardInterfaceCodeRelate("IDLevel",CardTypeCode))
	if (IDLevel="") set IDLevel=MaxLevel
	quit IDLevel
}

/// HIS生成就诊卡的卡号
/// w ##class(DHCExternalService.CardInterface.GetRelate).CreateCardNo(2)
ClassMethod CreateCardNo(CardType)
{
	s myCardNo=0
	q:CardType="" ""
	s CardLen=$p(^DHCCARDTYPEDef(CardType),"^",17)
	i $d(^DHCRegInterfaceCodeRelate("HISCardNo","I")) d
	.;s myCardNo=^DHCRegInterfaceCodeRelate("HISCardNo","I") //最大登记号
	e  d
	.s myCardNo=0
	Lock ^DHCRegInterfaceCodeRelate("HISCardNo","I")
	s myCardNo=$i(^DHCRegInterfaceCodeRelate("HISCardNo","I"))
	Lock -^DHCRegInterfaceCodeRelate("HISCardNo","I")
	s ^DHCRegInterfaceCodeRelate("HISCardNo","I")=myCardNo
	s myCardNo=$e("0000000000000000000",1,CardLen-$l(myCardNo))_myCardNo
	s myCardNo="X"_$e(myCardNo,2,CardLen)
	quit myCardNo
}

/// 处理校验码的差异化需求 
/// 中国医大一院默认写死校验码=0
ClassMethod GetSecurityNo(SecurityNo As %String = "") As %String
{
	q:SecurityNo="" ""
	q SecurityNo
}

/// 取银行表ID (CMC_BankMas)
ClassMethod GetHISBankID(BankCode As %String = "") As %String
{
	quit:BankCode="" ""
	set BankID=$G(^DHCCardInterfaceCodeRelate("Bank",BankCode))
	if (BankID="")
	{
		s BankCode=$$ALPHAUP^SSUTIL4(BankCode)
		s BankID=$O(^CMC("CMCBM",0,"CMCBM_Code",BankCode,0))
	}
	quit BankID
}

}
