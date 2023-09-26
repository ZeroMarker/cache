/// Creator:Candyxu
/// CreateDete:2012-08
/// Desc:病人列表
Class EPRservice.dataset.EPatientListDataset Extends %XML.DataSet [ Not ProcedureBlock ]
{

/// The class name that contains the query for typed DataSet
Parameter CLASSNAME = "EPRservice.BLL.BLRecordScan";

/// The XML namespace for typed DataSets
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice/EPatientListDataset";

Parameter QUERYNAME = "GetPatientList";

}
