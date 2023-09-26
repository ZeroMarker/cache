///  名称：		EMRservice.BOEMRNavigationLog
///  描述：		病历导航操作日志表BO层
///  编写者：	yejian
///  编写时间：	2021-4-12
Class EMRservice.BOEMRNavigationLog Extends %SOAP.WebService
{

///  TODO: change this to actual network address.
///  URL for invoking the WebService.
///  Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
///  TODO: change this to actual SOAP namespace.
///  SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

///  Name of the WebService. 
Parameter SERVICENAME = "EMRNavigationLogInfo";

/// 添加日志
ClassMethod AddLog(ALog As EMRservice.entity.EEMRNavigationLog) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.EMRNavigationLog).AddLog(ALog)
}

}
