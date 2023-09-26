///     
Class dbo.BTGenusUseAnt Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_GenusUseAnt ]
{

/// DDL Primary Key RUGenusDR
Index IndexMaster On (RUGenusDR, AntiWCode) [ SqlName = Index_Master, Type = index, Unique ];

/// Foreign Key FKBTGenusUseAntRUGenusDR created via DDL
ForeignKey FKBTGenusUseAntRUGenusDR(RUGenusDR) References dbo.BTRUGenus(PKBTRUGENUS) [ SqlName = FK_BTGenusUseAntRUGenusDR ];

/// DDL Primary Key Specification
Index PKBTGENUSUSEANT On RowID [ PrimaryKey, SqlName = PK_BT_GENUSUSEANT, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property RUGenusDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

Property AntiWCode As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 4 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="BTGenusUseAntDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RUGenusDR</Value>
</Value>
<Value name="3">
<Value>AntiWCode</Value>
</Value>
<Value name="4">
<Value>Sequence</Value>
</Value>
<Value name="5">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTGenusUseAntD</DataLocation>
<DefaultData>BTGenusUseAntDefaultData</DefaultData>
<IdLocation>^dbo.BTGenusUseAntD</IdLocation>
<IndexLocation>^dbo.BTGenusUseAntI</IndexLocation>
<StreamLocation>^dbo.BTGenusUseAntS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
