/// 名称： ERPservice.dataset.EASREpisodeListDataSet
/// 描述:按就诊号分页查询或查询一段时间内的语音文件
/// 创建者：LiangWeixi
/// 创建时间：2016-03-28
Class EPRservice.dataset.EASREpisodeListDataSet Extends %XML.DataSet [ ProcedureBlock ]
{

/// The XML namespace for typed DataSets
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice/EASREpisodeListDataSet";

/// The class name that contains the query for typed DataSet
Parameter CLASSNAME = "EPRservice.BLL.ASR.BLLASRDATA";

Parameter QUERYNAME = "GetASREpisodeList";

}
