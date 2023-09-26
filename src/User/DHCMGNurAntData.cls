Class User.DHCMGNurAntData Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//消毒数据记录

Relationship AntDataSub As User.DHCMGNurAntDataSub [ Cardinality = children, Inverse = AntParRef ];

Property AntDep As %String(TRUNCATE = 1);

Property AntStDate As %Library.Date(FORMAT = 1);

Property AntEnDate As %Library.Date(FORMAT = 1);

Property AntRecDate As %Library.Date(FORMAT = 1) [ InitialExpression = {+$p($h,",",1)} ];

Property AntRecTime As %Library.Time [ InitialExpression = {+$p($h,",",2)} ];

Property AntRecUser As User.DHCMGPersons;

Index DepDate On (AntStDate, AntDep);

Storage Default
{
<Data name="DHCMGNurAntDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AntDep</Value>
</Value>
<Value name="3">
<Value>AntEnDate</Value>
</Value>
<Value name="4">
<Value>AntRecDate</Value>
</Value>
<Value name="5">
<Value>AntRecTime</Value>
</Value>
<Value name="6">
<Value>AntRecUser</Value>
</Value>
<Value name="7">
<Value>AntStDate</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGNurAntDataD</DataLocation>
<DefaultData>DHCMGNurAntDataDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGNurAntDataD</IdLocation>
<IndexLocation>^User.DHCMGNurAntDataI</IndexLocation>
<StreamLocation>^User.DHCMGNurAntDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
