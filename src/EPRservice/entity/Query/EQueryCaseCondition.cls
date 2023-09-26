Class EPRservice.entity.Query.EQueryCaseCondition Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 操作关系code
Property ORCode As %String(TRUNCATE = 1);

/// 项目code
Property ItemCode As %String(MAXLEN = 256, TRUNCATE = 1);

/// 项目名称
Property ItemName As %String(TRUNCATE = 1);

/// 操作类型code
Property OPCode As %String(TRUNCATE = 1);

/// 值
Property txtValue As %String(TRUNCATE = 1);

/// 方案名称id
Property CNId As %String(TRUNCATE = 1);

}
