/// 名称： EPRservice.dataset.ELISDataListDataSet
/// 描述:按就诊号或按病人号分页查询或查询一段时间内的检验医嘱(返回已经执行的检验套列表)
/// 创建者：Candyxu
/// 创建时间：2011-12-08
Class EPRservice.dataset.ELISDataListDataSet Extends %XML.DataSet [ ProcedureBlock ]
{

/// The XML namespace for typed DataSets
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice/ELISDataListDataSet";

/// The class name that contains the query for typed DataSet
Parameter CLASSNAME = "EPRservice.BLL.LISDATA.BLLISDATA";

Parameter QUERYNAME = "GetListDataList";

}
