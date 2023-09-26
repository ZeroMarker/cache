Class dbo.BTCheckValidLinkLoc Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_CheckValidLinkLoc ]
{

Index IndexMaster On (ValidType, CheckValidRulesID, LocationDR) [ SqlName = Index_Master, Type = index ];

/// Foreign Key FKVisitNumberLocation created via DDL
ForeignKey FKCheckValidLinkLoc(LocationDR) References dbo.BTLocation(PKBTLOCATION) [ SqlName = FK_CheckValidLinkLoc ];

/// DDL Primary Key LocationDR
Index PKBTCHECKVALIDLINKLOC On RowID [ PrimaryKey, SqlName = PK_BT_CHECKVALIDLINKLOC, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property ValidType As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 3 ];

Property CheckValidRulesID As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 4 ];

Property LocationDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BTCheckValidLinkLocDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ValidType</Value>
</Value>
<Value name="3">
<Value>CheckValidRulesID</Value>
</Value>
<Value name="4">
<Value>LocationDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTCheckValidLinkLocD</DataLocation>
<DefaultData>BTCheckValidLinkLocDefaultData</DefaultData>
<IdLocation>^dbo.BTCheckValidLinkLocD</IdLocation>
<IndexLocation>^dbo.BTCheckValidLinkLocI</IndexLocation>
<StreamLocation>^dbo.BTCheckValidLinkLocS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
