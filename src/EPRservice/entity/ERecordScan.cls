/// CreateDate:2012-08
/// Desc:知情同意书entity表
Class EPRservice.entity.ERecordScan Extends (%Library.RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

/// 名称
Property Name As %String(MAXLEN = 20, TRUNCATE = 1);

/// 描述
Property Description As %String(MAXLEN = 200, TRUNCATE = 1);

/// 存储位置
Property Postion As %String(MAXLEN = 300, TRUNCATE = 1);

/// 父节点RowID
Property ParentID As %String(TRUNCATE = 1);

/// 操作用户
Property UserID As %String(TRUNCATE = 1);

/// 顺序号
Property Sequence As %Integer;

Property PatientID As %String(MAXLEN = 20, TRUNCATE = 1);

Property EpisodeID As %String(MAXLEN = 20, TRUNCATE = 1);

/// 别名
Property AliasName As %String(MAXLEN = 20, TRUNCATE = 1);

}
