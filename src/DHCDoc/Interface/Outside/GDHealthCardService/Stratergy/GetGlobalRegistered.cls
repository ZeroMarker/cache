Class DHCDoc.Interface.Outside.GDHealthCardService.Stratergy.GetGlobalRegistered Extends (%RegisteredObject, DHCDoc.Interface.Outside.GDHealthCardService.Stratergy.GetGlobal)
{

Method GetGlobal(Para As %String)
{
	//证件类型^证件号码^电子健康卡ID^操作方式
	s idCardTypeCode=$p(Para,"^",1)
	s idCardTypeCode=##class(DHCDoc.Interface.Outside.GDHealthCardService.Util).ConvertDataValueTo("idCardTypeCode",idCardTypeCode)
	s idCode=$p(Para,"^",2)
	i idCode'="" s idCode=##class(DHCDoc.Interface.Outside.GDHealthCardService.Util).GetEncrypt(idCode)
	s appMode=$p(Para,"^",3)
	/*s ^DHCDocEleHealthCard($j,"idCardTypeCode")=idCardTypeCode
	s ^DHCDocEleHealthCard($j,"idCode")=idCode
	s ^DHCDocEleHealthCard($j,"appMode")=appMode*/
	
	s myobj=##class(DHCDoc.Interface.Outside.GDHealthCardService.Entity.registered).%New()
	s myobj.idCardTypeCode=idCardTypeCode
	s myobj.idCode=idCode
	s myobj.appMode=appMode

	q myobj
}

}
