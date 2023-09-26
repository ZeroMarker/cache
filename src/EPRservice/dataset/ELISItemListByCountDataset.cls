/// 名称：EPRservice.dataset.ELISItemListByCount
/// 描述:查询一段时间内的检验医嘱(返回已经执行的检验套列表)
/// 创建者：HouJ
/// 创建时间：2009-09-09
Class EPRservice.dataset.ELISItemListByCountDataset Extends %XML.DataSet [ ProcedureBlock ]
{

/// The XML namespace for typed DataSets
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice/ELISItemListByCountDataset";

/// The class name that contains the query for typed DataSet
Parameter CLASSNAME = "DHCLabToEPR.DHCLabTestSetQuery";

Parameter QUERYNAME = "SelectLISItemListByCount";

}
