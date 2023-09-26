///     
Class dbo.BTMCResistanceItem Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTMC_ResistanceItem, StorageStrategy = Default ]
{

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSequence On Sequence [ SqlName = Index_Sequence, Type = index ];

/// DDL Primary Key Specification
Index PKBTMCRESISTANCEITEM On RowID [ PrimaryKey, SqlName = PK_BTMC_RESISTANCEITEM, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 4 ];

Property Wcode As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 5 ];

Property ResFormat As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 6 ];

Property ResItem As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 7 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 9 ];

Property Unit As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 10 ];

Property ISMcPrint As %Library.Boolean [ SqlColumnNumber = 11 ];

Storage Default
{
<Data name="BTMCResistanceItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>CName</Value>
</Value>
<Value name="4">
<Value>Wcode</Value>
</Value>
<Value name="5">
<Value>ResFormat</Value>
</Value>
<Value name="6">
<Value>ResItem</Value>
</Value>
<Value name="7">
<Value>Sequence</Value>
</Value>
<Value name="8">
<Value>Active</Value>
</Value>
<Value name="9">
<Value>Unit</Value>
</Value>
<Value name="10">
<Value>ISMcPrint</Value>
</Value>
</Data>
<DataLocation>^dbo.BTMCResistanceItemD</DataLocation>
<DefaultData>BTMCResistanceItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTMCResistanceItemD</IdLocation>
<IndexLocation>^dbo.BTMCResistanceItemI</IndexLocation>
<StreamLocation>^dbo.BTMCResistanceItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
