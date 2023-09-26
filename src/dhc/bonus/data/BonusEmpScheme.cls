Class dhc.bonus.data.BonusEmpScheme Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BonusEmpSchemeID ]
{

Property BonusEmpID As dhc.bonus.data.BonusEmployee [ SqlColumnNumber = 2 ];

Property BonusSchemeID As dhc.bonus.data.BonusScheme [ SqlColumnNumber = 3 ];

Property UpdateDate As %Library.TimeStamp [ SqlColumnNumber = 4 ];

Index EmpSchemeIdx On (BonusEmpID, BonusSchemeID);

Storage Default
{
<Data name="BonusEmpSchemeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BonusEmpID</Value>
</Value>
<Value name="3">
<Value>BonusSchemeID</Value>
</Value>
<Value name="4">
<Value>UpdateDate</Value>
</Value>
</Data>
<DataLocation>^dhcbsEmpSchemeD</DataLocation>
<DefaultData>BonusEmpSchemeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsEmpSchemeD</IdLocation>
<IndexLocation>^dhcbsEmpSchemeI</IndexLocation>
<StreamLocation>^dhcbsEmpSchemeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
