Class User.DHCMGNurStream Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property Str1 As %GlobalCharacterStream;

Storage Default
{
<Data name="DHCMGNurStreamDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Str1</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGNurStreamD</DataLocation>
<DefaultData>DHCMGNurStreamDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGNurStreamD</IdLocation>
<IndexLocation>^User.DHCMGNurStreamI</IndexLocation>
<StreamLocation>^User.DHCMGNurStreamS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
