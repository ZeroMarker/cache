/// Desc:查询条件
/// Creator:Candy
Class DHCEPRFS.Entity.EQuery Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", ProcedureBlock ]
{

/// 病案号
Property MedRecordNo As %String(TRUNCATE = 1);

/// 出院开始时间
Property StartDisDate As %String(TRUNCATE = 1);

/// 出院结束时间
Property EndDisDate As %String(TRUNCATE = 1);

/// 出院科室
Property DisLocID As %String(TRUNCATE = 1);

//Property Conditions As %GlobalCharacterStream(LOCATION = "^CacheTempDHCEPRFSQueryStream($J)");

/// 多条件
Property Conditions As %String(TRUNCATE = 1);

//Property ResultColumns As %GlobalCharacterStream(LOCATION = "^CacheTempDHCEPRFSQueryStream($J)");

/// 结果列
Property ResultColumns As %String(TRUNCATE = 1);

}
