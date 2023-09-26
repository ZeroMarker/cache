Class DHCDoc.Interface.Outside.GXKJElecHealthCard.Stratergy.GetGlobalPersonInfoByQrCode Extends (%RegisteredObject, DHCDoc.Interface.Outside.GXKJElecHealthCard.Stratergy.GetGlobal, DHCDoc.Interface.Outside.GXKJElecHealthCard.Parameter)
{

Method GetGlobal(Para As %String)
{
	s qrCode=$p(Para,"^",1)
	s terminalCode=$p(Para,"^",2)
	s medStepCode=$p(Para,"^",3)
	s appMode=$p(Para,"^",4)

	/*s ^DHCDocEleHealthCard($j,"qrCode")=qrCode
	s ^DHCDocEleHealthCard($j,"terminalCode")=terminalCode
	s ^DHCDocEleHealthCard($j,"medStepCode")=medStepCode
	s ^DHCDocEleHealthCard($j,"appMode")=appMode*/
	
	s myobj=##class(DHCDoc.Interface.Outside.GXKJElecHealthCard.Entity.personInfoByQrCode).%New()
	s myobj.qrCode=qrCode // 居民健康电子卡二维码信息
	s myobj.terminalCode=terminalCode  // 识读终端编码 需传输在卡管系统中注册过的设备码
	s myobj.terminalCode=..#terminalCode
	s myobj.medStepCode=medStepCode // 诊疗环节编码	参照诊疗环节编码表
	s myobj.appMode=appMode // 操作方式 3

	q myobj
}

}
