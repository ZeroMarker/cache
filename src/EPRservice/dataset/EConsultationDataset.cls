/// EPRservice.dataset.EConsultationDataset
/// 描述：根据EpisodeID或者PatientID查询患者会诊信息
/// 创建者：牛才才
/// 创建时间：2014-11-24
Class EPRservice.dataset.EConsultationDataset Extends %XML.DataSet [ Not ProcedureBlock ]
{

/// The XML namespace for typed DataSets
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice/EConsultationDataset";

/// The class name that contains the query for typed DataSet
Parameter CLASSNAME = "EPRservice.BLL.Consultation.BLConsultationData";

Parameter QUERYNAME = "GetConsultationData";

}
