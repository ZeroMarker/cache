Class dbo.BTSTTIGroupLink Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTST_TIGroupLink ]
{

/// Foreign Key FKRPVisitNumberTCRepeatBTTestCode created via DDL
ForeignKey FKBTSTTIGroupLinkBTSTTIGroup(TIGroupDR) References dbo.BTSTTIGroup(PKBTSTTIGroup) [ SqlName = FK_BTST_TIGroupLink_BTST_TIGroup ];

Index IndexCode On (TIGroupDR, TestItemCode) [ SqlName = Index_Code, Type = index, Unique ];

Index IndexTCCode On (TestItemCode, TIGroupDR) [ SqlName = Index_TCCode, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTSTTIGroupLink On RowID [ PrimaryKey, SqlName = PK_BTST_TIGroupLink, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property TIGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

Property TestItemCode As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 4 ];

Storage Default
{
<Data name="BTSTTIGroupLinkDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TIGroupDR</Value>
</Value>
<Value name="3">
<Value>TestItemCode</Value>
</Value>
</Data>
<DataLocation>^dbo.BTSTTIGroupLinkD</DataLocation>
<DefaultData>BTSTTIGroupLinkDefaultData</DefaultData>
<IdLocation>^dbo.BTSTTIGroupLinkD</IdLocation>
<IndexLocation>^dbo.BTSTTIGroupLinkI</IndexLocation>
<StreamLocation>^dbo.BTSTTIGroupLinkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
