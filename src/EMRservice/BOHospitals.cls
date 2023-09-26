///  名称：		EMRservice.BOHospitals
///  描述：		多院区BO层
///  编写者：	yejian
///  编写时间：	2021-6-25
Class EMRservice.BOHospitals Extends %SOAP.WebService
{

///  TODO: change this to actual network address.
///  URL for invoking the WebService.
///  Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
///  TODO: change this to actual SOAP namespace.
///  SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

///  Name of the WebService. 
Parameter SERVICENAME = "HospitalsInfo";

/// 获取该模板下用户模板
/// Debug: ##class(EMRservice.BOHospitals).SelectHospitals()
ClassMethod SelectHospitals() As %XML.DataSet [ WebMethod ]
{
	s result=##class(%XML.DataSet).%New("EMRservice.BL.BLHospitals:SelectHospitals")
	d result.SetArgs()
	q result
}

}
