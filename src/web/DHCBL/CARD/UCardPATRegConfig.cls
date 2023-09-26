Class web.DHCBL.CARD.UCardPATRegConfig Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

ClassMethod GetBasePatRegConfig() As %String
{
	;w ##class(web.DHCBL.CARD.UCardPATRegConfig).GetBasePatRegConfig()
	;
	s myHospitalID=%session.Get("LOGON.HOSPID")
	set Returnvalue=""
	set RowID=""
	set RowID=$order(^DHCCARDPATREGCONFIG(RowID))
	while(RowID '="")
	{
		set HospDr=$p($Get(^DHCCARDPATREGCONFIG(RowID)),"^",18)
		if HospDr=myHospitalID {
			set Returnvalue=RowID_"^"_$get(^DHCCARDPATREGCONFIG(RowID))
		}
		set RowID=$order(^DHCCARDPATREGCONFIG(RowID))
	}
	
	;获取界面初始化时，默认的信息
	s myRowID=$p(Returnvalue,"^",1)
	;s myXMLStr=""
	quit Returnvalue
}

ClassMethod GetCardPatRegConfig(SessionStr As %String = "") As %String
{
	;w ##class(web.DHCBL.CARD.UCardPATRegConfig).GetCardPatRegConfig()
	;
	if (SessionStr'=""){
		s myHospitalID=$p(SessionStr,"^",5)
	}else{
		s myHospitalID=%session.Get("LOGON.HOSPID")
	}
	set Returnvalue=""
	set RowID=""
	set RowID=$order(^DHCCARDPATREGCONFIG(RowID))
	while(RowID '="")
	{
		set HospDr=$p($Get(^DHCCARDPATREGCONFIG(RowID)),"^",18)
		if HospDr=myHospitalID {
			set Returnvalue=RowID_"^"_$get(^DHCCARDPATREGCONFIG(RowID))
		}
		set RowID=$order(^DHCCARDPATREGCONFIG(RowID))
	}
	b //56
	;获取界面初始化时，默认的信息
	s myRowID=$p(Returnvalue,"^",1)
	s myXMLStr=""
	
	i (myRowID'=""){
		s myobj=##class(User.DHCCardPATRegConfig).%OpenId(myRowID)
		
		s myrtnobj=##class(web.DHCEntity.PCA.PatDefaultConfig).%New()
		
		i myobj.CPRDefaultCityDR'=""{
			s myrtnobj.CityDesc=$p($g(^CT("CIT",myobj.CPRDefaultCityDR)),"^",2)
		}
		s myrtnobj.CityDescLookUpRowID=myobj.CPRDefaultCityDR
		if (myobj.CPRDefaultCountryDR'=""){
			s myrtnobj.CountryDesc=$p(^CT("COU",myobj.CPRDefaultCountryDR),"^",2)
		}
		s myrtnobj.CountryDescLookUpRowID=myobj.CPRDefaultCountryDR
		i (myobj.CPRDefaultNationDR'=""){
			s myrtnobj.NationDesc = $p(^CT("NAT",myobj.CPRDefaultNationDR),"^",2)
		}
		s myrtnobj.NationDescLookUpRowID=myobj.CPRDefaultNationDR
		i (myobj.CPRDefaultProvinceDR'=""){
			s myrtnobj.ProvinceInfo= $p(^CT("PROV",myobj.CPRDefaultProvinceDR),"^",2)
		}
		s myrtnobj.ProvinceInfoLookUpRowID=myobj.CPRDefaultProvinceDR
		s myrtnobj.Zip=""
		s myrtnobj.ZipLookUpRowID=""
		
		;s myPEObj=##class(web.DHCBL.Configure.PatEnroll).DHCGetDataObjectBySession(SessionStr)
		;if ($IsObject(myPEObj)){
			;d myPEObj.%Close()
		;}
		//s myrtnobj.CardRegMustFillIn=myobj.CPRCardRegMustFillIn
		//s myrtnobj.CardRegJumpSeq=myobj.CPRCardRegJumpSeq
		d myrtnobj.XMLExportToString(.myXMLStr)
		d myobj.%Close()
		d myrtnobj.%Close()
	}
	
	s Returnvalue=Returnvalue_$c(2)_myXMLStr
	
	quit Returnvalue
}

ClassMethod GetDefaultCity() As %String
{
	s myrtn=""
	s myVal=..GetBasePatRegConfig()
	s myRowID=$p(myVal,"^",11)
	s myrtn=myRowID
	q myrtn
}

ClassMethod GetDefaultCountry() As %String
{
	s myrtn=""
	s myVal=..GetBasePatRegConfig()
	s myRowID=$p(myVal,"^",8)
	s myrtn=myRowID
	q myrtn
}

ClassMethod GetDefaultProvince() As %String
{
	s myrtn=""
	s myVal=..GetBasePatRegConfig()
	s myRowID=$p(myVal,"^",10)
	s myrtn=myRowID
	q myrtn
}

ClassMethod GetDefaultNation() As %String
{
	s myrtn=""
	s myVal=..GetBasePatRegConfig()
	s myRowID=$p(myVal,"^",9)
	s myrtn=myRowID
	q myrtn
}

ClassMethod GetDefaultRelation() As %String
{
	q ""
}

/// 根据身份证号码获取
/// 配置信息
/// 人员信息
/// 是否修改标志
ClassMethod ReadConfigByIDU(IDNo As %String = "", CredTypeDR As %String, CredNo As %String = "", CardTypeDR As %String = "") As %String
{
	;CredTypeDR  证件类型
	;CredNo      证件号码
	;CardTypeDR  办理的当前卡类型
	;IDNo        身份证号码
	;w ##class(web.DHCBL.CARD.UCardPATRegConfig).ReadConfigByIDU("",1,"37252219760922493x",2)
	s ^TMPPATREGCONFIFDFDD=IDNo_","_CredTypeDR_","_ CredNo_","_ CardTypeDR
	s myrtn=0
	s myConfiXmlData=""
	s myPatXmlData=""
	s myRepairFlag="Y"
	s myConfingStr=""
	
	q:(CardTypeDR="") myrtn_$c(1)_myConfiXmlData_$c(1)_myPatXmlData_$c(1)_myRepairFlag_$c(1)_myConfingStr_$c(1)
	
	;IDNo , CredTypeDR , CredNo , CardTypeDR As %String = "", ExpStr As %String) As %String
	s myCheckInfo=##class(web.DHCBL.CARD.UCardRefInfo).CreateCardCheckData(IDNo, CredTypeDR,CredNo,  CardTypeDR, "" )
	
	;解释：myrtn=0  没有检测到信息 可以按照 卡类型原有配置 直接办卡
	;myrtn=-368   	需要绑定卡标志
	;myrtn=-365		患者已经办理过此卡，通知用户，不能办理卡 集团注册时，修改EmployeeCompony字段
	;其他错误，需要提示一下 同时，不能办理卡
	
	s myrtn=+$p(myCheckInfo,"^",1)
	
	q:(+myrtn'=-368) myrtn_$c(1)_myConfiXmlData_$c(1)_myPatXmlData_$c(1)_myRepairFlag_$c(1)_myConfingStr_$c(1)
	
	s myPAPMIDR=$p(myCheckInfo,"^",2)
	s myPAPMINo = ##Class(web.PAPatMas).GetRegistration(myPAPMIDR)
	
	b	;
	s myDefCTInfo=..ReadDefaultCardTypeConfigByDR(CardTypeDR)
	b	;;
	s myVal = ##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatInfoByPANo(myPAPMINo,"")
	s myPatXmlData=$p(myVal,"^",2)
	
	s myConObj=##class(web.DHCEntity.PCA.CardTypeConfig).%New()
	
	d myConObj.XMLDeserialize(.myConObj, myDefCTInfo)
	if (+myrtn=-368){
		s myConObj.PANoCardRefFlag="Y"		;直接定义卡与 信息建立对照
		s myConObj.SearchMasFlag="Y"		;建立对照， 要求有等记号
		s myConfingStr=myConfingStr_"^"_myConObj.PatMasFlag
		s myConfingStr=myConfingStr_"^"_myConObj.CardRefFlag
		s myConfingStr=myConfingStr_"^"_myConObj.AccManageFLag
		s myConfingStr=myConfingStr_"^"_myConObj.PANoCardRefFlag
		
	}
	
	d myConObj.XMLExportToString(.myConfiXmlData)
	s myRepairFlag= $p(^DHCCARDTYPEDef(CardTypeDR),"^", 34)		;CTD_ValidateMode
	
	q myrtn_$c(1)_myConfiXmlData_$c(1)_myPatXmlData_$c(1)_myRepairFlag_$c(1)_myConfingStr_$c(1)
}

/// 获取默认的配置表
/// 根据RowID获取卡类型的配置信息
/// 这个信息是 专门对 web.DHCEntity.PCA.CardTypeConfig
ClassMethod ReadDefaultCardTypeConfigByDR(CardTypeDR As %String, SessionStr As %String = "") As %String
{
	;w ##class(web.DHCBL.CARD.UCardPATRegConfig).ReadDefaultCardTypeConfigByDR(2)
	s myXmlData=""
	
	q:(CardTypeDR="") ""
	
	s myConObj=##class(web.DHCEntity.PCA.CardTypeConfig).%New()
	
	s myPatRegInfo=##class(web.DHCBL.CARD.UCardPATRegConfig).GetCardPatRegConfig(SessionStr)
	
	;基本配置
	s myConObj.PatMasFlag = $p(myPatRegInfo,"^",4)
	s myConObj.CardRefFlag = $p(myPatRegInfo,"^",5)
	s myConObj.AccManageFLag =$p(myPatRegInfo,"^",6)
	
	;类型配置
	s myCardDef=##class(User.DHCCardTypeDef).%OpenId(CardTypeDR)
	s myConObj.CardAccountRelation = myCardDef.CTDCardAccountRelation
	s myConObj.CardFareCost = myCardDef.CTDCardFareCost
	s myConObj.FareType = myCardDef.CTDFareType
	s myConObj.GroupRegFlag = "PR"		;GR  or PR
	s myConObj.InfoSource = ""		;="" or ="Web"
	s myConObj.PANoCardRefFlag = myCardDef.CTDPANoCardRefFlag
	s myConObj.PreCardFlag = myCardDef.CTDPreCardFlag
	s myConObj.SearchMasFlag = myCardDef.CTDSearchMasFlag
	s myConObj.SecurityNoFlag = myCardDef.CTDSecurityNoFlag
	s myConObj.StChangeValidateFlag = myCardDef.CTDStChangeValidateFlag
	s myConObj.UseINVType = myCardDef.CTDUseINVType

	s myPEObj=##class(web.DHCBL.Configure.PatEnroll).DHCGetDataObjectBySession(SessionStr)
	if ($IsObject(myPEObj)){
		s myConObj.PatMasFlag = myPEObj.PatMasFlag
		s myConObj.CardRefFlag = myPEObj.CardRefFlag
		s myConObj.AccManageFLag = myPEObj.AccManageFLag
		
		d myPEObj.%Close()
	}

	d myConObj.XMLExportToString(.myXmlData)
	
	d myConObj.%Close()
	d myCardDef.%Close()
	
	q myXmlData
}

ClassMethod ReadGroupConfigByDR(CardTypeDR As %String) As %String
{
	;w ##class(web.DHCBL.CARD.UCardPATRegConfig).ReadGroupConfigByDR(2)
	s myXmlData=""
	
	q:(CardTypeDR="") ""
	
	s myConObj=##class(web.DHCEntity.PCA.CardTypeConfig).%New()
	
	s myXmlData = ..ReadDefaultCardTypeConfigByDR(CardTypeDR)
	
	d myConObj.XMLDeserialize(.myConObj, myXmlData)
	
	s myConObj.GroupRegFlag="GR"
	
	d myConObj.XMLExportToString(.myXmlData)
	
	d myConObj.%Close()
	
	q myXmlData
}

ClassMethod ReadGroupConfigByXMLData(XmlData As %String) As %String
{
	;w ##class(web.DHCBL.CARD.UCardPATRegConfig).ReadGroupConfigByXMLData(my)
	s myXmlData=""
	
	q:(XmlData="") ""
	
	s myConObj=##class(web.DHCEntity.PCA.CardTypeConfig).%New()
	
	d myConObj.XMLDeserialize(.myConObj, XmlData)
	
	s myConObj.GroupRegFlag="GR"
	
	d myConObj.XMLExportToString(.myXmlData)
	
	d myConObj.%Close()
	
	q myXmlData
}

/// 根据综合查询获取
/// 配置信息
/// 人员信息
/// 是否修改标志
ClassMethod ReadConfigByCQU(PAPMIDR As %String = "", CardTypeDR As %String = "", SessionStr As %String = "") As %String
{
	;PAPMIDR   患者的RowID
	;CardTypeDR  办理的当前卡类型
	;
	;w ##class(web.DHCBL.CARD.UCardPATRegConfig).ReadConfigByCQU("12",2,"")
	s ^TMPPATREGCONFIFDFDD=PAPMIDR_","_CardTypeDR_","_ SessionStr
	s myrtn=0
	s myConfiXmlData=""
	s myPatXmlData=""
	s myRepairFlag="Y"
	s myConfingStr=""
	
	q:(CardTypeDR="") myrtn_$c(1)_myConfiXmlData_$c(1)_myPatXmlData_$c(1)_myRepairFlag_$c(1)_myConfingStr_$c(1)
	
	;IDNo , CredTypeDR , CredNo , CardTypeDR As %String = "", ExpStr As %String) As %String
	;s myCheckInfo=##class(web.DHCBL.CARD.UCardRefInfo).CreateCardCheckData(IDNo, CredTypeDR,CredNo,  CardTypeDR, "" )
	s myPAPMIDR=PAPMIDR
	s CardTypeDR=CardTypeDR
	
	q:((myPAPMIDR="")!(CardTypeDR="")) myrtn_$c(1)_myConfiXmlData_$c(1)_myPatXmlData_$c(1)_myRepairFlag_$c(1)_myConfingStr_$c(1)
	
	;解释：myrtn=0  没有检测到信息 可以按照 卡类型原有配置 直接办卡
	;myrtn=-368   	需要绑定卡标志
	;myrtn=-365		患者已经办理过此卡，通知用户，不能办理卡 集团注册时，修改EmployeeCompony字段
	;其他错误，需要提示一下 同时，不能办理卡
	
	;s myrtn=+$p(myCheckInfo,"^",1)
	;同一类型卡只能办理一个注册
	s myrtn=-368
	s myCardRowID=0
	f  s myCardRowID=$o(^DHCCARDi("CF",0, "PAPMICTDR", myPAPMIDR, CardTypeDR, myCardRowID))  q:(myCardRowID="")  d
	.s myCardFlag=$p(^DHCCARD("CF", myCardRowID),"^",10)			;
	.q:(myCardFlag'="N")
	.s myrtn=-365
	
	q:(+myrtn'=-368) myrtn_$c(1)_myConfiXmlData_$c(1)_myPatXmlData_$c(1)_myRepairFlag_$c(1)_myConfingStr_$c(1)
	
	;
	s myPAPMINo = ##Class(web.PAPatMas).GetRegistration(myPAPMIDR)
	
	b	;
	s myDefCTInfo=..ReadDefaultCardTypeConfigByDR(CardTypeDR)
	b	;;
	s myVal = ##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatInfoByPANo(myPAPMINo,"")
	s myPatXmlData=$p(myVal,"^",2)
	
	s myConObj=##class(web.DHCEntity.PCA.CardTypeConfig).%New()
	
	d myConObj.XMLDeserialize(.myConObj, myDefCTInfo)
	if (+myrtn=-368){
		s myConObj.PANoCardRefFlag="Y"		;直接定义卡与 信息建立对照
		s myConObj.SearchMasFlag="Y"		;建立对照， 要求有等记号
		s myConfingStr=myConfingStr_"^"_myConObj.PatMasFlag
		s myConfingStr=myConfingStr_"^"_myConObj.CardRefFlag
		s myConfingStr=myConfingStr_"^"_myConObj.AccManageFLag
		s myConfingStr=myConfingStr_"^"_myConObj.PANoCardRefFlag
		
	}
	
	d myConObj.XMLExportToString(.myConfiXmlData)
	s myRepairFlag= $p(^DHCCARDTYPEDef(CardTypeDR),"^", 34)		;CTD_ValidateMode
	
	q myrtn_$c(1)_myConfiXmlData_$c(1)_myPatXmlData_$c(1)_myRepairFlag_$c(1)_myConfingStr_$c(1)
}

/// 保存建卡页面缓存的DOM对象,用来维护项目必填和页面元素跳转顺序
ClassMethod SaveCardRegDOMCache(obj As %String) As %String
{
  s ^DHCDocConfig("CardRegDOMCache",%session.Get("LOGON.HOSPID"))=obj
  Q 0
}

}
