/// 工作小组关联项目
Class dbo.BTWorkGroupMachineTC Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_WorkGroupMachineTC, StorageStrategy = Default ]
{

Index IndexMaster On (WorkGroupMachineDR, TestCodeDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexTCGroup On (WorkGroupMachineDR, WorkGroupMachineTCGrpDR) [ SqlName = Index_TCGroup, Type = index ];

/// DDL Primary Key Specification
Index PKBTWORKGROUPMACHINETC On RowID [ PrimaryKey, SqlName = PK_BT_WORKGROUPMACHINETC, Type = index, Unique ];

/// Foreign Key FKWorkGroupMachine created via DDL
ForeignKey FKWorkGroupMachine(WorkGroupMachineDR) References dbo.BTWorkGroupMachine(PKBTWORKGROUPMACHINE) [ SqlName = FK_WorkGroupMachine ];

/// Foreign Key FKTestCode created via DDL
ForeignKey FKTestCode(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_TestCode ];

/// Foreign Key FKWorkGroupMachineTCGrp created via DDL
ForeignKey FKWorkGroupMachineTCGrp(WorkGroupMachineTCGrpDR) References dbo.BTWorkGroupMachineTCGrp(PKBTWORKGROUPMACHINETCGRP) [ SqlName = FK_BTWorkGroupMachineTCGrp ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 工作小组  
Property WorkGroupMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 检测项目  
Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 显示序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// 打印序号  
Property PrintSeq As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 工作小组关联项目组  
Property WorkGroupMachineTCGrpDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 双列显示  
Property DoubleColFillType As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 排除打印  {1:true,0:false}
Property ExPrint As %Library.Boolean [ SqlColumnNumber = 9 ];

/// 是否必填  {1:true,0:false}
Property IsRequired As %Library.Boolean [ SqlColumnNumber = 10 ];

/// 是否二次校验  {1:true,0:false}
Property IsReChecked As %Library.Boolean [ SqlColumnNumber = 11 ];

/// 行高  
Property RowHeight As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 12 ];

/// 隐匿无结果项目
Property IsHideNullTC As %Library.Boolean [ SqlColumnNumber = 13 ];

Storage Default
{
<Data name="BTWorkGroupMachineTCDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WorkGroupMachineDR</Value>
</Value>
<Value name="3">
<Value>TestCodeDR</Value>
</Value>
<Value name="4">
<Value>Sequence</Value>
</Value>
<Value name="5">
<Value>PrintSeq</Value>
</Value>
<Value name="6">
<Value>WorkGroupMachineTCGrpDR</Value>
</Value>
<Value name="7">
<Value>DoubleColFillType</Value>
</Value>
<Value name="8">
<Value>ExPrint</Value>
</Value>
<Value name="9">
<Value>IsRequired</Value>
</Value>
<Value name="10">
<Value>IsReChecked</Value>
</Value>
<Value name="11">
<Value>RowHeight</Value>
</Value>
<Value name="12">
<Value>IsHideNullTC</Value>
</Value>
</Data>
<DataLocation>^dbo.BTWorkGroupMachineTCD</DataLocation>
<DefaultData>BTWorkGroupMachineTCDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTWorkGroupMachineTCD</IdLocation>
<IndexLocation>^dbo.BTWorkGroupMachineTCI</IndexLocation>
<StreamLocation>^dbo.BTWorkGroupMachineTCS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
