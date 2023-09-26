/// 名称:EMRservice.dataset.EEpisodeDataItemDataset
/// 描述:就诊数据项BO
/// 编写者：yejian
/// 编写日期: 2014-2-12
Class EMRservice.dataset.EEpisodeDataItemDataset Extends %XML.DataSet [ ClassType = "", ProcedureBlock ]
{

/// The class name that contains the query for typed DataSet
Parameter CLASSNAME = "EMRservice.BL.BLEpisodeDataItem";

/// The XML namespace for typed DataSets
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice/EReportDataset";

Parameter QUERYNAME = "SELECTALL";

}
