///     
Class dbo.BTTestSetLayoutMachine Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_TestSetLayoutMachine ]
{

Index IndexMaster On (TestSetDR, WorkGroupMachineDR, TestCodeDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexTestCode On (TestCodeDR, TestSetDR, WorkGroupMachineDR) [ SqlName = Index_TestCode, Type = index ];

/// DDL Primary Key Specification
Index PKBTTESTSETLAYOUT On RowID [ PrimaryKey, SqlName = PK_BT_TESTSETLAYOUT, Type = index, Unique ];

/// Foreign Key FKTestSetLayoutTS created via DDL
ForeignKey FKTestSetLayoutTS(TestSetDR) References dbo.BTTestSet(PKBTTESTSET) [ SqlName = FK_TestSetLayoutTS ];

/// Foreign Key FKTestSetLayoutTestCode created via DDL
ForeignKey FKTestSetLayoutTestCode(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_TestSetLayoutTestCode ];

/// Foreign Key FKTestSetLayoutWorkGroup created via DDL
ForeignKey FKTestSetLayoutWorkGroupMachine(WorkGroupMachineDR) References dbo.BTWorkGroupMachine(PKBTWORKGROUPMACHINE) [ SqlName = FK_TestSetLayoutWorkGroupMachine ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property TestSetDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property WorkGroupMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property Allowed As %Library.Boolean [ SqlColumnNumber = 6 ];

// 1：不让医生看检验界面看

Property IsNotReport As %Library.Boolean [ SqlColumnNumber = 7 ];

Property IsMandatory As %Library.Boolean [ SqlColumnNumber = 8 ];

Property DefResult As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 9 ];

Property DefMidResult As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 10 ];

/// 显示序号 20200337
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

// 1:不让打印

Property IsNotAllowPrint As %Library.Boolean [ InitialExpression = 1, SqlColumnNumber = 12 ];

/// 打印序号 20200337
Property PrintSeq As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

Storage Default
{
<Data name="BTTestSetLayoutMachineDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TestSetDR</Value>
</Value>
<Value name="3">
<Value>WorkGroupMachineDR</Value>
</Value>
<Value name="4">
<Value>TestCodeDR</Value>
</Value>
<Value name="5">
<Value>Allowed</Value>
</Value>
<Value name="6">
<Value>IsNotReport</Value>
</Value>
<Value name="7">
<Value>IsMandatory</Value>
</Value>
<Value name="8">
<Value>DefResult</Value>
</Value>
<Value name="9">
<Value>DefMidResult</Value>
</Value>
<Value name="10">
<Value>Sequence</Value>
</Value>
<Value name="11">
<Value>IsNotAllowPrint</Value>
</Value>
<Value name="12">
<Value>PrintSeq</Value>
</Value>
</Data>
<DataLocation>^dbo.BTTestSetLayoutMachineD</DataLocation>
<DefaultData>BTTestSetLayoutMachineDefaultData</DefaultData>
<IdLocation>^dbo.BTTestSetLayoutMachineD</IdLocation>
<IndexLocation>^dbo.BTTestSetLayoutMachineI</IndexLocation>
<StreamLocation>^dbo.BTTestSetLayoutMachineS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
