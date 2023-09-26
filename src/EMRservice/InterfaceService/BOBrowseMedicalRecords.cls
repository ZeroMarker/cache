Class EMRservice.InterfaceService.BOBrowseMedicalRecords Extends %SOAP.WebService
{

Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/interfaceservice";

/// Name of the WebService.
Parameter SERVICENAME = "BOBrowseMedicalRecords";

/// Desc:       取病历目录
/// Input:      argEpisodeID 就诊号
///             argInternalCategoryID  病历术语目前ID 例如：住院病案首页 HDSD00.11 多个以"^"分隔
/// Output:     <Categorys><Category><Name>病案首页</Name><InstanceID>168||1</InstanceID><InternalID>HDSD00.11</InternalID></Category>……<Categorys>
ClassMethod GetRecordCategory(AEpisodeID As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLBSEMRBrowse).GetRecordCategory(AEpisodeID).Read()
}

}
