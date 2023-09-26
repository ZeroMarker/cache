/// Desc:打印方案DataSet
/// Creator:Candyxu
/// CreateDate:2012-04-28
Class DHCEPRFS.DataSet.PrintSchemeDS Extends %XML.DataSet [ ClassType = "", ProcedureBlock ]
{

/// The class name that contains the query for typed DataSet
Parameter CLASSNAME = "DHCEPRFS.BL.BLPrintScheme";

/// The XML namespace for typed DataSets
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice/PrintSchemeDS";

Parameter QUERYNAME = "GetAllSchemeList";

}
