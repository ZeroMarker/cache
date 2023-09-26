/// Desc:       系统参数操作日志BO层
/// Creator:    yejian
/// CreateDate: 2018-6-13
Class EMRservice.BOSysOptionLog Extends %SOAP.WebService
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "SysOptionLogInfo";

ClassMethod SelectALLLog() As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("EMRservice.BL.BLSysOtionLog:SelectALLLog")
	d result.SetArgs()
	q result
}

/// 增加一个日志
ClassMethod CreateLog(aESysOtionLog As EMRservice.entity.ESysOptionLog) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLSysOtionLog).CreateLog(aESysOtionLog)
}

}
