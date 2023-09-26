Class EPRservice.entity.Query.EQueryCaseResultCols Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 是否默认项："Y":默认 ; "N":非默认
Property IsDisabled As %String(TRUNCATE = 1);

/// 结果列名称
Property ColsName As %String(TRUNCATE = 1);

/// 结果列code
Property ColsCode As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1);

/// 查询方案id
Property CNId As %String(TRUNCATE = 1);

}
