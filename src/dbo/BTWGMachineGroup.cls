Class dbo.BTWGMachineGroup Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_WGMachineGroup, StorageStrategy = Default ]
{

Index IndexMaster On (WorkGroupMachineDR, CName) [ SqlName = Index_Master, Type = index ];

Index IndexSequence On (WorkGroupMachineDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

/// DDL Primary Key Specification
Index PKBTWGMACHINEGROUPROWID On RowID [ PrimaryKey, SqlName = PK_BT_WGMACHINEGROUPROWID, Type = index, Unique ];

/// Foreign Key FKVisitNumberSpecType created via DDL
ForeignKey FKBTWGMachineGroupSpecType(SpecimenDR) References dbo.BTSpecimen(PKBTSPECIMEN) [ SqlName = FK_BTWGMachineGroupSpecType ];

/// Foreign Key FKVisitNumberReportWorkGroup created via DDL
ForeignKey FKBTWGMachineGroupWGM(WorkGroupMachineDR) References dbo.BTWorkGroupMachine(PKBTWORKGROUPMACHINE) [ SqlName = FK_BTWGMachineGroupWGM ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 工作小组  
Property WorkGroupMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 名称  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ Required, SqlColumnNumber = 4 ];

/// 分组类别  
Property GrpClass As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 5 ];

/// 标本类型  
Property SpecimenDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 开始号  
Property NumStart As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 7 ];

/// 数量  
Property NumSum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 结束号  
Property NumEnd As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 9 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 是否激活  {1:True,0:False}
Property Active As %Library.Boolean [ SqlColumnNumber = 11 ];

Storage Default
{
<Data name="BTWGMachineGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WorkGroupMachineDR</Value>
</Value>
<Value name="3">
<Value>CName</Value>
</Value>
<Value name="4">
<Value>GrpClass</Value>
</Value>
<Value name="5">
<Value>SpecimenDR</Value>
</Value>
<Value name="6">
<Value>NumStart</Value>
</Value>
<Value name="7">
<Value>NumSum</Value>
</Value>
<Value name="8">
<Value>NumEnd</Value>
</Value>
<Value name="9">
<Value>Sequence</Value>
</Value>
<Value name="10">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTWGMachineGroupD</DataLocation>
<DefaultData>BTWGMachineGroupDefaultData</DefaultData>
<IdLocation>^dbo.BTWGMachineGroupD</IdLocation>
<IndexLocation>^dbo.BTWGMachineGroupI</IndexLocation>
<StreamLocation>^dbo.BTWGMachineGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
