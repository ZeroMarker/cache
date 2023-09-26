Class dbo.BTTSMaterialLayout Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_TSMaterialLayout ]
{

/// Foreign Key FKTSMaterialLayoutTc created via DDL
ForeignKey FKTSMaterialLayoutTc(TestSetDR) References dbo.BTTestSet(PKBTTESTSET) [ SqlName = FK_TSMaterialLayoutTc ];

/// Foreign Key FKWorkGroup created via DDL
ForeignKey FKWorkGroup(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_WorkGroup ];

/// Foreign Key FKTestCode created via DDL
ForeignKey FKTestCode(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_TestCode ];

Index IndexMaster On (TestSetDR, WorkGroupDR, TestCodeDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexTestCode On (TestCodeDR, TestSetDR, WorkGroupDR) [ SqlName = Index_TestCode, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTTSMATERIALLAYOUT On RowID [ PrimaryKey, SqlName = PK_BT_TSMATERIALLAYOUT, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property TestSetDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property DefaultNotes As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 6 ];

Property IsMandatory As %Library.Boolean [ SqlColumnNumber = 7 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="BTTSMaterialLayoutDefaultData">
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
<Value>TestCodeDR</Value>
</Value>
<Value name="5">
<Value>DefaultNotes</Value>
</Value>
<Value name="6">
<Value>IsMandatory</Value>
</Value>
<Value name="7">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^dbo.BTTSMaterialLayoutD</DataLocation>
<DefaultData>BTTSMaterialLayoutDefaultData</DefaultData>
<IdLocation>^dbo.BTTSMaterialLayoutD</IdLocation>
<IndexLocation>^dbo.BTTSMaterialLayoutI</IndexLocation>
<StreamLocation>^dbo.BTTSMaterialLayoutS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
