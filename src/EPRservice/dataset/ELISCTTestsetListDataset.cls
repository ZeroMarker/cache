/// 名称：EPRservice.dataset.ELISCTTestsetListDataset
/// 描述：取得接收科室下检验套列表
/// 创建者：HouJ
/// 创建时间：2009-05-26
Class EPRservice.dataset.ELISCTTestsetListDataset Extends %XML.DataSet [ ProcedureBlock ]
{

/// The XML namespace for typed DataSets
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice/ELISCTDepartListDataSet";

/// The class name that contains the query for typed DataSet
Parameter CLASSNAME = "DHCLabToEPR.DHCLabTestSetQuery";

Parameter QUERYNAME = "SelectLISCTDepartList";

}
