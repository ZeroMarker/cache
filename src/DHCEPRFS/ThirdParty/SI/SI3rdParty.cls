Class DHCEPRFS.ThirdParty.SI.SI3rdParty Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SI3rdParty";

/// Debug:	w ##Class(DHCEPRFS.SI.SI3rdParty).GetEpisodeByMedRecord("500306")
/// Desc: 根据病案号查询归档的就诊信息
/// Input: AMedRecordNo - 病案号
/// Output: 包含病案号，姓名，性别，出院日期，出院科室的DataSet
ClassMethod GetEpisodeByMedRecord(AMedRecordNo) As %XML.DataSet [ WebMethod ]
{
	s obj = ##Class(%XML.DataSet).%New("DHCEPRFS.ThirdParty.BL.BLGetEpisodeInfo:GetEpisodeByMedRecord")
	d obj.SetArgs(AMedRecordNo,"","")
	q obj
}

/// Debug:	w ##Class(DHCEPRFS.SI.SI3rdParty).GetEpisodeByDisDateRange("2011-1-1","2016-7-12")
/// Desc: 根据出院日期范围查询归档的就诊信息
/// Input: AStartDisDate - 出院日期起始，AEndDisDate - 出院日期终止
/// 			日期格式为 YYYY-MM-DD
/// Output: 包含病案号，姓名，性别，出院日期，出院科室的DataSet
ClassMethod GetEpisodeByDisDateRange(AStartDisDate As %String, AEndDisDate As %String) As %XML.DataSet [ WebMethod ]
{
	s obj = ##Class(%XML.DataSet).%New("DHCEPRFS.ThirdParty.BL.BLGetEpisodeInfo:GetEpisodeByMedRecord")
	d obj.SetArgs("",AStartDisDate,AEndDisDate)
	q obj
}

}
