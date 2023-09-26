/// 名称：EPRservice.dataset.ELISItemListByDateDataSet
/// 描述：根据选择的具体医嘱ID，取得本医嘱的检验项目的结果
/// 创建者：HouJ
/// 创建时间：2009-05-26
Class EPRservice.dataset.ELISReportByOeordIDDataSet Extends %XML.DataSet [ ProcedureBlock ]
{

/// The XML namespace for typed DataSets
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice/ELISReportByOeordIDDataSet";

Parameter CLASSNAME = "DHCLabToEPR.DHCLabTestSetQuery";

Parameter QUERYNAME = "SelReportByOeordIDList";

}
