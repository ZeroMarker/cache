/// Desc:打印方案项目
/// Creator:Candyxu
/// CreateDate:2012-05-06
Class DHCEPRFS.DataSet.SchemeItemDS Extends %XML.DataSet [ ClassType = "", ProcedureBlock ]
{

/// The class name that contains the query for typed DataSet
Parameter CLASSNAME = "DHCEPRFS.BL.BLPrintScheme";

/// The XML namespace for typed DataSets
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice/SchemeItemDS";

Parameter QUERYNAME = "GetSchemeByID";

}
