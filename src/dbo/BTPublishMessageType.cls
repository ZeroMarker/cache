Class dbo.BTPublishMessageType Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_PublishMessageType ]
{

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSequence On Sequence [ SqlName = Index_Sequence, Type = index ];

/// DDL Primary Key Specification
Index PKBTPUBLISHMESSAGETYPE On RowID [ PrimaryKey, SqlName = PK_BT_PUBLISHMESSAGETYPE, Type = index, Unique ];

/// Foreign Key FKWorkGroupMachine created via DDL
ForeignKey FKWorkGroupDR(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_WorkGroupDR ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

// 标记类别

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 4 ];

// 一个字的简称

Property SName As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 5 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 7 ];

Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="BTPublishMessageTypeDefaultData">
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
<Value>SName</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
<Value name="6">
<Value>Active</Value>
</Value>
<Value name="7">
<Value>WorkGroupDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTPublishMessageTypeD</DataLocation>
<DefaultData>BTPublishMessageTypeDefaultData</DefaultData>
<IdLocation>^dbo.BTPublishMessageTypeD</IdLocation>
<IndexLocation>^dbo.BTPublishMessageTypeI</IndexLocation>
<StreamLocation>^dbo.BTPublishMessageTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
