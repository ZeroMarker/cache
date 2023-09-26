/// Creator: Candyxu
/// Create Date: 2012-08
/// Desc: 医生列表
Class EPRservice.dataset.EDoctorListDataset Extends %XML.DataSet [ Not ProcedureBlock ]
{

/// The class name that contains the query for typed DataSet
Parameter CLASSNAME = "EPRservice.BLL.BLRecordScan";

/// The XML namespace for typed DataSets
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice/EDoctorListDataset";

Parameter QUERYNAME = "GetUserListByLocID";

}
