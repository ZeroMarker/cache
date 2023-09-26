Class DHCDoc.Interface.Outside.GDHealthCardService.Stratergy.GetGlobalActiveQrCode Extends (%RegisteredObject, DHCDoc.Interface.Outside.GDHealthCardService.Stratergy.GetGlobal)
{

Method GetGlobal(Para As %String)
{
	s erhcCardNo=$p(Para,"^",1)
	s appMode=$p(Para,"^",2)
	/*s ^DHCDocEleHealthCard($j,"erhcCardNo")=erhcCardNo
	s ^DHCDocEleHealthCard($j,"appMode")=appMode*/
	
	s myobj=##class(DHCDoc.Interface.Outside.GDHealthCardService.Entity.activeQrCode).%New()
	s myobj.erhcCardNo=erhcCardNo
	s myobj.appMode=appMode

	q myobj
}

}
