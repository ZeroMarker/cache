/// 电子病历综合查询——保存查询方案——结果列表
/// Creator：牛才才
Class EPRmeta.Query.QueryCaseResultCols Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 建立方案名称的索引
Index IdxCNId On CNId;

/// 是否默认项："Y":默认 ; "N":非默认
Property IsDisabled As %String(TRUNCATE = 1);

/// 结果列名称
Property ColsName As %String(TRUNCATE = 1);

/// 结果列code
Property ColsCode As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1);

/// 查询方案id
Property CNId As %String(TRUNCATE = 1);

Storage Default
{
<Data name="QueryCaseResultColsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IsDisabled</Value>
</Value>
<Value name="3">
<Value>ColsName</Value>
</Value>
<Value name="4">
<Value>ColsCode</Value>
</Value>
<Value name="5">
<Value>CNId</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.QueryCaseResultColsD</DataLocation>
<DefaultData>QueryCaseResultColsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.QueryCaseResultColsD</IdLocation>
<IndexLocation>^DHCEPRM.QueryCaseResultColsI</IndexLocation>
<StreamLocation>^DHCEPRM.QueryCaseResultColsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
