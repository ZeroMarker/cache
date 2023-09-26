Class DHCDoc.Interface.Outside.GDHealthCardService.Stratergy.GetGlobalModify Extends (%RegisteredObject, DHCDoc.Interface.Outside.GDHealthCardService.Stratergy.GetGlobal)
{

Method GetGlobal(Para)
{
	S PatientID=$p(Para,"^",1)
	s erhcCardNo=$p(Para,"^",2)
	s Patobj= ##class(User.PAPerson).%OpenId(PatientID)
	s sex=$p($g(^PAPER(PatientID,"ALL")),"^",7)
	s sex=##class(DHCDoc.Interface.Outside.GDHealthCardService.Util).ConvertDataValueTo("sex",sex)
	s nation=$p($g(^PAPER(PatientID,"PER",2)),"^",1)
	s nation=##class(DHCDoc.Interface.Outside.GDHealthCardService.Util).ConvertDataValueTo("nation",nation)
	s validStartdate=""
	s validEnddate=""
	s idInst=""
	s birthday=$p($g(^PAPER(PatientID,"ALL")),"^",6)
	s birthplace=""
	s phone=$p($g(^PAPER(PatientID,"PER",1)),"^",11)
	i phone'="" s phone=##class(DHCDoc.Interface.Outside.GDHealthCardService.Util).GetEncrypt(phone)
	s linkman=Patobj.PAPERForeignId
	i linkman'="" s linkman=##class(DHCDoc.Interface.Outside.GDHealthCardService.Util).GetEncrypt(linkman)
	s telephone=Patobj.PAPERForeignPhone
	i telephone'="" s telephone=##class(DHCDoc.Interface.Outside.GDHealthCardService.Util).GetEncrypt(telephone)
	s maritalstatuscode=Patobj.PAPERMaritalDRGetObjectId()
	s maritalstatuscode=##class(DHCDoc.Interface.Outside.GDHealthCardService.Util).ConvertDataValueTo("maritalstatuscode",maritalstatuscode)
	
	set AddressId=$o(^PAPER(PatientID,"PER","ADD",""),-1)
	set Address=""
	set:AddressId'="" Address=$g(^PAPER(PatientID,"PER","ADD",AddressId))
	s DHCPersonID=$O(^DHCPERSON(0,"PAPERSON",PatientID,0))
	s address=""
	s:DHCPersonID'="" address=$P(^DHCPERSON(DHCPersonID),"^",20)
	s currentAddress=Address
	s scenePhoto=""
	s nationality=Patobj.PAPERCountryDRGetObjectId()
	s language=""
	s appMode="3"
	//s provinceDr=Patobj.PAPERCTProvinceDRGetObjectId()  // 居住省份代码
	s provinceDr=$p($g(^PAPER(PatientID,"PER",4)),"^",2)  // 居住省份代码
	s provinceCode=##class(DHCDoc.Interface.Outside.GDHealthCardService.Util).ConvertDataValueTo("provinceCode",provinceDr)
	s addressCityDr=$p($g(^PAPER(PatientID,"PER",1)),"^",4)  // 居住城市代码
	s addressCityCode=##class(DHCDoc.Interface.Outside.GDHealthCardService.Util).ConvertDataValueTo("addressCityCode",addressCityDr)
	s countyDr=$p($g(^PAPER(PatientID,"PER",4)),"^",9)  // 居住县区代码
	s countyCode=##class(DHCDoc.Interface.Outside.GDHealthCardService.Util).ConvertDataValueTo("countyCode",countyDr)
	s professionTypeDr=$p($g(^PAPER(PatientID,"PER",2)),"^",6)
	s professionType=##class(DHCDoc.Interface.Outside.GDHealthCardService.Util).ConvertDataValueTo("professionType",professionTypeDr)
	
	d Patobj.%Close()
	/*s ^DHCDocEleHealthCard($j,"erhcCardNo")=erhcCardNo
	s ^DHCDocEleHealthCard($j,"sex")=sex
	s ^DHCDocEleHealthCard($j,"nation")=nation
	s ^DHCDocEleHealthCard($j,"validStartdate")=validStartdate
	s ^DHCDocEleHealthCard($j,"validEnddate")=validEnddate
	s ^DHCDocEleHealthCard($j,"idInst")=idInst
	s ^DHCDocEleHealthCard($j,"birthday")=birthday
	s ^DHCDocEleHealthCard($j,"birthplace")=birthplace
	s ^DHCDocEleHealthCard($j,"phone")=phone
	s ^DHCDocEleHealthCard($j,"linkman")=linkman
	s ^DHCDocEleHealthCard($j,"telephone")=telephone
	s ^DHCDocEleHealthCard($j,"maritalstatuscode")=maritalstatuscode
	s ^DHCDocEleHealthCard($j,"address")=address
	s ^DHCDocEleHealthCard($j,"currentAddress")=currentAddress
	s ^DHCDocEleHealthCard($j,"scenePhoto")=scenePhoto
	s ^DHCDocEleHealthCard($j,"nationality")=nationality
	s ^DHCDocEleHealthCard($j,"language")=language
	s ^DHCDocEleHealthCard($j,"appMode")=appMode*/
	s myobj=##class(DHCDoc.Interface.Outside.GDHealthCardService.Entity.vmcardInfo).%New()
	s myobj.erhcCardNo=erhcCardNo
	s myobj.sex=sex
	s myobj.nation=nation
	s myobj.validStartdate=validStartdate
	s myobj.validEnddate=validEnddate
	s myobj.idInst=idInst
	s myobj.birthday=birthday
	s myobj.birthplace=birthplace
	s myobj.phone=phone
	s myobj.linkman=linkman
	s myobj.telephone=telephone
	s myobj.maritalstatuscode=maritalstatuscode
	s myobj.address=address
	s myobj.currentAddress=currentAddress
	s myobj.scenePhoto=scenePhoto
	s myobj.nationality=nationality
	s myobj.language=language
	s myobj.appMode=appMode
	
	s myobj.guardianName=""  // 监护人姓名 加密
	s myobj.guardianIdcode=""  // 监护人身份证号 加密
	s myobj.guardianPhone=""  // 监护人联系方式 加密	
	s myobj.provinceCode=provinceCode  // 居住省份代码
	s myobj.addressCityCode=addressCityCode  // 居住城市代码
	s myobj.countyCode=countyCode  // 居住县区代码
	s myobj.professionType=professionType
	s myobj.recognizeFlag=""
	Q myobj
}

}
