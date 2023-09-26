Class dhc.bonus.extend.UnitLeveItem Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = UnitLeveItemID ]
{

Property UnitLeveSetID As dhc.bonus.extend.UnitLeveSet [ Required, SqlColumnNumber = 2 ];

Property BonusUnitID As dhc.bonus.data.BonusUnit [ Required, SqlColumnNumber = 3 ];

Property ItemOrder As %Library.Integer [ Required, SqlColumnNumber = 4 ];

Property beizhu As %Library.String [ SqlColumnNumber = 5 ];

Index IdxUnitLeveSetID On UnitLeveSetID;

Index IdxUnitLeveOrder On (UnitLeveSetID, ItemOrder);

Storage Default
{
<Data name="UnitLeveItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BonusUnitID</Value>
</Value>
<Value name="3">
<Value>UnitLeveSetID</Value>
</Value>
<Value name="4">
<Value>ItemOrder</Value>
</Value>
<Value name="5">
<Value>beizhu</Value>
</Value>
</Data>
<DataLocation>^dhcbsUnitLeveItemD</DataLocation>
<DefaultData>UnitLeveItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsUnitLeveItemD</IdLocation>
<IndexLocation>^dhcbsUnitLeveItemI</IndexLocation>
<StreamLocation>^dhcbsUnitLeveItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
