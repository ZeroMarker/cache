Class User.DHCMGNurAntDataSub Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Relationship AntParRef As User.DHCMGNurAntData [ Cardinality = parent, Inverse = AntDataSub, Required ];

Property AntItm As User.DHCMGNurAntItm;

Property AntPrevNum As %String(TRUNCATE = 1);

Property AntAfterNum As %String(TRUNCATE = 1);

Property AntMem As %String(TRUNCATE = 1);

Storage Default
{
<Data name="DHCMGNurAntDataSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AntAfterNum</Value>
</Value>
<Value name="3">
<Value>AntItm</Value>
</Value>
<Value name="4">
<Value>AntMem</Value>
</Value>
<Value name="5">
<Value>AntPrevNum</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGNurAntDataSubD</DataLocation>
<DefaultData>DHCMGNurAntDataSubDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGNurAntDataSubD</IdLocation>
<IndexLocation>^User.DHCMGNurAntDataSubI</IndexLocation>
<StreamLocation>^User.DHCMGNurAntDataSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
