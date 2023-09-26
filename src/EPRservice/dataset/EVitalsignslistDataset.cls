/// 名称：EPRservice.dataset.VitalsignslistDataset
/// 描述：根据EpisodeID查询患者生命体征信息
/// 创建者：Lifengbo
/// 创建时间：2012-05-28
Class EPRservice.dataset.EVitalsignslistDataset Extends %XML.DataSet [ Not ProcedureBlock ]
{

/// The XML namespace for typed DataSets
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice/EVitalsignslistDataset";

/// The class name that contains the query for typed DataSet
Parameter CLASSNAME = "EPRservice.BLL.Vitalsigns.BLVitalsignsData";

Parameter QUERYNAME = "GetVitalsignsData";

}
