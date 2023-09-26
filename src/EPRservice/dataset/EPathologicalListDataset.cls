/// EPRservice.dataset.EPathologicalListDataset
/// 描述：根据EpisodeID或者PatientID查询患者病理报告信息
/// 创建者：牛才才
/// 创建时间：2014-8-12
Class EPRservice.dataset.EPathologicalListDataset Extends %XML.DataSet
{

/// The XML namespace for typed DataSets
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice/EPathologicalListDataset";

/// The class name that contains the query for typed DataSet
Parameter CLASSNAME = "EPRservice.BLL.Pathological.BLPathologicalData";

Parameter QUERYNAME = "GetPathologicalOrder";

}
