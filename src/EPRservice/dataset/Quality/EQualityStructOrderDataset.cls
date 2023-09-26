/// Creator：Candyxu
/// CreateDate:20120326
Class EPRservice.dataset.Quality.EQualityStructOrderDataset Extends %XML.DataSet [ ClassType = "", ProcedureBlock ]
{

/// The class name that contains the query for typed DataSet
Parameter CLASSNAME = "EPRmeta.Quality.QualityStruct";

/// The XML namespace for typed DataSets
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice/EQualityStructOrderDataset";

Parameter QUERYNAME = "SELECTALLORDERBYCATEGORYID";

}
