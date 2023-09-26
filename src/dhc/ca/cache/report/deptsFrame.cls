/// Creator: 王赢赢
/// CreatDate: 2009-1-13
/// Description: 科室收入成本收益明细表
Class dhc.ca.cache.report.deptsFrame Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//Projection DetailReport As %Projection.Java(ROOTDIR = "c:\aaa");

Property deptOrder As %String(TRUNCATE = 1);

Property deptName As %String(TRUNCATE = 1);

Property num As %String(TRUNCATE = 1);

Property leaf As %String(TRUNCATE = 1);

Property par As %String(TRUNCATE = 1);

Storage Default
{
<Data name="deptsFrameDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>deptName</Value>
</Value>
<Value name="3">
<Value>leaf</Value>
</Value>
<Value name="4">
<Value>num</Value>
</Value>
<Value name="5">
<Value>deptOrder</Value>
</Value>
<Value name="6">
<Value>par</Value>
</Value>
</Data>
<DataLocation>^dhc.ca.c.deptsFrameD</DataLocation>
<DefaultData>deptsFrameDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.ca.c.deptsFrameD</IdLocation>
<IndexLocation>^dhc.ca.c.deptsFrameI</IndexLocation>
<StreamLocation>^dhc.ca.c.deptsFrameS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
