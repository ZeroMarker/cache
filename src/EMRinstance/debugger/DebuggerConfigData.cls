Class EMRinstance.debugger.DebuggerConfigData Extends %Persistent
{

Index IdxCode On Code;

Property Name As %String;

Property Code As %String;

Property Expression As %String;

Property ClassName As %String;

Property MethodName As %String;

Property Type As %String;

Property Parameter As %String;

Property Description As %String;

Property IsActive As %String;

Storage Default
{
<Data name="DebuggerConfigDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>Expression</Value>
</Value>
<Value name="5">
<Value>Description</Value>
</Value>
<Value name="6">
<Value>IsActive</Value>
</Value>
<Value name="7">
<Value>ClassName</Value>
</Value>
<Value name="8">
<Value>MethodName</Value>
</Value>
<Value name="9">
<Value>Type</Value>
</Value>
<Value name="10">
<Value>Parameter</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.DebuggerConfigD</DataLocation>
<DefaultData>DebuggerConfigDataDefaultData</DefaultData>
<IdLocation>^DHCEMRI.DebuggerConfigD</IdLocation>
<IndexLocation>^DHCEMRI.DebuggerConfigI</IndexLocation>
<StreamLocation>^DHCEMRI.DebuggerConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
