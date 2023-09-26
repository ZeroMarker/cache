/// creator:郭荣勇
/// date:20170524
/// desc:为外部机构建病案信息提供HIS服务接口
Class DHCExternalService.MedicalEPMI.Service.MedicalEPMI Extends %SOAP.WebService [ ProcedureBlock ]
{

/// Parameter LOCATION = "http://10.160.16.131/DTHealth/web/DHCExternalService.MedicalEPMI.Service.MedicalEPMI";
/// Name of the WebService.
Parameter SERVICENAME = "MedicalEPMI";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://tempuri.org";

Method TestNet() As %String [ WebMethod ]
{
	q "OK"
}

/// 由卡号或病人唯一号(注:东华称登记号)查出患者基本信息，当卡号不空时用卡号，卡号为空时用病人唯一号。
Method GetPatInfo(Input As %String) As DHCExternalService.MedicalEPMI.Entity.GetPatInfoRp [ WebMethod ]
{
	s RtnObj=##class(DHCExternalService.MedicalEPMI.Methods).GetPatInfo(Input)
	;d RtnObj.XMLExportToString(.RtnXml,"Response")
	q RtnObj
}

/// 用于外部机构将患者填写的建病案信息提交给HIS。入参描述带（CT）的为代码表属性，需对照传入Rowid
Method BuildMedical(Input As %String) As DHCExternalService.MedicalEPMI.Entity.BuildMedicalRp [ WebMethod ]
{
	q ##class(DHCExternalService.MedicalEPMI.Methods).BuildMedical(Input)
}

}
