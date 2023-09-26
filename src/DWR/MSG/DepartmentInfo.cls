Class DWR.MSG.DepartmentInfo Extends (%Persistent, %XML.Adaptor)
{

Parameter XMLNAME = "DeptInfo";

Property departmentId As %String;

Property departmentName As %String;

Property departmentNote As %String;

Property groupId As %String;

Property defaultFlag As %String;

Property locId As %String;

Property locDesc As %String;

Storage Default
{
<Data name="DepartmentInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>departmentId</Value>
</Value>
<Value name="3">
<Value>departmentName</Value>
</Value>
<Value name="4">
<Value>departmentNote</Value>
</Value>
<Value name="5">
<Value>groupId</Value>
</Value>
<Value name="6">
<Value>defaultFlag</Value>
</Value>
<Value name="7">
<Value>locId</Value>
</Value>
<Value name="8">
<Value>locDesc</Value>
</Value>
</Data>
<DataLocation>^DWR.MSG.DepartmentInfoD</DataLocation>
<DefaultData>DepartmentInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DWR.MSG.DepartmentInfoD</IdLocation>
<IndexLocation>^DWR.MSG.DepartmentInfoI</IndexLocation>
<StreamLocation>^DWR.MSG.DepartmentInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
