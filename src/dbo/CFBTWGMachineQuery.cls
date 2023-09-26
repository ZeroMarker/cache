Class dbo.CFBTWGMachineQuery Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = CFBT_WGMachineQuery ]
{

Index IndexMaster On (WorkGroupMachineDR, Code) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexWGMachineSeq On (WorkGroupMachineDR, SeqNum) [ SqlName = Index_WGMachineSeq, Type = index ];

/// Foreign Key FKBBRPHospital created via DDL
ForeignKey FKCFBTWGMachineDR(WorkGroupMachineDR) References dbo.BTWorkGroupMachine(PKBTWORKGROUPMACHINE) [ SqlName = PK_BT_WORKGROUPMACHINE ];

/// DDL Primary Key Specification
Index PKCFBTWGMACHINEQUERY On RowID [ PrimaryKey, SqlName = PK_CFBT_WGMACHINEQUERY, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 名称  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ Required, SqlColumnNumber = 4 ];

/// 工作小组
Property WorkGroupMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 序号  
Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 激活  {1:是,0:否}
Property Active As %Library.Boolean [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="CFBTWGMachineQueryDefaultData">
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
<Value>WorkGroupMachineDR</Value>
</Value>
<Value name="5">
<Value>SeqNum</Value>
</Value>
<Value name="6">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.CFBTWGMachineQueryD</DataLocation>
<DefaultData>CFBTWGMachineQueryDefaultData</DefaultData>
<IdLocation>^dbo.CFBTWGMachineQueryD</IdLocation>
<IndexLocation>^dbo.CFBTWGMachineQueryI</IndexLocation>
<StreamLocation>^dbo.CFBTWGMachineQueryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
