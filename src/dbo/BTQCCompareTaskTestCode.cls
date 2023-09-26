/// 仪器比对计划项目
Class dbo.BTQCCompareTaskTestCode Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTQC_CompareTaskTestCode ]
{

/// Foreign Key FKBTQCCompareTaskTestCodeQCCompareTaskDR created via DDL
ForeignKey FKBTQCCompareTaskTestCodeQCCompareTaskDR(CompareTaskDR) References dbo.BTQCCompareTask(PKBTQCCOMPARETASK) [ SqlName = FK_BTQCCompareTaskTestCodeQCCompareTaskDR ];

/// Foreign Key FKBTQCCompareTaskTestCodeTestCodeDR created via DDL
ForeignKey FKBTQCCompareTaskTestCodeTestCodeDR(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_BTQCCompareTaskTestCodeTestCodeDR ];

/// DDL Primary Key Specification
Index PKBTQCCOMPARETASKTESTCODE On RowID [ PrimaryKey, SqlName = PK_BTQC_COMPARETASKTESTCODE, Type = index, Unique ];

Index IndexMaster On (CompareTaskDR, TestCodeDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSequence On (CompareTaskDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

/// 主键
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 对比计划
Property CompareTaskDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 项目
Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 靶机对比偏差标准
Property TarCV As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 5 ];

/// 自身对比偏差标准
Property SelfCV As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 6 ];

/// 序号
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BTQCCompareTaskTestCodeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CompareTaskDR</Value>
</Value>
<Value name="3">
<Value>TestCodeDR</Value>
</Value>
<Value name="4">
<Value>TarCV</Value>
</Value>
<Value name="5">
<Value>SelfCV</Value>
</Value>
<Value name="6">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^dbo.BTQCCompareTaskTestCodeD</DataLocation>
<DefaultData>BTQCCompareTaskTestCodeDefaultData</DefaultData>
<IdLocation>^dbo.BTQCCompareTaskTestCodeD</IdLocation>
<IndexLocation>^dbo.BTQCCompareTaskTestCodeI</IndexLocation>
<StreamLocation>^dbo.BTQCCompareTaskTestCodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
