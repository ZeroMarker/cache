Class DHCDoc.Interface.Outside.GDHealthCardService.Stratergy.GetGlobalResetCard Extends (%RegisteredObject, DHCDoc.Interface.Outside.GDHealthCardService.Stratergy.GetGlobal)
{

Method GetGlobal(Para)
{
	S PatientID=$p(Para,"^",1)
	s erhcCardNo=$p(Para,"^",2)
	//s Patobj= ##class(User.PAPerson).%OpenId(PatientID)
	s idCardTypeCode=$p($g(^PAPER(PatientID,"PAT",3)),"^",7)
	s idCardTypeCode=##class(DHCDoc.Interface.Outside.GDHealthCardService.Util).ConvertDataValueTo("idCardTypeCode",idCardTypeCode)
	s idCode=$p($g(^PAPER(PatientID,"PAT",3)),"^",6)
	i idCode'="" s idCode=##class(DHCDoc.Interface.Outside.GDHealthCardService.Util).GetEncrypt(idCode)
	s name=$p($g(^PAPER(PatientID,"ALL")),"^",1)
	i name'="" s name=##class(DHCDoc.Interface.Outside.GDHealthCardService.Util).GetEncrypt(name)
	s appMode="3"
	//d Patobj.%Close()
	/*s ^DHCDocEleHealthCard($j,"erhcCardNo")=erhcCardNo
	s ^DHCDocEleHealthCard($j,"sex")=sex
	s ^DHCDocEleHealthCard($j,"nation")=nation
	s ^DHCDocEleHealthCard($j,"appMode")=appMode*/
	s myobj=##class(DHCDoc.Interface.Outside.GDHealthCardService.Entity.resetVmcardInfoBody).%New()
	s myobj.idCardTypeCode=idCardTypeCode
	s myobj.idCode=idCode
	s myobj.name=name
	s myobj.erhcCardNo=erhcCardNo	
	s myobj.appMode=appMode
	Q myobj
}

}
