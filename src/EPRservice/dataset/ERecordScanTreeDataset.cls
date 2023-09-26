/// Creator:Candyxu
/// CreateDate:2012-08
/// Desc:知情同意书目录树列表
Class EPRservice.dataset.ERecordScanTreeDataset Extends %XML.DataSet [ Not ProcedureBlock ]
{

/// The class name that contains the query for typed DataSet
Parameter CLASSNAME = "EPRservice.BLL.BLRecordScan";

/// The XML namespace for typed DataSets
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice/ERecordScanTreeDataset";

Parameter QUERYNAME = "GetRecordScanList";

}
