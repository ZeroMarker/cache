/// Desc:按照MRItem统计明细
/// Creator:yangpeng
/// CreateDate:2015-9-13
Class DHCEPRFS.DataSet.MRPrintDetailDS Extends %XML.DataSet [ ClassType = "", ProcedureBlock ]
{

/// The class name that contains the query for typed DataSet
Parameter CLASSNAME = "DHCEPRFS.BL.BLMRLog";

/// The XML namespace for typed DataSets
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice/MRPrintDetailDS";

Parameter QUERYNAME = "GetPrintDetailByMRItem";

}
