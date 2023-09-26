/// 名称:EPRservice.BOMedRecordData
/// 描述:按照EpisodeID查询患者病历信息
/// 创建者:Lifengbo
/// 创建时间:2012-08-08
Class EPRservice.BOMedRecordData Extends %SOAP.WebService [ Not ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "MedRecordDataService";

/// Creator： Lfb
/// CreatDate： 2012-08-08
/// Description:： 按照EpisodeID查询患者病历信息
/// Table： 
/// Input： EpisodeID:患者EpisodeID;StaDate,EndDate:筛选条件,起始结束日期;ArgStartPage,ArgEndPage:分页筛选结果,从第ArgStartPage条到第ArgEndPage条
/// Output： 查询的历次病历的Title,HappenDate,HappenTime和病历内容
/// Return：	
/// Others： 
/// debugger: d ##class(EPRservice.BOMedRecordData).SelectMedRecordList("77128","1900-01-01","2012-01-01",1,1)
ClassMethod SelectMedRecordList(ArgEpisodeID As %String, ArgStDate As %String, ArgEndDate As %String, ArgStartPage As %String, ArgEndPage As %String) As EPRservice.dataset.EMedRecordListDataSet [ WebMethod ]
{
	s StaDate=$zdh(ArgStDate,3)
	s EndDate=$zdh(ArgEndDate,3)
	s result=##class(EPRservice.dataset.EMedRecordListDataSet).%New()
	d result.SetArgs(ArgEpisodeID,StaDate,EndDate,ArgStartPage,ArgEndPage)
	q result
}

ClassMethod GetMedRecord(AEpisodeID As %String, ARecordFlag, ASelectionFlag, AStartCount As %String, AEndCount As %String) As EPRservice.dataset.EMedRecListDataSet [ WebMethod ]
{
	s result=##class(EPRservice.dataset.EMedRecListDataSet).%New()
	d result.SetArgs(AEpisodeID,ARecordFlag,ASelectionFlag,AStartCount,AEndCount)
	q result
}

}
