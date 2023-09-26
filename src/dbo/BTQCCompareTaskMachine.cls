/// 仪器比对计划仪器
Class dbo.BTQCCompareTaskMachine Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTQC_CompareTaskMachine ]
{

/// Foreign Key FKBTQCCompareTaskMachineQCCompareTaskDR created via DDL
ForeignKey FKBTQCCompareTaskMachineQCCompareTaskDR(CompareTaskDR) References dbo.BTQCCompareTask(PKBTQCCOMPARETASK) [ SqlName = FK_BTQCCompareTaskMachineQCCompareTaskDR ];

/// Foreign Key FKBTQCCompareTaskMachineMachineParameterDR created via DDL
ForeignKey FKBTQCCompareTaskMachineMachineParameterDR(MachineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_BTQCCompareTaskMachineMachineParameterDR ];

/// DDL Primary Key Specification
Index PKBTQCCOMPARETASKMACHINE On RowID [ PrimaryKey, SqlName = PK_BTQC_COMPARETASKMACHINE, Type = index, Unique ];

Index IndexMaster On (CompareTaskDR, MachineParameterDR) [ SqlName = Index_Master, Type = index, Unique ];

/// 主键
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 对比计划
Property CompareTaskDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 仪器
Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 是否是靶机
Property IsTarget As %Library.Boolean [ SqlColumnNumber = 5 ];

/// 序号
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="BTQCCompareTaskMachineDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CompareTaskDR</Value>
</Value>
<Value name="3">
<Value>MachineParameterDR</Value>
</Value>
<Value name="4">
<Value>IsTarget</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^dbo.BTQCCompareTaskMachineD</DataLocation>
<DefaultData>BTQCCompareTaskMachineDefaultData</DefaultData>
<IdLocation>^dbo.BTQCCompareTaskMachineD</IdLocation>
<IndexLocation>^dbo.BTQCCompareTaskMachineI</IndexLocation>
<StreamLocation>^dbo.BTQCCompareTaskMachineS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
