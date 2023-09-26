/// DHCExternalService.CardInterface.Service.CardService
Class DHCExternalService.CardInterface.Service.CardService Extends %SOAP.WebService [ ProcedureBlock ]
{

/// Parameter LOCATION = "http://172.16.0.33/DTHealth/web/DHCExternalService.CardInterface.Service.CardService.cls";
Parameter LOCATION = "http://127.0.0.1/DTHealth/web/";

/// Name of the WebService.
Parameter SERVICENAME = "CardService";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://tempuri.org";

/// 银医卡接口使用
Method CardManager(Input As %String) As %Stream.GlobalCharacter [ WebMethod ]
{
	s RtnObj=##class(DHCExternalService.CardInterface.CardManager).CardManager(Input)
	do RtnObj.XMLExportToStream(.OutputStream,"Response")
	quit OutputStream
}

/// 就诊卡查询(判断是否能发卡)
Method FindPatientCard(Input As %String) As %Stream.GlobalCharacter [ WebMethod ]
{
	s RtnObj=##class(DHCExternalService.CardInterface.CardManager).FindPatientCard(Input)
	do RtnObj.XMLExportToStream(.OutputStream,"Response")
	quit OutputStream
}

/// 发就诊卡
Method SavePatientCard(Input As %String) As %Stream.GlobalCharacter [ WebMethod ]
{
	set RtnObj=##class(DHCExternalService.CardInterface.CardManager).SavePatientCard(Input)
	do RtnObj.XMLExportToStream(.OutputStream,"Response")
	quit OutputStream
}

/// 收取病例费
Method BuyMedicalBook(Input As %String) As %Stream.GlobalCharacter [ WebMethod ]
{
	s RtnObj=##class(DHCExternalService.CardInterface.CardManager).BuyMedicalBook(Input)
	do RtnObj.XMLExportToStream(.OutputStream,"Response")
	quit OutputStream
}

/// 解除绑定
Method RemoveCardInfo(Input As %String) As %Stream.GlobalCharacter [ WebMethod ]
{
	s RtnObj=##class(DHCExternalService.CardInterface.CardManager).RemoveCardInfo(Input)
	do RtnObj.XMLExportToStream(.OutputStream,"Response")
	quit OutputStream
}

/// 更新病人信息
Method UpdatePatInfo(Input As %String) As %Stream.GlobalCharacter [ WebMethod ]
{
	s RtnObj=##class(DHCExternalService.CardInterface.CardManager).UpdatePatInfo(Input)
	do RtnObj.XMLExportToStream(.OutputStream,"Response")
	quit OutputStream
}

/// 补卡接口
Method CardReissue(Input As %String) As %Stream.GlobalCharacter [ WebMethod ]
{
	s RtnObj=##class(DHCExternalService.CardInterface.CardManager).PartientCardReissue(Input)
	do RtnObj.XMLExportToStream(.OutputStream,"Response")
	quit OutputStream
}

}
