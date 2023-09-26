/// 名称: EMRservice.InterfaceService.BOHtmlMedicalRecords
/// 描述: 病历HTML数据获取接口
/// 编写者：yejian
/// 编写日期: 2021-12-23
Class EMRservice.InterfaceService.BOHtmlMedicalRecords Extends %SOAP.WebService
{

Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/interfaceservice";

/// Name of the WebService.
Parameter SERVICENAME = "BOHtmlMedicalRecords";

/// Desc:       根据就诊号获取HTML配置数据
/// Creator:    yejian
/// Createdate: 2021-12-23
/// Input:     	AEpisodeID 就诊号
/// Output:     %XML.DataSet
/// debug:     d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLHtmlMedicalRecords","GetHtmlRecordsByID","67")
ClassMethod GetRecordCategory(AEpisodeID As %String) As %XML.DataSet [ WebMethod ]
{
	s result = ##Class(%XML.DataSet).%New("EMRservice.BL.BLBSEMRBrowse:GetRecordCategory")
	d result.SetArgs(AEpisodeID)
	q result
}

}
