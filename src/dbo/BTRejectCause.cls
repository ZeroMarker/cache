Class dbo.BTRejectCause Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_RejectCause, StorageStrategy = Default ]
{

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSequence On Sequence [ SqlName = Index_Sequence, Type = index ];

/// DDL Primary Key Specification
Index PKBTREJECTCAUSE On RowID [ PrimaryKey, SqlName = PK_BT_REJECTCAUSE, Type = index, Unique ];

/// Foreign Key FKMachineWorkGroup created via DDL
ForeignKey FKBTRejectType(RejectTypeDR) References dbo.BTRejectType(PKBTREJECTTYPE) [ SqlName = FK_BTRejectType ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 4 ];

Property RejectTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 7 ];

/// 是否合格
Property IsQualified As %Library.Boolean [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="BTBTRejectCauseDefaultData">
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
<Value>RejectTypeDR</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
<Value name="6">
<Value>Active</Value>
</Value>
<Value name="7">
<Value>IsQualified</Value>
</Value>
</Data>
<DataLocation>^dbo.BTRejectCauseD</DataLocation>
<DefaultData>BTBTRejectCauseDefaultData</DefaultData>
<IdLocation>^dbo.BTRejectCauseD</IdLocation>
<IndexLocation>^dbo.BTRejectCauseI</IndexLocation>
<StreamLocation>^dbo.BTRejectCauseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
