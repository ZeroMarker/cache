Import SQLUser

Class EPRmeta.DictSurgeryOper Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property OperCode As %String;

Property OperDesc As %String;

Property OperAlias As %String;

Property OperType As %String;

Storage Default
{
<Data name="DictSurgeryOperDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OperCode</Value>
</Value>
<Value name="3">
<Value>OperDesc</Value>
</Value>
<Value name="4">
<Value>Alias</Value>
</Value>
<Value name="5">
<Value>OperAlias</Value>
</Value>
<Value name="6">
<Value>OperType</Value>
</Value>
</Data>
<DataLocation>^EPRmeta.DictSurgeryOperD</DataLocation>
<DefaultData>DictSurgeryOperDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^EPRmeta.DictSurgeryOperD</IdLocation>
<IndexLocation>^EPRmeta.DictSurgeryOperI</IndexLocation>
<StreamLocation>^EPRmeta.DictSurgeryOperS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
