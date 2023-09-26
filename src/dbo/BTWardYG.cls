Class dbo.BTWardYG Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_WardYG ]
{

/// Foreign Key FKWardLocation created via DDL
ForeignKey FKWardLocation(LocationDR) References dbo.BTLocation(PKBTLOCATION) [ SqlName = FK_WardLocation ];

ForeignKey FKWard(WardDR) References dbo.BTWard(PKBTWARD) [ SqlName = FK_Ward ];

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Index IndexWard On WardDR [ SqlName = Index_Ward, Type = index ];

Index IndexLocation On LocationDR [ SqlName = Index_Location, Type = index ];

Index IndexSequence On Sequence [ SqlName = Index_Sequence, Type = index ];

/// DDL Primary Key Specification
Index PKBTWARDYG On RowID [ PrimaryKey, SqlName = PK_BT_WARDYG, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 150) [ SqlColumnNumber = 4 ];

Property LocationDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property WardDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 8 ];

Property PhoneNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="BTWardYGDefaultData">
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
<Value>LocationDR</Value>
</Value>
<Value name="5">
<Value>WardDR</Value>
</Value>
<Value name="6">
<Value>Sequence</Value>
</Value>
<Value name="7">
<Value>Active</Value>
</Value>
<Value name="8">
<Value>PhoneNo</Value>
</Value>
</Data>
<DataLocation>^dbo.BTWardYGD</DataLocation>
<DefaultData>BTWardYGDefaultData</DefaultData>
<IdLocation>^dbo.BTWardYGD</IdLocation>
<IndexLocation>^dbo.BTWardYGI</IndexLocation>
<StreamLocation>^dbo.BTWardYGS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
