/// Desc:科室列表
Class DHCEPRFS.DataSet.EDeptListDS Extends %XML.DataSet [ ClassType = "", ProcedureBlock ]
{

/// The class name that contains the query for typed DataSet
Parameter CLASSNAME = "DHCEPRFS.BL.BLDeptList";

/// The XML namespace for typed DataSets
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice/EDeptListDS";

Parameter QUERYNAME = "GetDeptList";

}
