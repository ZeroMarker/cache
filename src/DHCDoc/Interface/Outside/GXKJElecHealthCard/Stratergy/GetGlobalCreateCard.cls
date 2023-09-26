Class DHCDoc.Interface.Outside.GXKJElecHealthCard.Stratergy.GetGlobalCreateCard Extends (%RegisteredObject, DHCDoc.Interface.Outside.GXKJElecHealthCard.Stratergy.GetGlobal)
{

Method GetGlobal(Para)
{
	s name=$p(Para,"^",1)
	i name'="" s name=##class(DHCDoc.Interface.Outside.GXKJElecHealthCard.Util).GetEncrypt(name)
	s idCode=$p(Para,"^",2)
	i idCode'="" s idCode=##class(DHCDoc.Interface.Outside.GXKJElecHealthCard.Util).GetEncrypt(idCode)
	s idCardTypeCode=$p(Para,"^",3)
	s idCardTypeCode=##class(DHCDoc.Interface.Outside.GXKJElecHealthCard.Util).ConvertDataValueTo("idCardTypeCode",idCardTypeCode)
	s validStartdate=$p(Para,"^",4)
	s validEnddate=$p(Para,"^",5)
	s idInst=$p(Para,"^",6)
	s sex=$p(Para,"^",7)
	s sex=##class(DHCDoc.Interface.Outside.GXKJElecHealthCard.Util).ConvertDataValueTo("sex",sex)
	s nation=$p(Para,"^",8)
	s nation=##class(DHCDoc.Interface.Outside.GXKJElecHealthCard.Util).ConvertDataValueTo("nation",nation)
	s birthday=$p(Para,"^",9)
	s birthplace=$p(Para,"^",10)
	s phone=$p(Para,"^",11)
	i phone'="" s phone=##class(DHCDoc.Interface.Outside.GXKJElecHealthCard.Util).GetEncrypt(phone)
	s linkman=$p(Para,"^",12)
	i linkman'="" s linkman=##class(DHCDoc.Interface.Outside.GXKJElecHealthCard.Util).GetEncrypt(linkman)
	s telephone=$p(Para,"^",13)
	i telephone'="" s telephone=##class(DHCDoc.Interface.Outside.GXKJElecHealthCard.Util).GetEncrypt(telephone)
	s maritalstatuscode=$p(Para,"^",14)
	s maritalstatuscode=##class(DHCDoc.Interface.Outside.GXKJElecHealthCard.Util).ConvertDataValueTo("maritalstatuscode",maritalstatuscode)
	s address=$p(Para,"^",15)
	s currentAddress=$p(Para,"^",16)
	s idPhoto=$p(Para,"^",17)
	s scenePhoto=$p(Para,"^",18)
	s nationality=$p(Para,"^",19)
	s language=$p(Para,"^",20)
	s personnelType=$p(Para,"^",21)
	s multifetalMark=$p(Para,"^",22)
	s multpripleBirths=$p(Para,"^",23)
	s motherName=$p(Para,"^",24)
	i motherName'="" s motherName=##class(DHCDoc.Interface.Outside.GXKJElecHealthCard.Util).GetEncrypt(motherName)
	s motherIdCode=$p(Para,"^",25)
	i motherIdCode'="" s motherIdCode=##class(DHCDoc.Interface.Outside.GXKJElecHealthCard.Util).GetEncrypt(motherIdCode)
	s motherEmpi=$p(Para,"^",26)
	s appMode=$p(Para,"^",27)
	s payAccType=$p(Para,"^",28)	
	s provinceDr=$p(Para,"^",29)  // 居住省份代码
	s provinceCode=##class(DHCDoc.Interface.Outside.GXKJElecHealthCard.Util).ConvertDataValueTo("provinceCode",provinceDr)
	s addressCityDr=$p(Para,"^",30)  // 居住城市代码
	s addressCityCode=##class(DHCDoc.Interface.Outside.GXKJElecHealthCard.Util).ConvertDataValueTo("addressCityCode",addressCityDr)
	s countyDr=$p(Para,"^",31)  // 居住县区代码
	s countyCode=##class(DHCDoc.Interface.Outside.GXKJElecHealthCard.Util).ConvertDataValueTo("countyCode",countyDr)
	s professionTypeDr=$p(Para,"^",32)
	s professionType=##class(DHCDoc.Interface.Outside.GXKJElecHealthCard.Util).ConvertDataValueTo("professionType",professionTypeDr)
		
	/*s ^DHCDocEleHealthCard($j,"name")=name
    s ^DHCDocEleHealthCard($j,"idCode")=idCode
    s ^DHCDocEleHealthCard($j,"idCardTypeCode")=idCardTypeCode
    s ^DHCDocEleHealthCard($j,"validStartdate")=validStartdate
    s ^DHCDocEleHealthCard($j,"validEnddate")=validEnddate
    s ^DHCDocEleHealthCard($j,"idInst")=idInst
    s ^DHCDocEleHealthCard($j,"sex")=sex
    s ^DHCDocEleHealthCard($j,"nation")=nation
    s ^DHCDocEleHealthCard($j,"birthday")=birthday
    s ^DHCDocEleHealthCard($j,"birthplace")=birthplace
    s ^DHCDocEleHealthCard($j,"phone")=phone
    s ^DHCDocEleHealthCard($j,"linkman")=linkman
    s ^DHCDocEleHealthCard($j,"telephone")=telephone
    s ^DHCDocEleHealthCard($j,"maritalstatuscode")=maritalstatuscode
    s ^DHCDocEleHealthCard($j,"address")=address
    s ^DHCDocEleHealthCard($j,"currentAddress")=currentAddress
    s ^DHCDocEleHealthCard($j,"idPhoto")=idPhoto
    s ^DHCDocEleHealthCard($j,"scenePhoto")=scenePhoto
    s ^DHCDocEleHealthCard($j,"nationality")=nationality
    s ^DHCDocEleHealthCard($j,"language")=language
    s ^DHCDocEleHealthCard($j,"personnelType")=personnelType
    s ^DHCDocEleHealthCard($j,"multifetalMark")=multifetalMark
    s ^DHCDocEleHealthCard($j,"multpripleBirths")=multpripleBirths
    s ^DHCDocEleHealthCard($j,"motherName")=motherName
    s ^DHCDocEleHealthCard($j,"motherIdCode")=motherIdCode
    s ^DHCDocEleHealthCard($j,"motherEmpi")=motherEmpi
    s ^DHCDocEleHealthCard($j,"appMode")=appMode
    s ^DHCDocEleHealthCard($j,"payAccType")=payAccType*/
	
	s myobj=##class(DHCDoc.Interface.Outside.GXKJElecHealthCard.Entity.vmcardQRcode).%New()
	s myobj.name=name
	s myobj.idCode=idCode
	s myobj.idCardTypeCode=idCardTypeCode
	s myobj.validStartdate=validStartdate
	s myobj.validEnddate=validEnddate
	s myobj.idInst=idInst
	s myobj.sex=sex
	s myobj.nation=nation
	s myobj.birthday=birthday
	s myobj.phone=phone
	s myobj.linkman=linkman
	s myobj.telephone=telephone
    s myobj.maritalstatuscode=maritalstatuscode
	s myobj.address=address
	s myobj.currentAddress=currentAddress
	s myobj.idPhoto=idPhoto
	s myobj.scenePhoto=scenePhoto
	s myobj.nationality=nationality
	s myobj.language=language
	s myobj.personnelType=personnelType
	s myobj.multifetalMark=multifetalMark
	s myobj.multpripleBirths=multpripleBirths
    s myobj.motherName=motherName
	s myobj.motherIdCode=motherIdCode
	s myobj.motherEmpi=motherEmpi
	s myobj.appMode=appMode
	s myobj.payAccType=payAccType
	
	s myobj.guardianName=""  // 监护人姓名 加密
	s myobj.guardianIdcode=""  // 监护人身份证号 加密
	s myobj.guardianPhone=""  // 监护人联系方式 加密
	s myobj.provinceCode=provinceCode  // 居住省份代码
	s myobj.addressCityCode=addressCityCode  // 居住城市代码
	s myobj.countyCode=countyCode  // 居住县区代码
	s myobj.professionType=professionType
	s myobj.recognizeFlag=""
    q myobj
}

}
