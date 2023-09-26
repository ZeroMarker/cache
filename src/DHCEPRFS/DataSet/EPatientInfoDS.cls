/// Desc:病历基本信息DataSet
/// Creator:Candyxu
/// CreateDate:2012-04-28
Class DHCEPRFS.DataSet.EPatientInfoDS Extends %XML.DataSet [ ClassType = "", ProcedureBlock ]
{

/// The class name that contains the query for typed DataSet
Parameter CLASSNAME = "DHCEPRFS.BL.HISInfo.BLPatientInfo";

/// The XML namespace for typed DataSets
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice/EPatientInfoDS";

Parameter QUERYNAME = "GetPatientInfo";

}
