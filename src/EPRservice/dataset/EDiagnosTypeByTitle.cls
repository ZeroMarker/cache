/// Creator:Candyxu
/// Date:2012-04-11
/// Desc:诊断类型与可重复模板表题的对应关系
Class EPRservice.dataset.EDiagnosTypeByTitle Extends %XML.DataSet [ Not ProcedureBlock ]
{

/// The class name that contains the query for typed DataSet
Parameter CLASSNAME = "EPRservice.BLL.BLCustomDictory";

/// The XML namespace for typed DataSets
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice/EMRDiagnosDataSet";

Parameter QUERYNAME = "GetDiagnosTypeByTitle";

}
