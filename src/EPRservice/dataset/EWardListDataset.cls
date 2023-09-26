/// Creator:Candyxu
/// CreateDate:2012-08
/// Desc:病区列表
Class EPRservice.dataset.EWardListDataset Extends %XML.DataSet [ Not ProcedureBlock ]
{

/// The class name that contains the query for typed DataSet
Parameter CLASSNAME = "EPRservice.BLL.BLRecordScan";

/// The XML namespace for typed DataSets
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice/EWardListDataset";

Parameter QUERYNAME = "GetLocOrWard";

}
