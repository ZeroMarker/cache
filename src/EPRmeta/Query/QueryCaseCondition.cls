/// 电子病历综合查询——保存查询方案——查询条件表
/// Creator：牛才才
Class EPRmeta.Query.QueryCaseCondition Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 建立方案名称的索引
Index IdxCNId On CNId;

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

Storage Default
{
<Data name="QueryCaseConditionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ORCode</Value>
</Value>
<Value name="3">
<Value>ItemCode</Value>
</Value>
<Value name="4">
<Value>ItemName</Value>
</Value>
<Value name="5">
<Value>OPCode</Value>
</Value>
<Value name="6">
<Value>txtValue</Value>
</Value>
<Value name="7">
<Value>CNId</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.QueryCaseConditionD</DataLocation>
<DefaultData>QueryCaseConditionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.QueryCaseConditionD</IdLocation>
<IndexLocation>^DHCEPRM.QueryCaseConditionI</IndexLocation>
<StreamLocation>^DHCEPRM.QueryCaseConditionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
