Class EMRservice.entity.ECTProperty Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Property ID As %String(TRUNCATE = 1);

Property PropertyCode As %String(TRUNCATE = 1);

Property PropertyName As %String(TRUNCATE = 1);

Property ParentID As %String(TRUNCATE = 1);

Storage Default
{
<Data name="ECTPropertyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ID</Value>
</Value>
<Value name="3">
<Value>PropertyDesc</Value>
</Value>
<Value name="4">
<Value>PropertyName</Value>
</Value>
</Data>
<DataLocation>^EMRservice.entity.ECTPropertyD</DataLocation>
<DefaultData>ECTPropertyDefaultData</DefaultData>
<IdLocation>^EMRservice.entity.ECTPropertyD</IdLocation>
<IndexLocation>^EMRservice.entity.ECTPropertyI</IndexLocation>
<StreamLocation>^EMRservice.entity.ECTPropertyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
