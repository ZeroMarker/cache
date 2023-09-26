Class dbo.BTSTTSGroupLink Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTST_TSGroupLink ]
{

/// Foreign Key FKRPVisitNumberTCRepeatBTTestCode created via DDL
ForeignKey FKBTSTTSGroupLinkBTSTTSGroup(TSGroupDR) References dbo.BTSTTSGroup(PKBTSTTSGroup) [ SqlName = FK_BTST_TSGroupLink_BTST_TSGroup ];

Index IndexCode On (TSGroupDR, TestSetCode) [ SqlName = Index_Code, Type = index, Unique ];

Index IndexTSCode On (TestSetCode, TSGroupDR) [ SqlName = Index_TSCode, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTSTTSGroupLink On RowID [ PrimaryKey, SqlName = PK_BTSTTSGroupLink, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property TSGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

Property TestSetCode As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 4 ];

Storage Default
{
<Data name="BTSTTSGroupLinkDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TSGroupDR</Value>
</Value>
<Value name="3">
<Value>TestSetCode</Value>
</Value>
</Data>
<DataLocation>^dbo.BTSTTSGroupLinkD</DataLocation>
<DefaultData>BTSTTSGroupLinkDefaultData</DefaultData>
<IdLocation>^dbo.BTSTTSGroupLinkD</IdLocation>
<IndexLocation>^dbo.BTSTTSGroupLinkI</IndexLocation>
<StreamLocation>^dbo.BTSTTSGroupLinkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
