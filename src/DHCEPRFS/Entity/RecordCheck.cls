Class DHCEPRFS.Entity.RecordCheck Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

/// ID
Property ID As %String(TRUNCATE = 1);

/// 项目名称
Property CheckName As %String(TRUNCATE = 1);

/// 项目描述
Property CheckDesc As %String(TRUNCATE = 1);

/// 连接URL
Property CheckURL As %String(TRUNCATE = 1);

/// 类型
Property CheckType As %String(TRUNCATE = 1);

/// 是否有效
Property IsValid As %String(TRUNCATE = 1);

/// 次序号
Property Sequence As %Integer;

}
