Class User.DHCDocLabBloodSugarGroup Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = DHCDocLabBloodSugarGroup, StorageStrategy = NewStorage1 ]
{

Index LabBloodSugarGroupName On LabBloodSugarGroupName;

Index LabBloodSugarGroupCode On LabBloodSugarGroupCode;

Property LabBloodSugarGroupCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

Property LabBloodSugarGroupName As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

Storage NewStorage1
{
<Data name="DHCDocLabBloodSugarGroupDefaultData">
<Subscript>"1"</Subscript>
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<Data name="Node1">
<Value name="1">
<Value>LabBloodSugarGroupCode</Value>
</Value>
<Value name="2">
<Value>LabBloodSugarGroupName</Value>
</Value>
</Data>
<DataLocation>^User.DHCDocLabBloodSugarGroupD</DataLocation>
<DefaultData>DHCDocLabBloodSugarGroupDefaultData</DefaultData>
<IdLocation>^User.DHCDocLabBloodSugarGroupD</IdLocation>
<IndexLocation>^User.DHCDocLabBloodSugarGroupI</IndexLocation>
<StreamLocation>^User.DHCDocLabBloodSugarGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
