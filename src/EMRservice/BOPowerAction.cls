/// Not In Use
Class EMRservice.BOPowerAction Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://192.168.0.15/trakcarejst/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "Privilege.PowerAction";

ClassMethod Add(argPowerAction As EMRservice.entity.EPowerAction) As %String [ WebMethod ]
{
	q ##class(EMRservice.BL.BLPowerAction).Add(argPowerAction)
}

ClassMethod Delete(argPowerActionID As %String) As %String [ WebMethod ]
{
	q ##class(EMRservice.BL.BLPowerAction).Delete(argPowerActionID)
}

ClassMethod Update(argPowerActionID As %String, argPowerAction As EMRservice.entity.EPowerAction) As %String [ WebMethod ]
{
	q ##class(EMRservice.BL.BLPowerAction).Update(argPowerActionID,argPowerAction)
}

ClassMethod GetById(argPowerActionID As %String) As EMRservice.entity.EPowerAction [ WebMethod ]
{
	q ##class(EMRservice.BL.BLPowerAction).GetById(argPowerActionID)
}

ClassMethod GetAllPowerAction() As EMRservice.dataset.EPowerActionDataset [ WebMethod ]
{
 Set result=##class(EMRservice.dataset.EPowerActionDataset).%New()
 Quit result
}

}
