Class EPRservice.entity.Query.EQueryCaseName Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 查询方案名称
Property Name As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1);

/// 保存者ID
Property UserID As %String(TRUNCATE = 1);

/// 保存者名称
Property UserName As %String(TRUNCATE = 1);

/// 可见科室ID串
Property CTLocIDStr As %String(COLLATION = "AlphaUp", MAXLEN = 2048, TRUNCATE = 1);

/// 可见安全组ID串
Property GroupIDStr As %String(COLLATION = "AlphaUp", MAXLEN = 2048, TRUNCATE = 1);

}
