/// 名称：EPRservice.dataset.ELISItemListByDateDataSet
/// 描述：根据"就诊号","开始时间(医嘱)","结束时间(医嘱)",查询一段时间内的检验医嘱(返回已经执行的检验套列表)
/// 创建者：HouJ
/// 创建时间：2009-05-26
Class EPRservice.dataset.ELISItemListByDateDataSet Extends %XML.DataSet [ ProcedureBlock ]
{

/// The XML namespace for typed DataSets
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice/ELISItemListByDateDataSet";

/// The class name that contains the query for typed DataSet
Parameter CLASSNAME = "DHCLabToEPR.DHCLabTestSetQuery";

Parameter QUERYNAME = "SelectLISItemListByDate";

}
