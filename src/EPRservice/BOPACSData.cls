/// 名称：EPRservice.BOPACSData
/// 描述：取检查数据业务类
/// 编写者：GuoZT
/// 编写日期：2008-10-15
Class EPRservice.BOPACSData Extends %SOAP.WebService [ Not ProcedureBlock ]
{

Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

Parameter SERVICENAME = "PACSDataInfo";

/// 根据就诊号和起始时间查询病人检查列表
ClassMethod SelectPACSItemListByDate(EpisodeID As %String, StDate As %String, EndDate As %String) As EPRservice.dataset.EPACSInterFaceDataSet [ WebMethod ]
{
 s StDate=$zdh(StDate,3)
 s EndDate =$zdh(EndDate,3)
 Set result=##class(EPRservice.dataset.EPACSInterFaceDataSet).%New()
 Do result.SetArgs(EpisodeID,StDate,EndDate)
 Quit result
}

/// 根据就诊号和检查医嘱子类查询病人检查列表
ClassMethod SelectPACSItemListByACRDR(EpisodeID As %String, ACRDR As %String, EndDate As %String) As EPRservice.dataset.EPACSOEordIDByARCDRDataSet [ WebMethod ]
{
 Set result=##class(EPRservice.dataset.EPACSOEordIDByARCDRDataSet).%New()
 Do result.SetArgs(EpisodeID,ACRDR)
 Quit result
}

/// 根据就诊号、ARCDR、TypeID取检查报告的相应部分
ClassMethod SelectPACSRptByACRDR(EpisodeID As %String, ACRDR As %String, TypeID As %String) As EPRservice.dataset.EPACSRptByARCDRDataSet [ WebMethod ]
{
 Set result=##class(EPRservice.dataset.EPACSRptByARCDRDataSet).%New()
 Do result.SetArgs(EpisodeID,ACRDR,TypeID)
 Quit result
}

/// 根据医嘱RowID查询报告结果
ClassMethod SelectReportByOeordID(OEItemRowID As %String) As EPRservice.dataset.EPACSRptByOEordIDDataSet [ WebMethod ]
{
 Set result=##class(EPRservice.dataset.EPACSRptByOEordIDDataSet).%New()
 Do result.SetArgs(OEItemRowID)
 Quit result
}

/// 取得指定医嘱对应检查报告中项目内容
/// TypeID与返回值对应关系:1-检查所见；2-诊断意见，3-检查方法
ClassMethod SelectPACSItemIndicators(OEItemRowID As %String, TypeID As %String) As EPRservice.dataset.EPACSItemIndicatorsDataSet [ WebMethod ]
{
 Set result=##class(EPRservice.dataset.EPACSItemIndicatorsDataSet).%New()
 Do result.SetArgs(OEItemRowID,TypeID)
 Quit result
}

/// 查询检查医嘱子类
ClassMethod SelectPACSArcCateList() As EPRservice.dataset.EPACSArcCateListDataSet [ WebMethod ]
{
 Set result=##class(EPRservice.dataset.EPACSArcCateListDataSet).%New()
 Do result.SetArgs()
 Quit result
}

/// 取指定医嘱子类下医嘱列表
ClassMethod SelectPACSArcItemList(ArcCateID As %String) As EPRservice.dataset.EPACSArcItemListDataSet [ WebMethod ]
{
 Set result=##class(EPRservice.dataset.EPACSArcItemListDataSet).%New()
 Do result.SetArgs(ArcCateID)
 Quit result
}

/// 取检查报告结构化构成
ClassMethod SelectRptStructure() As EPRservice.dataset.EPACSRptStructureDataSet [ WebMethod ]
{
 Set result=##class(EPRservice.dataset.EPACSRptStructureDataSet).%New()
 Do result.SetArgs()
 Quit result
}

/// Creator: Canyxu 
/// CreatTime:2011-12-06 
/// Desc: 用于查所有检查医嘱
/// Input: SelectID：当Flag为1时SelectID为EpisodeID,否则SelectID为patientID，StDate：开始时间
///        EndDate：结束时间，StartPage：返回分页开始页号，EndPage：返回分页结束页号
/// OutPut:EpisodeDate:就诊日期,EpisodeSection:就诊科室,EpisodeItemName:医嘱名称,OEOrdItemDR:医嘱ID,RptRowID:报告ID	
/// do ##Class(EPRservice.BOPACSData).GetPACSItemListByDate("50729","2008-01-02","2011-01-01","1",1,10,0)
ClassMethod GetPACSItemList(ID As %String, StDate As %String, EndDate As %String, Flag As %String, StartPage As %String, EndPage As %String) As EPRservice.dataset.EPACSListDataset [ WebMethod ]
{
	//<+> added on 2012-08-17 by houj, 处理默认非法默认日期，如 2012/1/1 星期五
	s StDate = $p(StDate, " ", 1)
	s StDate = $Tr(StDate, "/","-")
	s EndDate = $p(EndDate, " ", 1)
	s EndDate = $Tr(EndDate, "/","-")

 s StDate=$zdh(StDate,3)
 s EndDate =$zdh(EndDate,3)
 s result=##class(EPRservice.dataset.EPACSListDataset).%New()
 Do result.SetArgs(ID,StDate,EndDate,Flag,StartPage,EndPage)
 Quit result
}

}
