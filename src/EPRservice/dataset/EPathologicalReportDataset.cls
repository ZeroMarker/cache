/// EPRservice.dataset.EPathologicalReportDataset
/// 描述：根据EpisodeID或者PatientID查询患者病理报告信息
/// 创建者：牛才才
/// 创建时间：2014-8-12
Class EPRservice.dataset.EPathologicalReportDataset Extends %XML.DataSet
{

/// The XML namespace for typed DataSets
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice/EPathologicalReportDataset";

/// The class name that contains the query for typed DataSet
Parameter CLASSNAME = "EPRservice.BLL.Pathological.BLPathologicalData";

Parameter QUERYNAME = "GetPathologicalReport";

}
