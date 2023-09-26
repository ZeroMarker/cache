Class EMRmeta.BindQuery Extends (%Persistent, User.Abstract) [ ClassType = persistent, ProcedureBlock ]
{

Property ClassName As %String(TRUNCATE = 1);

Property Description As %String(TRUNCATE = 1);

Property Name As %String(TRUNCATE = 1);

Property QueryName As %String(TRUNCATE = 1);

Property SingleResult As %String(TRUNCATE = 1);

/// 1:为术语集需要的处方数据
Property Mark As %String(TRUNCATE = 1);

/// 绑定类型(查询:Query/空，方法：Method)
Property BindType As %String(TRUNCATE = 1);

Storage Default
{
<Data name="BindQueryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ClassName</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
<Value name="4">
<Value>Name</Value>
</Value>
<Value name="5">
<Value>QueryName</Value>
</Value>
<Value name="6">
<Value>SingleResult</Value>
</Value>
<Value name="7">
<Value>Mark</Value>
</Value>
<Value name="8">
<Value>BindType</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.BindQueryD</DataLocation>
<DefaultData>BindQueryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.BindQueryD</IdLocation>
<IndexLocation>^DHCEMRM.BindQueryI</IndexLocation>
<StreamLocation>^DHCEMRM.BindQueryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
