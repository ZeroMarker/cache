/// 名称：EPRservice.dataset.EEpisodeListByPIdDataset
/// 描述：按patientID查询一段时间内的就诊信息
/// 创建者：CandyXU
/// 创建时间：2011-05-26
Class EPRservice.dataset.EEpisodeListByPIdDataset Extends %XML.DataSet [ ProcedureBlock ]
{

/// The XML namespace for typed DataSets
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice/EPRservice.dataset.EpisodeListByPIDDataset";

/// The class name that contains the query for typed DataSet
Parameter CLASSNAME = "EPRservice.HISInterface.EpisodeInfo";

Parameter QUERYNAME = "GetEpisodeListByPID";

}
