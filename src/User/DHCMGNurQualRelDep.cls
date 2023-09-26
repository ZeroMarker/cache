Class User.DHCMGNurQualRelDep Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property SSQualDep As %String(TRUNCATE = 1);

Property SSQual As User.DHCNURMGQualItm;

Index dep On SSQualDep;

Storage Default
{
<Data name="DHCMGNurQualRelDepDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SSQualDep</Value>
</Value>
<Value name="3">
<Value>SSQual</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGNurQualRelDepD</DataLocation>
<DefaultData>DHCMGNurQualRelDepDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGNurQualRelDepD</IdLocation>
<IndexLocation>^User.DHCMGNurQualRelDepI</IndexLocation>
<StreamLocation>^User.DHCMGNurQualRelDepS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
