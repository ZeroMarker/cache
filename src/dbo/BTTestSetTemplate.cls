Class dbo.BTTestSetTemplate Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_TestSetTemplate ]
{

/// Foreign Key TestSetTemplateTestSet created via DDL
ForeignKey FKTestSetTemplateWorkGroup(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_TestSetTemplateWorkGroup ];

/// Foreign Key TestSetTemplateTestSet created via DDL
ForeignKey FKTestSetTemplateTestSet(TestSetDR) References dbo.BTTestSet(PKBTTESTSET) [ SqlName = FK_TestSetTemplateTestSet ];

/// Foreign Key TestSetTemplateTestSet created via DDL
ForeignKey FKTestSetTemplateRowID(TemplateDR) References dbo.BTTemplate(PKBTTEMPLATEROWID) [ SqlName = PK_BTTEMPLATEROWID ];

Index IndexMaster On (TestSetDR, WorkGroupDR, TemplType) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexTSTemplate On (TestSetDR, TemplateDR) [ SqlName = IndexTS_Template, Type = index ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property TestSetDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

Property TemplType As %Library.String(COLLATION = "Exact", MAXLEN = 5) [ SqlColumnNumber = 5 ];

Property TemplText As %Library.String(COLLATION = "Exact", MAXLEN = 32767) [ SqlColumnNumber = 6 ];

Property TemplateDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BTTestSetTemplateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TestSetDR</Value>
</Value>
<Value name="3">
<Value>WorkGroupDR</Value>
</Value>
<Value name="4">
<Value>TemplType</Value>
</Value>
<Value name="5">
<Value>TemplText</Value>
</Value>
<Value name="6">
<Value>TemplateDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTTestSetTemplateD</DataLocation>
<DefaultData>BTTestSetTemplateDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTTestSetTemplateD</IdLocation>
<IndexLocation>^dbo.BTTestSetTemplateI</IndexLocation>
<StreamLocation>^dbo.BTTestSetTemplateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
