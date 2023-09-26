Class User.DHCMGNurAntItm Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//消毒项目

Property AntDep As %String(TRUNCATE = 1);

Property AntItm As %String(TRUNCATE = 1);

Property AntCat As User.DHCMGNurAntCat;

Property AntMem As %String(TRUNCATE = 1);

Index DepCat On (AntDep, AntCat);

Storage Default
{
<Data name="DHCMGNurAntItmDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AntCat</Value>
</Value>
<Value name="3">
<Value>AntDep</Value>
</Value>
<Value name="4">
<Value>AntItm</Value>
</Value>
<Value name="5">
<Value>AntMem</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGNurAntItmD</DataLocation>
<DefaultData>DHCMGNurAntItmDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGNurAntItmD</IdLocation>
<IndexLocation>^User.DHCMGNurAntItmI</IndexLocation>
<StreamLocation>^User.DHCMGNurAntItmS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
