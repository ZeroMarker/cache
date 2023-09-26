///     
Class dbo.BTGenuMultipleResistantDef Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_GenuMultipleResistantDef ]
{

/// Foreign Key FKBTGenuMultipleResistantDefRUGenusDR created via DDL
ForeignKey FKBTGenuMultipleResistantDefRUGenusDR(RUGenusDR) References dbo.BTRUGenus(PKBTRUGENUS) [ SqlName = FK_BTGenuMultipleResistantDefRUGenusDR ];

/// DDL Primary Key RUGenusDR
Index IndexMaster On RUGenusDR [ SqlName = Index_Master, Type = index ];

/// DDL Primary Key Specification
Index PKBTGENUMULTIPLERESISTANTDEF On RowID [ PrimaryKey, SqlName = PK_BT_GENUMULTIPLERESISTANTDEF, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property RUGenusDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

Property ResistanceItemCode As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 4 ];

Property ResistanceItemRes As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 5 ];

Property KindMin As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property KindMax As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property LevelNo As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property Conclusion As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 9 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 10 ];

Property AntiWCode As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 11 ];

Storage Default
{
<Data name="BTGenuMultipleResistantDefDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RUGenusDR</Value>
</Value>
<Value name="3">
<Value>ResistanceItemCode</Value>
</Value>
<Value name="4">
<Value>ResistanceItemRes</Value>
</Value>
<Value name="5">
<Value>KindMin</Value>
</Value>
<Value name="6">
<Value>KindMax</Value>
</Value>
<Value name="7">
<Value>LevelNo</Value>
</Value>
<Value name="8">
<Value>Conclusion</Value>
</Value>
<Value name="9">
<Value>Active</Value>
</Value>
<Value name="10">
<Value>AntiWCode</Value>
</Value>
</Data>
<DataLocation>^dbo.BTGenuMultipleResistantDefD</DataLocation>
<DefaultData>BTGenuMultipleResistantDefDefaultData</DefaultData>
<IdLocation>^dbo.BTGenuMultipleResistantDefD</IdLocation>
<IndexLocation>^dbo.BTGenuMultipleResistantDefI</IndexLocation>
<StreamLocation>^dbo.BTGenuMultipleResistantDefS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
