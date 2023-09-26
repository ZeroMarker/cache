/// 仪器比对计划
Class dbo.BTQCCompareTask Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTQC_CompareTask ]
{

/// Foreign Key FKBTQCCompareTaskWorkGroupDR created via DDL
ForeignKey FKBTQCCompareTaskWorkGroupDR(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_BTQCCompareTaskWorkGroupDR ];

/// DDL Primary Key Specification
Index PKBTQCCOMPARETASK On RowID [ PrimaryKey, SqlName = PK_BTQC_COMPARETASK, Type = index, Unique ];

Index IndexMaster On (WorkGroupDR, Code) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSequence On (WorkGroupDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

/// 主键
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 名称
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 60) [ SqlColumnNumber = 4 ];

/// 工作组
Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 序号
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 激活
Property Active As %Library.Boolean [ SqlColumnNumber = 7 ];

/// 测试次数
Property TestNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="BTQCCompareTaskDefaultData">
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
<Value>Sequence</Value>
</Value>
<Value name="6">
<Value>Active</Value>
</Value>
<Value name="7">
<Value>TestNum</Value>
</Value>
</Data>
<DataLocation>^dbo.BTQCCompareTaskD</DataLocation>
<DefaultData>BTQCCompareTaskDefaultData</DefaultData>
<IdLocation>^dbo.BTQCCompareTaskD</IdLocation>
<IndexLocation>^dbo.BTQCCompareTaskI</IndexLocation>
<StreamLocation>^dbo.BTQCCompareTaskS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
