///     
Class dbo.BTWardPosition Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_WardPosition ]
{

Index IndexMaster On (WardYGDR, Sequence, Position) [ SqlName = Index_Master, Type = index ];

/// Foreign Key FKBTWardPositionWardDR created via DDL
ForeignKey FKBTWardPositionWardDR(WardYGDR) References dbo.BTWardYG(PKBTWARDYG) [ SqlName = FK_BTWardPositionWardYGDR ];

/// DDL Primary Key Specification
Index PKBTWARDPOSITION On RowID [ PrimaryKey, SqlName = PK_BT_WARDPOSITION, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property WardYGDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

Property Position As %Library.String(COLLATION = "Exact", MAXLEN = 5) [ SqlColumnNumber = 4 ];

Property Num As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BTWardPositionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WardDR</Value>
</Value>
<Value name="3">
<Value>Position</Value>
</Value>
<Value name="4">
<Value>Num</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
<Value name="6">
<Value>Active</Value>
</Value>
<Value name="7">
<Value>WardYGDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTWardPositionD</DataLocation>
<DefaultData>BTWardPositionDefaultData</DefaultData>
<IdLocation>^dbo.BTWardPositionD</IdLocation>
<IndexLocation>^dbo.BTWardPositionI</IndexLocation>
<StreamLocation>^dbo.BTWardPositionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
