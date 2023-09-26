/// 医嘱关联工作小组
Class dbo.BTTestSetWorkGroupMachine Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_TestSetWorkGroupMachine, StorageStrategy = Default ]
{

/// Foreign Key FKTestSetWorkGroupTc created via DDL
ForeignKey FKTestSetWorkGroupTc(TestSetDR) References dbo.BTTestSet(PKBTTESTSET) [ SqlName = FK_TestSetWorkGroupTc ];

/// Foreign Key FKTestSetWorkGroupWg created via DDL
ForeignKey FKTestSetWorkGroupWg(WorkGroupMachineDR) References dbo.BTWorkGroupMachine(PKBTWORKGROUPMACHINE) [ SqlName = FK_TestSetWorkGroupWg ];

Index IndexMaster On (TestSetDR, WorkGroupMachineDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexWorkGroupMachine On (WorkGroupMachineDR, TestSetDR) [ SqlName = Index_WorkGroupMachine, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTTESTSETWORKGROUPMACHINE On RowID [ PrimaryKey, SqlName = PK_BT_TESTSETWORKGROUPMACHINE, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 医嘱名称  
Property TestSetDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 工作小组  
Property WorkGroupMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 是否默认  {1:true,0:false}
Property IsDefault As %Library.Boolean [ SqlColumnNumber = 5 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 是否激活  {1:true,0:false}
Property Active As %Library.Boolean [ SqlColumnNumber = 7 ];

/// 允许打印  
Property AlowedPrint As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 8 ];

/// 不允许格式  
Property NoAlowedFormula As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="BTTestSetWorkGroupMachineDefaultData">
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
<Value>IsDefault</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
<Value name="6">
<Value>Active</Value>
</Value>
<Value name="7">
<Value>AlowedPrint</Value>
</Value>
<Value name="8">
<Value>NoAlowedFormula</Value>
</Value>
</Data>
<DataLocation>^dbo.BTTestSetWorkGroupMachineD</DataLocation>
<DefaultData>BTTestSetWorkGroupMachineDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTTestSetWorkGroupMachineD</IdLocation>
<IndexLocation>^dbo.BTTestSetWorkGroupMachineI</IndexLocation>
<StreamLocation>^dbo.BTTestSetWorkGroupMachineS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
