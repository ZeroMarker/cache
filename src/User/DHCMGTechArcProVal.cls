Class User.DHCMGTechArcProVal Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property pro As User.DHCMGTechArcPro;

Property proval As %String(TRUNCATE = 1);

Index pro On pro;

Storage Default
{
<Data name="DHCMGTechArcProValDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>pro</Value>
</Value>
<Value name="3">
<Value>proval</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGTechArcProValD</DataLocation>
<DefaultData>DHCMGTechArcProValDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGTechArcProValD</IdLocation>
<IndexLocation>^User.DHCMGTechArcProValI</IndexLocation>
<StreamLocation>^User.DHCMGTechArcProValS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
