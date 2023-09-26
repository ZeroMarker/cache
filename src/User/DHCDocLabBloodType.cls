Class User.DHCDocLabBloodType Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = DHCDocLabBloodType, StorageStrategy = NewStorage1 ]
{

Index LabBloodTypeCode On LabBloodTypeCode;

Property LabBloodTypeCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

Property LabBloodTypeDesc As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

Property LabBloodTypeActiveFlag As %String(TRUNCATE = 1) [ SqlColumnNumber = 4 ];

Storage NewStorage1
{
<Data name="DHCDocLabBloodTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LabBloodTypeCode</Value>
</Value>
<Value name="3">
<Value>LabBloodTypeDesc</Value>
</Value>
<Value name="4">
<Value>LabBloodTypeActiveFlag</Value>
</Value>
</Data>
<DataLocation>^User.DHCDocLabBloodTypeD</DataLocation>
<DefaultData>DHCDocLabBloodTypeDefaultData</DefaultData>
<IdLocation>^User.DHCDocLabBloodTypeD</IdLocation>
<IndexLocation>^User.DHCDocLabBloodTypeI</IndexLocation>
<StreamLocation>^User.DHCDocLabBloodTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
