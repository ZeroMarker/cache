/// Desc:按照MRItem统计PagesDS
/// Creator:yangpeng
/// CreateDate:2015-9-13
Class DHCEPRFS.DataSet.MRPrintPagesDS Extends %XML.DataSet [ ClassType = "", ProcedureBlock ]
{

/// The class name that contains the query for typed DataSet
Parameter CLASSNAME = "DHCEPRFS.BL.BLMRLog";

/// The XML namespace for typed DataSets
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice/MRPrintPagesDS";

Parameter QUERYNAME = "GetPrintPagesByMRItem";

}
