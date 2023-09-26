/// EPRservice.dataset.ENursingRecordslistDataset
/// 描述：根据EpisodeID查询患者护理记录单信息
/// 创建者：牛才才
/// 创建时间：2014-8-8
Class EPRservice.dataset.ENursingRecordslistDataset Extends %XML.DataSet [ Not ProcedureBlock ]
{

/// The XML namespace for typed DataSets
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice/ENursingRecordslistDataset";

/// The class name that contains the query for typed DataSet
Parameter CLASSNAME = "EPRservice.BLL.NursingRecords.BLNursingRecordsData";

Parameter QUERYNAME = "GetNursingRecordsData";

}
