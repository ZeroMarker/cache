/// 电子病历综合查询——保存查询方案——方案名称表
/// Creator：牛才才
Class EPRmeta.Query.QueryCaseName Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
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

/// 保存者ID的索引
Index IdxUserID On UserID;

Storage Default
{
<Data name="QueryCaseNameDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>UserID</Value>
</Value>
<Value name="4">
<Value>CTLocIDStr</Value>
</Value>
<Value name="5">
<Value>GroupIDStr</Value>
</Value>
<Value name="6">
<Value>UserName</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.QueryCaseNameD</DataLocation>
<DefaultData>QueryCaseNameDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.QueryCaseNameD</IdLocation>
<IndexLocation>^DHCEPRM.QueryCaseNameI</IndexLocation>
<StreamLocation>^DHCEPRM.QueryCaseNameS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
