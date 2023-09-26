/// 名称：EPRservice.dataset.ELISCTCodeListDataset 
/// 描述：取得检验套下检验项目列表
/// 创建者：HouJ
/// 创建时间：2009-05-26
Class EPRservice.dataset.ELISCTCodeListDataset Extends %XML.DataSet [ ProcedureBlock ]
{

/// The class name that contains the query for typed DataSet
Parameter CLASSNAME = "DHCLabToEPR.DHCLabTestSetQuery";

/// The XML namespace for typed DataSets
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice/ELISCTCodeListDataset";

Parameter QUERYNAME = "SelectLISCTCodeList";

}
