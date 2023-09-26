/// 用户界面默认配置
Class web.DHCBL.UDHCUIDefConfig Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// //用户注册准备的 界面配置
ClassMethod ReadCardPatUIDef(UserID As %String = "", GroupID As %String = "", LocID As %String = "", SessionStr As %String = "", defaultObj As %String = "", HospId As %String = "") As %String
{
	;w ##class(web.DHCBL.UDHCUIDefConfig).ReadCardPatUIDef("","119","")
	s myObj=##class(web.DHCEntity.PCA.DHCCardRegInfoDefault).%New()
	
	;(web.DHCBL.CARD.UCardPatRegDefaultConfing)
	s myCardTypeRowID=""
	i GroupID="" d
	.s GroupID=%session.Get("LOGON.GROUPID")
	
	s mySexRowID = ##class(web.DHCBL.CARD.UCardPatRegDefaultConfing).ReadDefaultSex(HospId)
	s myCardTypeDR= ##class(web.DHCBL.CARD.UCardPatRegDefaultConfing).ReadDefaultCardTypeDefine()
	s myCredTypeDR = ##class(web.DHCBL.CARD.UCardPatRegDefaultConfing).ReadDefaultCredTypeExp(myCardTypeDR)		
	s myPatTypeDR = ##class(web.DHCBL.CARD.UCardPatRegDefaultConfing).ReadDefaultPatType()
	s myPayModeDR = ##class(web.DHCBL.CARD.UCardPatRegDefaultConfing).ReadDefaultPayMode(GroupID)
	s myCountryDR = ##class(web.DHCBL.CARD.UCardPATRegConfig).GetDefaultCountry()
	s myProvinceDR = ##class(web.DHCBL.CARD.UCardPATRegConfig).GetDefaultProvince()
	s myCityDR = ##class(web.DHCBL.CARD.UCardPATRegConfig).GetDefaultCity()
	s myNationDR = ##class(web.DHCBL.CARD.UCardPATRegConfig).GetDefaultNation()
	s myRelationDR = ##class(web.DHCBL.CARD.UCardPATRegConfig).GetDefaultRelation()
	
	s myObj.Sex=mySexRowID
	s myObj.CardTypeDefine = myCardTypeDR
	s myObj.CredType = myCredTypeDR
	s myObj.PatType = myPatTypeDR
	s myObj.PayMode = myPayModeDR
	s myObj.IEType = ""
	s myObj.NationDesc = myNationDR
	s myObj.NationDescLookUpRowID = myNationDR
	s myObj.CTRelation = myRelationDR
	s myObj.CountryDesc = myCountryDR
	s myObj.CountryDescLookUpRowID = myCountryDR
	s myObj.ProvinceInfo = myProvinceDR
	s myObj.ProvinceInfoLookUpRowID = myProvinceDR
	s myObj.CityDesc = myCityDR
	s myObj.CityDescLookUpRowID = myCityDR
	s myObj.EmployeeCompany = ""
	s myObj.SetDefaultPassword=+$g(^DHCACDP("ParaSet","CreatePWD"))
	
	s myPEObj=##class(web.DHCBL.Configure.PatEnroll).DHCGetDOByDefaultSession()
	;s myPEObj=##class(web.DHCBL.Configure.PatEnroll).DHCGetDataObjectBySession(SessionStr)
	if ($IsObject(myPEObj)){
		s myObj.CardTypeDefine =myPEObj.DefaultCardTypeDR
		s myObj.PatType = myPEObj.DefaultPatTypeDR
		s myObj.CountryDesc = myPEObj.DefaultCountryDR
		s myObj.CountryDescLookUpRowID = myPEObj.DefaultCountryDR
		;
		s myObj.CountryHouse = myPEObj.DefaultCountryDR
		s myObj.ProvinceInfo = myPEObj.DefaultProvinceDR
		s myObj.ProvinceInfoLookUpRowID = myPEObj.DefaultProvinceDR
		s myObj.CityDesc = myPEObj.DefaultCityDR
		s myObj.CityDescLookUpRowID = myPEObj.DefaultCityDR
		s myObj.NationDesc = myPEObj.DefaultNationDR
		s myObj.NationDescLookUpRowID = myPEObj.DefaultNationDR
		s myObj.IEType = myPEObj.DefaultIDEquipDR
		;
		d myPEObj.%Close()
	}
	;默认值设置
	s myObj.Vocation=""
	s myObj.CTRelationDR=myRelationDR
	s myObj.CityAreaLookUpRowID=""
	s myObj.MedicalCardNo=""
	s myObj.EmployeeNo=""
	s myObj.HCPDR=""
	s myObj.InsurCardNo=""
	s myObj.MedUnionCard=""
	s myObj.ForeignIDCard=""
	s myObj.ForeignPhone=""
	s myObj.HealthCareRegion=""
	s myObj.AdmSource=""
	s myObj.Company=""
	s myObj.VIPFlag=""
	s myObj.CompanyPostCode=""
	s myObj.ForeignAddress=""
	s myObj.ForeignPostCode=""
	s myObj.HomePlace=""
	s myObj.HouseArea=""
	s myObj.PostCode=""
	s myObj.RegisterPlace=""
	s myObj.PhotoInfo=""
	s myObj.CountryHome=myObj.CountryDescLookUpRowID
	s myObj.ProvinceHome=""
	s myObj.CityHome=""
	s myObj.CountryBirth=myObj.CountryDescLookUpRowID
	s myObj.ProvinceBirth=""
	s myObj.CityBirth=""
	s myObj.AreaBirth=""
	s myObj.AddressBirth=""
	s myObj.CountryHouse=myObj.CountryDescLookUpRowID
	s myObj.ProvinceHouse=""
	s myObj.Cityhouse=""
	s myObj.AreaHouse=""
	s myObj.PostCodeHouse=""
	s myObj.PoliticalLevel=""
	s myObj.SecretLevel=""
	s myObj.BirthTime=""
	
	d myObj.XMLExportToStringExp(.myXmlData)
	;s ^tmpgry("ReadCardPatUIDef",1)=myXmlData
	d myObj.%Close()
	
	s defaultObj=##class(%DynamicObject).%New()
	d defaultObj.%Set("CountryDr",myObj.CountryDescLookUpRowID)
	
	q myXmlData
}

}
