/// 名称：EPRservice.dataset.ELISCTDepartListDataSet
/// 描述：取得检验项目接收科室列表
/// 创建者：HouJ
/// 创建时间：2009-05-26
Class EPRservice.dataset.ELISCTDepartListDataSet Extends %XML.DataSet [ ProcedureBlock ]
{

/// The XML namespace for typed DataSets
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice/ELISCTDepartListDataSet";

/// The class name that contains the query for typed DataSet
Parameter CLASSNAME = "DHCLabToEPR.DHCLabTestSetQuery";

Parameter QUERYNAME = "SelectLISCTDepartList";

}
