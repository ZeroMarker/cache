/// 仪器比对计划标识
Class dbo.BTQCCompareTaskEpis Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTQC_CompareTaskEpis ]
{

/// Foreign Key FKBTQCCompareTaskEpisQCCompareTaskDR created via DDL
ForeignKey FKBTQCCompareTaskEpisQCCompareTaskDR(CompareTaskDR) References dbo.BTQCCompareTask(PKBTQCCOMPARETASK) [ SqlName = FK_BTQCCompareTaskEpisQCCompareTaskDR ];

/// Foreign Key FKBTQCCompareTaskEpisMachineParameterDR created via DDL
ForeignKey FKBTQCCompareTaskEpisMachineParameterDR(MachineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_BTQCCompareTaskEpisMachineParameterDR ];

/// DDL Primary Key Specification
Index PKBTQCCOMPARETASKEPIS On RowID [ PrimaryKey, SqlName = PK_BTQC_COMPARETASKEPIS, Type = index, Unique ];

Index IndexTestNum On (CompareTaskDR, TestNum) [ SqlName = Index_TestNum, Type = index ];

Index IndexMachine On (MachineParameterDR, SampleID) [ SqlName = Index_Machine, Type = index ];

Index IndexMaster On (CompareTaskDR, MachineParameterDR, SampleID) [ SqlName = Index_Master, Type = index, Unique ];

/// 主键
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 对比计划
Property CompareTaskDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 仪器
Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 标识号
Property SampleID As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 5 ];

/// 实验次数
Property TestNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

/// 序号
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BTQCCompareTaskEpisDefaultData">
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
<Value>SampleID</Value>
</Value>
<Value name="5">
<Value>TestNum</Value>
</Value>
<Value name="6">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^dbo.BTQCCompareTaskEpisD</DataLocation>
<DefaultData>BTQCCompareTaskEpisDefaultData</DefaultData>
<IdLocation>^dbo.BTQCCompareTaskEpisD</IdLocation>
<IndexLocation>^dbo.BTQCCompareTaskEpisI</IndexLocation>
<StreamLocation>^dbo.BTQCCompareTaskEpisS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
