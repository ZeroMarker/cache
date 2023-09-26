/// SH支出项目计提系数BonusSubExpendRate
Class dhc.bonus.subs.BonusSubExpendRate Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BonusSubExpendRateID ]
{

Property BonusUnit As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

Property BonusSubItem As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

Property CalculateUnit As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ Required, SqlColumnNumber = 4 ];

Property CalculateRate As %Library.Float [ Required, SqlColumnNumber = 5 ];

Property ExecuteRate As %Library.Float [ Required, SqlColumnNumber = 6 ];

Property CalculateRate1 As %Library.Float [ SqlColumnNumber = 7 ];

Property ExecuteRate1 As %Library.Float [ SqlColumnNumber = 8 ];

Property ItemPrice As %Library.Float [ SqlColumnNumber = 9 ];

Property ItemType As %Library.String [ SqlColumnNumber = 10 ];

Property CalculateRate2 As %Library.Float [ SqlColumnNumber = 11 ];

Property ExecuteRate2 As %Library.Float [ SqlColumnNumber = 12 ];

Property SubItemName As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 13 ];

Property BonusSubItemID As dhc.bonus.subs.BonusSubItem [ SqlColumnNumber = 14 ];

Index sbItem On (BonusUnit, BonusSubItem);

Storage Default
{
<Data name="BonusSubExpendRateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BonusSubItem</Value>
</Value>
<Value name="3">
<Value>BonusUnit</Value>
</Value>
<Value name="4">
<Value>CalculateRate</Value>
</Value>
<Value name="5">
<Value>CalculateUnit</Value>
</Value>
<Value name="6">
<Value>ExecuteRate</Value>
</Value>
<Value name="7">
<Value>CalculateRate1</Value>
</Value>
<Value name="8">
<Value>ExecuteRate1</Value>
</Value>
<Value name="9">
<Value>ItemPrice</Value>
</Value>
<Value name="10">
<Value>ItemType</Value>
</Value>
<Value name="11">
<Value>CalculateRate2</Value>
</Value>
<Value name="12">
<Value>ExecuteRate2</Value>
</Value>
<Value name="13">
<Value>SubItemName</Value>
</Value>
<Value name="14">
<Value>BonusSubItemID</Value>
</Value>
</Data>
<DataLocation>^dhcbsSubExpendRateD</DataLocation>
<DefaultData>BonusSubExpendRateDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsSubExpendRateD</IdLocation>
<IndexLocation>^dhcbsSubExpendRateI</IndexLocation>
<StreamLocation>^dhcbsSubExpendRateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
