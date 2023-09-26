///     
Class dbo.BTMicRecordTemplate Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_MicRecordTemplate ]
{

/// Foreign Key FKBTMicRecordTemplateTestSetDR created via DDL
ForeignKey FKBTMicRecordTemplateTestSetDR(TestSetDR) References dbo.BTTestSet(PKBTTESTSET) [ SqlName = FK_BTMicRecordTemplateTestSetDR ];

/// DDL Primary Key Specification
Index PKBTMICRECORDTEMPLATE On RowID [ PrimaryKey, SqlName = PK_BT_MICRECORDTEMPLATE, Type = index, Unique ];

Index IndexTestSetDR On TestSetDR [ SqlName = Index_TestSetDR, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property TestSetDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property TemplateCode As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 4 ];

Storage Default
{
<Data name="BTMicRecordTemplateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TestSetDR</Value>
</Value>
<Value name="3">
<Value>TemplateCode</Value>
</Value>
</Data>
<DataLocation>^dbo.BTMicRecordTemplateD</DataLocation>
<DefaultData>BTMicRecordTemplateDefaultData</DefaultData>
<IdLocation>^dbo.BTMicRecordTemplateD</IdLocation>
<IndexLocation>^dbo.BTMicRecordTemplateI</IndexLocation>
<StreamLocation>^dbo.BTMicRecordTemplateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
