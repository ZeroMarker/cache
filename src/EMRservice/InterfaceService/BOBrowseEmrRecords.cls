Class EMRservice.InterfaceService.BOBrowseEmrRecords Extends %SOAP.WebService
{

Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/interfaceservice";

/// Name of the WebService.
Parameter SERVICENAME = "BOBrowseEmrRecords";

/// Desc:       取病历html
/// Input:      InstanceId 病历ID
///             Type 访问类型
/// Output:     html流
ClassMethod GetRecordHtml(InstanceId As %String, Type As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BLBSParseXML).GetEMRHtmlData(InstanceId,Type).Read()
}

}
