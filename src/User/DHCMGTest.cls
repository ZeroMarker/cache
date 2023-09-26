Class User.DHCMGTest Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property aa As %String(TRUNCATE = 1);

Storage Default
{
<Data name="DHCMGTestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>aa</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGTestD</DataLocation>
<DefaultData>DHCMGTestDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGTestD</IdLocation>
<IndexLocation>^User.DHCMGTestI</IndexLocation>
<StreamLocation>^User.DHCMGTestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
