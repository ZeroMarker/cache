/// 名称： EPRservice.dataset.EPACSListDataset
/// 描述:按就诊号或按病人号分页查询或查询一段时间内的检查医嘱(返回已经执行的检查套列表)
/// 创建者：Candyxu
/// 创建时间：2011-12-08
Class EPRservice.dataset.EPACSListDataset Extends %XML.DataSet [ ProcedureBlock ]
{

/// The XML namespace for typed DataSets
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice/EPACSListDataset";

/// The class name that contains the query for typed DataSet
Parameter CLASSNAME = "EPRservice.BLL.PACSDATA.BLPACSData";

Parameter QUERYNAME = "GetPACSListItems";

}
