Class DWR.Store.LoginInfo Extends (%Persistent, %XML.Adaptor)
{

Property userCode As %String;

Property userName As %String;

Property defaultDeptId As %String;

Property defaultDeptName As %String;

Property defaultGroupId As %String;

Property defaultGroupName As %String;

Property hospitalId As %String;

Property hospitalName As %String;

Property loginDate As %String;

Property loginTime As %String;

Property loginNum As %String;

Property padIP As %String;

Property terminalId As %String;

Index logDate On loginDate;

Index terminalId On terminalId;

Index logDateTerminal On (loginDate, terminalId);

Storage Default
{
<Data name="LoginInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>userCode</Value>
</Value>
<Value name="3">
<Value>userName</Value>
</Value>
<Value name="4">
<Value>departmentId</Value>
</Value>
<Value name="5">
<Value>departmentName</Value>
</Value>
<Value name="6">
<Value>groupId</Value>
</Value>
<Value name="7">
<Value>groupName</Value>
</Value>
<Value name="8">
<Value>hospitalId</Value>
</Value>
<Value name="9">
<Value>hospitalName</Value>
</Value>
<Value name="10">
<Value>loginDate</Value>
</Value>
<Value name="11">
<Value>loginTime</Value>
</Value>
<Value name="12">
<Value>loginNum</Value>
</Value>
<Value name="13">
<Value>padIP</Value>
</Value>
<Value name="14">
<Value>terminalId</Value>
</Value>
<Value name="15">
<Value>defaultDeptId</Value>
</Value>
<Value name="16">
<Value>defaultDeptName</Value>
</Value>
<Value name="17">
<Value>defaultGroupId</Value>
</Value>
<Value name="18">
<Value>defaultGroupName</Value>
</Value>
</Data>
<DataLocation>^DWR.Store.LoginInfoD</DataLocation>
<DefaultData>LoginInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DWR.Store.LoginInfoD</IdLocation>
<IndexLocation>^DWR.Store.LoginInfoI</IndexLocation>
<StreamLocation>^DWR.Store.LoginInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
