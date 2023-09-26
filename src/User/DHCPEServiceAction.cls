Class User.DHCPEServiceAction Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract, %Populate) [ ClassType = persistent, SqlTableName = DHC_PE_ServiceAction, StorageStrategy = CacheStorage ]
{

Parameter ClassName = "User.DHCPEServiceAction";

Property ActionCode As %String(TRUNCATE = 1);

Property ActionName As %String(TRUNCATE = 1);

Property ClassName As %String(TRUNCATE = 1);

Property MethodName As %String(TRUNCATE = 1);

Index ActionCode On ActionCode As Upper;

Index ActionName On ActionName As Upper;

Index MethodName On MethodName As Upper;

Index ClassName On ClassName As Upper;

Index UnqIdxCode On ActionCode [ Unique ];

Storage CacheStorage
{
<Data name="DHCPEServiceActionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ActionCode</Value>
</Value>
<Value name="3">
<Value>ActionName</Value>
</Value>
<Value name="4">
<Value>ClassName</Value>
</Value>
<Value name="5">
<Value>MethodName</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEServiceActionD</DataLocation>
<DefaultData>DHCPEServiceActionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPEServiceActionD</IdLocation>
<IndexLocation>^User.DHCPEServiceActionI</IndexLocation>
<StreamLocation>^User.DHCPEServiceActionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
