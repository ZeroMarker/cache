Class dhc.bonus.extend.TargetLeveItem Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = TargetLeveItemID ]
{

Property TargetLeveSetID As dhc.bonus.extend.TargetLeveSet [ Required, SqlColumnNumber = 2 ];

Property BonusTargetID As dhc.bonus.data.BonusTarget [ SqlColumnNumber = 3 ];

Property BonusSubItemID As dhc.bonus.subs.BonusSubItem [ SqlColumnNumber = 4 ];

Property TargetLeveType As %Library.Integer [ Required, SqlColumnNumber = 5 ];

Property ItemOrder As %Library.Integer [ SqlColumnNumber = 6 ];

Property BonusSchemeItemID As dhc.bonus.data.BonusSchemeItem [ SqlColumnNumber = 7 ];

Property remark As %Library.String [ SqlColumnNumber = 8 ];

Index IdxSetIDType On (TargetLeveSetID, TargetLeveType);

Index IdxTargetOrder On (TargetLeveSetID, ItemOrder);

Index IdxTargetLeveSet On TargetLeveSetID;

Storage Default
{
<Data name="TargetLeveItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TargetLeveSetID</Value>
</Value>
<Value name="3">
<Value>BonusTargetID</Value>
</Value>
<Value name="4">
<Value>BonusSubItemID</Value>
</Value>
<Value name="5">
<Value>TargetLeveType</Value>
</Value>
<Value name="6">
<Value>ItemOrder</Value>
</Value>
<Value name="7">
<Value>BonusSchemeItemID</Value>
</Value>
<Value name="8">
<Value>remark</Value>
</Value>
</Data>
<DataLocation>^dhcbsTargetLeveItemD</DataLocation>
<DefaultData>TargetLeveItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsTargetLeveItemD</IdLocation>
<IndexLocation>^dhcbsTargetLeveItemI</IndexLocation>
<StreamLocation>^dhcbsTargetLeveItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
