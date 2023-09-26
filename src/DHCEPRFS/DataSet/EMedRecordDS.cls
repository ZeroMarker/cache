/// Desc:病历基本信息DataSet
Class DHCEPRFS.DataSet.EMedRecordDS Extends %XML.DataSet [ ClassType = "", ProcedureBlock ]
{

/// The class name that contains the query for typed DataSet
Parameter CLASSNAME = "DHCEPRFS.BL.BLMRMedRecord";

/// The XML namespace for typed DataSets
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice/EMedRecordDS";

Parameter QUERYNAME = "GetMedRecordInfo";

}
