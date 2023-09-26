///  名称：		EMRservice.BOEMRTemplateCLog
///  描述：		病历展现操作日志表BO层
///  编写者：	yejian
///  编写时间：	2021-4-12
Class EMRservice.BOEMRTemplateCLog Extends %SOAP.WebService
{

///  TODO: change this to actual network address.
///  URL for invoking the WebService.
///  Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
///  TODO: change this to actual SOAP namespace.
///  SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

///  Name of the WebService. 
Parameter SERVICENAME = "EMRTemplateCLogInfo";

/// 添加日志
ClassMethod AddLog(ALog As EMRservice.entity.EEMRTemplateCLog) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEMRTemplateCLog).AddLog(ALog)
}

}
