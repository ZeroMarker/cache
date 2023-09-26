Class User.DHCMGTechArcPro Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//属性

Property Proper As %String(TRUNCATE = 1);

Property Properdes As %String(TRUNCATE = 1);

Storage Default
{
<Data name="DHCMGTechArcProDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Proper</Value>
</Value>
<Value name="3">
<Value>Properdes</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGTechArcProD</DataLocation>
<DefaultData>DHCMGTechArcProDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGTechArcProD</IdLocation>
<IndexLocation>^User.DHCMGTechArcProI</IndexLocation>
<StreamLocation>^User.DHCMGTechArcProS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
