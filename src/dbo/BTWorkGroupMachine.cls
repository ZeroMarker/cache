/// BTWorkGroupMachine
Class dbo.BTWorkGroupMachine Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_WorkGroupMachine, StorageStrategy = Default ]
{

/// Foreign Key FKWorkGroupMachine created via DDL
ForeignKey FKWorkGroupMachine(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_WorkGroupMachine ];

/// Foreign Key FKWorkGroupMahineRoom created via DDL
ForeignKey FKWorkGroupMahineRoom(RoomDR) References dbo.BTRoom(PKBTROOM) [ SqlName = FK_WorkGroupMahineRoom ];

/// Foreign Key FKMachineWorkGroup created via DDL
ForeignKey FKMachineWorkGroup(OwnWorkGroupMachineDR) References dbo.BTWorkGroupMachine(PKBTWORKGROUPMACHINE) [ SqlName = FK_MachineWorkGroup ];

Index IndexCode On (WorkGroupDR, Code) [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSequence On (WorkGroupDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

Index IndexShortcut On Shortcut [ SqlName = Index_Shortcut, Type = index ];

/// DDL Primary Key Specification
Index PKBTWORKGROUPMACHINE On RowID [ PrimaryKey, SqlName = PK_BT_WORKGROUPMACHINE, Type = index, Unique ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 名称  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 4 ];

/// 工作组  
Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 负责人  
Property Leader As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 6 ];

/// 联系电话  
Property Telephone As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 7 ];

/// 报告模版  
Property ReportTempl As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 8 ];

/// 所在房间  
Property RoomDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 是否激活  {1:True,0:False}
Property Active As %Library.Boolean [ SqlColumnNumber = 11 ];

/// CommDirect  {UI:单向,BI:双向,LS:装载列表,UP:主动上传}
Property CommDirection As %Library.String(COLLATION = "Exact", MAXLEN = 2) [ SqlColumnNumber = 12 ];

/// WarningTime  
Property WarningTime As %Library.String(COLLATION = "Exact", MAXLEN = 5) [ SqlColumnNumber = 13 ];

/// AcceptFlag  {1:true,0:false}
Property AcceptFlag As %Library.Boolean [ SqlColumnNumber = 14 ];

///       
Property IsAuto As %Library.Boolean [ SqlColumnNumber = 15 ];

///       
Property OwnWorkGroupMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

///       
Property Type As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 17 ];

/// 简称
Property ShortName As %Library.String(COLLATION = "Exact", MAXLEN = 5) [ SqlColumnNumber = 18 ];

/// 是否自动转移标本
Property IsAutoTrans As %Library.Boolean [ SqlColumnNumber = 19 ];

/// 是否自动复查
Property IsAutoReCheck As %Library.Boolean [ SqlColumnNumber = 20 ];

/// 快速检索码
Property Shortcut As %Library.String(COLLATION = "Exact", MAXLEN = 5) [ SqlColumnNumber = 21 ];

/// 排样优先级
Property Priority As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 22 ];

/// 是否分样
Property IsSplit As %Library.Boolean [ SqlColumnNumber = 23 ];

Storage Default
{
<Data name="BTWorkGroupMachineDefaultData">
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
<Value>WorkGroupDR</Value>
</Value>
<Value name="5">
<Value>Leader</Value>
</Value>
<Value name="6">
<Value>Telephone</Value>
</Value>
<Value name="7">
<Value>ReportTempl</Value>
</Value>
<Value name="8">
<Value>RoomDR</Value>
</Value>
<Value name="9">
<Value>Sequence</Value>
</Value>
<Value name="10">
<Value>Active</Value>
</Value>
<Value name="11">
<Value>CommDirection</Value>
</Value>
<Value name="12">
<Value>WarningTime</Value>
</Value>
<Value name="13">
<Value>AcceptFlag</Value>
</Value>
<Value name="14">
<Value>IsAuto</Value>
</Value>
<Value name="15">
<Value>OwnWorkGroupMachineDR</Value>
</Value>
<Value name="16">
<Value>Type</Value>
</Value>
<Value name="17">
<Value>ShortName</Value>
</Value>
<Value name="18">
<Value>IsAutoTrans</Value>
</Value>
<Value name="19">
<Value>IsAutoReCheck</Value>
</Value>
<Value name="20">
<Value>Shortcut</Value>
</Value>
<Value name="21">
<Value>Priority</Value>
</Value>
<Value name="22">
<Value>IsSplit</Value>
</Value>
</Data>
<DataLocation>^dbo.BTWorkGroupMachineD</DataLocation>
<DefaultData>BTWorkGroupMachineDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTWorkGroupMachineD</IdLocation>
<IndexLocation>^dbo.BTWorkGroupMachineI</IndexLocation>
<StreamLocation>^dbo.BTWorkGroupMachineS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
