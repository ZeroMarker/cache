/// Creator:      EH
/// CreatDate:    2022-06-20
/// Description:  属性表
Class CT.NUR.MNIS.H8D5P.Property Extends (%Persistent, CT.NUR.MNIS.H8D5P.Base) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Entry As CT.NUR.MNIS.H8D5P.Entry [ Cardinality = parent, Inverse = Property ];

Property Reference As CT.NUR.MNIS.H8D5P.Definition;

Property Name As %String(MAXLEN = 256, TRUNCATE = 1);

Property Value As %String(MAXLEN = 1024, TRUNCATE = 1);

Property Remarks As %String(MAXLEN = 256, TRUNCATE = 1);

Property DataType As %String(TRUNCATE = 1);

Property System As %Boolean;

Index Reference On (Reference, Name);

Storage Default
{
<Data name="PropertyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Reference</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>Value</Value>
</Value>
<Value name="5">
<Value>Remarks</Value>
</Value>
<Value name="6">
<Value>DataType</Value>
</Value>
<Value name="7">
<Value>System</Value>
</Value>
</Data>
<DataLocation>^CT.NUR.MNIS.H8D5P.PropertyD</DataLocation>
<DefaultData>PropertyDefaultData</DefaultData>
<IdLocation>^CT.NUR.MNIS.H8D5P.PropertyD</IdLocation>
<IndexLocation>^CT.NUR.MNIS.H8D5P.PropertyI</IndexLocation>
<StreamLocation>^CT.NUR.MNIS.H8D5P.PropertyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
